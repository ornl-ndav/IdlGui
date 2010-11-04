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
  
  bFindnexus = (*global).bFindnexus
  
  tabs = widget_tab(MAIN_BASE,$
    /tracking_events, $
    uname = 'tab_uname')
    
  ;********* tab 1 *****************
  base1 = widget_base(tabs,$
    title = 'LOAD AND RUN')
    
  _base1 = widget_base(base1,$
    /column)
    
  data_box = widget_base(_base1,$
    frame = 1,$
    /align_center,$
    /base_align_center,$
    /column)
    
  ;display those widgets if findnexus is in the path
  if (bFindnexus) then begin
  
    row1 = widget_base(data_box,/row)
    label = widget_label(row1,$
      value = 'Data run numbers:')
    text = widget_text(row1,$
      value = '',$
      /editable,$
      uname = 'data_run_numbers_text_field',$
      xsize = 100)
    ex = widget_label(row1,$
      value = '(ex: 200,2004-2006)')
      
    row2 = widget_label(data_box,$
      value = 'OR')
      
  endif
  
  row3 = widget_button(data_box,$
    value = 'Browse for data NeXus files ...',$
    uname = 'data_browse_button',$
    scr_xsize = 575)
    
  ;SPACE
  space = widget_label(_base1,$
    value = ' ')
    
  ;NORMALIZATION
  norm_box = widget_base(_base1,$
    frame = 1,$
    /align_center,$
    /base_align_center,$
    /row)
    
  ;display those widgets if findnexus is in the path
  if (bFindnexus) then begin
  
    norm = cw_field(norm_box, $
    value = '',$
    xsize = 8,$
    title = 'Normalization run number:',$
    /row,$
    uname = 'norm_run_number_text_field',$
    /return_events,$
    /integer)
      
    or_label = widget_label(norm_box,$
      value = '  OR  ')
      
  endif
  
  button = widget_button(norm_box,$
    uname = 'norm_browse_button',$
    value = 'Browse for a normalization NeXus file ...',$
    scr_xsize = 575)
    
  ;SPACE
  space = widget_label(_base1,$
    value = ' ')
    
  ;PARAMETERS
  para_box = widget_base(_base1,$
    frame = 1,$
    /base_align_center,$
    /column)
    
  row1 = widget_base(para_box,$
    /row)
  row1col1 = widget_base(row1,$
    /column)
    
  field1 = cw_field(row1col1,$
    /integer,$
    xsize = 6,$
    value = '500',$
    uname = 'bins_qx',$
    title = 'Bins:  Qx')
  field2 = cw_field(row1col1,$
    xsize = 6,$
    /integer,$
    value = '500',$
    uname = 'bins_qz',$
    title = '       Qz')
    
  space = widget_label(row1,$
    value = '              ')
    
  row1col2 = widget_base(row1,$
    /column)
  field1 = cw_field(row1col2,$
    /floating,$
    xsize = 8,$
    uname = 'ranges_qx_min',$
    value = '-0.004',$
    title = 'Ranges:  Qx')
  field2 = cw_field(row1col2,$
    xsize = 8,$
    /floating,$
    value = '-0.004',$
    uname = 'ranges_qz_min',$
    title = '         Qz')
  field3 = cw_field(row1col2,$
    xsize = 8,$
    /floating,$
    value = '9.75',$
    uname = 'tof_min',$
    title = '   TOF (ms)')
    
  row1col3 = widget_base(row1,$
    /column)
  field1 = cw_field(row1col3,$
    /floating,$
    xsize = 8,$
    uname = 'ranges_qx_max',$
    value = '0.004',$
    title = 'to  ')
  field2 = cw_field(row1col3,$
    xsize = 8,$
    /floating,$
    uname = 'ranges_qz_max',$
    value = '0.004',$
    title = 'to  ')
  field3 = cw_field(row1col3,$
    xsize = 8,$
    /floating,$
    uname = 'tof_max',$
    value = '22.0',$
    title = 'to  ')
    
  space = widget_label(row1,$
    value = '              ')
    
  row1col4 = widget_base(row1,$
    /column)
  field1 = cw_field(row1col4,$
    /floating,$
    xsize = 8,$
    value = '133',$
    uname = 'center_pixel',$
    title = '   Center pixel')
  field2 = cw_field(row1col4,$
    xsize = 8,$
    /floating,$
    value = '0.7',$
    uname = 'pixel_size',$
    title = 'Pixel size (mm)')
    
  row2 = widget_base(para_box,$
    /align_left,$
    /row)
  row2col1 = widget_base(row2,$
    /column)
    
  field1 = cw_field(row2col1,$
    /integer,$
    xsize = 3,$
    value = '102',$
    uname = 'pixel_min',$
    title = 'Pixels:   min')
  field2 = cw_field(row2col1,$
    xsize = 3,$
    /integer,$
    value = '165',$
    uname = 'pixel_max',$
    title = '          max')
    
  space = widget_label(row2,$
    value = '              ')
    
  row2col2 = widget_base(row2,$
    /column)
  field1 = cw_field(row2col2,$
    /floating,$
    xsize = 10,$
    value = '1430.0',$
    uname = 'd_sd_uname',$
    title = '   Distance sample to detector (mm) ')
  field2 = cw_field(row2col2,$
    xsize = 10,$
    /floating,$
    value = '14910.',$
    uname = 'd_md_uname',$
    title = 'Distance moderator to detector (mm) ')
    
  ;progress bar and go button
  bottom_box = widget_base(_base1,$
    /align_center,$
    /row)
    
  progress_base = widget_base(bottom_box,$
    map = 0)
  progress_bar = widget_draw(progress_base,$
    scr_xsize = 400,$
    scr_ysize = 25)
    
  space = widget_label(bottom_box,$
    value = '                     ')
    
  ok = widget_button(bottom_box,$
    value = '>   >  > >> G O << <  <   <')
    
end
