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

;FUNCTION getInfo, Event, tag, value
;  print, 'INFO>>>>>>>>>>>>>>>>>>>>'
;  widget_control, Event.top, get_uvalue=global
;  command = '/SNS/software/sbin/mapinfo'
;  command = command + ' -x ' + (*global).x + ' -y ' + (*global).y
;  command = command + ' ' + (*global).path + ' --xml'
;  ;SPAWN,  '/SNS/software/sbin/mapinfo -x 256 -y 304 REF_L_TS_2006_08_10.dat --xml', listen, erlisten
;  print, command
;  SPAWN,  command, listen, erlisten
;  listen = STRCOMPRESS(listen, /REMOVE_ALL)
;
;  for i = 0, n_elements(listen) -1 do begin
;    print, listen[i]
;  endfor
;
;  if erlisten eq '' then begin
;    ;print, listen
;    use_tag = "<"  + tag + ">*</" +tag + ">"
;    index = WHERE(STRMATCH(listen, use_tag, /FOLD_CASE) EQ 1, count)
;    match = listen[index]
;    ;if N_ELEMENTS(value) then begin
;
;    split = STRSPLIT(match, '<>', /EXTRACT)
;    print, split
;    RETURN,  split[1]
;  endif else begin
;    print, '[' + erlisten + ']'
;    return, "error"
;  endelse
;END

PRO plotData, Event, index, fn

  id = widget_info(Event.top, find_by_uname = 'draw')
  if id ne 0 then begin
    widget_control, id , /destroy
  end
  
  widget_control, Event.top, get_uvalue=global
  x = fix((*global).x) *2
  y = fix((*global).y) *2
  
  base_x = x + 20
  base_y = y +120
  if base_x lt 430 then base_x = 430
  if base_y lt 140 then base_y = 140
  
  widget_control, Event.top, YSIZE=base_y
  
  wDraw = WIDGET_DRAW(event.top,$
    xoffset = 5,$
    yoffset = 120,$
    xsize = x+10,$
    ysize = y+10,$
    /MOTION_EVENTS, $
    uname = 'draw')
    
    
  help, x, y
  
  dt_start = ((*(*global).file[fn]).banks[index-1]).offset
  dt_end = ((*(*global).file[fn]).banks[index]).offset - 1
  data = (*(*global).all_data)
  help, dt_start, dt_end
  data = data[dt_start:dt_end]
  data = reform(data, x/2, y/2, /OVERWRITE)
  (*global).data = ptr_new(data)
  
  
  
  ;id = widget_info(Event.top, find_by_uname = 'draw')
  
  
  WIDGET_CONTROL, wDraw, GET_VALUE = ind
  ;widget_control, id, XSIZE = x + 10, YSIZE = y + 10
  ;widget_control,/realize, Event.top
  WSET, ind
  ;help, id, ind
  
  plotdata = rebin(data, x , y)
  ;widget_control,/realize, Event.top
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
  widget_control, Event.top, XSIZE = base_x, YSIZE=base_y
END

;PRO populateDropList, Event

PRO select, Event, fn
  index = event.index
  if index gt 0 then plotData, Event, Index, 0
END

