
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

pro Build_GUI, BatchMode, BatchFile, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;Resolve_Routine, 'ref_scale_eventcb',/COMPILE_FULL_FILE
  ;Load event callback routines

  ;define initial global values - these could be input via external file
  ;or other means

  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    ucams = 'j35'
  ENDIF ELSE BEGIN
    ucams = get_ucams()
  ENDELSE
  
  file = OBJ_NEW('idlxmlparser', '.REFscale_l.cfg')
  ;============================================================================
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  APPLICATION = file->getValue(tag=['configuration','application'])
  VERSION  = file->getValue(tag=['configuration','version'])
  DEBUGGER = file->getValue(tag=['configuration','debugging'])
  auto_cleaning_data = file->getValue(tag=['configuration','auto_cleaning'])
  relative_diff = file->getValue(tag=['configuration','relative_diff'])
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  ;============================================================================
  
  StrArray      = strsplit(VERSION,'.',/extract)
  VerArray      = StrArray[0]
  TagArray      = StrArray[1]
  BranchArray   = StrArray[2]
  CurrentBranch =  VerArray + '.' + TagArray
  
  if (auto_cleaning_data eq 'yes') then begin
    auto_cleaning = 1b
  endif else begin
    auto_cleaning = 0b
  endelse
  
  global = $
    PTR_NEW({ $
    
    nbr_data_to_exclude: 0,$  ;number of data to remove on both side when
    ;performing setp3
    
    instrument: 'REF_L', $ ;by default, REF_L instrument
    
    ;Q relative within which the Qs are treated as identical
    relative_diff: float(relative_diff), $
    
    ;settings base
    settings_show_error_bar_flag: 1b,$
    settings_number_of_data_to_display: 100L,$
    settings_auto_cleaning_flag: auto_cleaning,$
    settings_white_background_color: 2,$ ;[white,black,dark grey]s
    percentage_of_q_to_remove_value: 10,$ ;percentage of data to remove when
    ;using auto cleanup
    
    ;email where to send the output files
    email: '',$
    
    data_spin_state: ptr_new(0L), $ ;list of data spin states loaded
    norm_spin_state: ptr_new(0L), $ ;list of norm spin states loaded
    working_with_ref_m_batch: 0b, $ ;1 if file batch loaded is REF_M
    list_of_spins_for_each_angle: ptr_new(0L), $
    ;spin states used for each data file
    current_spin_index: -1, $ ;current index of spin state (-1 for REF_L)
    DRfiles: ptr_new(0L), $ ;[spin_states,files]
    
    cleaning_base_id: 0L, $  ;the id of the cleaning base
    
    BatchExtension:         '.txt',$
    BatchTable:             PTR_NEW(0L),$
    BatchDefaultPath:       '~/results/',$
    BatchDefaultFileFilter: '*_Batch_Run*.txt',$
    BatchFileName:          '',$
    version:                VERSION,$
    processing:             '(PROCESSING)',$
    ok:                     'OK',$
    failed:                 'FAILED',$
    delta_x_draw:           0.01,$
    Q1x:                    0L,$ ;event.x for Q1
    Q2x:                    0L,$ ;event.x for Q2
    draw_xmin:              60L,$
    draw_xmax:              632L,$
    draw_ymin:              40L,$
    draw_ymax:              570L,$
    qminmax_label:          'Enter or Select Qmin and Qmax',$
    Q_selection:            1,$ ;1 or 2
    left_mouse_pressed:     0,$
    Q1:                     0.,$ ;Qmin or Qmax
    Q2:                     0.,$ ;Qmin or Qmax
    X:                      0,$ ;current event.x of Q1 or Q2
    Y:                      0,$ ;current event.y of Q1 or Q2
    angleDisplayPrecision:  1000L,$ ;the precision of the angle value displayed
    replot_me: 1,$ ;to replot main plot will be 0 just after being replot
    replotQnew: 0,$
    force_activation_step2: 0,$
    
    flt0_ptr: PTRARR(50,4,/allocate_heap),$ ;arrays of all the x-axis
    flt1_ptr: PTRARR(50,4,/allocate_heap),$ ;arrays of all the y-axis
    flt2_ptr: PTRARR(50,4,/allocate_heap),$ ;arrays of all the y-error-axis
    flt0_rescale_ptr: PTRARR(50,4,/allocate_heap),$ ;arrays of all the x-axis after rescaling
    flt1_rescale_ptr: PTRARR(50,4,/allocate_heap),$ ;arrays of all the y-axis after rescaling
    flt2_rescale_ptr: PTRARR(50,4,/allocate_heap),$ ;arrays of all the y-error-axis after rescaling
    
    fit_cooef_ptr: PTRARR(50,4,/allocate_heap),$
    flt0_range: PTRARR(2,4,/allocate_heap) ,$ ;flt0 between Q1 and Q2 for lowQ and hihgQ files
    rescaling_ymax: 1.2,$ ;ymax when rescalling data
    rescaling_ymin: 0,$ ;ymin when rescalling data
    full_CE_name: '',$ ;full path to CE file
    short_CE_name: '',$ ;short path to CE file
    h_over_mn: 0.0039554,$ ;h/mass of neutron in USI
    FirstTimePlotting: 1,$ ;1 if first plot, 0 if not
    NbrInfoLineToDisplay: 12,$ ;the number of line to display in info box
    distanceMD: 14.85,$ ;distance Moderator-Detector (m)
    XYMinMax: PTR_NEW(0L),$
    ucams: '',$ ;remote user ucams
    file_extension: '.txt*',$ ;file extension of file to load
    file_filter: '',$
    input_path: '~/results/',$ ;default path to file to load
    PrevTabSelect: 0,$ ;value of previous tab selected
    angleValue: FLOAT(0),$ ;current value of the angle (float)
    CEcooef: PTR_NEW(0L),$ ;the fitting coeff of the CE file
    flt0_CE_range: PTR_NEW(0L),$ ;flt0 between Q1 and Q2 for CE file
    CE_scaling_factor: FLOAT(0),$ ;The CE scaling factor to go from Y to 1
    metadata_CE_file: ptrarr(4,/allocate_heap),$ ;first part of the CE input file
    flt0_xaxis: PTR_NEW(0L),$ ;x-axis of loaded file
    flt1_yaxis: PTR_NEW(0L),$ ;y-axis of loaded file
    flt2_yaxis_err: PTR_NEW(0L),$ ;y-axis error of loaded file
    FileHistory: PTR_NEW(0L),$ ;#0:CE file #1:next file...etc
    list_of_files: PTR_NEW(0L),$ ;list of files loaded
    NbrFilesLoaded: 0,$ ;number of files loaded
    Q1_array: PTR_NEW(0L),$ ;Q1 array
    Q2_array: PTR_NEW(0L),$ ;Q2 array
    SF_array: PTR_NEW(0L),$ ;Scalling factor array
    angle_array: PTR_NEW(0L),$ ;Angle value
    color_array: PTR_NEW(0L),$ ;index of color for each file
    Qmin_array: PTR_NEW(0L),$ ;list of Qmin
    Qmax_array: PTR_NEW(0L),$ ;list of Qmax
    ColorSliderDefaultValue: 25,$ ;default index value of color slider
    PreviousColorIndex: 25,$ ;color index of previous run
    color_index_step: 7, $ ;step between colors
    ListOfLongFileName: PTR_NEW(0L),$ ;list of path of file loaded
    show_CE_fit: 0,$ ;0 means the step2 has not been performed
    show_other_fit: 0$ ;0 means that the step3 has not been done yet
    })
    
  spawn, 'hostname', hostname
  instrument = ''
  if (hostname eq 'lrac.sns.gov') then instrument = 'REF_L'
  if (hostname eq 'mrac.sns.gov') then instrument = 'REF_M'
  case (instrument) of
    'REF_L': file_filter = 'REF_L_*' + (*global).file_extension
    'REF_M': file_filter = 'REF_M_*' + (*global).file_extension
    else: file_filter = ''
  endcase
  (*global).file_filter = file_filter
  
  
  CEcooef          = LONARR(3)
  FileHistory      = STRARR(1)
  list_of_files    = STRARR(1)
  Qmin_array       = FLTARR(1)
  Qmax_array       = FLTARR(1)
  Q1_array         = LONARR(1)
  Q2_array         = LONARR(1)
  SF_array         = FLTARR(1)
  angle_array      = FLTARR(1)
  color_array      = LONARR(1)
  ColorSliderDefaultValue = (*global).ColorSliderDefaultValue
  color_array[0]     = ColorSliderDefaultValue
  ListOfLongFileName = STRARR(1)
  data_spin_state = STRARR(1)
  norm_spin_state = STRARR(1)
  
  (*(*global).CEcooef)            = CEcooef
  (*(*global).FileHistory)        = FileHistory
  (*(*global).list_of_files)      = list_of_files
  (*(*global).Qmin_array)         = Qmin_array
  (*(*global).Qmax_array)         = Qmax_array
  (*(*global).Q1_array)           = Q1_array
  (*(*global).Q2_array)           = Q2_array
  (*(*global).SF_array)           = SF_array
  (*(*global).angle_array)        = angle_array
  (*(*global).color_array)        = color_array
  (*(*global).ListOfLongFileName) = ListOfLongFileName
  (*global).ucams                 = ucams
  (*(*global).BatchTable)         = STRARR(10,50)
  (*(*global).data_spin_state)     = data_spin_state
  (*(*global).norm_spin_state)     = norm_spin_state
  
  MainBaseSize         = [50 , 50, 1200, 600]
  PlotWindowSize       = [5  , 5 , 650 , 590]
  StepsTabSize         = [660, 5 , 530 , 400]
  
  ;general variables
  distance_L_TB        = 35
  distance_L_L         = 130
  distanceVertical_L_L = 35
  
  ;Define titles
  Step1Title  = 'STEP1: Load'
  Step2Title  = 'STEP2: Critical Edge'
  Step3Title  = 'STEP3: Other Files'
  ListOfFiles = ['                                                   ']
  MainTitle   = "REFLECTOMETER RESCALING PROGRAM for REF_L - " + VERSION
  
  ;Build Main Base
  MAIN_BASE_ref_scale = WIDGET_BASE(GROUP_LEADER = BatchMode, $
    UNAME        = 'MAIN_BASE_ref_scale',$
    XOFFSET      = MainBaseSize[0],$
    YOFFSET      = MainBaseSize[1],$
    SCR_XSIZE    = MainBaseSize[2], $
    SCR_YSIZE    = MainBaseSize[3], $
    TITLE        = MainTitle)
  ;                        MBAR      = WID_BASE_0_MBAR)
    
  PLOT_WINDOW = WIDGET_DRAW(MAIN_BASE_ref_scale,$
    UNAME     = 'plot_window',$
    XOFFSET   = PlotWindowSize[0],$
    YOFFSET   = PlotWindowSize[1],$
    SCR_XSIZE = PlotWindowSize[2],$
    SCR_YSIZE = PlotWindowSize[3],$
    RETAIN    = 2,$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS)
    
  STEPS_TAB = WIDGET_TAB(MAIN_BASE_ref_scale,$
    UNAME     = 'steps_tab',$
    LOCATION  = 0,$
    XOFFSET   = StepsTabSize[0],$
    YOFFSET   = StepsTabSize[1],$
    SCR_XSIZE = StepsTabSize[2],$
    SCR_YSIZE = StepsTabSize[3],$
    /TRACKING_EVENTS)
    
  ;Build STEP1 tab
  Step1Size = fMakeGuiStep1(StepsTabSize, $
    STEPS_TAB, $
    STRCOMPRESS((*global).distanceMD),$
    STRCOMPRESS((*global).angleValue),$
    ListOfFiles,$
    Step1Title)
    
  ;Build STEP2 tab
  fMakeGuiStep2, STEPS_TAB,$
    Step1Size,$
    Step2Title,$
    distance_L_TB,$
    distance_L_L,$
    distanceVertical_L_L,$
    ListOfFiles
    
  ListOfFiles = ['                                ' + $
    '                                ']
  ;Build STEP3 tab
  MakeGuiStep3, STEPS_TAB,$
    Step1Size,$
    Step3Title,$
    ListOfFiles
    
  ;Buid OUTPUT_PLOT tab
  MakeGuiOutputFile, STEPS_TAB, global
  
  MakeGuiLoadBatch, STEPS_TAB,$
    StepsTabSize
    
  ;Build LogBook Tab
  MakeGuiLogBook, STEPS_TAB, $
    StepsTabSize
    
  ;Build Main Base Components
  MakeGuiMainBaseComponents, MAIN_BASE_ref_scale, StepsTabSize
  
  ;Realize the widgets, set the user value of the top-level
  ;base, and call XMANAGER to manage everything.
  WIDGET_CONTROL, MAIN_BASE_ref_scale, /REALIZE
  WIDGET_CONTROL, MAIN_BASE_ref_scale, SET_UVALUE=global
  XMANAGER, 'MAIN_BASE_ref_scale', MAIN_BASE_ref_scale, /NO_BLOCK, $
    cleanup = 'ref_scale_cleanup'
    
  ;------------------------------------------------------------------------------
  ;- BATCH MODE ONLY ------------------------------------------------------------
  ;Show BATCH Tab if Batch Mode is used
  IF (BatchMode NE '') THEN BEGIN
    IF (BatchFile NE '') THEN BEGIN
      id = WIDGET_INFO(MAIN_BASE_ref_scale, $
        FIND_BY_UNAME='load_batch_file_text_field')
      WIDGET_CONTROL, id, SET_VALUE=BatchFile
    ENDIF
    ;Show defined tab
    id1 = WIDGET_INFO(MAIN_BASE_ref_scale, FIND_BY_UNAME='steps_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 3 ;batch tab
  ENDIF
  ;- END OF BATCH MODE ONLY -----------------------------------------------------
  ;------------------------------------------------------------------------------
  
  
  ;------------------------------------------------------------------------------
  ;- DEBUGGER MODE ONLY ---------------------------------------------------------
  IF (DEBUGGER EQ 'yes') THEN BEGIN
    ;default tab
    id1 = WIDGET_INFO(MAIN_BASE_ref_scale, FIND_BY_UNAME='steps_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 0 ;output_file
    ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 2 ;step3
    ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 0 ;output_file
    ;change default path of batch file
    (*global).BatchDefaultPath = '~/results_refm/'
    (*global).input_path       = '/SNS/REF_L/shared/'
    (*global).input_path =     '~/results/'
  ENDIF
  ;- END OF DEBUGGER MODE ONLY --------------------------------------------------
  ;------------------------------------------------------------------------------
  
  ;=============================================================================
  ;send message to log current run of application
  logger, APPLICATION=application, VERSION=version, UCAMS=ucams
  
  !P.BACKGROUND = 255
  
END

;
; Empty stub procedure used for autoloading.
;
PRO ref_scale_l, BatchMode    = BatchMode, $
    BatchFile    = BatchFile, $
    GROUP_LEADER = wGroup, $
    _EXTRA       = _VWBExtra_
  IF (N_ELEMENTS(BatchMode) EQ 0) THEN BEGIN
    BatchMode = ''
    BatchFile = ''
  ENDIF ELSE BEGIN
    BatchMode = BatchMode
  ENDELSE
  Build_GUI, BatchMode, BatchFile, GROUP_LEADER=wGgroup, _EXTRA=_VWBExtra
END
