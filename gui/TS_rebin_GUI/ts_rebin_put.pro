PRO put_text_field_value, Event, Uname, Value
TextFieldId = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldId, set_value=Value
END
