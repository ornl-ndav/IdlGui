PRO determine_Geometry_path, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
path  = (*global).output_default_geometry_path
title = 'Select where you want to write the geometry file created:'
path_name = DIALOG_PICKFILE(TITLE             = title,$
                            PATH              = path,$
                            /MUST_EXIST,$
                            /DIRECTORY)
IF (path_name NE '') THEN BEGIN
    putInTextField, Event, 'geo_path_text_field', path_name
ENDIF
END


PRO gg_generate_light_command, Event ;in gg_eventcb
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;;;;;Collect all info necessary
;get geometry input file name
geometry_file    = getGeometryFile(Event)
;get cvinfo file name
cvinfo_file_name = get_cvinfo_file_name(Event)
;get output path
output_geo_path  = get_output_path(Event)
;get output name
output_geo_name  = get_output_name(Event)
;full output name
full_output_geo_name = output_geo_path + '/' + output_geo_name

;start building the command line
cmd = (*global).cmd_command
cmd += ' ' + geometry_file
cmd += ' -m ' + cvinfo_file_name
cmd += ' -o ' + full_output_geo_name
print, cmd
;spawn, cmd, listening, err_listening
err_listening = ['']
IF (err_listening[0] NE '') THEN BEGIN ;an error occured
ENDIF ELSE BEGIN
ENDELSE

END


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


PRO populateNameOfOutputFile, Event, type
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
instrument          = getInstrument(Event)
output_geometry_ext = (*global).output_geometry_ext
default_extension   = (*global).default_extension
IF (type EQ 'run') THEN BEGIN ;ext is with run 'REF_L_10_geom.xml'
    ext           = strcompress((*global).RunNumber,/remove_all)
    IF (ext EQ '') THEN ext = '?'
ENDIF ELSE BEGIN
    ext = gg_GenerateIsoTimeStamp()
ENDELSE
output_file_name    = instrument + output_geometry_ext + $
  '_' + ext + '.' + default_extension
putGeometryFileNameInTextField, Event, output_file_name
END






;Reach by the LOADING GEOMETRY button of the first base
PRO load_geometry, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
IF ((*global).version_light) THEN BEGIN ;version light
    gg_generate_light_command, Event ;in gg_eventcb
ENDIF ELSE BEGIN ;version complete
;desactivate first base
    activateFirstBase, Event, 0
;activate second base
    activateSecondBase, Event, 1
ENDELSE
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

