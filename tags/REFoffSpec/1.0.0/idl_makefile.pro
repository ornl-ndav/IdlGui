;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro
.run time_utilities.pro
.run IDLsendToGeek__define.pro
.run IDL3columnsASCIIparser__define.pro
.run xdisplayfile.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/REFoffSpecGUI/'
.run MakeGuiMainBase.pro
.run MakeGuiStep1.pro
.run MakeGuiStep2.pro
.run MakeGuiLogBook.pro

;Build all procedures
cd, CurrentFolder

;utilities functions
.run ref_off_spec_get.pro
.run ref_off_spec_put.pro
.run ref_off_spec_gui.pro

;procedures
.run CheckPackages.pro
.run ref_off_spec_browse_ascii.pro
.run ref_off_spec_read_ascii.pro
.run ref_off_spec_plot.pro
.run ref_off_spec_congrid_data.pro

;main functions
.run MainBaseEvent.pro
.run ref_off_spec_eventcb.pro
.run ref_off_spec.pro
