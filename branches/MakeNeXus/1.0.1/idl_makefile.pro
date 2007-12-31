;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = "./utilities"
cd, IdlUtilitiesPath
.run system_utilities.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build MFN GUI
cd, CurrentFolder + '/makenexusGUI/'
.run MakeGui.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run makenexus_get.pro
.run makenexus_put.pro
.run makenexus_is.pro
.run makenexus_GUIupdate.pro
.run makenexus_utilities.pro
.run makenexus_LogBookInterface.pro
.run showprogress__define.pro

;procedures
.run makenexus_Cleanup.pro
.run makenexus_CreateNexusRoutines.pro

;main functions
.run MainBaseEvent.pro
.run makenexus_eventcb.pro
.run makenexus.pro
