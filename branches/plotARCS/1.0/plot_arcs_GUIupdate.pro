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
activateCreateHistoMapButton, Event, activate_status
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
activateCreateHistoMapButton, Event, activate_status
END
