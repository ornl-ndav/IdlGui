;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/plotROIGUI/'
.run MakeGuiMainBase.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run IDLsendToGeek__define.pro

;procedures

;main functions
.run MainBaseEvent.pro
.run plot_roi_eventcb.pro
.run plot_roi.pro
