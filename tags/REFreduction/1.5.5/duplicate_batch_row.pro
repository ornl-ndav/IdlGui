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

pro duplicate_batch_row, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  if ((*global).instrument eq 'REF_L') then begin
    BatchTable = (*(*global).BatchTable)
    max_row_index = getGlobalVariable('RowIndexes')
  endif else begin
    BatchTable = (*(*global).BatchTable_ref_m)
    max_row_index = getGlobalVariable_ref_m('RowIndexes')
  endelse
  
  newBatchTable = BatchTable
  row_selected = (*global).row_selected
  old_i = 0
  for new_i=0, max_row_index do begin
    newBatchTable[*,new_i] = BatchTable[*,old_i]
    if (new_i eq row_selected) then old_i--
    old_i++
  endfor
  
  if ((*global).instrument eq 'REF_L') then begin
    DisplayBatchTable, Event, newBatchTable
    (*(*global).BatchTable) = newBatchTable
  endif else begin
    DisplayBatchTable_ref_m, Event, newBatchTable
    (*(*global).BatchTable_ref_m) = newBatchTable
  endelse
  
end