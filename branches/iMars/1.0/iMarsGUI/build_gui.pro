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

;+
; :Description:
;    This builds the main interface
;
; :Params:
;    main_base
;
;
;
; :Author: j35
;-
pro build_gui, main_base
  compile_opt idl2
  
  ;main base is composed of 1 row and several columns (3)
  row = widget_base(main_base,$
    /row)
    
  ;col1 - col1 - col1 - col1 - col1 - col1 - col1 - col1 - col1 - col1 - col1
  ;first column starting from the left (browse for files)
  col1 = widget_base(row,$
    /column)
    
  space_value = '                                                         ' + $
  '                 '  
    
  ;first row
  row1 = widget_base(col1,$
    /row)
  label_base = widget_base(row1,$
    /row,$
    /align_bottom)
  label = widget_label(label_base,$
    value = 'Data files')
    
  space = widget_label(row1,$
    value = space_value)
    
  browse_base = widget_base(row1,$
    /row,$
    /align_bottom)
  browse = widget_button(browse_base,$
    value = 'Browse...',$
    uname = 'browse_data_files')
    
  ;second row
  row2 = widget_base(col1,$
    /row)
  data_table = widget_table(row2,$
    scr_xsize = 600,$
    scr_ysize = 200,$
    xsize = 1,$
    ysize = 30,$
    column_widths = 595,$
    uname = 'data_files_table',$
    /no_column_headers,$
    /no_row_headers)
    
  ;space
  space = widget_label(col1,$
    value = ' ')
    
  ;third row
  row1 = widget_base(col1,$
    /row)
  label_base = widget_base(row1,$
    /row,$
    /align_bottom)
  label = widget_label(label_base,$
    value = 'Open beam ')
    
  space = widget_label(row1,$
    value = space_value)
    
  browse_base = widget_base(row1,$
    /align_bottom,$
    /row)
  browse = widget_button(browse_base,$
    value = 'Browse...',$
    uname = 'browse_open_beam')
    
  ;4th row
  row2 = widget_base(col1,$
    /row)
  data_table = widget_table(row2,$
    scr_xsize = 600,$
    scr_ysize = 100,$
    xsize = 1,$
    ysize = 10,$
    column_widths = 595,$
    uname = 'open_beam_table',$
    /no_column_headers,$
    /no_row_headers)
    
 ;space
  space = widget_label(col1,$
    value = ' ')
    
  ;5th row
  row1 = widget_base(col1,$
    /row)
  label_base = widget_base(row1,$
    /row,$
    /align_bottom)
  label = widget_label(label_base,$
    value = 'Dark field')
    
  space = widget_label(row1,$
    value = space_value)
    
  browse_base = widget_base(row1,$
    /align_bottom,$
    /row)
  browse = widget_button(browse_base,$
    value = 'Browse...',$
    uname = 'browse_dark_field')
    
  ;6th row
  row2 = widget_base(col1,$
    /row)
  data_table = widget_table(row2,$
    scr_xsize = 600,$
    scr_ysize = 100,$
    xsize = 1,$
    ysize = 10,$
    column_widths = 595,$
    uname = 'dark_field_table',$
    /no_column_headers,$
    /no_row_headers)
    
     ;col2 - col2 - col2 - col2 - col2 - col2 - col2 - col2 - col2 - col2 - col2
  col1 = widget_draw(row,$
  scr_xsize = 5,$
  scr_ysize = 600)
    
    
    
    
    end
