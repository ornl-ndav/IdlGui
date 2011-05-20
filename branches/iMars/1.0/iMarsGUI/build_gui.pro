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
    ysize = 1,$
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
    ysize = 1,$
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
    ysize = 1,$
    column_widths = 595,$
    uname = 'dark_field_table',$
    /no_column_headers,$
    /no_row_headers)
    
  ;col2 - col2 - col2 - col2 - col2 - col2 - col2 - col2 - col2 - col2 - col2
  col2 = widget_draw(row,$
    scr_xsize = 5,$
    scr_ysize = 600)
    
  ;col3 - col3 - col3 - col3 - col3 - col3 - col3 - col3 - col3 - col3 - col3
  col3 = widget_base(row,$
    /column)
    
  row1 = widget_base(col3,$
    /row)
    
  preview_base = widget_base(row1)
  
  label = widget_label(preview_base,$
    xoffset = 10,$
    yoffset = 6,$
    value = 'Preview')
    
  in_preview_base = widget_base(preview_base,$
    xoffset = 5,$
    yoffset = 15,$
    frame=1,$
    /column)
    
  file = widget_label(in_preview_base,$
    value = 'N/A',$
    /align_left,$
    scr_xsize = 300)
    
  draw = widget_draw(in_preview_base,$
    scr_xsize = 300,$
    scr_ysize = 250,$
    uname = 'preview_draw_uname')
    
  bottom_base = widget_base(in_preview_base,$
    /row)
  gamma_base = widget_base(bottom_base,$
    /nonexclusive)
  button = widget_button(gamma_base,$
    value = 'With gamma filtering',$
    uname = 'with_gamma_filtering_uname')
  space = widget_label(bottom_base,$
    value = '                  ')
  enlarge = widget_draw(bottom_base,$
    scr_xsize=25,$
    scr_ysize=25)
    
  roi_base = widget_base(row1,$
    /column)
  label = widget_label(roi_base,$
    value='Selection: xmin,ymin,xmax,ymax')
  _row = widget_base(roi_base,$
    /row)
  roi = widget_text(_row,$
    xsize = 20,$
    ysize = 8)
  _col = widget_base(_row,$
    /column)
  load = widget_button(_col,$
    value = 'Load...',$
    uname = 'roi_load')
  for i=0,5 do begin
    space = widget_label(_col,$
      value = ' ')
  endfor
  save = widget_button(_col,$
    value = 'Save...',$
    uname='roi_save')
    
  ;space in col3
  for i=0,3 do begin
    space = widget_label(col3,$
      value = ' ')
  endfor
  
  ;output folder row
  of_row = widget_base(col3,$
    /row)
  label = widget_label(of_row,$
    value = 'Output folder:')
  button = widget_button(of_row,$
    value = '~/',$
    scr_xsize = 440,$
    uname = 'output_folder_button')
    
  ;format row
  f_row = widget_base(col3,$
    /row)
  label = widget_label(f_row,$
    value = 'Format(s):    ')
  format_base = widget_base(f_row,$
    /row,$
    /nonexclusive)
  b1 = widget_button(format_base,$
    value ='TIFF (.tif)',$
    uname = 'format_tiff_button')
  b2 = widget_button(format_base,$
    value = 'FITS (.fits)',$
    uname = 'format_fits_button')
  b3 = widget_button(format_base,$
    value = 'PNG (.png)',$
    uname = 'format_png_button')
  widget_control, b2, /set_button
  
  ;space
  space = widget_label(col3,$
    value = ' ')
    
  ;run reduction button
  reduction = widget_button(col3,$
    value = 'Run normalization',$
    sensitive = 0,$
    uname = 'run_normalization_button')
    
  ;progress bar
  pro_base = widget_base(col3,$
  map=0,$
    /row)
  draw = widget_draw(pro_base,$
    scr_xsize = 535,$
    scr_ysize = 25,$
    uname = 'progress_bar')
    
end