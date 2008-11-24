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
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global
;retrieve parameters
OK         = (*global).ok
FAILED     = (*global).failed
PROCESSING = (*global).processing

populate_error = 0
;CATCH, populate_error
NbrColumn  = getGlobalVariable('NbrColumn')
NbrRow     = getGlobalVariable('NbrRow')
BatchTable = STRARR(NbrColumn,NbrRow)
FileArray  = STRARR(1)
IF (populate_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, FAILED
    LogText = '-> FileArray:'
    idl_send_to_geek_addLogBookText, Event, LogText
    idl_send_to_geek_addLogBookText, Event, FileArray
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
                                      COUNT=length)
                CASE (SplitArray[0]) OF
                    '#Active'    : BatchTable[0,BatchIndex] = SplitArray[1]
                    '#Data_Runs' : BatchTable[1,BatchIndex] = SplitArray[1]
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
                    '#Angle(deg)': BatchTable[3,BatchIndex] = SplitArray[1]
                    '#S1(mm)'    : BatchTable[4,BatchIndex] = SplitArray[1]
                    '#S2(mm)'    : BatchTable[5,BatchIndex] = SplitArray[1]
                    '#Date'      : BatchTable[6,BatchIndex] = $
                      STRJOIN(SplitArray[1:length-1],':')
                    '#SF'        : BEGIN
                        sz = (size(SplitArray))(1)
                        IF (sz GT 1) THEN BEGIN
                            BatchTable[7,BatchIndex] = SplitArray[1]
                        ENDIF ELSE BEGIN
                            BatchTable[7,BatchIndex] = ''
                        ENDELSE
                    END
                    ELSE         : BEGIN
                        CommentArray= STRSPLIT(SplitArray[0],'#', $
                                               /EXTRACT, $
                                               COUNT=nbr)
                        SplitArray[0] =CommentArray[0]
                        cmd           = strjoin(SplitArray,' ')
;check if "-o none" is there or not
                        IF (STRMATCH(cmd,'*-o none*')) THEN BEGIN
                            string_split = ' --batch -o none'
                        ENDIF ELSE BEGIN
                            string_split = ' --batch'
                        ENDELSE
                        cmd_array     = STRSPLIT(cmd, $
                                                 string_split, $
                                                 /EXTRACT, $
                                                 /REGEX,$
                                                 COUNT = length)
                        IF (length NE 0) THEN BEGIN 
                            cmd = cmd_array[0] + ' ' + cmd_array[1]
                        ENDIF
                        BatchTable[8,BatchIndex] = cmd
                    END
                ENDCASE
                ++FileIndex
            ENDELSE
        ENDELSE
    ENDWHILE
    idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, OK
ENDELSE
RETURN, BatchTable
END

;******************************************************************************
;This function returns the BatchTable
FUNCTION idl_load_batch_file::getBatchTable
RETURN, self.BatchTable
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION idl_load_batch_file::init, batch_file_name, Event
IF (FILE_TEST(batch_file_name)) THEN BEGIN ;only if file exist
    self.BatchTable = PopulateBatchTable(Event, batch_file_name)
    RETURN,1
ENDIF ELSE BEGIN
    RETURN,0
ENDELSE
END

;******************************************************************************
;******  Class Define ****;****************************************************
PRO idl_load_batch_file__define
struct = {idl_load_batch_file,$
          BatchTable: STRARR(9,20),$
          value:      ''}
END
;******************************************************************************
;******************************************************************************

