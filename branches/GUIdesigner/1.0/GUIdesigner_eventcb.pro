PRO button1_Click, Event
  widget_control, Event.top, get_uvalue=global
  ;(*global).path = DIALOG_PICKFILE(/MUST_EXIST,/READ)
  print, (*global).path
  getData,Event
  data = (*(*(*global).MyStruct).data).data
  help, data
  print, *data[0]
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
  print, "haha"
END
