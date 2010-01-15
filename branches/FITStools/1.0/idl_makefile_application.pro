;define path to dependencies and current folder
CD , CURRENT=CurrentFolder

IdlUtilitiesPath = CurrentFolder + '/utilities'
cd, IdlUtilitiesPath
.run logger.pro
.run IDLxmlParser__define.pro
.run get.pro
.run put.pro
.run gui.pro
.run fsc_color.pro
.run colorbar.pro
.run showprogress__define.pro
.run xdisplayfile.pro

;routines used to read and write FITS files
cd, CurrentFolder + '/reader_writer_routines'
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

;build application
cd, CurrentFolder + '/FITStoolsGUI'
.run build_main_gui.pro
.run make_gui_tab1.pro
.run make_gui_tab2.pro
.run make_gui_tab3.pro

;main folder
cd, CurrentFolder

;tab1
.run fits_tools_tab1_functions.pro
.run fits_tools_tab1_browse.pro
.run fits_tools_tab1.pro

;tab2
.run fits_tools_tab2_functions.pro
.run fits_tools_tab2.pro

;tab1 and tab2
.run fits_tools_tab1_tab2_plot.pro

;tab3
.run fits_tools_tab3_functions.pro
.run fits_tools_tab3.pro

;tab2 and tab3
.run fits_tools_tab2_tab3.pro
.run fits_tools_tab3_plot.pro

.run MainBaseEvent.pro
.run fits_tools.pro
