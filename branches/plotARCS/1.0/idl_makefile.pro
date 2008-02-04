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
.run MakeGuiBankPlot.pro
.run MakeGuiTofBase.pro

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
.run plot_arcs_PreviewRuninfoFile.pro
.run plot_arcs_CollectHistoInfo.pro
.run plot_arcs_GUIupdate.pro
.run plot_arcs_CreateHistoMapped.pro
.run plot_arcs_SaveAsHistoMapped.pro
.run plot_arcs_SendToGeek.pro

;main plot base
.run plot_arcs_PlotMainPlot.pro
.run plot_arcs_MainPlot.pro

;bank plot base
.run plot_arcs_PlotBank.pro
.run plot_arcs_PlotBankEventcb.pro

;tof plot base
.run plot_arcs_PlotTof.pro

;main functions
.run MainBaseEvent.pro
.run plot_arcs_eventcb.pro
.run plot_arcs.pro
