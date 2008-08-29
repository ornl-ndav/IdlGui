PRO loadFile, Event, fn
  case fn of
    0: txtPath = 'txtPath'
    1: txtPath = 'txtPath1'
  endcase
  
  id = widget_info(Event.top, find_by_uname = txtPath)
  print, id
  tmp = dialog_pickfile(/must_exist, title = 'Select a binary file')
  widget_control, id, set_value = tmp
  check, Event, fn
END

PRO plotData, Event, index, fn
  widget_control, Event.top, get_uvalue=global
  
  x = (*(*global).file[fn]).x *2
  y = (*(*global).file[fn]).y *2
  y_offset = 130
  
  case fn of
    0: begin
      x_offset = 5
      name = 'draw'
      if (*global).extended then begin
      
        start_draw = ((*global).x * 2) + 20
        
        if start_draw lt 415 then begin
          start_draw = 415S
        endif
        
        widget_control, Event.top, XSIZE = (start_draw + 470)
        
        id = widget_info(Event.top, find_by_uname = 'gen_buttons')
        widget_control, id, xoffset = start_draw + 410
        widget_control, (*(*global).pane[1]).pane, xoffset = start_draw
        id = widget_info(Event.top, find_by_uname = 'draw1')
        if id ne 0 then widget_control, id, xoffset = start_draw
        id = widget_info(Event.top, find_by_uname = 'framePlotCtrl1')
        if id ne 0 then widget_control, id, xoffset = start_draw
        
      endif else begin
      
        widget_control, Event.top, XSIZE= x + 20
      endelse
      
      if (*global).y1 lt y then begin
        widget_control, Event.top, YSIZE= y + y_offset + 20
      endif
      
      
    end
    
    1: begin
      x_offset = (*global).x *2 +20
      if x_offset lt 415 then begin
        x_offset = 415S
      endif
      name = 'draw1'
      ;      base_y = y + 140
      if (*global).y lt y then begin
        widget_control, Event.top, YSIZE= y + y_offset + 10
      endif
      if x gt 440 then begin
        widget_control, Event.top, XSIZE= ((*global).x *2) +30
      endif
      
    end
  endcase
  
  
  
  if (*(*global).pane[fn]).draw ne 0 then begin
    widget_control, (*(*global).pane[fn]).draw , /destroy
    print, 'killed draw widget'
  end
  
  
  ;  if base_x lt 430 then base_x = 430
  
  
  wDraw = WIDGET_DRAW(event.top,$
    xoffset = x_offset,$
    yoffset = y_offset,$
    xsize = x+10,$
    ysize = y+10,$
    /MOTION_EVENTS, $
    uname = name)
    
  print, wDraw
  (*(*global).pane[fn]).draw = wDraw
  
  help, x, y
  
  data = *((*(*global).file[fn]).all_data)
  
  dt_start = ((*(*global).file[fn]).banks[index-1]).offset
  if n_elements((*(*global).file[fn]).banks) gt 1 then begin
    print, ((*(*global).file[fn]).banks[index]).offset
    dt_end = long(((*(*global).file[fn]).banks[index]).offset) - 1
    data = data[dt_start:dt_end]
  endif else begin
    data = data[dt_start:*]
  endelse
  
  print, n_elements(data)
  data = reform(data, x/2, y/2, /OVERWRITE)
  (*(*global).file[fn]).data = ptr_new(data)
  
  WIDGET_CONTROL, wDraw, GET_VALUE = ind
  WSET, ind
  plotdata = rebin(data, x , y)
  DEVICE, DECOMPOSED=0
  LOADCT, 5
  tvscl, plotdata
  
  ;Plot grid
  for y0 = 0, y+10, 5 do begin
    Plots, [0,y0], /device, color = 0
    Plots, [x+10,y0], /device , /continue, color = 0
  endfor
  
  for x0 = 0, x+10, 5 do begin
    Plots, [x0,0], /device, color = 0
    Plots, [x0,y+10], /device , /continue, color = 0
  endfor
END

PRO select, Event, fn
  index = event.index
  if index gt 0 then plotData, Event, Index, fn
END

