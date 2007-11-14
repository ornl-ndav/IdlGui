;****************** TAB 1 *************************

;This function is reached by the rsdf_run_number_cw_field (tab#1)
PRO BSSselection_Reduce_rsdf_run_number_cw_field, Event
BSSselection_NeXusFullPath, Event, 'rsdf'
END

;This function is reached by the rsdf_nexus_cw_field (tab#1)
PRO BSSselection_Reduce_rsdf_nexus_cw_field, Event
BSSselection_AddNexusFullPath, Event, 'rsdf'
END

;This function is reached by the rsdf_list_of_runs_text (tab#1)
PRO BSSselection_Reduce_rsdf_list_of_runs_text, Event
BSSselection_UpdateListOfNexus, Event, 'rsdf'
END

;This function is reached by the bdf_run_number_cw_field (tab#1)
PRO BSSselection_Reduce_bdf_run_number_cw_field, Event
BSSselection_NeXusFullPath, Event, 'bdf'
END

;This function is reached by the bdf_nexus_cw_field (tab#1)
PRO BSSselection_Reduce_bdf_nexus_cw_field, Event
BSSselection_AddNexusFullPath, Event, 'bdf'
END

;This function is reached by the bdf_list_of_runs_text (tab#1)
PRO BSSselection_Reduce_bdf_list_of_runs_text, Evvent
BSSselection_UpdateListOfNexus, Event, 'bdf'
END

;This function is reached by the ndf_run_number_cw_field (tab#1)
PRO BSSselection_Reduce_ndf_run_number_cw_field, Event
BSSselection_NeXusFullPath, Event, 'ndf'
END

;This function is reached by the ndf_nexus_cw_field (tab#1)
PRO BSSselection_Reduce_ndf_nexus_cw_field, Event
BSSselection_AddNexusFullPath, Event, 'ndf'
END

;This function is reached by the ndf_list_of_runs_text (tab#1)
PRO BSSselection_Reduce_ndf_list_of_runs_text, Event
BSSselection_UpdateListOfNexus, Event, 'ndf'
END

;This function is reached by the ecdf_run_number_cw_field (tab#1)
PRO BSSselection_Reduce_ecdf_run_number_cw_field, Event
BSSselection_NeXusFullPath, Event, 'ecdf'
END

;This function is reached by the ecdf_nexus_cw_field (tab#1)
PRO BSSselection_Reduce_ecdf_nexus_cw_field, Event
BSSselection_AddNexusFullPath, Event, 'ecdf'
END

;This function is reached by the ecdf_list_of_runs_text (tab#1)
PRO BSSselection_Reduce_ecdf_list_of_runs_text, Event
BSSselection_UpdateListOfNexus, Event, 'ecdf'
END

;This function is reached by the dsb_run_number_cw_field (tab#1)
PRO BSSselection_Reduce_dsb_run_number_cw_field, Event
BSSselection_NeXusFullPath, Event, 'dsb'
END

;This function is reached by the dsb_nexus_cw_field (tab#1)
PRO BSSselection_Reduce_dsb_nexus_cw_field, Event
BSSselection_AddNexusFullPath, Event, 'dsb'
END

;This function is reached by the dsb_list_of_runs_text (tab#1)
PRO BSSselection_Reduce_dsb_list_of_runs_text, Event
BSSselection_UpdateListOfNexus, Event, 'dsb'
END


;****************** TAB 11 *************************

;This function is reached by the proif_text
PRO BSSselection_Reduce_proif_text, Event
END

;This function is reached by the agi_list_of_runs_text
PRO BSSselection_Reduce_aig_list_of_runs_text, Event
END

;This function is reached by the of_list_of_runs_text
PRO BSSselection_Reduce_of_list_of_runs_text, Event
END

;****************** TAB 2 *************************

;This function is reached by the rdbbase_bank_button
PRO BSSselection_Reduce_rdbbase_bank_button, Event
END

;This function is reached by the rmcnf_button
PRO BSSselection_Reduce_rmcnf_button, Event
END

;This function is reached by the verbose_button
PRO BSSselection_Reduce_verbose_button, Event
END

;This function is reached by the absm_button
PRO BSSselection_Reduce_absm_button, Event
END

;This function is reached by the nmn_button
PRO BSSselection_Reduce_nmn_button, Event
END

;This function is reached by the nmec_button
PRO BSSselection_Reduce_nmec_button, Event
END

;This function is reached by the nisw_field
PRO BSSselection_Reduce_nisw_field, Event
END

;This function is reached by the niew_field
PRO BSSselection_Reduce_niew_field, Event
END

;****************** TAB 3 *************************

;This function is reached by the tibtof_channel1_text
PRO BSSselection_Reduce_tibtof_channel1_text, Event
END

;This function is reached by the tibtof_channel2_text
PRO BSSselection_Reduce_tibtof_channel2_text, Event
END

;This function is reached by the tibtof_channel3_text
PRO BSSselection_Reduce_tibtof_channel3_text, Event
END

;This function is reached by the tibtof_channel4_text
PRO BSSselection_Reduce_tibtof_channel4_text, Event
END

;This function is reached by the tibc_for_sd_button
PRO BSSselection_Reduce_tibc_for_sd_button, Event
BSSselection_EnableOrNotFields, Event, 'tibc_for_sd_button'
END

;This function is reached by the tibc_for_sd_value_text
PRO BSSselection_Reduce_tibc_for_sd_value_text, Event
END

;This function is reached by the tibc_for_sd_error_text
PRO BSSselection_Reduce_tibc_for_sd_error_text, Event
END

;This function is reached by the tibc_for_bd_button
PRO BSSselection_Reduce_tibc_for_bd_button, Event
BSSselection_EnableOrNotFields, Event, 'tibc_for_bd_button'
END

;This function is reached by the tibc_for_bd_value_text
PRO BSSselection_Reduce_tibc_for_bd_value_text, Event
END

;This function is reached by the tibc_for_bd_error_text
PRO BSSselection_Reduce_tibc_for_bd_error_text, Event
END

;This function is reached by the tibc_for_nd_button
PRO BSSselection_Reduce_tibc_for_nd_button, Event
BSSselection_EnableOrNotFields, Event, 'tibc_for_nd_button'
END

;This function is reached by the tibc_for_nd_value_text
PRO BSSselection_Reduce_tibc_for_nd_value_text, Event
END

;This function is reached by the tibc_for_nd_error_text
PRO BSSselection_Reduce_tibc_for_nd_error_text, Event
END

;This function is reduce by the tibc_for_nd_button
PRO BSSselection_Reduce_tibc_for_ecd_button, Event
BSSselection_EnableOrNotFields, Event, 'tibc_for_ecd_button'
END

;This function is reduce by the tibc_for_ecd_value_text
PRO BSSselection_Reduce_tibc_for_ecd_value_text, Event
END

;This function is reduce by the tibc_for_ecd_error_text
PRO BSSselection_Reduce_tibc_for_ecd_error_text, Event
END

;****************** TAB 4 *************************

;This function is reached by the tzsp_button
PRO BSSselection_Reduce_tzsp_button, Event
BSSselection_EnableOrNotFields, Event, 'tzsp_button'
END

;This function is reached by tzsp_value_text
PRO BSSselection_Reduce_tzsp_value_text, Event
END

;This function is reached by the tzsp_error_text
PRO BSSselection_Reduce_tzsp_error_text, Event
END

;This function is reached by the tzop_button
PRO BSSselection_Reduce_tzop_button, Event
BSSselection_EnableOrNotFields, Event, 'tzop_button'
END

;This function is reached by the tzop_value_text
PRO BSSselection_Reduce_tzop_value_text, Event
END

;This function is reached by the tzop_error_text
PRO BSSselection_Reduce_tzop_error_text, Event
END

;This function is reached by the eha_button
PRO BSSselection_Reduce_eha_button, Event
BSSselection_EnableOrNotFields, Event, 'eha_button'
END

;This function is reached by the eha_min_text
PRO BSSselection_Reduce_eha_min_text, Event
END

;This function is reached by eha_max_text
PRO BSSselection_Reduce_eha_max_text, Event
END

;This function is reached by eha_bin_text
PRO BSSselection_Reduce_eha_bin_text, Event
END

;This function is reached by gifw_button
PRO BSSselection_Reduce_gifw_button, Event
BSSselection_EnableOrNotFields, Event, 'gifw_button'
END

;This function is reached by gifw_value_text
PRO BSSselection_Reduce_gifw_value_text, Event
END

;This function is reached by gifw_error_text
PRO BSSselection_Reduce_gifw_error_text, Event
END

;****************** TAB 5 *************************

;This function is reached by waio_button
PRO BSSselection_Reduce_waio_button, Event
END

;This function is reached by woctib_button
PRO BSSselection_Reduce_woctib_button, Event
END

;This function is reached by wopws_button
PRO BSSselection_Reduce_wopws_button, Event
END

;This function is reached by womws_button
PRO BSSselection_Reduce_womws_button, Event
END

;This function is reached by womes_button
PRO BSSselection_Reduce_womes_button, Event
END

;This function is reached by worms_button
PRO BSSselection_Reduce_worms_button, Event
END

;This function is reached by wocpsamn_button
PRO BSSselection_Reduce_wocpsamn_button, Event
BSSselection_EnableOrNotFields, Event, 'wocpsamn_button'
END

;This function is reached by wopies_button
PRO BSSselection_Reduce_wopies_button, Event
END

;This function is reached by wopets_button
PRO BSSselection_Reduce_wopets_button, Event
END

;This function is reached by wa_min_text
PRO BSSselection_Reduce_wa_min_text, Event
END

;This function is reached by wa_max_text
PRO BSSselection_Reduce_wa_max_text, Event
END

;This function is reached by wa_bin_width_text
PRO BSSselection_Reduce_wa_bin_width_text, Event
END
