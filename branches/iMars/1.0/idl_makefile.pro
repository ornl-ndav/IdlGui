;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath

;functions
.run check.pro
.run colorbar.pro
.run convert.pro
.run fsc_color.pro
.run get_ucams.pro
.run get.pro
.run gui.pro
.run is.pro
.run put.pro
.run system.pro
.run time.pro
.run xdisplayfile.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build CLoop GUI
cd, CurrentFolder + '/iMarsGUI/'
.run build_menu.pro
.run build_gui.pro

;Build all procedures
cd, CurrentFolder

.run browse_files.pro

;main functions
.run global.pro
.run MainBaseEvent.pro
.run iMars.pro
