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
;    This routine checks that the conditions between the normalization column
;    of the big table and the buttons selected in normalization widgets match.
;    If they don't this routine will change the buttons
;
; :Params:
;    event
;
; :Author: j35
;-
pro check_use_same_norm_file_widgets, event
  compile_opt idl2
  
    if (isButtonSelected(event=event, base=base, $
    uname='not_same_normalization_file_button')) then return
    
    big_table = getValue(event=event, uname='tab1_table')
    nbr_norm = get_first_empty_row_index(big_table, type='norm')
    
    norm_column = big_table[1,0:nbr_norm-1]
    uniq_norm = norm_column[uniq(norm_column)]
    
    ;at least 2 differents files
    if (n_elements(uniq_norm) gt 1) then begin
    setButton, event=event, uname='not_same_normalization_file_button'
  endif
  
end

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
;    add new norm nexus files loaded to full list of norm nexus
;
; :Params:
;    event
;    list_of_nexus
;
; :Author: j35
;-
pro add_list_of_norm_nexus_to_selected_list, event, list_of_nexus
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  selected_list_norm_file = (*global).selected_list_norm_file
  sz = n_elements(selected_list_norm_file)
  index_start = 0
  for i=0,(sz-1) do begin
    if (selected_list_norm_file[i] ne '') then begin
      index_start = i
      break
    endif
  endfor
  
  sz_new_list = size(list_of_nexus,/dim)
  
  max_index = min(sz_new_list, sz)
  
  index = index_start
  _index = 0
  while (_index lt max_index) do begin
    selected_list_norm_file[index] = list_of_nexus[_index]
    index++
    _index++
  endwhile
  
  (*global).selected_list_norm_file = selected_list_norm_file
  
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
    
    ;1 norm file to use
    if (isButtonSelected(event=event, base=base, $
      uname='same_normalization_file_button')) then begin
      
      ;switch to 'not use same norm file' if more than 1 norm file is loaded
      if (n_elements(list_nexus) gt 1) then begin
        setButton, event=event, uname='not_same_normalization_file_button'
      endif
      
    endif
    
    add_list_of_norm_nexus_to_selected_list, event, list_nexus
    (*global).uniq_norm_file = list_nexus[0]
    
    
    refresh_big_table, event=event
    
    
    
    
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
