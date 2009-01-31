;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run put.pro
.run system_utilities.pro
.run time_utilities.pro
.run time.pro
.run logger.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build CLoop GUI
cd, CurrentFolder + '/CLoopGUI/'
.run MakeGuiMainBase.pro
.run make_gui_tab1.pro
.run make_gui_tab2.pro

;Build all procedures
cd, CurrentFolder

;classes
.run IDLsendLogBook__define.pro

;procedures
.run cloop_browse_cl_file.pro

;main functions
.run MainBaseEvent.pro
.run cloop_eventcb.pro
.run cloop.pro
