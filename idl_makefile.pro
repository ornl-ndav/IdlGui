;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder
IdlUtilitiesPath = "../utilities"

;Makefile that automatically compile the necessary modules
;and create the VM file.
;cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/utilities/"
cd, IdlUtilitiesPath
.run system_utilities.pro

;Build main procedures
cd, CurrentFolder
.run MakeGui.pro

.run ts_rebin_put.pro
.run ts_rebin_get.pro

.run MainBaseEvent.pro
.run ts_rebin_eventcb.pro
.run ts_rebin.pro
