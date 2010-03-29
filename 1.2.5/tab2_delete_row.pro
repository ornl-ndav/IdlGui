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
;    This procedure removes the row selected
;    row goes from 0-> n
;    table_size goes from 1 -> n+1
;
; :Params:
;    table
;    row
;
; :Author: j35
;-
pro remove_row_from_table, table, row
  compile_opt idl2
  
  sz = (size(table))[2]
  
  if (row ge sz) then return
  
  ;1 row only
  if ((size(table))[0] eq 1) then begin
    if (row ne 0) then return
    table = strarr(3)
    return
  endif
  
  ;last row selected
  if (row eq (sz-1)) then begin
    table = temporary(table[*,0:sz-2])
  end
  
  ;first row selected
  if (row eq 0) then begin
;    print, 'in first row selected
    table = temporary(table[*,1:sz-1])
    return
  end
  
  ;any other row selected
;  print, 'any other row'
  index = 0
  index_tmp = 0
  table_tmp = strarr(3,sz-1)
  while (index lt sz) do begin
    if (index ne row) then begin
      table_tmp[0,index_tmp] = table[0,index]
      table_tmp[1,index_tmp] = table[1,index]
      table_tmp[2,index_tmp] = table[2,index]
      index_tmp++
    endif
    index++
  endwhile
  table = table_tmp  
  
  return
  
end

;+
; :Description:
;    This procedure will remove in the table of tab2 the selected row
;
; :Params:
;    event
;
; :Author: j35
;-
pro tab2_delete_row_event, event
  compile_opt idl2
  
  ;get table value
  table = getTableValue(Event,'tab2_table_uname')
  
  ;get index of row selected
  rc_array = getCellSelectedTab1(Event, 'tab2_table_uname')
  row = rc_array[1]
  
  remove_row_from_table, table, row
  
  putValue, Event, 'tab2_table_uname', table
  
  ;refresh table
  refresh_tab2_table, Event
  check_tab2_run_jobs_button, Event
  
  
  
end