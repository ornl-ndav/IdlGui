;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro
.run nexus_utilities.pro
.run IDLxmlParser__define.pro
.run myXMLparser__define.pro
.run logger.pro
.run checking_packages.pro
.run showprogress__define.pro
.run is.pro
.run time.pro
.run get.pro
.run convert.pro
.run colorbar.pro
.run fsc_color.pro
.run xdisplayfile.pro
.run sans_reduction_functions.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/SANSreductionGUI/'
.run IDLloadNexus__define.pro
.run make_gui_main_tab.pro
.run make_gui_tab1.pro
.run make_gui_reduce_tab.pro
.run IDLnexusFrame__define.pro
.run IDLtxtFrame__define.pro
.run make_gui_reduce_tab1.pro
.run make_gui_reduce_tab2.pro
.run make_gui_reduce_tab3.pro
.run make_gui_reduce_jk_tab1.pro
.run make_gui_reduce_jk_tab2.pro
.run make_gui_reduce_jk_tab3.pro
.run make_gui_reduce_jk_tab3_tab1.pro
.run make_gui_reduce_jk_tab3_tab2.pro
.run make_gui_plot.pro
.run make_gui_plot_tab_fitting.pro
.run make_gui_log_book.pro
.run make_gui_transmission_manual_mode_step1.pro
.run make_gui_transmission_manual_mode_step2.pro
.run make_gui_transmission_manual_mode_step3.pro
.run make_gui_transmission_auto_mode.pro
.run make_gui_beam_center_base.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run sans_reduction_inverse_roi.pro
.run IDL3columnsASCIIparser__define.pro
.run error_message.pro
.run pickcolorname.pro
.run fsc_color.pro
.run IDLgetNexusMetadata__define.pro
.run IDLgetMetadata__define.pro
.run sans_reduction_put.pro
.run IDLsendToGeek__define.pro
.run IDLsendLogBook__define.pro
.run IDLgetNexusRunNumber__define.pro
.run sans_reduction_plot.pro
.run sans_reduction_gui.pro
.run sans_reduction_xroi.pro
.run sans_reduction_selection.pro
.run sans_reduction_exclusion.pro
.run sans_reduction_exclusion_sns.pro
.run sans_reduction_load_exclusion_sns.pro
.run sans_reduction_plot_exclusion_roi_sns.pro
.run sans_reduction_auto_exclude_dead_tubes.pro
.run sans_reduction_tab_plot.pro
.run sans_reduction_config__define.pro

;procedures
.run sans_reduction_reduce_tab1.pro
.run sans_reduction_reduce_tab2.pro
.run sans_reduction_reduce_tab3.pro
.run sans_reduction_command_line.pro
.run sans_reduction_run_commandline.pro
.run sans_reduction_lin_log_plot.pro
.run sans_reduction_display_selection_box.pro
.run sans_reduction_display_images.pro

;circle exclusion
.run sans_reduction_circle_exclusion_function.pro
.run sans_reduction_circle_exclusion.pro
.run sans_reduction_circle_exclusion_help_base.pro

;min and max counts of main tab
.run sans_reduction_min_max_counts.pro

;save selection borders
.run sans_reduction_exclusion_borders.pro

;jk reduction
.run sans_reduction_jk_tab1_functions.pro
.run sans_reduction_jk_input.pro
.run sans_reduction_jk_command_line.pro
.run sans_reduction_run_jk_command_line.pro
.run sans_reduction_jk_advanced.pro

;transmission
.run sans_reduction_transmission_manual_eventcb.pro
.run sans_reduction_transmission_launcher_base.pro
.run sans_reduction_transmission_manual_mode.pro
.run sans_reduction_transmission_manual_step1_selection_plot.pro
.run sans_reduction_transmission_manual_step2.pro
.run sans_reduction_transmission_manual_step2_3dview.pro
.run sans_reduction_transmission_manual_step3.pro
.run sans_reduction_transmission_file_name_base.pro

.run sans_reduction_transmission_auto_mode.pro
.run sans_reduction_transmission_auto_mode_routines.pro

;beam center
.run sans_reduction_beam_center_geometry_file.pro
.run sans_reduction_beam_center_functions.pro
.run sans_reduction_beam_center_base.pro
.run sans_reduction_beam_center_display_images.pro
.run sans_reduction_beam_center_tab.pro
.run sans_reduction_beam_center_plot.pro
.run sans_reduction_beam_center_replot.pro
.run sans_reduction_beam_center_plot_selection.pro
.run sans_reduction_beam_center_calculation_range.pro
.run sans_reduction_beam_center_calculation_utilities_functions.pro
.run sans_reduction_beam_center_calculation_functions.pro
.run sans_reduction_beam_center_calculation.pro

;plot tab
.run sans_reduction_plot_tab_widgets.pro
.run sans_reduction_plot_tab_fitting.pro

;tof tools
.run sans_reduction_tof_tools.pro
.run sans_reduction_tof_tools_eventcb.pro

;main functions
.run MainBaseEvent.pro
.run sans_reduction_make_facility_selection.pro
.run sans_reduction_eventcb.pro
.run sans_reduction_build_gui.pro

;build all the iProcedures (iPlot...)
itResolve
