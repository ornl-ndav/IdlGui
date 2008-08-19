PRO loadFile, Event
  id = widget_info(Event.top, find_by_uname = 'txtPath')
  tmp = dialog_pickfile(/must_exist, title = 'Select a binary file')
  widget_control, id, set_value = tmp
  check, Event
END

PRO plotData, Event
  widget_control, Event.top, get_uvalue=global
  x = fix((*global).x) *2
  y = fix((*global).y) *2
  
  id = widget_info(Event.top, find_by_uname = 'draw')
  
  help, x, y
  
  base_x = x + 30
  base_y = y +130
  if base_x lt 530 then base_x = 530
  if base_y lt 150 then base_y = 150
  
  widget_control, Event.top, XSIZE=base_x, YSIZE=base_y
  WIDGET_CONTROL, id, GET_VALUE = index
  widget_control, id, XSIZE = x + 10, YSIZE = y + 10
  ;widget_control,/realize, Event.top
  WSET, index
  help, id, index
  
  plotdata = rebin(*(*global).data, x , y)
  ;widget_control,/realize, Event.top
  DEVICE, DECOMPOSED=0
  LOADCT, 5
  tvscl, plotdata
  
  ;Plot grid  
  for y0 = 0, y+10, 5 do begin
    Plots, [0,y0], /device, color = 200
    Plots, [x+10,y0], /device , /continue, color = 200
  endfor
  
  for x0 = 0, x+10, 5 do begin
    Plots, [x0,0], /device, color = 200
    Plots, [x0,y+10], /device , /continue, color = 200
  endfor
 
END

PRO getData, Event
  widget_control, Event.top, get_uvalue=global
  x = fix((*global).x)
  y = fix((*global).y)
  
  use_read_binary = 1b
  IF (use_read_binary) THEN BEGIN
    data = READ_BINARY((*global).path, $
      DATA_DIMS=[x, y],$
      DATA_TYPE = 3)
    help, data
  ENDIF ELSE BEGIN
    openr,1,(*global).path
    fs=fstat(1)
    N=fs.size                 ; length of the file in bytes
    Nbytes = 4L               ; data are Unit32 = 4 bytes
    N = long(fs.size)/Nbytes
    data = lonarr(N) ; create a longword integer array of N elements
    readu,1,data
    data = reform(data, x, y, /OVERWRITE)
  ENDELSE
  close,1
  (*global).data = ptr_new(data)
  plotData, Event
END


PRO graph, Event
  check, Event
END

PRO check, Event
  widget_control, Event.top, get_uvalue=global
  
  flag= 1
  id = widget_info(Event.top, find_by_uname = 'txtPath')
  widget_control, id, get_value=tmp
  IF tmp NE '' THEN BEGIN
    (*global).path = tmp
    id = widget_info(Event.top, find_by_uname = 'txtX')
    widget_control, id, get_value=tmp
    IF tmp NE '' THEN BEGIN
      (*global).x = fix(tmp)
      id = widget_info(Event.top, find_by_uname = 'txtY')
      widget_control, id, get_value=tmp
      IF tmp NE '' THEN BEGIN
        (*global).y = fix(tmp)
        flag = 0
        PRINT, "OK"
        getData, Event
      ENDIF
    ENDIF
  ENDIF
  
  IF flag THEN BEGIN
    widget_control, id, /INPUT_FOCUS
  ENDIF
  
END

PRO draw, Event
  ;help, event, /structure
  ;  tmp = convert_coord(event.x, event.y, /normal, /to_data)
  ;  print, tmp
  ;  x = fix(tmp[0]/2)
  ;  y = fix(tmp[0]/2)
  x = fix(event.x)/2
  y = fix(event.y)/2
  ;print, x, y
  
  id = widget_info(Event.top, find_by_uname = 'labX')
  widget_control, id, set_value= 'X: ' +string(x)
  id = widget_info(Event.top, find_by_uname = 'labY')
  widget_control, id, set_value= 'Y: ' +string(y)
  id = widget_info(Event.top, find_by_uname = 'labZ')
  
  id = widget_info(Event.top, find_by_uname = 'txtX')
  widget_control, id, get_value=tmp
  if (x lt fix(tmp)) then begin
    id = widget_info(Event.top, find_by_uname = 'txtY')
    widget_control, id, get_value=tmp
    if (y lt fix(tmp)) then begin
      widget_control, Event.top, get_uvalue=global
      data = *(*global).data
      id = widget_info(Event.top, find_by_uname = 'labZ')
      widget_control, id, set_value= 'Z: '+ string(data[x,y])
    endif else begin
      id = widget_info(Event.top, find_by_uname = 'labZ')
      widget_control, id, set_value= 'Z: '+ 'Unknown'
    endelse
  endif else begin
    id = widget_info(Event.top, find_by_uname = 'labZ')
    widget_control, id, set_value= 'Z: '+ 'Unknown'
  endelse
END

PRO txtPath, Event
  check, Event
END

PRO txtX, Event
  check, Event
END

PRO txtY, Event
  check, Event
END



PRO plotMP_eventcb
END
