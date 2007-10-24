;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder
IdlUtilitiesPath = "../utilities"

;Makefile that automatically compile the necessary modules
;and create the VM file.
;cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/utilities/"
cd, IdlUtilitiesPath
.run system_utilities.pro

;Build BSSselection GUI
cd, CurrentFolder + '/BSSselectionGUI/'
.run MakeGuiMainTab.pro

;Build main procedures
cd, CurrentFolder

.run MainBaseEvent.pro
.run bss_selection_eventcb.pro
.run bss_selection.pro
