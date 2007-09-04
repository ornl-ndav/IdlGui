PRO  ActivateWidget, Event, uname, ActivateStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, sensitive=ActivateStatus
END


PRO MapBase, Event, uname, MapStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, map=MapStatus
END


PRO SetCWBgroup, Event, uname, value
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=value
END


PRO SetButtonValue, Event, uname, text
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=text
END

