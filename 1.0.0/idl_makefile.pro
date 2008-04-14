;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/SANSreductionGUI/'
.run make_gui_main_tab.PRO
.run make_gui_tab1.pro

;Build all procedures
cd, CurrentFolder

;utils functions

;procedures

;main functions
.run MainBaseEvent.pro
.run sans_reduction_eventcb.pro
.run sans_reduction.pro
