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

ListOFInstruments = ['BASIS',$
                     'SNAP',$
                     'REF_L',$
                     'REF_M',$
                     'ARCS']

;define global variables
global = ptr_new ({ ListOfInstruments     : ListOfInstruments,$
                    InstrumentSelected    : instrumentIndex,$
                    ucams                 : ucams,$
                    processing            : '(PROCESSING)',$
                    ok                    : 'OK',$
                    failed                : 'FAILED',$
                    RunNumber             : '',$
                    version               : VERSION })

IF (ucams EQ 'j35') THEN BEGIN
    MainBaseSize  = [30,25,540,715]
ENDIF ELSE BEGIN
    MainBaseSize  = [30,25,540,455]
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

;Validate instrument selected
id = widget_info(MAIN_BASE,find_by_uname='list_of_instrument')
widget_control, id, set_droplist_select=instrumentIndex

END


; Empty stub procedure used for autoloading.
pro plot_roi, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





