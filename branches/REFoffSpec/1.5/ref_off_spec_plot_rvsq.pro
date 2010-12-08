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

pro ref_off_spec_plot_rvsq, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

TYPE = 'IvsQ'
;TYPE = 'IvsLambda'

;path='/SNS/users/rwd/results/5387'
path = (*global).ascii_path

title='Select Output Directory'
ytitle = "Reflectivity"

IF (TYPE EQ 'IvsQ') THEN BEGIN
  WindowTitle = 'R vs Q'
  filter='*IvsQ.txt'
  xtitle = "Q(A!E-1!N)"
ENDIF ELSE BEGIN
  WindowTitle='R vs Lambda Perp'
  filter='*IvsLambda.txt'
  xtitle = "lambda perp(A)"
ENDELSE

datafile = PICKFILE(PATH=path,FILTER=filter,TITLE=title)
;    path = (*global).ascii_path
    message = '> Reflectivity vs Q plot: ' + datafile   
    PlotUtility_addLogBookText, Event,  message 

IF (datafile NE  "") THEN BEGIN
; IF datafile EXISTS THEN PROCEED TO MAKE PLOT 

  ; remove /SNS/USERS/UID/ from filename in title
  strlen = STRLEN(datafile)
  plottitle = STRMID(datafile,15,strlen)

  ymin = 1.e-6
  ymax = 1.2
;for debug:
;print, "Reading file: ", datafile

; type of plot - linear = 1 or linear = 0 for log plot
  linear = 0 


  line = STRARR(1)
  lambda = FLTARR(2000)
  intensity = FLTARR(2000)
  ALOG10intensity = FLTARR(2000)
  error = FLTARR(2000)
  for j=0,1999,1 do begin
    lambda[j]=0.
    intensity[j]=0.
    ALOG10intensity[j]=ALOG10(ymin)
    error[j]=0.
  endfor

  unit = 1
  openr, unit, datafile

; skip header - the first 4 lines
  FOR i=0,3,1 DO BEGIN
    readf, unit, line
  ENDFOR

  j = 0

  WHILE NOT EOF(unit) do begin
      readf, unit, line
      values = double(STRSPLIT(line, ' ',/extract))
      lambda[j] = values[0]
      intensity[j] = values[1]
      if (intensity[j] LE 0.) then intensity[j] = ymin 
      ALOG10intensity[j] = ALOG10(intensity[j])
      j = j + 1
  ENDWHILE

  xrange = [lambda[0],lambda[j-1]]

  SET_PLOT, 'Z'
  DEVICE, DECOMPOSED=0 
; GO BACK AND FIX THIS - NEED TO BE ABLE TO CONTROL COLORS
;  LOADCT, 0, /SILENT
; 
; Change code (RC Ward 24 Nov 2010): Pass color_table value for LOADCT from XML configuration file
;  color_table = (*global).color_table
;  LOADCT, color_table, /SILENT
  
; Code change (RC Ward, 24 Nov 2010): Get Background color from XML file
;  PlotBackground = (*global).BackgroundCurvePlot
;  background = FSC_COLOR(PlotBackground)

; Code Change (RC Ward, 24 Nov 2010): Color of data curves using ref_plot_data_color from XML configuration file, was set to 50.
; THIS DOES NOT WORK - WHY?
;  ref_plot_data_color = (*global).ref_plot_data_color  
;  color = FSC_COLOR(ref_plot_data_color)

; linear plot
  IF (linear EQ 1) THEN BEGIN
    yrange = [0.,ymax]
  
    PLOT, lambda, intensity, XRANGE=xrange, YRANGE=yrange, TITLE=plottitle, $
      XTITLE=xtitle, YTITLE=ytitle, BACKGROUND=convert_rgb([255B,250B,205B]), $
      COLOR=convert_rgb([0B,0B,255B]), THICK = 1, CHARSIZE = 1, PSYM = 1, SYMSIZE = 0.5
  ENDIF

; log plot
  IF (linear EQ 0) THEN BEGIN
    yrange = [ALOG10(ymin),ALOG10(ymax)] 

    PLOT, lambda, ALOG10intensity, XRANGE=xrange, YRANGE=yrange, TITLE=plottitle, $,
      XTITLE=xtitle, YTITLE=ytitle, BACKGROUND=convert_rgb([255B,250B,205B]), $
      COLOR=convert_rgb([0B,0B,255B]), THICK = 1, CHARSIZE = 1, PSYM = 1, SYMSIZE = 0.5
  ENDIF

  IMAGE=TVRD()
  SET_PLOT, 'X' 
;
; keep increasing window number by 1 from initial value of 0
  window_counter = (*global).window_counter
  WINDOW,window_counter,TITLE=WindowTitle,XSIZE=640,YSIZE=480, RETAIN = 2
  window_counter = window_counter + 1
; update window number by 1
  (*global).window_counter = window_counter

  TV,IMAGE
  close, unit 

ENDIF
END

