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
;    Keep record of all the normalization nexus files loaded. This is mostly
;    used by the widget_base normalization_base that allows the user
;    to select a different normalization file for a given data nexus file
;
; :Params:
;    event
;    list_of_nexus
;
; :Author: j35
;-
pro add_list_of_nexus_to_full_norm_list, event, list_of_nexus
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  list_norm_nexus = (*(*global).list_norm_nexus)
  
  list_norm_nexus = [list_norm_nexus, list_of_nexus]
  list_norm_nexus = list_norm_nexus[uniq(list_norm_nexus)]
  
  (*(*global).list_norm_nexus) = list_norm_nexus
  
end

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
  
  widget_control, event.top, get_uvalue=global
  
  ;parse the input text field and create the list of runs
  list_runs = parse_run_numbers(event, type='Norm')
  (*(*global).list_norm_runs) = list_runs
  
  ;create list of NeXus
  list_nexus = create_list_of_nexus(event, $
    list_runs=list_runs,$
    type='Norm')
  add_list_of_nexus_to_table, event, list_of_nexus, type='norm'
  add_list_of_nexus_to_full_norm_list, event, list_of_nexus
  
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
  list_nexus = browse_nexus_button(event, $
    title=title, $
    multiple_files=1)
  if (list_nexus[0] ne '') then begin
    widget_control, event.top, get_uvalue=global
    add_list_of_nexus_to_table, event, list_nexus, type='norm'
    refresh_big_table, event
    
    message = ['> Browsing for Normalization NeXus files: ']
    sz = n_elements(list_nexus)
    index=0
    while (index lt sz) do begin
      _message = '-> ' + list_nexus[index]
      message = [message, _message]
      index++
    endwhile
    log_book_update, event, message=message
    
  endif
  
end
