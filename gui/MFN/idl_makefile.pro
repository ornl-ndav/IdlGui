;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = "../utilities"
cd, IdlUtilitiesPath
.run system_utilities.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build MFN GUI
cd, CurrentFolder + '/mfnGUI/'
.run MakeGui.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run mfn_get.pro
.run mfn_put.pro
.run mfn_is.pro
.run mfn_GUIupdate.pro
.run mfn_utilities.pro
.run mfn_LogBookInterface.pro

;procedures

;main functions
.run MainBaseEvent.pro
.run mfn_eventcb.pro
.run mfn.pro
