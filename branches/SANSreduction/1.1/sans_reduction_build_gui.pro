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

PRO BuildGui, SCROLL=scroll, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;get the current folder
  CD, CURRENT = current_folder
  
  ;************************************************************************
  ;************************************************************************
  APPLICATION       = 'SANSreduction'
  VERSION           = '1.1.1'
  DEBUGGING         = 'no' ;yes/no
  TESTING           = 'no'
  SCROLLING         = scroll
  CHECKING_PACKAGES = 'yes'
  
  PACKAGE_REQUIRED_BASE = { driver:           '',$
    version_required: '',$
    sub_pkg_version:   ''}
  ;sub_pkg_version: python program that gives pkg v.
  my_package = REPLICATE(PACKAGE_REQUIRED_BASE,2)
  my_package[0].driver           = 'findnexus'
  my_package[0].version_required = '1.5'
  my_package[1].driver           = 'sas_reduction'
  my_package[1].version_required = ''
  my_package[1].sub_pkg_version  = './drversion'
  ;************************************************************************
  ;************************************************************************
  
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
  
  wave_para_label = 'Comma-delimited List of Increasing Coefficients'
  wave_para_help_label = '1 + 23*X + 456*X^2 + 7890*X^3   --->'
  wave_para_help_value = '1,23,456,7890'
  ;define global variables
  global = PTR_NEW ({version:         VERSION,$
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
    ascii_file_load_status: 0,$ ;1:success, 0:failedxs
    txt_extension:   'txt',$
    txt_filter:      '*.txt',$
    txt_title:       'Browse for an TXT file',$
    txt_path:        '~/',$
    ascii_extension: 'txt',$
    ascii_filter:    '*.txt',$
    ascii_path:      '~/',$
    ascii_title:     'Browse for an ASCII data file',$
    xaxis:           '',$
    xaxis_units:     '',$
    yaxis:           '',$
    yaxis_units:     '',$
    Xarray:          ptr_new(0L),$
    Xarray_untouched: ptr_new(0L),$
    Yarray:          ptr_new(0L),$
    SigmaYarray:     ptr_new(0L),$
    ;                   ROIcolor:        [50L,50L,0L],$
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
    RoiPixelArrayExcluded: ptr_new(0L),$
    data_nexus_file_name: '',$
    short_data_nexus_file_name: '',$
    path_data_nexus_file: '',$
    inst_geom:       '',$
    wave_para_value: '',$
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
    
  MainBaseTitle  = 'SANS Data Reduction GUI'
  MainBaseSize   = [30,25,695+320,530+320]
  MainBaseTitle += ' - ' + VERSION
  
  (*(*global).RoiPixelArrayExcluded) = INTARR(80,80)
  
  ;==============================================================================
  ;Build Main Base ==============================================================
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
      Y_SCROLL_SIZE = 500,$
      MBAR          = WID_BASE_0_MBAR)
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
      YPAD         = 2,$
      MBAR         = WID_BASE_0_MBAR)
  ENDELSE
  
  ;HELP MENU in Menu Bar
  HELP_MENU = WIDGET_BUTTON(WID_BASE_0_MBAR,$
    UNAME = 'help_menu',$
    VALUE = 'HELP',$
    /MENU)
    
  HELP_BUTTON = WIDGET_BUTTON(HELP_MENU,$
    VALUE = 'HELP',$
    UNAME = 'help_button')
    
  ;get the color of the GUI to hide the widget_draw that will label the draw
  sys_color = WIDGET_INFO(MAIN_BASE,/SYSTEM_COLORS)
  (*global).sys_color_face_3d = sys_color.face_3d
  
  
  ;attach global structure with widget ID of widget main base widget ID
  widget_control, MAIN_BASE, SET_UVALUE=global
  
  ;Build Tab1
  make_gui_main_tab, MAIN_BASE, MainBaseSize
  
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  
  
  ;==============================================================================
  ;debugging version of program
  IF (DEBUGGING EQ 'yes' AND $
    ucams EQ 'j35') THEN BEGIN
    nexus_path           = '~/SVN/IdlGui/branches/SANSreduction/1.0'
    (*global).nexus_path = nexus_path
    (*global).selection_path = '~/SVN/IdlGui/branches/SANSreduction/1.0/'
    (*global).wave_dep_back_sub_path = $
      '~/SVN/IdlGui/branches/SANScalibration/1.0/'
    ;put run 45 in the Run Number Data (first tab)
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='run_number_cw_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='45'
    ;populate the REDUCE tab to be able to run right away
    ;Data File text field (Load Files)
    id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='data_file_name_text_field')
    WIDGET_CONTROL, id, $
      SET_VALUE='/LENS/SANS/2008_01_COM/1/45/NeXus/SANS_45.nxs'
      
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
      
    ;show tab #2 'REDUCE
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 1
    ;show tab of the REDUCE tab
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 0
    
  ENDIF
  
  ;change color of background
  id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='label_draw_uname')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  ;ERASE, COLOR=convert_rgb(sys_color.face_3d)
  
  plot, randomn(s,80), $
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
    
  ;==============================================================================
  ; Date and Checking Packages routines =========================================
  ;==============================================================================
  ;Put date/time when user started application in first line of log book
  time_stamp = GenerateIsoTimeStamp()
  message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
  IDLsendToGeek_putLogBookText_fromMainBase, MAIN_BASE, 'log_book_text', $
    message
    
  IF (CHECKING_PACKAGES EQ 'yes') THEN BEGIN
    ;Check that the necessary packages are present
    message = '> Checking For Required Software: '
    IDLsendToGeek_addLogBookText_fromMainBase, MAIN_BASE, 'log_book_text', $
      message
      
    PROCESSING = (*global).processing
    OK         = (*global).ok
    FAILED     = (*global).failed
    NbrSpc     = 25             ;minimum value 4
    
    sz = (size(my_package))(1)
    
    IF (sz GT 0) THEN BEGIN
      max = 0                ;find the longer required software name
      pack_list = STRARR(sz)  ;initialize the list of driver
      missing_packages = STRARR(sz) ;initialize the list of missing packages
      nbr_missing_packages = 0
      FOR k=0,(sz-1) DO BEGIN
        pack_list[k] = my_package[k].driver
        length = STRLEN(pack_list[k])
        IF (length GT max) THEN max = length
      ENDFOR
      
      first_sub_packages_check = 1
      FOR i=0,(sz-1) DO BEGIN
        message = '-> ' + pack_list[i]
        ;this part is to make sure the PROCESSING string starts at the same column
        length = STRLEN(message)
        str_array = MAKE_ARRAY(NbrSpc+max-length,/STRING,VALUE='.')
        new_string = STRJOIN(str_array)
        message += ' ' + new_string + ' ' + PROCESSING
        
        IDLsendToGeek_addLogBookText_fromMainBase, $
          MAIN_BASE, $
          'log_book_text', $
          message
        cmd = pack_list[i] + ' --version'
        spawn, cmd, listening, err_listening
        IF (err_listening[0] EQ '') THEN BEGIN ;found
          IDLsendToGeek_ReplaceLogBookText_fromMainBase, $
            MAIN_BASE, $
            'log_book_text', $
            PROCESSING,$
            OK + ' (Current Version: ' + $
            listening[N_ELEMENTS(listening)-1] + ')'
          ;              ' / Minimum Required Version: ' + $
          ;              my_package[i].version_required + ')'
          IF (my_package[i].sub_pkg_version NE '' AND $
            first_sub_packages_check EQ 1) THEN BEGIN
            first_sub_packages_check = 0
            cmd = my_package[i].sub_pkg_version
            spawn, cmd, listening, err_listening
            IF (err_listening[0] EQ '') THEN BEGIN ;worked
              cmd_txt = '-> ' + cmd + ' ... OK'
              IDLsendToGeek_addLogBookText_fromMainBase, $
                MAIN_BASE, $
                'log_book_text', $
                cmd_text
              IDLsendToGeek_addLogBookText_fromMainBase, $
                MAIN_BASE, $
                'log_book_text', $
                '--> ' + listening
            ENDIF ELSE BEGIN
              cmd_txt = '-> ' + cmd + ' ... FAILED'
              IDLsendToGeek_addLogBookText_fromMainBase, $
                MAIN_BASE, $
                'log_book_text', $
                cmd_text
            ENDELSE
          ENDIF
        ENDIF ELSE BEGIN    ;missing program
          IDLsendToGeek_ReplaceLogBookText_fromMainBase, $
            MAIN_BASE, $
            'log_book_text', $
            PROCESSING,$
            FAILED
          ;              + ' (Minimum Required Version: ' + $
          ;              my_package[i].version_required + ')'
          missing_packages[i] = my_package[i].driver
          ++nbr_missing_packages
        ENDELSE
      ENDFOR
      
      IF (nbr_missing_packages GT 0) THEN BEGIN
        ;pop up window that show that they are missing packages
        message = ['They are ' + $
          STRCOMPRESS(nbr_missing_packages,/REMOVE_ALL) + $
          ' missing package(s) you need to ' + $
          'fully used this application.']
        message = [message,'Check Log Book For More Information !']
        result = DIALOG_MESSAGE(message, $
          /INFORMATION, $
          DIALOG_PARENT=MAIN_BASE)
          
      ENDIF
      
    ENDIF                       ;end of 'if (sz GT 0)'
    
    message = '=================================================' + $
      '========================'
    IDLsendToGeek_addLogBookText_fromMainBase, MAIN_BASE, $
      'log_book_text', message
      
  ENDIF
  
  ;==============================================================================
  ;==============================================================================
  
  
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


