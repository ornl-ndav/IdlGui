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

PRO make_gui_Reduce_step2, REDUCE_TAB, sTab, TabTitles, global

  ;******************************************************************************
  ;            DEFINE STRUCTURE
  ;******************************************************************************

  sBase = { size:  stab.size,$
    uname: 'reduce_step2_tab_base',$
    title: TabTitles.step2}
    
  ;******************************************************************************
  ;            BUILD GUI
  ;******************************************************************************
    
  Base = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = sBase.uname,$
    XOFFSET   = sBase.size[0],$
    YOFFSET   = sBase.size[1],$
    SCR_XSIZE = sBase.size[2],$
    SCR_YSIZE = sBase.size[3],$
    TITLE     = sBase.title)
    
  xoff = 30
  
  ;title of normalization input frame
  label = WIDGET_LABEL(Base,$
    XOFFSET = xoff,$
    YOFFSET = 5,$
    VALUE = 'Normalization File Input')
    
    x_norm = 720
  hidden_base = widget_base(Base,$
    xoffset = x_norm+xoff,$
    yoffset = 5,$
    map = 1,$
    frame = 0,$
    xsize = 130,$
    ysize = 15,$
    uname = 'reduce_step2_list_of_normalization_file_hidden_base')
    
  ;title of list of normaliation file
  label = WIDGET_LABEL(Base,$
    XOFFSET = x_norm+xoff,$
    YOFFSET = 5,$
    VALUE = 'Normalization Files')

  hidden_base = widget_base(Base,$
    xoffset = 845+xoff,$
    yoffset = 5,$
    map = 1,$
    frame = 0,$
    xsize = 130,$
    ysize = 15,$
    uname = 'reduce_step2_polarization_mode_hidden_base')
    
  ;title of normalization input frame
  label = WIDGET_LABEL(Base,$
    XOFFSET = 870+xoff,$
    YOFFSET = 5,$
    VALUE = 'Polarization Mode')

