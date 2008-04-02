;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
TextFieldID = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldID, get_value = TextFieldValue
RETURN, TextFieldValue
END


FUNCTION getLogBookText, Event
id = widget_info(Event.top,find_by_uname='log_book')
widget_control, id, get_value=text
RETURN, text
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


FUNCTION getCountsToExcludeValue, Event
value =  getTextFieldValue(Event, 'counts_exclusion')
RETURN, value
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


FUNCTION getOuptoutAsciiFileName, Event
id = widget_info(Event.top,find_by_uname='output_counts_vs_tof_file_name_text')
widget_control, id, get_value=value
RETURN, value
END


FUNCTION getReduceRunNumber, Event, type
CASE (type) OF
    'rsdf': uname = 'rsdf_run_number_cw_field'
    'bdf' : uname = 'bdf_run_number_cw_field'
    'ndf' : uname = 'ndf_run_number_cw_field'
    'ecdf': uname = 'ecdf_run_number_cw_field'
    'dsb' : uname = 'dsb_run_number_cw_field'
ENDCASE
RunNumber = getTextFieldValue(Event, uname)
RETURN, strcompress(RunNumber,/remove_all)
END


FUNCTION getLabelValue, Event, uname
RETURN, getTextFieldValue(Event, uname)
END


FUNCTION getExcludedPixelSymbol, Event
id = widget_info(Event.top,find_by_uname='excluded_pixel_type')
widget_control, id, get_value=value
RETURN, value
END




;retrieve the first run number from the list of nexus
FUNCTION getDRrunNumber, Event
List =  getTextFieldValue(Event,'rsdf_list_of_runs_text')

;get the first nexus file name
FirstSplit = strsplit(List,',',/extract)
FirstNexus = FirstSplit[0]

;get the nexus file name only
SecondSplit = strsplit(FirstNexus,'/',/extract)
sz = (size(secondSplit))(1)
NexusNameOnly = SecondSplit[sz-1]

;split using '_'
ThirdSplit = strsplit(NexusNameOnly,'_',/extract)
RunNumber1 = ThirdSplit[1]

;split using '.'
FourthSplit = strsplit(RunNUmber1,'.',/extract)
RunNumber = FourthSplit[0]

return, RunNumber
end




FUNCTION getXmlConfigFileName, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

output_file_name = getTextFieldValue(Event, 'of_list_of_runs_text')
IF (output_file_name EQ '') THEN BEGIN

;get run number used by Data Reduction
    run_number = getDRrunNumber(Event)
    output_file_name = 'BSS_' + strcompress(run_number,/remove_all)
    output_file_name += (*global).DR_xml_config_ext

;get path
    cd, CURRENT=current_path
    output_file_name = current_path + '/' + output_file_name

ENDIF ELSE BEGIN
    
;get path (if any)
    pathArray = strsplit(output_file_name,'/',/extract)
    sz = (size(pathArray))(1)
    if (sz GT 1) then begin     ;a path has been given
        
;if left part is '~' or '/' do not do anything
        IF (pathArray[0] EQ '~' OR $
            strmatch(output_file_name,'/*')) THEN BEGIN ;nothing to do here
            
        endif else begin

;get current path
            cd, CURRENT=current_path
            output_file_name = current_path + '/' + output_file_name
            
        endelse
        
    endif else begin            ;just a file name
        
;get current path
        cd, CURRENT=current_path
        output_file_name = current_path + '/' + output_file_name
        
    endelse

;remove '.' if any and put (*global).DR_xml_config_ext
dotArray = strsplit(output_file_name,'.',/extract)
output_file_name = dotArray[0]+ (*global).DR_xml_config_ext
    
ENDELSE

RETURN, output_file_name
END

;these two functions are use by the Output tab
FUNCTION getOutputFileNameSelectedIndex, Event
id = widget_info(Event.top, find_by_uname = 'output_file_name_droplist')
RETURN, widget_info(id, /droplist_select)
END

FUNCTION getOutputDroplistFileName, Event
id = widget_info(Event.top, find_by_uname = 'output_file_name_droplist')
widget_control, id, get_value=list
selected_index = getOutputFileNameSelectedIndex(Event)
RETURN, list[selected_index]
END



