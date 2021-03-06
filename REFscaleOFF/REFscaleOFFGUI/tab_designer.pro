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
    /tracking_events, $
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
    value = 'Off_Off',$
    sensitive = 0,$
    uname = 'tab1state1')
  spin2 = widget_button(row2col1,$
    value = 'Off_On',$
    sensitive = 0,$
    uname = 'tab1state2')
  spin3 = widget_button(row2col1,$
    value = 'On_Off',$
    sensitive = 0,$
    uname = 'tab1state3')
  spin4 = widget_button(row2col1,$
    value = 'On_On',$
    sensitive = 0,$
    uname = 'tab1state4')
    
  editable_table = [0,1,0]
  
  table = widget_table(row2,$
    uname = 'tab1_table',$
    xsize = 3,$
    ysize = 20,$
    column_labels = ['Files','SF','1st Px'],$
    /no_row_headers,$
    editable=editable_table,$
    /row_major,$
    /context_events,$
    column_widths = [690,80,50],$
    /all_events)
    
  ;context_menu
  contextBase = widget_base(table,$
    /context_menu,$
    uname = 'context_base')
  plot = widget_button(contextBase,$
    value = 'Plot file...',$
    uname = 'table_plot')
  preview = widget_button(contextBase,$
    value = 'Preview file...',$
    uname = 'table_preview')
  delete = widget_button(contextBase,$
    value = 'Delete file',$
    uname = 'table_delete',$
    /separator)
    
  row3 = widget_base(base1,$
    /align_right,$
    /row)
  mScale = widget_button(row3,$
  sensitive = 0,$
  uname = 'manual_scaling',$
  tooltip = 'Scale data according to SF defined in table',$
  value = ' MANUAL SCALING ')
  mScale = widget_button(row3,$
  sensitive = 0,$
  uname = 'manual_scaling_and_plot',$
  tooltip = 'Scale data using SF defined in table and plot data',$
  value = ' MANUAL SCALING and SHOW PLOT')
  space = widget_label(row3,$
    value = '   ')
  wScale = widget_button(row3,$
    sensitive = 0,$
    uname = 'automatic_scaling',$
    tooltip = 'Automatic scaling of data',$
    value = ' AUTO SCALING ')
  wScale = widget_button(row3,$
    sensitive = 0,$
    uname = 'automatic_scaling_and_plot',$
    tooltip = 'Automatic scaling and plot data',$
    value = ' AUTO SCALING and SHOW PLOT')
  space = widget_label(row3,$
    value = '     ')
  wPlot = widget_button(row3,$
    uname = 'show_plot',$
    sensitive = 0,$
    tooltip = 'Display scaled data',$
    value = ' SHOW SCALED DATA ')
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
    path = expand_path('~/results/')
  button = widget_button(row1,$
    value = path,$
    uname = 'output_path',$
    event_pro = 'output_path_event',$
    scr_xsize = 737)
    
  row2 = widget_base(base2,$
    /row)
  label = widget_label(row2,$
    value = 'Base File Name:')
  value = widget_text(row2,$
    value = 'N/A',$
    uname = 'output_base_file_name',$
    scr_xsize = 685,$
    /all_events,$
    /editable)
    
  space = widget_label(base2,$
    value = ' ')
    
  row3 = widget_base(base2,$
    /column)
  row3a = widget_base(row3,$
    /row,$
    /nonexclusive)
    rtof_ext = (*global).rtof_ext
  button1 = widget_button(row3a,$
    uname = '3_columns_ascii_button',$
    value = '3 columns ASCII     ' + rtof_ext)
  row3b = widget_base(row3,$
    /row,$
    /nonexclusive)
    excel_ext = (*global).excel_ext
;    widget_control, button1, /set_button
  button2 = widget_button(row3b,$
  uname = '2d_table_ascii_button',$
    value = '2D table            ' + excel_ext)
     widget_control, button2, /set_button
    
  row4 = widget_base(base2,$
    /row)
  row4a = widget_base(row4,$
    /row,$
    /nonexclusive)
  button3 = widget_button(row4a,$
    event_pro = 'send_by_email_button',$
    uname = 'send_by_email_button_uname',$
    value = 'Also send file(s) by email')
  row4b = widget_base(row4,$
  sensitive = 0,$
  uname = 'send_by_email_base_uname',$
    /row)
  email = widget_text(row4b,$
    value = '<your uname>',$
    xsize = 50,$
    uname = 'email_widget_text',$
    /editable)
    
  space = widget_label(base2,$
    value = ' ')
    
  row5 = widget_base(base2,$
    /align_center)
  create_output = widget_button(row5,$
  uname = 'create_output_button',$
  sensitive = 0,$
    value = 'CREATE OUTPUT',$
    scr_xsize = 700)
        
  space = widget_label(base2,$
    value = ' ')

  row6 = widget_base(base2,$
  uname = 'files_created_base_uname',$
  map = 0,$
  /row)
  label = widget_label(row6,$
  value = 'Files created:')
  text = widget_text(row6,$
  uname = 'list_of_files_created',$
  value = '',$
  xsize = 110,$
  /scroll,$
  ysize = 10)      
        
        
end
