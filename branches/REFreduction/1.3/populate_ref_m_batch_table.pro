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

pro populate_ref_m_batch_table, event, cmd_array
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global
  
  ;retrieve current Batch Table
  BatchTable = (*(*global).BatchTable_ref_m)
  
  ;check if there is a row in the BatchTable where the Command Line is
  ;still undefined. If yes, remove this row, if not, remove last row and
  ;move up everything
  RowIndexes    = getGlobalVariable_ref_m('RowIndexes')
  ColumnIndexes = getglobalVariable_ref_m('ColumnIndexes')
  for i=0,RowIndexes do begin
    if (BatchTable[ColumnIndexes,i] EQ 'N/A') then begin
      RemoveGivenRowInBatchTable_ref_m, BatchTable, i
      break
    endif
  endfor
  
  ;move down everything to make room for new load data and insert blank
  ;data
  AddBlankRowInBatchTable_ref_m, BatchTable
  
  ;Create instance of the class that will collect the various infos
  ClassInstance = obj_new('IDLparseCommandLine_ref_m',cmd_array)
  
  MainDataRunNumber = ClassInstance->getMainDataRunNumber()
  DataSpinStates = ClassInstance->getDataPath()
  MainNormRunNumber = ClassInstance->getMainNormRunNumber()
  NormSpinStates = ClassInstance->getNormPath()
  Sangle = ClassInstance->getSangleValue()
  cmd = ClassInstance->getCmd()
  
  BatchTable[1,0] = MainDataRunNumber
  BatchTable[2,0] = DataSpinStates
  BatchTable[3,0] = MainNormRunNumber
  BatchTable[4,0] = NormSpinStates
  BatchTable[5,0] = Sangle
  BatchTable[6,0] = GenerateShortReadableIsoTimeStamp()
  BatchTable[8,0] = cmd
  
  active_batch_new_line, event, BatchTable
  
  ;populate table of batch tab
  VisualBatchTable = BatchTable[0:8,*]
  id = widget_info(Event.top,find_by_uname='batch_table_widget')
  widget_control, id, set_value=VisualBatchTable
  
  (*(*global).BatchTable_ref_m) = BatchTable
  
end

;+
; :Description:
;   This will activate the new batch line that was just added
;
; :Params:
;    event
;    BatchTable
;
; :Author: j35
;-
PRO active_batch_new_line, event, BatchTable
  ;get global structure
  widget_control,event.top,get_uvalue=global
  ;remove old current working row
  RowIndexes = getGlobalVariable_ref_m('RowIndexes')
  FOR i=0,RowIndexes DO BEGIN
    CASE (BatchTable[0,i]) OF
      '> YES <': BEGIN
        BatchTable[0,i]='YES'
        BREAK
      END
      '> NO <': BEGIN
        BatchTable[0,i]='NO'
        BREAK
      END
      ELSE:
    ENDCASE
  ENDFOR
  BatchTable[0,0] = '> YES <'
END


;------------------------------------------------------------------------------
;This function insert a clear row on top of batchTable and move
;everything else down
PRO AddBlankRowInBatchTable_ref_m, BatchTable
  RowIndexes = getglobalVariable_ref_m('RowIndexes')
  FOR i = 0, RowIndexes-1 DO BEGIN
    k=(RowIndexes-i)
    BatchTable[*,k]=BatchTable[*,k-1]
  ENDFOR
  ClearStructureFields_ref_m, BatchTable, 0
END

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
  nbr_column = getGlobalVariable_ref_m('NbrColumn')
  resetArray = strarr(nbr_column)
  BatchTable[*,CurrentBatchTableIndex] = resetArray
END
