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
;   add the new spin state to the data spin state strarr
;
; :Params:
;    event
;    spinState
;
; :Author: j35
;-
pro add_data_spin_state, event, spinState
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  data_spin_state = (*(*global).data_spin_state)
  if (data_spin_state[0] eq '') then begin
    data_spin_state[0] = spinState[0]
  endif else begin
    data_spin_state = [data_spin_state,spinState[0]]
  endelse
  (*(*global).data_spin_state) = data_spin_state
  
end

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
    ;number of columns in the Table (active/data/norm/s1/s2...)
    'ColumnIndexes'         : RETURN, 8
    'NbrColumn'             : RETURN, 9
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

;------------------------------------------------------------------------------
FUNCTION PopulateBatchTable, Event, BatchFileName

  populate_error = 0
  CATCH, populate_error
  NbrColumn  = getGlobalVariable('NbrColumn')
  NbrRow     = getGlobalVariable('NbrRow')
  BatchTable = STRARR(NbrColumn,NbrRow)
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
            '#Active'    : BatchTable[0,BatchIndex] = SplitArray[1]
            '#Data_Runs' : BatchTable[1,BatchIndex] = SplitArray[1]
            '#Data_Spin_States' : begin
              data_error = 0
              catch, data_error
              if (data_error ne 0) then begin
                catch,/cancel
              endif else begin
                (*global).working_with_ref_m_batch = 1b
                (*global).instrument = 'REF_M'
                spinState = SplitArray[1]
                add_data_spin_state, event, spinState
              endelse
            end
            '#Norm_Runs' : BEGIN
              norm_error = 0
              CATCH,norm_error
              IF (norm_error NE 0) THEN BEGIN
                CATCH,/CANCEL
                BatchTable[2,BatchIndex] = ''
              ENDIF ELSE BEGIN
                BatchTable[2,BatchIndex] = SplitArray[1]
              ENDELSE
            END
            '#Norm_Spin_States' : begin
              norm_error = 0
              catch, norm_error
              if (norm_error ne 0) then begin
                catch,/cancel
              endif else begin
                normSpinState = SplitArray[1]
                add_norm_spin_state, event, normSpinState
              endelse
            end
            '#EC_Runs' : BEGIN
              ec_error = 0
              CATCH,ec_error
              IF (ec_error NE 0) THEN BEGIN
                CATCH,/CANCEL
                BatchTable[3,BatchIndex] = ''
              ENDIF ELSE BEGIN
                BatchTable[3,BatchIndex] = SplitArray[1]
              ENDELSE
            END
            '#Angle(deg)' : begin
              angle_error = 0
              catch, angle_error
              if (angle_error ne 0) then begin
                catch,/cancel
                BatchTable[4,BatchIndex] = ''
              endif else begin
                BatchTable[4,BatchIndex] = SplitArray[1]
              endelse
            end
            '#S1(mm)'    : begin
              s1_error = 0
              catch, s1_error
              if (s1_error ne 0) then begin
                catch, /cancel
                BatchTable[5,BatchIndex] = ''
              endif else begin
                BatchTable[5,BatchIndex] = SplitArray[1]
              endelse
            end
            '#S2(mm)'    : begin 
              s1_error = 0
              catch, s1_error
              if (s1_error ne 0) then begin
                catch, /cancel
                BatchTable[6,BatchIndex] = ''
              endif else begin
                BatchTable[6,BatchIndex] = SplitArray[1]
              endelse
            end
            '#Date'      : BatchTable[7,BatchIndex] = $
              STRJOIN(SplitArray[1:length-1],':')
            '#SF'        : BEGIN
              sz = (size(SplitArray))(1)
              IF (sz GT 1) THEN BEGIN
                BatchTable[8,BatchIndex] = SplitArray[1]
              ENDIF ELSE BEGIN
                BatchTable[8,BatchIndex] = ''
              ENDELSE
            END
            ELSE: BEGIN ;command line
            
              print, 'in else:'
              print, splitarray[0]
            
              CommentArray= STRSPLIT(SplitArray[0],'#', $
                /EXTRACT, $
                COUNT=nbr)
              SplitArray[0] =CommentArray[0]
              cmd           = strjoin(SplitArray,' ')




;              ;check if "-o none" is there or not
;              IF (strmatch(strlowcase(cmd),'*-o none*')) THEN BEGIN
;                string_split = ' --batch -o none'
;              ENDIF ELSE BEGIN
;                string_split = ' --batch'
;              ENDELSE
;              
;              cmd_array     = STRSPLIT(cmd, $
;                string_split, $
;                /EXTRACT, $
;                /REGEX,$
;                COUNT = length)
;              IF (length NE 1) THEN BEGIN
;                cmd = cmd_array[0] + ' ' + cmd_array[1]
;              ENDIF else begin
;                cmd = cmd_array[0]
;              endelse

              BatchTable[9,BatchIndex] = cmd

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
    BatchTable: STRARR(10,20),$
    value:      ''}
END
;******************************************************************************
;******************************************************************************

