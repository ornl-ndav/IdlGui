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
;    refresh the big table
;
; :Params:
;    event
;
; :Author: j35
;-
pro update_big_table_tab1, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
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
  if (_sz_norm ge max_nbr_data_nexus) then _sz_norm = max_nbr_data_nexus
  _index_norm = 0
  while (_index_norm lt _sz_norm) do begin
    big_table[1,_index_norm] = list_norm_nexus[_index_norm]
    _index_norm++
  endwhile
  
  putValue, event=event, 'tab1_table', big_table
  
  (*global).big_table = big_table
  
end