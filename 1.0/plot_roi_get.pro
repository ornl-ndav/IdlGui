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

