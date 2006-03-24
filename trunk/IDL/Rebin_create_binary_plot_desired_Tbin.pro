; ##################################################################################
; ###################### API for IDL (event Data) ##################################
; ##################################################################################

; Non Interactive Part
file_name = "DAS_3_neutron_event.dat"
file = "c:\Documents and Settings\j35\Desktop\HistoTool\DAS_event_1\DAS_3\" + file_name

;; ******* Pickup Dialog Box **************
; file = dialog_pickfile(/must_exist, $
; title = 'Select a binary file', $
; filter = ['*.dat'], $
; path = 'c:\Documents and Settings\j35\Desktop\HistoTool\DAS_3\DAS_event_1\', $
; get_path = Path)
; ****************************************

; to get only the last part of the name
file_list = strsplit(file,'\',/extract, count=length)
file_name = file_list[length-1]

openr,1,file
fs=fstat(1)
N=fs.size   ; length of the file in bytes

Nbytes = 4  ; data are Uint32 = 4 bytes
N = fs.size/Nbytes
data = lonarr(N)    ; create a longword integer array of N elements
readu,1,data
close,1

; ##Information from xxx_runnumber_runinfo.xml###
Nx = 256L
Ny = 304L
Nt = 167L
read, time_bin_width, prompt='Enter time bin width desired (us):'
; ###############################################

;new size of data_histo
new_Nt = floor((167*100)/time_bin_width)

data_histo = lonarr(new_Nt,Nx*Ny)

for i=0L,((N/2-1)) do begin
    pixelId = data(2*i+1)
    time_stamp_index = floor((data(2*i)/1000L)/time_bin_width)
    data_histo[time_stamp_index, pixelId]=data_histo[time_stamp_index,pixelId]+1
endfor

indx = where(data_histo GT 0, Ngt0)
img = intarr(new_Nt,Nx,Ny)

img(indx) = data_histo(indx)
simg = total(img,1)

; graphical part
xtitle = "pixel X"
ytitle = "pixel Y"
title = strtrim(uint(new_Nt),1) + " time bins"
window,1,xsize=450,ysize=450

; *********color************
do_color = 1
if do_color EQ 1 then begin
    ; Decomposed=0 causes the least-significant 8 bits of the color index value
    ; to be interpreted as a PseudoColor index
    DEVICE, DECOMPOSED = 0

    ; pick your favorite color table ... see xloadct
    loadct,5
endif

;******end of color part****
xoff=100
yoff=80
Nx=256
Ny=304

tvscl, simg, xoff, yoff, /device,xsize=Nx,ysize=Ny     ;plot data

plot,[0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx], yrange=[0,Ny],ystyle=1,$
xstyle=1,pos=[xoff,yoff,xoff+Nx,yoff+Ny],$
/noerase,xtitle=xtitle, ytitle=ytitle,title=title, charsize=1.4,$
charthick=1.6
wshow

; ***** Create histogram binary output file *****

; Non Interactive Part
file_name = "DAS_3_neutron_histo.dat"
file = "c:\Documents and Settings\j35\Desktop\HistoTool\DAS_event_1\DAS_3\" + file_name

openw,3,file
writeu,3,data_histo
close,3

; to get only the last part of the name
file_list = strsplit(file,'\',/extract, count=length)
file_name = file_list[length-1]

openr,1,file
fs = fstat(1)
N=fs.size        ;size of file

Nbytes = 4       ;data are Uint32 = 4 bytes
N = fs.size/Nbytes
data = lonarr(N)
readu,1,data
close,1                     ;close file

;#########################################################
Nx = 256       ;information from xxx_runnumber_runinfo.xml
Ny = 304
Nt = new_Nt
;#########################################################

read, Tbin_wanted, prompt='Which time bin do you want to see (0-'+string(Nt)+'):'
;Tbin_wanted = 1

;find the non-null elements
indx1 = where(data GT 0, Ngt0)
img = intarr(Nt,Nx,Ny)
img(indx1) = data(indx1)

new_img = intarr(1,Nx,Ny)

new_img(0,*,*)=img(Tbin_wanted,*,*)
new_img = total(new_img,1)

;format of graph
xtitle="pixel x"
ytitle="pixel y"
title= "Plot of Tbin # " + strtrim(uint(Tbin_wanted),1)

window,1,xsize=450,ysize=450,xpos=650,ypos=250

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
Nx=256
Ny=304

tvscl, new_img, xoff, yoff, /device,xsize=Nx,ysize=Ny     ;plot data

plot,[0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx], yrange=[0,Ny],ystyle=1,$
xstyle=1,pos=[xoff,yoff,xoff+Nx,yoff+Ny],$
/noerase,xtitle=xtitle, ytitle=ytitle,title=title, charsize=1.4,$
charthick=1.6
wshow

end