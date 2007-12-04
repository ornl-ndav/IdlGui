PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

VERSION = 'VERSION: GG1.0.0'

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

;define global variables
global = ptr_new ({ $
                    version : VERSION })

MainBaseSize  = [30,25,700,500]
MainBaseTitle = 'Geometry Generator'
        
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

;add version to program
VersionLength = strlen(VERSION)
version_label = widget_label(MAIN_BASE,$
                             XOFFSET = MainBaseSize[2]-VersionLength*6.5,$
                             YOFFSET = 2,$
                             VALUE   = VERSION,$
                             FRAME   = 0)

MakeGuiMainTab, MAIN_BASE, MainBaseSize, XYfactor

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

;????????????????????????? FOR DEVELOPMENT ONLY ??????????????????????????
;;default tabs shown
;id1 = widget_info(MAIN_BASE, find_by_uname='main_tab')
;widget_control, id1, set_tab_current = 1 ;reduce

;;tab #7
;id1 = widget_info(MAIN_BASE, find_by_uname='reduce_input_tab')
;widget_control, id1, set_tab_current = 6
;?????????????????????????????????????????????????????????????????????????

END


; Empty stub procedure used for autoloading.
pro gg, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





