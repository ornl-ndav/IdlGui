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
;   create the batch file for the REF_M instrument
;
; :Params:
;    Event
;    FullFileName
;
; :Author: j35
;-
PRO CreateBatchFile_ref_m, Event, FullFileName
  compile_opt idl2
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;get Text To copy

  BatchTable = (*(*global).BatchTable_ref_m)
  NbrRow    = (size(BatchTable))[2]
  NbrColumn = (size(BatchTable))[1]
  text    = STRARR(1)
  text[0] = '#This Batch File has been produced by REFreduction ' + $
    (*global).REFreductionVersion
  text    = [text,'#Date : ' + RefReduction_GenerateIsoTimeStamp()]
  text    = [text,'#Ucams : ' + (*global).ucams]
  text    = [text,'']
  
  FOR i=0,(NbrRow-1) DO BEGIN
    ;add information only if row is not blank
    IF (BatchTable[0,i] NE '') THEN BEGIN
    
      IF (BatchTable[0,i] EQ 'NO' OR $
        BatchTable[0,i] EQ '> NO <') THEN BEGIN
        FP     = '#'
        active = 'NO'
      ENDIF ELSE BEGIN
        FP     = ''
        active = 'YES'
      ENDELSE
      
      text    = [text,'#Active : ' + active]
      k=1
      text    = [text,'#Data_Runs : ' + BatchTable[k++,i]]
      text    = [text,'#Data_Spin_States : ' + BatchTable[k++,i]]
      text    = [text,'#Norm_Runs : ' + BatchTable[k++,i]]
      text    = [text,'#Norm_Spin_States : ' + BatchTable[k++,i]]
      text    = [text,'#Angle(deg) : ' + BatchTable[k++,i]]
      text    = [text,'#Date : ' + BatchTable[k++,i]]
      text    = [text,'#SF : ' + BatchTable[k++,i]]
      ;add --batch flag to command line
;      cmd_array = strsplit(BatchTable[k++,i], 'srun ', /EXTRACT, /REGEX)
;      cmd       = 'srun --batch -o none' + cmd_array[0]
;      text    = [text, FP+cmd]
      text    = [text,BatchTable[k++,i]]
      text    = [text, '']
      
    ENDIF
  ENDFOR
  
  file_error = 0
  CATCH, file_error
  IF (file_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    AppendReplaceLogBookMessage, Event, $
      (*global).FAILED, $
      (*global).processing_message
  ENDIF ELSE BEGIN
    ;create output file
    openw,1,FullFileName
    sz = (size(text))[1]
    FOR j=0,(sz-1) DO BEGIN
      printf, 1, text[j]
    ENDFOR
    close,1
    free_lun,1
    AppendReplaceLogBookMessage, Event, 'OK', (*global).processing_message
  ENDELSE
  
  IF (file_error EQ 0) THEN BEGIN
    permission_error = 0
    CATCH, permission_error
    IF (permission_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      LogText = '-> Give execute permission to file created ... FAILED'
    ENDIF ELSE BEGIN
      ;give execute permission to file created
      cmd = 'chmod 755 ' + FullFileName
      spawn, cmd, listening
      LogText = '-> Give execute permission to file created ... OK'
      (*global).BatchFileName = FullFileName
    ENDELSE
    putLogBookMessage, Event, LogText, APPEND=1
    ;Show contain of file
    LogText = '------------- BATCH FILE : ' + FullFileName + ' --------------'
    putLogBookMessage, Event, LogText, APPEND=1
    putLogBookMessage, Event, text, APPEND=1
  ENDIF
END
