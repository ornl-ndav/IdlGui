;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/REFoffSpecGUI/'
.run MakeGuiMainBase.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run IDLsendToGeek__define.pro

;procedures

;main functions
.run MainBaseEvent.pro
.run ref_off_spec_eventcb.pro
.run ref_off_spec.pro
