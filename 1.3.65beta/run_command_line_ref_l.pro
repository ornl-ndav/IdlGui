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

PRO run_command_line_ref_l, Event

  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  PROCESSING = (*global).processing_message ;processing message
  
  status_text = 'Data Reduction ........ ' + PROCESSING
  putTextFieldValue, event, 'data_reduction_status_text_field', status_text, 0
  
  ;check the run numbers and replace them by full nexus path
  ;check first DATA run numbers
  ReplaceDataRunNumbersByFullPath, Event
  ;check second NORM run numbers
  IF (isReductionWithNormalization(Event)) THEN BEGIN
    ReplaceNormRunNumbersByFullPath, Event
  ENDIF
  
  ;re-run the CommandLineGenerator
  REFreduction_CommandLineGenerator, Event
  
  ;disable RunCommandLine
  ActivateWidget, Event,'start_data_reduction_button', 0
  
  ;get command line to generate
  cmd = getTextFieldValue(Event,'reduce_cmd_line_preview')
  
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/hourglass
  
  ;display command line in log-book
  cmd_text = 'Running Command Line:'
  putLogBookMessage, Event, cmd_text, Append=1
  cmd_text = ' -> ' + cmd
  putLogBookMessage, Event, cmd_text, Append=1
  cmd_text = '......... ' + PROCESSING
  putLogBookMessage, Event, cmd_text, Append=1
  
  SPAWN, cmd, listening, err_listening
  
  IF (err_listening[0] NE '') THEN BEGIN
  
    (*global).DataReductionStatus = 'ERROR'
    LogBookText = getLogBookText(Event)
    Message = '* ERROR! *'
    putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING
    ErrorLabel = 'ERROR MESSAGE:'
    putLogBookMessage, Event, ErrorLabel, Append=1
    putLogBookMessage, Event, err_listening, Append=1
    
    status_text = 'Data Reduction ........ ERROR! (-> Check Log Book)'
    putTextFieldValue, event, 'data_reduction_status_text_field', $
      status_text, 0
      
  ENDIF ELSE BEGIN
  
    (*global).DataReductionStatus = 'OK'
    LogBookText = getLogBookText(Event)
    Message = 'Done'
    putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING
    
    status_text = 'Data Reduction ........ DONE'
    putTextFieldValue, event, 'data_reduction_status_text_field', $
      status_text, 0
      
    ;   IF ((*global).debugger) THEN BEGIN
    ;We can retrieve info for Batch Tab
    RetrieveBatchInfoAtLoading, Event
    ;   ENDIF
    PopulateBatchTableWithCMDinfo, Event, cmd ;_BatchTab
    
  ENDELSE
  
  ;disable RunCommandLine
  ActivateWidget, Event,'start_data_reduction_button', 1
  
  ;turn off hourglass
  WIDGET_CONTROL,hourglass=0
  
END
