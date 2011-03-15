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

PRO BuildGui,  instrument, reduce_step_path, splicing_alternative, MainBaseSize, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

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
  BROWSER = file->getValue(tag=['configuration','browser'])
  MainBaseTitle = file->getValue(tag=['configuration','MainBaseTitle'])
  STEP1_TITLE = file->getValue(tag=['configuration','MainTabTitles','step1'])
  STEP2_TITLE = file->getValue(tag=['configuration','MainTabTitles','step2'])
  STEP3_TITLE = file->getValue(tag=['configuration','MainTabTitles','step3'])
  STEP4_TITLE = file->getValue(tag=['configuration','MainTabTitles','step4'])
  STEP5_TITLE = file->getValue(tag=['configuration','MainTabTitles','step5'])
  STEP6_TITLE = file->getValue(tag=['configuration','MainTabTitles','step6'])
  STEP7_TITLE = file->getValue(tag=['configuration','MainTabTitles','step7'])
  STEP8_TITLE = file->getValue(tag=['configuration','MainTabTitles','step8'])
  STEP9_TITLE = file->getValue(tag=['configuration','MainTabTitles','step9'])
  RSTEP1_NAME = file->getValue(tag=['configuration','ReduceTabNames','name1'])
  RSTEP2_NAME = file->getValue(tag=['configuration','ReduceTabNames','name2'])
  RSTEP3_NAME = file->getValue(tag=['configuration','ReduceTabNames','name3'])
  SSTEP1_NAME = file->getValue(tag=['configuration','ScalingTabNames','sname1'])
  SSTEP2_NAME = file->getValue(tag=['configuration','ScalingTabNames','sname2'])
  SL3STEP1_NAME = file->getValue(tag=['configuration','ScalingLevel3TabNames','sl3name1'])
  SL3STEP2_NAME = file->getValue(tag=['configuration','ScalingLevel3TabNames','sl3name2'])
  SL3STEP3_NAME = file->getValue(tag=['configuration','ScalingLevel3TabNames','sl3name3'])
  REFPIX_INITIAL = file->getValue(tag=['configuration','RefPix','InitialValue'])
  XSIZE_DRAW = file->getValue(tag=['configuration','DataPlot','XSizeDraw'])
  YSIZE_DRAW = file->getValue(tag=['configuration','DataPlot','YSizeDraw'])
  COLOR_TABLE = file->getValue(tag=['configuration','DataPlot','ColorTable'])
  BOX_COLOR0 = file->getValue(tag=['configuration','DataPlot','BoxColors','BoxColor0'])
  BOX_COLOR1 = file->getValue(tag=['configuration','DataPlot','BoxColors','BoxColor1'])
  BOX_COLOR2 = file->getValue(tag=['configuration','DataPlot','BoxColors','BoxColor2'])
  BOX_COLOR3 = file->getValue(tag=['configuration','DataPlot','BoxColors','BoxColor3'])
  BOX_COLOR4 = file->getValue(tag=['configuration','DataPlot','BoxColors','BoxColor4'])
  BOX_COLOR5 = file->getValue(tag=['configuration','DataPlot','BoxColors','BoxColor5'])
  BOX_COLOR6 = file->getValue(tag=['configuration','DataPlot','BoxColors','BoxColor6'])
  BOX_COLOR7 = file->getValue(tag=['configuration','DataPlot','BoxColors','BoxColor7'])
  BOX_COLOR8 = file->getValue(tag=['configuration','DataPlot','BoxColors','BoxColor8'])
  BACKGROUND_COLOR = file->getValue(tag=['configuration','CurvePlot','BackgroundColor'])
  CESELECT_VERTLINE_COLOR = file->getValue(tag=['configuration','CurvePlot','CESelect','VerticalLineColor'])
  SELECT_COLOR = file->getValue(tag=['configuration','CurvePlot','CESelect','SelectColor'])
  PIXELS_YNUMBER = file->getValue(tag=['configuration','Detector','Pixels_YNumber'])
  PIXELS_XNUMBER = file->getValue(tag=['configuration','Detector','Pixels_XNumber'])
  PIXELS_YSIZE = file->getValue(tag=['configuration','Detector','Pixels_YSize'])
  NUMBER_OF_SANGLE = file->getValue(tag=['configuration','Detector','Number_of_Sangle'])
  DATA_COLOR = file->getValue(tag=['configuration','ReflectivityPlot','DataColor'])
  ERROR_COLOR = file->getValue(tag=['configuration','ReflectivityPlot','ErrorColor'])
  ZOOMBOX_COLOR = file->getValue(tag=['configuration','ReflectivityPlot','ZoomBoxColor'])
  VERTICAL_COLOR = file->getValue(tag=['configuration','ReflectivityPlot','VerticalColor'])
  HORIZONTAL_COLOR = file->getValue(tag=['configuration','ReflectivityPlot','HorizontalColor'])
  AVERAGE_COLOR = file->getValue(tag=['configuration','ReflectivityPlot','AverageColor'])
  REFPIX_LOAD = file->getValue(tag=['configuration','Shifting','RefPixLoad'])
  APPLY_TOF_CUTOFFS = file->getValue(tag=['configuration','TOFCuttoffs','ApplyTOFCutoffs'])
  TOF_CUTOFF_MIN = file->getValue(tag=['configuration','TOFCuttoffs','TOFCutoffMin'])
  TOF_CUTOFF_MAX = file->getValue(tag=['configuration','TOFCuttoffs','TOFCutoffMax'])
  SPLICING_ALTERNATIVE = file->getValue(tag=['configuration','Recap','SplicingAlternative'])
  QUEUE = file->getValue(tag=['configuration','Reduction','Queue'])
  ; Note: YSIZE_DRAW and Pixels_XValue are not presently used in the code
  SUPER_USERS = ['rwd']
  
  ;print, "reduce_step_path: ", reduce_step_path
  ;print, "splicing_alternative: ", splicing_alternative
  ; Change code (RC Ward, 7 Aug 2010): Change the splash screen for:  Job_Mananger_on_the_way.png
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
    reduce_tab1_cw_field: '5387-5389',$
    reduce_tab2_cw_field: '5392-5394',$
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
    
    roi_base_background: ptr_new(0L), $ ;2d plot of roi selection (reduce/tab2)
    norm_tof: ptr_new(0L), $ ;tof array of normalization file loaded in reduce/tab2
    
    left_right_cursor: 96, $
    standard: 31, $
    ; Code change RCW (Dec 28, 2009): firefox replaced by browser obtained from XML config file entry BROWSER
    browser: BROWSER,$
    
    ;Tab titles
    ; Code change RCW (Dec 29, 2009): Get TabTitles from XML config file
    ; Code Change (RC Ward, 18 Nov 2010): Add Plot Utility as Step 9 Tab on main gui
    TabTitles: {  step1:     STEP1_TITLE,$
    step2:     STEP2_TITLE,$
    step3:     STEP3_TITLE,$
    step4:     STEP4_TITLE,$
    step5:     STEP5_TITLE,$
    step6:     STEP6_TITLE,$
    options:   STEP7_TITLE,$
    log_book:  STEP8_TITLE,$
    plot_utility: STEP9_TITLE},$
    ; Code change RCW (Dec 30, 2009): get ReduceTabNames and ScalingTabNames from XML config file (NOT USING THESE RIGHT NOW)
    ReduceTabNames: [RSTEP1_NAME,$
    RSTEP2_NAME,$
    RSTEP3_NAME],$
    
    ScalingTabNames: [SSTEP1_NAME,$
    SSTEP2_NAME],$
    
    ScalingLevel3TabNames: [SL3STEP1_NAME,$
    SL3STEP2_NAME,$
    SL3STEP3_NAME],$
    ; Code change (RC Ward Feb 1, 2010): get intial value of RefPix from XML config file
    RefPix_InitialValue: REFPIX_INITIAL,$
    ; Code change (RC Ward Feb 8, 2010): get ascii data 2D-plot background color from XML config file
    BackgroundCurvePlot: BACKGROUND_COLOR,$
    ; Code change (RC Ward Feb 26, 2010): use color names for lines in curve plots
    ceselect_vertical_line_color: CESELECT_VERTLINE_COLOR,$
    ref_plot_select_color: SELECT_COLOR,$
    ref_plot_data_color: DATA_COLOR,$
    ref_plot_error_color: ERROR_COLOR,$
    ref_plot_zoombox_color: ZOOMBOX_COLOR,$
    ref_plot_vertical_color: VERTICAL_COLOR,$
    ref_plot_horizontal_color: HORIZONTAL_COLOR,$
    ref_plot_average_color: AVERAGE_COLOR,$
    
    ; Code change RCW (Feb 10, 2010): get detector pixels in X and Y directions from XML config file
    detector_pixels_x: LONG(PIXELS_XNUMBER),$
    detector_pixels_y: LONG(PIXELS_YNUMBER),$
    ; Code change RCW (Apr 6, 2010): get detector pixels size in Y direction from XML config file
    detector_pixels_size_y: PIXELS_YSIZE, $
    number_of_sangle: NUMBER_OF_SANGLE, $
    
    ; Code change (RC Ward Feb 18,2010): Get flag to automatically load RefPix values for Shifting step
    RefPixLoad: REFPIX_LOAD, $
    
    ; Code change (RC Ward Feb 22, 2010): Get Color Table value for LOADCT from XML config file
    color_table: COLOR_TABLE,$
    
    ; Code change (RC Ward, Mar 2, 2010): Get tof_cutoff_min and tof_cutoff_max values from the XML config file
    apply_tof_cutoffs: APPLY_TOF_CUTOFFS, $
    tof_cutoff_min: TOF_CUTOFF_MIN, $
    tof_cutoff_max: TOF_CUTOFF_MAX, $
    ; Change code (RC Ward, 3 Aug 2010): set up default value of splicing_alternative
    ; [0] is use Max value in overlap range (default); [1] is let the higher Q curve override lower Q
    splicing_alternative: SPLICING_ALTERNATIVE, $
    ; Change code (RC Ward, 5 Oct, 2010): Specify queue for reduction code (redref_lp) processing
    queue: QUEUE, $
    srun_web_page: 'https://neutronsr.us/applications/jobmonitor/squeue.php?view=all',$
    
    ; refred_lp is the remote reflectometer reduction code. Here were are setting up the names of the parameters to refred_lp.
    ; Change made (RC Ward, Mar 2, 2010): add time of flight cutoffs (min, max) to the call to refred_lp
    reduce_structure: {driver: 'refred_lp',$
    data_paths: '--data-path',$
    data: '--data',$
    sangle: '--omega', $
    norm: '--norm',$
    norm_paths: '--norm-data-paths',$
    norm_roi: '--norm-roi-file',$
    tof_cut_min: '--tof-cut-min',$
    tof_cut_max: '--tof-cut-max',$
    output: '--output'},$
    
    nexus_list_OF_pola_state: ['/entry-Off_Off/',$
    '/entry-Off_On/',$
    '/entry-On_Off/',$
    '/entry-On_On/'],$
    reduce_tab1_table_left_click: 1,$
    ;browsing_path: '~/results/',$
    browsing_path: '~/',$  ;REMOVE_ME
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
    ; Code change RCW (Feb 8, 2010): get value of xsize_draw from XML config file
    ;    sangle_xsize_draw: 845., $
    sangle_xsize_draw: XSIZE_DRAW, $
    ; Code change RCW (Feb 10, 2010): gset xsize_draw to 2*PIXELS_YNUMBER from XML config file
    ;    sangle_ysize_draw: 608., $
    sangle_ysize_draw: 2*PIXELS_YNUMBER, $
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
    input_file_name: '  ', $ ; set up a place holder for RefPix filename
    ; Code change (RC Ward, March 24, 2010): Change images used for setting spin matching for data/norm
    Spins_Not_Matching_Enable: $
    'REFoffSpec_images/Spins_Not_Matching_Enable.png',$
    Spins_Not_Matching_Disable: $
    'REFoffSpec_images/Spins_Not_Matching_Disable.png',$
    Spins_Matching_Enable: $
    'REFoffSpec_images/Spins_Matching_Enable.png',$
    Spins_Matching_Disable: $
    'REFoffSpec_images/Spins_Matching_Disable.png',$
    User_Defined_Spins_Matching_Enable: $
    'REFoffSpec_images/User_Defined_Spins_Matching_Enable.png', $
    User_Defined_Spins_Matching_Disable: $
    'REFoffSpec_images/User_Defined_Spins_Matching_Disable.png', $
    ; These are the old images used for setting spin matching for data/norm
    ;    reduce_step1_spin_match_disable: $
    ;    'REFoffSpec_images/spin_states_match_button_unselected.png',$
    ;    reduce_step1_spin_match_enable: $
    ;    'REFoffSpec_images/spin_states_match_button_selected.png',$
    ;    reduce_step1_spin_do_not_match_fixed_disable: $
    ;    'REFoffSpec_images/spin_states_do_not_match_fixed_unselected.png',$
    ;    reduce_step1_spin_do_not_match_fixed_enable: $
    ;    'REFoffSpec_images/spin_states_do_not_match_fixed_selected.png',$
    ;    reduce_step1_spin_do_not_match_user_defined_disable: $
    ;    'REFoffSpec_images/spin_states_do_not_match_user_defined_unselected.png',$
    ;    reduce_step1_spin_do_not_match_user_defined_enable: $
    ;    'REFoffSpec_images/spin_states_do_not_match_user_defined_selected.png',$
    
    reduce_step1_sangle_equation: $
    'REFoffSpec_images/sangle_equation.png', $
    
    tmp_reduce_step2_row: 0L,$
    tmp_reduce_step2_data_spin_state: '',$
    
    list_of_data_spin: ['Off_Off',$
    'Off_On',$
    'On_Off',$
    'On_On'],$
    
    ;step3
    ; test - add this to see how it looks - fix up later
    reduce_step3_spin_off_off_unavailable: $
    'REFoffSpec_images/Off_Off_Disabled_Cropped.PNG',$
    reduce_step3_spin_off_off_disable: $
    'REFoffSpec_images/Off_Off_Inactive_Cropped.PNG',$
    reduce_step3_spin_off_off_enable: $
    'REFoffSpec_images/Off_Off_Active_Cropped.PNG',$
    
    reduce_step3_spin_off_on_unavailable: $
    'REFoffSpec_images/Off_On_Disabled_Cropped.PNG',$
    reduce_step3_spin_off_on_disable: $
    'REFoffSpec_images/Off_On_Inactive_Cropped.PNG',$
    reduce_step3_spin_off_on_enable: $
    'REFoffSpec_images/Off_On_Active_Cropped.PNG',$
    
    reduce_step3_spin_on_off_unavailable: $
    'REFoffSpec_images/On_Off_Disabled_Cropped.PNG',$
    reduce_step3_spin_on_off_disable: $
    'REFoffSpec_images/On_Off_Inactive_Cropped.PNG',$
    reduce_step3_spin_on_off_enable: $
    'REFoffSpec_images/On_Off_Active_Cropped.PNG',$
    
    reduce_step3_spin_on_on_unavailable: $
    'REFoffSpec_images/On_On_Disabled_Cropped.PNG',$
    reduce_step3_spin_on_on_disable: $
    'REFoffSpec_images/On_On_Inactive_Cropped.PNG',$
    reduce_step3_spin_on_on_enable: $
    'REFoffSpec_images/On_On_Active_Cropped.PNG',$
    
    ; here is the original code
    ;    reduce_step3_spin_off_off_unavailable: $
    ;    'REFoffSpec_images/off_off_disable.png',$
    ;    reduce_step3_spin_off_off_disable: $
    ;    'REFoffSpec_images/off_off_unselected.png',$
    ;    reduce_step3_spin_off_off_enable: $
    ;    'REFoffSpec_images/off_off_selected.png',$
    
    ;    reduce_step3_spin_off_on_unavailable: $
    ;    'REFoffSpec_images/off_on_disable.png',$
    ;    reduce_step3_spin_off_on_disable: $
    ;    'REFoffSpec_images/off_on_unselected.png',$
    ;    reduce_step3_spin_off_on_enable: $
    ;    'REFoffSpec_images/off_on_selected.png',$
    
    ;    reduce_step3_spin_on_off_unavailable: $
    ;    'REFoffSpec_images/on_off_disable.png',$
    ;    reduce_step3_spin_on_off_disable: $
    ;    'REFoffSpec_images/on_off_unselected.png',$
    ;    reduce_step3_spin_on_off_enable: $
    ;    'REFoffSpec_images/on_off_selected.png',$
    
    ;    reduce_step3_spin_on_on_unavailable: $
    ;    'REFoffSpec_images/on_on_disable.png',$
    ;    reduce_step3_spin_on_on_disable: $
    ;    'REFoffSpec_images/on_on_unselected.png',$
    ;    reduce_step3_spin_on_on_enable: $
    ;    'REFoffSpec_images/on_on_selected.png',$
    
    step3_working_spin: '',$
    job_manager_splash_draw: $
    'REFoffSpec_images/Job_Mananger_on_the_way.png',$
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
    reduce_rebin_roi_rebin_y: 2,$  ;y rebin for reduce/tab2
    reduce_rebin_roi_rebin_x: 1, $ ;x rebin for reduce/tab2
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
    
    ;both are strarr(5,11) where [0] is for the name of the norm file
    nexus_spin_state_roi_table: PTR_NEW(0L),$
    nexus_spin_state_back_roi_table: ptr_new(0L), $
    
    ;working_path: '~/results/',$
    working_path: '~/',$
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
    step5_selection_savefrom_step4: [0,0,0,0], $
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
    step4_ymin_global_value: 1.E-6, $ ;value min of y for log scale
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
    ; Change code (RC Ward, 28 Dec 2010): Add RESTART flag.
    ;  This will be set in Plot Utility when user enters new reference run#
    RESTART: 0,$
    
    plot_realign_data:   0,$
    ref_pixel_list:      PTR_NEW(0L),$
    ref_pixel_offset_list: PTR_NEW(0L),$
    ref_pixel_list_original: PTR_NEW(0L),$
    RefPixSave: PTR_NEW(0L), $
    PreviousRefPix: PTR_NEW(0L), $ ; used to store RefPix for Shifting Step
    
    SangleDone: PTR_NEW(0B), $
    ref_x_list:          PTR_NEW(0L),$
    super_users:         SUPER_USERS,$
    delta_x:             0.,$
    something_to_plot:   0,$
    first_load:          0,$
    congrid_coeff_array: PTR_NEW(0L),$
    application:         APPLICATION,$
    ;    box_color:           [50,75,100,125,150,175,200,225,250],$
    ; Change code (RC Ward, Feb 25, 2010): Read box_colors in from XML configuration file so they can be changed easily
    box_color:           [BOX_COLOR0, BOX_COLOR1, BOX_COLOR2, BOX_COLOR3, BOX_COLOR4, BOX_COLOR5, BOX_COLOR6, BOX_COLOR7, BOX_COLOR8],$
    processing:          '(PROCESSING)',$
    ok:                  'OK',$
    failed:              'FAILED',$
    version:             VERSION,$
    ; Change code (RC Ward, March 27, 2010): Decrease size of all windows in vertical direction
    ;  MainBaseSize:        [30,50,1300,770],$
    MainBaseSize:        [30,50,1276,901],$
    ascii_extension:     'txt',$
    ascii_filter:        '*.txt',$
    ascii_path:          '~/results/',$
    sys_color_face_3d:    INTARR(3),$
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
    w_scaling_plot2d_id: 0,$ ;id of scaling plot2D widget_base
    ; Change (RC Ward, 23 Nov 2010): Add window counter and increment this as plots are made in the PlotUtility Tab.
    window_counter: 0$
    })
    
  ;initialize variables
  (*(*global).list_OF_ascii_files) = STRARR(1)
  (*(*global).reduce_tab1_table) = STRARR(2,1)
  (*(*global).reduce_run_sangle_table) = STRARR(2,1)
  ; Code change RCW (Feb 1, 2010): set up array for RefPixSave, SangleDone
  (*(*global).RefPixSave) = FLTARR(18)
  (*(*global).SangleDone) = BYTARR(18)
  
  ; Build Application Title ======================================================
  ; CHANGE CODE (RC WARD, 22 June 2010): Pass MainBaseSize in from MakeGuiInstrumentSelection to control resolution
  ;  MainBaseSize   = (*global).MainBaseSize
  (*global).MainBaseSize = MainBaseSize
  ;  MainBaseTitle  = 'Reflectometer Off Specular Application'
  IF (instrument EQ 'REF_L') THEN BEGIN
    MainBaseTitle += '_for_REF_L'
  ENDIF ELSE BEGIN
    MainBaseTitle += '_for_REF_M'
  ENDELSE
  
  MainBaseTitle += ' Version: ' + VERSION
  IF (DEBUGGING EQ 'yes') THEN BEGIN
    MainBaseTitle += ' (DEBUGGING MODE)'
  ENDIF
  ;===============================================================================
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
  ; Change code (RC Ward, 23 July 2010): Load the users value for reduce step path
  (*global).ascii_path = reduce_step_path
  (*global).working_path = reduce_step_path
  ;===============================================================================
  
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
  
  ;refresh_plot_scale, MAIN_BASE=MAIN_BASE ;_plot    ;remove comments
  
  ;=============================================================================
  ; Date and Checking Packages routines ========================================
  ;=============================================================================
  ;Put date/time when user started application in first line of log book
  time_stamp = GenerateIsoTimeStamp()
  message = '>>>>>>  Application started date/time: ' + time_stamp + '  <<<<<<'
  IDLsendToGeek_putLogBookText_fromMainBase, MAIN_BASE, 'log_book_text', $
    message
    
  PlotUtility_putText_fromMainBase, MAIN_BASE, 'plot_utility_text', message
  
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
  message = '> Browser: ' + BROWSER
  IDLsendToGeek_addLogBookText_fromMainBase, MAIN_BASE, 'log_book_text', $
    message
  message = '> Instrument: ' + instrument
  IDLsendToGeek_addLogBookText_fromMainBase, MAIN_BASE, 'log_book_text', $
    message
  PlotUtility_putText_fromMainBase, MAIN_BASE, 'plot_utility_text', message
  message = '  '
  PlotUtility_putText_fromMainBase, MAIN_BASE, 'plot_utility_text', message
  message = '   Select buttons below to plot Reflectivity vs Q or Scaled 2D results, each in separate window.'
  PlotUtility_putText_fromMainBase, MAIN_BASE, 'plot_utility_text', message
  message = '  '
  PlotUtility_putText_fromMainBase, MAIN_BASE, 'plot_utility_text', message
  message = '   Or modify the reduce step path to examine other results.'
  PlotUtility_putText_fromMainBase, MAIN_BASE, 'plot_utility_text', message
  message = '  '
  PlotUtility_putText_fromMainBase, MAIN_BASE, 'plot_utility_text', message
  ;=============================================================================
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
END

; Empty stub procedure used for autoloading.
PRO ref_off_spec, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ; Check hostname (lrac or mrac) to determine instrument =========================
  ; Code change RCW (Jan 12, 2010): hostname returns full name (mrac.sns.gov or lrac.sns.gov)
  SPAWN, 'hostname',listening
  CASE (listening) OF
    'lrac.sns.gov': instrument = 'REF_L'
    'mrac.sns.gov': instrument = 'REF_M'
    ELSE: instrument = 'UNDEFINED'
  ENDCASE
  ; For debugging, force BuildInstrumentGui to run so instrument must be selected - RCW 30 Dec 2009
  instrument = 'UNDEFINED'
  ; If instrument is UNDEFINED call BuildInstrumentGui, else call BuildGui =========================
  IF (instrument EQ 'UNDEFINED') THEN BEGIN
    BuildInstrumentGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  ENDIF ELSE BEGIN
    BuildGui, instrument, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  ENDELSE
  
END





