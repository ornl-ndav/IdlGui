;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

FUNCTION getTableValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
TextFieldID = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldID, get_value = TextFieldValue
RETURN, TextFieldValue
END

;------------------------------------------------------------------------------
;This function returns the contain of the Text Field for the config file
FUNCTION getTextFieldValueForConfig, Event, uname
TextFieldID = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldID, get_value = TextFieldValue
IF (textFieldValue EQ '') THEN RETURN, 'N/A'
RETURN, TextFieldValue
END

;------------------------------------------------------------------------------
FUNCTION getButtonValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, GET_VALUE=status
RETURN, status
END

;------------------------------------------------------------------------------
FUNCTION getLogBookText, Event
id = widget_info(Event.top,find_by_uname='log_book')
widget_control, id, get_value=text
RETURN, text
END

;------------------------------------------------------------------------------
;this function gives the droplist index
FUNCTION getDropListSelectedIndex, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
RETURN, WIDGET_INFO(id, /DROPLIST_SELECT)
END

;------------------------------------------------------------------------------
FUNCTION getCWBgroupValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
;This function gives the value of the index selected
FUNCTION getDropListSelectedValue, Event, uname
index_selected = getDropListSelectedIndex(Event,uname)
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, GET_VALUE=list
return, list[index_selected]
END

;------------------------------------------------------------------------------

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


FUNCTION getCountsToExcludeValue_lowrange, Event
value =  getTextFieldValue(Event, 'counts_exclusion')
RETURN, value
END

FUNCTION getCountsToExcludeValue_highrange, Event
value =  getTextFieldValue(Event, 'counts_exclusion_2')
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


FUNCTION getReduceRoiFullFileName, Event
FullFileName = getTextFieldValue(Event, 'proif_text')
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

;------------------------------------------------------------------------------
FUNCTION getXmlConfigFileName, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

output_file_name = getTextFieldValue(Event, 'of_list_of_runs_text')
output_file_path = getButtonValue(Event, 'output_folder_name')

IF (output_file_name EQ '') THEN BEGIN

;get run number used by Data Reduction
    run_number = getDRrunNumber(Event)
    output_file_name = 'BSS_' + strcompress(run_number,/remove_all)
    output_file_name += (*global).DR_xml_config_ext

;get path
    current_path     = output_file_path
    output_file_name = current_path + '/' + output_file_name
    
ENDIF ELSE BEGIN

    dotArray = STRSPLIT(output_file_name,'.',/EXTRACT,COUNT=nbr)
    output_file_name = dotArray[0]+ (*global).DR_xml_config_ext
    output_file_name = output_file_path + output_file_name
    
ENDELSE

RETURN, output_file_name
END

;------------------------------------------------------------------------------
FUNCTION getIntermediateFileName, Event, ext
output_file_name = getTextFieldValue(Event, 'of_list_of_runs_text')
output_file_path = getButtonValue(Event, 'output_folder_name')

IF (output_file_name EQ '') THEN BEGIN

;get run number used by Data Reduction
    run_number = getDRrunNumber(Event)
    output_file_name = 'BSS_' + strcompress(run_number,/remove_all)
    output_file_name += ext

;get path
    current_path     = output_file_path
    output_file_name = current_path + output_file_name
    
ENDIF ELSE BEGIN

    dotArray = STRSPLIT(output_file_name,'.',/EXTRACT,COUNT=nbr)
    output_file_name = dotArray[0]+ ext
    output_file_name = output_file_path + output_file_name
    
ENDELSE

RETURN, output_file_name
END

;------------------------------------------------------------------------------
;these two functions are use by the Output tab
FUNCTION getOutputFileNameSelectedIndex, Event
id = widget_info(Event.top, find_by_uname = 'output_file_name_droplist')
RETURN, widget_info(id, /droplist_select)
END

;------------------------------------------------------------------------------
FUNCTION getOutputDroplistFileName, Event
id = widget_info(Event.top, find_by_uname = 'output_file_name_droplist')
widget_control, id, get_value=list
selected_index = getOutputFileNameSelectedIndex(Event)
RETURN, list[selected_index]
END

;------------------------------------------------------------------------------
FUNCTION getMTorNCPvalues, Event
min_value = STRCOMPRESS(getTextFieldValue(Event,'mtha_min_text'),/REMOVE_ALL)
max_value = STRCOMPRESS(getTextFieldValue(Event,'mtha_max_text'),/REMOVE_ALL)
width_value = STRCOMPRESS(getTextFieldValue(Event,'mtha_bin_text'), $
                          /REMOVE_ALL)
RETURN, [min_value,max_value,width_value]
END

;------------------------------------------------------------------------------
;input: ['1 2','3 4','5 6'] 
;output:[1,3,5]
FUNCTION getValueOnly, data
nbr_column = (size(data))(1) ;nbr Energies (ex: 1000)
nbr_row    = (size(data))(2) ;nbr Qs (ex: 20)
new_data   = FLTARR(nbr_column, nbr_row)

index_row = 0
WHILE (index_row LT nbr_row) DO BEGIN
    index_column = 0
    WHILE (index_column LT nbr_column) DO BEGIN
        value = STRSPLIT(data[index_column,index_row],' ',/EXTRACT)
        IF (value[0] EQ 'nan') THEN value[0] = !VALUES.F_NAN
        new_data[index_column,index_row] = FLOAT(value[0])
        index_column++
    ENDWHILE
    index_row++
ENDWHILE
RETURN, new_data
END

;------------------------------------------------------------------------------
FUNCTION getFileExt, file_name
file_array = STRSPLIT(file_name,'.',/EXTRACT,COUNT=nbr)
IF (nbr GT 1) THEN RETURN, file_array[nbr-1]
RETURN, ''
END
