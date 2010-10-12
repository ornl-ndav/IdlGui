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
;    Creates the default output file name and put it in the
;    base File Name box in the output tab
;
; :Params:
;    event

; :Author: j35
;-
pro create_default_output_file_name, event, spin_state=spin_state
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  if (n_elements(spin_state) eq 0) then spin_state = 0
  
  files_SF_list = (*global).files_SF_list
  nbr_files = get_number_of_files_loaded(event)
  
  instrument = getInstrument(files_SF_list[spin_state, 0, 0])
  
  ;loop over all the names of the files to get the first run number
  ;and the number of run added to it
  index = 0
  _output_file_name = instrument
  while(index lt nbr_files) do begin
  
    _file_name = files_SF_list[spin_state, 0, index]
    
    ;retrieve first run number and number of runs
    _split1 = strsplit(_file_name,',',/extract,count=nbr_runs)
    _split2 = strsplit(_split1[0],'_',/extract)
    _start_run = _split2[-1]
    
    _output_file_name += '_' + _start_run + '#' + $
    strcompress(nbr_runs,/remove_all)
    
    index++
  endwhile
  
  default_output_file_name = _output_file_name
  
  putValue, event=event, 'output_base_file_name', default_output_file_name
  
end

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