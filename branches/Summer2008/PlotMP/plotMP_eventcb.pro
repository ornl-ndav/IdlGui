PRO loadFile, Event
  id = widget_info(Event.top, find_by_uname = 'txtPath')
  tmp = dialog_pickfile(/must_exist, title = 'Select a binary file')
  widget_control, id, set_value = tmp
END

PRO draw, Event
  a=indgen(50,25)
  tvscl,a
;To rebin
; b=rebin(a,50*5,25*10)
; tvscl,b
END

PRO getData, Event
  widget_control, Event.top, get_uvalue=global
  ; file = OBJ_NEW('IDL3columnsASCIIParser', (*global).path)
  openr,1,(*global).path
  print, (*global).path
  fs=fstat(1)
  N=fs.size   ; length of the file in bytes
  Nbytes = 4  ; data are Uint32 = 4 bytes
  N = fs.size/Nbytes
  data = dblarr(N)    ; create a longword integer array of N elements
  ;readu,1,data
  data = READ_BINARY(1)
  close,1
  ;data = REFORM(data, (*global).x, (*global).y, /OVERWRITE)
  help, data
  print, data
;(*global).MyStruct = ptr_new(file -> getData())
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
      (*global).x = tmp
      id = widget_info(Event.top, find_by_uname = 'txtY')
      widget_control, id, get_value=tmp
      IF tmp NE '' THEN BEGIN
        (*global).y = tmp
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
