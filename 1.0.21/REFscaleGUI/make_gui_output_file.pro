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

PRO MakeGuiOutputFile, STEPS_TAB, global

  output_base = widget_base(steps_tab,$
    uname = 'output_file_base',$
    title = 'Output File')
    
  base = widget_base(output_base,$
    /column)
    
  output_path = widget_button(base,$
    value = (*global).BatchDefaultPath,$
    scr_xsize = 519,$
    event_pro = 'browse_output_path',$
    uname = 'output_path_button')
    
  ;row2
  row2 = widget_base(base,$
    /row)
  label = widget_label(row2,$
    value = 'Raw file name:')
  value = widget_text(row2,$
    value = '',$
    /all_events,$
    /editable,$
    scr_xsize = 385,$
    event_pro = 'output_file_name_value',$
    uname = 'output_short_file_name')
  ext = widget_label(row2,$
    uname = 'output_file_name_extension',$
    value = '.txt')
    
  ;row3
  row3 = widget_base(base,$
    /row)
  label = widget_label(row3,$
    scr_ysize = 10,$
    value = '                                   S C A L E D  ')
    
  for i=0,3 do begin
    row = widget_base(base,$
      /row)
    label = widget_label(row,$
      value = 'N/A',$
      uname = 'scaled_data_spin_state_' + strcompress(i,/remove_all),$
      scr_xsize = 50)
    value = widget_label(row,$
      value = 'N/A',$
      /align_left,$
      frame = 0,$
      scr_xsize = 400,$
      uname = 'scaled_data_file_name_value_' + strcompress(i,/remove_all))
    preview = widget_button(row,$
      value = 'Preview..',$
      uname = 'scaled_data_file_preview_' + strcompress(i,/remove_all),$
      sensitive = 0)
  endfor
  
  ;row4
  row4 = widget_base(base,$
    /row)
  label = widget_label(row4,$
    scr_ysize = 10,$
    value = '                                 C O M B I N E D  ')
    
  for i=0,3 do begin
    row = widget_base(base,$
      /row)
    label = widget_label(row,$
      value = 'N/A',$
      uname = 'combined_scaled_data_spin_state_' + strcompress(i,/remove_all),$
      scr_xsize = 50)
    value = widget_label(row,$
      value = 'N/A',$
      /align_left,$
      scr_xsize = 400,$
      uname = 'combined_scaled_data_file_name_value_' + strcompress(i,/remove_all))
    preview = widget_button(row,$
      value = 'Preview..',$
      uname = 'combined_scaled_data_file_preview_' + strcompress(i,/remove_all),$
      sensitive = 0)
  endfor
  
end

