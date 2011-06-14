;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder

cd, CurrentFolder + '/utilities'
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
.run histoplot.pro

cd, CurrentFolder + '/reader_writer_routines/'
.run gettok.pro
.run is_ieee_big.pro
.run fxparpos.pro
.run fxaddpar.pro
.run fxmove.pro
.run fxpar.pro
.run fxposit.pro
.run ieee_to_host.pro
.run mrd_skip.pro
.run mrd_struct.pro
.run valid_num.pro
.run mrd_hread.pro
.run match.pro
.run mrdfits.pro

.run sxdelpar.pro
.run hprint.pro
.run fits_open.pro
.run fits_close.pro
.run strn.pro
.run sxpar.pro
.run textopen.pro
.run textclose.pro
.run fits_info.pro
.run fits_help.pro
.run sxaddpar.pro
.run fits_write.pro

cd, CurrentFolder + '/FitsPlot'
.run fits_plot_base.pro
.run fits_plot_colorbar.pro
.run fits_plot_launcher.pro
.run fits_plot_roi_input_base.pro

cd, CurrentFolder + '/PreviewBase'
.run plot_zoom_roi.pro
.run preview_display_base.pro
.run plot_zoom_data.pro
.run zoom_base_id_eventcb.pro

cd, CurrentFolder + '/NormalizedPlot'
.run normalized_plot.pro
.run plot_normalized_data.pro

cd, CurrentFolder + '/SettingsBase'
.run settings_base.pro

;Makefile that automatically compile the necessary modules
;and create the VM file.

;Build CLoop GUI
cd, CurrentFolder + '/iMarsGUI/'
.run build_menu.pro
.run build_gui.pro

;Build all procedures
cd, CurrentFolder

;fits routines
.run read_fits_file.pro
.run gamma_cleaner.pro

.run display_images.pro
.run browse_files.pro
.run reset_menu_eventcb.pro
.run roi_eventcb.pro
.run output.pro
.run help_menu_eventcb.pro
.run log_book.pro
.run configuration.pro
.run IDLconfiguration__define.pro
.run IDLxmlParser__define.pro
.run preview.pro
.run table_right_click.pro

;run reduction
.run check_run_normalization_button_status.pro
.run run_normalization.pro
.run progress_bar.pro

;buttons base
.run display_metadata.pro
.run launch_xloadct.pro
.run preview_roi.pro

;main functions
.run button_eventcb.pro
.run global.pro
.run MainBaseEvent.pro
.run iMars_cleanup.pro
.run iMars.pro
