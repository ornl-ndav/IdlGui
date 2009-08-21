;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro
.run nexus_utilities.pro
.run IDLxmlParser__define.pro
.run logger.pro
.run checking_packages.pro
.run showprogress__define.pro
.run is.pro
.run time.pro
.run get.pro
.run convert.pro
.run colorbar.pro
.run fsc_color.pro

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
.run make_gui_plot.pro
.run make_gui_log_book.pro
.run make_gui_transmission_manual_mode_step1.pro
.run make_gui_transmission_manual_mode_step2.pro
.run make_gui_transmission_manual_mode_step3.pro
.run make_gui_transmission_auto_mode.pro
.run make_gui_beam_center_base.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run IDL3columnsASCIIparser__define.pro
.run error_message.pro
.run pickcolorname.pro
.run fsc_color.pro
.run IDLgetMetadata__define.pro
.run sans_reduction_put.pro
.run IDLsendToGeek__define.pro
.run IDLsendLogBook__define.pro
.run IDLgetNexusData__define.pro
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

;procedures
.run sans_reduction_reduce_tab1.pro
.run sans_reduction_reduce_tab2.pro
.run sans_reduction_reduce_tab3.pro
.run sans_reduction_command_line.pro
.run sans_reduction_run_commandline.pro
.run sans_reduction_lin_log_plot.pro
.run sans_reduction_display_selection_box.pro
.run sans_reduction_display_images.pro

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
.run sans_reduction_beam_center_base.pro
.run sans_reduction_beam_center_display_images.pro
.run sans_reduction_beam_center_tab.pro
.run sans_reduction_beam_center_plot.pro
.run sans_reduction_beam_center_replot.pro

;main functions
.run MainBaseEvent.pro
.run sans_reduction_make_facility_selection.pro
.run sans_reduction_eventcb.pro
.run sans_reduction_build_gui.pro

;build all the iProcedures (iPlot...)
itResolve