PRO extend, Event
  widget_control, Event.top, get_uvalue=global
  
  if (*global).extended then begin
    widget_control, (*(*global).pane[1]).pane, /destroy
    id = widget_info(Event.top, find_by_uname = 'draw1')
    if id ne 0 then widget_control, id, /destroy
    (*global).extended = 0
    
    end_draw = ((*global).x * 2) + 10
    if end_draw lt 415 then begin
      end_draw = 415S
    endif
    
    widget_control, Event.top, XSIZE = end_draw + 50
    
    id = widget_info(Event.top, find_by_uname = 'gen_buttons')
    widget_control, event.id, set_value = '>>'
    widget_control, id, xoffset = end_draw
    
    id = widget_info(Event.top, find_by_uname = 'framePlotCtrl1')
    if id ne 0 then widget_control, id, /destroy
    
  endif else begin
  
    start_draw = ((*global).x * 2) + 20
    
    if start_draw lt 415 then begin
      start_draw = 415S
    endif
    
    print, 'start at:', start_draw
    widget_control, Event.top, XSIZE = (start_draw + 470)
    help, event, /structure
    
    id = widget_info(Event.top, find_by_uname = 'gen_buttons')
    widget_control, event.id, set_value = '<<'
    widget_control, id, xoffset = start_draw + 410
    
    
    id = widget_info(Event.top, find_by_uname = 'framePlotCtrl1')
    if id ne 0 then widget_control, id, xoffset = end_draw
    
    
    pane_2 = Widget_Base( Event.top,$
      GROUP_LEADER=MAIN_BASE,$
      UNAME          = 'pane_2',$
      XOFFSET        = start_draw,$
      YOFFSET        = 5,$
      XSIZE      = 395,$
      YSIZE      = 70,$
      FRAME       = 4)
      
    loadFile = widget_button(pane_2,$
      xoffset = 355,$
      yoffset = 0,$
      xsize = 35,$
      ysize = 30,$
      value = '...',$
      uname = 'loadFile1')
      
    Label1 = widget_label(pane_2,$
      /ALIGN_LEFT, $
      /DYNAMIC_RESIZE, $
      xoffset = 0,$
      yoffset = 10,$
      ; xsize = 80,$
      ;ysize = 30,$
      value = 'Select file:',$
      uname = 'label4')
      
    Label2 = widget_label(pane_2,$
      /ALIGN_LEFT, $
      /DYNAMIC_RESIZE, $
      xoffset = 0,$
      yoffset = 45,$
      ;xsize = 140,$
      ;ysize = 30,$
      value = '#X pixels/bank:',$
      uname = 'label5')
      
    Label3 = widget_label(pane_2,$
      /ALIGN_LEFT, $
      /DYNAMIC_RESIZE, $
      xoffset = 205,$
      yoffset = 45,$
      ;xsize = 140,$
      ;ysize = 30,$
      value = '#Y pixels/bank:',$
      uname = 'label6')
      
    txtPath = WIDGET_TEXT(pane_2,$
      xoffset = 90,$
      yoffset = 0,$
      scr_xsize = 260,$
      scr_ysize = 30,$
      /NO_NEWLINE, $
      /EDITABLE, $
      uname = 'txtPath1')
      
    txtX= WIDGET_TEXT(pane_2,$
      xoffset = 110,$
      yoffset = 35,$
      scr_xsize = 80,$
      scr_ysize = 30,$
      /NO_NEWLINE, $
      /EDITABLE, $
      uname = 'txtX1')
      
    txtY= WIDGET_TEXT(pane_2,$
      xoffset = 310,$
      yoffset = 35,$
      scr_xsize = 80,$
      scr_ysize = 30,$
      /NO_NEWLINE, $
      /EDITABLE, $
      uname = 'txtY1')
      
    ;    select = WIDGET_COMBOBOX(Event.top,$
    ;      /sensitive, $
    ;      xoffset = 400,$
    ;      yoffset = 80,$
    ;      xsize = 110,$
    ;      ysize = 25,$
    ;      value = 'Select...',$
    ;      uname = 'select1')
    ;
    ;    statusX = widget_label(Event.top,$
    ;      /ALIGN_LEFT, $
    ;      /SUNKEN_FRAME, $
    ;      xoffset = 520,$
    ;      yoffset = 80,$
    ;      xsize = 80,$
    ;      ysize = 20,$
    ;      value = 'X:',$
    ;      uname = 'labX1')
    ;
    ;    statusY = widget_label(Event.top,$
    ;      /ALIGN_LEFT, $
    ;      /SUNKEN_FRAME, $
    ;      xoffset = 610,$
    ;      yoffset = 80,$
    ;      xsize = 80,$
    ;      ysize = 20,$
    ;      value = 'Y:',$
    ;      uname = 'labY1')
    ;
    ;    statusZ = widget_label(Event.top,$
    ;      /ALIGN_LEFT, $
    ;      /SUNKEN_FRAME, $
    ;      xoffset = 700,$
    ;      yoffset = 80,$
    ;      xsize = 80,$
    ;      ysize = 20,$
    ;      value = 'Z:',$
    ;      uname = 'labZ1')
      
      
      
    *(*global).pane[1] = {Main: Event.top, $
      pane: pane_2, $
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
      loadFile: loadFile, $
      draw: 0}
      
    widget_control, txtPath, set_value = '/SNS/users/dfp/IdlGui/branches/Summer2008/PlotMP/ARCS_TS_2007_10_10.dat'
    widget_control, txtX, set_value = '8'
    widget_control, txtY, set_value = '128'
    ;    widget_control, select, sensitive = 0
    widget_control, txtPath, /INPUT_FOCUS
    (*global).extended = 1
  endelse
