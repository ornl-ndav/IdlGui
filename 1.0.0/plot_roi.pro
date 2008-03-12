PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;get the current folder
cd, current=current_folder

VERSION = '(1.0.0)'

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
    'heater': instrumentIndex = 0
    'lrac'  : instrumentIndex = 2
    'mrac'  : instrumentIndex = 3
    'bac.sns.gov'  : instrumentIndex = 1
    'bac2'  : instrumentIndex = 1
    else    : instrumentIndex = 0
ENDCASE 

;define global variables
global = ptr_new ({ instrumentShortList   : ptr_new(0L),$
                    stringFoundIteration  : 1,$
                    geom_xml_file_title   : 'Geometry.xml file: ',$
                    new_geo_xml_filename  : '',$
                    TCompileMessage       : '*processing modified jar*',$
                    error_log_book        : '',$
                    error_list            : ['Failed',$ ;list of error found in SNSproblem_log
                                             'Fatal error',$
                                             'Error'],$
                    ucams                 : ucams,$
                    processing            : '(PROCESSING)',$
                    ok                    : 'OK',$
                    failed                : 'FAILED',$
                    ts_geom_calc_path     : 'TS_geom_calc.sh',$
                    tmp_xml_file          : '~/local/tmp_gg_xml_file.xml',$
                    leaf_array            : ptr_new(0L),$
                    setpointStatus        : 'S',$
                    userStatus            : 'U',$
                    readbackStatus        : 'R',$
                    cmd_command           : 'TS_geom_calc.sh ',$
                    geek                  : 'j35',$
                    output_default_geometry_path : '~/local',$
                    RunNumber             : '',$
                    output_geometry_ext   : '_geom',$
                    cvinfo_default_path   : '~/',$
                    geometry_default_path : '~/',$
                    geometry_xml_filtering: '*.xml',$
                    cvinfo_xml_filtering  : '*_cvinfo.xml',$
                    default_extension     : 'nxs',$
                    motors                : ptr_new(0L),$ ;full xml
                    untouched_motors      : ptr_new(0L),$ ;full untouched xml
                    motor_group           : ptr_new(0L),$   ;xml of selected group only
                    version : VERSION })

MainBaseSize  = [30,25,700,530]
MainBaseTitle = 'Plot NeXus and ROI files'
        
MainBaseTitle += ' - ' + VERSION
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

;confirmation base
MakeGuiMainBase, MAIN_BASE

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='gg_Cleanup' 

END


; Empty stub procedure used for autoloading.
pro plot_roi, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





