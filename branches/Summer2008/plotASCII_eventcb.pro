PRO loadASCII_Click, Event
  widget_control, Event.top, get_uvalue=global
  ;(*global).path = DIALOG_PICKFILE(/MUST_EXIST,/READ)
  ;print, (*global).path
  getData,Event
  plotData, Event, 0
  
END


;PRO resetZoom_Click, Event
;  ;widget_control, Event.top, get_uvalue=global
;  plotData, Event, 0
;  
;END


PRO draw1_Enter, Event
;  print, 'draw'
;  help, event, /structure
  widget_control, Event.top, get_uvalue=global
  
  CASE (Event.press) OF
  
    0:BEGIN
    tmp = convert_coord(event.x, event.y, /device, /to_data)
    ;   print, "tmpB: " + tmp
    (*global).zoomCrdEnd = [tmp[0], tmp[1]]
    plotData, Event, 1
  END
  1: BEGIN
    tmp = convert_coord(event.x, event.y, /device, /to_data)
    ; print, "tmpE: ", tmp
    (*global).zoomCrdBeg = [tmp[0], tmp[1]]
    
  END
  
END

;print, (*global).zoomCrdBeg
;;print, convert_coord((*global).zoomCrdBeg[0], (*global).zoomCrdBeg[1], /device, /to_data)
;print, (*global).zoomCrdEnd
END

PRO drawBox
END

PRO plotData, Event, resize
print, "PLOTTING>>>"
  widget_control, Event.top, get_uvalue=global
  data = (*(*(*global).MyStruct).data)
  num = (*(*global).MyStruct).Nbrarray
  data = *(data.data)[4]
  x = data[0,*]
  y = data[1,*]
  err = data[2,*]
  id = widget_info(Event.top, find_by_uname = 'draw1')
  WIDGET_CONTROL, id, GET_VALUE = index
  WSET, index
  ; Plot the data
  if (resize eq 1) then begin
    if ((*global).zoomCrdBeg[0] lt (*global).zoomCrdEnd[0]) then begin
      xran = [(*global).zoomCrdBeg[0], (*global).zoomCrdEnd[0]]
    endif else begin
      xran = [(*global).zoomCrdEnd[0], (*global).zoomCrdBeg[0]]
    endelse
    if ((*global).zoomCrdBeg[1] lt (*global).zoomCrdEnd[1]) then begin
      yran = [(*global).zoomCrdBeg[1], (*global).zoomCrdEnd[1]]
    endif else begin
      yran = [(*global).zoomCrdEnd[1], (*global).zoomCrdBeg[1]]
    endelse
    ;yran = [(*global).zoomCrdBeg[1], (*global).zoomCrdEnd[1]]
    ;((*global).zoomCrdBeg - (*global).zoomCrdEnd)
    PLOT, x, y, XRANGE = xran, YRANGE = yran
    ERRPLOT, x, y-err, y+err
    AXIS, YAXIS = 0, YTITLE ='Y-axis Title'
    AXIS, XAXIS = 0, XTITLE ='X-axis Title'
  endif else begin
    PLOT, x, y, XRANGE = [MIN(x), MAX(x)], YRANGE = [MIN(y), MAX(y)]
    ERRPLOT, x, y-err, y+err
    AXIS, YAXIS = 0, YTITLE ='Y-axis Title'
    AXIS, XAXIS = 0, XTITLE ='X-axis Title'
  endelse
END

PRO getData, Event
  widget_control, Event.top, get_uvalue=global
  file = OBJ_NEW('IDL3columnsASCIIParser', (*global).path)
  (*global).MyStruct = ptr_new(file -> getData())
END

PRO txt1_Enter, Event
  widget_control, Event.top, get_uvalue=global
  id = widget_info(Event.top, find_by_uname = 'txt1')
  widget_control, id, get_value=tmp
  (*global).path = tmp
  print, (*global).path
END



PRO plotASCII_eventcb
END
