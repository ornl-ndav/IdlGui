;this function will disabled or not the cw_fields and buttons
;if no NeXus has been found
PRO updateDataWidget, Event, isNeXusFound
if (isNeXusFound) then begin    ;NeXus has been found
    ActivateWidget, Event, 'data_roi_save_button', 1
    ActivateWidget, Event, 'data_1d_selection', 1
    ActivateWidget, Event, 'data_d_selection_background_ymin_cw_field', 1
    ActivateWidget, Event, 'data_d_selection_peak_ymin_cw_field', 1
    ActivateWidget, Event, 'data_d_selection_background_ymax_cw_field', 1
    ActivateWidget, Event, 'data_d_selection_peak_ymax_cw_field', 1
    ActivateWidget, Event, 'data_roi_load_button', 1 
endif else begin                ;NeXus not found
    ActivateWidget, Event, 'data_roi_save_button', 0
    ActivateWidget, Event, 'data_1d_selection', 0
    ActivateWidget, Event, 'data_d_selection_background_ymin_cw_field', 0
    ActivateWidget, Event, 'data_d_selection_background_ymax_cw_field', 0
    ActivateWidget, Event, 'data_d_selection_peak_ymin_cw_field', 0
    ActivateWidget, Event, 'data_d_selection_peak_ymax_cw_field', 0
    ActivateWidget, Event, 'data_roi_load_button', 0
endelse
END



;this function will clear the text field if no nexus has been found
PRO updateDataTextFields, Event, isNeXusFound
if (isNeXusFound) then begin ;NeXus has been found
endif else begin ;Nexus not found
    putTextFieldValue, event, 'data_file_info_text','', 0
    putTextFieldValue, event, 'DATA_left_interaction_help_text','',0
endelse
END



;This function will clear the 1D and 2D Data draw if no NeXus found
PRO clearOffDatadisplay, Event, isNeXusFound
if (~isNexusFound) then begin ;NeXus not found



endif 
END



;****************************** M A I N ****************************
;This function updates the GUI according to the result of Data NeXus
;found or not
PRO RefReduction_update_data_gui_if_NeXus_found, Event, isNeXusFound

updateDataWidget, Event, isNeXusFound ;update cw_fields and buttons
updateDataTextFields, Event, isNeXusFound ;update text_fields contain

END

;This function updates the GUI according to the result of Norm NeXus
;found or not
PRO RefReduction_update_normalization_gui_if_NeXus_found, Event, isNeXusFound

END

