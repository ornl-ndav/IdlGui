PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

APPLICATION     = 'BSSreductionSQE'
VERSION         = '1.2.4'
DeployedVersion = 'yes'

;define initial global values - these could be input via external file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

;define global variables
global = ptr_new ({ $
                    DeployedVersion : DeployedVersion,$
                    DriverName : 'amorphous_reduction_sqe',$
                    DRstatusOK : 'Data Reduction ... DONE',$
                    DRstatusFAILED : 'Data Reduction ... ERROR! (-> Check Log Book)',$
                    unit : 0,$
                    BSSreductionVersion : VERSION,$
                    DR_xml_config_ext : '.rmd',$
                    DR_xml_config_file : '',$
                    ListOfOutputPlots : {woctib_button   : 0,$
                                         wopws_button    : 0,$
                                         womws_button    : 0,$
                                         womes_button    : 0,$
                                         worms_button    : 0,$
                                         wocpsamn_button : 0,$
                                         wopies_button   : 0,$
                                         wopets_button   : 0,$
                                         wolidsb_button  : 0},$
                    NameOfOutputPlots : {woctib_button   : $
                                         'Calculated Time-Independent Background', $
                                         wopws_button    : $
                                         'Pixel Wavelength Spectrum',$
                                         womws_button    : $
                                         'Monitor Wavelngth Spectrum',$
                                         womes_button    : $
                                         'Monitor Efficiency Spectrum',$
                                         worms_button    : $
                                         'Rebinned Monitor Spectrum',$
                                         wocpsamn_button : $
                                         'Combined Pixel Spectrum After Monitor Normalization',$
                                         wopies_button   : $
                                         'Pixel Initial Energy Spectrum',$
                                         wopets_button   : $
                                         'Pixel Energy Transfer Spectrum',$
                                         wolidsb_button  : $
                                         'linearly Interpolated Direct Scattering Back. Info. Summed over all Pixels'},$
                    OutputPlotsExt : {woctib   : '_data.tib',$
                                      wopws    : '_data.pxl',$
                                      womws    : '_data.mxl',$
                                      womes    : '_data.mel',$
                                      worms    : '_data.mrl',$
                                      wocpsamn : '_data.pml',$
                                      wopies   : '_data.ixl',$
                                      wopets   : '_data.exl',$
                                      wolidsb  : '_data.lin'},$
                    MainDRPlotsExt : { etr  : '.etr',$
                                       setr : '.setr'},$
                    WidgetsToActivate : ptr_new(0L),$
                    LoadingConfig : 1,$ ;will be 1 after loading config file
                    DefaultConfigFileName : '~/.bss_reduction.cfg',$ 
                    instrument : 'BSS',$
                    nexus_path : '/SNS/BSS/',$
                    nexus_geometry_path : '/SNS/BSS/2006_1_2_CAL/calibrations/',$
                    nexus_ext : '.nxs',$
                    nexus_full_path : $
                    '/Users/j35/SVN/HistoTool/branches/BSSreductionBranch/NeXus/BSS/BSS_246.nxs',$
                    processing : 'PROCESSING',$
                    PrevLinLogValue : 0,$ ;previously saved lin or log counts vs tof scale
                    PrevFullLinLogValue : 0,$ ;previously saved lin or log full counts vs tof scale
                    full_counts_vs_tof_data : ptr_new(0L),$ ;counts vs tof of full selected pixels
                    output_full_counts_vs_tof_legend : '#TOF(microS) Counts errCounts',$
                    CountsVsTofAsciiArray : ptr_new(0L),$
                    PreviewCountsVsTofAsciiArray : ptr_new(0L),$   
                    OutputMessageToAdd : '',$ ;message to add in output counts vs tof ascii file
                    PrevExcludedSymbol : 0,$
                    ColorSelectedPixel : 100,$
                    ColorVerticalGrid : 85,$
                    ColorHorizontalGrid : 85,$
                    ColorExcludedPixels : 150,$
                    LoadctMainPlot : 5,$
                    DefaultColorVerticalGrid : 85,$
                    DefaultColorHorizontalGrid : 85,$
                    DefaultColorExcludedPixels : 150,$
                    DefaultLoadctMainPlot : 5,$
                    BSSselectionVersion : version,$ ;version of current program
                    ucams : ucams,$ ;ucams of user
                    previous_tab : 0,$ ;default tab is 0 (Selection big tab)
                    previous_counts_vs_tof_tab : 0,$ ;default counts vs tof tab is 0
                    RunNumber : 0L, $ ;NeXus run number
                    NexusFullName : '',$ ;Full nexus file name
                    roi_path : '~/local/',$ ;path where to save the ROI file
                    SavedRoiFullFileName : '',$ ;full file name of ROI file
                    counts_vs_tof_path : '~/local/',$ ;path where to save the counts vs tof ascii file
                    roi_ext : '_ROI.dat' ,$ ;extension of ROI files
                    counts_vs_tof_ext : '_IvsTOF.txt' ,$ ;extension of ROI files
                    roi_default_file_name : '',$ ;default roi file name
                    ROI_error_status : 0,$ ;error status of the ROI process
                    RoiPreviewArray : [0,10,50,100],$ ;roi array
                    counts_vs_tof_x : 0L,$ ;x of actual counts vs tof plotted
                    counts_vs_tof_y : 0L,$ ;y of actual counts vs tof plotted
                    counts_vs_tof_bank : 0,$ ;bank of actual counts vs tof plotted
                    true_x_min : 0.0000001,$ ;tof min for counts vs tof zoom plot
                    true_x_max : 0.0000001,$ ;tof max for counts vs tof zoom plot
                    true_full_x_min : 0.0000001,$ ;tof min for full counts vs tof zoom plot
                    tmp_true_full_x_min : 0.00000001, $
                    true_full_x_max : 0.0000001,$ ;tof max for full counts vs tof zoom plot
                    NbTOF : 0L,$ ;number of tof for counts vs tof plot
                    NeXusFound : 0,$ ;0: nexus has not been found, 1 nexus has been found
                    NeXusFormatWrong : 0,$ ;if we are trying to open using hdf4
                    ok : 'OK',$
                    failed : 'FAILED',$
                    bank1: ptr_new(0L),$ ;array of bank1 data (Ntof, Nx, Ny)
                    bank1_sum: ptr_new(0L),$ ;array of bank1 data (Nx, Ny)
                    bank2: ptr_new(0L),$ ;array of bank2 data (Ntof, Nx, Ny)
                    bank2_sum: ptr_new(0L),$ ;array of bank2 data (Nx, Ny)
                    pixel_excluded : ptr_new(0L),$ ;list of pixel excluded 
                    pixel_excluded_base : ptr_new(0L),$
 ;list of pixel excluded without counts removing
                    default_pixel_excluded : ptr_new(0L),$
                    pixel_excluded_size : 64*2*64L,$ ; total number of pixels
                    TotalPixels : 8192L,$ ;Total number of pixels
                    TotalRows   : 128L,$ ;total number of rows
                    TotalTubes  : 128L,$ ;total number of tubes
                    nexus_bank1_path : '/entry/bank1/data',$ ;nxdir path to bank1 data
                    nexus_bank2_path : '/entry/bank2/data',$ ;nxdir path to bank2 data
                    tof_path : '/entry/bank1/time_of_flight',$ nxdir path to tof data
                    Nx : 56,$
                    Ny : 64,$
                    Xfactor : 13,$ ;coefficient in X direction for rebining img
                    Yfactor : 5,$ ; coefficient in Y direction for rebining img
                    LogBookPath : '/SNS/users/LogBook/',$ ;path where to put the log book
                    DefaultPath : '~/local/BSS/',$ ;default path where to look for the file
                    DefaultFilter : '*.nxs',$ ;default filter for the nexus file
                    Configuration : { Input : {nexus_run_number    : '',$
                                               ColorVerticalGrid   : 85,$
                                               ColorHorizontalGrid : 85,$
                                               ColorExcludedPixels : 150,$
                                               ColorSelectedPixel  : 100,$
                                               loadct_droplist     : 5,$
                                               excluded_pixel_type : 0},$
                                      Reduce : {tab1 : { rsdf_list_of_runs_text    : '',$
                                                         rsdf_multiple_runs_button : 0,$
                                                         bdf_list_of_runs_text     : '',$
                                                         ndf_list_of_runs_text     : '',$
                                                         ecdf_list_of_runs_text    : '',$
                                                         dsb_list_of_runs_text     : ''},$
                                                tab2 : { proif_text            : '',$
                                                         aig_list_of_runs_text : '',$
                                                         of_list_of_runs_text  : ''},$
                                                tab3 : { rmcnf_button            : 0,$
                                                         verbose_button             : 0,$
                                                         absm_button       : 0,$
                                                         nmn_button        : 0,$
                                                         nmec_button          : 0,$
                                                         niw_button  : 0,$
                                                         nisw_field        : '',$
                                                         niew_field          : '',$
                                                         te_button     : 0,$
                                                         te_low_field       : '',$
                                                         te_high_field      : ''},$
                                                tab4 : { tib_tof_button : 0,$
                                                         tibtof_channel1_text : '',$
                                                         tibtof_channel2_text: '',$
                                                         tibtof_channel3_text: '',$
                                                         tibtof_channel4_text : '',$
                                                         tibc_for_sd_button: 0,$
                                                         tibc_for_sd_value_text: '',$
                                                         tibc_for_sd_error_text: '',$
                                                         tibc_for_bd_button: 0,$
                                                         tibc_for_bd_value_text: '',$
                                                         tibc_for_bd_error_text: '',$
                                                         tibc_for_nd_button: 0,$
                                                         tibc_for_nd_value_text: '',$
                                                         tibc_for_nd_error_text: '',$
                                                         tibc_for_ecd_button: 0,$
                                                         tibc_for_ecd_value_text: '',$
                                                         tibc_for_ecd_error_text: '',$
                                                         tibc_for_scatd_button : 0,$
                                                         tibc_for_scatd_value_text: '',$
                                                         tibc_for_scatd_error_text: ''},$
                                                tab5 : { csbss_button : 0,$
                                                         csbss_value_text : '',$
                                                         csbss_error_text: '',$
                                                         csn_button: 0,$
                                                         csn_value_text : '',$
                                                         csn_error_text: '',$
                                                         bcs_button : 0,$
                                                         bcs_value_text : '',$
                                                         bcs_error_text: '',$
                                                         bcn_button : 0,$
                                                         bcn_value_text : '',$
                                                         bcn_error_text: '',$
                                                         cs_button : 0,$
                                                         cs_value_text : '',$
                                                         cs_error_text: '',$
                                                         cn_button: 0,$
                                                         cn_value_text: '',$
                                                         cn_error_text: ''},$
                                                tab6 : { tzsp_button : 0,$ ;Data Control
                                                         tzsp_value_text: '',$
                                                         tzsp_error_text: '',$
                                                         tzop_button: 0,$
                                                         tzop_value_text : '',$
                                                         tzop_error_text: '',$
                                                         eha_min_text: '',$
                                                         eha_max_text: '',$
                                                         eha_bin_text : '',$
                                                         gifw_button : 0,$
                                                         gifw_value_text : '',$
                                                         gifw_error_text: '',$
                                                         mtha_min_text: '',$
                                                         mtha_max_text:'',$
                                                         mtha_bin_text:''},$
                                                tab7 : { waio_button: 0,$
                                                         woctib_button: 0,$
                                                         wopws_button: 0,$
                                                         womws_button: 0,$
                                                         womes_button: 0,$
                                                         worms_button: 0,$
                                                         wocpsamn_button : 0,$
                                                         wa_min_text: '',$
                                                         wa_max_text: '',$
                                                         wa_bin_width_text : '',$
                                                         wopies_button: 0,$
                                                         wopets_button: 0,$
                                                         wolidsb_button: 0,$
                                                         wodwsm_button: 0}}}$
                  })

