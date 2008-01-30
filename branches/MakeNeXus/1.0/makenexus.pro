PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;get the current folder
cd, current=current_folder

VERSION = '(1.0.2)'

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

;get hostname
spawn, 'hostname', hostname
CASE (hostname) OF
    'heater'      : instrumentIndex = 0
    'lrac'        : instrumentIndex = 2
    'mrac'        : instrumentIndex = 3
    'bac.sns.gov' : instrumentIndex = 1
    'bac2'        : instrumentIndex = 1
    else          : instrumentIndex = 0
ENDCASE 

;define global variables
global = ptr_new ({ program_name          : 'MakeNeXus',$
                    prenexus_found_nbr    : 0,$
                    validate_go           : 0,$
                    RunNumber             : '',$
                    RunNumberArray        : ptr_new(0L),$
                    Instrument            : '',$
                    MainBaseXoffset       : 0,$
                    MainBaseYoffset       : 0,$
                    mac : { prenexus_path : '/REF_L-DAS-FS/2008_1_2_SCI/REF_L_2000/',$
                            mapping_file  : '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_TS_2006_08_08.dat',$
                            geometry_file : '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_2006_geom.nxs',$
                            translation_file : '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_2007_08_08.nxt'},$
                    instrumentShortList   : ptr_new(0L),$
                    LogBookPath           : '/SNS/users/j35/IDL_LogBook/',$
                    hostname              : hostname,$
                    ucams                 : ucams,$
                    geek                  : 'j35',$
                    prenexus_path         : '',$
                    prenexus_path_array   : ptr_new(0L),$
                    RunNumber_array       : ptr_new(0L),$
                    output_path_1         : '~/local',$
                    staging_folder        : '~/local/.makenexus_staging',$
                    processing            : '(PROCESSING)',$
                    ok                    : 'OK',$
                    failed                : 'FAILED',$
                    NbrPhase              : 0,$
                    runinfo_ext           : '_runinfo.xml',$
                    version               : VERSION })


(*(*global).prenexus_path_array) = strarr(1)
(*(*global).RunNumber_array)     = strarr(1)

InstrumentList = ['Select your instrument...',$
                  'Backscattering',$
                  'Liquids Reflectometer',$
                  'Magnetism Reflectometer',$
                  'ARCS']

instrumentShortList = ['',$
                       'BSS',$
                       'REF_L',$
                       'REF_M',$
                       'ARCS']
(*(*global).instrumentShortList) = instrumentShortList

IF ((*global).ucams NE (*global).geek) THEN BEGIN
    MainBaseSize  = [700,500,450,422]
endif else begin
    MainBaseSize  = [100,50,850,630]
endelse
MainBaseTitle = 'Make NeXus ' + VERSION

(*global).MainBaseXoffset = MainBaseSize[0]
(*global).MainBaseYoffset = MainBaseSize[1]
        
;Build Main Base
MAIN_BASE = Widget_Base( GROUP_LEADER = wGroup,$
                         UNAME        = 'MAIN_BASE',$
                         SCR_XSIZE    = MainBaseSize[2],$
                         SCR_YSIZE    = MainBaseSize[3],$
                         XOFFSET      = MainBaseSize[0],$
                         YOFFSET      = MainBaseSize[1],$
                         TITLE        = MainBaseTitle,$
                         SPACE        = 0,$
                         XPAD         = 0,$
                         YPAD         = 2)

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

MakeGui, MAIN_BASE, MainBaseSize, InstrumentList, InstrumentIndex
Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='makenexus_Cleanup' 

;set the instrument droplist
id = widget_info(MAIN_BASE,find_by_uname='instrument_droplist')
widget_control, id, set_droplist_select=InstrumentIndex

;if on mac, instrument is REF_L and run number is 2000
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    id = widget_info(MAIN_BASE,find_by_uname='instrument_droplist')
    widget_control, id, set_droplist_select=2
    id = widget_info(MAIN_BASE,find_by_uname='run_number_cw_field')
    widget_control,id,set_value='2000'   
ENDIF 

;;REMOVE ME
;;set the instrument droplist
;id = widget_info(MAIN_BASE,find_by_uname='instrument_droplist')
;widget_control, id, set_droplist_select=3
;id = widget_info(MAIN_BASE,find_by_uname='run_number_cw_field')
;widget_control,id,set_value='2968'
;id = widget_info(MAIN_BASE,find_by_uname='create_nexus_button')
;widget_control, id, sensitive=1
;(*global).prenexus_path = '/REF_M-DAS-FS/2008_1_4A_SCI/REF_M_2968/'
;END OF REMOVE

END


; Empty stub procedure used for autoloading.
pro makenexus, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





