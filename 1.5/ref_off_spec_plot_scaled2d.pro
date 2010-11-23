pro ref_off_spec_plot_scaled2d, Event
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
WINDOW, window_counter, TITLE=title,XSIZE=900,YSIZE=480
window_counter = window_counter + 1
; update window number by 1
(*global).window_counter = window_counter

print, TITLE

lines = LONG(FILE_LINES(datafile))
print, "Reading file: ",datafile
print, lines
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
print, "z_min: ", z_min," z_max: ", z_max
;printf, outunit, i, j, lambda[i,j], intensity[i,j]

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
;      printf, outunit, i, j, lambda[i], intensity[i,j]
      i = i + 1
    ENDELSE
  ENDIF
ENDFOR

IMAX = i-1
x_min = lambda[0]
delta_x = lambda[1]
;print, "IMAX: ",IMAX
print, "delta-x: ",delta_x
;x_max = lambda[IMAX]
print, "x_min: ", x_min, " x_max: ", x_max
y_min = 0
print, "y_min: ", y_min, " y_max: ", y_max

FOR i = 0, IMAX DO BEGIN
    FOR j = 0, y_max DO BEGIN
        newarray[i,j] = intensity[i,j]
;        print, i, j, newarray[i,j]
    ENDFOR
ENDFOR

; select color table, 13 is RAINBOW
LOADCT, 13, /SILENT
DEVICE, DECOMPOSED=0

; now plot the rebinned 2D intensity array = newarray
TVSCL, newarray, X0, Y0, /DEVICE

; plot the axes and labels
; need a dummy function to plot (not shown)
     X = [0,1,2,3,4,5,6,7,8,9,10]
     Y = [0,1,2,3,4,5,6,7,8,9,10]
; set up mapping to the device coordinates [X0,Y0,X1,Y1] 
;x_max = 700
X1 = x_max + X0 
Y1 = y_max + Y0 
print, "[X0,Y0,X1,Y1]: ", X0," "," ",Y0," ",X1," ",Y1 
; remove /SNS/USERS/UID/ from filename in title
strlen = STRLEN(datafile)
plottitle = STRMID(datafile,15,strlen)

PLOT,  X, Y, $
    TITLE = plottitle, $
    XTITLE = 'Lambda Perp (A)', $
    YTITLE = 'Pixel', $
    YRANGE = [y_min,y_max],$
    XRANGE = [0, delta_x * x_max], $
    COLOR = convert_rgb([124B,124B,124B]), $
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

; draw colorbar
perso_format = '(e8.1)'
range  = FLOAT([z_min,z_max])

  IF (bLogPlot) THEN BEGIN
    divisions = 10
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = [0.94,0.15,0.96,0.85], $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      YLOG = 1,$
      /VERTICAL
  ENDIF ELSE BEGIN
    divisions = 20
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = [0.94,0.15,0.96,0.85], $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      /VERTICAL
  ENDELSE
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

close, unit 

ENDIF

end
