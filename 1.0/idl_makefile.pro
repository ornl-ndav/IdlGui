;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder
IdlUtilitiesPath = "/utilities"

;Makefile that automatically compile the necessary modules
;and create the VM file.
cd, CurrentFolder + IdlUtilitiesPath
.run system_utilities.pro

;Build REFscale GUI
cd, CurrentFolder + '/REFscaleGUI/'
.run "MakeGuiStep1.pro"
.run "MakeGuiStep2.pro"
.run "MakeGuiStep3.pro"
.run "MakeGuiOutputFile.pro"
.run "MakeGuiSettings.pro"
.run "MakeGuiMainBaseComponents.pro"

;Build main procedures
cd, CurrentFolder
.run "ArrayDelete.pro"
.run "getNumeric.pro"
.run "ref_scale_get.pro"
.run "ref_scale_put.pro"
.run "ref_scale_is.pro"
.run "Main_Base_event.pro"
.run "ref_scale_utility.pro"
.run "ref_scale_widget.pro"
.run "ref_scale_Gui.pro"
.run "ref_scale_fit.pro"
.run "ref_scale_step2_old.pro"
.run "ref_scale_step3.pro"
.run "ref_scale_Arrays.pro"
.run "ref_scale_math.pro"
.run "ref_scale_file_utility.pro"
.run "ref_scale_Arrays.pro"
.run "ref_scale_TOF_to_Q.pro"

.run "ref_scale_open_file.pro"
.run "ref_scale_OpenFile.pro"
.run "ref_scale_Plot.pro"
.run "ref_scale_Load.pro"
.run "ref_scale_Step2.pro"
.run "ref_scale_produce_output.pro"
.run "ref_scale_Tabs.pro"
.run "ref_scale_eventcb.pro"
.run "ref_scale.pro"
.run "ref_scale_eventcb"
