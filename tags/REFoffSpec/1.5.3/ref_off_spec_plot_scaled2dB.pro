;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : rwd (wardrc1@ornl.gov)
;
;==============================================================================

pro ref_off_spec_plot_scaled2dB, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global

x_max = 700
y_max = 303

; set device location for origin 
X0 = 60
Y0 = 60

; select log (1) or linear (0) file
bLogPlot = 1 

line = STRARR(1)
lambda = FLTARR(10000,10000)
intensity = FLTARR(10000,10000)
error = FLTARR(10000,10000)
newarray = FLTARR(10000,y_max+1)
unit = 1
; user selecst output directory and Scaled2D datafile
;  path='/SNS/users/rwd/results/5387'
  path = (*global).ascii_path
  filter='*Scaled2D.txt'
  title='Select Output Directory'
  datafile = PICKFILE(PATH=path,FILTER=filter,TITLE=title)

IF (datafile NE  "") THEN BEGIN
; IF datafile EXISTS THEN PROCEED TO MAKE PLOT 

title = 'Scaled 2D Plot'
; keep increasing window number by 1 from initial value of 0
window_counter = (*global).window_counter
WINDOW, window_counter, TITLE=title,XSIZE=900,YSIZE=480, RETAIN = 2
window_counter = window_counter + 1
; update window number by 1
(*global).window_counter = window_counter

;for debug:
;print, TITLE

lines = LONG(FILE_LINES(datafile))
;for debug:
;print, "Reading file: ",datafile
;print, lines

openr, unit, datafile
form='(e12.6,e12.6)'

z_min = 10000D
z_max = 0.0000000001D 
 
;outfile = 'output.txt'
;openw, outunit, outfile

i = 0
j = 0
l = 0l
; get minimum and maximum z values
FOR l = 1l,lines,1l DO BEGIN
   readf, unit, line
;   print, "line: ",line
   test1 = STRMID(line, 0, 1)
   test2 = STRMID(line, 0, 2)
; skip eveything if a blank line (line of no length) 
; if line has # also skip, unles #L, when increment j and rezero i 
  IF(STRLEN(line) NE 0) THEN BEGIN
; if line has # also skip, unless #L, when increment j and rezero i 
    IF( test1 EQ '#') THEN BEGIN
       IF( test2 EQ '#L') THEN BEGIN
         i = 0
         j = j + 1
       END
    ENDIF ELSE BEGIN
        values = double(STRSPLIT(line, ' ',/extract))
;   print, "line: values[1]: ", l," ",values[1]
        IF (values[1] GT z_max) THEN BEGIN
                z_max = values[1]
;           print,"i,j values[1], z_max: ", i," ", j," ",values[1]," ",z_max
        ENDIF
       IF (values[1] NE 0.) THEN BEGIN
        IF (values[1] LT z_min) THEN BEGIN
                z_min = values[1]
;           print,"i,j values[1], z_min: ", i," ", j," ",values[1]," ",z_min
        ENDIF
       ENDIF
        i = i + 1
    ENDELSE
  ENDIF
ENDFOR
close, unit

IF (bLogPlot EQ 0) THEN BEGIN
   z_min = 0.
ENDIF
;for debug:
;print, "z_min: ", z_min," z_max: ", z_max

openr, unit, datafile

; set all values of arrays to min value: for linear:0 for log:alog10(z_min) 
if (bLogPlot EQ 1) then begin
  intensity[*,*] = ALOG10(z_min)
endif else begin
  intensity[*,*] = 0.
endelse

i = 0
j = 0 
l = 0l
FOR l = 1l,lines,1l DO BEGIN
   readf, unit, line
;for debug:
;   print, "line: ",line
   test1 = STRMID(line, 0, 1)
   test2 = STRMID(line, 0, 2) 
; skip eveything if a blank line (line of no length) 
; if line has # also skip, unles #L, when increment j and rezero i 
  IF(STRLEN(line) NE 0) THEN BEGIN
; if line has # also skip, unless #L, when increment j and rezero i 
    IF( test1 EQ '#') THEN BEGIN 
       IF( test2 EQ '#L') THEN BEGIN
         i = 0
         j = j + 1
       END
    ENDIF ELSE BEGIN
        values = double(STRSPLIT(line, ' ',/extract))
