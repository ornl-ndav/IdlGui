PRO MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id
  
  CASE Event.id OF
  
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
    ELSE:
  ENDCASE
  
END


PRO MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;define parameters
  scr_x 	= 1100				;main window width
  scr_y 	= 700				;main window height
  ctrl_x	= 1				;width of left box - control
  ctrl_y	= scr_y				;height of lect box - control
  draw_x 	= 304				;main width of draw area
  draw_y 	= 256				;main heigth of draw area
  draw_offset_x = 10			;draw x offset within widget
  draw_offset_y = 10			;draw y offset within widget
  plot_height = 150			;plot box height
  plot_length = 304			;plot box length
  
  APPLICATION = 'GUIdesigner'
  VERSION     = '1.0.0'
  
  Resolve_Routine, 'GUIdesigner_eventcb',/COMPILE_FULL_FILE
  ;Load event callback routines
  
  title = APPLICATION + ' - ' + VERSION
  
 ;define initial global values
  global = ptr_new({xoffset: 50,$
                    yoffset: 50,$
                    xsize: 200,$
                    ysize: 200})
 
  MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
    UNAME          = 'MAIN_BASE',$
    XOFFSET        = (*global).xoffset,$
    YOFFSET        = (*global).yoffet,$
    SCR_XSIZE      = (*global).xsize,$
    SCR_YSIZE      = (*global).ysize,$
    TITLE          = title,$
    SPACE          = 3,$
    XPAD           = 3,$
    YPAD           = 3)
 ;   MBAR           = WID_BASE_0_MBAR)
     
;attach global data structure with widget ID of widget main base widget ID
  widget_control,MAIN_BASE,set_uvalue=global
    
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
END

;
; Empty stub procedure used for autoloading.
;
pro GUIbuilder, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
