;set the value of the specified uname with text
PRO putTextFieldValue, event, uname, text, append
TextFieldId = widget_info(Event.top,find_by_uname=uname)
if (append) then begin
    widget_control, TextFieldId, set_value=text,/append
endif else begin
    widget_control, TextFieldId, set_value=text
endelse
END


;display message in Main Log Book (default is to not append the new message)
PRO putLogBookMessage, Event, LogBookText, Append=Append
if (n_elements(Append) EQ 0) then begin
    Append = 0
endif else begin
    Append = 1
endelse
putTextFieldValue, Event, 'log_book_text_field', LogBookText, append
END


;display message in Data Log Book (default is to not append the new text)
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
;If the optional RemoveString is present, the given String will be
;removed before adding the new MessageToAdd
PRO putTextAtEndOfLogBookLastLine, Event, InitialStrarr, MessageToAdd, RemoveString

;get size of InitialStrarr
ArrSize = (size(InitialStrarr))(1)
if (n_elements(RemoveString) EQ 0) then begin ;do not remove anything from last line
    if (ArrSize GE 2) then begin
        NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
        FinalStrarr = InitialStrarr + MessageToAdd
    endelse
endif else begin ;remove given string from last line
    if (ArrSize GE 2) then begin
        NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1],RemoveString)
        NewLastLine += MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
        NewInitialStrarr = removeStringFromText(InitialStrarr,RemoveString)
        FinalStrarr = NewInitialStrarr + MessageToAdd
    endelse
endelse

;put it back in uname text field
putLogBookMessage, Event, FinalStrarr
END


;Add the given message at the end of the last string array element and
;put it back in the DataLogBook text field given
PRO putTextAtEndOfDataLogBookLastLine, Event, InitialStrarr, MessageToAdd, RemoveString

;get size of InitialStrarr
ArrSize = (size(InitialStrarr))(1)
if (n_elements(RemoveString) EQ 0) then begin ;do not remove anything from last line
    if (ArrSize GE 2) then begin
        NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
        FinalStrarr = InitialStrarr + MessageToAdd
    endelse
endif else begin ;remove given string from last line
    if (ArrSize GE 2) then begin
        NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1],RemoveString)
        NewLastLine += MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSizae-2],NewLastLine]
    endif else begin
        NewInitialStrarr = removeStringFromText(InitialStrarr,RemoveString)
        FinalStrarr = NewInitialStrarr + MessageToAdd
    endelse
endelse
;put it back in uname text field
putDataLogBookMessage, Event, FinalStrarr
END
