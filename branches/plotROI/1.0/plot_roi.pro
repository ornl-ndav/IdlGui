PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;get the current folder
cd, current=current_folder

APPLICATION = 'plotROI'
VERSION     = '1.0.4'

;define initial global values - these could be input via external file or other
;means

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
    'heater'       : instrumentIndex = 0
    'bac.sns.gov'  : instrumentIndex = 1
    'bac2'         : instrumentIndex = 1
    'snap'         : instrumentIndex = 2
    'lrac'         : instrumentIndex = 3
    'mrac'         : instrumentIndex = 4
    'arcs1'        : instrumentIndex = 5
    'arcs2'        : instrumentIndex = 5
    ELSE           : instrumentIndex = 0
ENDCASE 

ListOFInstruments = ['BSS',$
                     'SNAP',$
                     'REF_L',$
                     'REF_M',$
                     'ARCS']

;define global variables
global = ptr_new ({ ListOfInstruments     : ListOfInstruments,$
                    LogBookPath           : '/SNS/users/LogBook/',$
                    DeployedVersion       : 0,$
                    InstrumentSelected    : instrumentIndex,$
                    ucams                 : ucams,$
                    processing            : '(PROCESSING)',$
                    ok                    : 'OK',$
                    failed                : 'FAILED',$
                    RunNumber             : '',$
                    BrowseNexusDefaultExt : '.nxs',$
                    BrowseDefaultPath     : '~/',$
                    BrowseFilter          : '*.nxs',$
                    BrowseROIExt          : '.dat',$
                    BrowseROIPath         : '~/',$
                    BrowseROIFilter       : '*.dat',$
                    ValidNexus            : 0,$
                    version               : VERSION })

IF (ucams EQ 'j35') THEN BEGIN
    MainBaseSize  = [30,25,540,700]
ENDIF ELSE BEGIN
    MainBaseSize  = [30,25,540,445]
ENDELSE

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
MakeGuiMainBase, MAIN_BASE, global

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

IF ((*global).DeployedVersion EQ 0) THEN BEGIN
    IF (!VERSION.os EQ 'darwin') THEN BEGIN
        instrumentIndex = 3    ;REMOVE_ME
;put default nexus name in 'nexus_file_text_field'
        id = widget_info(MAIN_BASE,find_by_uname='nexus_file_text_field')
        nexus = '/Users/j35/REF_L_4493.nxs'
        widget_control, id, set_value=nexus
;put default nexus name of ROI file
        id = widget_info(MAIN_BASE,find_by_uname='roi_text_field')
        roi_file = '/Users/j35/REF_L_3000_data_roi.dat'
        widget_control, id, set_value=roi_file
    ENDIF ELSE BEGIN
        instrumentIndex = 3     ;REMOVE_ME
;put default nexus name in 'nexus_file_text_field'
        id = widget_info(MAIN_BASE,find_by_uname='nexus_file_text_field')        
        nexus = '/SNS/REF_L/IPTS-231/2/4000/NeXus/REF_L_4000.nxs'
        widget_control, id, set_value=nexus
;put default nexus name of ROI file
        id = widget_info(MAIN_BASE,find_by_uname='roi_text_field')
        roi_file = '~/REF_L_2454_data_roi.dat'
        widget_control, id, set_value=roi_file
    ENDELSE
ENDIF ELSE BEGIN

ENDELSE
id = widget_info(MAIN_BASE,find_by_uname='list_of_instrument')
widget_control, id, set_droplist_select=instrumentIndex

;logger message
logger_message  = '/usr/bin/logger -p local5.notice IDLtools '
logger_message += APPLICATION + '_' + VERSION + ' ' + ucams
print, logger_message
spawn, logger_message

END


; Empty stub procedure used for autoloading.
pro plot_roi, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





