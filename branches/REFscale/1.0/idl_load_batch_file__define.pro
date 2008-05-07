;===============================================================================
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
;===============================================================================

FUNCTION PopulateBatchTable, Event, BatchFileName
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
populate_error = 0
;CATCH, populate_error
NbrColumn = getGlobalVariable('NbrColumn')
NbrRow    = getGlobalVariable('NbrRow')
BatchTable = strarr(NbrColumn,NbrRow)
FileArray = strarr(1)
IF (populate_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    AppendReplaceLogBookMessage, Event, $
      (*global).FAILED, $
      (*global).processing_message
    LogText = '-> FileArray:'
    putLogBookMessage, Event, LogText, APPEND=1
    putLogBookMessage, Event, FileArray, APPEND=1
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
                SplitArray = strsplit(FileArray[FileIndex],' : ',/extract)
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
                    '#Date'      : BatchTable[6,BatchIndex] = SplitArray[1]
                    ELSE         : BEGIN
                        CommentArray= strsplit(SplitArray[0],'#',/extract, COUNT=nbr)
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
                        BatchTable[7,BatchIndex] = cmd
                    END
                ENDCASE
                ++FileIndex
            ENDELSE
        ENDELSE
    ENDWHILE
    AppendReplaceLogBookMessage, Event, 'OK', (*global).processing_message
ENDELSE
RETURN, BatchTable
END

;*******************************************************************************
;***** Class constructor *******************************************************
FUNCTION idl_load_batch_file::init, batch_file_name
IF (FILE_TEST(batch_file_name)) THEN BEGIN ;only if file exist





    RETURN,1
ENDIF ELSE BEGIN
    RETURN,0
ENDELSE
END

;*******************************************************************************
;******  Class Define ****;*****************************************************
PRO idl_load_batch_file__define
struct = {ild_load_batch_file,$
          value: ''}
END
;*******************************************************************************
;*******************************************************************************

