;HELPER FUNCTIONS
;this function removes from the intial text the given TextToRemove and 
;returns the result.
FUNCTION removeStringFromText, initialText, TextToRemove
;find where the 'textToRemove' starts
step1 = strpos(initialText,TexttoRemove)
;keep the text from the start of the line to the step1 position
step2 = strmid(initialText,0,step1)
return, step2
END


PRO AddInLogBook, Event, message, Append
id = widget_info(Event.top,find_by_uname='log_book')
IF (Append) THEN BEGIN
    widget_control, id, set_value=message, /append
ENDIF ELSE BEGIN
    widget_control, id, set_value=message
ENDELSE
END


PRO putTextInTextField, Event, uname, text
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=text
END


;========================================================================
;MAIN FUNCTION
PRO putLogBook, Event, message
AddInLogBook, Event, message, 0
END


PRO appendLogBook, Event, message
AddInLogBook, Event, message, 1
END


PRO putStatus, Event, message
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
id = widget_info(Event.top,find_by_uname='status_label')
widget_control, id, set_value= (*global).STATUS + message
END


;Add the given message at the end of the last string array element and
;put it back in the LogBook text field given
;If the optional RemoveString is present, the given String will be
;removed before adding the new MessageToAdd
PRO putTextAtEndOfLogBook, Event, MessageToAdd, MessageToRemove
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
endif else begin                ;remove given string from last line
    if (ArrSize GE 2) then begin
        NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1],MessageToRemove)
        NewLastLine += MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    endif else begin
        NewInitialStrarr = removeStringFromText(InitialStrarr,MessageToRemove)
        FinalStrarr = NewInitialStrarr + MessageToAdd
    endelse
endelse
putLogBook, Event, FinalStrarr
END


;Add the given message at the end of the last string array element and
;put it back in the LogBook text field given
;If the optional RemoveString is present, the given String will be
;removed before adding the new MessageToAdd
PRO putTextAtEndOfStatus, Event, MessageToAdd, MessageToRemove
id = widget_info(Event.top,find_by_uname='status_label')
widget_control, id, get_value=InitialStr
FinalStr= removeStringFromText(InitialStr,MessageToRemove)
FinalStr += ' ' + MessageToAdd
id = widget_info(Event.top,find_by_uname='status_label')
widget_control, id, set_value= FinalStr
END

;-------------------------------------------------------------------------------
;Name of nexus file name label in Nexus tab
PRO putArchivedNexusFileName, Event, message
putTextInTextField, Event, 'archived_text_field'
END

