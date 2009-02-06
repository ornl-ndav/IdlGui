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

;classes
cd , CurrentFolder + '/Classes/'
.run IDLxmlParser__define.pro
.run IDLsendLogBook__define.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build CLoop GUI
cd, CurrentFolder + '/CLoopGUI/'
.run MakeGuiMainBase.pro
.run make_gui_tab1.pro
.run make_gui_tab2.pro

;Build all procedures
cd, CurrentFolder

;procedures
.run cloop_srun.pro
.run cloop_browse_cl_file.pro
.run cloop_help.pro
.run cloop_input_parser.pro
.run cloop_run_jobs.pro

;main functions
.run MainBaseEvent.pro
.run cloop_eventcb.pro
.run cloop.pro
