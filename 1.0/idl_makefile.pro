;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro
.run time_utilities.pro
.run IDLsendToGeek__define.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/REFoffSpecGUI/'
.run MakeGuiMainBase.pro
.run MakeGuiStep1.pro
.run MakeGuiLogBook.pro

;Build all procedures
cd, CurrentFolder

;procedures
.run IDLsendToGeek__define.pro

;main functions
.run MainBaseEvent.pro
.run ref_off_spec_eventcb.pro
.run ref_off_spec.pro
