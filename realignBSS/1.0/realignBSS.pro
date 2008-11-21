pro MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id

  case Event.id of

    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end

    else:
endcase

end




pro MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_


Resolve_Routine, 'plotASCII_eventcb',/COMPILE_FULL_FILE 
;Load event callback routines

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
                         UNAME          = 'MAIN_BASE',$
                         XOFFSET        = 500,$           
                         YOFFSET        = 50,$
                         SCR_XSIZE      = 300,$
                         SCR_YSIZE      = 200,$
                         NOTIFY_REALIZE = 'MAIN_REALIZE',$
                         TITLE          = '',$
                         SPACE          = 3,$
                         XPAD           = 3,$
                         YPAD           = 3,$
                         MBAR           = WID_BASE_0_MBAR)

;define initial global values - these could be input via external file
;or other means

global = ptr_new({})


;attach global data structure with widget ID of widget main base widget ID
widget_control,MAIN_BASE,set_uvalue=global


Widget_Control, /REALIZE, MAIN_BASE

XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

; logger message
; logger_message  = '/usr/bin/logger -p local5.notice IDLtools '
; logger_message += APPLICATION + '_' + VERSION + ' ' + ucams
; error = 0
; CATCH, error
; IF (error NE 0) THEN BEGIN
;     CATCH,/CANCEL
; ENDIF ELSE BEGIN
;     spawn, logger_message
; ENDELSE

end

;
; Empty stub procedure used for autoloading.
;
pro plotASCII, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
