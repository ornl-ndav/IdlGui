;**************** Generic Functions ********************
PRO sensitive_widget, Event, uname, sensitive_status
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, sensitive = sensitive_status
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
                          'geometry_preview']
sz = (size(loading_geometry_uname))(1)
FOR i=0,(sz-1) DO BEGIN
    sensitive_widget, Event, loading_geometry_uname[i], sensitiveStatus
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
sensitive_widget, Event, 'loading_geometry_button', loading_geometry_button_sensitive
END
