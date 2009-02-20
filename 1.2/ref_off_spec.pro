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

  ;get the current folder
  CD, CURRENT = current_folder
  
  ;*****************************************************************************
  ;*****************************************************************************
  APPLICATION       = 'REFoffSpec'
  VERSION           = '1.2.3'
  DEBUGGING         = 'yes'        ;no
  TESTING           = 'no'        ;no
  SCROLLING         = 'no'        ;no
  CHECKING_PACKAGES = 'yes'       ;yes
  SUPER_USERS       = ['j35']
  
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
  sDEBUGGING = { tab: {main_tab: 1,$ ;REDUCE tab
    step4_tab: 0,$
    scaling_tab: 1},$
    ascii_path: '~/SVN/IdlGui/trunk/REFoffSpec/',$
    reduce_tab1_cw_field: '4753-4755',$
    reduce_tab1_proposal_combobox: 1}
  ;PACKAGES
  PACKAGE_REQUIRED_BASE = { driver:           '',$
    version_required: ''}
  my_package = REPLICATE(PACKAGE_REQUIRED_BASE,1)
  my_package[0].driver           = 'findnexus'
  my_package[0].version_required = '1.5'
  
  ;*****************************************************************************
  ;*****************************************************************************
  
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    ucams = 'j35'
  ENDIF ELSE BEGIN
    ucams = GET_UCAMS()
  ENDELSE
  
  ;define global variables
  global = ptr_new ({ ucams: ucams,$
    instrument: 'REF_M',$
    debugging: DEBUGGING,$
    sDebugging: sDebugging,$
    
    nexus_list_OF_pola_state: ['/entry-Off_Off/',$
    '/entry-Off_On/',$
    '/entry-On_Off/',$
    '/entry-On_On/'],$
    reduce_tab1_table_left_click: 1,$
    browsing_path: '~/results/',$
    reduce_tab1_table: PTR_NEW(0L),$
    reduce_tab1_working_pola_state: '',$
    reduce_tab1_nexus_file_list: PTR_NEW(0L),$
    
    working_path: '~/results/',$
    
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
    
    zmin_g: 0d,$
    zmax_g: 0d,$
    
    manual_scaling_4: FLOAT(5),$
    manual_scaling_3: FLOAT(2),$
    manual_scaling_2: FLOAT(1.5),$
    step4_1_plot2d_delta_x: 0.0,$
    scaling_factor: ptr_new(0L),$
    
    pixel_offset_array: ptr_new(0L),$
    X_Y_min_max_backup: STRARR(4),$
    ymin_log_mode: 0.001,$
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
    ResizeOrMove:        'move',$
    corner_selected:     INTARR(2),$
    fix_corner:          INTARR(2),$
    bClick_step4_step1:  1,$
    step4_step1_move_selection_position: INTARR(2),$
    left_mouse_pressed:  0,$
    step4_step1_left_mouse_pressed: 0,$
    plot_realign_data:   0,$
    ref_pixel_list:      ptr_new(0L),$
    ref_pixel_offset_list: ptr_new(0L),$
    ref_pixel_list_original: ptr_new(0L),$
    ref_x_list:          ptr_new(0L),$
    super_users:         SUPER_USERS,$
    delta_x:             0.,$
    something_to_plot:   0,$
    first_load:          0,$
    congrid_coeff_array: ptr_new(0L),$
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
    list_OF_ascii_files: ptr_new(0L),$
    list_OF_ascii_files_p1: ptr_new(0L),$
    list_OF_ascii_files_p2: ptr_new(0L),$
    list_OF_ascii_files_p3: ptr_new(0L),$
    time_stamp:             '',$
    short_list_OF_ascii_files: ptr_new(0L),$
    trans_coeff_list:    ptr_new(0L),$
    pData:               ptr_new(0L),$
    pData_y:             ptr_new(0L),$
    pData_y_error:       ptr_new(0L),$
    realign_pData_y:     ptr_new(0L),$
    realign_pData_y_error: ptr_new(0L),$
    untouched_realign_pData_y:       ptr_new(0L),$
    untouched_realign_pData_y_error: ptr_new(0L),$
    first_realign:       1,$
    manual_ref_pixel:    0,$
    pData_x:             ptr_new(0L),$
    x_axis:              ptr_new(0L),$
    total_array:         ptr_new(0L),$
    total_array_untouched: ptr_new(0L),$
    total_array_error:    PTR_NEW(0L),$
    xscale:              {xrange: FLTARR(2),$
    xticks: 1L,$
    position: INTARR(4)},$
    PrevTabSelect:       0,$
    PrevScalingTabSelect: 0,$
    PrevScalingStep2TabSelect: 0,$
    step4_step1_selection: [0,0,0,0],$
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
  (*(*global).reduce_tab1_table) = STRARR(3,1)
  
  
  MainBaseSize   = (*global).MainBaseSize
  MainBaseTitle  = 'Reflectometer Off Specular Application'
  MainBaseTitle += ' - ' + VERSION
  IF (DEBUGGING EQ 'yes') THEN BEGIN
    MainBaseTitle += ' (DEBUGGING MODE)'
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
    YPAD         = 2)
    
  ;get the color of the GUI to hide the widget_draw that will draw the label
  sys_color = WIDGET_INFO(MAIN_BASE,/SYSTEM_COLORS)
  (*global).sys_color_face_3d = sys_color.face_3d
  
  ;attach global structure with widget ID of widget main base widget ID
  WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global
  
  label = Widget_label(MAIN_BASe,$
    xoffset = 0,$
    yoffset = 0,$
    value = '')
    
  ;confirmation base
  MakeGuiMainBase, MAIN_BASE, global
  
  Widget_Control, /REALIZE, MAIN_BASE
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
  id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_tab1_list_of_proposal')
  WIDGET_CONTROL, id, SET_VALUE=ListOfProposal
  
  ;?????????????????????????????????????????????????????????????????????????????
  IF (DEBUGGING EQ 'yes' ) THEN BEGIN
    ;tab to show (main_tab)
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.main_tab
    ;reduce tab1 combobox index selected
    id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_tab1_list_of_proposal')
    set_value = sDebugging.reduce_tab1_proposal_combobox
    WIDGET_CONTROL, id, SET_COMBOBOX_SELECT=set_value
    ;tab to show (pixel_range_selection/scaling_tab)
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='scaling_main_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.step4_tab
    ;step4/step2 tabs
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='step4_step2_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = sDEBUGGING.tab.scaling_tab
    ;ascii default path
    (*global).ascii_path = sDEBUGGING.ascii_path
  ENDIF
  ;????????????????????????????????????????????????????????????????????????????
  
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
    CheckPackages, MAIN_BASE, global, my_package;_CheckPackages
  ENDIF
  
  ;=============================================================================
  ;=============================================================================
  
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
END


; Empty stub procedure used for autoloading.
PRO ref_off_spec, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
END





