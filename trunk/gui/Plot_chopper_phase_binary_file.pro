; ##################################################################################
; ###################### API for IDL (event Data) ##################################
; ##################################################################################

; Non Interactive Part
file_name = "DAS_3_chopperphase_event.dat"
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

N_phase_error = N / 3
array = lonarr(3,N_phase_error)     ; Determine the max and min value of the phase_error (that will be used for the axis of the plot

array(*,*)=data(*)

Value_max = max(array, min=Value_min)

array_1 = lonarr(N_phase_error)
array_2 = lonarr(N_phase_error)
array_3 = lonarr(N_phase_error)

array_1(*) = array(0,*)
array_2(*) = array(1,*)
array_3(*) = array(2,*)

; **************graphical part**********************
xtitle = "X"
ytitle = "Y"
title = ""

window,1,xsize=700,ysize=500, xpos=0, ypos=0
plot, array_1, title="Plot of phase_error_1", xtitle=" ?", ytitle="Phase_error (*100ns)", charsize=1.4

window,2,xsize=700,ysize=500, xpos=700, ypos=0
plot, array_2, title="Plot of phase_error_2", xtitle=" ?", ytitle="Phase_error (*100ns)", charsize=1.4

window,3,xsize=700,ysize=500, xpos=0, ypos=550
plot, array_3, title="Plot of phase_error_3", xtitle=" ?", ytitle="Phase_error (*100ns)", charsize=1.4

end