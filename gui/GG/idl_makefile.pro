;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = "../utilities"
cd, IdlUtilitiesPath
.run system_utilities.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.


;Build BSSreduction GUI
cd, CurrentFolder + '/ggGUI/'
.run MakeGuiMainTab.pro

;Build main procedures
cd, CurrentFolder

.run MainBaseEvent.pro
.run gg_eventcb.pro
.run gg.pro
