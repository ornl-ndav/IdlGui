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
;    This routines checks if the 'run normalization' button can be
;    enabled or not.
;    Condition to enable the button will be to have at least 1 data file,
;    1 open beam and 1 dark field files. A ROI is optional.
;
;    if either the enabled or disabled button are passed, those values are
;    forced on the button
;
;
; :Keywords:
;    event
;    enabled
;    disabled
;
; :Author: j35
;-
pro check_run_normalization_button_status, event=event, $
    enabled=enabled, $
    disabled=disabled
  compile_opt idl2
  
  ;force the enabled state
  if (keyword_set(enabled)) then begin
    activate_button, event=event, $
      status=1b, $
      uname='run_normalization_button'
    return
  endif
  
  ;force the disabled state
  if (keyword_set(disabled)) then begin
    activate_button, event=event, $
      status=0b, $
      uname='run_normalization_button'
    return
  endif
  
  list_table_uname = ['data_files_table',$
    'open_beam_table',$
    'dark_field_table']
  nbr_table = n_elements(list_table_uname)
  _index=0
  while (_index lt nbr_table) do begin
    table = getValue(event=event,uname=list_table_uname[_index])
    if (table[0,0] eq '') then begin
    activate_button, event=event, $
      status=0b, $
      uname='run_normalization_button'
  message = 'To run normalization, at least one file is required in ' + $
  list_table_uname[_index] 
  log_book_update, event, message=message
      return
    endif
    _index++
  endwhile
  
  ;make sure at least 1 output format has been selected
    if (~isButtonSelected(event=event,uname='format_tiff_button') && $
    ~isButtonSelected(event=event,uname='format_png_button') && $
    ~isButtonSelected(event=event,uname='format_fits_button')) then begin
    activate_button, event=event, $
      status=0b, $
      uname='run_normalization_button'
  ;add log book message
  message = 'At least one output file format requested to be able ' + $
  'to run the normalization!'
  log_book_update, event, message=message
      return
    endif 
  
    activate_button, event=event, $
      status=1b, $
      uname='run_normalization_button'
  
end