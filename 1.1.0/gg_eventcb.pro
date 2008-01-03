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
putInTextField, Event, 'status_label', 'Create Geometry File ... (PROCESSING)'
putInTextField, EVENt, 'debug_text_field', ''
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
spawn, cmd, listening, err_listening
IF (err_listening[0] NE '') THEN BEGIN ;an error occured
    text = 'Process FAILED !'
    putInTextField, Event, 'status_label', text
    putInTextField, EVENt, 'debug_text_field', err_listening
ENDIF ELSE BEGIN ;it works 
    text = 'Geometry file created with SUCCESS (' + full_output_geo_name + ')'
    putInTextField, Event, 'status_label', text
    putInTextField, EVENt, 'debug_text_field', ''
ENDELSE
;desactivate loading_geometry_button
sensitive_widget, Event, 'loading_geometry_button', 0
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
    geometry_file = getGeometryFileName(Event)
    cvinfo_file   = getCvinfoFileName(Event)
;run TS_geom_calc.sh
    cmd = (*global).ts_geom_calc_path
    cmd += ' ' + geometry_file
    cmd += ' -m ' + cvinfo_file
    cmd += ' -l ' + (*global).tmp_xml_file
    spawn, cmd
    ReadXmlFile, Event  
;desactivate first base
    activateFirstBase, Event, 0
;activate second base
    activateSecondBase, Event, 1
;desactivate all widgets of base2
    sensitive_widget, Event, 'input_geometry_base', 1
ENDELSE
END


;Reach by the load new base geometry of base #2
;this will display a confirmation base
PRO LoadNewGeometryButton, Event
;activate confirmation base
activateMap, Event, 'confirmation_base', 1
;desactivate all widgets of base2
sensitive_widget, Event, 'input_geometry_base', 0
END


;Reach by the YES button of the confirmation base
PRO YesLoadNewGeometry, Event
;desactivate confirmation base
activateMap, Event, 'confirmation_base', 0
;activate first base
activateMap, Event, 'loading_geometry_base',1
;desactivate second base
activateMap, Event, 'input_geometry_base',0
END


;Reach by the NO button of the confirmation base
PRO NoLoadNewGeometry, Event
;desactivate confirmation base
activateMap, Event, 'confirmation_base', 0
;activate all widgets of base2
sensitive_widget, Event, 'input_geometry_base', 1
END


;Reached by the 'CREATE GEOMETRY FILE' button
PRO CreateNewGeometryFile, Event      ;in gg_evenctb
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;activate confirmation base
activateMap, Event, 'final_result_base', 1
;desactivate all widgets of base2
sensitive_widget, Event, 'input_geometry_base', 0
;display message processing
message = 'Creating geometry file ... ' + (*global).processing
putInTextField, Event, 'final_result_text_field', message
;retrieve value of untouched motor and touched motor data
new_motor = (*(*global).motors)
;isolate values that changed
sz = (size(new_motor))(1)
;get runinfo and geometry file names
geometry_file = getGeometryFileName(Event)
cvinfo_file   = getCvinfoFileName(Event)
cmd = (*global).ts_geom_calc_path
cmd += ' ' + geometry_file
cmd += ' -m ' + cvinfo_file
FOR i=0,(sz-1) DO BEGIN
    new_value = new_motor[i].value
    new_units = new_motor[i].valueUnits
    readback_value = new_motor[i].readback
    readback_units = new_motor[i].readbackUnits
    IF ((new_value NE readback_value) OR $
        (new_units NE readback_units)) THEN BEGIN
        cmd += ' -D ' + new_motor[i].name + '='
        cmd += strcompress(new_value,/remove_all) + $
          strcompress(new_units,/remove_all)
    ENDIF
ENDFOR
;get output path
outputPath     = get_output_path(Event)
;get output file name
outputFileName = get_output_name(Event)
cmd += ' -o ' + outputPath + '/' + outputFileName
spawn, cmd, listening, err_listening
err_listening = ['']
IF (err_listening[0] NE 0) THEN BEGIN ;procedure failed
    message = 'Creating geometry file ... ' + (*global).failed
    putInTextField, Event, 'final_result_text_field', message
    message = 'Error log book: '
    appendInTextField, Event, 'final_result_text_field', message
    appendInTextField, Event, 'final_result_text_field', err_listening
ENDIF else begin                ;procedure worked
    message = 'Creating geometry file ... ' + (*global).ok
    putInTextField, Event, 'final_result_text_field', message
    message = 'File created: ' + outputPath + '/' + outputFileName
    appendInTextField, Event, 'final_result_text_field', message
    ;get Contents of <SNSproblem_log> tab in geometry file created
    FullOutputFileName = '/SNS/users/' + (*global).ucams + '/local/' + outputFileName
    logText = getXmlTagContent(Event, tag_name, FullOutputFileName)
ENDELSE
END



PRO final_result_ok, Event
;activate confirmation base
activateMap, Event, 'final_result_base', 0
;desactivate all widgets of base2
sensitive_widget, Event, 'input_geometry_base', 1
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

