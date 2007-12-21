;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/ggGUI/'
.run MakeGuiConfirmationBase.pro
.run MakeGuiLoadingGeometry.pro
.run MakeGuiInputGeometry.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run gg_get.pro
.run gg_put.pro
.run gg_is.pro
.run gg_GUIupdate.pro
.run gg_time.pro

;procedures
.run gg_Preview.pro
.run gg_Browse.pro
.run gg_Table.pro
.run gg_ReadXml.pro
.run xmlParser__define.pro
.run gg_ConfirmationBase.pro

;main functions
.run MainBaseEvent.pro
.run gg_eventcb.pro
.run gg.pro
