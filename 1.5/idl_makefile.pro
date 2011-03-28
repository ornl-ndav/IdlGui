;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run array.pro
.run math_utilities.pro
.run system_utilities.pro
.run time.pro
.run IDLsendLogBook__define.pro
.run IDLsendToGeek__define.pro
.run IDL3columnsASCIIparser__define.pro
.run IDLgetMetadata__define.pro
.run IDLgetMetadata_REF_M__define.pro
.run xdisplayfile.pro
.run findnexus.pro
.run uniq_element_table.pro
.run logger.pro
.run IDLxmlParser__define.pro 
.run fsc_color.pro
.run set.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/REFoffSpecGUI/'
.run MakeGuiInstrumentSelection.pro
.run MakeGuiMainBase.pro
.run MakeGuiStep1.pro
.run MakeGuiReduceStep1.pro
.run MakeGuiReduceStep2.pro
.run MakeGuiReduceStep3.pro
;.run MakeGuiReduceStep4.pro
.run MakeGuiStep2.pro
.run MakeGuiStep3.pro
.run MakeGuiStep4.pro
.run MakeGuiStep4Step1.pro
.run MakeGuiStep4Step2.pro
.run MakeGuiStep4Step2Step1.pro
.run MakeGuiStep4Step2Step2.pro
.run MakeGuiStep4Step2Step3.pro
.run MakeGuiStep5.pro
.run MakeGuiStep6.pro
.run MakeGuiOptions.pro
.run MakeGuiLogBook.pro
.run MakeGuiPlotUtility.pro

;Build Data background ROI selection
cd, CurrentFolder + '/data_background_selection/'
.run data_background_tof_range_selection_eventcb.pro
.run data_background_selection_base.pro
.run data_background_selection_counts_vs_pixel_base.pro
.run data_background_selection_input_base.pro
.run refresh_plot_data_background_selection_colorbar.pro
.run data_background_selection_tool_button_eventcb.pro
.run cursor_info_base.pro
.run data_background_tof_range_selection_base.pro

;Build all procedures
cd, CurrentFolder

;utilities functions
.run ref_off_spec_is.pro
.run ref_off_spec_get.pro
.run ref_off_spec_put.pro
.run ref_off_spec_gui.pro
.run IDLnexusUtilities__define.pro
.run ref_off_spec_retrieve_nexus_data.pro

;procedures
.run colorbar.pro
.run CheckPackages.pro

.run ref_off_spec_full_reset.pro
.run ref_off_spec_job_manager_info_base.pro
.run ref_off_spec_plot_rvsq.pro
.run ref_off_spec_plot_scaled2d.pro
.run ref_off_spec_reduce_step1.pro
.run ref_off_spec_reduce_sangle.pro
.run ref_off_spec_saving_background.pro
.run ref_off_spec_reduce_step2.pro
.run ref_off_spec_reduce_step2_plot_norm.pro
.run ref_off_spec_reduce_step2_roi_selection.pro
;.run ref_off_spec_reduce_step1_save_roi.pro
.run ref_off_spec_reduce_step2_save_roi.pro
.run ref_off_spec_reduce_step2_save_roi_base.pro
.run ref_off_spec_reduce_step1_save_roi_base.pro
.run ref_off_spec_reduce_step2_load_roi.pro
.run ref_off_spec_reduce_step3.pro
.run ref_off_spec_reduce_step3_command_line.pro
.run ref_off_spec_reduce_step3_working_spin_selection_base.pro
.run ref_off_spec_reduce_step3_checking_working_spin_state_base.pro
.run ref_off_spec_browse_ascii.pro
.run ref_off_spec_read_ascii.pro
.run ref_off_spec_plot.pro
.run ref_off_spec_congrid_data.pro
.run ref_off_spec_shifting.pro
.run ref_off_spec_shifting_plot2d.pro
.run ref_off_spec_scaling_step1.pro
.run ref_off_spec_scaling_step1_plot2d.pro
.run ref_off_spec_scaling_step2.pro
.run ref_off_spec_scaling_step2_step1.pro
.run ref_off_spec_scaling_step2_step2.pro
.run ref_off_spec_scaling_step2_step3.pro
.run ref_off_spec_step5.pro
.run ref_off_spec_step5_rescale.pro
.run ref_off_spec_refresh_recap_plot.pro
.run ref_off_spec_step6.pro
.run ref_off_spec_display_buttons.pro
.run packages_required.pro
.run reduce_tab2_scale.pro
.run reduce_tab2_colorbar.pro
.run roi_selection_counts_vs_pixel_base.pro
.run reduce_step2_tof_range_selection.pro
.run ref_off_spec_cleanup.pro

;main functions
.run MainBaseEvent.pro
.run ref_off_spec_eventcb.pro
.run ref_off_spec.pro
