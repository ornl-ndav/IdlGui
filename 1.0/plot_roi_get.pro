;Generic function that returns the contain of a text field
FUNCTION getTextFieldValue, Event, uname
id = widget_info(Event.top, find_by_uname=uname)
widget_control, id, get_value = value
RETURN, value
END

;-------------------------------------------------------------------------------
;this function gives the droplist index
FUNCTION getDropListSelectedIndex, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
return, WIDGET_INFO(id, /DROPLIST_SELECT)
END

;-------------------------------------------------------------------------------
;This function returns the number of row
FUNCTION getNbrLines, FileName
cmd = 'wc -l ' + FileName
SPAWN, cmd, result
Split = STRSPLIT(result[0],' ',/EXTRACT)
RETURN, Split[0]
END

;*******************************************************************************
;*******************************************************************************

;This function returns the contain of the run number text field
FUNCTION getRunNumber, Event
RunNumber = getTextFieldValue(Event,'nexus_run_number')
RETURN, STRCOMPRESS(RunNumber,/REMOVE_ALL)
END

;-------------------------------------------------------------------------------
;This function returns the instrument selected
FUNCTION getInstrument, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
InstrumentList = (*global).ListOFInstruments
IndexSelected  = getDropListSelectedIndex(Event,'list_of_instrument')
RETURN, InstrumentList[IndexSelected-1]
END

;-------------------------------------------------------------------------------
;This function returns the full nexus file name
FUNCTION getFullNexusFileName, Event
FullNexusFileName = getTextFieldValue(Event, 'nexus_file_text_field')
RETURN, FullNexusFileName
END

;-------------------------------------------------------------------------------
;This function returns the ROI file name
FUNCTION getRoiFileName, Event
RoiFileName = getTextFieldValue(Event,'roi_text_field')
RETURN, RoiFileName
END

;-------------------------------------------------------------------------------
;This function returns the X and Y array of pixel to exclude
PRO getXYROI, NbrPixelExcluded, StringArray, Xarray, Yarray
NbrRow         = NbrPixelExcluded
FOR i=0,(NbrRow-1) DO BEGIN
    RoiStringArray = STRSPLIT(StringArray[i],'_',/EXTRACT)
    ON_IOERROR, L1
    Xarray[i] = Fix(RoiStringArray[1])
    Yarray[i] = Fix(RoiStringArray[2])
ENDFOR
L1: error_status = 1
END

;-------------------------------------------------------------------------------
;this function gives from the droplist the value selected
FUNCTION getDropListSelectedValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
index = WIDGET_INFO(id, /DROPLIST_SELECT)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value[index]
END
