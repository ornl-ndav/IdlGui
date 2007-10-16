
PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

VERSION = '(VERSION: TSrebin1.0.0)'
loadct,5

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

;define global variables
global = ptr_new ({instrument : ''$
                  })
;define Main Base variables
;[xoffset, yoffset, scr_xsize, scr_ysize]

MainBaseSize  = [50,50,550,305]
MainBaseTitle = 'Translation Service Rebin Tool ' + VERSION
        
;Build Main Base
MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
                         UNAME='MAIN_BASE',$
                         SCR_XSIZE=MainBaseSize[2],$
                         SCR_YSIZE=MainBaseSize[3],$
                         XOFFSET=MainBaseSize[0],$
                         YOFFSET=MainBaseSize[1],$
                         TITLE=MainBaseTitle,$
                         COLUMN = 1,$
                         SPACE=0,$
                         XPAD=0,$
                         YPAD=2)

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

;Build GUI
MakeGui, MAIN_BASE

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

END


; Empty stub procedure used for autoloading.
pro ts_rebin, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





