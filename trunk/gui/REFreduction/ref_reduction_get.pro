;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
TextFieldID = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldID, get_value = TextFieldValue
RETURN, TextFieldValue
END


;This function returns the contain of the Main Log Book text field
FUNCTION getLogBookText, Event
return, getTextFieldValue(Event,'log_book_text_field')
END


;This function returns the contain of the Data Log Book text field
FUNCTION getDataLogBookText, Event
return, getTextFieldValue(Event, 'data_log_book_text_field')
END


;This function returns the contain of the Normalization Log Book text field
FUNCTION getNormalizationLogBookText, Event
return, getTextFieldValue(Event, 'normalization_log_book_text_field')
END


;This function returns the result of cw_bgroup
FUNCTION getCWBgroupValue, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=value
return, value
END


;This function returns the Reduction Q scale desired (lin or log)
FUNCTION getQScale, Event
id = widget_info(Event.top,find_by_uname='q_scale_b_group')
widget_control, id, get_value=value
if (value EQ 0) then begin
    return, 'lin'
endif else begin
    return, 'log'
endelse
END


;This function gives the Detector angle units (degrees or radians)
FUNCTION getDetectorAngleUnits, Event
id = widget_info(Event.top,find_by_uname='detector_units_b_group')
widget_control, id, get_value=value
if (value EQ 0) then begin
    return, 'degrees'
endif else begin
    return, 'radians'
endelse
END
