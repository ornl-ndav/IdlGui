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
  MakeGuiFacilitySelection, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, $
    SCROLL=scroll
END

PRO BuildGui, SCROLL=scroll, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, facility

  ;get the current folder
  CD, CURRENT = current_folder
  
  file = OBJ_NEW('IDLxmlParser','SANScalibration.cfg')
  ;============================================================================
  ;****************************************************************************
  
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION = file->getValue(tag=['configuration','version'])
  DEBUGGING = file->getValue(tag=['configuration','debugging'])
  TESTING = file->getValue(tag=['configuration','testing'])
  CHECKING_PACKAGES = file->getValue(tag=['configuration','checking_packages'])
  SCROLLING = scroll
  
  ;************************************************************************
  ;************************************************************************
  
  PACKAGE_REQUIRED_BASE = { driver:           '',$
    version_required: '',$
    found: 0,$
    sub_pkg_version:   ''}
  ;sub_pkg_version: python program that gives pkg v. of common libraries...etc
  my_package = REPLICATE(PACKAGE_REQUIRED_BASE,4)
  my_package[0].driver           = 'findnexus'
  my_package[0].version_required = '1.5'
  my_package[1].driver           = 'sas_transmission'
  my_package[1].version_required = '1.0'
  my_package[1].sub_pkg_version  = './drversion'
  my_package[2].driver           = 'sas_background'
  my_package[2].version_required = '1.0'
  my_package[3].driver           = 'tof_slicer'
  
  ;*************************************************************************
  ;*************************************************************************
  
  ;works only on dev and pick up ~/bin/runenv before the command line
  
  ;define initial global values - these could be input via external
  ;file or other means
  
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    ucams = 'j35'
  ENDIF ELSE BEGIN
    ucams = get_ucams()
  ENDELSE
  
  ;define global variables
  global = PTR_NEW ({version:         VERSION,$
    facility: facility,$
    
    previous_button: 'SANScalibration_images/previous.png',$
    play_button: 'SANScalibration_images/play.png',$
    pause_button: 'SANScalibration_images/pause.png',$
    stop_button: 'SANScalibration_images/stop.png',$
    next_button: 'SANScalibration_images/next.png',$
    play_button_active: 'SANScalibration_images/play_active.png',$
    pause_button_active: 'SANScalibration_images/pause_active.png',$
    stop_button_active: 'SANScalibration_images/stop_active.png',$
    next_button_active: 'SANScalibration_images/next_active.png',$
    previous_button_active: 'SANScalibration_images/previous_active.png',$
    previous_disable_button: 'SANScalibration_images/previous_disable.png',$
    play_disable_button: 'SANScalibration_images/play_disable.png',$
    pause_disable_button: 'SANScalibration_images/pause_disable.png',$
    stop_disable_button: 'SANScalibration_images/stop_disable.png',$
    next_disable_button: 'SANScalibration_images/next_disable.png',$
    
    tof_buttons_activated: 1,$
    status_buttons: INTARR(5),$
    previous_button_clicked: 4,$ ;play by default
    
    tof_min_index: 0.0,$
    tof_max_index: 0.0,$
    time_per_frame: 0.0,$
    bins_range: 0.0,$
    tof_range: 0.0,$
    bin_per_frame: 0.0,$
    
    facility_list: ['LENS'],$
    facility_flag: '--facility',$
    instrument_list: ['SANS'],$
    instrument_flag: '--inst',$
    
    main_base_uname: 'MAIN_BASE',$
    MainBaseSize:    INTARR(4),$
    tof_ascii_path:  '~/',$
    tof_ascii_name: '',$
    tof_ascii_path_backup:  '~/',$
    tof_ascii_type:  '',$
    tof_ascii_file_name: '',$
    tof_monitor_flag: '--data-paths',$
    tof_monitor_path: '/entry/monitor,1',$
    tof_monitor_path1: '/entry/monitor1,1',$
    tof_roi_flag: '--roi-file',$
    package_required_base: PTR_NEW(0L),$
    advancedToolId: 0,$
    tof_slicer: 'tof_slicer',$
    list_OF_files_to_send: PTR_NEW(0L),$
    auto_output_file_name: 1,$
    Xpixel: 80L,$     ;320 or 80
    mouse_status: 0,$ ;0:nothing, 1:has been pressed
    rectangle_XY0_mouse: [0,0],$
    rectangle_XY1_mouse: [0,0],$
    rectangle_selection_color: 50,$
    current_output_file_name: '',$
    MainBaseTitle: '',$
    sys_color_face_3d: INTARR(3),$
    DisplayR1:        0.,$
    DisplayR2:        0.,$
    there_is_a_selection: 0,$
    exclusion_type_index: 0,$ ;0,1,2 or 3
    TESTING:         TESTING,$
    fitting_status:  1,$        ;0:succes, 1:failed
    ascii_file_load_status: 0,$ ;1:success, 0:failed
    txt_extension:   'bkg',$
    txt_filter:      ['*.txt','*.bkg'],$
    txt_title:       'Browse for an TXT file',$
    txt_path:        '~/',$
    application:     APPLICATION,$
    ROIcolor:        250L,$
    DrawXcoeff:      8,$
    DrawYcoeff:      8,$
    ucams:           ucams,$
    DataArray:       PTR_NEW(0L),$
    tof_array:       PTR_NEW(0L),$
    tof_min:         0.0,$
    tof_max:         0.0,$
    pressed_stop:    0,$
    img:             PTR_NEW(0L),$
    rtDataXY:        PTR_NEW(0L),$
    X:               0L,$
    Y:               0L,$
    PrevTabSelect:   0,$
    processing:      '(PROCESSING)',$
    ok:              'OK',$
    failed:          'FAILED',$
    NOT_found:       'NOT_FOUND',$
    roi_extension:   '.dat',$
    roi_filter:      '*.dat',$
    roi_path:        '~/',$
    geo_extension:   'nxs',$
    geo_filter:      '*.nxs',$
    geo_path:        '/LENS/',$
    nexus_extension: 'nxs',$
    nexus_filter:    '*.nxs',$
    nexus_title:     'Browse for a Data NeXus File',$
    nexus_path:      '/LENS/',$
    selection_extension: 'dat',$
    selection_filter: '*.dat',$
    selection_title:  'Browse for a ROI file',$
    selection_path:   '~/',$
    RoiPixelArrayExcluded: PTR_NEW(0L),$
    ascii_trans_extension: '.txt',$
    ascii_back_extension: '.bkg',$
    ascii_trans_filter: '*.txt',$
    ascii_back_filter:  '*.bkg',$
    ascii_path:      '~/',$
    ascii_title:     'Browse for a Transmission ASCII File',$
    data_nexus_file_name: '',$
    short_data_nexus_file_name: '',$
    path_data_nexus_file: '',$
    inst_geom:       '',$
    Xarray:           PTR_NEW(0L),$
    Xarray_untouched: PTR_NEW(0L),$
    Yarray:           PTR_NEW(0L),$
    SigmaYarray:      PTR_NEW(0L),$
    xaxis:            '',$
    xaxis_units:      '',$
    yaxis:            '',$
    yaxis_units:      '',$
    beam_monitor_data_path: ['/entry/monitor/data/',$
    '/entry/monitor1/data/'],$
    beam_monitor_flag: ['/entry/monitor,1',$
    '/entry/monitor1,1'],$
    ReducePara: {transmission_driver_name: $
    my_package[1].driver,$
    background_driver_name: $
    my_package[2].driver, $
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
    
    detector_efficiency: {flag: $
    '--det-effc',$
    default: $
    1},$ ;on/OFF
    detector_efficiency_scale: $
    '--det-eff-scale-const',$
    detector_efficiency_attenuator: $
    '--det-eff-atten-const',$
    
    monitor_efficiency_constant: $
    '--mon-eff-const',$
    verbose: $
    '--verbose',$
    acc_down_time: $
    '--acc-down-time',$
    min_lambda_cut_off:$
    '--lambda-low-cut',$
    max_lambda_cut_off:$
    '--lambda-high-cut',$
    monitor_rebin: $
    '--mom-trans-bins',$
    roi_file: $
    '--roi-file'},$
    CorrectPara: {transm_back: {title: $
    'Transmission Background',$
    flag: $
    '--back'},$
    roi:         {title: $
    'ROI File',$
    flag: $
    '--roi-file'},$
    sample_data_trans: {flag: $
    '--data-trans'},$
    empty_can_trans: {flag: $
    '--ecan-trans'},$
    wavelength_range: {title:$
    'Wavelength Range',$
    flag: $
    '--lambda-bins'}},$
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
    '--dump-wave-bmnom',$
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
    
  MainBaseTitle  = 'SANS Data Calibration GUI '
  (*global).MainBaseTitle = MainBaseTitle
  MainBaseTitle += '( Mode: Transmission ) '
  MainBaseSize   = [30,25,695+320,550+320]
  (*global).MainBaseSize = MainBaseSize
  MainBaseTitle += ' - ' + VERSION
  
  (*(*global).RoiPixelArrayExcluded) = INTARR(80,80)
  
  ;==============================================================================
  ;Build Main Base ==============================================================
  IF (SCROLLING EQ 'yes') THEN BEGIN
    MAIN_BASE = WIDGET_BASE( GROUP_LEADER  = wGroup,$
      UNAME         = (*global).main_base_uname,$
      SCR_XSIZE     = MainBaseSize[2],$
      XOFFSET       = MainBaseSize[0],$
      YOFFSET       = MainBaseSize[1],$
      TITLE         = MainBaseTitle,$
      SPACE         = 0,$
      XPAD          = 0,$
      YPAD          = 2,$
      X_SCROLL_SIZE = 500,$
      Y_SCROLL_SIZE = 500,$
      MBAR          = WID_BASE_0_MBAR)
  ENDIF ELSE BEGIN
    MAIN_BASE = WIDGET_BASE( GROUP_LEADER = wGroup,$
      UNAME        = (*global).main_base_uname,$
      SCR_XSIZE    = MainBaseSize[2],$
      SCR_YSIZE    = MainBaseSize[3],$
      XOFFSET      = MainBaseSize[0],$
      YOFFSET      = MainBaseSize[1],$
      TITLE        = MainBaseTitle,$
      SPACE        = 0,$
      XPAD         = 0,$
      YPAD         = 2)
  ENDELSE
  
  ;get the color of the GUI to hide the widget_draw that will label the draw
  sys_color = WIDGET_INFO(MAIN_BASE,/SYSTEM_COLORS)
  (*global).sys_color_face_3d = sys_color.face_3d
  
  ;attach global structure with widget ID of widget main base widget ID
  WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global
  
  ;Build Tab1
  make_gui_main_tab, MAIN_BASE, MainBaseSize, global
  
  WIDGET_CONTROL, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, $
    CLEANUP='sans_calibration_cleanup'
    
  ;give superpower to j35 and 2zr
  IF (ucams EQ 'j35' OR $
    ucams EQ '2zr') THEN BEGIN
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='command_line_preview')
    WIDGET_CONTROL, id, /EDITABLE
  ENDIF
  
  ;==============================================================================
  ;debugging version of program
  ;  IF (DEBUGGING EQ 'yes' AND $
  ;    ucams EQ 'j35') THEN BEGIN
  IF (DEBUGGING EQ 'yes') THEN BEGIN
  
    nexus_path = '~/tmp/'
    (*global).nexus_path = nexus_path
    (*global).ascii_path = '~/SVN/IdlGui/branches/SANScalibration/1.0/'
    (*global).selection_path = '~/SVN/IdlGui/branches/SANScalibration/1.0/'
    ;populate the FITTING tab (ascii file name)
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='input_file_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='~/SVN/IdlGui/branches/SANScalibration/1.1/SANS_175_new.txt'
      
    ;min,max and width
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='alternate_wave_min_text_field')
    WIDGET_CONTROL, id, SET_VALUE='0'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='alternate_wave_max_text_field')
    WIDGET_CONTROL, id, SET_VALUE='25'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='alternate_wave_width_text_field')
    WIDGET_CONTROL, id, SET_VALUE='0.5'
    
    ;activate load button
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='input_file_load_button')
    WIDGET_CONTROL, id, $
      SENSITIVE = 1
    ;populate the REDUCE tab to be able to run right away
    ;Data File text field (Load Files)
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='data_file_name_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='/LENS/SANS/EXP005/2/536/NeXus/SANS_536.nxs'
    ;roi file
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='roi_file_name_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='/SNS/users/j35/SVN/IdlGui/branches/SANScalibration/1.1/my_roi.dat'
    ;transmission background file
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='transm_back_file_name_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='/LENS/SANS/EXP005/2/537/NeXus/SANS_537.nxs
    ;Time Zero Offset (Parameters)
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='time_zero_offset_detector_uname')
    WIDGET_CONTROL, id, $
      SET_VALUE='500'
    id = WIDGET_INFO(MAIN_BASE, $
      FIND_BY_UNAME='time_zero_offset_beam_monitor_uname')
    WIDGET_CONTROL, id, $
      SET_VALUE='500'
    ;Wavlength range (Parameters)
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='wave_min_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='0.1'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='wave_max_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='5'
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='wave_width_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='0.1'
      
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
      
    ;show main tab # ?
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 1
    ;show tab inside REDUCE
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 1
    
  ENDIF
  
  ;display the png files
  ;display_buttons, MAIN_BASE = MAIN_BASE, ACTIVATE=2, global
  
  IF (facility EQ 'LENS') THEN BEGIN
  
    ;change color of background
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='label_draw_uname')
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    ;ERASE, COLOR=convert_rgb(sys_color.face_3d)
    
    PLOT, RANDOMN(s,80), $
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
  
  ;=============================================================================
  ; Date and Checking Packages routines ========================================
  ;=============================================================================
  ;Put date/time when user started application in first line of log book
  time_stamp = GenerateIsoTimeStamp()
  message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
  IDLsendToGeek_putLogBookText_fromMainBase, MAIN_BASE, 'log_book_text', $
    message
    
  IF (CHECKING_PACKAGES EQ 'yes') THEN BEGIN
    checking_packages_routine, MAIN_BASE, my_package, global
  ENDIF
  
  ;=============================================================================
  ;=============================================================================
  
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
  
END

;==============================================================================
PRO sans_calibration_cleanup, MAIN_BASE
  ;if tof_base is active, close it here

  WIDGET_CONTROL, MAIN_BASE, get_uvalue=global
  PTR_FREE, global
  
END