END


PRO drawPlotCtrl, Event, fn
  widget_control, Event.top, get_uvalue=global
  
  if ((*global).y lt 640) && ((*global).y lt 640) then begin
    widget_control, Event.top, YSIZE= 640
  endif
  
  
  
  
  names = ['select', 'labX','labY','labZ', 'framePlotCtrl']
  
  case fn of
    0: begin
      start_draw = 5
    end
    1: begin
      start_draw = ((*global).x * 2) + 20
      help, start_draw
      if start_draw lt 415 then begin
        start_draw = 415S
      endif
      names = names + '1'
    end
  endcase
  
  id = widget_info(Event.top, find_by_uname = names[4])
  if id ne 0 then begin
    widget_control, id, /destroy
  endif
  
  
  frame = Widget_Base( Event.top,$
    GROUP_LEADER = Event.top,$
    UNAME          = names[4],$
    XOFFSET        = start_draw,$
    YOFFSET        = 90,$
    XSIZE      = 395,$
    YSIZE      = 25,$
    FRAME       = 4 )
    
  select = WIDGET_COMBOBOX(frame,$
    /sensitive, $
    xoffset = 0,$
    yoffset = 0,$
    xsize = 100,$
    ysize = 25,$
    value = 'Select...',$
    uname = names[0])
    
  statusX = widget_label(frame,$
    /ALIGN_LEFT, $
    /SUNKEN_FRAME, $
    xoffset = 115,$
    yoffset = 0,$
    xsize = 80,$
    ysize = 20,$
    value = 'X:',$
    uname = names[1])
    
  statusY = widget_label(frame,$
    /ALIGN_LEFT, $
    /SUNKEN_FRAME, $
    xoffset = 205,$
    yoffset = 0,$
    xsize = 80,$
    ysize = 20,$
    value = 'Y:',$
    uname = names[2])
    
  statusZ = widget_label(frame,$
    /ALIGN_LEFT, $
    /SUNKEN_FRAME, $
    xoffset = 295,$
    yoffset = 0,$
    xsize = 80,$
    ysize = 20,$
    value = 'Z:',$
    uname = names[3])
    
  (*(*global).pane[fn]).statusX = statusX
  (*(*global).pane[fn]).statusY = statusY
  (*(*global).pane[fn]).statusZ = statusZ
  (*(*global).pane[fn]).select = select
  
  
;   widget_control, select, sensitive = 0
END



