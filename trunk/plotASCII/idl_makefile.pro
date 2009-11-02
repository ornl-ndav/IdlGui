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

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build all procedures
cd, CurrentFolder

;procedures

;main functions
.run MainBaseEvent.pro
.run plot_ascii.pro
