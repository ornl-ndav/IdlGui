PRO EnableStep1ClearFile, Event, validate
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

ClearFileId = widget_info(Event.top, find_by_uname='clear_button')
widget_control, ClearFileId, sensitive=validate
END
