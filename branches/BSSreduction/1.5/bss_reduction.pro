;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  file = OBJ_NEW('idlxmlparser', 'BSSreduction.cfg')
  ;==============================================================================
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION = file->getValue(tag=['configuration','version'])
  CHECKING_PACKAGES = file->getValue(tag=['configuration','checking_packages'])
  DeployedVersion = file->getValue(tag=['configuration','DeployedVersion'])
  DEBUGGING_VERSION = file->getValue(tag=['configuration','debugging_version'])
  ;==============================================================================
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  obj_destroy, file
  
  PACKAGE_REQUIRED_BASE = { driver:           '',$
    version_required: '',$
    found: 0,$
    sub_pkg_version:   ''}
    
  ;DEBUGGING (enter the tab you want to see)
  ;(main_tab): 0: Selection
  ;            1: Reduce (reduce_input_tab)
  ;               0: 1) Input
  ;               1: 2) Input
  ;               2: 3) Setup
  ;               3: 4) Time-Index. Back.
  ;               4: 5) Lambda-Dep. Back.
  ;               5: 6) Scaling Cst.
  ;               6: 7) Data Control
  ;               7: 8) Output
  ;            2: Output
  ;            3: Log Book
    
  sDEBUGGING = { tab: {main_tab: 0,$ ;Selection tab
    reduce_input_tab: 6},$ ;Scaling Cst tab
    DefaultPath: '~/SVN/IdlGui/branches/BSSreduction/1.5/',$
    reduce: {input1: { uname: 'rsdf_list_of_runs_text',$
    value: $
    '/SNS/BSS/IPTS-493/7/638/' + $
    'NeXus/BSS_638.nxs'},$
    input2: { uname: 'proif_text',$
    value: $
    '/SNS/users/j35/BASIS_350_2008y_10m_30d_'+$
    '16h_43mn_ROI.dat'},$
    input3: { uname: 'eha_min_text',$ ;7)Data Control
    value: '-200'},$
    input4: { uname: 'eha_max_text',$
    value: '200'},$
    input5: { uname: 'eha_bin_text',$
    value: '.4'},$
    input6: { uname: 'mtha_min_text',$
    value: '0'},$
    input7: { uname: 'mtha_max_text',$
    value: '1'},$
    input8: { uname: 'mtha_bin_text',$
    value: '.3'},$
    input9: { uname: 'pte_min_text',$
    value: '180'},$
    input10: { uname: 'pte_max_text',$
    value: '200'},$
    input11: { uname: 'pte_bin_text',$
    value: '0.4'},$
    input12: { uname: $
    'detailed_balance_temperature_value',$
    value: '300'},$
    input13: { uname: 'ratio_tolerance_value',$
    value: '0.001'},$
    input14: { uname: 'max_wave_dependent_back',$
    value: '1E-10'},$
    input15: { uname: 'chopper_frequency_value',$
    value: '30'},$
    input16: { uname: 'chopper_wavelength_value',$
    value: '6.4'},$
    input17: { uname: 'tof_least_background_value',$
    value: '154000'}}}
    
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  ;==============================================================================
    
  ;define initial global values - these could be input via external file or
  ;other means
    
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
    
  ucams = get_ucams()
  live_shared_folder = '/SNS/users/' + ucams + '/.tmp_live_data/'
  
  ;define global variables
  global = ptr_new ({ $
    firefox: '/usr/bin/firefox',$
    srun_web_page: 'https://neutronsr.us/applications/jobmonitor/squeue.php?view=all',$
    first_lds_used: 1,$
    
    ;temporary live folder for live data stremaing
    tmp_live_shared_folder: live_shared_folder, $
    
    application: APPLICATION,$
    version: VERSION,$
    ucams: UCAMS,$ ;ucams of user
    output_log_srun_path: '~/results/',$
    job_status_full_output_file_name: '',$
    MainBaseSize: INTARR(4),$
    igs_selected_index: 0,$
    stitch_driver: 'stitch_dave',$
    iter_dependent_back_ext: 'ibs.txt',$
    icon_ok: PTR_NEW(0L),$
    icon_failed: PTR_NEW(0L),$
    pMetadata: PTR_NEW(0L),$
    pMetadataValue: PTR_NEW(0L),$
    job_status_uname: PTR_NEW(0L),$
    leaf_uname_array: PTR_NEW(0L),$
    job_status_root_id: PTR_NEW(0L),$
    job_status_first_plot: 1,$
    job_status_root_status: PTR_NEW(0L),$
    absolute_leaf_index: PTR_NEW(0L),$
    ok_bmp: 'BSSreduction_images/ok.bmp',$
    failed_bmp: 'BSSreduction_images/failed.bmp',$
    TreeBase: 0L,$
    TreeID: 0L,$
    RootID: 0L,$
    config_file_name: '~/.bss_reduction_js.cfg',$
    lds_mode: 0,$
    output_plot_path: '~/results/',$
    findlivenexus: '/SNS/software/sbin/findlivenexus',$
    default_output_path: '~/results/',$
    CL_output_path: '~/results/',$
    negative_cosine_polar_array: STRARR(3),$
    momentum_transfer_array:     STRARR(3),$
    DeployedVersion: DeployedVersion,$
    DriverName: 'amorphous_reduction_sqe',$
    iterative_background_DriverName: 'find_ldb',$
    DRstatusOK: 'Data Reduction ... DONE',$
    DRstatusFAILED: 'Data Reduction ... ERROR! ' + $
    '(-> Check Log Book)',$
    unit: 0,$
    BSSreductionVersion: VERSION,$
    DR_xml_config_ext: '.rmd',$
    DR_xml_config_file: '',$
    
    ListOfOutputPlots: {woctib_button: 0,$
    wopws_button: 0,$
    womws_button: 0,$
    womes_button: 0,$
    worms_button: 0,$
    wocpsamn_button: 0,$
    wolidsb_button: 0,$
    sad_button: 0},$
    NameOfOutputPlots: {woctib_button: $
    'Calculated Time-Independent' + $
    ' Background', $
    wopws_button: $
    'Pixel Wavelength Spectrum',$
    womws_button: $
    'Monitor Wavelength Spectrum',$
    womes_button: $
    'Monitor Efficiency Spectrum',$
    worms_button: $
    'Rebinned Monitor Spectrum',$
    wocpsamn_button: $
    'Combined Pixel Spectrum' + $
    ' After Monitor Normalization',$
    wopies_button: $
    'Pixel Initial Energy Spectrum',$
    wopets_button: $
    'Pixel Energy Transfer Spectrum',$
    wolidsb_button: $
    'linearly Interpolated Direct' + $
    ' Scattering Back. Info. ' + $
    'Summed over all Pixels',$
    sad_button: $
    'Solid Angle Distribution from' + $
    ' S(Q,E) Rebinning'},$
    OutputPlotsExt: {woctib: '_data.tib',$
    wopws: '_data.pxl',$
    womws: '_data.mxl',$
    womes: '_data.mel',$
    worms: '_data.mrl',$
    wocpsamn: '_data.pml',$
    wopies: '_data.ixl',$
    wopets: '_data.exl',$
    wolidsb: '_data.lin',$
    sad: '_data.pcs'},$
    MainDRPlotsExt: { sqe: '.txt'},$
    FullNameOutputPlots: ptr_new(0L),$
    WidgetsToActivate: ptr_new(0L),$
    LoadingConfig: 1,$ ;will be 1 after loading config file
    instrument: 'BSS',$
    nexus_path: '/SNS/BSS/',$
    nexus_geometry_path: '/SNS/BSS/2006_1_2_CAL/' + $
    'calibrations/',$
    nexus_ext: '.nxs',$
    nexus_full_path: $
    '/Users/j35/SVN/HistoTool/branches/' + $
    'BSSreductionBranch/NeXus/BSS/BSS_246.nxs',$
    processing: 'PROCESSING',$
    PrevLinLogValue: 0,$ ;previously saved lin
    ;or log counts vs tof scale
    PrevFullLinLogValue: 0,$       ;previously saved
    ;lin or log full counts vs tof scale
    full_counts_vs_tof_data: ptr_new(0L),$ ;counts vs
    ;tof of full selected pixels
    output_full_counts_vs_tof_legend: '#TOF(microS) ' + $
    'Counts errCounts',$
    CountsVsTofAsciiArray: ptr_new(0L),$
    PreviewCountsVsTofAsciiArray: ptr_new(0L),$
    OutputMessageToAdd: '',$ ;message to add in
    ;output counts vs tof ascii file
    PrevExcludedSymbol: 0,$
    ColorSelectedPixel: 100,$
    ColorVerticalGrid: 85,$
    ColorHorizontalGrid: 85,$
    ColorExcludedPixels: 150,$
    LoadctMainPlot: 5,$
    DefaultColorVerticalGrid: 85,$
    DefaultColorHorizontalGrid: 85,$
    DefaultColorExcludedPixels: 150,$
    DefaultLoadctMainPlot: 5,$
    BSSselectionVersion: version,$ ;version of current program
    previous_tab: 0,$ ;default tab is 0 (Selection big tab)
    previous_counts_vs_tof_tab: 0,$ ;default counts
    ;vs tof tab is 0
    RunNumber: 0L, $ ;NeXus run number
    NexusFullName: '',$ ;Full nexus file name
    roi_path: '~/results/',$ ;path where to save the ROI file
    SavedRoiFullFileName: '',$ ;full file name of ROI file
    counts_vs_tof_path: '~/results/',$ ;path where to
    ;save the counts vs tof ascii file
    roi_ext: '_ROI.dat' ,$ ;extension of ROI files
    counts_vs_tof_ext: '_IvsTOF.txt' ,$ ;extension of
    ;ROI files
    roi_default_file_name: '',$ ;default roi file name
    ROI_error_status: 0,$ ;error status of the ROI process
    RoiPreviewArray: [0,10,50,100],$ ;roi array
    counts_vs_tof_x: 0L,$ ;x of actual counts vs tof plotted
    counts_vs_tof_y: 0L,$ ;y of actual counts vs tof plotted
    counts_vs_tof_bank: 0,$ ;bank of actual counts vs
    ;tof plotted
    true_x_min: 0.0000001,$ ;tof min for counts vs tof
    ;zoom plot
    true_x_max: 0.0000001,$ ;tof max for counts vs tof
    ;zoom plot
    true_full_x_min: 0.0000001,$ ;tof min for full counts
    ;vs tof zoom plot
    tmp_true_full_x_min: 0.00000001, $
    true_full_x_max: 0.0000001,$ ;tof max for full counts
    ;vs tof zoom plot
    NbTOF: 0L,$ ;number of tof for counts vs tof plot
    NeXusFound: 0,$ ;0: nexus has not been found, 1 nexus
    ;has been found
    NeXusFormatWrong: 0,$ ;if we are trying to open using hdf4
    ok: 'OK',$
    failed: 'FAILED',$
    bank1: ptr_new(0L),$ ;array of bank1 data (Ntof, Nx, Ny)
    bank1_sum: ptr_new(0L),$ ;array of bank1 data (Nx, Ny)
    bank2: ptr_new(0L),$ ;array of bank2 data (Ntof, Nx, Ny)
    bank2_sum: ptr_new(0L),$ ;array of bank2 data (Nx, Ny)
    pixel_excluded: ptr_new(0L),$ ;list of pixel excluded
    pixel_excluded_base: ptr_new(0L),$
    ;list of pixel excluded without counts removing
    default_pixel_excluded: ptr_new(0L),$
    pixel_excluded_size: 64*2*64L,$ ; total number of pixels
    TotalPixels: 8192L,$ ;Total number of pixels
    TotalRows: 128L,$ ;total number of rows
    TotalTubes: 128L,$ ;total number of tubes
    nexus_bank1_path: '/entry/bank1/data',$ ;nxdir path
    ;to bank1 data
    nexus_bank2_path: '/entry/bank2/data',$ ;nxdir path
    ;to bank2 data
    tof_path: '/entry/bank1/time_of_flight',$ ;nxdir path $
    ;to tof data
    Nx: 56,$
    Ny: 64,$
    Xfactor: 13,$ ;coefficient in X direction for rebining img
    Yfactor: 5,$ ; coefficient in Y direction for rebining img
    LogBookPath: '/SNS/users/LogBook/',$ ;path where
    ;to put the log book
    DefaultPath: '~/',$ ;default path where
    ;to look for the file
    DefaultFilter: '*.nxs'$ ;default filter for the
    ;nexus file
    })
    
  file_ok     = (*global).ok_bmp
  myIcon1     = READ_BMP(file_ok)
  myIcon2     = bytarr(16,16,3,/nozero)
  myIcon2[*,*,0] = myIcon1[2,*,*]
  myIcon2[*,*,1] = myIcon1[1,*,*]
  myIcon2[*,*,2] = myIcon1[0,*,*]
  (*(*global).icon_ok) = myIcon2
  
  file_failed = (*global).failed_bmp
  myIcon1     = READ_BMP(file_failed)
  myIcon2     = bytarr(16,16,3,/nozero)
  myIcon2[*,*,0] = myIcon1[2,*,*]
  myIcon2[*,*,1] = myIcon1[1,*,*]
  myIcon2[*,*,2] = myIcon1[0,*,*]
  (*(*global).icon_failed) = myIcon2
  
  ;sub_pkg_version: python program that gives pkg v. of common libraries...etc
  my_package = REPLICATE(PACKAGE_REQUIRED_BASE,4)
  ;number of packages we need to check
  my_package[0].driver           = 'findnexus'
  my_package[0].version_required = ''
  my_package[1].driver           = (*global).DriverName
  my_package[1].version_required = ''
  my_package[1].sub_pkg_version  = './drversion'
  my_package[2].driver           = (*global).iterative_background_DriverName
  my_package[2].version_required = ''
  my_package[3].driver           = (*global).stitch_driver
  my_package[3].version_required = ''
  
  (*global).negative_cosine_polar_array = ['-1.0','1.0','0.5']
  
  Device, /decomposed
  loadct, (*global).DefaultLoadctMainPlot, /SILENT
  
  XYfactor               = {Xfactor:(*global).Xfactor, $
    Yfactor:(*global).Yfactor}
  default_pixel_excluded = intarr((*global).pixel_excluded_size)
  
  ;Define Default Exclusion ROI file
  FOR j=0,1 DO BEGIN ;bank1 and bank2
    ;Exclude tubes 56-63 and 120-127
    FOR i=3584L,4095L DO BEGIN
      default_pixel_excluded[i+j*4096L]=1
    ENDFOR
  ENDFOR
  
  list1 = indgen(6)               ;row 0-6
  list2 = indgen(63-48)+49        ;row 49-63
  list3 = indgen(15)+4096L        ;row 64-78
  list4 = indgen(63-57)+58+4096L  ;row 122-127
  
  FOR i=1,55 DO BEGIN
    list1 = [list1, indgen(6) + i*64]
    list2 = [list2, indgen(63-48)+49 + i*64]
    list3 = [list3, indgen(15)+4096L + i*64]
    list4 = [list4, indgen(63-57)+58+4096L + i*64]
  ENDFOR
  
  default_pixel_excluded[[list1,list2,list3,list4]] = 1
  
  (*(*global).default_pixel_excluded) = default_pixel_excluded
  (*(*global).pixel_excluded)         = default_pixel_excluded
  (*(*global).pixel_excluded_base)    = default_pixel_excluded
  
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
    
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    MainBaseSize  = [30,25,1200,730]
  ENDIF ELSE BEGIN
    MainBaseSize  = [50,50,1200,730]
  ENDELSE
  (*global).MainBaseSize = MainBasesize
  
  MainBaseTitle = 'BSS reduction tool - ' + VERSION
  IF (DEBUGGING_VERSION EQ 'yes') THEN BEGIN
    MainBaseTitle += ' (DEBUGGING VERSION)'
  ENDIF
  
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
    mbar         = bar, $
    YPAD         = 2)
  
  ;config menu
  config = widget_button(bar, $
  value = 'Configuration',$
  /menu)
  load = widget_button(config, $
  uname = 'load_configuration',$
  value = 'Load ...')
  save = widget_button(config, $
  uname = 'save_configuration',$
  value = 'Save ...')
    
  ;attach global structure with widget ID of widget main base widget ID
  widget_control, MAIN_BASE, set_uvalue=global
  
  MakeGuiMainTab, MAIN_BASE, MainBaseSize, XYfactor
  
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='BSSreduction_Cleanup'
  ;XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  ; initialize slider (Grid: Vertical Lines)
  id = widget_info(Main_base,Find_by_Uname='color_slider')
  widget_control, id, set_value = (*global).ColorVerticalGrid
  
  ;??????????????????????????????????????????????????????????????????????????????
  IF (DEBUGGING_VERSION EQ 'yes' ) THEN BEGIN
    ;tab to show (main_tab)
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.main_tab
    ;tab to show (pixel_range_selection/scaling_tab)
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_input_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.reduce_input_tab
    
    ;refill gui with information
    nbr = N_TAGS(sDebugging.reduce)
    index =  0
    WHILE (index LT nbr) DO BEGIN
      putTextFieldValue_from_MainBase, MAIN_BASE, $
        sDebugging.reduce.(index).uname,$
        sDebugging.reduce.(index).value
      index++
    ENDWHILE
    
    ;change default path
    (*global).DefaultPath = sDebugging.DefaultPath
    
    
  ENDIF
  ;??????????????????????????????????????????????????????????????????????????????
  
  ;give extra power to j35, 2zr, ele, z3i, eg9
  IF (ucams EQ 'j35' OR $
    ucams EQ '2zr' OR $
    ucams EQ 'ele' OR $
    ucams EQ 'z3i' OR $
    ucams EQ 'eg9' OR $
    ucams EQ 'mid') THEN BEGIN
    id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME= 'command_line_generator_text')
    WIDGET_CONTROL, id, /EDITABLE
  ENDIF
  ;
  ;============================================================================
  ; Date and Checking Packages routines =======================================
  ;============================================================================
  ;Put date/time when user started application in first line of log book
  time_stamp = GenerateReadableIsoTimeStamp()
  message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
  IDLsendToGeek_putLogBookText_fromMainBase, MAIN_BASE, 'log_book', $
    message
    
  IF (CHECKING_PACKAGES EQ 'yes') THEN BEGIN
    CheckPackages, MAIN_BASE, global, my_package;_CheckPackages
  ENDIF
  
  ;==============================================================================
  
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
END


; Empty stub procedure used for autoloading.
pro bss_reduction, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