;##############################################################################    
  ;first Row
  main_row1 = WIDGET_BASE(Base,$
    XOFFSET = 0,$
    YOFFSET = 20,$
    /ROW)
    
  ;space
  space = WIDGET_LABEL(main_row1,$
    VALUE = '   ')
    
  ;Loand normalization
  base_row1 = WIDGET_BASE(main_row1,$
    /ROW,$
    SCR_YSIZE = 150,$
    FRAME = 5)
    
  col1 = WIDGET_BASE(base_row1,$
    /COLUMN)
    
  value = WIDGET_LABEL(col1,$
    VALUE = '')
    
  value = WIDGET_LABEL(col1,$
    VALUE = '')
    
  browse_button = WIDGET_BUTTON(col1,$
    UNAME = 'reduce_step2_browse_button',$
    VALUE = 'BROWSE ...')
    
  value = WIDGET_LABEL(col1,$
    VALUE = '')
    
  value = WIDGET_LABEL(col1,$
    VALUE = 'OR')
    
  value = WIDGET_LABEL(col1,$
    VALUE = '')
    
  row2 = WIDGET_BASE(col1,$
    /ROW)
    
  value = WIDGET_LABEL(row2,$
    VALUE = 'Run(s) #:')
    
  text = WIDGET_TEXT(row2,$
    VALUE = '',$
    UNAME = 'reduce_step2_normalization_text_field',$
    XSIZE = 20)
    
  value = WIDGET_LABEL(row2,$
    VALUE = '(ex: 1245,1345-1347,1349)')
    
  label = WIDGET_LABEL(row2,$
    VALUE = '     List of Proposal:')
  ComboBox = WIDGET_COMBOBOX(Row2,$
    VALUE = '                         ',$
    UNAME = 'reduce_tab1_list_of_proposal')
    
  ;;space between base of first row
  ;space = WIDGET_LABEL(main_row1,$
  ;  VALUE = '      ')
    
  ;list of normalization file loaded base ------------------------------------
  list_norm_base = WIDGET_BASE(main_row1,$
    uname = 'reduce_step2_list_of_norm_files_base',$
    ;    scr_xsize = 200,$
    /column,$
    map=0,$
    FRAME=5)

  table = widget_table(list_norm_base,$
    scr_xsize = 65,$
    xsize = 1,$
    ysize = 11,$
    scr_ysize = 120,$
    column_widths = 110,$
    /no_headers,$
    /no_row_headers,$
    ;   /scroll,$
    uname = 'reduce_step2_list_of_norm_files_table')
    
  button = widget_button(list_norm_base,$
    value = 'Remove Selected File',$
    uname = 'reduce_step2_list_of_norm_files_remove_button')
    
  ;Polarization buttons/base --------------------------------------------------
  col2 = WIDGET_BASE(main_row1,$
    FRAME = 5,$
    uname = 'reduce_step2_polarization_base',$
    map = 0,$
    /ROW)
    
  col2_col1 = widget_base(col2,$
    /column)
    
  button1 = WIDGET_DRAW(col2_col1,$
    uname = 'reduce_step2_polarization_mode1_draw',$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS,$
    /TRACKING_EVENTS,$
    SCR_XSIZE = 150,$
    SCR_YSIZE = 109)
    
  ;base of the spin state combobox
  base_combo = widget_base(col2_col1,$
    /ALIGN_CENTER,$
    uname = 'reduce_step2_spin_state_combobox_base',$
    /ROW)
    
  spinStates = WIDGET_COMBOBOX(base_combo,$
    value = ['Off-Off','Off-On','On-Off','On-On'],$
    uname = 'reduce_step2_mode1_spin_state_combobox')
    
  space = WIDGET_LABEL(col2,$
    VALUE = '')
    
  button2 = WIDGET_DRAW(col2,$
    uname = 'reduce_step2_polarization_mode2_draw',$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS,$
    /TRACKING_EVENTS,$
    SCR_XSIZE = 150,$
    SCR_YSIZE = 109)
    
  ;-------------------------------------------------------------------------------
  xyoff = [8,210]
  sLabel = { size: [XYoff[0],$
    XYoff[1]],$
    value: 'Data Run #     Normalization       Spin State            ' + $
    '             Region Of Intereset (ROI)'}
    
  label_base = widget_base(Base,$
    xoffset = sLabel.size[0],$
    yoffset = slabel.size[1],$
    scr_xsize = 600,$
    scr_ysize = 30,$
    map = 0,$
    uname = 'reduce_step2_label_table_base')
    
  label = WIDGET_LABEL(label_base,$
    XOFFSET = 0,$
    YOFFSET = 0,$
    VALUE   = sLabel.value)
    
  offset = 35
  xoff = 50
  yoff = offset + sLabel.size[1]
  label_offset = 4
  FOR i=0,10 DO BEGIN
  
    uname = 'reduce_tab2_data_recap_base_#' + strcompress(i)
    row_base = WIDGET_BASE(Base,$
      uname = uname,$
      xoffset = XYoff[0],$
      yoffset = yoff,$
      scr_ysize = 30,$
      scr_xsize = 1250,$
      map = 0,$
      frame = 0)
      
    uname = 'reduce_tab2_data_value' + STRCOMPRESS(i)
    value1 = WIDGET_LABEL(row_Base,$
      value   = '1345',$
      xoffset = 0,$
      yoffset = label_offset,$
      SCR_XSIZE = 50,$
      uname   = uname)
      
    uname = 'reduce_tab2_norm_base'
    combo_base = WIDGET_BASE(row_Base,$
      XOFFSET = xyoff[0]+65,$
      YOFFSET = 0,$
      uname = uname+ strcompress(i),$
      map = 1)
      
    uname = 'reduce_tab2_norm_combo'
    combo = widget_combobox(combo_base,$
      value = ['1500','1501','1502'],$
      uname = uname + strcompress(i))
      
    uname = 'reduce_tab2_norm_value' + STRCOMPRESS(i)
    value2 = WIDGET_LABEL(row_Base,$
      XOFFSET = XYoff[0]+100,$
      YOFFSET = label_offset,$
      /align_left,$
      value = '1500',$
      SCR_XSIZE = 50,$
      uname = uname)
      
    ;spin state widget_base and widget_combobox
    uname = 'reduce_tab2_spin_combo_base'
    combo_base = WIDGET_BASE(row_Base,$
      XOFFSET = XYoff[0]+180,$
      YOFFSET = 0,$
      uname = uname+ strcompress(i),$
      map = 0)
      
    uname = 'reduce_tab2_spin_combo'
    combo = widget_combobox(combo_base,$
      value = ['Off-Off','Off-On','On-Off','On-On'],$
      uname = uname + strcompress(i))
      
    ;spin state widget_label
    uname = 'reduce_tab2_spin_value' + strcompress(i)
    spin = WIDGET_LABEL(row_Base,$
      XOFFSET = XYoff[0]+210,$
      YOFFSET = label_offset,$
      SCR_XSIZE = 50,$
      value = 'Off-Off',$
      /align_left,$
      uname = uname)
      
    ;roi widgets
    ;Browse button
    uname = 'reduce_tab2_roi_browse_button' + strcompress(i)
    browse = WIDGET_BUTTON(row_base,$
      Xoffset = xyoff[0]+310,$
      yoffset = 0,$
      scr_xsize = 180,$
      value = 'Browse for a ROI file ...',$
      uname = uname)
      
    ;Create/modify ROI
    uname = 'reduce_tab2_roi_modify_button' + strcompress(i)
    modify = widget_button(row_base,$
      xoffset = xyoff[0]+500,$
      yoffset = 0,$
      uname = uname,$
      scr_xsize = 230,$
      value = 'Create/Modify/Visualize ROI file')
      
    uname = 'reduce_tab2_roi_value' + strcompress(i)
    roi = widget_label(row_Base,$
      XOFFSET = XYoff[0]+740,$
      YOFFSET = label_offset,$
      SCR_XSIZE = 490,$
      /ALIGN_LEFT,$
      frame=0,$
      value = '',$
      uname = uname)
      
    yoff += offset
  ENDFOR
  
  
  
  
  
  
  
  
  
  
  
  
  
END
