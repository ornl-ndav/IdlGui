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

;**********************************************************************
;GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL
;**********************************************************************

;+
; :Description:
;   add the new spin state to the new norm spin state strarr
;
; :Params:
;    event
;    spinState
;
; :Author: j35
;-
pro add_norm_spin_state, event, spinState
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  norm_spin_state = (*(*global).norm_spin_state)
  if (norm_spin_state[0] eq '') then begin
    norm_spin_state[0] = spinState[0]
  endif else begin
    norm_spin_state = [norm_spin_state,spinState[0]]
  endelse
  (*(*global).norm_spin_state) = norm_spin_state
  
end


;Procedure that will return all the global variables for this routine
FUNCTION getGlobalVariable, var
  CASE (var) OF
    ;number of columns in the Table
  
    ;active|data_runs|data_spin_states|Norm_runs|norm_spin_states
    ;EC_runs|Angle|s1|s2|date|SF|command_line
    'ColumnIndexes'         : RETURN, 11
    'NbrColumn'             : RETURN, 12
    'RowIndexes'            : RETURN, 19
    'NbrRow'                : RETURN, 20
    'BatchFileHeadingLines' : RETURN, 3
    ELSE:
  ENDCASE
  RETURN, 'NA'
END

;------------------------------------------------------------------------------
FUNCTION getNbrLines, FileName
  cmd = 'wc -l ' + FileName
  spawn, cmd, result
  Split = STRSPLIT(result[0],' ',/EXTRACT)
  RETURN, Split[0]
END

;------------------------------------------------------------------------------
FUNCTION PopulateFileArray, BatchFileName, NbrLine
  OPENR, u, BatchFileName, /GET
  onebyte   = 0b
  tmp       = ''
  i         = 0
  NbrLine   = getNbrLines(BatchFileName)
  FileArray = STRARR(NbrLine)
  WHILE (NOT eof(u)) DO BEGIN
    READU,u,onebyte
    fs = FSTAT(u)
    IF (fs.cur_ptr EQ 0) THEN BEGIN
      POINT_LUN,u,0
    ENDIF ELSE BEGIN
      POINT_LUN,u,fs.cur_ptr - 1
    ENDELSE
    READF,u,tmp
    FileArray[i++] = tmp
  ENDWHILE
  CLOSE, u
  FREE_LUN,u
  NbrElement = i                  ;nbr of lines
  RETURN, FileArray
END

;+
;
; Descriptions:
;   Add the second part of the string array (if any)
;   at the right place in the BatchTable
;
; keywords:
;   column_index
;   row_index
;   split_array
;   BatchTable
;   cmd_line    if True, takes split_array[0], otherwise split_array[1]
;
;-
pro addToBatchTable, column_index = column_index, $
    row_index = row_index, $
    split_array = split_array, $
    BatchTable = BatchTable, $
    cmd_line = cmd_line
  compile_opt idl2
  
  error = 0
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    BatchTable[column_index, row_index] = ''
  endif else begin
    if (n_elements(cmd_line) eq 0) then begin
      value = split_array[1]
    endif else begin
      value = split_array[0]
    endelse
    BatchTable[column_index, row_index] = value
  endelse
  
end

;------------------------------------------------------------------------------
FUNCTION PopulateBatchTable, Event, BatchFileName

  widget_control, event.top, get_uvalue=global
  
  populate_error = 0
  ; CATCH, populate_error
  NbrColumn  = getGlobalVariable('NbrColumn')
  NbrRow     = getGlobalVariable('NbrRow')
  BatchTable = STRARR(NbrColumn,NbrRow) ;[spin_state, column row]
  ;spin state is for off_off, off_on ...
  ;column is cmd | SF
  ;row is list of files
  FileArray  = STRARR(1)
  IF (populate_error NE 0) THEN BEGIN
    CATCH,/CANCEL
  ENDIF ELSE BEGIN
    NbrLine   = 0
    FileArray = PopulateFileArray(BatchFileName, NbrLine)
    BatchIndex = -1             ;row index
    FileIndex  = 0
    NbrHeadingLines = getGlobalVariable('BatchFileHeadingLines')
    WHILE (FileIndex LT NbrLine) DO BEGIN
      IF (FileIndex LT NbrHeadingLines) THEN BEGIN
        ;add work on header here
        ++FileIndex
      ENDIF ELSE BEGIN
        IF (FileArray[FileIndex] EQ '') THEN BEGIN
          ++BatchIndex
          ++FileIndex
        ENDIF ELSE BEGIN
          SplitArray = STRSPLIT(FileArray[FileIndex],' : ', $
            /EXTRACT,$
            /regex,$
            COUNT=length)
            
          CASE (SplitArray[0]) OF
            '#Active'    : addToBatchTable, column_index = 0, $
              row_index = BatchIndex, $
              split_array = SplitArray, $
              BatchTable = BatchTable
            '#Data_Runs' : addToBatchTable, column_index = 1, $
              row_index = BatchIndex, $
              split_array = SplitArray, $
              BatchTable = BatchTable
            '#Data_Spin_States' : addToBatchTable, column_index = 2, $
              row_index = BatchIndex, $
              split_array = SplitArray, $
              BatchTable = BatchTable
            '#Norm_Runs' : addToBatchTable, column_index = 3, $
              row_index = BatchIndex, $
              split_array = SplitArray, $
              BatchTable = BatchTable
            '#Norm_Spin_States' : addToBatchTable, column_index = 4, $
              row_index = BatchIndex, $
              split_array = SplitArray, $
              BatchTable = BatchTable
            '#EC_Runs' : addToBatchTable, column_index = 5, $
              row_index = BatchIndex, $
              split_array = SplitArray, $
              BatchTable = BatchTable
            '#Angle(deg)' : addToBatchTable, column_index = 6, $
              row_index = BatchIndex, $
              split_array = SplitArray, $
              BatchTable = BatchTable
            '#S1(mm)'    : addToBatchTable, column_index = 7, $
              row_index = BatchIndex, $
              split_array = SplitArray, $
              BatchTable = BatchTable
            '#S2(mm)'    : addToBatchTable, column_index = 8, $
              row_index = BatchIndex, $
              split_array = SplitArray, $
              BatchTable = BatchTable
            '#Date'      : addToBatchTable, column_index = 9, $
              row_index = BatchIndex, $
              split_array = SplitArray, $
              BatchTable = BatchTable
            '#SF'        : addToBatchTable, column_index = 10, $
              row_index = BatchIndex, $
              split_array = SplitArray, $
              BatchTable = BatchTable
            ELSE: BEGIN ;command line
              addToBatchTable, column_index = 11, $
                row_index = BatchIndex, $
                split_array = SplitArray, $
                BatchTable = BatchTable, $
                cmd_line = 1b
            END
          ENDCASE
          ++FileIndex
        ENDELSE
      ENDELSE
    ENDWHILE
  ENDELSE
  RETURN, BatchTable
END

;******************************************************************************
;This function returns the BatchTable
FUNCTION IDLloadBatchFile::getBatchTable
  RETURN, self.BatchTable
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLloadBatchFile::init, batch_file_name, Event
  IF (FILE_TEST(batch_file_name)) THEN BEGIN ;only if file exist
    self.BatchTable = PopulateBatchTable(Event, batch_file_name)
    RETURN,1
  ENDIF ELSE BEGIN
    RETURN,0
  ENDELSE
END

;******************************************************************************
;******  Class Define ****;****************************************************
PRO IDLloadBatchFile__define
  struct = {IDLloadBatchFile,$
    BatchTable: STRARR(12,20),$
    value:      ''}
END
;******************************************************************************
;******************************************************************************

