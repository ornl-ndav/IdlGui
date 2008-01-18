PRO activateWidget, Event, uname, activate_status
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, sensitive=activate_status
END


PRO activateCreateHistoMapButton, Event, activate_status
id = widget_info(Event.top,find_by_uname='create_histo_mapped_button')
widget_control, id, sensitive=activate_status
END


PRO activateMappingBase, Event, activate_status
uname_array = ['mapping_frame',$
               'mapping_label',$
               'mapping_droplist']
sz = (size(uname_array))(1)
FOR i=0,(sz-1) DO BEGIN
    id = widget_info(Event.top,find_by_uname=uname_array[i])
    widget_control, id, sensitive=activate_status
ENDFOR
END


PRO activateHistogrammingBase, Event, activate_status
uname_array = ['histo_frame',$
               'histo_frame_label',$
               'min_time_bin_label',$
               'min_time_bin',$
               'max_time_bin_label',$
               'max_time_bin',$
               'bin_width_label',$
               'bin_width',$
               'bin_type_label',$
               'bin_type_droplist']
sz = (size(uname_array))(1)
FOR i=0,(sz-1) DO BEGIN
    id = widget_info(Event.top,find_by_uname=uname_array[i])
    widget_control, id, sensitive=activate_status
ENDFOR
END


PRO ActivateHistoMappingBasesStatus, Event
;get value of input event file widget_text
EventFile = getEventFile(Event)
IF(EventFile NE '') THEN BEGIN
    activate_status = 1
ENDIF ELSE BEGIN
    activate_status = 0
ENDELSE
activateHistogrammingBase, Event, activate_status
activateMappingBase, Event, activate_status
END


PRO ActivateHistoMappingBaseFromWidgetText, Event
;get event file name entered in widget_text
EventFile = getEventFile(Event)
IF (FILE_TEST(EventFile)) THEN BEGIN
    activate_status = 1
ENDIF ELSE BEGIN
    activate_status = 0
ENDELSE
activateHistogrammingBase, Event, activate_status
activateMappingBase, Event, activate_status
END


PRO ActivateOrNotCreateHistogramMapped, Event
activate_go_histo_mapped_status = 1
;if there is an event file and file exist
EventFile = getEventFile(Event)
IF (FILE_TEST(EventFile)) THEN BEGIN
;nothing to do, everything is ok so far
ENDIF ELSE BEGIN
    activate_go_histo_mapped_status = 0
ENDELSE
;if the mandatory paramters of the histogram are there
max_time_bin = getTextFieldValue(Event,'max_time_bin')
bin_width    = getTextFieldValue(Event,'bin_width')
IF (max_time_bin NE '' AND bin_width NE '') THEN BEGIN
;nothing to do, everything is ok so far
ENDIF ELSE BEGIN
    activate_go_histo_mapped_status = 0
ENDELSE
;if there is at least one mapping
mapping_file = getMappingFile(Event)
IF (mapping_file NE '') THEN BEGIN
;nothing to do, everything is ok so far
ENDIF ELSE BEGIN
    activate_go_histo_mapped_status = 0
ENDELSE
;activate or not go_histo_mapped
IF (activate_go_histo_mapped_status) THEN BEGIN
    activateCreateHistoMapButton, Event, 1
ENDIF ELSE BEGIN
    activateCreateHistoMapButton, Event, 0
ENDELSE
END


PRO ActivateOrNotPlotButton, Event
;get histo_mapped file name
histo_mapped_file = getTextFieldValue(Event,'histo_mapped_text_field')
IF (FILE_TEST(histo_mapped_file)) THEN BEGIN
    activate_status = 1
ENDIF ELSE BEGIN
    activate_status = 0
ENDELSE
activateWidget, Event, 'plot_button', activate_status
END
