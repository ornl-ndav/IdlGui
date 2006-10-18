transpose_ok = 1

;****************************************************************
;******** HISTOGRAMMING API FOR IDL *****************************
;******** version with axis on the plot  ************************
;****************************************************************

;############################################
; file_name="output_array_binary.dat"      ;Interactive part
;############################################

;open file and check size
;file = "~/nexus/applications/NXtranslate/" + file_name

;**** pickup dialog box******************************************
;  file = dialog_pickfile(/must_exist, $
;  title='Select a binary file', $
;  filter = ['*.dat'],$
;  path='/Users/j35/CD4/BSS/2006_1_2_SCI/BSS_22/',$
;  get_path = path)
;****************************************************************

file = '~/CD4/BSS/BSS_37_neutron_histo.dat'

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
Nx=128L
Ny=72
;Ny=56L
;Nx = 64L  	;information from xxx_runnumber_runinfo.xml
;Ny = long(N/64)
Nt = 1
;#################################

;find the non-null elements
indx1 = where(data GT 0, Ngt0)
img = intarr(Nt,Nx,Ny)

img(indx1) = data(indx1)
simg = total(img,1)     ;sum over time bins

;transpose or not
if transpose_ok EQ 1 then simg=transpose(simg)


simg_up = intarr(64,64)
simg_down = intarr (64,64)

;format of graph
xtitle="pixels"
ytitle="tubes"

if transpose_ok EQ 1 then begin
	xtitle = "tubes"
	ytitle = "pixels"
endif

title="After mapping"
window,1,xsize=1000,ysize=600,xpos=350,ypos=150

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


xoff=70
yoff=70

New_Nx = 4*Nx
New_Ny = 4*Ny

tvimg = congrid(simg,New_Nx,New_Ny,/interp) ;**** re-grid data to New_Nx by New_Ny - SDM

if transpose_ok EQ 0 then begin
	tvscl, tvimg, xoff, yoff, /device,xsize=Nx,ysize=Ny     ;plot data
endif else begin
	tvscl, tvimg, xoff, yoff, /device, xsize=Ny, ysize=Nx	;plot data in transpose mode
endelse

;tvscl,simg,xoff,yoff,/device,xsize=Nx,ysize=Ny              ;plot data

;******pretty plot********************************

if transpose_ok EQ 0 then begin
	plot,[0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx],yrange=[0,Ny],ystyle=1,xstyle=1, $
	   pos=[xoff,yoff,xoff+New_Nx, yoff+New_Ny],$
	  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
	  charthick=1.6
endif else begin
	plot,[0,Ny],[0,Nx],/nodata,/device,xrange=[0,Ny],yrange=[0,Nx],ystyle=1,xstyle=1, $
	   pos=[xoff,yoff,xoff+New_Nx, yoff+New_Ny],$
	  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
	  charthick=1.6
endelse
wshow




end
