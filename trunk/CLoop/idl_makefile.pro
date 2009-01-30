;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro
.run time_utilities.pro
.run time.pro
.run logger.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build CLoop GUI
cd, CurrentFolder + '/CLoopGUI/'
.run MakeGuiMainBase.pro

;Build all procedures
cd, CurrentFolder

;procedures
.run IDLsendLogBook__define.pro

;main functions
.run MainBaseEvent.pro
.run cloop_eventcb.pro
.run cloop.pro
