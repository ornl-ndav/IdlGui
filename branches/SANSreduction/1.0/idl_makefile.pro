;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/SANSreductionGUI/'
.run IDLloadNexus__define.pro
.run make_gui_main_tab.pro
.run make_gui_tab1.pro
.run make_gui_reduce_tab.pro
.run make_gui_log_book.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run sans_reduction_put.pro
.run IDLsendToGeek__define.pro
.run IDLgetNexusData__define.pro
.run sans_reduction_plot.pro

;procedures

;main functions
.run MainBaseEvent.pro
.run sans_reduction_eventcb.pro
.run sans_reduction.pro
