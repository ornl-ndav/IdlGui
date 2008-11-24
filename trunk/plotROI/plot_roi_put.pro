;set the value of the specified uname with text
PRO putLabelValue, Event, uname, value
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SET_VALUE=value
END
;-------------------------------------------------------------------------------
PRO putTextFieldValue, Event, uname, value
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SET_VALUE=value
END
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
PRO putStatusMessage, Event, message
putLabelValue, Event, 'status_message', message
END
;-------------------------------------------------------------------------------
PRO putNexusFileName, Event, FileName
putTextFieldValue, Event, 'nexus_file_text_field', FileName
END
;-------------------------------------------------------------------------------
PRO putRoiFileName, Event, FileName
putTextFieldValue, Event, 'roi_text_field', FileName
END
;-------------------------------------------------------------------------------

