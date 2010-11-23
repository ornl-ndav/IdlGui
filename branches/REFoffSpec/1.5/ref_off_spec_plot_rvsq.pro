pro ref_off_spec_plot_rvsq, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global

TYPE = 'IvsQ'
;TYPE = 'IvsLambda'
;path='/SNS/users/rwd/results/5387'
path = (*global).ascii_path
title='Select Output Directory'
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

IF (datafile NE  "") THEN BEGIN
; IF datafile EXISTS THEN PROCEED TO MAKE PLOT 

; remove /SNS/USERS/UID/ from filename in title
strlen = STRLEN(datafile)
plottitle = STRMID(datafile,15,strlen)

ymin = 1.e-6
ymax = 1.2

print, "Reading file: ", datafile

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
j =0
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
; select color table, 13 is RAINBOW
LOADCT, 0, /SILENT
DEVICE, DECOMPOSED=0

; linear plot
if (linear EQ 1) THEN BEGIN
  ytitle = "Reflectivity"
  yrange = [0.,1.2]

  PLOT, lambda, intensity, XRANGE=xrange, YRANGE=yrange, TITLE=plottitle, XTITLE=xtitle, YTITLE=ytitle, BACKGROUND=255, COLOR=0, THICK = 2, CHARSIZE = 1, PSYM = 1, SYMSIZE = 1 
ENDIF
; log plot
IF (linear EQ 0) THEN BEGIN
  ; log-linear plot
  ytitle = "Reflectivity"
  yrange = [ALOG10(ymin),ALOG10(ymax)]

  PLOT, lambda, ALOG10intensity, XRANGE=xrange, YRANGE=yrange, TITLE=plottitle, XTITLE=xtitle, YTITLE=ytitle, BACKGROUND=255, COLOR=0, THICK = 2, CHARSIZE = 1, PSYM = 1, SYMSIZE = 1
ENDIF
IMAGE=TVRD()
SET_PLOT, 'X' 
;
; keep increasing window number by 1 from initial value of 0
window_counter = (*global).window_counter
WINDOW,window_counter,TITLE=WindowTitle,XSIZE=640,YSIZE=480
window_counter = window_counter + 1
; update window number by 1
(*global).window_counter = window_counter

TV,IMAGE
close, unit 

ENDIF
end
