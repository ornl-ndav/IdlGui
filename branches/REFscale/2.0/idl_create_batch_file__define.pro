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
    'ColumnIndexes'         : RETURN, 9
    'NbrColumn'             : RETURN, 10
    'RowIndexes'            : RETURN, 19
    'NbrRow'                : RETURN, 20
    'BatchFileHeadingLines' : RETURN, 3
    ELSE:
  ENDCASE
  RETURN, 'NA'
END

;------------------------------------------------------------------------------
;This function takes the name of the output file to create
;and create the Batch output file
FUNCTION CreateBatchFile, Event, FullFileName, BatchTable
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  NbrRow    = (size(BatchTable))(2)
  NbrColumn = (size(BatchTable))(1)
  text      = STRARR(1)
  text[0]   = '#This Batch File has been produced by REFscale ' + $
    (*global).version
  text      = [text,'#Date : ' + idl_send_to_geek_GenerateIsoTimeStamp()]
  text      = [text,'#Ucams : ' + (*global).ucams]
  text      = [text,'']

;  data_spin_states = (*(*global).data_spin_state)
;  norm_spin_states = (*(*global).norm_spin_state)
  
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
      text    = [text,'#Data_Runs : '  + BatchTable[k++,i]]
 ;     text    = [text,'#Data_Spin_States : ' + data_spin_states[i]]
      text    = [text,'#Norm_Runs : '  + BatchTable[k++,i]]
;      text    = [text,'#Norm_Spin_States : ' + norm_spin_states[i]]
      text    = [text,'#EC_Runs : '    + BatchTable[k++,i]]
      text    = [text,'#Angle(deg) : ' + BatchTable[k++,i]]
      text    = [text,'#S1(mm) : '     + BatchTable[k++,i]]
      text    = [text,'#S2(mm) : '     + BatchTable[k++,i]]
      text    = [text,'#Date : '       + BatchTable[k++,i]]
      text    = [text,'#SF : '         + $
        STRCOMPRESS(BatchTable[k++,i],/REMOVE_ALL)]
      ;add --batch flag to command line
      cmd_array = strsplit(BatchTable[k++,i], 'srun ', /EXTRACT, /REGEX)
      nbr_ele = n_elements(cmd_array)
      if (nbr_ele gt 1) then begin
        for j=0,nbr_ele-1 do begin
          cmd_array[j] = 'srun --batch -o none ' + cmd_array[j]
        endfor
        cmd = strjoin(cmd_array,' ')
      endif else begin
        cmd = 'srun --batch -o none ' + cmd_array[0]
      endelse
      text      = [text, FP+cmd]
      text      = [text, '']
    ENDIF
  ENDFOR
  
  ;put message about process
  LogText = '-> Creating Batch File ... ' + (*global).processing
  idl_send_to_geek_addLogBookText, Event, LogText
  
  file_error = 0
  CATCH, file_error
  IF (file_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    idl_send_to_geek_ReplaceLogBookText, $
      Event, $
      (*global).processing, $
      (*global).failed
    msg = ['SAVE ' + FullFileName + ' FAILED !',$
      '>> Please Check LogBook <<']
    title = 'SAVE PROCESS FAILED'
    dialog_id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
    result = DIALOG_MESSAGE(msg,$
      /ERROR, $
      TITLE=title,$
      /center,$
      dialog_parent=dialog_id)
    RETURN, 0
  ENDIF ELSE BEGIN
    ;create output file
    openw,1,FullFileName
    sz = (SIZE(text))(1)
    FOR j=0,(sz-1) DO BEGIN
      PRINTF, 1, text[j]
    ENDFOR
    close,1
    free_lun,1
    idl_send_to_geek_ReplaceLogBookText, $
      Event, $
      (*global).processing, $
      (*global).ok
  ENDELSE
  
  IF (file_error EQ 0) THEN BEGIN
    permission_error = 0
    CATCH, permission_error
    IF (permission_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      LogText = '-> Change file permission (->755) ... FAILED'
    ENDIF ELSE BEGIN
      ;give execute permission to file created
      cmd = 'chmod 755 ' + FullFileName
      spawn, cmd, listening, err_listening
      IF (err_listening[0] NE '') THEN BEGIN
        LogText = '-> Change file permission (->755) ... FAILED'
        idl_send_to_geek_addLogBookText, Event, LogText
        spawn, 'ls -l ' + FullFileName, listening
        LogText = '-> ls -l <FileName> : ' + listening
        idl_send_to_geek_addLogBookText, Event, LogText
      ENDIF ELSE BEGIN
        LogText = '-> Change file permission (->755) ... OK'
        idl_send_to_geek_addLogBookText, Event, LogText
        (*global).BatchFileName = FullFileName
      ENDELSE
    ENDELSE
  ENDIF
  RETURN, 1
END


;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION idl_create_batch_file::init, Event, BatchFileName, BatchTable
  status = CreateBatchFile(Event, BatchFileName, BatchTable)
  IF (status EQ 0) THEN RETURN, 0
  RETURN,1
END

;******************************************************************************
;******  Class Define ****;****************************************************
PRO idl_create_batch_file__define
  struct = {idl_create_batch_file,$
    BatchTable: STRARR(9,20),$
    value:      ''}
END
;******************************************************************************
;******************************************************************************


