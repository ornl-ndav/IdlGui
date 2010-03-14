;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath

;functions
.run get.pro
;procedures
.run put.pro
.run gui.pro
.run system_utilities.pro
.run time_utilities.pro
.run time.pro
.run logger.pro
.run xdisplayfile.pro
.run get_ucams.pro
.run get_general_infos.pro

;classes
cd , CurrentFolder + '/Classes/'
.run IDLxmlParser__define.pro
.run IDLsendLogBook__define.pro
.run IDL3columnsASCIIparser__define.pro
  
;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build CLoop GUI
cd, CurrentFolder + '/NeedHelpGUI/'
.run MakeGuiMainBase.pro

;Build all procedures
cd, CurrentFolder

;main functions
.run MainBaseEvent.pro
.run need_help_eventcb.pro
.run need_help.pro
