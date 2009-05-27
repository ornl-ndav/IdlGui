;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro
.run IDLnexusUtilities__define.pro
.run showprogress__define.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/plotCNCSGUI/'
.run MakeGuiInputBase.pro
.run IDLloadNexus__define.pro
.run MakeGuiMainPlot.pro
.run MakeGuiBankPlot.pro
.run MakeGuiTofBase.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run plot_cncs_get.pro
.run plot_cncs_time.pro
.run plot_cncs_put.pro
.run plot_cncs_is.pro

;procedures
;first base
.run plot_cncs_Input.pro
.run plot_cncs_Browse.pro
.run plot_cncs_PreviewRuninfoFile.pro
.run plot_cncs_CollectHistoInfo.pro
.run plot_cncs_GUIupdate.pro
.run plot_cncs_CreateHistoMapped.pro
.run plot_cncs_SaveAsHistoMapped.pro
.run plot_cncs_SendToGeek.pro

;Nexus tab
.run plot_cncs_Nexus.pro

;main plot base
.run plot_cncs_PlotMainPlot.pro
.run plot_cncs_MainPlot.pro

;bank plot base
.run plot_cncs_PlotBank.pro
.run plot_cncs_PlotBankEventcb.pro

;tof plot base
.run plot_cncs_PlotTof.pro
.run plot_cncs_PlotTofEventcb.pro

;main functions
.run MainBaseEvent.pro
.run plot_cncs_eventcb.pro
.run plot_cncs.pro
