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


;Put Bank name (bank1 or bank2) in the cw_field BANK:
PRO PutBankValue, Event, bank
id = widget_info(event.top,find_by_uname='bank_value')
widget_control, id, set_value=strcompress(bank,/remove_all)
END

;Put Bank value (1-2) in the counts_vs_tof label Bank:
PRO PutCountsVsTofBankValue, Event, bank
id = widget_info(event.top,find_by_uname='counts_vs_tof_bank_label')
text = 'Bank: ' + strcompress(bank,/remove_all)
widget_control, id, set_value = text
END


;Put X value (0-55) in the cw_field X:
PRO PutXValue, Event, x
id = widget_info(event.top,find_by_uname='x_value')
widget_control, id, set_value=strcompress(x,/remove_all)
END

;Put X value (0-55) in the counts_vs_tof label X:
PRO PutCountsVsTofXValue, Event, x
id = widget_info(event.top,find_by_uname='counts_vs_tof_x_label')
text = 'X: ' + strcompress(x,/remove_all)
widget_control, id, set_value = text
END


;Put Y value (0-63) in the cw_field Y:
PRO PutYValue, Event, y
id = widget_info(event.top,find_by_uname='y_value')
widget_control, id, set_value=strcompress(y,/remove_all)
END

;Put Y value (0-63) in the counts_vs_tof label Y:
PRO PutCountsVsTofYValue, Event, y
id = widget_info(event.top,find_by_uname='counts_vs_tof_y_label')
text = 'Y: ' + strcompress(y,/remove_all)
widget_control, id, set_value=text
END

;Put row value (0-127) in the cw_field row_value:
PRO PutRowValue, Event, row
id = widget_info(event.top,find_by_uname='row_value')
widget_control, id, set_value=strcompress(row,/remove_all)
END

;Put tube value (0-55 and 64-119) in the cw_field tube_value:
PRO PutTubeValue, Event, tube
id = widget_info(event.top,find_by_uname='tube_value')
widget_control, id, set_value=strcompress(tube,/remove_all)
END

;Put pixelID value (0-9215) in the cw_field PixelID:
PRO PutPixelIDValue, Event, pixelid
id = widget_info(event.top,find_by_uname='pixel_value')
widget_control, id, set_value=strcompress(pixelid,/remove_all)
END

;Put pixelID value (0-9215) in the counts_vs_tof label PixelID:
PRO PutCountsVsTofPixelIDValue, Event, pixelid
id = widget_info(event.top,find_by_uname='counts_vs_tof_pixel_label')
text = 'PixelID: ' + strcompress(pixelid,/remove_all)
widget_control, id, set_value=text
END

;Put counts value of pixel selected in cw_field counts_value:
PRO PutCountsValue, Event, counts
id = widget_info(event.top,find_by_uname='counts_value')
widget_control, id, set_value=strcompress(counts,/remove_all)
END

;Put '' into pixelid cw_field Selection base
PRO ResetSelectionBasePixelidText, Event
id = widget_info(Event.top,find_by_uname='pixelid')
widget_control, id, set_value=''
END

;Put '' into row cw_field Selection base
PRO ResetSelectionBaseRowText, Event
id = widget_info(Event.top,find_by_uname='pixel_row')
widget_control, id, set_value=''
END

;Put '' into tube cw_field Selection base
PRO ResetSelectionBaseTubeText, Event
id = widget_info(Event.top,find_by_uname='tube')
widget_control, id, set_value=''
END

;change label of ROI path button
PRO putRoiPathButtonValue, Event, text
id = widget_info(Event.top,find_by_uname='roi_path_button')
widget_control, id, set_value=text
END

;put the value of the new ROI file
PRO putRoiFileName, Event, fileName
id = widget_info(Event.top,find_by_uname='save_roi_file_text')
widget_control, id, set_value=fileName
END

;put the message text in the message box (selection tab)
PRO putMessageBoxInfo, Event, text
id = widget_info(Event.top,find_by_uname='message_text')
widget_control, id, set_value=text
END

;put the name of the loaded ROI file name
PRO putLoadedRoiFileName, Event, text
id = widget_info(Event.top,find_by_uname='load_roi_file_text')
widget_control, id, set_value=text
END

