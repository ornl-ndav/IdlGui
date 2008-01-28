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
.run MakeGuiMainPlot.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run plot_arcs_get.pro
.run plot_arcs_time.pro
.run plot_arcs_put.pro

;procedures
;first base
.run plot_arcs_Input.pro
.run plot_arcs_Browse.pro
.run plot_arcs_GUIupdate.pro
.run plot_arcs_CreateHistoMapped.pro
.run plot_arcs_SaveAsHistoMapped.pro
.run plot_arcs_SendToGeek.pro
;main plot base
.run plot_arcs_PlotMainPlot.pro
.run plot_arcs_MainPlot.pro

;main functions
.run MainBaseEvent.pro
.run plot_arcs_eventcb.pro
.run plot_arcs.pro
