;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro
.run IDLnexus__define.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/plotROIGUI/'
.run MakeGuiMainBase.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run plot_roi_get.pro
.run plot_roi_is.pro
.run plot_roi_put.pro
.run plot_roi_GUI.pro
.run IDLsendToGeek__define.pro
.run IDLgetNexusMetadata__define.pro

;procedures
.run plot_roi_Load.pro
.run plot_roi_Plot.pro

;main functions
.run MainBaseEvent.pro
.run plot_roi_eventcb.pro
.run plot_roi.pro