Device, /decomposed
loadct, (*global).DefaultLoadctMainPlot

XYfactor                    = {Xfactor:(*global).Xfactor, Yfactor:(*global).Yfactor}
default_pixel_excluded      = intarr((*global).pixel_excluded_size)

;default exclusion are tubes 56-63 and 120-127
for j=0,1 do begin
    for i=3584L,4095L do begin
        default_pixel_excluded[i+j*4096L]=1
    endfor
endfor
(*(*global).default_pixel_excluded) = default_pixel_excluded
(*(*global).pixel_excluded) = default_pixel_excluded
(*(*global).pixel_excluded_base) = default_pixel_excluded

(*(*global).WidgetsToActivate) = ['load_roi_file_button',$
                                  'save_roi_file_button',$
                                  'roi_path_button',$
                                  'roi_file_name_generator',$
                                  'xbase',$
                                  'ybase',$
                                  'bank_base',$
                                  'tube_base',$
                                  'row_base',$
                                  'pixelid_base',$
                                  'counts_base',$
                                  'color_index_base',$
                                  'color_slider_base',$
                                  'color_base',$
                                  'counts_vs_tof_tab2',$
                                  'counts_vs_tof_tab1',$
                                  'fbase',$
                                  'sbase',$
                                  'abase',$
                                  'symbol_base',$
                                  'ebase',$
                                  'exclusion_base',$
                                  'reset_button']
    