; lambda values all the same for each j, so make this a single dimension array
        lambda[i] = values[0]
      IF(bLogPlot) THEN BEGIN
        IF(values[1] EQ 0.) THEN values[1] = z_min
        intensity[i,j] = ALOG10(values[1])
      ENDIF ELSE BEGIN
        IF(values[1] EQ 0.) THEN values[1] = 0. 
        intensity[i,j] = values[1]
      ENDELSE
      i = i + 1
    ENDELSE
  ENDIF
ENDFOR

IMAX = i-1
x_min = lambda[0]
delta_x = lambda[1]
y_min = 0

;for debug:
;print, "IMAX: ",IMAX
;print, "delta-x: ",delta_x
;print, "x_min: ", x_min, " x_max: ", x_max


FOR i = 0, IMAX DO BEGIN
    FOR j = 0, y_max DO BEGIN
        newarray[i,j] = intensity[i,j]
;for debug:
;        print, i, j, newarray[i,j]
    ENDFOR
ENDFOR

; Change code (RC Ward 24 Nov 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table

  LOADCT, color_table, /SILENT
  DEVICE, DECOMPOSED=0

; now plot the rebinned 2D intensity array = newarray
TVSCL, newarray, X0, Y0, /DEVICE

; draw colorbar
perso_format = '(e8.1)'
range  = FLOAT([z_min,z_max])
; For routine colorbar, COLOR is the color of the outline and the labeling
  IF (bLogPlot) THEN BEGIN
    divisions = 10
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = [0.94,0.15,0.96,0.85], $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      YLOG = 1,$
      COLOR = convert_rgb([255B,255B,255B]), $
      /VERTICAL
  ENDIF ELSE BEGIN
    divisions = 20
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = [0.94,0.15,0.96,0.85], $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      COLOR = convert_rgb([255B,255B,255B]), $
      /VERTICAL
  ENDELSE

; plot the axes and labels
; need a dummy function to plot (not shown)
     X = [0,1,2,3,4,5,6,7,8,9,10]
     Y = [0,1,2,3,4,5,6,7,8,9,10]
; set up mapping to the device coordinates [X0,Y0,X1,Y1] 
;x_max = 700
X1 = x_max + X0 
Y1 = y_max + Y0 

;for debug:
;print, "[X0,Y0,X1,Y1]: ", X0," "," ",Y0," ",X1," ",Y1 
; remove /SNS/USERS/UID/ from filename in title
strlen = STRLEN(datafile)
plottitle = STRMID(datafile,15,strlen)

  LOADCT, 0, /SILENT
PLOT,  X, Y, $
    TITLE = plottitle, $
    XTITLE = 'Lambda Perp (A)', $
    YTITLE = 'Pixel', $
    YRANGE = [y_min,y_max],$
    XRANGE = [0, delta_x * x_max], $
    COLOR = convert_rgb([255B,255B,255B]), $
    BACKGROUND = convert_rgb([0B, 0B, 0B]), $
    THICK = 1, $
    TICKLEN = -0.015, $
    XSTYLE = 1,$
    YSTYLE = 1,$
    XTICKINTERVAL = 500,$
    YTICKINTERVAL = 50,$
    POSITION = [X0,Y0,X1,Y1],$
; this should be  POSITION = [60,60,760,363]
    NOCLIP = 0,$
    /NOERASE, $
    /NODATA, $
    /DEVICE
  
;=========================================================================
;use this section of code to get pixel values from the screen for purposes 
; of scaling the image. Set G = 1 to see cursor/acutal values.
; G = 0
G = 0 
  WHILE (G GT 0) DO BEGIN
    CURSOR, X, Y, /DEVICE
; subtract off the offset
    Xcursor = X-X0
    Ycursor = Y-Y0
    print, "Cursor Position: x: ", Xcursor, " y: ", Ycursor
; now compute acutal values using delta_x * cursor position for X
    Xactual = delta_x * Xcursor
    Yactual = Ycursor  
    print, "Actual value:    x: ", Xactual," y: ",Yactual
    ;XYOUTS, X, Y, 'X Marks the Spot.', /DEVICE
    print, "  "
  ENDWHILE
;=========================================================================
close, unit 

ENDIF

end
