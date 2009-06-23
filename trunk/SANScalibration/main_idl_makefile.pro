;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro
.run nexus_utilities.pro
.run IDLxmlParser__define.pro
.run checking_packages.pro
.run logger.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSScalibration GUI
cd, CurrentFolder + '/SANScalibrationGUI/'
.run make_gui_log_book.pro
.run IDLloadNexus__define.pro
.run make_gui_main_tab.pro
.run make_gui_tab1.pro
.run make_gui_reduce_tab.pro
.run make_gui_fitting.pro
.run IDLnexusFrame__define.pro
.run IDLtxtFrame__define.pro
.run make_gui_reduce_tab1.pro
.run make_gui_reduce_tab2.pro
.run make_gui_reduce_tab3.pro
.run IDLmakeTOFbase__define.pro

;Build all procedures
cd, CurrentFolder

;utils functions
.run sans_calibration_time.pro
.run IDLgetMetadata__define.pro
.run IDL3columnsASCIIparser__define.pro
.run sans_calibration_put.pro
.run IDLsendToGeek__define.pro
.run IDLsendLogBook__define.pro
.run IDLgetNexusData__define.pro
.run sans_calibration_get.pro
.run sans_calibration_lin_log_plot.pro
.run sans_calibration_plot.pro
.run sans_calibration_gui.pro

;procedures
.run sans_calibration_reduce_tab1.pro
.run sans_calibration_reduce_tab2.pro
.run sans_calibration_reduce_tab3.pro
.run sans_calibration_command_line.pro
.run sans_calibration_run_commandline.pro
.run sans_calibration_xroi.pro
.run sans_calibration_xdisplayfile.pro
.run sans_calibration_selection.pro
.run sans_calibration_exclusion.pro
.run sans_calibration_fitting.pro
.run sans_calibration_counts_vs_tof.pro
.run sans_calibration_play.pro

;main functions
.run MainBaseEvent.pro
.run sans_calibration_make_facility_selection.pro
.run sans_calibration_eventcb.pro
.run sans_calibration_build_gui.pro

;to compile all the iTools procedures
itResolve

