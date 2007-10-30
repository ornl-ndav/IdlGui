PRO activate_button, event, uname, activate_status
id = widget_info(event.top,find_by_uname=uname)
widget_control, id, sensitive=activate_status
END
