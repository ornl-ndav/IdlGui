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
;    This set the value of a widget (such as a widget_button)
;
; :Params:
;    uname
;    value
;
; :Keywords:
;    event
;    base
;    append
;
; :Author: j35
;-
pro putValue, event=event, base=base, uname, value, append=append
  compile_opt idl2
  
  if (n_elements(event) ne 0) then begin
    uname_id = widget_info(event.top,find_by_uname=uname)
  endif else begin
    uname_id = widget_info(base,find_by_uname=uname)
  endelse
  if (n_elements(append) eq 0) then begin
    widget_control, uname_id, set_value=value
  endif else begin
    widget_control, uname_id, set_value=value, /append
  endelse
  
end

;+
; :Description:
;    new call to putValue
;
;
;
; :Keywords:
;    event
;    id
;    base
;    uname
;    value
;
; :Author: j35
;-
pro put_value, event=event, id=id, base=base, uname=uname, value=value
  compile_opt idl2
  
  if (keyword_set(id)) then begin
    if (n_elements(append) eq 0) then begin
      widget_control, id, set_value=value
    endif else begin
      widget_control, id, set_value=value, /append
    endelse
    return
  endif
  
  putValue, event=event, base=base, uname, value, append=append
  
  end