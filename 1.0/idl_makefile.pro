;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath

;functions
.run get.pro
;procedures
.run put.pro
.run gui.pro
.run system_utilities.pro
.run time_utilities.pro
.run time.pro
.run logger.pro
.run xdisplayfile.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build CLoop GUI
cd, CurrentFolder + '/iMarsGUI/'

;Build all procedures
cd, CurrentFolder

;main functions
.run MainBaseEvent.pro
.run iMars_eventcb.pro
.run iMars.pro
