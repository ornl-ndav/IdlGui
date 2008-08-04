pro MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id

  case Event.id of

    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='my_first_button'): begin
        myFirstClick, Event
    end
    
    else:
endcase

end






pro MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;define parameters
scr_x 	= 1118				;main window width
scr_y 	= 700				;main window height 
ctrl_x	= 1				;width of left box - control
ctrl_y	= scr_y				;height of lect box - control
draw_x 	= 304				;main width of draw area
draw_y 	= 256				;main heigth of draw area
draw_offset_x = 10			;draw x offset within widget
draw_offset_y = 10			;draw y offset within widget
plot_height = 150			;plot box height
plot_length = 304			;plot box length

APPLICATION = 'realignBSS'
VERSION     = '1.0.3'

Resolve_Routine, 'plotASCII_eventcb',/COMPILE_FULL_FILE 
;Load event callback routines

title = APPLICATION + ' - ' + VERSION

MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
                         UNAME          = 'MAIN_BASE',$
                         XOFFSET        = 500,$           
                         YOFFSET        = 50,$
                         SCR_XSIZE      = scr_x,$
                         SCR_YSIZE      = scr_y,$
;                         NOTIFY_REALIZE = 'MAIN_REALIZE',$
                         TITLE          = title,$
                         SPACE          = 3,$
                         XPAD           = 3,$
                         YPAD           = 3,$
                         MBAR           = WID_BASE_0_MBAR)

;define initial global values - these could be input via external file
;or other means

global = ptr_new({var: 1000000L$
                 })

wbutton = widget_button(MAIN_BASE,$
                        xoffset = 0,$
                        yoffset = 0,$
                        scr_xsize = 300,$
                        scr_ysize = 35,$
                        value = 'this is my bouton',$
                        uname = 'my_first_button')

;attach global data structure with widget ID of widget main base widget ID
widget_control,MAIN_BASE,set_uvalue=global
;                                 uname="sns_idl_button")

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

end

;
; Empty stub procedure used for autoloading.
;
pro plotASCII, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
