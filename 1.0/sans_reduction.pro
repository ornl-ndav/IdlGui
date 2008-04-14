PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;get the current folder
CD, CURRENT = current_folder

VERSION = '(1.0.0)'

;define initial global values - these could be input via external
;file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

IF (!VERSION.os EQ 'darwin') THEN BEGIN
   ucams = 'j35'
ENDIF ELSE BEGIN
   ucams = get_ucams()
ENDELSE

;define global variables
global = PTR_NEW ({ version : VERSION })

MainBaseTitle  = 'SANS Data Reduction GUI'
MainBaseSize   = [30,25,700,500]
        
MainBaseTitle += ' - ' + VERSION

;Build Main Base
MAIN_BASE = WIDGET_BASE( GROUP_LEADER = wGroup,$
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
widget_control, MAIN_BASE, SET_UVALUE=global

;Build Tab1
make_gui_main_tab, MAIN_BASE, MainBaseSize

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

END

;===============================================================================
; Empty stub procedure used for autoloading.
PRO sans_reduction, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





