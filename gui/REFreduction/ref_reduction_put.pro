;set the value of the specified uname with text
PRO putTextFieldValue, event, uname, text, append
TextFieldId = widget_info(Event.top,find_by_uname=uname)
if (append) then begin
    widget_control, TextFieldId, set_value=text,/append
endif else begin
    widget_control, TextFieldId, set_value=text
endelse
END


;display message in Main Log Book
PRO putLogBookMessage, Event, LogBookText, append=1
putTextFieldValue, Event, 'log_book_text_field', LogBookText, append
END


;display message in Data Log Book
PRO putDataLogBookMessage, Event, DataLogBookText, append=1
putTextFieldValue, Event, 'data_log_book_text_field', DataLogBookText, append
END
