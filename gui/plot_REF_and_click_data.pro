transpose_ok = 1

;****************************************************************
;******** HISTOGRAMMING API FOR IDL *****************************
;******** version with axis on the plot  ************************
;****************************************************************

;;**** pickup dialog box******************************************
; file = dialog_pickfile(/must_exist, $
; title='Select a binary file', $
; filter = ['*.dat'],$
; path='/Users/j35/CD4/DAS/REF/',$
; get_path = path)
;;****************************************************************

file = "/Users/j35/CD4/DAS/REF/DAS_60_neutron_histo.dat"
openr,1,file
fs = fstat(1)
N=fs.size        ;size of file

Nbytes = 4       ;data are Uint32 = 4 bytes
N = fs.size/Nbytes
data = lonarr(N)
readu,1,data
data = swap_endian(data)    ;swap endian because PC -> Mac
close,1			    ;close file

;################################
Nx = 256L  	;information from xxx_runnumber_runinfo.xml
Ny = 304L
;Nt = 834L
Nt=84
;#################################

;find the non-null elements
indx1 = where(data GT 0, Ngt50)
img = lonarr(Nt,Nx,Ny)

img(indx1) = data(indx1)
simg = total(img,1)     ;sum over time bins
simg[0]=0
if transpose_ok EQ 1 then begin
	simg=transpose(simg)
endif

;format of graph
xtitle="pixel x"
ytitle="pixel y"
if transpose_ok EQ 1 then begin
	xtitle = "pixel y"
	ytitle = "pixel x"
endif
;title=file
title=""

window,1,xsize=600,ysize=400,xpos=250,ypos=250

;***************color*************

do_color = 1

if do_color EQ 1 then begin

	;Decomposed=0 causes the least-significant 8 bits of the color index value
	;to be interpreted as a PseudoColor index.
	DEVICE, DECOMPOSED = 0

	;pick your favorite color table...see xloadct
	loadct,5

endif

;*********end of color part***********************
xoff=110
yoff=90

if transpose_ok EQ 1 then begin

	tvscl,simg,xoff,yoff,/device,xsize=Ny,ysize=Nx              ;plot data

	;******pretty plot********************************

	plot,[0,Ny],[0,Nx],/nodata,/device,xrange=[0,Ny],yrange=[0,Nx],ystyle=1,xstyle=1, $
   		pos=[xoff,yoff,xoff+Ny, yoff+Nx],$
		  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
		  charthick=1.6

endif else begin

	tvscl,simg,xoff,yoff,/device,xsize=Nx,ysize=Ny              ;plot data

	;******pretty plot********************************

	plot,[0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx],yrange=[0,Ny],ystyle=1,xstyle=1, $
   		pos=[xoff,yoff,xoff+Nx, yoff+Ny],$
		  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
		  charthick=1.6

endelse

wshow

;**interactivity with graph************************

do_coords = 1

if do_coords EQ 1 then begin
;case to get the mouse click, return the (x,y) coordinates and the value
getvals = 1	;while getvals is GT 0, continue to check mouse down clicks

print,'Left click within the image to return (x,y) and f(x,y)'
print,'Right click, or click within the window, but outside the image to terminate check'

;continue to loop getting values while mouse clicks occur within the image window

x = lonarr(2)
y = lonarr(2)

for i=0,1 do begin

cursor,a,b,/down,/device

x[i] = a-xoff
y[i] = b-yoff

if transpose_ok EQ 1 then begin

	if ((x[i] LT 0) OR (x[i] GT Ny) OR (y[i] LT 0) OR (y[i] GT Nx) OR (!mouse.button EQ 4)) then begin
		getvals = 0
		print,'Terminating return data'
	endif else begin
		print, 'pixelID#:'+strcompress(y[i]*304+x[i])+'  (x['+strcompress(i,/rem)+'] = '+strcompress(y[i],/rem)+'; y['+strcompress(i,/rem)+' = '+strcompress(x[i],/rem)+'; val = '+strcompress(simg[x[i],y[i]],/rem)+')'
	endelse

endif else begin

	if ((x[i] LT 0) OR (x[i] GT Nx) OR (y[i] LT 0) OR (y[i] GT Ny) OR (!mouse.button EQ 4)) then begin
		getvals = 0
		print,'Terminating return data'
	endif else begin
		print,'x['+i+' = '+strcompress(x[i],/rem)+'  y['+i+' = '+strcompress(y[i],/rem)+'  val = '+strcompress(simg[x[i],y[i]],/rem)
	endelse

endelse

endfor

endif

r=255L  ;red max
g=0L    ;no green
b=255L  ;blue max

for i=0,1 do begin
	x[i]=x[i]+xoff
	y[i]=y[i]+yoff
endfor

plots, x[0], y[0], /device, color=800
plots, x[0], y[1], /device, /continue, color=r+(g*256L)+(b*256L^2)
plots, x[1], y[1], /device, /continue, color=r+(g*256L)+(b*256L^2)
plots, x[1], y[0], /device, /continue, color=r+(g*256L)+(b*256L^2)
plots, x[0], y[0], /device, /continue, color=r+(g*256L)+(b*256L^2)

end
