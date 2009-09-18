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

;classes
cd , CurrentFolder + '/Classes/'
.run IDLxmlParser__define.pro
.run IDLsendLogBook__define.pro
.run IDL3columnsASCIIparser__define.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build CLoop GUI
cd, CurrentFolder + '/DADgui/'
.run MakeGuiMainBase.pro

;Build all procedures
cd, CurrentFolder
.run dad_create_output.pro
.run dad_check_gui_status.pro
.run dad_input_dave_ascii.pro
.run dad_input_es_file.pro
.run dad_table.pro
.run dad_run.pro
.run dad_temperature_selection_base.pro

;main functions
.run MainBaseEvent.pro
.run dad_eventcb.pro
.run dad.pro
