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

PRO BuildFacilityGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, SCROLL=scroll
  ;build the facility Selection base
;  MakeGuiFacilitySelection, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, $
;    SCROLL=scroll

    BuildGui, SCROLL=scroll, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, 'SNS'

END

;------------------------------------------------------------------------------
PRO SANSreduction_Cleanup, tlb

  WIDGET_CONTROL, tlb, GET_UVALUE=global, /NO_COPY
  
  ;destroy based mapped
  id_array = [(*global).plot_tab_fitting_wBase,$ ;fitting equation
    (*global).transmission_launcher_base_id, $ ;transmission launcher
    (*global).transmission_auto_mode_id, $ ;auto transmission
    (*global).transmission_manual_mode_id,$] ;manual transmission
  (*global).beam_center_base_id] ;beam center calculation
  sz = N_ELEMENTS(id_array)
  FOR i=0,sz-1 DO BEGIN
    IF (WIDGET_INFO(id_array[i], /VALID_ID) NE 0) THEN BEGIN
      WIDGET_CONTROL, id_array[i], /DESTROY
    ENDIF
  ENDFOR
  
  IF N_ELEMENTS(global) EQ 0 THEN RETURN
  
  ; Free up the pointers
  PTR_FREE, (*global).global_exclusion_array
  PTR_FREE, (*global).background
  PTR_FREE, (*global).BankArray
  PTR_FREE, (*global).TubeArray
  PTR_FREE, (*global).PixelArray
  PTR_FREE, (*global).PixelArray_of_DeadTubes
  PTR_FREE, (*global).dead_tube_nbr
  PTR_FREE, (*global).back_bank
  PTR_FREE, (*global).front_bank
  PTR_FREE, (*global).both_banks
  PTR_FREE, (*global).package_required_base
  PTR_FREE, (*global).list_OF_files_to_send
  PTR_FREE, (*global).Xarray
  PTR_FREE, (*global).Xarray_untouched
  PTR_FREE, (*global).Yarray
  PTR_FREE, (*global).SigmaYarray
  PTR_FREE, (*global).rtDataXY
  PTR_FREE, (*global).DataArray
  PTR_FREE, (*global).img
  PTR_FREE, (*global).RoiPixelArrayExcluded
  PTR_FREE, global
  
END

