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

; ************************************************************
; *** let's open and read the data from the other binary file*
; ************************************************************
file1 = "C:\Documents and Settings\j35\Desktop\HistoTool\DAS_event_1\DAS_3\DAS_3_neutron_event_pulseid.dat"
; ******* Pickup Dialog Box **************
; file1 = dialog_pickfile(/must_exist, $
; title = 'Select a binary file', $
; filter = ['*.dat'], $
; path = 'c:\Documents and Settings\j35\Desktop\HistoTool\DAS_event_1\', $
; get_path = Path)
; ****************************************

openr,2,file1
fs1=fstat(2)
N1=fs1.size     ; size of file
Nbytes = 8      ; data are Uint64 = 8 bytes
N1=fs1.size/Nbytes
data1=lon64arr(N1)  ; create a 8bytes array
readu,2,data1
;data1=swap_endian(data1)   ;only for mac
close,2

; pulse_id we want
read, pulse_id_number, prompt='Enter pulse id of interest:'

offset_start = data1[2*pulse_id_number + 1]
offset_end = data1[2*pulse_id_number + 3]

big_array=lonarr(256,304)     ; big_array(x,y)

; *** Regroup only the positionID of the offset of interest and plot it ***
for i = offset_start, offset_end do begin
    big_array[data[2*i+1]] = big_array[data[2*i+1]]+1
endfor

; ******************************************************************
; **** Regroup all the positionID into a same array and plot it ****
; ******************************************************************

;for i=0L,((N/2-1)) do begin
;    big_array[data[2*i+1]] = big_array[data[2*i+1]]+1
;endfor

; graphical part
xtitle = "pixel X"
ytitle = "pixel Y"
title = "Event data (time bin #" + string(time_bin_number) + ")"

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

tvscl, big_array, xoff, yoff, /device,xsize=Nx,ysize=Ny     ;plot data

plot,[0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx], yrange=[0,Ny],ystyle=1,$
xstyle=1,pos=[xoff,yoff,xoff+Nx,yoff+Ny],$
/noerase,xtitle=xtitle, ytitle=ytitle,title=title, charsize=1.4,$
charthick=1.6
wshow

end
