;      				   HH  HH   II    SSSSS  TTTTT   OOO
;			          HH  HH   II   SSS       T    OO OO
; 			         HH  HH   II   SSS       T    OO OO
; 			        HHHHHH   II      SSS    T    OO OO 
;    			       HH  HH   II      SSS    T    OO OO
;  			      HH  HH   II   SSSSS     T     OOO

; This program allows to plot the mapped histogram preNeXus binary files
; mapping file = DAS version 
	
		;############################################################
		; 			INTERFACE                           #  		       
		;___________________________________________________________#
		Nx = 128        ; Number of pixelIDs per tube               |
		Ny = 72         ; Number of tubes per tube                  |
		Nt = 1          ; Number of time bins                       |
		swap_endian = 0 ; swap_endian 0=NO, 1=YES                   |
		path='/Users/j35/CD4/DAS/2006_1_7_SCI/BSS_22/' ;default path|
		do_color = 1    ; If you want graph in color 0=NO, 1=YES    |
		;___________________________________________________________|
		;############################################################
		;for questions, contact Jean Bilheux at bilheuxjm@ornl.gov



;<code>

Nx=long(Nx)
Ny=long(Ny)
Nt=long(Nt)

;**** pickup dialog box******************************************
 file = dialog_pickfile(/must_exist, $
 title='Select a binary file', $
 filter = ['*.dat'],$
 path=path,$
 get_path = path)
;****************************************************************

openr,1,file
fs = fstat(1)
N=fs.size        ;size of file

Nbytes = 4       ;data are Uint32 = 4 bytes
N = fs.size/Nbytes
data = lonarr(N)
readu,1,data
data = swap_endian(data)    ;swap endian because PC -> Mac
close,1			    ;close file

;find the non-null elements
indx1 = where(data GT 0, Ngt0)
img = intarr(Nt,Nx,Ny)

img(indx1) = data(indx1)
simg = total(img,1)     ;sum over time bins

simg=transpose(simg)

;format of graph
xtitle="tubes"
ytitle="pixels"

title=title
window,1,xsize=850,ysize=530,xpos=150,ypos=250

if do_color EQ 1 then begin

	;Decomposed=0 causes the least-significant 8 bits of the color index value
	;to be interpreted as a PseudoColor index.
	DEVICE, DECOMPOSED = 0

	;pick your favorite color table...see xloadct
	loadct,5

endif

;*********end of color part***********************

xoff=60
yoff=60

New_Nx = 6*Nx
New_Ny = 6*Ny

tvimg = congrid(simg,New_Nx,New_Ny,/interp) ;**** re-grid data to New_Nx by New_Ny - SDM

tvscl, tvimg, xoff, yoff, /device, xsize=Ny, ysize=Nx	;plot data in transpose mode

;******pretty plot********************************

plot,[0,Ny],[0,Nx],/nodata,/device,xrange=[0,Ny],yrange=[0,Nx],ystyle=1,xstyle=1, $
   pos=[xoff,yoff,xoff+New_Nx, yoff+New_Ny],$
  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
  charthick=1.6

wshow

end
