;Get value of text field
FUNCTION getTextFieldValue, Event, uname
TextFieldID = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldID, get_value = TextFieldValue
RETURN, TextFieldValue
END


;Get type of bin
FUNCTION getBinType, Event
id = widget_info(Event.top,find_by_uname='bin_type')
widget_control, id, get_vale=value
if (value EQ 0) then begin
    type = 'linear'
endif else begin
    type = 'log'
endelse
RETURNb, type
END
