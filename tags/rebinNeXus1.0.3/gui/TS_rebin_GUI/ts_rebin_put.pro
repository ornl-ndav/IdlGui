PRO put_text_field_value, Event, Uname, Value
TextFieldId = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldId, set_value=Value
END


PRO add_text_field_value, Event, Uname, Value
TextFieldId = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldId, set_value=Value, /append
END




;this function removes from the intial text the given TextToRemove and 
;returns the result.
FUNCTION removeStringFromText, initialText, TextToRemove
;find where the 'textToRemove' starts
step1 = strpos(initialText,TexttoRemove)
;keep the text from the start of the line to the step1 position
step2 = strmid(initialText,0,step1)
return, step2
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
put_text_field_value, Event, 'log_book', FinalStrarr
END




;Put the contain of the string array in the specified text field
PRO putTextFieldArray, Event, uname, array
NbrLines = (size(array))(1)
if (NbrLines GT 1) then begin
    for k=0,(NbrLines-1) do begin
        add_text_field_value, Event, Uname, array[k]
    endfor
endif
END
