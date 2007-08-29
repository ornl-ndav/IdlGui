PRO BuildInstrumentGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

Resolve_Routine, 'ref_reduction_eventcb',/COMPILE_FULL_FILE ; Load event callback routines

;build the Instrument Selection base
MakeGuiInstrumentSelection, wGroup

END



PRO BuildGui, instrument, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;Resolve_Routine, 'ref_reduction_eventcb',/COMPILE_FULL_FILE ; Load event callback routines

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin
if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

;define global variables
global = ptr_new ({instrument : strcompress(instrument,/remove_all),$ ;name of the current selected REF instrument
                   IntermPlots : intarr(7),$ ;0 for inter. plot no desired, 1 for desired
                   PrevTabSelect : 0,$ ;name of previous main tab selected
                   DataNeXusFound : 0, $ ;no data nexus found by default
                   NormNeXusFound : 0, $ ;no norm nexus found by default
                   data_full_nexus_name : '',$ ;full path to data nexus file
                   norm_full_nexus_name : '',$ ;full path to norm nexus file
                   xsize_1d_draw : 2*304L,$ ;size of 1D draw (should be Ntof)
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
                   data_run_number: 0L,$ ;run number of the data file loaded and plotted
                   norm_run_number: 0L,$ ;run number of the norm. file loaded and plotted
                   DATA_DD_ptr : ptr_new(0L),$ ;detector view of DATA (2D)
                   DATA_D_ptr : ptr_new(0L),$ ;(Ntof,Ny,Nx) array of DATA
                   NORM_DD_ptr : ptr_new(0L),$ ;detector view of NORMALIZATION (2D)
                   NORM_D_ptr : ptr_new(0L),$ ;(Ntof,Ny,Nx) array of NORMALIZATION
                   tvimg_data_ptr : ptr_new(0L),$ ;rebin data img
                   tvimg_norm_ptr : ptr_new(0L),$ ;rebin norm img
                   back_selection_color : 250L,$ ;color of background selection
                   peak_selection_color : 100L,$ ;color of peak exclusion
                   data_back_selection : ptr_new(0L),$ ;Ymin and Ymax for data background
                   norm_back_selection : ptr_new(0L),$ ;Ymin and Ymax for norm background
                   data_peak_selection : ptr_new(0L),$ ;Ymin and Ymax for data peak
                   norm_peak_selection : ptr_new(0L),$ ;Ymin and Ymax for norm peak
                   data_back_roi_ext : '_data_roi.dat',$ ;extension file name of back data ROI
                   norm_back_roi_ext : '_norm_roi.dat',$ ;extension file name of back norm ROI
                   roi_file_preview_nbr_line : 20L,$ ;nbr of line to display in preview
                   select_data_status : 0,$ ;Status of the data selection (see below)
                   select_norm_status : 0,$ ;Status of the norm selection (see below)
                   flt0_ptr : ptrarr(8,/allocate_heap),$ ;arrays of all the x-axis
                   flt1_ptr : ptrarr(8,/allocate_heap),$ ;arrays of all the y-axis
                   flt2_ptr : ptrarr(8,/allocate_heap)$ ;arrays of all the y-error data
                  })

;------------------------------------------------------------------------
;explanation of the select_data_status and select_norm_status
;0 nothing has been done yet
;1 user left click first and is now in back selection 1st border
;2 user release click and is done with back selection 1st border
;3 user right click and is now entering the back selection of 2nd border
;4 user left click and is now selecting the 2nd border
;5 user release click and is done with selection of 2nd border
;------------------------------------------------------------------------

full_data_tmp_dat_file = (*global).working_path + (*global).data_tmp_dat_file 
(*global).full_data_tmp_dat_file = full_data_tmp_dat_file
full_norm_tmp_dat_file = (*global).working_path + (*global).norm_tmp_dat_file
(*global).full_norm_tmp_dat_file = full_norm_tmp_dat_file
(*(*global).data_back_selection) = [0,2*303]
(*(*global).data_peak_selection) = [0,2*303]
(*(*global).norm_back_selection) = [0,2*303]
(*(*global).norm_peak_selection) = [0,2*303]

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
MakeGuiMainTab, MAIN_BASE, MainBaseSize, instrument

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

END


;
; Empty stub procedure used for autoloading.
;
pro ref_reduction, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;check instrument here
spawn, 'hostname',listening
CASE (listening) OF
   'lrac': instrument = 'REF_L'
   'mrac': instrument = 'REF_M'
   'heater': instrument = 'UNDEFINED'
   else: instrument = 'UNDEFINED'
ENDCASE

if (instrument EQ 'UNDEFINED') then begin
   BuildInstrumentGui, GROUP_LEADER=wGroup, _Extra=_VWBExtra_
endif else begin
   BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument
endelse
end





