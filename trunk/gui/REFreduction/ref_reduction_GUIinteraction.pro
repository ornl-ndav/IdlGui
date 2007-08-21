PRO  ActivateWidget, Event, uname, ActivateStatus

id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, sensitive=ActivateStatus

END



