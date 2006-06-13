;****************************************************************
;********       Plot API FOR IDL    *****************************
; version that plot:    I(pixel_X, pixel_Y, tof)
;			I(pixelID, tof)
; 			I(tof)
;****************************************************************

;**** pickup dialog box******************************************
 file = dialog_pickfile(/must_exist, $
 title='Select a binary file', $
 filter = ['*.dat'],$`
 path = "/Users/j35/CD4/BSS/",$
 get_path = path)
;****************************************************************

; to get only the last part of the name
file_list = strsplit(file,'/',/extract, count=length)
file_name = file_list[length-1]

;file = "/Users/j35/SVN/HistoTool/trunk/IDL/DAS_505_neutron_histogram.dat"

openr,1,file
fs = fstat(1)
N=fs.size                ;size of file

Nbytes = 4               ;data are Uint32 = 4 bytes
N = fs.size/Nbytes
data = lonarr(N)
readu,1,data
if !cpu.hw_vector EQ 1 then data = swap_endian(data)    ;swap endian because PC -> Mac
close,1                  ;close file

;information from xxx_runnumber_runinfo.xml
;Nx = 128L
;Ny=64L
;Nt = N/(Nx*Ny)
;Nt=1
Nx=64
Ny=112
Nt=1

;find the non-null elements
indx1 = where(data GT 0, Ngt0)
img = lonarr(Nt,Nx,Ny)

;############################################################################################
;I(pixel_X,pixel_Y,tof) #####################################################################
;############################################################################################

img(indx1) = data(indx1)
simg = total(img,1)      ;sum over time bins

xtitle="Pixel_X"
ytitle="Pixel_Y"
title="I(Pixel_X,Pixel_Y,tof)"
window,1,xsize=450,ysize=550,xpos=50,ypos=350

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
xoff=100
yoff=80

New_Nx=Nx*4
New_Ny=Ny*4
tvimg = congrid(simg,New_Nx,New_Ny,/interp) ;**** re-grid data to Nx by Ny - SDM
tvscl, tvimg, xoff, yoff, /device,xsize=Nx,ysize=Ny     ;plot data

;tvscl, simg, xoff, yoff, /device,xsize=Nx,ysize=Ny     ;plot data

plot,[0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx], yrange=[0,Ny],ystyle=1,$
xstyle=1,pos=[xoff,yoff,xoff+New_Nx,yoff+New_Ny],$
/noerase,xtitle=xtitle, ytitle=ytitle,title=title, charsize=1.4,$
charthick=1.60
wshow

;############################################################################################
;I(tof) #####################################################################################
;############################################################################################

dataz = total(total(img,3),2)
max_y = max(dataz)
window,2,xsize=450,ysize=450,xpos=150,ypos=250
plot, dataz, title= 'I(tof)', xtitle='tof(x200us)', ytitle='Counts', xrange=[0,85],$
yrange=[0,max_y+10],xstyle=1,ystyle=1,charsize=1.4,charthick=1.6

;;############################################################################################
;;I(pixel_number,tof) ########################################################################
;;############################################################################################
;read, pixelID, prompt='Which pixelID do you want to see (0-'+strtrim((Nx*Ny-1),1)+'):'
;
;tof = lonarr(Nt)
;
;for i=0L,Nt-1 do begin
;	tof(i) = img(Nt*pixelID+i)
;endfor
;
;window,3,xsize=450,ysize=450,xpos=250,ypos=150
;
;plot, tof, title= 'PixelID # '+ strtrim(long(pixelID),1),xtitle='tof(x200us)',$
;ytitle='Counts', xrange=[0,85],xstyle=1,ystyle=1,charsize=1.4,charthick=1.6

end
