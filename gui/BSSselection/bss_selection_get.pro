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


FUNCTION getYValue, Event
id = widget_info(Event.top,find_by_uname='y_value')
widget_control, id, get_value=y
RETURN, y
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
FUNCTION getPixelIDfromRoiString, RoiString
RoiStringArray = strsplit(RoiString,'_',/EXTRACT)
bank = RoiStringArray[0]
Y    = Fix(RoiStringArray[1])
X    = Fix(RoiStringArray[2])

IF (bank EQ 'bank1') THEN BEGIN
    pixel_offset = 0
ENDIF ELSE BEGIN
    pixel_offset = 4096
ENDELSE

pixelid = pixel_offset + Y * 64 + X
RETURN, pixelid
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


FUNCTION getNbrLines, FileName
cmd = 'wc -l ' + FileName
spawn, cmd, result
Split = strsplit(result[0],' ',/extract)
RETURN, Split[0]
END

