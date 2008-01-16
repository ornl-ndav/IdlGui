;Returns the Run Number from the INPUT base
FUNCTION getEventRunNumber, Event
id = widget_info(Event.top,find_by_uname='run_number')
widget_control, id, get_value=RunNumber
RETURN, strcompress(RunNumber,/remove_all)
END


;Returns the contain of the Event file widget_text (in INPUT base)
FUNCTION getEventFile, Event
id = widget_info(Event.top,find_by_uname='event_file')
widget_control, id, get_value=event_file
RETURN, event_file
END
