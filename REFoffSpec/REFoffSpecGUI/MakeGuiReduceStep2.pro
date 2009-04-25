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
    
  xoff = 40
  
  ;title of normalization input frame
  label = WIDGET_LABEL(Base,$
    XOFFSET = 30+xoff,$
    YOFFSET = 5,$
    VALUE = 'Normalization File Input')
    
  ;title of normalization input frame
  label = WIDGET_LABEL(Base,$
    XOFFSET = 780+xoff,$
    YOFFSET = 5,$
    VALUE = 'Polarization Mode')
    
  ;first Row
  main_row1 = WIDGET_BASE(Base,$
    XOFFSET = 10,$
    YOFFSET = 20,$
    /ROW)
    
  ;space
  space = WIDGET_LABEL(main_row1,$
    VALUE = '      ')
    
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
    
  ;space between base of first row
  space = WIDGET_LABEL(main_row1,$
    VALUE = '      ')
    
  ;Polarization buttons/base
  col2 = WIDGET_BASE(main_row1,$
    FRAME = 5,$
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
    uname = 'reduce_step2_spin_state_combobox')
    
  space = WIDGET_LABEL(col2,$
    VALUE = '')
    
  button2 = WIDGET_DRAW(col2,$
    uname = 'reduce_step2_polarization_mode2_draw',$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS,$
    /TRACKING_EVENTS,$
    SCR_XSIZE = 150,$
    SCR_YSIZE = 109)
    
  ;Data/Normalization/Spin state -------------------------------------------
  xyoff = [50,210]
  sLabel = { size: [XYoff[0],$
    XYoff[1]],$
    value: 'Data Run #       Normalization       Spin State            ROI'}
    
  label = WIDGET_LABEL(Base,$
    XOFFSET = sLabel.size[0],$
    YOFFSET = sLabel.size[1],$
    VALUE   = sLabel.value)
    
  offset = 35
  yoff = offset + sLabel.size[1]
  for i=0,10 do begin
    uname = 'reduce_tab2_data_value' + STRCOMPRESS(i)
    
    value1 = WIDGET_LABEL(Base,$
      XOFFSET = XYoff[0],$
      YOFFSET = yoff,$
      value   = '1345',$
      SCR_XSIZE = 50,$
      uname   = uname)
      
    uname = 'reduce_tab2_norm_value' + STRCOMPRESS(i)
    value2 = WIDGET_LABEL(Base,$
      XOFFSET = XYoff[0]+115,$
      YOFFSET = yoff,$
      value = '1500',$
      SCR_XSIZE = 50,$
      uname = uname)
      
      ;spin state widget_base and widget_combobox
    uname = 'reduce_tab2_spin_combo_base'
    combo_base = WIDGET_BASE(Base,$
    XOFFSET = XYoff[0]+205,$
    YOFFSET = yoff,$
    uname = uname+ strcompress(i),$
    map = 1)
    
    uname = 'reduce_tab2_spin_combo'
    combo = widget_combobox(combo_base,$
    value = ['Off-Off','Off-On','On-Off','On-On'],$
    uname = uname + strcompress(i))
      
      ;spin state widget_label
    uname = 'reduce_tab2_spin_value' + strcompress(i)
    spin = WIDGET_LABEL(Base,$
      XOFFSET = XYoff[0]+225,$
      YOFFSET = yoff,$
      SCR_XSIZE = 50,$
      value = 'Off-Off',$
      uname = uname)
      
    uname = 'reduce_tab2_roi_value' + strcompress(i)
    roi = widget_label(Base,$
      XOFFSET = XYoff[0]+330,$
      YOFFSET = yoff,$
      SCR_XSIZE = 300,$
      /ALIGN_LEFT,$
      value = '/SNS/REFfdfdfdfdfdfdfdfdfdfdfdfffdfdfdfdfdfsadfdfafdfadfadfdafdsafdasfadsfadsfasdfasf',$
      uname = uname)
      
    yoff += offset
  ENDFOR
  
  
  
  
  
  
  
  
  
  
  
  
  
END
