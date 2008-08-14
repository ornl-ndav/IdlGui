PRO loadFile, Event
  id = widget_info(Event.top, find_by_uname = 'txtPath')
  tmp = dialog_pickfile(/must_exist, title = 'Select a binary file')
  widget_control, id, set_value = tmp
END

PRO draw, Event
;  widget_control, Event.top, get_uvalue=global
;  plotdata = rebin(*(*global).data,(*global).x * 2, (*global).y * 2)
;  tvscl, plotdata
;D = REBIN(D, 250, 250) & TVSCL, D
  
;  a=indgen(50,25)
;  tvscl,a
;To rebin
; b=rebin(a,50*5,25*10)
; tvscl,b
END

PRO plotData, Event
  widget_control, Event.top, get_uvalue=global

  
  print, (*global).x, (*global).y
  id = widget_info(Event.top, find_by_uname = 'draw1')
  x = (*global).x *2 + 20
  y = (*global).y *2 + 20
    print, x, y
  ;widget_control, id, DRAW_XSIZE = 400, DRAW_YSIZE=628
  widget_control, id, SCR_XSIZE = x, SCR_YSIZE = y
  ; help, *(*global).data
  ;plotdata = *(*global).data
  plotdata = rebin(*(*global).data,(*global).x * 2, (*global).y * 2)
  tvscl, plotdata
widget_control, Event.top, $
  XSIZE=((*global).x *2) + 20, YSIZE=((*global).y *2) + 20
END

PRO getData, Event
  widget_control, Event.top, get_uvalue=global
  ; file = OBJ_NEW('IDL3columnsASCIIParser', (*global).path)
  x = fix((*global).x)
  y = fix((*global).y)

  use_read_binary = 1b
  IF (use_read_binary) THEN BEGIN
    data = READ_BINARY((*global).path, $
      DATA_DIMS=[x, y],$
      DATA_TYPE = 3)
    help, data
    ;print, data
  ENDIF ELSE BEGIN
    openr,1,(*global).path
    fs=fstat(1)
    N=fs.size                 ; length of the file in bytes
    Nbytes = 4L               ; data are Unit32 = 4 bytes
    N = long(fs.size)/Nbytes
    data = lonarr(N) ; create a longword integer array of N elements
    readu,1,data
    data = reform(data, x, y, /OVERWRITE)
    ;print, data
  ENDELSE
  close,1
  (*global).data = ptr_new(data)
  plotData, Event
  
; plotdata = rebin(data,(*global).x * 5, (*global).y * 10)
; data = REFORM(data, (*global).x, (*global).y, /OVERWRITE)
; help, data
; print, data
; (*global).MyStruct = ptr_new(file -> getData())
END


PRO graph, Event
  check, Event
END

PRO check, Event
  widget_control, Event.top, get_uvalue=global
  ;  id = widget_info(Event.top, find_by_uname = 'txtPath')
  ;  widget_control, id, get_value=tmp
  ;  (*global).path = tmp
  ;  id = widget_info(Event.top, find_by_uname = 'txtX')
  ;  widget_control, id, get_value=tmp
  ;  (*global).x = tmp
  ;  id = widget_info(Event.top, find_by_uname = 'txtY')
  ;  widget_control, id, get_value=tmp
  ;  (*global).y = tmp
  
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
