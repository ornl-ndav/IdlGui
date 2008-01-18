;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/plotARCSGUI/'
.run MakeGuiInputBase.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run plot_arcs_get.pro
.run plot_arcs_put.pro

;procedures
.run plot_arcs_Input.pro
.run plot_arcs_Browse.pro
.run plot_arcs_GUIupdate.pro
.run plot_arcs_CreateHistoMapped.pro

;main functions
.run MainBaseEvent.pro
.run plot_arcs_eventcb.pro
.run plot_arcs.pro
