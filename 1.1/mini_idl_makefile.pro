;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro
.run nexus_utilities.pro
.run IDLxmlParser__define.pro
.run logger.pro

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

;Build all procedures
cd, CurrentFolder

;utils functions
.run IDL3columnsASCIIparser__define.pro
.run error_message.pro
.run pickcolorname.pro
.run fsc_color.pro
.run sans_reduction_time.pro
.run IDLgetMetadata__define.pro
.run sans_reduction_put.pro
.run sans_reduction_get.pro
.run IDLsendToGeek__define.pro
.run IDLgetNexusData__define.pro
.run sans_reduction_plot.pro
.run sans_reduction_gui.pro
.run sans_reduction_xroi.pro
.run sans_reduction_selection.pro
.run sans_reduction_exclusion.pro
.run sans_reduction_tab_plot.pro

;procedures
.run sans_reduction_reduce_tab1.pro
.run sans_reduction_reduce_tab2.pro
.run sans_reduction_reduce_tab3.pro
.run sans_reduction_command_line.pro
.run sans_reduction_run_commandline.pro
.run sans_reduction_lin_log_plot.pro

;main functions
.run MainBaseEvent.pro
.run sans_reduction_eventcb.pro
.run sans_reduction_build_gui.pro
.run mini_sans_reduction.pro
