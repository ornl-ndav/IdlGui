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
;    Procedure reached by the normalization text field
;
; :Params:
;    event
;
; :Author: j35
;-
pro norm_run_number_event, event
  compile_opt idl2
  
  run_number = getValue(event=event,uname='norm_run_number_text_field')
  if (run_number ne '') then begin
    message = ['> Get full Normalization NeXus file name: ']
    nexus_name = get_nexus(event=event, run_number=run_number)
    if (nexus_name ne 'N/A') then begin
      widget_control, event.top, get_uvalue=global
      (*global).norm_nexus = nexus_name
    endif
    _message = '-> Run number: ' + strcompress(run_number,/remove_all) + $
      ' -> NeXus: ' + nexus_name
    message = [message, _message]
    log_book_update, event, message=message
  endif
  
end

;+
; :Description:
;    routine reached by the browse norm button
;
; :Params:
;    event
;
; :Author: j35
;-
pro browse_norm_button_event, event
  compile_opt idl2
  
  title = 'Select the normalization NeXus files'
  nexus = browse_nexus_button(event, $
  title=title, $
  multiple_files=0)
  if (nexus[0] ne '') then begin
    widget_control, event.top, get_uvalue=global
    (*global).norm_nexus = nexus
    
    message = ['> Browsing for a Normalization NeXus file: ']
    _message = '-> ' + nexus
    message = [message, _message]
    log_book_update, event, message=message
    
  endif
  
end
