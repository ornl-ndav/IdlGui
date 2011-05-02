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

.run progress_bar_eventcb.pro
.run tab1_table_eventcb.pro
.run data_box_eventcb.pro
.run norm_box_eventcb.pro
.run log_book_eventcb.pro

cd, CurrentFolder + '/Reduction'
.run go_nexus_reduction_eventcb.pro
.run go_nexus_reduction.pro
.run nexus_reduction_ref_l.pro
.run nexus_reduction_ref_m.pro
.run go_rtof_reduction_eventcb.pro
.run go_rtof_reduction.pro

cd, CurrentFolder + '/FinalPlot'
.run final_plot_base.pro
.run final_plot_help.pro
.run save_background.pro
.run plot_colorbar.pro
.run final_plot_eventcb.pro
.run cursor_info_base.pro
.run menu_eventcb.pro
.run counts_vs_axis_base.pro

cd, CurrentFolder
.run sos_eventcb.pro
.run global_infos_base.pro
.run normalization_selection_base.pro

;working with nexus
.run configuration_table_event.pro

cd, CurrentFolder + '/InputFilesPlots'
.run px_vs_tof_functions.pro
.run info_bases_eventcb.pro
.run px_vs_tof_plots_input_files_base.pro
.run px_vs_tof_plots_input_files.pro
.run info_bases.pro
.run px_vs_tof_cursor_info_base.pro
.run counts_vs_axis_base.pro
.run px_vs_tof_draw_eventcb.pro
.run save_px_vs_tof_background.pro
.run counts_vs_xaxis_draw_eventcb.pro
.run counts_vs_yaxis_draw_eventcb.pro
.run counts_vs_axis_draw_eventcb.pro

cd, CurrentFolder
.run px_vs_tof_plots_base.pro
.run px_vs_tof_plots_base_eventcb.pro

cd, CurrentFolder + '/rtof'
.run rtof_plot_colorbar.pro
.run rtof_menu_eventcb.pro
.run rtof_cursor_info_base.pro
.run rtof_tab.pro
.run rtof_file_tab.pro
.run rtof_counts_vs_axis_base.pro

;configuration tab
cd, CurrentFolder + '/refpix'
.run refpix_eventcb.pro
.run refpix_base.pro
.run refpix_colorbar.pro
.run refpix_input_base.pro
.run refpix_counts_vs_pixel_base.pro

cd, CurrentFolder
.run update_main_interface.pro

;outut tab
cd, CurrentFolder + '/output'
.run sample_info_base.pro
.run output_info_base.pro
.run create_output_tab.pro

cd, CurrentFolder
.run main_base_event.pro
.run sos.pro
.run sos_cleanup.pro
