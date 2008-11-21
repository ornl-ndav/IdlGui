pro MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id
  
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
      print, 'status 2'
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
    pane: ptrarr(2, /allocate_heap), $
    all_data: ptr_new(), $
    data: ptr_new(), $
    extended: 0S, $
    x: 0S, $
    y: 0S, $
    x1: 0S, $
    y1: 0S})
  ;============================
    
    
  pane_1 = Widget_Base( MAIN_BASE,$
    GROUP_LEADER=MAIN_BASE,$
    UNAME          = 'pane_1',$
    XOFFSET        = 5,$
    YOFFSET        = 5,$
    XSIZE      = 395,$
    YSIZE      = 70,$
    FRAME       = 4)
    
  loadFile = widget_button(pane_1,$
    xoffset = 355,$
    yoffset = 0,$
    xsize = 35,$
    ysize = 30,$
    value = '...',$
    uname = 'loadFile')
    
  Label1 = widget_label(pane_1,$
    /ALIGN_LEFT, $
    /DYNAMIC_RESIZE, $
    xoffset = 5,$
    yoffset = 10,$
    ; xsize = 80,$
    ;ysize = 30,$
    value = 'Select file:',$
    uname = 'label1')
    
  Label2 = widget_label(pane_1,$
    /ALIGN_LEFT, $
    /DYNAMIC_RESIZE, $
    xoffset = 5,$
    yoffset = 45,$
    ;xsize = 140,$
    ;ysize = 30,$
    value = '#X pixels/bank:',$
    uname = 'label2')
    
  Label3 = widget_label(pane_1,$
    /ALIGN_LEFT, $
    /DYNAMIC_RESIZE, $
    xoffset = 205,$
    yoffset = 45,$
    ;xsize = 140,$
    ;ysize = 30,$
    value = '#Y pixels/bank:',$
    uname = 'label3')
    
  txtPath = WIDGET_TEXT(pane_1,$
    xoffset = 90,$
    yoffset = 0,$
    scr_xsize = 260,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtPath')
    
  txtX= WIDGET_TEXT(pane_1,$
    xoffset = 110,$
    yoffset = 35,$
    scr_xsize = 80,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtX')
    
  txtY= WIDGET_TEXT(pane_1,$
    xoffset = 310,$
    yoffset = 35,$
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
    
;  gen_buttons = Widget_Base( MAIN_BASE,$
;    GROUP_LEADER = MAIN_BASE,$
;    UNAME          = 'gen_buttons',$
;    XOFFSET        = 415,$
;    YOFFSET        = 5,$
;    XSIZE      = 40,$
;    YSIZE      = 70,$
;    FRAME       = 4 )
;        
;  select = WIDGET_COMBOBOX(MAIN_BASE,$
;    /sensitive, $
;    xoffset = 5,$
;    yoffset = 80,$
;    xsize = 110,$
;    ysize = 25,$
;    value = 'Select...',$
;    uname = 'select')
;    
;  statusX = widget_label(MAIN_BASE,$
;    /ALIGN_LEFT, $
;    /SUNKEN_FRAME, $
;    xoffset = 120,$
;    yoffset = 80,$
;    xsize = 80,$
;    ysize = 20,$
;    value = 'X:',$
;    uname = 'labX')
;    
;  statusY = widget_label(MAIN_BASE,$
;    /ALIGN_LEFT, $
;    /SUNKEN_FRAME, $
;    xoffset = 210,$
;    yoffset = 80,$
;    xsize = 80,$
;    ysize = 20,$
;    value = 'Y:',$
;    uname = 'labY')
;    
;  statusZ = widget_label(MAIN_BASE,$
;    /ALIGN_LEFT, $
;    /SUNKEN_FRAME, $
;    xoffset = 300,$
;    yoffset = 80,$
;    xsize = 80,$
;    ysize = 20,$
;    value = 'Z:',$
;    uname = 'labZ')
    
    
  gen_buttons = Widget_Base( MAIN_BASE,$
    GROUP_LEADER = MAIN_BASE,$
    UNAME          = 'gen_buttons',$
    XOFFSET        = 415,$
    YOFFSET        = 5,$
    XSIZE          = 40,$
    YSIZE          = 70,$
    FRAME          = 4 )
    
  extend = widget_button(gen_buttons,$
    xoffset = 0,$
    yoffset = 0,$
    xsize = 37,$
    ysize = 30,$
    value = '>>',$
    uname = 'extend')
    
  exit = widget_button(gen_buttons,$
    xoffset = 0,$
    yoffset = 35,$
    xsize = 37,$
    ysize = 30,$
    value = 'X',$
    uname = 'exit')
    
    
  ;attach global da8ta structure with widget ID of widget main base widget ID
  widget_control,MAIN_BASE,set_uvalue=global
  
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  ;remove, debug purpose
  tmp = '/SNS/users/dfp/IdlGui/branches/Summer2008/PlotMP/REF_L_TS_2006_12_01.dat'
  widget_control, txtPath, set_value = tmp
  widget_control, txty, set_value = '304'
  widget_control, txtx, set_value = '256'
  ; widget_control, wDraw, XSIZE = 150, YSIZE = 150
  
  
  ;remove
  
  widget_control, txtPath, /INPUT_FOCUS
  widget_control, MAIN_BASE, XSIZE = 465, YSIZE = 100
  
  *(*global).pane[0] = {Main: MAIN_BASE, $
    txtPath: txtPath, $
    txtX: txtX, $
    txtY: txtY, $
    statusX: 0, $
    statusY: 0, $
    statusZ: 0, $
    label1: label1, $
    label2: label2, $
    label3: label3, $
    select: 0, $
    exit: exit, $
    extend: extend,$
    loadFile: loadFile, $
    draw: 0}
    
; print, (*(*global).pane[0]).txtPath, txtPath
    
end

;
; Empty stub procedure used for autoloading.
;
pro plotMP, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
