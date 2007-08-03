PRO putValueInTextField, Event, $
                         uname, $
                         value

uname_id = widget_info(Event.top,find_by_uname=uname)
widget_control, uname_id, set_value=value

END
