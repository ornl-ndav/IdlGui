;===============================================================================
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
;===============================================================================

pro design_tabs, MAIN_BASE, global
  compile_opt idl2
  
  tabs = widget_tab(MAIN_BASE,$
  uname = 'tab_uname')
  
  base1 = widget_base(tabs,$
    title = 'LOAD and SCALE',$
    /column)
    
  ;TAB1 ===========================================
    
  row1 = widget_base(base1,$
    /row)
  label = widget_label(row1,$
    value = 'Laod Files:')
  button = widget_button(row1,$
    value = 'BROWSE...',$
    event_pro = 'load_files_button',$
    scr_xsize = 100,$
    tooltip='Browse for reduced or batch files.')
    
  row2 = widget_base(base1,$
    /row)
  row2col1 = widget_base(row2,$
    /column)
  spin1 = widget_button(row2col1,$
    value = 'State 1',$
    sensitive = 0,$
    uname = 'tab1state1')
  spin2 = widget_button(row2col1,$
    value = 'State 2',$
    sensitive = 0,$
    uname = 'tab1state2')
  spin3 = widget_button(row2col1,$
    value = 'State 3',$
    sensitive = 0,$
    uname = 'tab1state3')
  spin4 = widget_button(row2col1,$
    value = 'State 4',$
    sensitive = 0,$
    uname = 'tab1state4')
  
  editable_table = indgen(2*20) MOD 2
  
  table = widget_table(row2,$
    uname = 'tab1_table',$
    xsize = 2,$
    ysize = 20,$
    column_labels = ['Files','SF'],$
    /no_row_headers,$
    editable=editable_table,$
    /row_major,$
    column_widths = [450,50],$
    /all_events)
    
  row3 = widget_base(base1,$
    /align_right,$
    /row)
  wScale = widget_button(row3,$
  value = ' AUTOMATIC SCALING ')
  wPlot = widget_button(row3,$
    value = ' SHOW PLOT ')
    space = widget_label(row3,$
    value = '  ')
    
  ;TAB2 =========================================
    
  base2 = widget_base(tabs,$
    title = 'OUTPUT',$
    /column)
    
  row1 = widget_base(base2,$
  /row)
  label = widget_label(row1,$
  value = 'Where:')
  button = widget_button(row1,$
  value = '~/results',$
  scr_xsize = 537)
  
  row2 = widget_base(base2,$
  /row)
  label = widget_label(row2,$
  value = 'Base File Name:')
  value = widget_text(row2,$
  value = 'N/A',$
  scr_xsize = 485,$
  /editable)
    
    space = widget_label(base2,$
    value = ' ')

  row3 = widget_base(base2,$
  /column)
    row3a = widget_base(row3,$
  /row,$
  /nonexclusive)
  button1 = widget_button(row3a,$
  value = '3 columns ASCII')
  row3b = widget_base(row3,$
  /row,$
  /nonexclusive)
  button2 = widget_button(row3b,$
  value = '2D table')
  
  row4 = widget_base(base2,$
  /row)
  row4a = widget_base(row4,$
  /row,$
  /nonexclusive)
  button3 = widget_button(row4a,$
  value = 'Also send file(s) by email')
  row4b = widget_base(row4,$
  /row)
  email = widget_text(row4b,$
  value = '',$
  xsize = 50,$
  /editable)
    
    space = widget_label(base2,$
    value = ' ')
    space = widget_label(base2,$
    value = ' ')
    
  row5 = widget_base(base2,$
  /align_center)
  create_output = widget_button(row5,$
  value = 'CREATE OUTPUT',$
  scr_xsize = 500)  
    
    
    
    

    
end
