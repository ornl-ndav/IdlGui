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
  
  ;****************************************************************************
  ;            DEFINE STRUCTURE
  ;****************************************************************************
  
  sBase = { size:  stab.size,$
    uname: 'reduce_step1_tab_base',$
    title: TabTitles.step1}
    
  ;****************************************************************************
  ;            BUILD GUI
  ;****************************************************************************
    
  TabBase = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = 'reduce_step1_top_base',$
    XOFFSET   = sBase.size[0],$
    YOFFSET   = sBase.size[1],$
    SCR_XSIZE = sBase.size[2],$
    SCR_YSIZE = sBase.size[3],$
    TITLE     = sBase.title,$
    map = 1)
    
  ;****************************************************************************
    
  SangleBaseEquation = WIDGET_BASE(TabBase, $
    UNAME = 'reduce_step1_sangle_base_equation', $
    XOFFSET   = 530, $
    YOFFSET   = 675, $
    SCR_XSIZE = 300, $
    SCR_YSIZE = 100, $
    map = 0)
    
  ;equation
  equation = WIDGET_DRAW(SangleBaseEquation,$
    UNAME = 'reduce_step1_sangle_equation',$
    XSIZE = 300,$
    YSIZE = 100)
    
  SangleBaseLabel = WIDGET_BASE(TabBase, $
    UNAME = 'reduce_step1_sangle_base_label', $
    XOFFSET = 15, $
    YOFFSET = 628, $
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
    
  table = WIDGET_TABLE(row1col1,$
    COLUMN_LABELS = ['Data Run #',$
    'Sangle [rad (deg)]'],$
    UNAME = 'reduce_sangle_tab_table_uname',$
    /NO_ROW_HEADERS,$
    ;    /RESIZEABLE_COLUMNS,$
    ALIGNMENT = 0,$
    XSIZE = 2,$
    YSIZE = 18,$
    SCR_XSIZE = 232,$
    SCR_YSIZE = 380,$
    COLUMN_WIDTHS = [105,148],$
    ;/SCROLL,$
    /ALL_EVENTS)
  WIDGET_CONTROL, table, SET_TABLE_SELECT=[0,0,1,0]
  
  reset_sangle = WIDGET_BUTTON(row1col1,$
    VALUE = 'Reset SANGLE value of selected run number',$
    UNAME = 'reduce_sangle_tab_reset_button',$
    SENSITIVE = 0)
    
  row1col2 = WIDGET_BASE(row1,$ ;............................
    UNAME = 'reduce_sangle_plot_base')
    
  label = WIDGET_LABEL(row1col2,$
    VALUE = 'Pixel vs TOF (microsS)', $
    UNAME = 'reduce_sangle_plot_title',$
    XOFFSET = 720,$
    YOFFSET = 35)
    
  plot = WIDGET_DRAW(row1col2,$
    UNAME = 'reduce_sangle_plot',$
    XOFFSET = 40,$
    YOFFSET = 5,$
    /TRACKING_EVENTS, $
    /MOTION_EVENTS, $
    /BUTTON_EVENTS, $
    XSIZE = (*global).sangle_xsize_draw,$
    YSIZE = (*global).sangle_ysize_draw)
    
  ;scale
  scale = WIDGET_DRAW(row1col2, $
    UNAME = 'reduce_sangle_y_scale', $
    XSIZE = (*global).sangle_xsize_draw + 55,$
    YSIZE = 2*304+30,$
    YOFFSET = 0)
    
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
  
  space = WIDGET_LABEL(row1col3Main, $
    VALUE = ' ')
    
  row1col3b = WIDGET_BASE(row1col3Main,$ ;..................................
    /COLUMN, $
    /EXCLUSIVE)
    
  button1 = WIDGET_BUTTON(row1col3b,$
    VALUE = 'Linear',$
    /NO_RELEASE, $
    UNAME = 'reduce_sangle_lin',$
    SENSITIVE = 1)
  button2 = WIDGET_BUTTON(row1col3b,$
    VALUE = 'Log',$
    /NO_RELEASE, $
    UNAME = 'reduce_sangle_log', $
    SENSITIVE = 1)
    
  WIDGET_CONTROL, button2, /SET_BUTTON
  
  space = WIDGET_LABEL(row1col3Main, $
    VALUE = ' ')
    
  ;live cursor info
  row1col3c = WIDGET_BASE(row1col3Main,$ ;..................................
    /COLUMN,$
    FRAME=1)
  title = WIDGET_LABEL(row1col3c,$
    VALUE = 'Live Infos')
    space = WIDGET_LABEL(row1col3c,$
    VALUE = '-------------')
  
  tof = WIDGET_LABEL(row1col3c,$
    VALUE = 'TOF (microS):',$
    /ALIGN_LEFT)
  value = WIDGET_LABEL(row1col3c,$
    VALUE = 'N/A',$
    SCR_XSIZE = 80,$
    UNAME = 'reduce_sangle_live_info_tof',$
    /ALIGN_LEFT)
  space = WIDGET_LABEL(row1col3c,$
    VALUE = '')
  tof = WIDGET_LABEL(row1col3c,$
    VALUE = 'Pixel:',$
    /ALIGN_LEFT)
  value = WIDGET_LABEL(row1col3c,$
    VALUE = 'N/A',$
    SCR_XSIZE = 80,$
    UNAME = 'reduce_sangle_live_info_pixel',$
    /ALIGN_LEFT)
    
  row2 = WIDGET_BASE(SangleBase, $ ;...........................
    /ROW)
    
  row2col1 = WIDGET_BASE(row2,$ ;.............................
    /COLUMN,$
    FRAME = 1)
    
  empty = WIDGET_LABEL(row2col1,$
    VALUE = '')
    
  rowa = WIDGET_BASE(row2col1,$
    /ROW)
  label = WIDGET_LABEL(rowa,$
    /ALIGN_LEFT, $
    VALUE = '          Full file name: ')
  value = WIDGET_LABEL(rowa,$
    VALUE = 'N/A',$
    /ALIGN_LEFT, $
    SCR_XSIZE = 500,$
    UNAME = 'reduce_sangle_base_full_file_name')
    
  rowb = WIDGET_BASE(row2col1,$
    /ROW)
  label = WIDGET_LABEL(rowb,$
    /ALIGN_LEFT, $
    VALUE = '      Dangle [rad (deg)]: ')
  value = WIDGET_LABEL(rowb,$
    VALUE = 'N/A',$
    /ALIGN_LEFT, $
    SCR_XSIZE = 200,$
    UNAME = 'reduce_sangle_base_dangle_value')
    
  rowbb = WIDGET_BASE(row2col1,$
    /ROW)
  label = WIDGET_LABEL(rowbb,$
    /ALIGN_LEFT, $
    VALUE = '     Dangle0 [rad (deg)]: ')
  value = WIDGET_LABEL(rowbb,$
    VALUE = 'N/A',$
    /ALIGN_LEFT, $
    SCR_XSIZE = 200,$
    UNAME = 'reduce_sangle_base_dangle0_value')
    
  rowc = WIDGET_BASE(row2col1,$
    /ROW)
  label = WIDGET_LABEL(rowc,$
    /ALIGN_LEFT, $
    VALUE = '      Sangle [rad (deg)]: ')
  value = WIDGET_LABEL(rowc,$
    VALUE = 'N/A',$
    /ALIGN_LEFT, $
    SCR_XSIZE = 200,$
    UNAME = 'reduce_sangle_base_sangle_value')
    
  rowd = WIDGET_BASE(row2col1,$
    /ROW)
  label = WIDGET_LABEL(rowd,$
    /ALIGN_LEFT, $
    VALUE = '                  Dirpix: ')
  value = WIDGET_LABEL(rowd,$
    VALUE = 'N/A',$
    /ALIGN_LEFT, $
    SCR_XSIZE = 100,$
    UNAME = 'reduce_sangle_base_dirpix_value')
    
  rowe = WIDGET_BASE(row2col1,$
    /ROW)
  label = WIDGET_LABEL(rowe,$
    /ALIGN_LEFT, $
    VALUE = '                  RefPix: ')
  value = WIDGET_LABEL(rowe,$
    /ALIGN_LEFT, $
    VALUE = 'N/A',$
    SCR_XSIZE = 100,$
    UNAME = 'reduce_sangle_base_refpix_value')
    
  rowf = WIDGET_BASE(row2col1,$
    /ROW)
  label = WIDGET_LABEL(rowf,$
    /ALIGN_LEFT, $
    VALUE = 'Sample-Det. distance [m]: ')
  value = WIDGET_LABEL(rowf,$
    /ALIGN_LEFT, $
    VALUE = 'N/A',$
    SCR_XSIZE = 100,$
    UNAME = 'reduce_sangle_base_sampledetdis_value')
    
  row2col2 = WIDGET_BASE(row2,$ ;.............................
    FRAME = 0)
    
  base1 = WIDGET_BASE(row2col2,$
    XOFFSET = 155,$
    YOFFSET = 40,$
    /ROW)
  label = WIDGET_LABEL(base1,$
    /ALIGN_LEFT,$
    VALUE = 'RefPix:')
  value = WIDGET_TEXT(base1,$
    VALUE = 'N/A',$
    UNAME = 'reduce_sangle_base_refpix_user_value',$
    /EDITABLE, $
    XSIZE = 10)
    space = WIDGET_LABEL(base1,$
    VALUE = '  ')
  label = WIDGET_LABEL(base1,$
    /ALIGN_LEFT,$
    VALUE = 'DirPix:')
  value = WIDGET_TEXT(base1,$
    VALUE = 'N/A',$
    UNAME = 'reduce_sangle_base_dirpix_user_value',$
    /EDITABLE, $
    XSIZE = 10)
    
  base2 = WIDGET_BASE(row2col2,$
    XOFFSET = 155,$
    YOFFSET = 110,$
    /ROW)
  label = WIDGET_LABEL(base2,$
    /ALIGN_LEFT,$
    VALUE = 'Sangle [rad (deg)]: ')
  value = WIDGET_LABEL(base2,$
    VALUE = 'N/A (N/A)',$
    UNAME = 'reduce_sangle_base_sangle_user_value',$
    SCR_XSIZE = 200,$
    /ALIGN_LEFT)
    
  done = WIDGET_BUTTON(row2col2,$
    VALUE = 'DONE WITH SANGLE CALCULATION',$
    UNAME = 'reduce_sangle_done_button',$
    YOFFSET = 165, $
    XOFFSET = 20, $
    SCR_XSIZE = 450)
    
  ;****************************************************************************
    
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
  
  tRun = CW_FIELD(Row1,$
    XSIZE = 40,$
    UNAME = 'reduce_tab1_run_cw_field',$
    TITLE = '',$
    VALUE = value,$
    /RETURN_EVENTS)
    
  label = WIDGET_LABEL(Row1,$
    VALUE = '(ex: 1245,1345-1347,1349)')
    
    
  ;label = WIDGET_LABEL(Row1,$
  ;                     VALUE = '     List of Proposal:')
  ;ComboBox = WIDGET_COMBOBOX(Row1,$
  ;                           VALUE = '                         ',$
  ;                           UNAME = 'reduce_tab1_list_of_proposal')
    
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
    YSIZE = 18,$
    SCR_XSIZE = 1230,$
    SCR_YSIZE = 400,$
    COLUMN_WIDTHS = [100,1110],$
    /SCROLL,$
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
    sangle_button = WIDGET_BUTTON(Row3,$
      VALUE = ' VIEW / EDIT SANGLE ',$
      UNAME = 'reduce_step1_sangle_button', $
      SENSITIVE = 0)
  ENDIF
  
  ;space
  space = WIDGET_LABEL(Base,$
    VALUE = ' ')
    
  ;Repeat work for other polarization states (Row #4) ---------------------------
  Row4_row = WIDGET_BASE(Base,$
    UNAME = 'reduce_tab1_row4_base',$
    /ROW)
    
  space = WIDGET_LABEL(Row4_row,$
    VALUE = '                                                      ')
    
  IF (instrument EQ 'REF_L') THEN BEGIN
    map = 0
  ENDIF ELSE BEGIN
    map = 1
  ENDELSE
  
  Row4 = WIDGET_BASE(Row4_row,$
    FRAME = 1,$
    MAP = map,$
    /ROW)
    
  ;  label = WIDGET_LABEL(Row4,$
  ;    VALUE = 'Working with Polarization State:')
  ;  label = WIDGET_LABEL(Row4,$
  ;    VALUE = 'N/A                     ',$q
  ;    /ALIGN_LEFT,$
  ;    UNAME = 'reduce_tab1_working_polarization_state_label',$
  ;    FRAME = 0)
    
  label = WIDGET_LABEL(Row4,$
    VALUE = 'Work with Following Polarization States:  ')
    
  Row4Base = WIDGET_BASE(Row4,$
    /ROW,$
    /BASE_ALIGN_TOP,$
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
    
  ;WIDGET_CONTROL, Row4Base, SET_BUTTON=1 ;all spin states are selected by default
  WIDGET_CONTROL, button1, /SET_BUTTON
  WIDGET_CONTROL, button3, /SET_BUTTON
  
  ;space base
  space = WIDGET_BASE(Base,$
    SCR_YSIZE = 50)
    
  ;new row
  Row5 = WIDGET_BASE(Base,$
    /COLUMN,$
    /BASE_ALIGN_CENTER,$
    MAP = map)
    
  Row5_row1 = WIDGET_BASE(Row5,$
    /ROW)
    
  space = WIDGET_LABEL(Row5_row1,$
    VALUE = '                                           ')
    
  label = WIDGET_LABEL(Row5_row1,$
    FONT = "8X13",$
    VALUE = 'Select the way you want to match the Data and Normalization' + $
    ' Spin States')
    
  Row5_row2 = WIDGET_BASE(Row5,$
    /ROW,$
    /BASE_ALIGN_CENTER)
    
  big_space = WIDGET_LABEL(Row5_row2,$
    VALUE = '                                               ')
    
  ;match button
  tooltip = 'Spin States of the Data and Normalization files are identical'
  match = WIDGET_DRAW(Row5_row2,$
    SCR_XSIZE = 200,$
    SCR_YSIZE = 109,$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS,$
    /TRACKING_EVENTS,$
    TOOLTIP = tooltip,$
    UNAME = 'reduce_step1_spin_match')
    
  space_value = '   '
  space = WIDGET_LABEL(Row5_row2,$
    VALUE = space_value)
    
  ;do not match and fixed
  tooltip = 'Spin State of Normalization files if fixed (Off_Off), no ' + $
    'matter the spin state of the Data file.'
  not_match = WIDGET_DRAW(Row5_row2,$
    SCR_XSIZE = 200,$
    SCR_YSIZE = 109,$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS,$
    /TRACKING_EVENTS,$
    TOOLTIP = tooltip,$
    UNAME = 'reduce_step1_spin_do_not_match_fixed')
    
  space = WIDGET_LABEL(Row5_row2,$
    VALUE = space_value)
    
  ;do not match and user defined
  tooltip = 'Spin States of Data and Normalization files do not match and ' + $
    'can will be manually defined by the user'
  match = WIDGET_DRAW(Row5_row2,$
    SCR_XSIZE = 200,$
    SCR_YSIZE = 109,$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS,$
    /TRACKING_EVENTS,$
    TOOLTIP = tooltip,$
    UNAME = 'reduce_step1_spin_do_not_match_user_defined')
    
END
