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
;    Describe the procedure.
;
; :Params:
;    event
;
; :Keywords:
;    list_runs
;    type       ;'data' or 'norm' used for log book only
;
; :Author: j35
;-
function create_list_of_nexus, event, list_runs=list_runs, type=type
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  message = ['> Get full ' + type ' + NeXus file names: ']
  sz = n_elements(list_runs)
  
  if (list_runs eq !null) then return
  
  list_nexus = !null
  index = 0
  while (index lt sz) do begin
  
    _nexus_name = get_nexus(event=event, run_number=list_runs[index])
    if (_nexus_name ne 'N/A') then begin
      list_nexus = [list_nexus, _nexus_name]
    endif
    
    _message = '-> Run number: ' + $
      strcompress(list_runs[index],/remove_all) + ' -> NeXus: ' + $
      _nexus_name
    message = [message, _message]
    
    index++
  endwhile
  
  ;message for log book
  log_book_update, event, message = message
  
  return, list_nexus
end

;+
; :Description:
;    Parse the run numbers text field and create the list of
;    run numbers
;
; :Params:
;    event
;
; :Keywords:
;   type        ;'data' or 'norm'
;
; :Author: j35
;-
function parse_run_numbers, event, type=type
  compile_opt idl2
  
  case (strlowcase(type)) of
    'data': begin
      run_number_string = strcompress(getValue(event=event, $
        uname='data_run_numbers_text_field'),/remove_all)
    end
    'norm': begin
      run_number_string = strcompress(getValue(event=event, $
        uname='norm_run_numbers_text_field'),/remove_all)
    end
  endcase
  
  list_of_runs = !null
  widget_control, event.top, get_uvalue=global
  
  if (run_number_string eq '') then begin
    return, list_of_runs
  endif
  
  split1 = strsplit(run_number_string,',',/extract,/regex)
  sz1 = n_elements(split1)
  index1 = 0
  while (index1 lt sz1) do begin
  
    split2 = strsplit(split1[index1],'-',/extract,/regex)
    sz2 = n_elements(split2)
    if (sz2 eq 1) then begin
      list_of_runs = [list_of_runs,strcompress(split2[0],/remove_all)]
    endif else begin
      new_runs = getSequence(from=split2[0], to=split2[1])
      list_of_runs = [list_of_runs, new_runs]
    endelse
    index1++
  endwhile
  
  ;message for log book
  message1 = '> ' + type + ' run numbers input is: ' + run_number_string
  message2 = '-> Parsing ' + type + ' run number:'
  message = [message1, message2]
  sz = n_elements(list_of_runs)
  index = 0
  while (index lt sz) do begin
    message = [message, '    - ' + list_of_runs[index]]
    index++
  endwhile
  (*(*global).new_log_book_message) = message
  log_book_update, event
  
end
