transpose_ok = 1

;****************************************************************
;******** HISTOGRAMMING API FOR IDL *****************************
;******** version with axis on the plot  ************************
;****************************************************************

;open file and check sizel
;file = "~/nexus/applications/NXtranslate/" + file_name

;**** pickup dialog box******************************************
 file = dialog_pickfile(/must_exist, $
 title='Select a binary file', $
 filter = ['*.dat'],$
 path='/SNSlocal/tmp/',$
 get_path = path)
;****************************************************************

openr,1,file
fs = fstat(1)
N=fs.size        ;size of file

Nbytes = 4       ;data are Uint32 = 4 bytes
N = fs.size/Nbytes
data = lonarr(N)
readu,1,data
;data = swap_endian(data)    ;swap endian because PC -> Mac
close,1			    ;close file

;################################
Nx=64L
Ny=144L
Nt=1
;#################################

;find the non-null elements
indx1 = where(data GT 0, Ngt0)
img = intarr(Nt,Nx,Ny)

img(indx1) = data(indx1)
simg = total(img,1)     ;sum over time bins

bottom_bank = simg(0:63, 0:63)
top_bank = simg(0:63, 64:127)
diffraction_bank = simg(0:63, 127:143)  ;useless because no data

;transpose or not
if transpose_ok EQ 1 then begin
	bottom_bank=transpose(bottom_bank)
	top_bank=transpose(top_bank)
;	diffraction_bank=transpose(diffraction_bank)
endif

;format of graph
xtitle="pixels"
ytitle="tubes"

if transpose_ok EQ 1 then begin
	xtitle = "tubes"
	ytitle = "pixels"
endif

title=file

;window,1,xsize=1000,ysize=600,xpos=150,ypos=250

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

;xoff=70
;yoff=70
;
;New_Nx = 13*Nx
;New_Ny = 4*Ny
;
;tvimg = congrid(simg,New_Nx,New_Ny,/interp) ;**** re-grid data to New_Nx by New_Ny - SDM
;
;if transpose_ok EQ 0 then begin
;	tvscl, tvimg, xoff, yoff, /device,xsize=Nx,ysize=Ny     ;plot data
;endif else begin
;	tvscl, tvimg, xoff, yoff, /device, xsize=Ny, ysize=Nx	;plot data in transpose mode
;endelse
;
;;tvscl,simg,xoff,yoff,/device,xsize=Nx,ysize=Ny              ;plot data
;
;;******pretty plot********************************
;
;if transpose_ok EQ 0 then begin
;	plot,[0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx],yrange=[0,Ny],ystyle=1,xstyle=1, $
;	   pos=[xoff,yoff,xoff+New_Nx, yoff+New_Ny],$
;	  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
;	  charthick=1.6
;endif else begin
;	plot,[0,Ny],[0,Nx],/nodata,/device,xrange=[0,Ny],yrange=[0,Nx],ystyle=1,xstyle=1, $
;	   pos=[xoff,yoff,xoff+New_Nx, yoff+New_Ny],$
;	  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
;	  charthick=1.6
;endelse
;wshow

;if transpose_ok EQ 1 then begin

;********************
;plot of second part
;********************

window,2,xsize=900,ysize=830,xpos=250,ypos=120
title = file

;plot of top_bank
xoff=50
yoff=450

Nx=64L
Ny=64L

New_Nx = 13*Nx
New_Ny = 5*Ny

tvimg = congrid(top_bank,New_Nx,New_Ny,/interp) ;**** re-grid data to Nx by Ny - SDM

if transpose_ok EQ 0 then begin
	tvimg = congrid(top_bank,New_Nx,New_Ny,/interp) ;**** re-grid data to Nx by Ny - SDM
	tvscl, tvimg, xoff, yoff, /device,xsize=Nx,ysize=Ny     ;plot data
endif else begin
	tvimg = congrid(top_bank,New_Nx,New_Ny,/interp) ;**** re-grid data to Nx by Ny - SDM
	tvscl, tvimg, xoff, yoff, /device,xsize=New_Ny,ysize=New_Nx     ;plot data
endelse

;******pretty plot********************************

if transpose_ok EQ 0 then begin
	plot,[0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx],yrange=[0,Ny],ystyle=1,xstyle=1, $
	   pos=[xoff,yoff,xoff+New_Nx, yoff+New_Ny],$
	  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
	  charthick=1.6
endif else begin
;	New_Nx=1.5*New_Nx
	plot,[0,Ny],[0,Nx],/nodata,/device,xrange=[0,Ny],yrange=[0,Nx],ystyle=1,xstyle=1, $
	   pos=[xoff,yoff,xoff+New_Nx, yoff+New_Ny],$
	  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
	  charthick=1.6
endelse

;plot of bottom_bank

xoff=50
yoff=70

Nx=64L
Ny=64L

New_Nx= 13*Nx
New_Ny=5*Ny

tvimg = congrid(bottom_bank,New_Nx,New_Ny,/interp) ;**** re-grid data to Nx by Ny - SDM

if transpose_ok EQ 0 then begin
	tvimg = congrid(bottom_bank,New_Nx,New_Ny,/interp) ;**** re-grid data to Nx by Ny - SDM
	tvscl, tvimg, xoff, yoff, /device,xsize=Nx,ysize=Ny     ;plot data
endif else begin
	tvimg = congrid(bottom_bank,New_Nx,New_Ny,/interp) ;**** re-grid data to Nx by Ny - SDM
	tvscl, tvimg, xoff, yoff, /device,xsize=Ny,ysize=Nx     ;plot data
endelse

;******pretty plot********************************

if transpose_ok EQ 0 then begin
	plot,[0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx],yrange=[0,Ny],ystyle=1,xstyle=1, $
	   pos=[xoff,yoff,xoff+New_Nx, yoff+New_Ny],$
	  /noerase,xtitle=xtitle,ytitle=ytitle,charsize=1.4,$
	  charthick=1.6
endif else begin
;	New_Nx=1.5*New_Nx
	plot,[0,Ny],[0,Nx],/nodata,/device,xrange=[0,Ny],yrange=[0,Nx],ystyle=1,xstyle=1, $
	   pos=[xoff,yoff,xoff+New_Nx, yoff+New_Ny],$
	  /noerase,xtitle=xtitle,ytitle=ytitle,charsize=1.4,$
	  charthick=1.6
endelse
wshow

;endif

end
