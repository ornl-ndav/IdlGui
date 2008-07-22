;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro
.run nexus_utilities.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSStransmission GUI
cd, CurrentFolder + '/SANStransmissionGUI/'
.run IDLloadNexus__define.pro
.run make_gui_main_tab.pro
.run make_gui_tab1.pro
.run make_gui_reduce_tab.pro
.run make_gui_fitting.pro
.run IDLnexusFrame__define.pro
.run make_gui_reduce_tab1.pro
.run make_gui_reduce_tab2.pro
.run make_gui_reduce_tab3.pro
.run make_gui_log_book.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run IDLgetMetadata__define.pro
.run IDL3columnsASCIIparser__define.pro
.run sans_transmission_put.pro
.run sans_transmission_get.pro
.run IDLsendToGeek__define.pro
.run IDLgetNexusData__define.pro
.run sans_transmission_plot.pro
.run sans_transmission_gui.pro
.run sans_transmission_time.pro

;procedures
.run sans_transmission_reduce_tab1.pro
.run sans_transmission_reduce_tab2.pro
.run sans_transmission_reduce_tab3.pro
.run sans_transmission_command_line.pro
.run sans_transmission_run_commandline.pro
.run sans_transmission_xroi.pro
.run sans_transmission_xdisplayfile.pro
.run sans_transmission_selection.pro
.run sans_transmission_fitting.pro

;main functions
.run MainBaseEvent.pro
.run sans_transmission_eventcb.pro
.run sans_transmission.pro
