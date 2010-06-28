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
.run get_button_name.pro

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
.run design_tab1.pro
.run design_tab2.pro
.run design_tab3.pro

;Build all functions and procedures
cd, CurrentFolder

;build all functions
.run create_email_message.pro
.run create_email_subject.pro

.run send_your_message.pro
.run send_error_message.pro
.run browse_files.pro
.run remove_files.pro
.run create_tar_folder.pro
.run launch_web_page.pro
.run launch_application.pro

.run display_buttons.pro
.run display_descriptions_buttons.pro
.run button_event.pro

;main functions
.run MainBaseEvent.pro
.run need_help_eventcb.pro
.run need_help.pro
