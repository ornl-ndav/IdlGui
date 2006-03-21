;****************************************************************
;************** API FOR IDL (event data) ************************
;****************************************************************

; Non Interactive part
file_name = "DAS_15_neutron_event.dat"

;open file and check size
file = "/Users/j35/pre-NeXus/" + file_name      

;****** Pickup Dialog Box **************************************
; file = dialog_pickfile(/must_exist, $
; title = 'Select a binary file', $
; filter = ['*.dat'],$
; path = '/Users/j35/pre-NeXus/',$
; get_path = Path)
;***************************************************************

;to get only the last part of the name
file_list = strsplit(file,'/',/extract,count=length)
file_name = file_list[length-1]

openr,1,file
fs = fstat(1)
N=fs.size        ;length of the file in bytes

Nbytes = 4       ;data are Uint32 = 4 bytes
N = fs.size/Nbytes
data = lonarr(N)     ;create an longword integer array of N elements
readu,1,data
data = swap_endian(data)    ;swap endian because PC(littleEndian) -> Mac(bigEndian)
close,1	

;***************************************************************************
;**let's open and read the data from the other binary file
;***************************************************************************
;file1 = "/Users/j35/Documents/pre-NeXus/DAS_3/DAS_3_neutron_event_pulseid.dat"
;openr,2,file1
;fs1=fstat(2)
;N1=fs1.size      ;size of file
;Nbytes = 8	;data are uint64 = 8 bytes
;N1=fs1.size/Nbytes
;data1=lon64arr(N1)   ;create a 8bytes array
;readu,2,data1
;data1=swap_endian(data1)
;close,2

;*************************************************
;******* regroup all the positionID into *********
;******* a same array and plot it        *********
;*************************************************

big_array=lonarr(256,304)    ;big_array(y,x)
for i=0L,((N/2)-1) do begin
big_array[data[2*i+1]]=big_array[data[2*i+1]]+1
endfor

;graphical part
xtitle="pixel y"
ytitle="pixel x"
title="Event data (1 big time bin)"
window,1,xsize=400,ysize=400

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
Nx=256
Ny=304

tvscl,big_array,xoff,yoff,/device,xsize=Nx,ysize=Ny              ;plot data

plot,[0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx],yrange=[0,Ny],ystyle=1,xstyle=1, $
   pos=[xoff,yoff,xoff+Nx, yoff+Ny],$
  /noerase,xtitle=xtitle,ytitle=ytitle,title=title,charsize=1.4,$
  charthick=1.6
wshow

end
