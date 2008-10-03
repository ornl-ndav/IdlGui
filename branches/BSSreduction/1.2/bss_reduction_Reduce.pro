;****************** TAB 1 *************************

;This function is reached by the rsdf_run_number_cw_field (tab#1)
PRO BSSreduction_Reduce_rsdf_run_number_cw_field, Event
BSSreduction_NeXusFullPath, Event, 'rsdf'
END

;This function is reached by the rsdf_nexus_cw_field (tab#1)
PRO BSSreduction_Reduce_rsdf_nexus_cw_field, Event
BSSreduction_AddNexusFullPath, Event, 'rsdf'
END

;This function is reached by the rsdf_list_of_runs_text (tab#1)
PRO BSSreduction_Reduce_rsdf_list_of_runs_text, Event
BSSreduction_UpdateListOfNexus, Event, 'rsdf'
END

;This function is reached by the bdf_run_number_cw_field (tab#1)
PRO BSSreduction_Reduce_bdf_run_number_cw_field, Event
BSSreduction_NeXusFullPath, Event, 'bdf'
END

;This function is reached by the bdf_nexus_cw_field (tab#1)
PRO BSSreduction_Reduce_bdf_nexus_cw_field, Event
BSSreduction_AddNexusFullPath, Event, 'bdf'
END

;This function is reached by the bdf_list_of_runs_text (tab#1)
PRO BSSreduction_Reduce_bdf_list_of_runs_text, Event
BSSreduction_UpdateListOfNexus, Event, 'bdf'
END

;This function is reached by the ndf_run_number_cw_field (tab#1)
PRO BSSreduction_Reduce_ndf_run_number_cw_field, Event
BSSreduction_NeXusFullPath, Event, 'ndf'
END

;This function is reached by the ndf_nexus_cw_field (tab#1)
PRO BSSreduction_Reduce_ndf_nexus_cw_field, Event
BSSreduction_AddNexusFullPath, Event, 'ndf'
END

;This function is reached by the ndf_list_of_runs_text (tab#1)
PRO BSSreduction_Reduce_ndf_list_of_runs_text, Event
BSSreduction_UpdateListOfNexus, Event, 'ndf'
END

;This function is reached by the ecdf_run_number_cw_field (tab#1)
PRO BSSreduction_Reduce_ecdf_run_number_cw_field, Event
BSSreduction_NeXusFullPath, Event, 'ecdf'
END

;This function is reached by the ecdf_nexus_cw_field (tab#1)
PRO BSSreduction_Reduce_ecdf_nexus_cw_field, Event
BSSreduction_AddNexusFullPath, Event, 'ecdf'
END

;This function is reached by the ecdf_list_of_runs_text (tab#1)
PRO BSSreduction_Reduce_ecdf_list_of_runs_text, Event
BSSreduction_UpdateListOfNexus, Event, 'ecdf'
END

;This function is reached by the dsb_run_number_cw_field (tab#1)
PRO BSSreduction_Reduce_dsb_run_number_cw_field, Event
BSSreduction_NeXusFullPath, Event, 'dsb'
END

;This function is reached by the dsb_nexus_cw_field (tab#1)
PRO BSSreduction_Reduce_dsb_nexus_cw_field, Event
BSSreduction_AddNexusFullPath, Event, 'dsb'
END

;This function is reached by the dsb_list_of_runs_text (tab#1)
PRO BSSreduction_Reduce_dsb_list_of_runs_text, Event
BSSreduction_UpdateListOfNexus, Event, 'dsb'
END


;****************** TAB 2 *************************

;This function is reached by the proif_text
PRO BSSreduction_Reduce_proif_text, Event
END

;This function is reached by the agi_list_of_runs_text
PRO BSSreduction_Reduce_aig_list_of_runs_text, Event
END

;This function is reached by the of_list_of_runs_text
PRO BSSreduction_Reduce_of_list_of_runs_text, Event
END

;****************** TAB 3 *************************

;This function is reached by the rdbbase_bank_button
PRO BSSreduction_Reduce_rdbbase_bank_button, Event
END

;This function is reached by the rmcnf_button
PRO BSSreduction_Reduce_rmcnf_button, Event
END

;This function is reached by the verbose_button
PRO BSSreduction_Reduce_verbose_button, Event
END

;This function is reached by the absm_button
PRO BSSreduction_Reduce_absm_button, Event
END

;This function is reached by the nmn_button
PRO BSSreduction_Reduce_nmn_button, Event
END

;This function is reached by the nmec_button
PRO BSSreduction_Reduce_nmec_button, Event
END

;This funciton is reached by the niw_button
PRO BSSreduction_Reduce_niw_button, Event
BSSreduction_EnableOrNotFields, Event, 'niw_button'
END

;This function is reached by the nisw_field
PRO BSSreduction_Reduce_nisw_field, Event
END

;This function is reached by the niew_field
PRO BSSreduction_Reduce_niew_field, Event
END

;This funciton is reached by the te_button
PRO BSSreduction_Reduce_te_button, Event
BSSreduction_EnableOrNotFields, Event, 'te_button'
END

;This function is reached by the te_low_field
PRO BSSreduction_Reduce_te_low_field, Event
END

;This function is reached by the te_high_field
PRO BSSreduction_Reduce_te_high_field, Event
END

;****************** TAB 4 *************************

;This function is reached by the tib_tof_button
PRO BSSreduction_Reduce_tib_tof_button, Event
BSSreduction_EnableOrNotFields, Event, 'tib_tof_button'
END

;This function is reached by the tibtof_channel1_text
PRO BSSreduction_Reduce_tibtof_channel1_text, Event
END

;This function is reached by the tibtof_channel2_text
PRO BSSreduction_Reduce_tibtof_channel2_text, Event
END

;This function is reached by the tibtof_channel3_text
PRO BSSreduction_Reduce_tibtof_channel3_text, Event
END

;This function is reached by the tibtof_channel4_text
PRO BSSreduction_Reduce_tibtof_channel4_text, Event
END

;This function is reached by the tibc_for_sd_button
PRO BSSreduction_Reduce_tibc_for_sd_button, Event
BSSreduction_EnableOrNotFields, Event, 'tibc_for_sd_button'
END

;This function is reached by the tibc_for_sd_value_text
PRO BSSreduction_Reduce_tibc_for_sd_value_text, Event
END

;This function is reached by the tibc_for_sd_error_text
PRO BSSreduction_Reduce_tibc_for_sd_error_text, Event
END

;This function is reached by the tibc_for_bd_button
PRO BSSreduction_Reduce_tibc_for_bd_button, Event
BSSreduction_EnableOrNotFields, Event, 'tibc_for_bd_button'
END

;This function is reached by the tibc_for_bd_value_text
PRO BSSreduction_Reduce_tibc_for_bd_value_text, Event
END

;This function is reached by the tibc_for_bd_error_text
PRO BSSreduction_Reduce_tibc_for_bd_error_text, Event
END

;This function is reached by the tibc_for_nd_button
PRO BSSreduction_Reduce_tibc_for_nd_button, Event
BSSreduction_EnableOrNotFields, Event, 'tibc_for_nd_button'
END

;This function is reached by the tibc_for_nd_value_text
PRO BSSreduction_Reduce_tibc_for_nd_value_text, Event
END

;This function is reached by the tibc_for_nd_error_text
PRO BSSreduction_Reduce_tibc_for_nd_error_text, Event
END

;This function is reached by the tibc_for_nd_button
PRO BSSreduction_Reduce_tibc_for_ecd_button, Event
BSSreduction_EnableOrNotFields, Event, 'tibc_for_ecd_button'
END

;This function is replaced by the tibc_for_ecd_value_text
PRO BSSreduction_Reduce_tibc_for_ecd_value_text, Event
END

;This function is replaced by the tibc_for_ecd_error_text
PRO BSSreduction_Reduce_tibc_for_ecd_error_text, Event
END

;This function is replaced by the tibc_for_scatd_button
PRO BSSreduction_Reduce_tibc_for_scatd_button, Event
BSSreduction_EnableOrNotFields, Event, 'tibc_for_scatd_button'
END

;This function is replaced by the tibc_for_scatd_value_text
PRO BSSreduction_Reduce_tibc_for_scatd_value_text, Event
END

;This function is replaced by the tibc_for_scatd_error_text
PRO BSSreduction_Reduce_tibc_for_scatd_error_text, Event
END

;****************** TAB 5 *************************
;This function is reached by csbss_button
PRO BSSreduction_Reduce_csbss_button, Event
BSSreduction_EnableOrNotFields, Event, 'csbss_button'
END

;This function is reached by csbss_value_text
PRO BSSreduction_Reduce_csbss_value_text, Event
END

;This function is reached by csbss_error_text
PRO BSSreduction_Reduce_csbss_error_text, Event
END



PRO BSSreduction_Reduce_csn_button, Event
BSSreduction_EnableOrNotFields, Event, 'csn_button'
END

;This function is reached by csn_value_text
PRO BSSreduction_Reduce_csn_value_text, Event
END

;This function is reached by csn_error_text
PRO BSSreduction_Reduce_csn_error_text, Event
END


PRO BSSreduction_Reduce_bcs_button, Event
BSSreduction_EnableOrNotFields, Event, 'bcs_button'
END

;This function is reached by bcs_value_text
PRO BSSreduction_Reduce_bcs_value_text, Event
END

;This function is reached by bcs_error_text
PRO BSSreduction_Reduce_bcs_error_text, Event
END


PRO BSSreduction_Reduce_bcn_button, Event
BSSreduction_EnableOrNotFields, Event, 'bcn_button'
END

;This function is reached by bcn_value_text
PRO BSSreduction_Reduce_bcn_value_text, Event
END

;This function is reached by bcn_error_text
PRO BSSreduction_Reduce_bcn_error_text, Event
END


PRO BSSreduction_Reduce_cs_button, Event
BSSreduction_EnableOrNotFields, Event, 'cs_button'
END

;This function is reached by cs_value_text
PRO BSSreduction_Reduce_cs_value_text, Event
END

;This function is reached by cs_error_text
PRO BSSreduction_Reduce_cs_error_text, Event
END


PRO BSSreduction_Reduce_cn_button, Event
BSSreduction_EnableOrNotFields, Event, 'cn_button'
END

;This function is reached by cn_value_text
PRO BSSreduction_Reduce_cn_value_text, Event
END

;This function is reached by cn_error_text
PRO BSSreduction_Reduce_cn_error_text, Event
END
;****************** TAB 6 *************************

;This function is reached by the csfds_button
PRO BSSreduction_Reduce_csfds_button, Event
BSSreduction_EnableOrNotFields, Event, 'csfds_button'
END

;This function is reached by csfds_value_text
PRO BSSreduction_Reduce_csfds_value_text, Event
END

;This function is reached by the tzsp_button
PRO BSSreduction_Reduce_tzsp_button, Event
BSSreduction_EnableOrNotFields, Event, 'tzsp_button'
END

;This function is reached by tzsp_value_text
PRO BSSreduction_Reduce_tzsp_value_text, Event
END

;This function is reached by the tzsp_error_text
PRO BSSreduction_Reduce_tzsp_error_text, Event
END

;This function is reached by the tzop_button
PRO BSSreduction_Reduce_tzop_button, Event
BSSreduction_EnableOrNotFields, Event, 'tzop_button'
END

;This function is reached by the tzop_value_text
PRO BSSreduction_Reduce_tzop_value_text, Event
END

;This function is reached by the tzop_error_text
PRO BSSreduction_Reduce_tzop_error_text, Event
END

;This function is reached by the eha_button
PRO BSSreduction_Reduce_eha_button, Event
BSSreduction_EnableOrNotFields, Event, 'eha_button'
END

;This function is reached by the eha_min_text
PRO BSSreduction_Reduce_eha_min_text, Event
END

;This function is reached by eha_max_text
PRO BSSreduction_Reduce_eha_max_text, Event
END

;This function is reached by eha_bin_text
PRO BSSreduction_Reduce_eha_bin_text, Event
END

;This function is reached by gifw_button
PRO BSSreduction_Reduce_gifw_button, Event
BSSreduction_EnableOrNotFields, Event, 'gifw_button'
END

;This function is reached by gifw_value_text
PRO BSSreduction_Reduce_gifw_value_text, Event
END

;This function is reached by gifw_error_text
PRO BSSreduction_Reduce_gifw_error_text, Event
END

;Momentum Transfer Histogram Axis (1/Angstroms) and Negative Cosine -----------
;Polar
PRO BSSreduction_Reduce_mtha_button, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global
;retrieve current activated flag
;0:momentum transfer/1:negative cosine polar
ButtonValue = getButtonValue(Event) 
IF (ButtonValue EQ 0) THEN BEGIN ;Momentum Transfer Histogram Axis
;first save fields value of Negative Cosine Polar Axis
    MinMaxWidthArray = getMTorNCPvalues(Event)
    (*global).negative_cosine_polar = MinMaxWidthArray
    putMTorNCPvalues, (*global).momentum_transfer_array




;work to do here
















END

;This function is reached by the mtha_min_text
PRO BSSreduction_Reduce_mtha_min_text, Event
END

;This function is reached by mtha_max_text
PRO BSSreduction_Reduce_mtha_max_text, Event
END

;This function is reached by mtha_bin_text
PRO BSSreduction_Reduce_mtha_bin_text, Event
END
;****************** TAB 7 *************************

;This function is reached by waio_button
PRO BSSreduction_Reduce_waio_button, Event
IF (isButtonSelected(Event, 'waio_button')) THEN BEGIN
;select all button of field
button_array = ['woctib_button',$
                'wopws_button',$
                'womws_button',$
                'womes_button',$
                'worms_button',$
                'wocpsamn_button',$
                'wopies_button',$
                'wopets_button',$
                'wolidsb_button']
sz = (size(button_array))(1)
FOR i=0,(sz-1) DO BEGIN
    SetButton, event, button_array[i], 1
ENDFOR
BSSreduction_EnableOrNotFields, Event, 'wocpsamn_button'
ENDIF
END

;This function is reached by woctib_button
PRO BSSreduction_Reduce_woctib_button, Event
IF (isButtonSelected(Event, 'woctib_button') NE 1 AND $
    isButtonSelected(Event, 'waio_button') EQ 1) THEN BEGIN
    SetButton, event, 'waio_button', 0
ENDIF
END

;This function is reached by wopws_button
PRO BSSreduction_Reduce_wopws_button, Event
IF (isButtonSelected(Event, 'wopws_button') NE 1 AND $
    isButtonSelected(Event, 'waio_button') EQ 1) THEN BEGIN
    SetButton, event, 'waio_button', 0
ENDIF
END

;This function is reached by womws_button
PRO BSSreduction_Reduce_womws_button, Event
IF (isButtonSelected(Event, 'womws_button') NE 1 AND $
    isButtonSelected(Event, 'waio_button') EQ 1) THEN BEGIN
    SetButton, event, 'waio_button', 0
ENDIF
END

;This function is reached by womes_button
PRO BSSreduction_Reduce_womes_button, Event
IF (isButtonSelected(Event, 'womes_button') NE 1 AND $
    isButtonSelected(Event, 'waio_button') EQ 1) THEN BEGIN
    SetButton, event, 'waio_button', 0
ENDIF
END

;This function is reached by worms_button
PRO BSSreduction_Reduce_worms_button, Event
IF (isButtonSelected(Event, 'worms_button') NE 1 AND $
    isButtonSelected(Event, 'waio_button') EQ 1) THEN BEGIN
    SetButton, event, 'waio_button', 0
ENDIF
END

;This function is reached by wocpsamn_button
PRO BSSreduction_Reduce_wocpsamn_button, Event
IF (isButtonSelected(Event, 'wocpsamn_button') NE 1 AND $
    isButtonSelected(Event, 'waio_button') EQ 1) THEN BEGIN
    SetButton, event, 'waio_button', 0
ENDIF
BSSreduction_EnableOrNotFields, Event, 'wocpsamn_button'
END


;This function is reached by wa_min_text
PRO BSSreduction_Reduce_wa_min_text, Event
END

;This function is reached by wa_max_text
PRO BSSreduction_Reduce_wa_max_text, Event
END

;This function is reached by wa_bin_width_text
PRO BSSreduction_Reduce_wa_bin_width_text, Event
END

;This function is reached by wopies_button
PRO BSSreduction_Reduce_wopies_button, Event
IF (isButtonSelected(Event, 'wopies_button') NE 1 AND $
    isButtonSelected(Event, 'waio_button') EQ 1) THEN BEGIN
    SetButton, event, 'waio_button', 0
ENDIF
END

;This function is reached by wopets_button
PRO BSSreduction_Reduce_wopets_button, Event
IF (isButtonSelected(Event, 'wopets_button') NE 1 AND $
    isButtonSelected(Event, 'waio_button') EQ 1) THEN BEGIN
    SetButton, event, 'waio_button', 0
ENDIF
END

;This function is reached by wolidsb_button
PRO BSSreduction_Reduce_wolidsb_button, Event
IF (isButtonSelected(Event, 'wolidsb_button') NE 1 AND $
    isButtonSelected(Event, 'waio_button') EQ 1) THEN BEGIN
    SetButton, event, 'waio_button', 0
ENDIF
END

;This function is reached by wodwsm_button
PRO BSSreduction_Reduce_wodwsm_button, Event
IF (isButtonSelected(Event, 'wodwsm_button') NE 1 AND $
    isButtonSelected(Event, 'waio_button') EQ 1) THEN BEGIN
    SetButton, event, 'waio_button', 0
ENDIF
END
