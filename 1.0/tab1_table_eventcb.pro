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
;    Refresh big table and put new big_table value in table
;
; :Params:
;    event
;
; :Author: j35
;-
pro refresh_big_table, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  big_table = (*global).big_table
  putValue, event=event, base=main_base, 'tab1_table', big_table
  
end

;+
; :Description:
;    add new listed data nexus to big table
;
; :Params:
;    event
;    list_of_nexus
;
; :Keywords:
;   type        'data' or 'norm'
;
; :Author: j35
;-
pro add_list_of_nexus_to_table, event, list_of_nexus, type=type
  compile_opt idl2
  
  case (type) of
    'data': _index_column=0
    'norm': _index_column=1
  endcase
  
  widget_control, event.top, get_uvalue=global
  _big_table = (*global).big_table
  nbr_row = (size(_big_table,/dim))[1]
  
  first_empty_row_index = get_first_empty_row_index(_big_table, type=type)
  if (first_empty_row_index eq -1) then begin
    ;display error message (too many files loaded)
    return
  endif
  
  nbr_nexus_freshly_loaded = n_elements(list_of_nexus)
  _index = 0
  while (_index lt nbr_nexus_freshly_loaded) do begin
    _big_table[_index_column,first_empty_row_index] = list_of_nexus[_index]
    first_empty_row_index++
    if (first_empty_row_index eq nbr_row) then begin
      ;display error message about too many files loaded)
      break
    endif
    _index++
  endwhile
  
  (*global).big_table = _big_table
  
end

;+
; :Description:
;    Remove the row selected
;
; :Params:
;    event
;
; :Author: j35
;-
pro delete_row_tab1_table, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  selection = get_table_lines_selected(event)
  row_selected = selection[1]
  
  big_table = (*global).big_table
  
  dimension = size(big_table,/dim)
  nbr_column = dimension[0]
  nbr_row = dimension[1]
  
  _big_table = strarr(nbr_column, nbr_row)
  
  _index_old = 0
  _index_new = 0
  while (_index_old lt nbr_row) do begin
    if (row_selected ne _index_old) then begin
      _big_table[*,_index_new] = big_table[*,_index_old]
      _index_new++
    endif
    _index_old++
  endwhile
  
  putValue, event=event, base=main_base, 'tab1_table', _big_table
  
  (*global).big_table = _big_table
  
end

;+
; :Description:
;    check if the data cell of the current row selected is not empty
;
; :Params:
;    event
;
; :Returns:
;   1 if the data cell is not empty, 0 otherwise
;
; :Author: j35
;-
function selected_row_data_not_empty, event
  compile_opt idl2
  
  selection = get_table_lines_selected(event)
  row_selected = selection[1]
  
  widget_control, event.top, get_uvalue=global
  big_table = (*global).big_table
  if (big_table[0,row_selected] ne '') then return, 1
  return, 0
  
end

;+
; :Description:
;    refresh the big table
;
; :Params:
;    event
;
; :Author: j35
;-
pro create_big_table_tab1, event=event, main_base=main_base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global
  endif else begin
    widget_control, main_base, get_uvalue=global
  endelse
  
  list_data_nexus = (*(*global).list_data_nexus)
  max_nbr_data_nexus = (*global).max_nbr_data_nexus
  list_norm_nexus = (*(*global).list_norm_nexus)
  
  ;initialize big array
  big_table = strarr(2,max_nbr_data_nexus)
  
  ;add the data nexus file to big array
  _sz_data = n_elements(list_data_nexus)
  if (_sz_data ge max_nbr_data_nexus) then _sz_data = max_nbr_data_nexus
  _index_data = 0
  while (_index_data lt _sz_data) do begin
    big_table[0,_index_data] = list_data_nexus[_index_data]
    _index_data++
  endwhile
  
  ;add the norm nexus file to big array
  _sz_norm = n_elements(list_norm_nexus)
  _index_norm_left = 0
  _index_norm_right = 0
  while (_index_norm_left lt _sz_norm) do begin
    ;    if (_index_norm_left ge _sz_norm) then begin
    ;      _index_norm_right--
    ;    endif
    big_table[1,_index_norm_left] = list_norm_nexus[_index_norm_right]
    _index_norm_left++
    _index_norm_right++
  endwhile
  
  putValue, event=event, base=main_base, 'tab1_table', big_table
  
  (*global).big_table = big_table
  
end