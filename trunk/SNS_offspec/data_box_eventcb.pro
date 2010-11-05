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
;    Parse the Data run numbers text field and create the list of
;    data run numbers
;
; :Params:
;    event
;
; :Author: j35
;-
pro parse_data_run_numbers, event
  compile_opt idl2
  
  run_number_string = strcompress(getValue(event=event, $
    uname='data_run_numbers_text_field'),/remove_all)
    
  list_of_runs = !null
  widget_control, event.top, get_uvalue=global
  
  if (run_number_string eq '') then begin
    (*(*global).list_data_runs) = list_of_runs
    return
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
  
  (*(*global).list_data_runs) = list_of_runs
  ;message for log book
  message1 = '> Data run numbers input is: ' + run_number_string
  message2 = '-> Parsing data run number:'
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

;+
; :Description:
;    from the list of data run numbers, create the list of full path
;    NeXus file names
;
; :Params:
;    event

; :Author: j35
;-
pro create_list_of_nexus, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  list_data_runs = (*(*global).list_data_runs)
  message = ['> Get full data NeXus file name: ']
  
  sz = n_elements(list_data_runs)
  
  if (list_data_runs eq !null) then return
  
  list_data_nexus = !null
  index = 0
  while (index lt sz) do begin
  
    _nexus_name = get_nexus(event=event, run_number=list_data_runs[index])
    if (_nexus_name ne 'N/A') then begin
      list_data_nexus = [list_data_nexus, _nexus_name]
    endif
    
    _message = '-> Run number: ' + $
      strcompress(list_data_runs[index],/remove_all) + ' -> NeXus: ' + $
      _nexus_name
    message = [message, _message]
    
    index++
  endwhile
  
  (*(*global).list_data_nexus) = list_data_nexus
  
  ;message for log book
  log_book_update, event, message = message
  
end

;+
; :Description:
;    Event reached by the 'Data run numbers:' text field
;
; :Params:
;    event

; :Author: j35
;-
pro data_run_numbers_event, event
  compile_opt idl2
  
  ;parse the input text field and create the list of runs
  parse_data_run_numbers, event
  
  ;create list of NeXus
  create_list_of_nexus, event
  
end

;+
; :Description:
;    Routine reached by the browse data button
;
; :Params:
;    event
;
; :Author: j35
;-
pro browse_data_button_event, event
  compile_opt idl2
  
  title = 'Select the data NeXus files'
  list_of_nexus = browse_nexus_button(event, $
    title=title,$
    /multiple_files)
  if (list_of_nexus[0] ne '') then begin
    widget_control, event.top, get_uvalue=global
    (*(*global).list_data_nexus) = list_of_nexus
    
    message = ['> Browsing for Data NeXus files: ']
    sz = n_elements(list_of_nexus)
    index = 0
    while (index lt sz) do begin
      _message = '-> ' + list_of_nexus[index]
      message = [message, _message]
      index++
    endwhile
    log_book_update, event, message=message
    
  endif
  
end

;+
; :Description:
;    Using the first data nexus file loaded, this routine
;    retrieves the distance Sample to Detector and Moderator to Detector
;
; :Params:
;    event
;
; :Author: j35
;-
pro retrieve_data_nexus_distances, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  list_data_nexus = (*(*global).list_data_nexus)
  first_data_nexus = list_data_nexus[0]
  
  type = (size(first_data_nexus))[1]
  ;no nexus loaded yet
  if (type ne 7) then return
  
  iNexus = obj_new('IDLnexusUtilities', first_data_nexus)
  d_SD = iNexus->get_d_SD()
  d_MS = iNexus->get_d_MS()
  obj_destroy, iNexus
  
  ;convert into mm
  d_SD_mm = abs(convert_distance(distance = d_SD.value,$
    from_unit = d_SD.units, $
    to_unit = 'mm'))
  d_MS_mm = abs(convert_distance(distance = d_MS.value,$
    from_unit = d_MS.units, $
    to_unit = 'mm'))
    
  d_MD_mm = d_MS_mm + d_SD_mm
  
  putValue, event=event, 'd_sd_uname', d_SD_mm
  putValue, event=event, 'd_md_uname', d_MD_mm
    
end
