;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder
IdlUtilitiesPath = "utilities/"

;Makefile that automatically compile the necessary modules
;and create the VM file.
;cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/utilities/"
cd, IdlUtilitiesPath
.run nexus_utilities.pro
.run system_utilities.pro

cd, CurrentFolder
.run rebin_nexus_eventcb.pro
.run rebin_nexus.pro
