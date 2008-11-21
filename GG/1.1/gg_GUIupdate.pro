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

PRO gg_GuiUpdate_selectPreviewButtons, Event
gg_GuiUpdate_selectGeometryPreviewButton, Event
gg_GuiUpdate_selectCvinfoPreviewButton, Event
END


PRO gg_GuiUpdate_selectGeometryPreviewButton, Event
IF (getTextFieldValue(Event,'geometry_text_field') NE '') THEN BEGIN
    sensitive_widget, Event, 'geometry_preview', 1
ENDIF ELSE BEGIN
    sensitive_widget, Event, 'geometry_preview', 0
ENDELSE
END


PRO gg_GuiUpdate_selectCvinfoPreviewButton, Event
text = getTextFieldValue(Event,'cvinfo_text_field')
IF (text EQ '' OR $
    strmatch(text,'*CAN NOT BE FOUND*')) THEN BEGIN
    sensitive_widget, Event, 'cvinfo_preview', 0
ENDIF ELSE BEGIN
    sensitive_widget, Event, 'cvinfo_preview', 1
ENDELSE
END



;activate or not most of the widgets of the first base according to
;yes or not an instrument has been selected in the top droplist
PRO update_loading_geometry_gui_sensitivity, Event, sensitiveStatus
loading_geometry_uname = ['geometry_droplist',$
                          'geometry_browse_button',$
                          'geometry_text_field',$
                          'cvinfo_base',$
                          'cvinfo_browse_button',$
                          'cvinfo_text_field',$
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
               'geo_path_button',$
               'loading_geometry_button']
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
    FILE_TEST(cvinfo_file_name) AND $
    isOutputGeometryPathValidate(Event)) THEN BEGIN
    loading_geometry_button_sensitive = 1
ENDIF ELSE BEGIN
    loading_geometry_button_sensitive = 0
ENDELSE
uname_array = ['loading_geometry_button']
sensitive_widget, $
  Event, $
  uname_array[0], $
  loading_geometry_button_sensitive
END


;activate or not the first base
PRO activateFirstBase, Event, activate_status
activateMap, Event, 'loading_geometry_base', activate_status
END


;activate or not the second base
PRO activateSecondBase, Event, activate_status
activateMap, Event, 'input_geometry_base', activate_status
END


;populate table
PRO populateTable, Event, FinalArray
id = widget_info(Event.top,find_by_uname='table_widget')
widget_control, id, set_value=FinalArray
END


;number of lines in Table
PRO TableNbrLines, Event, nbrLines
id = widget_info(Event.top,find_by_uname='table_widget')
widget_control, id, table_ysize=nbrLines
END


;display the data (name, value, units...) of first element of table
PRO displayDataOfFirstElement, Event, motors

type = (size(motors))(2)

IF (type EQ 8) THEN BEGIN

;retrive value of first element selected
    name           = motors[0].name
    setpoint_value = motors[0].setpoint
    setpoint_units = motors[0].setpointUnits
    readback       = motors[0].readback
    readback_units = motors[0].readbackUnits
    value          = motors[0].value
    value_units    = motors[0].valueUnits
    
ENDIF ELSE BEGIN
    
;retrive value of first element selected
    name           = ''
    setpoint_value = ''
    setpoint_units = ''
    readback       = ''
    readback_units = ''
    value          = ''
    value_units    = ''
    
endelse

;display data
putInTextField, Event, 'name_value', name
putInTextField, Event, 'setpoint_value_label', setpoint_value
putInTextField, Event, 'setpoint_units_label', setpoint_units
putInTextField, Event, 'readback_value_label', readback
putInTextField, Event, 'readback_units_label', readback_units
putInTextField, Event, 'current_value_text_field', value
putInTextField, Event, 'current_units_text_field', value_units

END


;display the value of the selected element
PRO DisplaySelectedElement, Event ;in gg_GUIupdate.pro
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;get line selected
id = widget_info(Event.top,find_by_uname='table_widget')
selection = widget_info(id,/table_select)
columnIndex = selection[1]

motors = (*(*global).motor_group)

name           = motors[columnIndex].name
setpoint_value = motors[columnIndex].setpoint
setpoint_units = motors[columnIndex].setpointUnits
readback       = motors[columnIndex].readback
readback_units = motors[columnIndex].readbackUnits
value          = motors[columnIndex].value
value_units    = motors[columnIndex].valueUnits
;display data
putInTextField, Event, 'name_value', name
putInTextField, Event, 'setpoint_value_label', setpoint_value
putInTextField, Event, 'setpoint_units_label', setpoint_units
putInTextField, Event, 'readback_value_label', readback
putInTextField, Event, 'readback_units_label', readback_units
putInTextField, Event, 'current_value_text_field', value
putInTextField, Event, 'current_units_text_field', value_units

END



;display the value of the selected element
PRO DisplayGivenElement, Event, $
                         name, $
                         set_v, $
                         set_u, $
                         read_v,$
                         read_u,$
                         value_v,$
                         value_u

;display data
putInTextField, Event, 'name_value', name
putInTextField, Event, 'setpoint_value_label', set_v
putInTextField, Event, 'setpoint_units_label', set_u
putInTextField, Event, 'readback_value_label', read_v
putInTextField, Event, 'readback_units_label', read_u
putInTextField, Event, 'current_value_text_field', value_v
putInTextField, Event, 'current_units_text_field', value_u
END


PRO activateTableGui, Event, activate_status
array = ['table_widget',$
         'reset_selected_element_button',$
         'validate_selected_element_button',$
         'current_value_text_base',$
         'current_units_text_base']
sz = (size(array))(1)
FOR i=0,(sz-1) DO BEGIN
    sensitive_widget, Event, array[i], activate_status
ENDFOR
END

PRO activateTreeGui, Event, activate_status
sensitive_widget, Event, 'tree_widget', activate_status
END


;select first line of table
PRO selectFirstTableLine, Event
id = widget_info(event.top,find_by_uname='table_widget')
widget_control, id, set_table_select=[0,0,0,0]
END


;select root from tree
PRO selectTreeRoot, Event
id = widget_info(event.top,find_by_uname='tree_widget')
widget_control, id, set_tree_select=0
END


;get tree group selected
FUNCTION treeGroupSelected, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
leaf_array = (*(*global).leaf_array)
sz = (size(leaf_array.uname))(1)
FOR i=0,(sz-1) DO BEGIN
    id = widget_info(Event.top,find_by_uname=leaf_array.uname[i])
    index = widget_info(id, /tree_select)
    IF (index) THEN RETURN, leaf_array.name[i]
ENDFOR
RETURN, 'root'
END



