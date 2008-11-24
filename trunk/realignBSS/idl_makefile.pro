;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build all procedures
cd, CurrentFolder
.run plotASCII_eventcb.pro
.run plotASCII.pro
