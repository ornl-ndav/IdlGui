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

PRO BuildInstrumentGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  ;  RESOLVE_ROUTINE, 'ref__eventcb',$
  ;    /COMPILE_FULL_FILE            ; Load event callback routines
  ;build the Instrument Selection base
  MakeGuiInstrumentSelection, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
END

PRO BuildGui, instrument, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;get the current folder
  CD, CURRENT = current_folder
  
  file = OBJ_NEW('idlxmlparser', '.REFoffSpec.cfg')
  ;============================================================================
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION = file->getValue(tag=['configuration','version'])
  DEBUGGING = file->getValue(tag=['configuration','debugging'])
  CHECKING_PACKAGES = file->getValue(tag=['configuration','checking_packages'])
  TESTING = file->getValue(tag=['configuration','testing'])
  SCROLLING = file->getValue(tag=['configuration','scrolling'])
  FAKING_DATA = file->getValue(tag=['configuration','faking','data'])
  AM = file->getValue(tag=['configuration','am'])
  SUPER_USERS = ['j35']
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  ;============================================================================
  
  ;DEBUGGING (enter the tab you want to see)
  ;main_tab: 0: Reduction,
  ;          1: Loading,
  ;          2: Shifting,
  ;          3: Scaling (step4_tab)
  ;             0: Pixel range selection
  ;             1: scaling (scaling_tab)
  ;                0: all files
  ;                1: Critical edge
  ;                2: scaling of other files
  ;          4: Recap,
  ;          5: Create Output
  ;          6: Options,
  ;          7:Log Book
  sDEBUGGING = { tab: {main_tab: 0,$
    reduce_tab: 0,$
    step4_tab: 0,$
    scaling_tab: 1},$
    ascii_path: '~/results/',$
    reduce_tab1_cw_field: '5242-5244',$
    reduce_tab1_proposal_combobox: 1}
    
  ;****************************************************************************
  ;****************************************************************************
    
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    ucams = 'j35'
  ENDIF ELSE BEGIN
    ucams = GET_UCAMS()
  ENDELSE
  
  ;define global variables
  global = ptr_new ({ ucams: ucams,$
    instrument: instrument,$
    debugging: DEBUGGING,$
    sDebugging: sDebugging,$
    am: AM, $
    
    left_right_cursor: 96, $
    standard: 31, $
    
    firefox: '/usr/bin/firefox',$
    srun_web_page: 'https://neutronsr.us/applications/jobmonitor/squeue.php?view=all',$
    
    reduce_structure: {driver: 'refred_lp',$
    data_paths: '--data-path',$
    data: '--data',$
    sangle: '--omega', $
    norm: '--norm',$
    norm_paths: '--norm-data-paths',$
    norm_roi: '--norm-roi-file',$
    output: '--output'},$
    
    nexus_list_OF_pola_state: ['/entry-Off_Off/',$
    '/entry-Off_On/',$
    '/entry-On_Off/',$
    '/entry-On_On/'],$
    reduce_tab1_table_left_click: 1,$
    browsing_path: '~/results/',$
    reduce_tab1_table: PTR_NEW(0L),$
    reduce_tab1_working_pola_state: '',$
    reduce_tab1_nexus_file_list: PTR_NEW(0L),$
    reduce_input_table_nbr_row: 18,$
    reduce_input_table_nbr_column: 2,$
    reduce_step1_spin_state_mode: 2,$
    
    ;SANGLE BASE
    reduce_run_sangle_table: PTR_NEW(0L), $
    sangle_tData: PTR_NEW(0L), $
    sangle_tof: PTR_NEW(0L), $
    sangle_background_plot: PTR_NEW(0L), $
    sangle_table_press_click: 1,$
    sangle_xsize_draw: 845., $
    sangle_ysize_draw: 608., $
    sangle_help_xsize_draw: 255, $
    sangle_help_ysize_draw: 215, $
    sangle_main_plot_congrid_x_coeff: 0.,$
    sangle_main_plot_congrid_y_coeff: 2., $
    sangle_mouse_pressed: 0b, $
    sangle_refpix_arrow_xoffset: 10, $ ;xoffset for arrow
    sangle_refpix_arrow_yoffset: 10, $ ;yoffset for arrow
    sangle_mode: 'refpix', $ ;either 'refpix','dirpix','tof_min','tof_max'
    old_sangle_mode: 'refpix', $ ;either 'refpix' or 'dirpix'
    tof_sangle_device_range: LONARR(2), $
    tof_sangle_offset: 0,$
    tof_sangle_index_range: INTARR(2), $
    sangle_zoom_xy_minmax: FLTARR(4),$ ;corners of zoom sangle help plot box
    sangle_current_zoom_para: FLTARR(4), $ ;para used for current zoom plot
    zoom_left_click_pressed: 0b, $ ;boolean button pressed or not (zoom help)
    
    reduce_step1_spin_match_disable: $
    'REFoffSpec_images/spin_states_match_button_unselected.png',$
    reduce_step1_spin_match_enable: $
    'REFoffSpec_images/spin_states_match_button_selected.png',$
    reduce_step1_spin_do_not_match_fixed_disable: $
    'REFoffSpec_images/spin_states_do_not_match_fixed_unselected.png',$
    reduce_step1_spin_do_not_match_fixed_enable: $
    'REFoffSpec_images/spin_states_do_not_match_fixed_selected.png',$
    reduce_step1_spin_do_not_match_user_defined_disable: $
    'REFoffSpec_images/spin_states_do_not_match_user_defined_unselected.png',$
    reduce_step1_spin_do_not_match_user_defined_enable: $
    'REFoffSpec_images/spin_states_do_not_match_user_defined_selected.png',$
    
    reduce_step1_sangle_equation: $
    'REFoffSpec_images/sangle_equation.png', $
    
    tmp_reduce_step2_row: 0L,$
    tmp_reduce_step2_data_spin_state: '',$
    
    list_of_data_spin: ['Off_Off',$
    'Off_On',$
    'On_Off',$
    'On_On'],$
    
    ;step3
    reduce_step3_spin_off_off_unavailable: $
    'REFoffSpec_images/off_off_disable.png',$
    reduce_step3_spin_off_off_disable: $
    'REFoffSpec_images/off_off_unselected.png',$
    reduce_step3_spin_off_off_enable: $
    'REFoffSpec_images/off_off_selected.png',$
    
    reduce_step3_spin_off_on_unavailable: $
    'REFoffSpec_images/off_on_disable.png',$
    reduce_step3_spin_off_on_disable: $
    'REFoffSpec_images/off_on_unselected.png',$
    reduce_step3_spin_off_on_enable: $
    'REFoffSpec_images/off_on_selected.png',$
    
    reduce_step3_spin_on_off_unavailable: $
    'REFoffSpec_images/on_off_disable.png',$
    reduce_step3_spin_on_off_disable: $
    'REFoffSpec_images/on_off_unselected.png',$
    reduce_step3_spin_on_off_enable: $
    'REFoffSpec_images/on_off_selected.png',$
    
    reduce_step3_spin_on_on_unavailable: $
    'REFoffSpec_images/on_on_disable.png',$
    reduce_step3_spin_on_on_disable: $
    'REFoffSpec_images/on_on_unselected.png',$
    reduce_step3_spin_on_on_enable: $
    'REFoffSpec_images/on_on_selected.png',$
    
    step3_working_spin: '',$
    job_manager_splash_draw: $
    'REFoffSpec_images/job_manager_is_coming.png',$
    list_of_files_to_load_in_step2: PTR_NEW(0L),$
    go_shift_scale: $
    'REFoffSpec_images/go_shift_scale.png',$
    
    PrevReduceTabSelect: 0,$
    reduce_tab2_nexus_file_list: PTR_NEW(0L),$
    nexus_norm_list_run_number: STRARR(1,11),$
    ROI_path: '~/results/',$
    reduce_step2_norm_roi: STRARR(10)+'N/A',$
    reduce_step2_create_roi_base: 0,$
    reduce_step2_big_table_norm_index: INTARR(10),$
    norm_data: PTR_NEW(0L),$
    norm_tData: PTR_NEW(0L),$
    norm_rtData: PTR_NEW(0L),$
    norm_rtData_log: PTR_NEW(0L),$
    norm_roi_y_selected: 'left',$
    mouse_left_pressed: 0,$
    mouse_right_pressed: 0,$
    reduce_rebin_roi_rebin_y: 2,$
    reduce_step2_roi_color: 150,$
    reduce_step2_norm_tof: 0,$
    reduce_step2_UD_keys_pressed: 0,$
    reduce_step2_roi_path: '',$
    reduce_step2_roi_file_name: '',$
    roi_color: 150,$
    working_reduce_step2_row: 0,$
    reduce_step2_spin_state_not_selected: $
    'REFoffSpec_images/spin_state_not_selected.png',$
    PrevReduceStep2TabSelect: 0,$
    nexus_spin_state_roi_table: PTR_NEW(0L),$
    
    working_path: '~/results/',$
    step5_scaling_factor: 1.0D, $
    
    step5_x0: 0,$ ;event.x initial
    step5_y0: 0,$ ;event.y initial
    step5_x1: 0,$ ;event.x final
    step5_y1: 0,$ ;event.y final
    step5_i_vs_q_color: 200,$ ;color of selection
    
    lin_zmax: 0d,$ ;0.46009228 (real value)
    lin_zmin: 0d,$ ;real value
    log_zmax: 0d,$ ;0.46009228 (real value)
    log_zmin: 0d,$ ;real value
    a_zmax: 0d,$ ;4.6e-1 (abreviated value)
    a_zmin: 0d,$ ;abreviated value
    a_log_zmax: 0d,$ ;abreviated value
    a_log_zmin: 0d,$ ;abreviated value
    
    step2_zmax: 0d,$
    step2_zmin: 0d,$
    step2_zmax_backup: 0d,$
    step2_zmin_backup: 0d,$
    
    zmax_g_recap: 0d,$
    zmin_g_recap: 0d,$
    zmax_g_recap_backup: 0d,$
    zmin_g_recap_backup: 0d,$
    zmax_g_backup: 0d,$
    zmin_g_backup: 0d,$
    
    zmin_g: 0d,$
    zmax_g: 0d,$
    
    manual_scaling_4: FLOAT(5),$
    manual_scaling_3: FLOAT(2),$
    manual_scaling_2: FLOAT(1.5),$
    step4_1_plot2d_delta_x: 0.0,$
    scaling_factor: PTR_NEW(0L),$
    
    i_vs_q_ext: '',$
    selection_type: '',$
    
    array_selected_total_backup: PTR_NEW(0L),$
    array_selected_total_error_backup: PTR_NEW(0L),$
    step5_selection_x_array: PTR_NEW(0L),$
    step5_selection_y_array: PTR_NEW(0L),$
    step5_selection_y_error_array: PTR_NEW(0L),$
    recap_rescale_left_mouse: 0, $
    recap_rescale_working_with: 'left',$
    recap_rescale_x0: 0,$
    recap_rescale_y0: 0,$
    recap_rescale_x1: 0,$
    recap_rescale_y1: 0,$
    x0y0x1y1: [0.,0.,0.,0.],$
    x0y0x1y1_graph: [0.,0.,0.,0.],$
    first_recap_rescale_plot: 1,$
    recap_rescale_selection_left: 0.0,$
    recap_rescale_selection_right: 0.0,$
    recap_rescale_average: 0.0,$
    last_valid_x: 0.0,$
    last_valid_y: 0.0,$
    
    pixel_offset_array: PTR_NEW(0L),$
    X_Y_min_max_backup: STRARR(4),$
    ymin_log_mode: 0.001,$
    scaling_step2_ymin_ymax: DBLARR(2), $ ;ymin and ymax for zoom widgets of step2
    step4_ymin_global_value: 0.000001, $ ;value min of y for log scale
    step4_2_2_fitting_status: 0,$
    step4_2_2_lambda_selected: 'min',$
    step4_2_2_fitting_parameters: FLTARR(2),$
    step4_2_2_fitting_parameters_backup: FLTARR(2),$
    step4_2_2_x_array_to_fit: PTR_NEW(0L),$
    step4_2_2_left_click: 0,$
    step4_2_2_lambda_array: FLTARR(2),$
    step4_2_2_draw_xmin:    60L,$
    step4_2_2_draw_xmax:    681L,$
    step4_2_2_draw_ymin:    40L,$
    step4_2_2_draw_ymax:    678L,$
    AverageValue: 0.0,$
    ResizeOrMove:        'move',$
    corner_selected:     INTARR(2),$
    fix_corner:          INTARR(2),$
    bClick_step4_step1:  1,$
    step4_step1_move_selection_position: INTARR(2),$
    left_mouse_pressed:  0,$
    step4_step1_left_mouse_pressed: 0,$
    plot_realign_data:   0,$
    ref_pixel_list:      PTR_NEW(0L),$
    ref_pixel_offset_list: PTR_NEW(0L),$
    ref_pixel_list_original: PTR_NEW(0L),$
    ref_x_list:          PTR_NEW(0L),$
    super_users:         SUPER_USERS,$
    delta_x:             0.,$
    something_to_plot:   0,$
    first_load:          0,$
    congrid_coeff_array: PTR_NEW(0L),$
    application:         APPLICATION,$
    box_color:           [50,75,100,125,150,175,200,225,250],$
    processing:          '(PROCESSING)',$
    ok:                  'OK',$
    failed:              'FAILED',$
    version:             VERSION,$
    MainBaseSize:        [30,50,1276,901],$
    ascii_extension:     'txt',$
    ascii_filter:        '*.txt',$
    ascii_path:          '~/results/',$
    sys_color_face_3d:   INTARR(3),$
    working_pola_state:  '',$
    list_OF_ascii_files: PTR_NEW(0L),$
    list_OF_ascii_files_p1: PTR_NEW(0L),$
    list_OF_ascii_files_p2: PTR_NEW(0L),$
    list_OF_ascii_files_p3: PTR_NEW(0L),$
    time_stamp:             '',$
    short_list_OF_ascii_files: PTR_NEW(0L),$
    trans_coeff_list:    PTR_NEW(0L),$
    pData:               PTR_NEW(0L),$
    pData_y:             PTR_NEW(0L),$
    pData_y_error:       PTR_NEW(0L),$
    realign_pData_y:     PTR_NEW(0L),$
    realign_pData_y_error: PTR_NEW(0L),$
    untouched_realign_pData_y:       PTR_NEW(0L),$
    untouched_realign_pData_y_error: PTR_NEW(0L),$
    first_realign:       1,$
    manual_ref_pixel:    0,$
    pData_x:             PTR_NEW(0L),$

    x_axis:              PTR_NEW(0L),$
    x_axis_max_values:   PTR_NEW(0L), $
    
    total_array:         PTR_NEW(0L),$
    total_array_untouched: PTR_NEW(0L),$
    total_array_error:    PTR_NEW(0L),$
    total_array_error_untouched:    PTR_NEW(0L),$
    xscale:              {xrange: FLTARR(2),$
    xticks: 1L,$
    position: INTARR(4)},$
    PrevTabSelect:       0,$
    PrevScalingTabSelect: 0,$
    PrevScalingStep2TabSelect: 0,$
    step4_step1_selection: [0,0,0,0],$ ;[xmin, ymin, xmax, ymax]
    step4_2_2_lambda_value_array: [0,0], $ [Qmin, Qmax] data value (not device)
    plot2d_x_left:       0,$
    plot2d_y_left:       0,$
    plot2d_x_right:      0,$
    plot2d_y_right:      0,$
    step4_step2_step1_xrange:  PTR_NEW(0L),$
    step4_step2_data_to_plot:  PTR_NEW(0L),$
    IvsLambda_selection:       PTR_NEW(0L),$
    new_IvsLambda_selection:   PTR_NEW(0L),$
    IvsLambda_selection_error: PTR_NEW(0L),$
    new_IvsLambda_selection_error: PTR_NEW(0L),$
    IvsLambda_selection_backup:       PTR_NEW(0L),$
    IvsLambda_selection_error_backup: PTR_NEW(0L),$
    IvsLambda_selection_step3_backup:       PTR_NEW(0L),$
    IvsLambda_selection_error_step3_backup: PTR_NEW(0L),$
    step4_step1_ymax_value: 0L,$
    w_shifting_plot2d_draw_uname: '',$
    w_scaling_plot2d_draw_uname: '',$
    w_shifting_plot2d_id: 0,$ ;id of shift. plot2D widget_base
    w_scaling_plot2d_id: 0$ ;id of scaling plot2D widget_base
    })
    
  ;initialize variables
  (*(*global).list_OF_ascii_files) = STRARR(1)
  (*(*global).reduce_tab1_table) = STRARR(2,1)
  (*(*global).reduce_run_sangle_table) = STRARR(2,1)
  
  MainBaseSize   = (*global).MainBaseSize
  MainBaseTitle  = 'Reflectometer Off Specular Application'
  IF (instrument EQ 'REF_L') THEN BEGIN
    MainBaseTitle += ' for REF_L'
  ENDIF ELSE BEGIN
    MainBaseTitle += ' for REF_M'
  ENDELSE
  
  MainBaseTitle += ' - ' + VERSION
  IF (DEBUGGING EQ 'yes') THEN BEGIN
    MainBaseTitle += ' (DEBUGGING MODE)'
  ENDIF

  ;Build Main Base
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
    
  ;get the color of the GUI to hide the widget_draw that will draw the label
  sys_color = WIDGET_INFO(MAIN_BASE,/SYSTEM_COLORS)
  (*global).sys_color_face_3d = sys_color.face_3d
  
  ;attach global structure with widget ID of widget main base widget ID
  WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global
  
  label = WIDGET_LABEL(MAIN_BASe,$
    xoffset = 0,$
    yoffset = 0,$
    value = '')
    
  ;confirmation base
  MakeGuiMainBase, MAIN_BASE, global
  
  WIDGET_CONTROL, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  ;change color of background
  id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='scale_draw_step2')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  ;LOADCT, 0,/SILENT
  
  ;display list of proposal for this instrument --------------------------------
  ListOfProposal = getListOfProposal((*global).instrument,$
    UCAMS,$
    MAIN_BASE)
  ;id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_tab1_list_of_proposal')
  ;WIDGET_CONTROL, id, SET_VALUE=ListOfProposal
  ;id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_tab2_list_of_proposal')
  ;WIDGET_CONTROL, id, SET_VALUE=ListOfProposal
    
  ;?????????????????????????????????????????????????????????????????????????????
  IF (DEBUGGING EQ 'yes' ) THEN BEGIN
    ;tab to show (main_tab)
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.main_tab
    ;reduce tab
    id_reduce = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_tab')
    WIDGET_CONTROL, id_reduce, SET_TAB_CURRENT=sDebugging.tab.reduce_tab
    (*global).PrevReduceTabSelect = sDebugging.tab.reduce_tab
    ;reduce tab1 combobox index selected
    ;    id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_tab1_list_of_proposal')
    ;    set_value = sDebugging.reduce_tab1_proposal_combobox
    ;    WIDGET_CONTROL, id, SET_COMBOBOX_SELECT=set_value
    ;tab to show (pixel_range_selection/scaling_tab)
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='scaling_main_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.step4_tab
    ;step4/step2 tabs
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='step4_step2_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.scaling_tab
    ;ascii default path
    (*global).ascii_path = sDEBUGGING.ascii_path
  ENDIF
  
  IF (FAKING_DATA EQ 'yes') THEN BEGIN ;no need to load the data (reduce step1)
    nexus_file_list = ['/SNS/REF_M/2008_1_2_SCI/12/5000/NeXus/REF_M_5000.nxs',$
      '/SNS/REF_M/2008_1_2_SCI/12/5001/NeXus/REF_M_5001.nxs',$
      '/SNS/REF_M/2008_1_2_SCI/12/5002/NeXus/REF_M_5002.nxs',$
      '/SNS/REF_M/2008_1_2_SCI/12/5003/NeXus/REF_M_5003.nxs',$
      '/SNS/REF_M/2008_1_2_SCI/12/5004/NeXus/REF_M_5004.nxs',$
      '/SNS/REF_M/2008_1_2_SCI/12/5005/NeXus/REF_M_5005.nxs']
    (*(*global).reduce_tab1_nexus_file_list) = nexus_file_list
    
  ;(*(*global).reduce_tab1_table)
    
  ENDIF
  
  ;?????????????????????????????????????????????????????????????????????????????
  
  ;refresh_plot_scale, MAIN_BASE=MAIN_BASE ;_plot    ;rmeove comments
  
  ;=============================================================================
  ; Date and Checking Packages routines ========================================
  ;=============================================================================
  ;Put date/time when user started application in first line of log book
  time_stamp = GenerateIsoTimeStamp()
  message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
  IDLsendToGeek_putLogBookText_fromMainBase, MAIN_BASE, 'log_book_text', $
    message
    
  IF (CHECKING_PACKAGES EQ 'yes') THEN BEGIN
    packages_required, global, my_package ;packages_required
    CheckPackages, MAIN_BASE, global, my_package;_CheckPackages
  ENDIF
  
  IF (instrument EQ 'REF_M') THEN BEGIN
    display_reduce_step1_buttons, MAIN_BASE=main_base, $
      ACTIVATE=(*global).reduce_step1_spin_state_mode, global
  ENDIF
  
;  display_reduce_step1_sangle_buttons, MAIN_BASE=main_base, global
;  display_reduce_step1_sangle_scale, MAIN_BASE=main_base, global
  
  ;=============================================================================
  ;=============================================================================
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
END

; Empty stub procedure used for autoloading.
PRO ref_off_spec, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;check instrument here
  SPAWN, 'hostname',listening
  CASE (listening) OF
    'lrac': instrument = 'REF_L'
    'mrac': instrument = 'REF_M'
    ELSE: instrument = 'UNDEFINED'
  ENDCASE
  
  IF (instrument EQ 'UNDEFINED') THEN BEGIN
    BuildInstrumentGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  ENDIF ELSE BEGIN
    BuildGui, instrument, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  ENDELSE
  
END





