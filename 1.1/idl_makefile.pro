;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath

;functions
.run get.pro
;procedures
.run is.pro
.run put.pro
.run gui.pro
.run system_utilities.pro
.run time_utilities.pro
.run time.pro
.run logger.pro
.run IDLxmlParser__define.pro
.run checking_packages.pro

;classes
cd , CurrentFolder + '/Classes/'
.run IDLxmlParser__define.pro
.run IDLsendLogBook__define.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build CLoop GUI
cd, CurrentFolder + '/CLoopESGUI/'
.run MakeGuiMainBase.pro
.run make_gui_tab1.pro
.run make_gui_tab2.pro
.run make_gui_tab3.pro

;Build all procedures
cd, CurrentFolder

;procedures
.run cloopes_tab.pro
.run cloopes_tab1.pro
.run cloopes_srun.pro
.run cloopes_browse_cl_file.pro
.run cloopes_help.pro
.run cloopes_input_parser.pro
.run cloopes_run_jobs.pro
.run cloopes_job_manager_splash_base.pro
.run cloopes_tab2.pro
.run cloopes_run_job_tab2.pro
.run cloopes_load_save_temperature.pro
.run cloopes_save_temperature_base.pro

;main functions
.run MainBaseEvent.pro
.run cloopes_eventcb.pro
.run cloopes.pro
