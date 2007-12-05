;**************** Generic Functions ********************

;Returns the contain of a text field
FUNCTION getTextFieldValue, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=value
RETURN, value[0]
END





;*************** Particular Functions ********************

;Returns the index of the instrument selected in the 'loading
;geometry' base
FUNCTION getInstrumentSelectedIndex, Event
id = widget_info(Event.top, find_by_uname = 'instrument_droplist')
RETURN, widget_info(id, /droplist_select)
END

;Returns the full file name of the geoemtry.xml file
FUNCTION getGeometryFileName, Event
RETURN, getTextFieldValue(Event,'geometry_text_field')
END

;Returns the full file name of the cvinfo.xml file
FUNCTION getCvinfoFileName, Event
RETURN, getTextFieldValue(Event,'cvinfo_text_field')
END