if (!VERSION.os EQ 'darwin') then begin
    MainBaseSize  = [30,25,1200,730]
endif else begin
    MainBaseSize  = [50,200,1200,730]
endelse

MainBaseTitle = 'BSS reduction tool - ' + VERSION
        
;Build Main Base
MAIN_BASE = Widget_Base( GROUP_LEADER = wGroup,$
                         UNAME        = 'MAIN_BASE',$
                         SCR_XSIZE    = MainBaseSize[2],$
                         SCR_YSIZE    = MainBaseSize[3],$
                         XOFFSET      = MainBaseSize[0],$
                         YOFFSET      = MainBaseSize[1],$
                         TITLE        = MainBaseTitle,$
                         SPACE        = 0,$
                         XPAD         = 0,$
                         YPAD         = 2)

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

MakeGuiMainTab, MAIN_BASE, MainBaseSize, XYfactor

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='BSSreduction_Cleanup' 

; initialize slider (Grid: Vertical Lines)
id = widget_info(Main_base,Find_by_Uname='color_slider')
widget_control, id, set_value = (*global).ColorVerticalGrid

IF (DeployedVersion EQ 'no') THEN BEGIN

;default tabs shown
    id1 = widget_info(MAIN_BASE, find_by_uname='main_tab')
    widget_control, id1, set_tab_current = 1 ;reduce
    
;tab #7
    id1 = widget_info(MAIN_BASE, find_by_uname='reduce_input_tab')
    widget_control, id1, set_tab_current = 5
    
ENDIF

;logger message
logger_message  = '/usr/bin/logger -p local5.notice IDLtools '
logger_message += APPLICATION + '_' + VERSION + ' ' + ucams
error = 0
CATCH, error
IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
ENDIF ELSE BEGIN
    spawn, logger_message
ENDELSE

END


; Empty stub procedure used for autoloading.
pro bss_reduction_sqe, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





