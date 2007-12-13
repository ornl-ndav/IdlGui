PRO clearCvinfoBase, Event
putInTextField, Event, 'cvinfo_run_number_field', ''
putInTextField, Event, 'cvinfo_text_field', ''
END


PRO putSelectedGeometryFileInTextField, Event ;in gg_eventcb.pro
;get Selected Geometry File
geometry_file = getGeometryFile(Event)
;put geometry file in text_field
putXmlGeometryFileInTextField, Event, geometry_file
END


PRO ggEventcb_InstrumentSelection, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;get instrument selected
InstrumentSelectedIndex = getInstrumentSelectedIndex(Event)
;if instrument selected is not 0 then activate 'loading geometry' GUI
IF (InstrumentSelectedIndex EQ 0) THEN BEGIN
    sensitiveStatus = 0
ENDIF ELSE BEGIN
    sensitiveStatus = 1
ENDELSE
update_loading_geometry_gui_sensitivity, Event, sensitiveStatus
instrumentShortList = (*(*global).instrumentShortList)
END


PRO retrieve_cvinfo_file_name, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;show user that program is looking for cvinfo file
;get instrument
instrument = getInstrument(Event)
;get RunNumber
RunNumber = getTextFieldValue(Event, 'cvinfo_run_number_field')
text = 'Sarching for ' 
file_name = instrument + '_' + strcompress(RunNumber,/remove_all) + '_cvinfo.xml'
full_text = text + file_name + ' ...'
putFileNameInTextField, Event, 'cvinfo', full_text
;get cvinfo file name
cvinfo_file_name = get_cvinfo_file_name(Event)
IF (cvinfo_file_name NE '') THEN BEGIN ;display file name found
    putFileNameInTextField, Event, 'cvinfo', cvinfo_file_name
    (*global).RunNumber = RunNumber
ENDIF ELSE BEGIN
    message = file_name + ' CAN NOT BE FOUND'
    putFileNameInTextField, Event, 'cvinfo', message
    (*global).RunNumber = ''
ENDELSE
END


PRO populateNameOfOutputFile, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

instrument          = getInstrument(Event)
output_geometry_ext = (*global).output_geometry_ext
RunNumber           = (*global).RunNumber
IF (RunNumber EQ '') THEN RunNumber = '?'
output_file_name    = instrument + output_geometry_ext + $
  '_' + strcompress(RunNumber,/remove_all) + '.' + (*global).default_extension
putGeometryFileNameInTextField, Event, output_file_name
END






;Reach by the LOADING GEOMETRY button of the first base
PRO load_geometry, Event
;desactivate first base
activateFirstBase, Event, 0
;activate second base
activateSecondBase, Event, 1
END

;------------------------------------------------------------

pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end

pro gg_eventcb, event
end

