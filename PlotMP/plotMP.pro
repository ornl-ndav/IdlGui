pro MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id
  HELP, EVENT, /STRUCTURE
  
  case Event.id of
  
    Widget_Info(wWidget, FIND_BY_UNAME='loadFile'): begin
      loadFile, Event, 0
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='graph'): begin
      graph, Event, 0
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txtPath'): begin
      txtPath, Event, 0
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txtX'): begin
      txtX, Event, 0
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txtY'): begin
      txtY, Event, 0
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='draw'): begin
      draw, Event, 0
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='select'): begin
      select, Event, 0
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='extend'): begin
      extend, Event
    end
    
    ;file_2
        Widget_Info(wWidget, FIND_BY_UNAME='loadFile1'): begin
      loadFile, Event, 1
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='graph1'): begin
      graph, Event, 1
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txtPath1'): begin
      txtPath, Event, 1
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txtX1'): begin
      txtX, Event, 1
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txtY1'): begin
      txtY, Event, 1
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='draw1'): begin
      draw, Event, 1
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='select1'): begin
      select, Event, 1
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='extend'): begin
      extend, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='exit'): begin
      WIDGET_CONTROL, wWidget, /DESTROY
    end
    
    else: print, "else"
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
    file: ptrarr(2, /allocate_heap), $
    all_data: ptr_new(), $
    data: ptr_new(), $
    extended: 0, $
    x: '', $
    y: ''})
  ;============================
    
    
  loadFile = widget_button(MAIN_BASE,$
    xoffset = 355,$
    yoffset = 5,$
    xsize = 35,$
    ysize = 30,$
    value = '...',$
    uname = 'loadFile')
    
    
    
  extend = widget_button(MAIN_BASE,$
    xoffset = 395,$
    yoffset = 5,$
    xsize = 35,$
    ysize = 30,$
    value = '>>',$
    uname = 'extend')
    
  exit = widget_button(MAIN_BASE,$
    xoffset = 395,$
    yoffset = 40,$
    xsize = 35,$
    ysize = 30,$
    value = 'X',$
    uname = 'exit')
    
  ;  graph = widget_button(MAIN_BASE,$
  ;    xoffset = 300,$
  ;    yoffset = 70,$
  ;    xsize = 120,$
  ;    ysize = 29,$
  ;    value = 'Graph',$
  ;    uname = 'graph')
    
  Label1 = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    /DYNAMIC_RESIZE, $
    xoffset = 5,$
    yoffset = 15,$
    ; xsize = 80,$
    ;ysize = 30,$
    value = 'Select file:',$
    uname = 'label1')
    
  Label2 = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    /DYNAMIC_RESIZE, $
    xoffset = 5,$
    yoffset = 50,$
    ;xsize = 140,$
    ;ysize = 30,$
    value = '#X pixels/bank:',$
    uname = 'label2')
    
  Label3 = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    /DYNAMIC_RESIZE, $
    xoffset = 210,$
    yoffset = 50,$
    ;xsize = 140,$
    ;ysize = 30,$
    value = '#Y pixels/bank:',$
    uname = 'label3')
    
  txtPath = WIDGET_TEXT(MAIN_BASE,$
    xoffset = 90,$
    yoffset = 5,$
    scr_xsize = 260,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtPath')
    
  txtX= WIDGET_TEXT(MAIN_BASE,$
    xoffset = 110,$
    yoffset = 40,$
    scr_xsize = 80,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtX')
    
  txtY= WIDGET_TEXT(MAIN_BASE,$
    xoffset = 310,$
    yoffset = 40,$
    scr_xsize = 80,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtY')
    
  ;  wDraw = WIDGET_DRAW(MAIN_BASE,$
  ;    xoffset = 5,$
  ;    yoffset = 120,$
  ;    ;    xsize = 800,$
  ;    ;    ysize = 900,$
  ;    /MOTION_EVENTS, $
  ;    uname = 'draw')
    
  select = WIDGET_COMBOBOX(MAIN_BASE,$
    /sensitive, $
    xoffset = 5,$
    yoffset = 80,$
    xsize = 110,$
    ysize = 25,$
    value = 'Select...',$
    uname = 'select')
    
  statusX = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    /SUNKEN_FRAME, $
    xoffset = 120,$
    yoffset = 80,$
    xsize = 80,$
    ysize = 20,$
    value = 'X:',$
    uname = 'labX')
    
  statusY = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    /SUNKEN_FRAME, $
    xoffset = 210,$
    yoffset = 80,$
    xsize = 80,$
    ysize = 20,$
    value = 'Y:',$
    uname = 'labY')
    
  statusX = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    /SUNKEN_FRAME, $
    xoffset = 300,$
    yoffset = 80,$
    xsize = 80,$
    ysize = 20,$
    value = 'Z:',$
    uname = 'labZ')
    
    
  ;attach global da8ta structure with widget ID of widget main base widget ID
  widget_control,MAIN_BASE,set_uvalue=global
  
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  ;remove, debug purpose
  tmp = '/SNS/users/dfp/IdlGui/branches/Summer2008/PlotMP/ARCS_TS_2007_10_10.dat'
  widget_control, txtPath, set_value = tmp
  widget_control, txty, set_value = '128'
  widget_control, txtx, set_value = '8'
  ; widget_control, wDraw, XSIZE = 150, YSIZE = 150
  
  
  ;remove
  
  widget_control, txtPath, /INPUT_FOCUS
  widget_control, select, sensitive = 0
  widget_control, MAIN_BASE, XSIZE = 430, YSIZE = 80
  
end

;
; Empty stub procedure used for autoloading.
;
pro plotMP, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
