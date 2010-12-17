;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = "/utilities"

;unit test
cd, CurrentFolder + '/mgunit'
.run assert.pro

cd, CurrentFolder + IDLUtilitiesPath
.run get_ucams.pro
.run fsc_color.pro
.run get.pro
.run gui.pro
.run is.pro
.run logger.pro
.run put.pro
.run set.pro
.run time.pro
.run xdisplayfile.pro
.run system.pro
.run convert.pro
.run check.pro

;build GUI
cd, CurrentFolder + '/SOS_GUI'
.run design_tabs.pro
.run menu_designer.pro

;build main routines and tests
cd, CurrentFolder

;main functions
.run data_norm_eventcb.pro
.run load_rtof_file.pro
.run colorbar.pro
.run IDLnexusUtilities__define.pro
.run IDLxmlParser__define.pro
.run IDL3columnsASCIIparser__define.pro
.run conversion.pro
.run browse_nexus_button.pro
.run convert_to_qxqz.pro
.run check_gui.pro
.run produce_metadata_structure.pro
.run produce_rtof_metadata_structure.pro
.run display_images.pro
.run error_dialog_message.pro
.run create_structure_data.pro

;test
.run IDLnexusUtilitiesTest__define.pro
.run IDLxmlParserTest__define.pro
.run IDLsystemTest__define.pro

;main routines	
;.run xcw_direct.pro
;.run xcr_direct.pro
;.run SNS_convert_QXQZ.pro
;.run SNS_convert_THLAM.pro
;.run sns_divide_spectrum.pro
;.run SNS_extract_specular.pro
;.run SNS_read_NEXUS.pro
;.run SNS_offspec_QXQZ_from_NEXUS_looper_NEW.pro
.run progress_bar_eventcb.pro

.run tab1_table_eventcb.pro
.run data_box_eventcb.pro
.run norm_box_eventcb.pro
.run log_book_eventcb.pro
.run go_nexus_reduction_eventcb.pro
.run go_nexus_reduction.pro
.run final_plot_base.pro
.run save_background.pro
.run plot_colorbar.pro
.run final_plot_eventcb.pro
.run cursor_info_base.pro
.run menu_eventcb.pro
.run counts_vs_axis_base.pro
.run sos_eventcb.pro
.run global_infos_base.pro
.run output_info_base.pro
.run normalization_selection_base.pro

;working with nexus
.run configuration_table_event.pro

;plot of rtof file
.run px_vs_tof_plots_base.pro
.run px_vs_tof_plots_base_eventcb.pro
.run rtof_plot_colorbar.pro
.run rtof_menu_eventcb.pro
.run rtof_cursor_info_base.pro

.run rtof_tab.pro
.run rtof_file_tab.pro
.run go_rtof_reduction_eventcb.pro
.run go_rtof_reduction.pro

;outut tab
.run sample_info_base.pro
.run create_output_tab.pro

.run main_base_event.pro
.run sos.pro
.run sos_cleanup.pro