PRO extend, Event
  widget_control, Event.top, XSIZE = 860
  help, event, /structure
  widget_control, event.id, xoffset = 795, set_value = '<<'
  id = widget_info(Event.top, find_by_uname = 'exit')
  widget_control, id, xoffset = 795
  
  
  
  loadFile = widget_button(Event.top,$
    xoffset = 755,$
    yoffset = 5,$
    xsize = 35,$
    ysize = 30,$
    value = '...',$
    uname = 'loadFile1')
    
  Label1 = widget_label(Event.top,$
    /ALIGN_LEFT, $
    /DYNAMIC_RESIZE, $
    xoffset = 400,$
    yoffset = 15,$
    ; xsize = 80,$
    ;ysize = 30,$
    value = 'Select file:',$
    uname = 'label4')
    
  Label2 = widget_label(Event.top,$
    /ALIGN_LEFT, $
    /DYNAMIC_RESIZE, $
    xoffset = 400,$
    yoffset = 50,$
    ;xsize = 140,$
    ;ysize = 30,$
    value = '#X pixels/bank:',$
    uname = 'label5')
    
  Label3 = widget_label(Event.top,$
    /ALIGN_LEFT, $
    /DYNAMIC_RESIZE, $
    xoffset = 610,$
    yoffset = 50,$
    ;xsize = 140,$
    ;ysize = 30,$
    value = '#Y pixels/bank:',$
    uname = 'label6')
    
  txtPath = WIDGET_TEXT(Event.top,$
    xoffset = 490,$
    yoffset = 5,$
    scr_xsize = 260,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtPath1')
    
  txtX= WIDGET_TEXT(Event.top,$
    xoffset = 510,$
    yoffset = 40,$
    scr_xsize = 80,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtX1')
    
  txtY= WIDGET_TEXT(Event.top,$
    xoffset = 710,$
    yoffset = 40,$
    scr_xsize = 80,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtY1')
    
    widget_control, txtPath, set_value = '/SNS/users/dfp/IdlGui/branches/Summer2008/PlotMP/ARCS_TS_2007_10_10.dat'
    widget_control, txtX, set_value = '8'
    widget_control, txtY, set_value = '128'
    
    widget_control, txtPath, /INPUT_FOCUS
END

PRO getData, Event, fn
  widget_control, Event.top, get_uvalue=global
  x = fix((*global).x)
  y = fix((*global).y)
  
  
  
  use_read_binary = 1b
  IF (use_read_binary) THEN BEGIN
    all_data = READ_BINARY((*global).path, $
      ; DATA_DIMS=[x, y],$
      DATA_TYPE = 3)
  ENDIF ELSE BEGIN
    openr,1,(*global).path
    fs=fstat(1)
    N=fs.size                 ; length of the file in bytes
    Nbytes = 4L               ; data are Unit32 = 4 bytes
    N = long(fs.size)/Nbytes
    all_data = lonarr(N) ; create a longword integer array of N elements
    readu,1,all_data
    all_data = reform(all_data, x, y, /OVERWRITE)
  ENDELSE
  close,1
  (*global).all_data = ptr_new(all_data)
  
  
  info = obj_new('getMapInfo',(*global).path)
  infStruct = info ->getInfo(x, y)
  *(*global).file[fn] = infStruct
  
  tmp = string(indgen(infStruct.numbanks + 1))
  tmp[0] = '--'
  id = widget_info(Event.top, find_by_uname = 'select')
  widget_control, id, set_value = tmp
  widget_control, id, sensitive = 1
  widget_control, Event.top, YSIZE= 640
  widget_control, id, /INPUT_FOCUS
  
;plotData, Event
END


PRO graph, Event, fn
  check, Event
END

PRO check, Event, fn
 
 case fn of
0: begin
txtPath = 'txtPath'
txtX = 'txtX' 
txtY =  'txtY'
end
1: begin
txtPath = 'txtPath1'
txtX = 'txtX1' 
txtY =  'txtY1'
end
endcase
 
 
  widget_control, Event.top, get_uvalue=global
  
  flag= 1
  id = widget_info(Event.top, find_by_uname = txtPath)
  widget_control, id, get_value=tmp
  IF tmp NE '' THEN BEGIN
    (*global).path = tmp
    id = widget_info(Event.top, find_by_uname = txtX)
    widget_control, id, get_value=tmp
    IF tmp NE '' THEN BEGIN
      (*global).x = fix(tmp)
      id = widget_info(Event.top, find_by_uname = txtY)
      widget_control, id, get_value=tmp
      IF tmp NE '' THEN BEGIN
        (*global).y = fix(tmp)
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
