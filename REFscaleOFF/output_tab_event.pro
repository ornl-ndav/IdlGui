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

;+
; :Description:
;    implement the button that determines where the output data will be created
;
; :Params:
;    event

; :Author: j35
;-
pro output_path_event, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  path = (*global).output_path
  dialog_id   = widget_info(event.top, find_by_uname='main_base')
  title = 'Select where to save the output files'
  
  result = dialog_pickfile(path=path,$
    get_path = new_path,$
    dialog_parent = dialog_id, $
    title = title,$
    /directory,$
    /must_exist)
    
  if (strcompress(new_path,/remove_all) ne 0) then begin
    putValue, event=event, 'output_path', new_path
    (*global).output_path = path
  endif
  
end

;+
; :Description:
;    procedure triggered by the 'send by email' button
;    activate or not the email text field
;
; :Params:
;    event
;
; :Author: j35
;-
pro send_by_email_button, event
  compile_opt idl2
  
  id = event.id
  button_status = isButtonSelected(id=id)
  
  if (button_status eq 0) then begin
    text_field_status = 0
  endif else begin
    text_field_status = 1
  endelse
  setSensitive, event=event, $
    uname='send_by_email_base_uname', $
    sensitive=text_field_status
    
end