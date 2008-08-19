pro MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id
  
  case Event.id of
  
    Widget_Info(wWidget, FIND_BY_UNAME='button1'): begin
      loadFile, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='graph'): begin
      graph, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txtPath'): begin
      txtPath, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txtX'): begin
      txtX, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txtY'): begin
      txtY, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='draw'): begin
      draw, Event
    end
    
    else:
  endcase
  
end






pro MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;define parameters
  ;  x 	= 800				;main window width
  ;  y 	= 750				;main window height
  ;  ctrl_x	= 1				;width of left box - control
  ;  ctrl_y	= y				;height of lect box - control
  ;  draw_x 	= 304				;main width of draw area
  ;  draw_y 	= 256				;main heigt of draw area

  APPLICATION = 'plotMP'
  VERSION     = '1.0'
  
  Resolve_Routine, 'plotMP_eventcb',/COMPILE_FULL_FILE
  ;Load event callback routines
  
  title = APPLICATION + ' - ' + VERSION
  
  MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
    UNAME          = 'MAIN_BASE',$
    XOFFSET        = 450,$
    YOFFSET        = 50,$
    ;    XSIZE      = 430,$
    ;    YSIZE      = 110,$
    XSIZE      = 700,$
    YSIZE      = 1000,$
    ;NOTIFY_REALIZE = 'MAIN_REALIZE',$
    TITLE          = title,$
    SPACE          = 3,$
    XPAD           = 3,$
    YPAD           = 3) ;,$
  ; MBAR           = WID_BASE_0_MBAR)
    
  ;define initial global values
  ;============================
  global = ptr_new({path: '',$
    data: ptr_new(), $
    x: '', $
    y: ''})
  ;============================
    
    
  loadFile = widget_button(MAIN_BASE,$
    xoffset = 300,$
    yoffset = 40,$
    xsize = 120,$
    ysize = 29,$
    value = 'Browse',$
    uname = 'button1')
    
  graph = widget_button(MAIN_BASE,$
    xoffset = 300,$
    yoffset = 70,$
    xsize = 120,$
    ysize = 29,$
    value = 'Graph',$
    uname = 'graph')
    
  Label1 = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    xoffset = 10,$
    yoffset = 10,$
    xsize = 140,$
    ysize = 30,$
    value = 'Select mapping File:',$
    uname = 'label1')
    
  Label2 = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    xoffset = 10,$
    yoffset = 40,$
    xsize = 140,$
    ysize = 30,$
    value = '#X pixels/bank:',$
    uname = 'label2')
    
  Label3 = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    xoffset = 10,$
    yoffset = 70,$
    xsize = 140,$
    ysize = 30,$
    value = '#Y pixels/bank:',$
    uname = 'label3')
    
  txtPath = WIDGET_TEXT(MAIN_BASE,$
    xoffset = 150,$
    yoffset = 10,$
    scr_xsize = 270,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtPath')
    
  txtX= WIDGET_TEXT(MAIN_BASE,$
    xoffset = 150,$
    yoffset = 40,$
    scr_xsize = 140,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtX')
    
  txtY= WIDGET_TEXT(MAIN_BASE,$
    xoffset = 150,$
    yoffset = 70,$
    scr_xsize = 140,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtY')
    
  wDraw = WIDGET_DRAW(MAIN_BASE,$
    xoffset = 10,$
    yoffset = 110,$
;    xsize = 800,$
;    ysize = 900,$
    /MOTION_EVENTS, $
    uname = 'draw')
    
  statusX = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    xoffset = 430,$
    yoffset = 10,$
    xsize = 140,$
    ysize = 30,$
    value = 'X:',$
    uname = 'labX')
    
  statusY = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    xoffset = 430,$
    yoffset = 40,$
    xsize = 140,$
    ysize = 30,$
    value = 'Y:',$
    uname = 'labY')
    
  statusX = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    xoffset = 430,$
    yoffset = 70,$
    xsize = 140,$
    ysize = 30,$
    value = 'Z:',$
    uname = 'labZ')
    
    
  ;attach global da8ta structure with widget ID of widget main base widget ID
  widget_control,MAIN_BASE,set_uvalue=global
  
  
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  ;remove, debug purpose
  tmp = '/SNS/users/dfp/IdlGui/branches/Summer2008/PlotMP/REF_L_TS_2006_12_01.dat'
  widget_control, txtPath, set_value = tmp
  widget_control, txty, set_value = '304'
  widget_control, txtx, set_value = '256'
  ;widget_control, wDraw, XSIZE = 150, YSIZE = 150
  help, wDraw
  
  ;remove
  
  widget_control, txtPath, /INPUT_FOCUS
  widget_control, MAIN_BASE, XSIZE = 430, YSIZE = 110
  
end

;
; Empty stub procedure used for autoloading.
;
pro plotMP, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
