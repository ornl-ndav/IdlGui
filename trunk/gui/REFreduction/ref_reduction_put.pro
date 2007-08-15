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
PRO putLogBookMessage, Event, LogBookText, Append=Append
if (n_elements(Append) EQ 0) then begin
    Append = 0
endif else begin
    Append = 1
endelse
putTextFieldValue, Event, 'log_book_text_field', LogBookText, append
END


;display message in Data Log Book
PRO putDataLogBookMessage, Event, DataLogBookText, Append=Append
if (n_elements(append) EQ 0) then begin
    Append = 0
endif else begin
    Append = 1
endelse
putTextFieldValue, Event, 'data_log_book_text_field', DataLogBookText, append
END


;Add the given message at the end of the last string array element and
;put it back in the LogBook text field given
PRO putTextAtEndOfLogBookLastLine, Event, InitialStrarr, MessageToAdd

;get size of InitialStrarr
ArrSize = (size(InitialStrarr))(1)
NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
;put it back in uname text field
putLogBookMessage, Event, FinalStrarr

END
