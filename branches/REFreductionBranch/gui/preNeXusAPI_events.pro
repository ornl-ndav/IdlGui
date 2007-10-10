; ##################################################################################
; ###################### API for IDL (event Data) ##################################
; ##################################################################################



; ******* Pickup Dialog Box **************
 file = dialog_pickfile(/must_exist, $
 title = 'Select a binary file', $
 filter = ['*.dat'], $
 path = '/tmp/BSS_23/', $
 get_path = Path)
 ;****************************************

openr,1,file
fs=fstat(1)
N=fs.size   ; length of the file in bytes

Nbytes = 4  ; data are Uint32 = 4 bytes
N = fs.size/Nbytes
data = lonarr(N)    ; create a longword integer array of N elements
readu,1,data
close,1


end
