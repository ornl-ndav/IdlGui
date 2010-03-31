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

pro populate_ref_m_batch_table, event, bash_cmd_array
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global
  
  ;retrieve current Batch Table
  BatchTable = (*(*global).BatchTable)
  
  ;check if there is a row in the BatchTable where the Command Line is
  ;still undefined. If yes, remove this row, if not, remove last row and
  ;move up everything
  RowIndexes    = getGlobalVariable('RowIndexes')
  ColumnIndexes = getglobalVariable('ColumnIndexes')
  for i=0,RowIndexes do begin
    if (BatchTable[ColumnIndexes,i] EQ 'N/A') then begin
      RemoveGivenRowInBatchTable_ref_m, BatchTable, i
      break
    endif
  endfor
  
  ;Create instance of the class
  ClassInstance = obj_new('IDLparseCommandLine_ref_m',cmd_array)
  
  
  
end


;------------------------------------------------------------------------------
;This function removes the given row from the BatchTable
PRO RemoveGivenRowInBatchTable_ref_m, BatchTable, Row
  RowIndexes = getGlobalVariable('RowIndexes')
  FOR i = Row, (RowIndexes-1) DO BEGIN
    BatchTable[*,i]=BatchTable[*,i+1]
  ENDFOR
  ClearStructureFields_ref_m, BatchTable, RowIndexes
END

;------------------------------------------------------------------------------
;This function reset all the structure fields of the current index
PRO ClearStructureFields_ref_m, BatchTable, CurrentBatchTableIndex
  resetArray = strarr(8)
  BatchTable[*,CurrentBatchTableIndex] = resetArray
END