PRO getData, Event, fn
  widget_control, Event.top, get_uvalue=global
  
  widget_control, (*(*global).pane[fn]).txtX, get_value=tmp
  x = fix(tmp)
  widget_control, (*(*global).pane[fn]).txtY, get_value=tmp
  y = fix(tmp)
  
  if ~fn then begin
    (*global).x = x
    (*global).y = y
  endif else begin
    (*global).x1 = x
    (*global).y1 = y
  endelse
  
  
  ;reads the mapping file with either method
  use_read_binary = 1b
  IF (use_read_binary) THEN BEGIN
    all_data = READ_BINARY((*global).path, $
      DATA_TYPE = 3)
  ENDIF ELSE BEGIN
    openr,1,(*global).path
    fs=fstat(1)
    N=fs.size                 ; length of the file in bytes
    Nbytes = 4L               ; data are Unit32 = 4 bytes
    N = long(fs.size)/Nbytes
    all_data = lonarr(N) ; create a longword integer array of N elements
    readu,1,all_data
  ;   all_data = reform(all_data, x, y, /OVERWRITE)
  ENDELSE
  close,1
  
  
  ;get info about the mapping file
  info = obj_new('getMapInfo',(*global).path)
  infStruct = info ->getInfo(x, y)
  *(*global).file[fn] = infStruct
  (*(*global).file[fn]).all_data = ptr_new(all_data)
  drawPlotCtrl, Event, fn
  ;set up the combo box
  tmp = string(indgen(infStruct.numbanks + 1))
  tmp[0] = '--'
  widget_control, (*(*global).pane[fn]).select, set_value = tmp
  widget_control, (*(*global).pane[fn]).select, /INPUT_FOCUS
  
;plotData, Event
END


PRO graph, Event, fn
  check, Event, fn
END

PRO check, Event, fn
  widget_control, Event.top, get_uvalue=global
  
  ;  case fn of
  ;    0: begin
  ;      txtPath = 'txtPath'
  ;      txtX = 'txtX'
  ;      txtY =  'txtY'
  ;    end
  ;    1: begin
  ;      txtPath = 'txtPath1'
  ;      txtX = 'txtX1'
  ;      txtY =  'txtY1'
  ;    end
  ;  endcase
  
  
  
  flag= 1
  id = (*(*global).pane[fn]).txtPath
  widget_control, id, get_value=tmp
  IF tmp NE '' THEN BEGIN
    (*global).path = tmp
    id = (*(*global).pane[fn]).txtX
    widget_control, id, get_value=tmp
    IF tmp NE '' THEN BEGIN
      id = (*(*global).pane[fn]).txtY
      widget_control, id, get_value=tmp
      IF tmp NE '' THEN BEGIN
        flag = 0
        getData, Event, fn
      ENDIF
    ENDIF
  ENDIF
  
  IF flag THEN BEGIN
    widget_control, id, /INPUT_FOCUS
  ENDIF
  
END

PRO draw, Event, fn

  widget_control, Event.top, get_uvalue=global
  
  ;help, event, /structure
  ;  tmp = convert_coord(event.x, event.y, /normal, /to_data)
  ;  print, tmp
  ;  x = fix(tmp[0]/2)
  ;  y = fix(tmp[0]/2)
  x = fix(event.x)/2
  y = fix(event.y)/2
  ;print, x, y
  
  
  ;help, (*(*global).pane[fn]).statusX
  ; id = widget_info(Event.top, find_by_uname = 'labX')
  widget_control, (*(*global).pane[fn]).statusX, set_value= 'X: ' +string(x)
  ; id = widget_info(Event.top, find_by_uname = 'labY')
  widget_control, (*(*global).pane[fn]).statusY, set_value= 'Y: ' +string(y)
  ; id = widget_info(Event.top, find_by_uname = 'labZ')
  
  ; id = widget_info(Event.top, find_by_uname = 'txtX')
  widget_control, (*(*global).pane[fn]).txtX, get_value=tmp
  if (x lt fix(tmp)) then begin
    ;  id = widget_info(Event.top, find_by_uname = 'txtY')
    widget_control, (*(*global).pane[fn]).txtY, get_value=tmp
    if (y lt fix(tmp)) then begin
      widget_control, Event.top, get_uvalue=global
      data = *(*(*global).file[fn]).data
      ; id = widget_info(Event.top, find_by_uname = 'labZ')
      widget_control, (*(*global).pane[fn]).statusZ, set_value= 'Z: '+ string(data[x,y])
    endif else begin
      ;   id = widget_info(Event.top, find_by_uname = 'labZ')
      widget_control, (*(*global).pane[fn]).statusZ, set_value= 'Z: '+ 'Unknown'
    endelse
  endif else begin
    ; id = widget_info(Event.top, find_by_uname = 'labZ')
    widget_control, (*(*global).pane[fn]).statusZ, set_value= 'Z: '+ 'Unknown'
  endelse
END

PRO txtPath, Event, fn
  check, Event, fn
END

PRO txtX, Event, fn
  check, Event, fn
END

PRO txtY, Event, fn
  check, Event, fn
END



PRO plotMP_eventcb
END
