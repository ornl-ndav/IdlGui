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
id = widget_info(Event.top, find_by_uname ='instrument_droplist')
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

;Returns the instrument Selected
FUNCTION getInstrument, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
index = getInstrumentSelectedIndex(Event)
instrumentShortList = (*(*global).instrumentShortList)
RETURN, instrumentShortlist[index]
END

;Returns the result of finding or not the prenexus folder of the given
;run number for the given instrument. The prenexus path is also
;returns as an argument
FUNCTION getPreNexus, instrument, RunNumber, prenexus_path
cmd = 'findnexus --prenexus -i' + strcompress(instrument,/remove_all)
cmd += ' ' + strcompress(RunNumber,/remove_all)
spawn, cmd, result, err_listening
if (err_listening[0] NE '') THEN RETURN, 0
IF (STRMATCH(result[0],'ERROR*')) THEN BEGIN
    prenexus_path = ''
    RETURN, 0
ENDIF ELSE BEGIN
    prenexus_path = strcompress(result[0],/remove_all)
    RETURN, 1
ENDELSE
END


;Returns the cvinfo file name of the run number given
FUNCTION get_cvinfo_file_name, Event
;get instrument
instrument = getInstrument(Event)
;get RunNumber
RunNumber = getTextFieldValue(Event, 'cvinfo_run_number_field')
;find preNeXus
result = getPreNexus(instrument, RunNumber, prenexus_path)
IF (result EQ 1) THEN BEGIN
;append cvinfo file name to path found (if found)
    full_cvinfo_file_name = prenexus_path + '/' + instrument
    full_cvinfo_file_name += '_' + strcompress(RunNumber,/remove_all) + '_cvinfo.xml'
;return fileName
    RETURN, full_cvinfo_file_name
ENDIF ELSE BEGIN
    RETURN, ''
ENDELSE
END


;Get the list of geometry files
FUNCTION getGeometryList, instrument
cmd = 'findcalib -g --listall -i' + instrument
spawn, cmd, listening, err_listening
IF (err_listening[0] EQ '') THEN BEGIN
    RETURN, listening
ENDIF ELSE BEGIN
    RETURN, ['']
ENDELSE
END


;Returns the index of the geometry file selected
FUNCTION getGeometrySelectedIndex, Event
id = widget_info(Event.top, find_by_uname ='geometry_droplist')
RETURN, widget_info(id, /droplist_select)
END


;Returns the array of geometry files
FUNCTION getGeometryValue, Event
id = widget_info(Event.top, find_by_uname ='geometry_droplist')
widget_control, id, get_value=array
return, array
END


;Returns the geometry file selected
FUNCTION getGeometryFile, Event
;get global structure
index = getGeometrySelectedIndex(Event)
value = getGeometryValue(Event)
RETURN, value[index]
END


;Returns the path of the output geometry file
FUNCTION get_output_path, Event
RETURN, getTextFieldValue(Event, 'geo_path_text_field')
END


;Returns the name of the output geometry file
FUNCTION get_output_name, Event
RETURN, getTextFieldValue(Event, 'geo_name_text_field')
END


FUNCTION getMotorsIndexOfName, Event, name, motors
ListOfName = motors.name
index = where(ListOfName EQ name)
return, index
end