;------------------------------------------------------------------------------
PRO BuildGui, SCROLL=scroll, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, facility

  ;get the current folder
  CD, CURRENT = current_folder
  
  file = OBJ_NEW('IDLxmlParser','SANSreduction.cfg')
  ;============================================================================
  ;****************************************************************************
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION = file->getValue(tag=['configuration','version'])
  DEBUGGING = file->getValue(tag=['configuration','debugging'])
  TESTING = file->getValue(tag=['configuration','testing'])
  TESTING_ON_MAC = file->getValue(tag=['configuration','testing_on_mac'])
  SCROLLING = scroll
  CHECKING_PACKAGES = file->getValue(tag=['configuration','checking_packages'])
  EQSANS_REDUCE = file->getValue(tag=['configuration','eqsans_reduce'])
  EQSANS_REDUCE_MPI = file->getValue(tag=['configuration','eqsans_reduce_mpi'])
  TUBE_SIZE = file->getValue(tag=['configuration','tube_size'])
  PIXEL_SIZE = file->getValue(tag=['configuration','pixel_size'])
  ;****************************************************************************
  ;============================================================================
  
  PACKAGE_REQUIRED_BASE = { driver:           '',$
    version_required: '',$
    found: 0,$
    sub_pkg_version:   ''}
  ;sub_pkg_version: python program that gives pkg v.
  my_package = REPLICATE(PACKAGE_REQUIRED_BASE,3)
  my_package[0].driver           = 'findnexus'
  my_package[0].version_required = '1.5'
  my_package[1].driver           = 'sas_reduction'
  my_package[1].version_required = ''
  my_package[1].sub_pkg_version  = './drversion'
  my_package[2].driver           = 'findcalib'
  ;************************************************************************
  ;************************************************************************
  
  ;works only on dev and pick up ~/bin/runenv before the command line
  
  ;define initial global values - these could be input via external
  ;file or other means
  
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  
  IF (facility EQ 'LENS') THEN BEGIN
    geo_path = '/LENS/'
    nexus_path = '/LENS/'
    instrument = 'EQSANS'
  ENDIF ELSE BEGIN
    geo_path = '/SNS/'
    nexus_path = '/SNS/'
    instrument = 'SANS'
  ENDELSE
  
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    ucams = 'j35'
  ENDIF ELSE BEGIN
    ucams = get_ucams()
  ENDELSE
  
  wave_para_label = 'Comma-delimited List of Increasing Coefficients'
  wave_para_help_label = '1 + 23*X + 6*X^2 + 7890*X^3   --->'
  wave_para_help_value = '1,23,456,7890'
  ;define global variables
  global = PTR_NEW ({version:         VERSION,$
    scaling_value: '',$
    build_command_line: 1,$
    testing_on_mac: testing_on_mac, $
    
    tube_size: FLOAT(TUBE_SIZE), $
    pixel_size: FLOAT(PIXEL_SIZE), $
    
    circle_exclusion_help_base: 0L, $ ;id of circle exclusion help base
    circular_tube_list: PTR_NEW(0L), $
    circular_pixel_list: PTR_NEW(0L), $
    sector_tube_list: ptr_new(0L),$
    sector_pixel_list: ptr_new(0L),$
    
    run_number: '',$
    jk_selection_x0y0x1y1: PTR_NEW(0L), $
    jk_selection_xyr: PTR_NEW(0L), $
    jk_selection_sector: ptr_new(0L),$
    
    eqsans_reduce: EQSANS_REDUCE, $
    eqsans_reduce_mpi: EQSANS_REDUCE_MPI, $
    
    sns_jk_switch: 'sns',$
    jk_default_value: {sample_detector: 'N/A',$
    sample_detector_with_units: 'N/A',$
    monitor_detector: '10.0',$
    monitor_source: '',$
    detector_source: '',$
    source_rate: '60',$
    sample_source: '14.0',$
    number_of_pixels: {x : '192',$
    y: '256'},$
    pixels_size: {x: '5.5',$
    y: '4.0467'}},$
    
    draw_x: 3*192L,$
    draw_y: 3*256L,$
    left_button_clicked: 0,$
    mouse_moved: 0,$
    dead_tube_coeff_ratio: 100., $ ;coeff used to determine if a tube is dead or not
    
    tof_array: PTR_NEW(0L), $
    selection_type: 'inside', $ ;'inside' or 'outside'
    selection_shape_type: 'rectangle',$
    
    ;counts vs tof plot
    tof_counts: PTR_NEW(0L), $
    array_of_tof_bins: PTR_NEW(0L), $
    tof_tof: PTR_NEW(0L), $
    tof_range: { min: 0.,$ ;min and max value of tof selected in counts vs tof
    max: 0.}, $
    tof_tools_base: 0, $
    tof_fields_mode1: {from: { bin: 0,$
    tof: 0.}, $
    to: { bin: 0,$
    tof: 0.}}, $
    tof_fields_mode2: {from: { bin: 0,$
    tof: 0.}, $
    to: { bin: 0,$
    tof: 0.}}, $
    
    x0_device: 0L,$
    y0_device: 0L,$
    x1_device: 0L,$
    y1_device: 0L,$
    global_exclusion_array: PTR_NEW(0L),$
    background: PTR_NEW(0L),$
    BankArray: PTR_NEW(0L),$
    TubeArray: PTR_NEW(0L),$
    PixelArray: PTR_NEW(0L),$
    PixelArray_of_DeadTubes: PTR_NEW(0L),$
    dead_tube_nbr: PTR_NEW(0L),$
    
    facility: facility, $
    facility_list: ['LENS'],$
    facility_flag: '--facility',$
    instrument_list: ['SANS'],$
    instrument_flag: '--inst',$
    instrument: instrument,$
    
    back_bank: PTR_NEW(0L),$
    front_bank: PTR_NEW(0L),$
    both_banks: PTR_NEW(0L),$
    
    congrid_x_coeff: 1.,$
    congrid_y_coeff: 1.,$
    
    package_required_base: ptr_new(0L),$
    advancedToolId: 0,$
    list_OF_files_to_send: ptr_new(0L),$
    auto_output_file_name: 1,$
    Xpixel: 80L,$ ;320 or 80
    help: 'SANSreductionHelp/sans_reduction.adp',$
    current_output_file_name: '',$
    sys_color_face_3d: INTARR(3),$
    DisplayR1:        0.,$
    DisplayR2:        0.,$
    there_is_a_selection: 0,$
    exclusion_type_index: 0,$ ;0,1,2 or 3
    fitting_status:  1,$ ;0:succes, 1:failed
    txt_extension:   'txt',$
    txt_filter:      '*.txt',$
    txt_title:       'Browse for an TXT file',$
    txt_path:        '~/results/',$
    output_path:     '~/results/',$
    ascii_extension: 'txt',$
    ascii_filter:    '*.txt',$
    ascii_path:      '~/results/',$
    ascii_title:     'Browse for an ASCII data file',$
    xaxis:           '',$
    xaxis_units:     '',$
    yaxis:           '',$
    yaxis_units:     '',$
    Xarray:          ptr_new(0L),$
    Xarray_untouched: ptr_new(0L),$
    Yarray:          ptr_new(0L),$
    SigmaYarray:     ptr_new(0L),$
    rtDataXY:        ptr_new(0L),$
    ROIcolor:        250L,$
    DrawXcoeff:      8,$
    DrawYcoeff:      8,$
    TESTING:         TESTING,$
    application:     APPLICATION,$
    ucams:           ucams,$
    DataArray:       ptr_new(0L),$
    img:             ptr_new(0L),$
    X:               0L,$
    Y:               0L,$
    PrevTabSelect:   0,$
    processing:      '(PROCESSING)',$
    ok:              'OK',$
    failed:          'FAILED',$
    roi_extension:   '.dat',$
    roi_filter:      '*.dat',$
    roi_path:        '~/results/',$
    geo_extension:   'nxs',$
    geo_filter:      '*.nxs',$
    geo_path:        geo_path,$
    nexus_extension: 'nxs',$
    nexus_filter:    '*.nxs',$
    nexus_title:     'Browse for a Data NeXus File',$
    nexus_path:       nexus_path,$
    selection_extension: 'dat',$
    selection_filter: '*.dat',$
    selection_title:  'Browse for a ROI file',$
    selection_path:   '~/results/',$
    RoiPixelArrayExcluded: ptr_new(0L),$
    data_nexus_file_name: '',$
    short_data_nexus_file_name: '',$
    path_data_nexus_file: '',$
    inst_geom:       '',$
    wave_para_value: '',$
    
    ;Transmission Field Calculation
    mass_neutron: DOUBLE(1.67493e-27), $  ;kg
    planck_constant: DOUBLE(6.626068e-34), $ ;m^2 Kg/s
    
    ;Bases ids
    transmission_launcher_base_id: 0, $
    transmission_auto_mode_id: 0, $
    transmission_manual_mode_id: 0, $
    beam_center_base_id: 0,$
    
    ;Plot tab
    plot_left_click: 0b, $ ;1b when left click pressed (for zoom)
    xyminmax: FLTARR(4), $ ;xmin, ymin, xmax and ymax data values for zoom
    old_xyminmax: FLTARR(4), $
    plot_selection_style: { linestyle: 0,$ ;information about style of selection
    color: 'blue',$
    thick: 2},$
    plot_tab_fitting_wBase: 0L, $
    ascii_file_load_status: 0b, $
    plot_tab_fitting_help_message: 'Select range of data to use for fitting', $
    Yminmax: FLTARR(2), $ ;min and max value of y
    xminmax_fitting: FLTARR(2), $ ;min and max value of fitting range
    Xarray_fitting: PTR_NEW(0L), $
    Yarray_fitting: PTR_NEW(0L), $
    SigmaYarray_fitting: PTR_NEW(0L), $
    fitting_to_plot: 0b, $
    fitting_a_coeff: 0., $
    fitting_b_coeff: 0., $
    fitted_coeff_equation: {b: '',$ ;all the coeff displayed in the equation base
    a: '',$
    I: '',$
    R: ''},$
    Xarray_fitting_for_fitting_plot: PTR_NEW(0L), $
    Yarray_fitting_for_fitting_plot: PTR_NEW(0L), $
    last_fitting_performed: {xaxis_type:'',$
    yaxis_type: ''},$
    
    wave_para_label: wave_para_label,$
    wave_para_help_label: wave_para_help_label,$
    wave_para_help_value: wave_para_help_value,$
    wave_dep_back_sub_path: '~/',$
    beam_monitor_data_path: ['/entry/monitor/data/',$
    '/entry/monitor1/data/'],$
    beam_monitor_flag: ['/entry/monitor,1',$
    '/entry/monitor1,1'],$
    ReducePara: {driver_name: $
    'sas_reduction',$
    overwrite_geo: $
    '--inst-geom',$
    detect_time_offset: $
    '--time-zero-offset-det',$
    monitor_time_offset: $
    '--time-zero-offset-mon',$
    monitor_efficiency: {flag: $
    '--mon-effc',$
    default: $
    1},$ ;on/OFF
    monitor_efficiency_constant: $
    '--mon-eff-const',$
    
    detector_efficiency: {flag: $
    '--det-effc',$
    default: $
    1},$ ;on/OFF
    detector_efficiency_scale: $
    '--det-eff-scale-const',$
    detector_efficiency_attenuator: $
    '--det-eff-atten-const',$
    
    verbose: $
    '--verbose',$
    min_lambda_cut_off:$
    '--lambda-low-cut',$
    max_lambda_cut_off:$
    '--lambda-high-cut',$
    monitor_rebin: $
    '--mom-trans-bins',$
    wave_dep_back_sub:$
    '--bkg-coeff',$
    roi_file: $
    '--roi-file'},$
    scaling_value_flag: '--bkg-scale',$
    accelerator_data_flag: '--data-acc-down-time',$
    accelerator_solvent_flag: '--solv-acc-down-time',$
    accelerator_empty_can_flag: '--ecan-acc-down-time',$
    accelerator_open_beam_flag: '--open-acc-down-time',$
    CorrectPara: {solv_buffer: {title: $
    'Solvant Buffer Only',$
    flag: $
    '--solv'},$
    roi:         {title: $
    'ROI File',$
    flag: $
    '--roi-file'},$
    empty_can:    {title: $
    'Empty Can',$
    flag: $
    '--ecan'},$
    solvent:    {title: $
    'Solvent Transmission',$
    flag: $
    '--solv-trans'},$
    open_beam:    {title: $
    'Open Beam (shutter open)',$
    flag: $
    '--open'},$
    dark_current: {title: $
    'Dark Current (shutter ' + $
    'closed)',$
    flag: $
    '--dkcur'},$
    scale: {flag: $
    '--rescale-final'},$
    sample_data_trans: {flag: $
    '--data-trans'},$
    empty_can_trans: {flag: $
    '--ecan-trans'}},$
    IntermPara: {bmon_wave: {title: $
    'Beam Monitor after ' + $
    'Conversion to Wavelength',$
    flag: $
    '--dump-bmon-wave'},$
    bmon_effc: {title: $
    'Beam Monitor in Wavelenght' + $
    ' after Efficiency correction',$
    flag: $
    '--dump-bmon-effc'},$
    bmnon_wave: {title: $
    'Combined Spectrum of Data' + $
    ' after Beam Monitor ' + $
    'Normalization',$
    flag: $
    '--dump-wave-bmnorm',$
    flag1: $
    '--lambda-bins'},$
    wave:        {title: $
    'Data of Each Pixel after' + $
    ' Wavelength Conversion' + $
    ' (WARNING: HUGE FILE !)',$
    flag: $
    '--dump-wave'},$
    fract_counts: {title: $
    'Fractional Counts and Area' + $
    ' after Q Rebinning (Two ' + $
    'Files)',$
    flag: $
    '--dump-frac-rebin'},$
    bmon_rebin : {title: $
    'Monitor Spectrum after' + $
    ' Rebin to Detector' + $
    ' Wavelength Axis' + $
    ' (WARNING: HUGE FILE !)',$
    flag: $
    '--dump-bmon-rebin'}}$
    })
    
  (*(*global).global_exclusion_array) = STRARR(1)
  
  MainBaseTitle  = 'SANS Data Reduction GUI'
  MainBaseTitle += ' for ' + facility
  IF (facility EQ 'LENS') THEN BEGIN
    MainBaseSize   = [30,25,695+320,530+320]
  ENDIF ELSE BEGIN
    MainBaseSize   = [30,25,695+320,530+390]
  ENDELSE
  MainBaseTitle += ' - ' + VERSION
  
  (*(*global).RoiPixelArrayExcluded) = INTARR(80,80)
  
  ;============================================================================
  ;Build Main Base ============================================================
  IF (SCROLLING EQ 'yes') THEN BEGIN
    MAIN_BASE = WIDGET_BASE( GROUP_LEADER  = wGroup,$
      UNAME         = 'MAIN_BASE',$
      SCR_XSIZE     = MainBaseSize[2],$
      XOFFSET       = MainBaseSize[0],$
      YOFFSET       = MainBaseSize[1],$
      TITLE         = MainBaseTitle,$
      SPACE         = 0,$
      XPAD          = 0,$
      YPAD          = 2,$
      X_SCROLL_SIZE = 500,$
      Y_SCROLL_SIZE = 500)
  ;      MBAR          = WID_BASE_0_MBAR)
  ENDIF ELSE BEGIN
    MAIN_BASE = WIDGET_BASE( GROUP_LEADER = wGroup,$
      UNAME        = 'MAIN_BASE',$
      SCR_XSIZE    = MainBaseSize[2],$
      SCR_YSIZE    = MainBaseSize[3],$
      XOFFSET      = MainBaseSize[0],$
      YOFFSET      = MainBaseSize[1],$
      TITLE        = MainBaseTitle,$
      SPACE        = 0,$
      XPAD         = 0,$
      YPAD         = 2)
  ;      MBAR         = WID_BASE_0_MBAR)
  ENDELSE
  
  ;  ;HELP MENU in Menu Bar
  ;  HELP_MENU = WIDGET_BUTTON(WID_BASE_0_MBAR,$
  ;    UNAME = 'help_menu',$
  ;    VALUE = 'HELP',$
  ;    /MENU)
  ;
  ;  HELP_BUTTON = WIDGET_BUTTON(HELP_MENU,$
  ;    VALUE = 'HELP',$
  ;    UNAME = 'help_button')
  
  ;get the color of the GUI to hide the widget_draw that will label the draw
  sys_color = WIDGET_INFO(MAIN_BASE,/SYSTEM_COLORS)
  (*global).sys_color_face_3d = sys_color.face_3d
  
  ;attach global structure with widget ID of widget main base widget ID
  widget_control, MAIN_BASE, SET_UVALUE=global
  
  ;Build Tab1
  make_gui_main_tab, MAIN_BASE, MainBaseSize, global
  
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='SANSreduction_Cleanup'
  
  ;============================================================================
  ;debugging version of program
  IF (DEBUGGING EQ 'yes' AND $
    ucams EQ 'j35') THEN BEGIN
    ;nexus_path           = '~/SVN/IdlGui/branches/SANSreduction/1.0'
    nexus_path           = '~/EQSANS/2009_2_6_SCI/1/118/NeXus/'
    ;nexus_path           = '/SNS/EQSANS/2009_2_6_SCI/1/71/NeXus/'
    (*global).nexus_path = nexus_path
    (*global).selection_path = '~/results/'
    (*global).wave_dep_back_sub_path = $
      '~/SVN/IdlGui/branches/SANScalibration/1.0/'
    ;put run 45 in the Run Number Data (first tab)
    ;id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='run_number_cw_field')
    ;WIDGET_CONTROL, id, $
    ;  SET_VALUE=''
    ;populate the REDUCE tab to be able to run right away
    ;Data File text field (Load Files)
    ;id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='data_file_name_text_field')
    ;WIDGET_CONTROL, id, $
    ;  SET_VALUE='/LENS/SANS/2008_01_COM/1/45/NeXus/SANS_45.nxs'
      
    IF (facility EQ 'LENS') THEN BEGIN
      ;exclusion tool
      id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='x_center_value')
      WIDGET_CONTROL, id, $
        SET_VALUE='37.25'
      id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='y_center_value')
      WIDGET_CONTROL, id, $
        SET_VALUE='41.625'
      id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='r1_radii')
      WIDGET_CONTROL, id, $
        SET_VALUE='5'
      id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='r2_radii')
      WIDGET_CONTROL, id, $
        SET_VALUE='0'
    ENDIF
    
    ;show tab #2 'REDUCE
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 0
    
    MapBase_from_base, BASE=main_base, uname='sns_reduction_base', 0
    display_reduction_interruptor, MAIN_BASE=main_base, mode='jk'
    (*global).sns_jk_switch = 'jk'
    ;advanced base of JK's reduction
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='jk_reduction_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 0
  ;part 2
  ;id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_jk_advanced_tab')
  ;WIDGET_CONTROL, id1, SET_TAB_CURRENT = 0
    
  ENDIF
  
  IF (facility EQ 'LENS') THEN BEGIN
  
    ;change color of background
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='label_draw_uname')
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    ;ERASE, COLOR=convert_rgb(sys_color.face_3d)
    
    PLOT, randomn(s,80), $
      XRANGE     = [0,80],$
      YRANGE     = [0,80],$
      COLOR      = convert_rgb([0B,0B,255B]), $
      BACKGROUND = convert_rgb(sys_color.face_3d),$
      THICK      = 1, $
      TICKLEN    = -0.015, $
      XTICKLAYOUT = 0,$
      YTICKLAYOUT = 0,$
      XTICKS      = 8,$
      YTICKS      = 8,$
      XMARGIN     = [5,5],$
      /NODATA
      
  ENDIF
  
  IF (facility EQ 'SNS') THEN BEGIN
    display_images, MAIN_BASE=main_base
    display_circle_rectangle_buttons, MAIN_BASE=main_base
  END
  
  
  ;============================================================================
  ; Date and Checking Packages routines =======================================
  ;============================================================================
  ;Put date/time when user started application in first line of log book
  time_stamp = GenerateIsoTimeStamp()
  message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
  IDLsendToGeek_putLogBookText_fromMainBase, MAIN_BASE, 'log_book_text', $
    message
    
  IF (CHECKING_PACKAGES EQ 'yes') THEN BEGIN
    checking_packages_routine, MAIN_BASE, my_package, global
  ENDIF
  
  ;============================================================================
  ;============================================================================
  
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
;tof_tools_base, main_base=MAIN_BASE
  
END


