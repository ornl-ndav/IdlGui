;this function will disabled or not the cw_fields and buttons
;if no NeXus has been found
PRO updateDataWidget, Event, isNeXusFound
ActivateWidget, Event, 'data_ymin_label_frame', isNeXusFound
ActivateWidget, Event, 'data_1d_selection', isNeXusFound
ActivateWidget, Event, 'data_d_selection_background_ymin_cw_field', isNeXusFound
ActivateWidget, Event, 'data_d_selection_peak_ymin_cw_field', isNeXusFound
ActivateWidget, Event, 'data_d_selection_background_ymax_cw_field', isNeXusFound
ActivateWidget, Event, 'data_d_selection_peak_ymax_cw_field', isNeXusFound
ActivateWidget, Event, 'data_roi_load_button', isNeXusFound
ActivateWidget, Event, 'data_contrast_droplist', isNeXusFound
ActivateWidget, Event, 'data_contrast_bottom_slider', isNeXusFound
ActivateWidget, Event, 'data_contrast_number_slider', isNeXusFound
ActivateWidget, Event, 'data_reset_contrast_button', isNeXusFound
ActivateWidget, Event, 'data_reset_xaxis_button', isNeXusFound
ActivateWidget, Event, 'data_reset_yaxis_button', isNeXusFound
ActivateWidget, Event, 'data_reset_zaxis_button', isNeXusFound
ActivateWidget, Event, 'data_full_reset_button', isNeXusFound
ActivateWidget, Event, 'data_rescale_z_droplist', isNeXusFound
END




;this function will disabled or not the cw_fields and buttons
;if no NeXus has been found
PRO updateNormWidget, Event, isNeXusFound
ActivateWidget, Event, 'normalization_ymin_label_frame', isNeXusFound
ActivateWidget, Event, 'normalization_1d_selection', isNeXusFound
ActivateWidget, Event, 'normalization_d_selection_background_ymin_cw_field', isNeXusFound
ActivateWidget, Event, 'normalization_d_selection_peak_ymin_cw_field', isNeXusFound
ActivateWidget, Event, 'normalization_d_selection_background_ymax_cw_field', isNeXusFound
ActivateWidget, Event, 'normalization_d_selection_peak_ymax_cw_field', isNeXusFound
ActivateWidget, Event, 'normalization_roi_load_button', isNeXusFound
ActivateWidget, Event, 'normalization_contrast_droplist', isNeXusFound
ActivateWidget, Event, 'normalization_contrast_bottom_slider', isNeXusFound
ActivateWidget, Event, 'normalization_contrast_number_slider', isNeXusFound
ActivateWidget, Event, 'normalization_reset_contrast_button', isNeXusFound
ActivateWidget, Event, 'normalization_reset_xaxis_button', isNeXusFound
ActivateWidget, Event, 'normalization_reset_yaxis_button', isNeXusFound
ActivateWidget, Event, 'normalization_reset_zaxis_button', isNeXusFound
ActivateWidget, Event, 'normalization_full_reset_button', isNeXusFound
ActivateWidget, Event, 'normalizaiton_rescale_z_droplist', isNeXusFound
END



;this function will clear the text field if no nexus has been found
PRO updateDataTextFields, Event, isNeXusFound
if (isNeXusFound) then begin ;NeXus has been found
endif else begin ;Nexus not found
    putTextFieldValue, event, 'data_file_info_text','', 0
    putTextFieldValue, event, 'DATA_left_interaction_help_text','',0
endelse
END


;this function will clear the text field if no nexus has been found
PRO updateNormTextFields, Event, isNeXusFound
if (isNeXusFound) then begin ;NeXus has been found
endif else begin ;Nexus not found
    putTextFieldValue, event, 'normalization_file_info_text','', 0
    putTextFieldValue, event, 'NORM_left_interaction_help_text','',0
endelse
END


;This function will clear the 1D and 2D Data draw if no NeXus found
PRO clearOffDatadisplay, Event, isNeXusFound
if (~isNexusFound) then begin   ;NeXus not found
    
    id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
    widget_control, id_draw, get_value=id_value
    wset,id_value
    erase
    
    id_draw = widget_info(Event.top, find_by_uname='load_data_DD_draw')
    widget_control, id_draw, get_value=id_value
    wset,id_value
    erase
    
endif 
END


;This function will clear the 1D and 2D Normalization draw if no NeXus found
PRO clearOffNormdisplay, Event, isNeXusFound
if (~isNexusFound) then begin   ;NeXus not found
    
    id_draw = widget_info(Event.top, find_by_uname='load_normalization_D_draw')
    widget_control, id_draw, get_value=id_value
    wset,id_value
    erase
    
    id_draw = widget_info(Event.top, find_by_uname='load_normalization_DD_draw')
    widget_control, id_draw, get_value=id_value
    wset,id_value
    erase
    
endif 
END


;****************************** M A I N ****************************
;This function updates the GUI according to the result of Data NeXus
;found or not
PRO RefReduction_update_data_gui_if_NeXus_found, Event, isNeXusFound

updateDataWidget, Event, isNeXusFound ;update cw_fields and buttons
updateDataTextFields, Event, isNeXusFound ;update text_fields contain
clearOffDatadisplay, Event, isNeXusFound ;erase 1D and 2D widget_draw

END

;This function updates the GUI according to the result of Norm NeXus
;found or not
PRO RefReduction_update_normalization_gui_if_NeXus_found, Event, isNeXusFound

updateNormWidget, Event, isNeXusFound ;update cw_fields and buttons
updateNormTextFields, Event, isNeXusFound ;update text_fields contain
clearOffNormdisplay, Event, isNeXusFound ;erase 1D and 2D widget_draw

END


;this function insenstive the Y label framed selected and sensitive
;the other one in Data world
PRO RefReduction_UpdateDataNormGui_reverseDataYminYmaxLabelsFrame, Event

if (isWidgetSensitive(Event, 'data_ymin_label_frame')) then begin
    ActivateWidget, Event, 'data_ymin_label_frame', 0
    ActivateWidget, Event, 'data_ymax_label_frame', 1
endif else begin
    ActivateWidget, Event, 'data_ymin_label_frame', 1
    ActivateWidget, Event, 'data_ymax_label_frame', 0
endelse

END



;this function insenstive the Y label framed selected and sensitive
;the other one in Norm world
PRO RefReduction_UpdateDataNormGui_reverseNormYminYmaxLabelsFrame, Event

if (isWidgetSensitive(Event, 'normalization_ymin_label_frame')) then begin
    ActivateWidget, Event, 'normalization_ymin_label_frame', 0
    ActivateWidget, Event, 'normalization_ymax_label_frame', 1
endif else begin
    ActivateWidget, Event, 'normalization_ymin_label_frame', 1
    ActivateWidget, Event, 'normalization_ymax_label_frame', 0
endelse

END
