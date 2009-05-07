;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run system_utilities.pro
.run time.pro
.run IDLsendLogBook__define.pro
.run IDLsendToGeek__define.pro
.run IDL3columnsASCIIparser__define.pro
.run IDLgetMetadata__define.pro
.run xdisplayfile.pro
.run math_utilities.pro
.run findnexus.pro
.run uniq_element_table.pro
.run logger.pro
.run IDLxmlParser__define.pro 

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build BSSreduction GUI
cd, CurrentFolder + '/REFoffSpecGUI/'
.run MakeGuiMainBase.pro
.run MakeGuiStep1.pro
.run MakeGuiReduceStep1.pro
.run MakeGuiReduceStep2.pro
.run MakeGuiReduceStep3.pro
.run MakeGuiReduceStep4.pro
.run MakeGuiStep2.pro
.run MakeGuiStep3.pro
.run MakeGuiStep4.pro
.run MakeGuiStep4Step1.pro
.run MakeGuiStep4Step2.pro
.run MakeGuiStep4Step2Step1.pro
.run MakeGuiStep4Step2Step2.pro
.run MakeGuiStep4Step2Step3.pro
.run MakeGuiStep5.pro
.run MakeGuiStep6.pro
.run MakeGuiOptions.pro
.run MakeGuiLogBook.pro

;Build all procedures
cd, CurrentFolder

;utilities functions
.run ref_off_spec_is.pro
.run ref_off_spec_get.pro
.run ref_off_spec_put.pro
.run ref_off_spec_gui.pro
.run IDLnexusUtilities__define.pro
.run ref_off_spec_retrieve_nexus_data.pro

;procedures
.run colorbar.pro
.run CheckPackages.pro

.run ref_off_spec_reduce_step1.pro
.run ref_off_spec_reduce_step2.pro
.run ref_off_spec_reduce_step2_plot_norm.pro
.run ref_off_spec_reduce_step2_roi_selection.pro
.run ref_off_spec_reduce_step2_save_roi.pro
.run ref_off_spec_reduce_step2_save_roi_base.pro
.run ref_off_spec_reduce_step2_load_roi.pro
.run ref_off_spec_reduce_step3.pro
.run ref_off_spec_browse_ascii.pro
.run ref_off_spec_read_ascii.pro
.run ref_off_spec_plot.pro
.run ref_off_spec_congrid_data.pro
.run ref_off_spec_shifting.pro
.run ref_off_spec_shifting_plot2d.pro
.run ref_off_spec_scaling_step1.pro
.run ref_off_spec_scaling_step1_plot2d.pro
.run ref_off_spec_scaling_step2.pro
.run ref_off_spec_scaling_step2_step1.pro
.run ref_off_spec_scaling_step2_step2.pro
.run ref_off_spec_scaling_step2_step3.pro
.run ref_off_spec_step5.pro
.run ref_off_spec_step5_rescale.pro
.run ref_off_spec_refresh_recap_plot.pro
.run ref_off_spec_step6.pro
.run ref_off_spec_display_buttons.pro
.run packages_required.pro

;main functions
.run MainBaseEvent.pro
.run ref_off_spec_eventcb.pro
.run ref_off_spec.pro
