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

PRO make_gui_Reduce_step1, REDUCE_TAB, sTab, TabTitles, global

  instrument = (*global).instrument
  number_of_sangle = (*global).number_of_sangle
  
  ;****************************************************************************
  ;            DEFINE STRUCTURE
  ;****************************************************************************
  
  sBase = { size:  stab.size,$
    uname: 'reduce_step1_tab_base',$
    title: TabTitles.step1}
    
  ;****************************************************************************
  ;            BUILD GUI
  ;****************************************************************************
  ; ====== SECOND PAGE ======
  TabBase = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = 'reduce_step1_top_base',$
    XOFFSET   = sBase.size[0],$
    YOFFSET   = sBase.size[1],$
    SCR_XSIZE = sBase.size[2],$
    SCR_YSIZE = sBase.size[3],$
    TITLE     = sBase.title,$
    map = 1)
    
  ;****************************************************************************
  ; Change code (RC Ward, March 22, 2010): Remove the graphic with the equation for Sangle.
  ;  SangleBaseEquation = WIDGET_BASE(TabBase, $
  ;    UNAME = 'reduce_step1_sangle_base_equation', $
  ;    XOFFSET   = 450, $
  ;    YOFFSET   = 695, $
  ;    SCR_XSIZE = 350, $
  ;    SCR_YSIZE = 100, $
  ;    map = 0)
    
  ;equation
  ;  equation = WIDGET_DRAW(SangleBaseEquation,$
  ;    UNAME = 'reduce_step1_sangle_equation',$
  ;    XSIZE = 350,$
  ;    YSIZE = 100)
    
  ; Code Change (RC Ward, 27 March 2010): Extensive redsign of the GUI was implemented
  ; Allowed shrinking the vertical screen size for viewing on laptop
  SangleBaseLabel = WIDGET_BASE(TabBase, $
    UNAME = 'reduce_step1_sangle_base_label', $
    XOFFSET = 45, $
    YOFFSET = 640, $
    MAP = 0, $
    /ROW)
    
  ;Sangle info base title
  title = WIDGET_LABEL(SangleBaseLabel,$
    VALUE = 'Run Number: N/A',$
    SCR_XSIZE = 150,$
    UNAME = 'reduce_sangle_info_title_base')
    
  ;SANGLE base
  SangleBase = WIDGET_BASE(TabBase,$
    UNAME     = 'reduce_step1_sangle_base',$
    XOFFSET   = sBase.size[0],$
    YOFFSET   = sBase.size[1],$
    SCR_XSIZE = sBase.size[2],$
    SCR_YSIZE = sBase.size[3],$
    FRAME = 0,$
    /COLUMN, $
    map = 0)
    
  row1 = WIDGET_BASE(SangleBase,$ ;.................................
    /ROW)
    
  row1col1 = WIDGET_BASE(row1,$ ;...................................
    /COLUMN)
    
  ; column 1
  table = WIDGET_TABLE(row1col1,$
    COLUMN_LABELS = ['Data Run #',$
    'Sangle [rad (deg)]'],$
    UNAME = 'reduce_sangle_tab_table_uname',$
    /NO_ROW_HEADERS,$
    ;    /RESIZEABLE_COLUMNS,$
    ALIGNMENT = 0,$
    XSIZE = 2,$
    ; Code change (RC Ward, April 7, 2010): use variable to specify the number of scattering angles
    ;   YSIZE = 18,$
    YSIZE = number_of_sangle,$
    SCR_XSIZE = 232,$
    SCR_YSIZE = 380,$
    COLUMN_WIDTHS = [105,148],$
    ;/SCROLL,$
    /ALL_EVENTS)
  WIDGET_CONTROL, table, SET_TABLE_SELECT=[0,0,1,0]
  
  reset_sangle = WIDGET_BUTTON(row1col1,$
    VALUE = 'Reset SANGLE flag of selected run number',$
    UNAME = 'reduce_sangle_tab_reset_button',$
    SENSITIVE = 1)
    
  ;Counts vs pixel plot
  help_plot = WIDGET_DRAW(row1col1,$
    SCR_XSIZE = (*global).sangle_help_xsize_draw,$
    SCR_YSIZE = (*global).sangle_help_ysize_draw,$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS,$
    retain=2,$
    /TRACKING_EVENTS,$
    UNAME = 'sangle_help_draw')
    
  ; column 2
  row1col2 = WIDGET_BASE(row1,$ ;............................
    UNAME = 'reduce_sangle_plot_base')
    
  label = WIDGET_LABEL(row1col2,$
    VALUE = 'Pixel vs TOF (microsS)', $
    UNAME = 'reduce_sangle_plot_title',$
    ;    XOFFSET = 720,$
    XOFFSET = (*global).sangle_xsize_draw - 125,$
    YOFFSET = 35)
    
  plot = WIDGET_DRAW(row1col2,$
    UNAME = 'reduce_sangle_plot',$
    XOFFSET = 40,$
    YOFFSET = 5,$
    /TRACKING_EVENTS, $
    /MOTION_EVENTS, $
    /BUTTON_EVENTS, $
    retain=2,$
    XSIZE = (*global).sangle_xsize_draw,$
    YSIZE = 2 * (*global).detector_pixels_y)
    
  ;scale
  scale = WIDGET_DRAW(row1col2, $
    UNAME = 'reduce_sangle_y_scale', $
    XSIZE = (*global).sangle_xsize_draw + 55,$
    ; Change made: Replace 304 with detector_pixels_y obtained from XML fole (RCW, Feb 10, 2010)
    YSIZE = 2 * (*global).detector_pixels_y + 30,$
    ;    YSIZE = 2*304+30,$
    retain=2,$
    YOFFSET = 0)
  ; Change code (RC Ward, 7 Aug 2010): Add label on x-axis, namely "TOF (micro seconds)".
  label = WIDGET_LABEL(row1col2, $
    VALUE = 'TOF (ms)',$
    XOFFSET= 300,$
    YOFFSET= 635)
  ; Change code (RC Ward, 7 Aug 2010): Move log/linear toggle to lower right, underneath the plot
  row1col2a = WIDGET_BASE(row1col2, $
    /ROW,$
    XOFFSET = 500,$
    YOFFSET = 635,$
    /EXCLUSIVE)
    
  button1 = WIDGET_BUTTON(row1col2a, $
    VALUE = 'Linear',$
    /NO_RELEASE, $
    UNAME = 'reduce_sangle_lin',$
    SENSITIVE = 1)
  button2 = WIDGET_BUTTON(row1col2a, $
    VALUE = 'Log',$
    /NO_RELEASE, $
    UNAME = 'reduce_sangle_log', $
    SENSITIVE = 1)
    
  WIDGET_CONTROL, button2, /SET_BUTTON
  
  ; column 3
  row1col3Main = WIDGET_BASE(row1,$ ;---------------------------------------
    /COLUMN)
    
  row1col3 = WIDGET_BASE(row1col3Main,$ ;..................................
    /COLUMN, $
    /EXCLUSIVE)
    
  button1 = WIDGET_BUTTON(row1col3,$
    VALUE = 'Off_Off',$
    UNAME = 'reduce_sangle_1',$
    /NO_RELEASE, $
    SENSITIVE = 1)
  button2 = WIDGET_BUTTON(row1col3,$
    VALUE = 'Off_On',$
    /NO_RELEASE, $
    UNAME = 'reduce_sangle_2', $
    SENSITIVE = 0)
  button3 = WIDGET_BUTTON(row1col3,$
    VALUE = 'On_Off',$
    /NO_RELEASE, $
    UNAME = 'reduce_sangle_3', $
    SENSITIVE = 1)
  button4 = WIDGET_BUTTON(row1col3,$
    VALUE = 'On_On',$
    /NO_RELEASE, $
    UNAME = 'reduce_sangle_4', $
    SENSITIVE = 0)
    
  WIDGET_CONTROL, button1, /SET_BUTTON
  
  ; Change code (RC Ward, 7 Aug 2010): Remove log/linear toggle from this location and move (see above)
  ;  space = WIDGET_LABEL(row1col3Main, $
  ;    VALUE = ' ')
  
  ;  row1col3b = WIDGET_BASE(row1col3Main,$ ;..................................
  ;    /COLUMN, $
  ;    /EXCLUSIVE)
  
  ;  button1 = WIDGET_BUTTON(row1col3b,$
  ;    VALUE = 'Linear',$
  ;    /NO_RELEASE, $
  ;    UNAME = 'reduce_sangle_lin',$
  ;    SENSITIVE = 1)
  ;  button2 = WIDGET_BUTTON(row1col3b,$
  ;    VALUE = 'Log',$
  ;    /NO_RELEASE, $
  ;    UNAME = 'reduce_sangle_log', $
  ;    SENSITIVE = 1)
  
  ;  WIDGET_CONTROL, button2, /SET_BUTTON
  ;================================
  ; Table of values from the nexus header
  ;================================
  
  ;row #1
  row1col3c = WIDGET_BASE(row1col3Main,$ ;..................................
    /COLUMN, $
    FRAME = 5)
  base3c = WIDGET_BASE(row1col3c,$
    /ROW)
  value = WIDGET_LABEL(base3c,$
    /ALIGN_LEFT, $
    VALUE = 'File: N/A',$
    SCR_XSIZE = 300,$
    UNAME = 'reduce_sangle_base_full_file_name')
    
  ;row #2
  row1col3d = WIDGET_BASE(row1col3Main,$ ;..................................
    /ROW,$
    FRAME=1)
  base3d = WIDGET_BASE(row1col3d,$
    /ROW)
  label = WIDGET_LABEL(base3d,$
    /ALIGN_LEFT, $
    VALUE = '      Dangle [rad (deg)]: ')
  value = WIDGET_LABEL(base3d,$
    VALUE = 'N/A',$
    SCR_XSIZE = 140,$
    /ALIGN_LEFT, $
    UNAME = 'reduce_sangle_base_dangle_value')
    
  ;Row #3
  row1col3e = WIDGET_BASE(row1col3Main,$ ;..................................
    /ROW,$
    FRAME=1)
  base3e = WIDGET_BASE(row1col3e,$
    /ROW)
  label = WIDGET_LABEL(base3e,$
    /ALIGN_LEFT, $
    VALUE = '     Dangle0 [rad (deg)]: ')
  value = WIDGET_LABEL(base3e,$
    VALUE = 'N/A',$
    SCR_XSIZE = 140,$
    /ALIGN_LEFT, $
    UNAME = 'reduce_sangle_base_dangle0_value')
    
  ;Row #4
  row1col3f = WIDGET_BASE(row1col3Main,$ ;..................................
    /ROW,$
    FRAME=1)
  base3f = WIDGET_BASE(row1col3f,$
    /ROW)
    
  label = WIDGET_LABEL(base3f,$
    /ALIGN_LEFT, $
    VALUE = '      Sangle [rad (deg)]: ')
  value = WIDGET_LABEL(base3f,$
    VALUE = 'N/A',$
    SCR_XSIZE = 140,$
    /ALIGN_LEFT, $
    UNAME = 'reduce_sangle_base_sangle_value')
    
  ;Row #5
  row1col3g = WIDGET_BASE(row1col3Main,$ ;..................................
    /ROW,$
    FRAME=1)
  ;left part
  base3g = WIDGET_BASE(row1col3g,$
    /ROW)
  label = WIDGET_LABEL(base3g,$
    /ALIGN_LEFT, $
    VALUE = '     DirPix: ')
  value = WIDGET_LABEL(base3g,$
    VALUE = 'N/A',$
    SCR_XSIZE = 80,$
    /ALIGN_LEFT, $
    UNAME = 'reduce_sangle_base_dirpix_value')
    
  space = WIDGET_LABEL(base3g,$
    VALUE = '  ')
    
  label = WIDGET_LABEL(base3g,$
    /ALIGN_LEFT, $
    VALUE = ' RefPix: ')
  value = WIDGET_LABEL(base3g,$
    VALUE = 'N/A',$
    SCR_XSIZE = 80,$
    /ALIGN_LEFT, $
    UNAME = 'reduce_sangle_base_refpix_value')
    
  row1col3h = WIDGET_BASE(row1col3Main,$ ;..................................
    /ROW,$
    FRAME=1)
    
  base3h = WIDGET_BASE(row1col3h,$
    /ROW)
    
  label = WIDGET_LABEL(base3h,$
    /ALIGN_LEFT, $
    VALUE = 'Sample-Detector Distance [m]: ')
  value = WIDGET_LABEL(base3h,$
    VALUE = 'N/A',$
    SCR_XSIZE = 140,$
    /ALIGN_LEFT, $
    UNAME = 'reduce_sangle_base_sampledetdis_value')
  ;================================
  ; Cursor Position
  ;================================
  ;live cursor info
  ;  row1col3j = WIDGET_BASE(row1col3Main,$ ;..................................
  ;    /COLUMN,$
  ;    FRAME=2)
    
  ;   base3j = WIDGET_BASE(row1col3j,$
  ;    /ROW)
    
  ; Code change (RC Ward, 25 Jan 2010): Change text here
  ;  title1 = WIDGET_LABEL(base3j,$
  ;     VALUE = 'Cursor Position:',$
  ;     /ALIGN_CENTER);
    
  row1col3i = WIDGET_BASE(row1col3Main,$ ;..................................
    /COLUMN,$
    FRAME=1)
    
  base3i = WIDGET_BASE(row1col3i,$
    /ROW)
    
  tof = WIDGET_LABEL(base3i,$
    VALUE = 'Cursor: TOF (ms):',$
    /ALIGN_LEFT)
  value = WIDGET_LABEL(base3i,$
    VALUE = 'N/A',$
    SCR_XSIZE = 80,$
    UNAME = 'reduce_sangle_live_info_tof',$
    /ALIGN_LEFT)
    
  tof = WIDGET_LABEL(base3i,$
    VALUE = 'Pixel:',$
    /ALIGN_LEFT)
  value = WIDGET_LABEL(base3i,$
    VALUE = 'N/A',$
    SCR_XSIZE = 80,$
    UNAME = 'reduce_sangle_live_info_pixel',$
    /ALIGN_LEFT)
  ;================================
  ; Change code (RC Ward, 13 July 2010): display default apply_tof_cutoffs and allow user to change that
  row1col3j = WIDGET_BASE(row1col3Main,$ ;..................................
    /COLUMN,$
    FRAME=1)
    
  base3j = WIDGET_BASE(row1col3j,$
    /ROW)
    
  label = WIDGET_LABEL(base3j,$
    /ALIGN_LEFT,$
    VALUE = 'Apply TOF Cutoffs: (yes/no):')
  value = WIDGET_TEXT(base3j,$
    VALUE = 'N/A',$
    UNAME = 'reduce_sangle_base_apply_tof_cutoffs_value',$
    /EDITABLE, $
    XSIZE = 6)
  ;
  ; Change code (RC Ward, 16 June 2010): display default tof_cutoffs and allow user to change them
  ;TOF cutoffs
  row1col3k = WIDGET_BASE(row1col3Main,$ ;..................................
    /COLUMN,$
    FRAME=1)
    
  base3k = WIDGET_BASE(row1col3k,$
    /ROW)
    
  label = WIDGET_LABEL(base3k,$
    /ALIGN_LEFT,$
    VALUE = 'TOF Cutoffs: Min:')
  value = WIDGET_TEXT(base3k,$
    VALUE = 'N/A',$
    UNAME = 'reduce_sangle_base_tof_cutoff_min_value',$
    /EDITABLE, $
    XSIZE = 10)
  space = WIDGET_LABEL(base3k,$
    VALUE = '  ')
    
  label = WIDGET_LABEL(base3k,$
    /ALIGN_LEFT,$
    VALUE = 'Max:')
  value = WIDGET_TEXT(base3k,$
    VALUE = 'N/A',$
    UNAME = 'reduce_sangle_base_tof_cutoff_max_value',$
    /EDITABLE, $
    XSIZE = 10)
  space = WIDGET_LABEL(base3k,$
    VALUE = '  ')
  ;================================
  ;Dangle0
  row1col3m = WIDGET_BASE(row1col3Main,$ ;..................................
    /COLUMN, $
    FRAME = 2)
  base3m = WIDGET_BASE(row1col3m,$
    ;    XOFFSET = 155,$
    ;    YOFFSET = 40,$
    /ROW)
    
  ; Change code (RC Ward, 6 Sept 2010): Add entry box for Dangle.
    
  label = WIDGET_LABEL(base3m,$
    /ALIGN_LEFT,$
    VALUE = 'Dangle:')
  value = WIDGET_TEXT(base3m,$
    VALUE = 'N/A',$
    UNAME = 'reduce_sangle_base_dangle_user_value',$
    /EDITABLE, $
    XSIZE = 10)
  space = WIDGET_LABEL(base3m,$
    VALUE = '  ')
    
  label = WIDGET_LABEL(base3m,$
    /ALIGN_LEFT,$
    VALUE = 'Dangle0:')
  value = WIDGET_TEXT(base3m,$
    VALUE = 'N/A',$
    UNAME = 'reduce_sangle_base_dangle0_user_value',$
    /EDITABLE, $
    XSIZE = 10)
  space = WIDGET_LABEL(base3m,$
    VALUE = '  ')
    
  ; Change code (RC Ward, 6 Sept 2010): Move Sample-Detector distance down to separate line
    
  row1col3mm = WIDGET_BASE(row1col3Main,$ ;..................................
    /COLUMN, $
    FRAME = 2)
  base3mm = WIDGET_BASE(row1col3mm,$
    ;    XOFFSET = 155,$
    ;    YOFFSET = 40,$
    /ROW)
    
  label = WIDGET_LABEL(base3mm,$
    /ALIGN_LEFT,$
    VALUE = 'Sample-Detector Distance (m):')
  value = WIDGET_TEXT(base3mm,$
    VALUE = 'N/A',$
    UNAME = 'reduce_sangle_base_sampledetdis_user_value',$
    /EDITABLE, $
    XSIZE = 10)
  space = WIDGET_LABEL(base3m,$
    VALUE = '  ')
  ;================================
  ;RefPix and DirPix
  row1col3n = WIDGET_BASE(row1col3Main,$ ;..................................
    /COLUMN, $
    FRAME = 2)
  base3n = WIDGET_BASE(row1col3n,$
    ;    XOFFSET = 155,$
    ;    YOFFSET = 40,$
    /ROW)
    
  label = WIDGET_LABEL(base3n,$
    /ALIGN_LEFT,$
    VALUE = 'RefPix:')
  value = WIDGET_TEXT(base3n,$
    VALUE = 'N/A',$
    UNAME = 'reduce_sangle_base_refpix_user_value',$
    /EDITABLE, $
    XSIZE = 10)
  space = WIDGET_LABEL(base3n,$
    VALUE = '  ')
    
  label = WIDGET_LABEL(base3n,$
    /ALIGN_LEFT,$
    VALUE = 'DirPix:')
  value = WIDGET_TEXT(base3n,$
    VALUE = 'N/A',$
    UNAME = 'reduce_sangle_base_dirpix_user_value',$
    /EDITABLE, $
    XSIZE = 10)
  ;=================================
  ; Sangle
  row1col3o = WIDGET_BASE(row1col3Main,$ ;..................................
    /COLUMN, $
    FRAME = 2)
  base3o = WIDGET_BASE(row1col3o,$
    FRAME = 1,$
    /ROW)
    
  label = WIDGET_LABEL(base3o,$
    /ALIGN_LEFT,$
    VALUE = 'Sangle [rad (deg)]: ')
  value = WIDGET_LABEL(base3o,$
    VALUE = 'N/A (N/A)',$
    UNAME = 'reduce_sangle_base_sangle_user_value',$
    SCR_XSIZE = 200,$
    /ALIGN_LEFT)
    
  ;row2 of SANGLE BASE
  row2 = WIDGET_BASE(SangleBase,$ ;.................................
    /ROW)
    
  space = widget_label(row2,$
    value = '                                                                    ')
    
  row2a = widget_base(row2,$
    /column)
  ;first inside row (browse button)
  browse_button = WIDGET_BUTTON(row2a,$
    VALUE = 'B R O W S E   F O R   A   B A C K.  R O I . . .',$
    SCR_XSIZE = 320,$
    TOOLTIP = 'Click to browse for a background ROI file and plot it',$
    UNAME = 'reduce_step1_create_roi_browse_back_roi_button')
    
  row3col2_base2 = WIDGET_BASE(row2a,$
    /ROW)
    
  y1_working = WIDGET_LABEL(row3col2_base2,$
    VALUE = '  ',$
    /ALIGN_LEFT, $
    UNAME = 'reduce_step1_create_back_roi_y1_l_status')
  y1_label = WIDGET_LABEL(row3col2_base2,$
    /ALIGN_LEFT, $
    VALUE = 'Y1:')
  y1_value = WIDGET_TEXT(row3col2_base2,$
    VALUE = ' ',$
    XSIZE = 3,$
    /EDITABLE,$
    /ALIGN_LEFT,$
    UNAME = 'reduce_step1_create_back_roi_y1_value')
  y1_working = WIDGET_LABEL(row3col2_base2,$
    VALUE = '  ',$
    /ALIGN_LEFT, $
    UNAME = 'reduce_step1_create_back_roi_y1_r_status')
    
  space = WIDGET_LABEL(row3col2_base2,$
    value = '  ')
    
    
  y2_working = WIDGET_LABEL(row3col2_base2,$
    VALUE = ' ',$
    UNAME = 'reduce_step1_create_back_roi_y2_l_status')
  y2_label = WIDGET_LABEL(row3col2_base2,$
    VALUE = 'Y2:')
  y2_value = WIDGET_TEXT(row3col2_base2,$
    VALUE = ' ',$
    XSIZE = 3,$
    /EDITABLE,$
    /ALIGN_LEFT,$
    UNAME = 'reduce_step1_create_back_roi_y2_value')
  y2_working = WIDGET_LABEL(row3col2_base2,$
    VALUE = ' ',$
    UNAME = 'reduce_step1_create_back_roi_y2_r_status')
  space = widget_label(row3col2_base2,$
    value = '   ')
  reset = widget_button(row3col2_base2,$
    value = 'Reset',$
    uname = 'reset_step1_back_roi_inputs')
    
  ; ;Select background | select dirpix/refpix
  ; DirRef_back_base = widget_base(row2,$
  ;    /exclusive,$
  ;    frame=5,$
  ;    /column)
  ;  DirRef = widget_button(DirRef_back_base,$
  ;    value = 'Select DIRPIX/REFPIX',$
  ;    /no_release,$
  ;    uname = 'working_with_data_dirpix_refpix')
  ;  back = widget_button(DirRef_back_base,$
  ;    value = 'Select BACKGROUND ROI',$
  ;    /no_release,$
  ;    uname = 'working_with_data_back')
  ;  widget_control, DirRef,/set_button
    
    
  ; DONE button
    
  space = widget_label(row2,$
    value = '                            ')
  done = WIDGET_BUTTON(row2,$
    VALUE = 'RETURN TO DATA TAB',$
    UNAME = 'reduce_sangle_done_button',$
    frame=5,$
    SCR_XSIZE = 320)
    
  ;****************************************************************************
  ; ====== INITIAL PAGE ======
  TopBase = WIDGET_BASE(TabBase,$
    UNAME     = 'reduce_step1_top_base',$
    XOFFSET   = sBase.size[0],$
    YOFFSET   = sBase.size[1],$
    SCR_XSIZE = sBase.size[2],$
    SCR_YSIZE = sBase.size[3],$
    map = 1)
    
  ;list of polarization states ------------------------------------------------
  wPolaBase = WIDGET_BASE(TopBase,$
    XOFFSET   = 400,$
    YOFFSET   = 130,$
    SCR_XSIZE = 300,$
    SCR_YSIZE = 180,$
    UNAME     = 'reduce_tab1_polarization_base',$
    FRAME     = 10,$
    MAP       = 0,$
    /COLUMN,$
    /BASE_ALIGN_CENTER)
    
  wLabel = WIDGET_LABEL(wPolaBase,$
    VALUE = 'Select the Polarization State You Want to Use:')
    
  ColumnBase = WIDGET_BASE(wPolaBase,$
    /COLUMN,$
    /BASE_ALIGN_TOP,$
    /EXCLUSIVE,$
    UNAME = 'reduce_tab1_pola_base_list_of_pola_state')
    
  button1 = WIDGET_BUTTON(ColumnBase,$
    VALUE = 'Off-Off  ',$
    UNAME = 'reduce_tab1_pola_base_pola_1',$
    SENSITIVE = 1)
  button2 = WIDGET_BUTTON(ColumnBase,$
    VALUE = 'Off-On  ',$
    UNAME = 'reduce_tab1_pola_base_pola_2',$
    SENSITIVE = 1)
  button3 = WIDGET_BUTTON(ColumnBase,$
    VALUE = 'On-Off  ',$
    UNAME = 'reduce_tab1_pola_base_pola_3',$
    SENSITIVE = 1)
  button4 = WIDGET_BUTTON(ColumnBase,$
    VALUE = 'On-On  ',$
    UNAME = 'reduce_tab1_pola_base_pola_4',$
    SENSITIVE = 1)
    
  okButton = WIDGET_BUTTON(wPolaBase,$
    VALUE = 'OK',$
    SCR_XSIZE = 250,$
    UNAME = 'reduce_tab1_pola_base_valid_button')
    
  ;Main base --------------------------------------------------------------------
  Base = WIDGET_BASE(TopBase,$
    UNAME     = sBase.uname,$
    XOFFSET   = 0,$
    YOFFSET   = 0,$
    SCR_XSIZE = sBase.size[2],$
    SCR_YSIZE = sBase.size[3],$
    /BASE_ALIGN_LEFT,$
    /COLUMN,$
    map = 1)
    
  ;Vertical space
  vSpace = WIDGET_LABEL(Base,$
    VALUE = '',$
    YSIZE = 15)
    
  ;Load New Entry (row #1) ------------------------------------------------------
  Row1 = WIDGET_BASE(Base,$
    /ROW,$
    SCR_XSIZE = 1200,$
    FRAME = 0)
    
  lLoad = WIDGET_LABEL(Row1,$
    VALUE = '     Load New Entry into Table   ')
    
  bBrowse = WIDGET_BUTTON(Row1,$
    VALUE = '  BROWSE...  ',$
    UNAME = 'reduce_tab1_browse_button')
    
  lOrRun = WIDGET_LABEL(Row1,$
    VALUE = '  or   Run(s) #:')
    
  IF ((*global).DEBUGGING EQ 'yes') THEN BEGIN
    value = (*global).sDebugging.reduce_tab1_cw_field
  ENDIF ELSE BEGIN
    value = ''
  ENDELSE
  
  ;=================== COMMENT OUT LATTER =============================================================
  ; For debugging, set the value to desired run numbers (RCW, Dec 31, 2009, Modified Feb 1, 2010)
  ; Commented out for release of Ver 1.5.0 on 16 June 2010
  ; IF (instrument EQ 'REF_L') THEN BEGIN
  ;    value = '24586-24591'
  ;  ENDIF ELSE BEGIN
  ;    value = '5387-5389'
  ;  ENDELSE
  ;=================== COMMENT OUT LATTER =============================================================
  
  tRun = CW_FIELD(Row1,$
    XSIZE = 40,$
    UNAME = 'reduce_tab1_run_cw_field',$
    TITLE = '',$
    VALUE = value,$
    /RETURN_EVENTS)
    
  label = WIDGET_LABEL(Row1,$
    VALUE = '(ex: 1245,1345-1347,1349)')
    
  ;Table (Row #2) ---------------------------------------------------------------
  Row2 = WIDGET_BASE(Base,$
    /ROW)
    
  space = WIDGET_LABEL(Row2,$
    VALUE = '  ')
    
  table = WIDGET_TABLE(Row2,$
    COLUMN_LABELS = ['Run #',$
    'Full NeXus File Name'],$
    UNAME = 'reduce_tab1_table_uname',$
    /NO_ROW_HEADERS,$
    /RESIZEABLE_COLUMNS,$
    ALIGNMENT = 0,$
    XSIZE = 2,$
    
    ; Code change (RC Ward, April 7, 2010): use variable to specify the number of scattering angles
    ;    YSIZE = 18,$
    YSIZE = number_of_sangle,$
    ;    SCR_XSIZE = 1230,$
    ;    SCR_YSIZE = 400,$
    ; Code change (RC Ward, April 7, 2010): Change size of table - make it more realistic
    SCR_XSIZE = 800, $
    SCR_YSIZE = 300, $
    COLUMN_WIDTHS = [100,700],$
    ;    /SCROLL,$
    /ALL_EVENTS)
    
  WIDGET_CONTROL, table, SET_TABLE_SELECT=[0,0,1,0]
  
  ;Button (Row #3) --------------------------------------------------------------
  Row3 = WIDGET_BASE(Base,$
    /ROW)
    
  button1 = WIDGET_BUTTON(Row3,$
    VALUE = 'Remove Selected Run',$
    UNAME = 'reduce_step1_remove_selection_button',$
    SENSITIVE = 0)
    
  ;  button2 = WIDGET_BUTTON(Row3,$
  ;    VALUE = 'Display Y vs TOF of Selected Run',$
  ;    UNAME = 'reduce_step1_display_y_vs_tof_button',$
  ;    SENSITIVE = 0)
  ;
  ;  button3 = WIDGET_BUTTON(Row3,$
  ;    VALUE = 'Display Y vs X of Selected Run',$
  ;    UNAME = 'reduce_step1_display_y_vs_x_button',$
  ;    SENSITIVE = 0)
    
  IF ((*global).instrument EQ 'REF_M') THEN BEGIN
    space = widget_label(Row3,$
    value = '                          ')
    
    sangle_button = WIDGET_BUTTON(Row3,$
      VALUE = '  BACKGROUND ROI and SANGLE selection tool  ',$
      UNAME = 'reduce_step1_sangle_button', $
      scr_ysize = 30,$
      SENSITIVE = 0)
  ENDIF else begin
  
    space = widget_label(row3,$
    value = '                            ')
    back_roi_button = widget_button(row3,$
    value ='  BACKGROUND selection tool  ',$
    uname = 'reduce_step1_back_button',$
    scr_ysize = 30,$
    sensitive = 1)
  
  endelse
  
  ;Repeat work for other polarization states (Row #4) ---------------------------
  Row4_row = WIDGET_BASE(Base,$
    UNAME = 'reduce_tab1_row4_base',$
    /ROW)
  ; shift the buttons over a bit
  space = WIDGET_LABEL(Row4_row, $
    VALUE='                          ')
    
  IF (instrument EQ 'REF_L') THEN BEGIN
    map = 0
  ENDIF ELSE BEGIN
    map = 1
  ENDELSE
  
  Row4 = WIDGET_BASE(Row4_row,$
    FRAME = 1,$
    MAP = map,$
    /ROW)
    
  label = WIDGET_LABEL(Row4,$
    VALUE = 'Reflected Data Polarization States: ')
    
  Row4Base = WIDGET_BASE(Row4,$
    /ROW,$
    /NONEXCLUSIVE)
    
  button1 = WIDGET_BUTTON(Row4Base,$
    VALUE = 'Off_Off  ',$
    UNAME = 'reduce_tab1_pola_1',$
    /NO_RELEASE,$
    SENSITIVE = 1)
  button2 = WIDGET_BUTTON(Row4Base,$
    VALUE = 'Off_On  ',$
    UNAME = 'reduce_tab1_pola_2',$
    /NO_RELEASE,$
    SENSITIVE = 1)
  button3 = WIDGET_BUTTON(Row4Base,$
    VALUE = 'On_Off  ',$
    UNAME = 'reduce_tab1_pola_3',$
    /NO_RELEASE,$
    SENSITIVE = 1)
  button4 = WIDGET_BUTTON(Row4Base,$
    VALUE = 'On_On  ',$
    UNAME = 'reduce_tab1_pola_4',$
    /NO_RELEASE,$
    SENSITIVE = 1)
    
  ; NOTE (RC Ward, May 29, 2010) - These defaults are imbedded into the program
  ;WIDGET_CONTROL, Row4Base, SET_BUTTON=1 ;all spin states are selected by default
  WIDGET_CONTROL, button1, /SET_BUTTON
  WIDGET_CONTROL, button3, /SET_BUTTON
  
  ; Buttons for selecting the direct beam polarization states (Row #5) ---------------------------
  ; Change code (RC WARD, May 28, 2010): Modify the way that the direct beam polarization states are specied.
  
  ;new row
  ;  Row5 = WIDGET_BASE(Base,$
  ;    /COLUMN,$
  ;    /BASE_ALIGN_CENTER,$
  ;    MAP = map)
  ;  Row5_row1 = WIDGET_BASE(Row5,$
  ;    /ROW)
  ;
  Row5_row = WIDGET_BASE(Base,$
    UNAME = 'reduce_tab1_row5_base',$
    /ROW)
  ; shift the buttons over a bit
  space = WIDGET_LABEL(Row5_row, $
    VALUE='                          ')
    
  IF (instrument EQ 'REF_L') THEN BEGIN
    map = 0
  ENDIF ELSE BEGIN
    map = 1
  ENDELSE
  
  Row5 = WIDGET_BASE(Row5_row,$
    FRAME = 1,$
    MAP = map,$
    /ROW)
    
  label = WIDGET_LABEL(Row5,$
    VALUE = '  Direct Beam Polarization States: ')
    
  Row5Base = WIDGET_BASE(Row5,$
    /ROW, $
    /NONEXCLUSIVE)
    
  button5 = WIDGET_BUTTON(Row5Base,$
    VALUE = 'Off_Off  ',$
    UNAME = 'reduce_tab1_direct_pola_1',$
    /NO_RELEASE,$
    SENSITIVE = 1)
  button6 = WIDGET_BUTTON(Row5Base,$
    VALUE = 'Off_On  ',$
    UNAME = 'reduce_tab1_direct_pola_2',$
    /NO_RELEASE,$
    SENSITIVE = 1)
  button7 = WIDGET_BUTTON(Row5Base,$
    VALUE = 'On_Off  ',$
    UNAME = 'reduce_tab1_direct_pola_3',$
    /NO_RELEASE,$
    SENSITIVE = 1)
  button8 = WIDGET_BUTTON(Row5Base,$
    VALUE = 'On_On  ',$
    UNAME = 'reduce_tab1_direct_pola_4',$
    /NO_RELEASE,$
    SENSITIVE = 1)
  ; NOTE (RC Ward, May 29, 2010) - These defaults are imbedded into the program
  ;WIDGET_CONTROL, Row5Base, SET_BUTTON=1 ;all direct beam spin states are selected by default
  WIDGET_CONTROL, button5, /SET_BUTTON
  
;  space = WIDGET_LABEL(Row5_row1,$
;    VALUE = '                                           ')
  
;  label = WIDGET_LABEL(Row5_row1,$
;    FONT = "8X13",$
;    VALUE = 'Select the way you want to match the Data and Normalization' + $
;    ' Spin States')
  
;  Row5_row2 = WIDGET_BASE(Row5,$
;    /ROW,$
;    /BASE_ALIGN_CENTER)
  
;  big_space = WIDGET_LABEL(Row5_row2,$
;    VALUE = '                                               ')
  
; Code change (RC Ward, March 27, 2010): Images used for the buttons were simplified.
;match button
;  tooltip = 'Spin States of the Data and Normalization files are identical.'
;  match = WIDGET_DRAW(Row5_row2,$
;    SCR_XSIZE = 243,$
;    SCR_YSIZE = 47,$
;    /BUTTON_EVENTS,$
;    /MOTION_EVENTS,$
;    /TRACKING_EVENTS,$
;    TOOLTIP = tooltip,$
;    UNAME = 'reduce_step1_spin_match')
  
;  space_value = '   '
;  space = WIDGET_LABEL(Row5_row2,$
;    VALUE = space_value)
; Code change RCW (Dec 31, 2009): fix typos below
;do not match and fixed
;  tooltip = 'Spin State of Normalization files is fixed (Off_Off), no ' + $
;    'matter the spin state of the Data file.'
;  not_match = WIDGET_DRAW(Row5_row2,$
;    SCR_XSIZE = 245,$
;    SCR_YSIZE = 47,$
;    /BUTTON_EVENTS,$
;    /MOTION_EVENTS,$
;    /TRACKING_EVENTS,$
;    TOOLTIP = tooltip,$
;    UNAME = 'reduce_step1_spin_do_not_match_fixed')
  
;  space = WIDGET_LABEL(Row5_row2,$
;    VALUE = space_value)
;
;do not match and user defined
;  tooltip = 'Spin States of Data and Normalization files do not match and ' + $
;    'must be manually defined by the user.'
;  match = WIDGET_DRAW(Row5_row2,$
;    SCR_XSIZE = 245,$
;    SCR_YSIZE = 47,$
;    /BUTTON_EVENTS,$
;    /MOTION_EVENTS,$
;    /TRACKING_EVENTS,$
;    TOOLTIP = tooltip,$
;    UNAME = 'reduce_step1_spin_do_not_match_user_defined')
;
END
