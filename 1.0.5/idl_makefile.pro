;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath

;functions
.run get.pro
;procedures
.run is.pro
.run put.pro
.run fsc_color.pro
.run gui.pro
.run system_utilities.pro
.run time_utilities.pro
.run time.pro
.run logger.pro
.run IDLxmlParser__define.pro
.run checking_packages.pro
.run IDL3columnsASCIIparser__define.pro
.run IDL3columnsASCIIparserREFscale__define.pro
.run plot_ascii_functions.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build all procedures
cd, CurrentFolder

;tools base
.run plot_ascii_tools.pro
.run plot_ascii_tools_functions.pro

;load base
.run plot_ascii_load_functions.pro
.run plot_ascii_load_eventcb.pro
.run plot_ascii_load.pro

;procedures

;main functions
.run MainBaseEvent.pro
.run plot_ascii_eventcb.pro
.run plot_ascii.pro
