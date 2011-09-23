pro read_pulsid,plow,phigh,evid,char,filename=file

; ##################################################################################
; ###################### API for IDL (event Data) ##################################
; ##################################################################################

; INPUT 

path = "~/detectorpositions"  ;path to event file

;; uncomment this part if you want to hard define the name of the event file
;file_name = "REF_L_10000_neutron_event.dat"   ;Name of event file to read
;file = path + file_name

; ******* Pickup Dialog Box **************
if not var_defined(file) then begin
 file = dialog_pickfile(/must_exist, $
 title = 'Select a pulseID file', $
 filter = ['*.dat'], $
 path = path,$
 get_path = Path)
; ****************************************

; to get only the last part of the name
file_list = strsplit(file,'\',/extract, count=length)
file_name = file_list[length-1]
end

openr,1,file
fs=fstat(1)
N=fs.size   ; length of the file in bytes
a1=1l
a2=1l
a3=ulong64(1)
a4=double(2)

Nbytes = 24  ; data are Uint64 = 8 bytes
N = fs.size/Nbytes
plow = lonarr(N)    ; create a longword integer array of N elements
phigh = lonarr(N)    ; create a longword integer array of N elements
evid=lonarr(N)
char=lonarr(N)
evid=ulong64(evid)
char=double(char)
for i=0l,n-1 do begin
readu,1,a1,a2,a3,a4
plow(i)=a1
phigh(i)=a2
evid(i)=a3
char(i)=a4
endfor
close,1
two63=2d0^63
w=where(evid gt two63,n1)
if n1 gt 0 then evid(w)=evid(w)-two63
return
end
