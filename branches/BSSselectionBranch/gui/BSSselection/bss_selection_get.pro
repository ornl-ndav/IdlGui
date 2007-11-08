;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
TextFieldID = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldID, get_value = TextFieldValue
RETURN, TextFieldValue
END


;This function returns the contain of the nexus run number
FUNCTION getRunNumber, Event
RunNumberID = widget_info(Event.top,find_by_uname='nexus_run_number')
widget_control, RunNumberID, get_value = RunNumber
RETURN, RunNumber
END


FUNCTION getXValue, Event
id = widget_info(Event.top,find_by_uname='x_value')
widget_control, id, get_value=x
return, x
END


FUNCTION getTubeValue, Event
id = widget_info(Event.top,find_by_uname='tube_value')
widget_control, id, get_value=tube
return, tube
END


FUNCTION getYValue, Event
id = widget_info(Event.top,find_by_uname='y_value')
widget_control, id, get_value=y
RETURN, y
END


FUNCTION getRowValue, Event
id = widget_info(Event.top,find_by_uname='row_value')
widget_control, id, get_value=row
return, row
END


FUNCTION getBankvalue, Event
id = widget_info(Event.top,find_by_uname='bank_value')
widget_control, id, get_value=bank
RETURN, bank
END


FUNCTION getPixelIDvalue, Event
id = widget_info(Event.top,find_by_uname='pixel_value')
widget_control, id, get_value=pixelid
RETURN, pixelid
END


FUNCTION getPixelidColorIndex, Event
id = widget_info(Event.top,find_by_uname='pixel_color_index')
widget_control, id, get_value=color
RETURN, color
END


;FUNCTION getPixelIDfromXY, Event, pixelID
FUNCTION getXYfromPixelID, Event, pixelID
IF (pixelID LT 4096) THEN BEGIN
;    bank = 1
ENDIF ELSE BEGIN
;    bank = 2
    pixelid -= 4096
ENDELSE
y = (pixelid MOD 64)
x = (pixelid / 64)
RETURN, [x,y]
END


;this function does the same as the previous one but does not
;touch the pixelid value
;FUNCTION getPixelIDfromXY_Untouched, pixelID
FUNCTION getXYfromPixelID_Untouched, pixelID
IF (pixelID LT 4096) THEN BEGIN
    a = pixelID
ENDIF ELSE BEGIN
    a = pixelid - 4096
ENDELSE
y = (a MOD 64)
x = (a / 64)
RETURN, [x,y]
END


;this function gives the pixelID of the given bank, x and y value
;retrieve from the string type 'bank1_34_4'
FUNCTION getPixelIDfromRoiString, Event, RoiString, display_info, error_status

RoiStringArray = strsplit(RoiString,'_',/EXTRACT)

ON_IOERROR, L1

bank = RoiStringArray[0]
Y    = Fix(RoiStringArray[1])
X    = Fix(RoiStringArray[2])

IF (bank EQ 'bank1') THEN BEGIN
    pixel_offset = 0
ENDIF ELSE BEGIN
    pixel_offset = 4096
ENDELSE
pixelid = pixel_offset + Y * 64 + X

IF (display_info EQ 1) THEN BEGIN
    
    LogBookMessage = '      -> ' + RoiString
    LogBookMessage += ' : => bank: ' + bank
    LogBookMessage += ' , Y: ' + strcompress(Y,/remove_all)
    LogBookMessage += ' , X: ' + strcompress(X,/remove_all) 
    LogBookMessage += ' ==> PixelID: ' + strcompress(pixelid,/remove_all)
    AppendLogBookMessage, Event, LogBookMessage
    
ENDIF

RETURN, pixelid

L1: error_status = 1
return, 0

END


FUNCTION getSelectionBasePixelidText, Event
id = widget_info(Event.top,find_by_uname='pixelid')
widget_control, id, get_value=text
RETURN, text
END


FUNCTION getSelectionBaseRowText, Event
id = widget_info(Event.top,find_by_uname='pixel_row')
widget_control, id, get_value=text
RETURN, text
END


FUNCTION getSelectionBaseTubeText, Event
id = widget_info(Event.top,find_by_uname='tube')
widget_control, id, get_value=text
RETURN, text
END


FUNCTION getRoiPathButtonValue, Event
id = widget_info(Event.top,find_by_uname='roi_path_button')
widget_control, id, get_value=text
RETURN, text
END


FUNCTION getRoiFullFileName, Event
id = widget_info(Event.top,find_by_uname='save_roi_file_text')
widget_control, id, get_value=FullFileName
RETURN, FullFileName
END


FUNCTION getCurrentSelectedMainTab, Event
id = widget_info(Event.top,find_by_uname='main_tab')
RETURN, widget_info(id, /tab_current)
END


FUNCTION getCurrentSelectedCountsVsTofTab, Event
id = widget_info(Event.top,find_by_uname='counts_vs_tof_tab')
RETURN, widget_info(id, /tab_current)
END


FUNCTION getNbrLines, FileName
cmd = 'wc -l ' + FileName
spawn, cmd, result
Split = strsplit(result[0],' ',/extract)
RETURN, Split[0]
END


FUNCTION getLogBookText, Event
return, getTextFieldValue(Event,'log_book')
END


FUNCTION getColorSliderValue, Event
id = widget_info(Event.top,find_by_uname='color_slider')
widget_control, id, get_value=value
RETURN, VALUE
END


FUNCTION getColorDropListSelectedIndex, Event
id = widget_info(Event.top, find_by_uname = 'selection_droplist')
RETURN, widget_info(id, /droplist_select)
END


FUNCTION getColorDropListSelectedValue, Event
id = widget_info(Event.top, find_by_uname = 'selection_droplist')
widget_control, id, get_value=list
selected_index = getColorDropListSelectedIndex(Event)
RETURN, list[selected_index]
END


FUNCTION getLoadctDropListSelectedIndex, Event
id = widget_info(Event.top, find_by_uname = 'loadct_droplist')
RETURN, widget_info(id, /droplist_select)
END


FUNCTION getLinLogValue, Event
id = widget_info(Event.top,find_by_uname='counts_scale_cwbgroup')
widget_control, id, get_value=value
RETURN, value
END


FUNCTION getFullLinLogValue, Event
id = widget_info(Event.top,find_by_uname='full_counts_scale_cwbgroup')
widget_control, id, get_value=value
RETURN, value
END



FUNCTION getgetCountsVsTofMessageToAdd, Event
id = widget_info(Event.top,find_by_uname='output_counts_vs_tof_message_text')
widget_control, id, get_value=value
RETURN, value
END



