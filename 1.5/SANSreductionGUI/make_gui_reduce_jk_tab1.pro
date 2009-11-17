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

PRO make_gui_reduce_jk_tab1, REDUCE_TAB, tab_size, tab_title

  ;= Build Widgets ==============================================================
  BaseTab = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = 'reduce_jk_tab1_base_uname',$
    XOFFSET   = tab_size[0],$
    YOFFSET   = tab_size[1],$
    SCR_XSIZE = tab_size[2],$
    SCR_YSIZE = tab_size[3],$
    TITLE     = tab_title)
    
  xoff1 = 425
  yoff1 = 55
  event_label = WIDGET_LABEL(BaseTab,$
    XOFFSET = xoff1,$
    YOFFSET = yoff1,$
    VALUE = 'Event File')
    
  yoff2 = yoff1 + 77
  monitor_label = WIDGET_LABEL(BaseTab,$
    XOFFSET = xoff1,$
    YOFFSET = yoff2,$
    VALUE = 'Monitor File')
    
  base = WIDGET_BASE(BaseTab,$
    /BASE_ALIGN_CENTER,$
    SCR_XSIZE = tab_size[2],$
    /COLUMN)
    
  ;row1
  row1 = WIDGET_BASE(base,$
    /ROW,$
    /EXCLUSIVE)
  button1 = WIDGET_BUTTON(row1,$
    VALUE = 'SAMPLE',$
    UNAME = 'reduce_jk_tab1_sample_button')
  button2 = WIDGET_BUTTON(row1,$
    VALUE = 'BUFFER',$
    UNAME = 'reduce_jk_tab1_buffer_button')
  button3 = WIDGET_BUTTON(row1,$
    VALUE = 'BACKGROUND',$
    UNAME = 'reduce_jk_tab1_background_button')
  WIDGET_CONTROL, button1, /SET_BUTTON
  
  space = WIDGET_LABEL(base,$
    VALUE = ' ')
    
  rowa = WIDGET_BASE(base,$
  /ROW)
  
  col1 = WIDGET_BASE(rowa, $
  /ALIGN_CENTER,$
      /COLUMN)
    
  row2 = WIDGET_BASE(col1,$
    /ROW,$
    /BASE_ALIGN_CENTER)
  label = WIDGET_LABEL(row2,$
    VALUE = 'Run number:')
  
  value = WIDGET_TEXT(row2,$
    VALUE = '',$
    XSIZE = 5,$
    YSIZE = 1,$
    /EDITABLE,$
    /ALL_EVENTS,$
    UNAME = 'reduce_jk_tab1_run_number')
    
  space = WIDGET_LABEL(col1,$
  VALUE = ' ')  
    
  button = WIDGET_BUTTON(col1,$
    UNAME = 'reduce_jk_tab1_get_run_information',$
    SENSITIVE = 0,$
    VALUE = 'GET RUN INFORMATION')
    
  label = WIDGET_LABEL(rowa,$
    VALUE = '     OR     ')
    
  row2_col2 = WIDGET_BASE(rowa,$
    /COLUMN)
  row2_col2_row1 = WIDGET_BASE(row2_col2,$
    /COLUMN,$
    FRAME=1)
  row2_col2_row1_row1 = WIDGET_LABEL(row2_col2_row1,$
    VALUE='')
  row2_col2_row1_row2 = WIDGET_BASE(row2_col2_row1,$
    /ROW)
  button = WIDGET_BUTTON(row2_col2_row1_row2,$
    VALUE = 'BROWSE ...')
  text = WIDGET_TEXT(row2_col2_row1_row2,$
    VALUE = '',$
    XSIZE = 50)
    
  space = WIDGET_LABEL(row2_col2,$
    VALUE = ' ')
    
  row2_col2_row2 = WIDGET_BASE(row2_col2,$
    /COLUMN,$
    FRAME=1)
  row2_col2_row2_row1 = WIDGET_LABEL(row2_col2_row2,$
    VALUE='')
  row2_col2_row2_row2 = WIDGET_BASE(row2_col2_row2,$
    /ROW)
  button = WIDGET_BUTTON(row2_col2_row2_row2,$
    VALUE = 'BROWSE ...')
  text = WIDGET_TEXT(row2_col2_row2_row2,$
    VALUE = '',$
    XSIZE = 50)
    
  space = WIDGET_LABEL(base,$
  VALUE = ' ')  

    ;text box that will display run information
    text = WIDGET_TEXT(base,$
    VALUE = '',$
    UNAME = 'reduce_jk_tab1_run_information_text',$
    XSIZE = 140,$
    YSIZE = 32)
    
END
