;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

;Makefile that automatically compile the necessary modules
;and create the VM file.
cd, CurrentFolder + '/utilities'
.run system_utilities.pro
.run nexus_utilities.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build all procedures
cd, CurrentFolder
.run plot_data_eventcb.pro
.run plot_data.pro
