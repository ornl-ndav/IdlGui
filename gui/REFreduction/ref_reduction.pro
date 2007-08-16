PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_


Resolve_Routine, 'ref_reduction_eventcb',/COMPILE_FULL_FILE ; Load event callback routines

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin
if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

;define global variables
global = ptr_new ({instrument : 'REF_L',$ ;name of the current selected REF instrument
                   REF_L : 'REF_L',$ ;name of REF_L instrument
                   REF_M : 'REF_M',$ ;name of REF_M instrument
                   Nx_REF_L : 256L,$ ;Nx for REF_L instrument
                   Ny_REF_L : 304L,$ ;Ny for REF_L instrument
                   Nx_REF_M : 304L,$ ;Nx for REF_M instrument
                   Ny_REF_M : 256L,$ ;Ny for REF_M instrument
                   Ntof_DATA : 0L, $ ;TOF for data file
                   Ntof_NORM : 0L, $ ;TOF for norm file
                   processing_message : '(PROCESSING)',$ ;processing message to display
                   data_tmp_dat_file : 'tmp_data.dat',$ ;default name of tmp binary data file
                   full_data_tmp_dat_file : '',$ ;full path of tmp .dat file for data
                   norm_tmp_dat_file : 'tmp_nor.dat',$ ;default name of tmp binary norm file
                   full_norm_tmp_dat_file : '',$ ;full path of tmp .dat file for normalization
                   working_path : '~/local/',$ ;where the tmp file will be created
                   ucams : ucams, $ ;ucams of the current user
                   DATA_DD_ptr : ptr_new(0L),$ ;detector view of DATA (2D)
                   DATA_D_ptr : ptr_new(0L)$ ;(Ntof,Ny,Nx) array of DATA
                  })

full_data_tmp_dat_file = (*global).working_path + (*global).data_tmp_dat_file 
(*global).full_data_tmp_dat_file = full_data_tmp_dat_file
full_norm_tmp_dat_file = (*global).working_path + (*global).full_norm_tmp_dat_file
(*global).full_norm_tmp_dat_file = full_norm_tmp_dat_file

;define Main Base variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
MainBaseSize       = [50,50,1200,880]
MainBaseTitle      = 'Reflectometer Data Reduction Package'

;Build Main Base
MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
                         UNAME='MAIN_BASE',$
                         SCR_XSIZE=MainBaseSize[2],$
                         SCR_YSIZE=MainBaseSize[3],$
                         XOFFSET=MainBaseSize[0],$
                         YOFFSET=MainBaseSize[1],$
                         TITLE=MainBaseTitle,$
                         SPACE=0,$
                         XPAD=0,$
                         YPAD=0)


;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

;Build LOAD-REDUCE-PLOTS-LOGBOOK-SETTINGS tab
MakeGuiMainTab, MAIN_BASE, MainBaseSize

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

END


;
; Empty stub procedure used for autoloading.
;
pro ref_reduction, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEASER=wGroup, _EXTRA=_VWBExtra_
end





