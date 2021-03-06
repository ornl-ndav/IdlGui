;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

IdlUtilitiesPath = "/utilities"

cd, CurrentFolder + IDLUtilitiesPath
.run colorbar.pro
.run fsc_color.pro
.run get.pro
.run gui.pro
.run is.pro
.run logger.pro
.run put.pro
.run set.pro
.run time.pro
.run xdisplayfile.pro
.run system.pro
.run convert.pro

;build GUI
cd, CurrentFolder + '/SOS_GUI'
.run design_tabs.pro
.run menu_designer.pro

;build main routines and tests
cd, CurrentFolder
.run IDLnexusUtilities__define.pro
.run IDLxmlParser__define.pro
.run conversion.pro
.run browse_nexus_button.pro
.run convert_to_qxqz.pro

;test
.run IDLnexusUtilitiesTest__define.pro
.run IDLxmlParserTest__define.pro
.run IDLsystemTest__define.pro

;main routines	
.run xcw_direct.pro
.run xcr_direct.pro
.run SNS_convert_QXQZ.pro
.run SNS_convert_THLAM.pro
.run sns_divide_spectrum.pro
.run SNS_extract_specular.pro
.run SNS_read_NEXUS.pro
.run SNS_offspec_QXQZ_from_NEXUS_looper_NEW.pro
.run progress_bar_eventcb.pro

.run data_box_eventcb.pro
.run norm_box_eventcb.pro
.run log_book_eventcb.pro
.run go_reduction.pro
.run final_plot_base.pro
.run save_background.pro
.run plot_colorbar.pro
.run final_plot_eventcb.pro
.run cursor_info_base.pro
.run menu_eventcb.pro
.run counts_vs_axis_base.pro

.run sos.pro
.run sos_cleanup.pro