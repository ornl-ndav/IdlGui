pro MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id
  
  case Event.id of
  
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='button1'): begin
      loadASCII_Click, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='button2'): begin
      plotData, Event, 0
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txt1'): begin
      txt1_Enter, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='draw1'): begin
      draw1_Enter, Event
    end
    
    else:
  endcase
  
end






pro MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

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
  
  APPLICATION = 'plotASCII'
  VERSION     = '1.0'
  
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
    
  ;define initial global values
  global = ptr_new({path: $
    '/SNS/users/dfp/IdlGui/branches/Summer2008/REF_M_3769_2008y_05m_23d_17h_52mn_28s.rtof',$
    MyStruct: ptr_new(), $
    zoomCrdBeg: [0D,0D], $
    zoomCrdEnd: [0D,0D]})
    
  loadASCII = widget_button(MAIN_BASE,$
    xoffset = 2,$
    yoffset = 3,$
    scr_xsize = 100,$
    scr_ysize = 35,$
    value = 'Load ASCII',$
    uname = 'button1')
    
  resetZoom = widget_button(MAIN_BASE,$
    xoffset = 404,$
    yoffset = 3,$
    scr_xsize = 100,$
    scr_ysize = 35,$
    value = 'Reset Zoom',$
    uname = 'button2')
    
  ;  wLabel = WIDGET_LABEL(MAIN_BASE,$
  ;    xoffset = 200,$
  ;    yoffset = 400,$
  ;    scr_xsize = 300,$
  ;    scr_ysize = 35,$
  ;    /DYNAMIC_RESIZE, $
  ;    value = 'blank',$
  ;    uname = 'label1')
    
  wTXT = WIDGET_TEXT(MAIN_BASE,$
    xoffset = 102,$
    yoffset = 3,$
    scr_xsize = 300,$
    scr_ysize = 36,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txt1')
    
  wDraw = WIDGET_DRAW(MAIN_BASE,$
    xoffset = 1,$
    yoffset = 40,$
    scr_xsize = 700,$
    scr_ysize = 500,$
    /BUTTON_EVENTS, $
    uname = 'draw1')
    
  ;attach global data structure with widget ID of widget main base widget ID
  widget_control,MAIN_BASE,set_uvalue=global
  
  
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
end

;
; Empty stub procedure used for autoloading.
;
pro plotASCII, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
