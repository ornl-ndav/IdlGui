PRO PutLogBookMessage, Event, Message

id = widget_info(Event.top,find_by_uname='log_book')
widget_control, id, set_value=Message

END


PRO AppendLogBookMessage, Event, Message

id = widget_info(Event.top,find_by_uname='log_book')
widget_control, id, set_value=Message,/append

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
PRO putTextAtEndOfLogBookLastLine, Event, MessageToAdd, MessageToRemove

id = widget_info(Event.top,find_by_uname='log_book')
widget_control, id, get_value=InitialStrarr

;get size of InitialStrarr
ArrSize = (size(InitialStrarr))(1)
if (n_elements(MessageToRemove) EQ 0) then begin ;do not remove anything from last line
    if (ArrSize GE 2) then begin
        NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
        FinalStrarr = InitialStrarr + MessageToAdd
    endelse
endif else begin ;remove given string from last line
    if (ArrSize GE 2) then begin
        NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1],MessageToRemove)
        NewLastLine += MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
        NewInitialStrarr = removeStringFromText(InitialStrarr,MessageToRemove)
        FinalStrarr = NewInitialStrarr + MessageToAdd
    endelse
endelse

;put it back in uname text field
putLogBookMessage, Event, FinalStrarr
END


PRO PutNexusNameInLabel, Event, NeXusName
id = widget_info(event.top,find_by_uname='nexus_full_path_label')
widget_control, id, set_value=NeXusName
END
