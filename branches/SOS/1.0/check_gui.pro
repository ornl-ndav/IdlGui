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
; @author : Erik Watkins
;           (refashioned by j35@ornl.gov)
;
;==============================================================================

pro check_go_button, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  activate_go_button = 1
  list_data_nexus = (*(*global).list_data_nexus)
  sz = n_elements(list_data_nexus)
  if (sz eq 0) then begin
    activate_go_button = 0
  endif
  
  if (sz gt 1) then begin
    _label_data = ' data files loaded!'
  endif else begin
    _label_data = ' data file loaded!'
  endelse
  _label_data_message = strcompress(sz,/remove_all) + _label_data
  putValue, event=event, 'data_status_label', _label_data_message
  
  norm_nexus = (*global).norm_nexus
  if (norm_nexus eq '') then begin
    activate_go_button = 0
    _label_norm = '0 normalization file loaded!'
  endif else begin
    _label_norm = '1 normalization file loaded!'
  endelse
  putValue, event=event, 'norm_status_label', _label_norm
  
  activate_button, event=event, $
    status= activate_go_button, $
    uname= 'go_button'
    
end