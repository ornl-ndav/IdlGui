;**************** Generic Functions ********************
PRO sensitive_widget, Event, uname, sensitive_status
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, sensitive = sensitive_status
END

PRO activateMap, Event, uname , activate_status
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, map=activate_status
END

;*************** Particular Functions ********************

;activate or not most of the widgets of the first base according to
;yes or not an instrument has been selected in the top droplist
PRO update_loading_geometry_gui_sensitivity, Event, sensitiveStatus
loading_geometry_uname = ['geometry_droplist',$
                          'geometry_browse_button',$
                          'geometry_text_field',$
                          'cvinfo_base',$
                          'cvinfo_browse_button',$
                          'cvinfo_text_field',$
                          'cvinfo_preview',$
                          'geometry_preview',$
                          'geometry_frame',$
                          'geometry_label',$
                          'geometry_or_label',$
                          'cvinfo_frame',$
                          'cvinfo_label',$
                          'or_label']
sz = (size(loading_geometry_uname))(1)
FOR i=0,(sz-1) DO BEGIN
    sensitive_widget, Event, loading_geometry_uname[i], sensitiveStatus
ENDFOR
END



PRO ValidateOrNotOutputGeometryFileBase, Event
IF (isGeometryAndCvinfoXmlValide(Event)) THEN BEGIN
    ActivateStatus = 1
ENDIF ELSE BEGIN
    ActivateStatus = 0
ENDELSE
uname_array = ['geo_file_frame',$
               'geo_file_label',$
               'geo_name_label',$
               'geo_name_text_field',$
               'auto_name_with_time_button',$
               'geo_path_label',$
               'geo_path_text_field',$
               'geo_or_label',$
               'geo_path_button']
sz = (size(uname_array))(1)
FOR i=0,(sz-1) DO BEGIN
    sensitive_widget, $
      Event, $
      uname_array[i], $
      ActivateStatus
ENDFOR
END



;activate or not the 'LOADING GEOMETRY' button in the first base
PRO loading_geometry_button_status, Event
;check that the geometry and cvinfo file field are not empty and that
;the files exist
geometry_file_name = getGeometryFileName(Event)
cvinfo_file_name   = getCvinfoFileName(Event)
IF (FILE_TEST(geometry_file_name) AND $
    FILE_TEST(cvinfo_file_name)) THEN BEGIN
    loading_geometry_button_sensitive = 1
ENDIF ELSE BEGIN
    loading_geometry_button_sensitive = 0
ENDELSE
uname_array = ['loading_geometry_button',$
               'geo_name_text_field',$
               'auto_name_with_time_button',$
               'geo_path_text_field',$
               'geo_path_button']
sz = (size(uname_array))(1)
FOR i=0,(sz-1) DO BEGIN
    sensitive_widget, $
      Event, $
      uname_array[i], $
      loading_geometry_button_sensitive
ENDFOR
END

;activate or not the first base
PRO activateFirstBase, Event, activate_status
activateMap, Event, 'loading_geometry_base', activate_status
END

;activate or not the second base
PRO activateSecondBase, Event, activate_status
activateMap, Event, 'input_geometry_base', activate_status
END
