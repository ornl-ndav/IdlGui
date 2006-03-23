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
; ###############################################

data_histo = lonarr(Nt,Nx*Ny)

for i=0L,((N/2-1)) do begin
    pixelId = data(2*i+1)
    time_stamp_index = floor((data(2*i)/1000L)/100)
    data_histo[time_stamp_index, pixelId]=data_histo[time_stamp_index,pixelId]+1
endfor

indx = where(data_histo GT 0, Ngt0)
img = intarr(Nt,Nx,Ny)

img(indx) = data_histo(indx)
simg = total(img,1)

; graphical part
xtitle = "pixel X"
ytitle = "pixel Y"
title = "Event data (1 big time bin)"
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



end