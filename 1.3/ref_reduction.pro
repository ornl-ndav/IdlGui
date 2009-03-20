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
  RESOLVE_ROUTINE, 'ref_reduction_eventcb',$
    /COMPILE_FULL_FILE            ; Load event callback routines
  ;build the Instrument Selection base
  MakeGuiInstrumentSelection, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
END

;------------------------------------------------------------------------------
PRO BuildGui, instrument, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;retrieve global structure
  global = getGlobal(INSTRUMENT=instrument,MINIversion=0)
  
  LOADCT,5, /SILENT
  
  ;define initial global values - these could be input via external file
  ;or other means
  
  (*(*global).empty_cell_images) = getEmptyCellImages()
  (*(*global).substrate_type)    = getSubstrateType()
  
  BatchTable = STRARR(10,20)
  (*(*global).BatchTable) = BatchTable
  
  ;------------------------------------------------------------------------
  ;explanation of the select_data_status and select_norm_status
  ;0 nothing has been done yet
  ;1 user left click first and is now in back selection 1st border
  ;2 user release click and is done with back selection 1st border
  ;3 user right click and is now entering the back selection of 2nd border
  ;4 user left click and is now selecting the 2nd border
  ;5 user release click and is done with selection of 2nd border
  ;------------------------------------------------------------------------
  
  full_data_tmp_dat_file = (*global).working_path + (*global).data_tmp_dat_file
  (*global).full_data_tmp_dat_file = full_data_tmp_dat_file
  full_norm_tmp_dat_file = (*global).working_path + (*global).norm_tmp_dat_file
  (*global).full_norm_tmp_dat_file = full_norm_tmp_dat_file
  (*(*global).data_back_selection) = [-1,-1]
  (*(*global).data_peak_selection) = [-1,-1]
  (*(*global).norm_back_selection) = [-1,-1]
  (*(*global).norm_peak_selection) = [-1,-1]
  (*(*global).data_roi_selection)  = [-1,-1]
  (*(*global).norm_roi_selection)  = [-1,-1]
  
  (*global).UpDownMessage = 'Use U(up) or D(down) to move selection' + $
    ' vertically pixel per pixel.'
  (*global).REFreductionVersion = (*global).VERSION
  
  PlotsTitle = ['Data Combined Specular TOF Plot',$
    'Data Combined Background TOF Plot',$
    'Data Combined Subtracted TOF Plot',$
    'Normalization Combined Specular TOF Plot',$
    'Normalization Combined Background TOF Plot',$
    'Normalization Combined Subtracted TOF Plot',$
    'R vs TOF Plot',$
    'R vs TOF Combined Plot',$
    ;              'XML output file',$
    'Empty Cell R vs TOF Plot']
  (*(*global).PlotsTitle) = PlotsTitle
  MainPlotTitle = 'Main Data Reduction Plot'
  (*global).MainPlotTitle = MainPlotTitle
  
  ;instrument geometry
  if (instrument EQ 'REF_L') then begin ;REF_L
    InstrumentGeometryPath = '/SNS/REF_L/2006_1_4B_CAL/calibrations/'
  endif else begin
    InstrumentGeometryPath = '/SNS/REF_M/2006_1_4A_CAL/calibrations/'
  endelse
  (*global).InstrumentGeometryPath = InstrumentGeometryPath
  
  ExtOfAllPlots = ['.txt',$
    '.rmd',$
    '_data.sdc',$
    '_data.bkg',$
    '_data.sub',$
    '_norm.sdc',$
    '_norm.bkg',$
    '_norm.sub',$
    '.rtof',$
    '.crtof',$
    '.ecrtof']
  (*(*global).ExtOfAllPlots) = ExtOfAllPlots
  
  ;define Main Base variables
  ;[xoffset, yoffset, scr_xsize, scr_ysize]
  
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    MainBaseSize  = [0,0,1200,885]
  ENDIF ELSE BEGIN
    MainBaseSize  = [50,50,1200,885]
  ENDELSE
  
  MainBaseTitle = 'Reflectometer Data Reduction Package - '
  MainBaseTitle += (*global).VERSION
  IF ((*global).DEBUGGING_VERSION EQ 'yes') THEN BEGIN
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
    YPAD         = 2,$
    MBAR         = WID_BASE_0_MBAR)
    
  (*global).main_base = MAIN_BASE
  
  ;polarization state base ======================================================
  pola_base = WIDGET_BASE(MAIN_BASE,$
    XOFFSET   = 200,$
    YOFFSET   = 200,$
    SCR_XSIZE = 200,$
    SCR_YSIZE = 195,$
    UNAME     = 'polarization_state',$
    FRAME     = 10,$
    MAP       = 0,$
    /COLUMN,$
    /BASE_ALIGN_CENTER)
    
  label = WIDGET_LABEL(pola_base,$
    VALUE = 'Select a Polarization State:')
  label = WIDGET_LABEL(pola_base,$
    VALUE = '                                             ',$
    UNAME = 'pola_file_name_uname')
    
  button_base = WIDGET_BASE(pola_base,$
    /COLUMN,$
    /EXCLUSIVE)
    
  button1 = WIDGET_BUTTON(button_base,$
    VALUE = 'Off_Off',$
    UNAME = 'pola_state1_uname',$
    SENSITIVE = 1)
    
  button2 = WIDGET_BUTTON(button_base,$
    VALUE = 'Off_On',$
    UNAME = 'pola_state2_uname',$
    SENSITIVE = 1)
    
  button3 = WIDGET_BUTTON(button_base,$
    VALUE = 'On_Off',$
    UNAME = 'pola_state3_uname',$
    SENSITIVE = 0)
    
  button4 = WIDGET_BUTTON(button_base,$
    VALUE = 'On_On',$
    UNAME = 'pola_state4_uname',$
    SENSITIVE = 0)
    
  WIDGET_CONTROL, button1, /SET_BUTTON
  
  ok_cancel_base = WIDGET_BASE(pola_base,$ ;....................................
    /ROW)
    
  cancel_button = WIDGET_BUTTON(ok_cancel_base,$
    VALUE = 'CANCEL',$
    UNAME = 'cancel_pola_state',$
    XSIZE = 90)
    
  OK_button = WIDGET_BUTTON(ok_cancel_base,$
    VALUE = 'VALIDATE',$
    UNAME = 'ok_pola_state',$
    XSIZE = 90)
    
  ;==============================================================================
    
  ;attach global structure with widget ID of widget main base widget ID
  WIDGET_CONTROL, MAIN_BASE, set_uvalue=global
  
  ;HELP MENU in Menu Bar --------------------------------------------------------
  HELP_MENU = WIDGET_BUTTON(WID_BASE_0_MBAR,$
    UNAME = 'help_menu',$
    VALUE = 'HELP',$
    /MENU)
    
  HELP_BUTTON = WIDGET_BUTTON(HELP_MENU,$
    VALUE = 'HELP',$
    UNAME = 'help_button')
    
  IF ((*global).ucams EQ 'j35') THEN BEGIN
    my_help_button = WIDGET_BUTTON(HELP_MENU,$
      VALUE = 'MY HELP',$
      UNAME = 'my_help_button')
  ENDIF
  
  structure = {with_launch_button: (*global).with_launch_switch}
  
  MakeGuiMainTab, $
    MAIN_BASE, $
    MainBaseSize, $
    instrument, $
    PlotsTitle, $
    structure
    
  ;hidden widget_text
  DataHiddenWidgetText = WIDGET_TEXT(MAIN_BASE,$
    XOFFSET = 1,$
    YOFFSET = 1,$
    /ALL_EVENTS,$
    UNAME='data_hidden_widget_text')
  (*global).DataHiddenWidgetTextId = DataHiddenWidgetText
  (*global).DataHiddenWidgetTextUname = 'data_hidden_widget_text'
  
  NormHiddenWidgetText = WIDGET_TEXT(MAIN_BASE,$
    XOFFSET = 1,$
    YOFFSET = 1,$
    /ALL_EVENTS,$
    UNAME='norm_hidden_widget_text')
  (*global).NormHiddenWidgetTextId = NormHiddenWidgetText
  (*global).NormHiddenWidgetTextUname = 'norm_hidden_widget_text'
  
  WIDGET_CONTROL, /REALIZE, MAIN_BASE
  XMANAGER, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  ;initialize contrast droplist
  id = WIDGET_INFO(Main_base,Find_by_Uname='data_contrast_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialDataContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='normalization_contrast_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialNormContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='data_loadct_1d_3d_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialData1d3DContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='normalization_loadct_1d_3d_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialNorm1d3DContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='data_loadct_2d_3d_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialData2d3DContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='normalization_loadct_2d_3d_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialNorm2d3DContrastDropList
    
  ;initialize CommandLineOutput widgets (path and file name)
  id = WIDGET_INFO(Main_base, find_by_uname='cl_directory_text')
  WIDGET_CONTROL, id, set_value=(*global).cl_output_path
  time = RefReduction_GenerateIsoTimeStamp()
  file_name = (*global).cl_file_ext1 + time + (*global).cl_file_ext2
  id = WIDGET_INFO(Main_Base, find_by_uname='cl_file_text')
  WIDGET_CONTROL, id, set_value=file_name
  
  IF ((*global).ucams EQ 'j35' OR $
    (*global).ucams EQ '2zr') THEN BEGIN
    id = WIDGET_INFO(MAIN_BASE,find_by_uname='reduce_cmd_line_preview')
    WIDGET_CONTROL, id, /editable
    WIDGET_CONTROL, /CONTEXT_EVENTS
  ENDIF
  
  IF ((*global).ucams EQ 'j35') THEN BEGIN
    id = WIDGET_INFO(MAIN_BASE,find_by_uname='cmd_status_preview')
    WIDGET_CONTROL, id, /editable
  ENDIF
  
  IF ((*global).DEBUGGING_VERSION EQ 'yes') THEN BEGIN
  
    ; Default Main Tab Shown
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
    ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 1 ;REDUCE
    ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 2 ;PLOT
    ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 3 ;BATCH
    ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 4 ;LOG BOOK
    
    ;default path of Load Batch files
    (*global).BatchDefaultPath = '~/tmp/'
    
  ; default tabs shown
  ;    id1 = widget_info(MAIN_BASE, find_by_uname='roi_peak_background_tab')
  ;    widget_control, id1, set_tab_current = 1 ;peak/background
    
  ;    id2 = widget_info(MAIN_BASE, find_by_uname='data_normalization_tab')
  ;    widget_control, id2, set_tab_current = 1 ;NORMALIZATION
    
  ;change default location of Batch file
  ;    (*global).BatchDefaultPath = '/SNS/REF_L/shared/'
    
  ; id2 = widget_info(MAIN_BASE, find_by_uname='data_normalization_tab')
  ; widget_control, id2, set_tab_current = 2  ;empty cell
    
  ; id3 = widget_info(MAIN_BASE, find_by_uname='load_data_d_dd_tab')
  ; widget_control, id3, set_tab_current = 3  ;Y vs X (2D)
    
  ;id4 = widget_info(MAIN_BASE, find_by_uname='data_back_peak_rescale_tab')
  ;widget_control, id4, set_tab_current = 3 ;ouput ascii file
    
  ENDIF ;end of debugging_version statement
  
  ;display empty cell images ----------------------------------------------------
  ;get images files
  sImages = (*(*global).empty_cell_images)
  
  ;background image
  draw1 = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='confuse_background')
  WIDGET_CONTROL, draw1, GET_VALUE=id
  WSET, id
  image = READ_PNG(sImages.confuse_background)
  TV, image, 0,0,/true
  
  ;empty cell image
  empty_cell_draw = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='empty_cell_draw')
  WIDGET_CONTROL, empty_cell_draw, GET_VALUE=id
  WSET, id
  image = READ_PNG(sImages.empty_cell)
  TV, image, 0,0,/true
  
  ;data background image
  data_background_draw = WIDGET_INFO(MAIN_BASE, $
    FIND_BY_UNAME='data_background_draw')
  WIDGET_CONTROL, data_background_draw, GET_VALUE=id
  WSET, id
  image = READ_PNG(sImages.data_background)
  TV, image, 0,0,/true
  
  ;display equation of Scalling factor in Empty Cell tab
  draw1 = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='scaling_factor_equation_draw')
  WIDGET_CONTROL, draw1, GET_VALUE=id
  WSET, id
  image = READ_PNG((*global).sf_equation_file)
  TV, image, 0,0,/true
  
  ;------------------------------------------------------------------------------
  ;populate the list of proposal droplist (data, normalization,empty_cell)
  populate_list_of_proposal, MAIN_BASE, (*global).instrument
  
  ;==============================================================================
  ;checking packages
  IF ((*global).DEBUGGING_VERSION EQ 'yes') THEN BEGIN
    packages_required, global, my_package ;packages_required
    (*(*global).my_package) = my_package
  ENDIF
  IF ((*global).CHECKING_PACKAGES EQ 'yes') THEN BEGIN
    packages_required, global, my_package ;packages_required
    checking_packages_routine, MAIN_BASE, my_package, global
    update_gui_according_to_package, MAIN_BASE, my_package
  ENDIF
  ;==============================================================================
  
  ;send message to log current run of application
  logger, global
  
END


; Empty stub procedure used for autoloading.
pro ref_reduction, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;check instrument here
  SPAWN, 'hostname',listening
  CASE (listening) OF
    'lrac': instrument = 'REF_L'
    'mrac': instrument = 'REF_M'
    'heater': instrument = 'UNDEFINED'
    else: instrument = 'UNDEFINED'
  ENDCASE
  
  if (instrument EQ 'UNDEFINED') then begin
    BuildInstrumentGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  endif else begin
    BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument
  endelse
end





