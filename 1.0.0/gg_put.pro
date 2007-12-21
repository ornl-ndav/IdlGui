;**************** Generic Functions ********************
PRO putInTextField, Event, uname, file_name
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=strcompress(file_name)
END


;*************** Particular Functions ********************

;Put the file_name given in the text_fiels specified by the type
;(geometry,cvinfo)
PRO putFileNameInTextField, Event, type, file_name
uname = type + '_text_field'
putInTextField, Event, uname, file_name
END

;name of output geometry file name
PRO putGeometryFileNameInTextField, Event, file_name
uname = 'geo_name_text_field'
putInTextField, Event, uname, file_name
END

PRO putGeometryFileInDroplist, Event
instrument = getInstrument(Event)
GeoArray = getGeometryList(instrument)
id = widget_info(Event.top, find_by_uname='geometry_droplist')
widget_control, id, set_value=GeoArray
id = widget_info(Event.top, find_by_uname='geometry_text_field')
widget_control, id, set_value=GeoArray[0]
END

;name of input xml geometry file
PRO putXmlGeometryFileInTextField, Event, file_name
uname = 'geometry_text_field'
putInTextField, Event, uname, file_name
END
