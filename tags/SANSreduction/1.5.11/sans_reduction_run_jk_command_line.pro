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

PRO run_jk_command_line, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,get_uvalue=global
  
  ;check first if the output file already exists and if it does, ask the user
  ;if he wants to continue the process.
  
  root_value = STRCOMPRESS(getTextFieldValue(Event,$
    'reduce_jk_tab2_root_name_extension'),/REMOVE_ALL)
  output_path = STRCOMPRESS(getButtonValue(Event,$
    'reduce_jk_tab2_output_folder_button'),/REMOVE_ALL)
  output_file_name = output_path + root_value
  
  IF (FILE_TEST(output_file_name)) THEN BEGIN ;yes
    result = DIALOG_MESSAGE(['Output File Name exists already !',$
      '','Do You want to replace it ?'],$
      /QUESTION,$
      /DEFAULT_NO,$
      TITLE='Output File Name is not unique !',$
      DIALOG_PARENT=id)
      
    IF (result EQ 'Yes') THEN BEGIN
      RunJKCommandLine, Event
    ENDIF ELSE BEGIN
      RETURN
    ENDELSE
    
  ENDIF ELSE BEGIN
    RunJKCommandLine, Event
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO RunJKCommandLine, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;retrieve infos
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  status_text = "JK's Data Reduction ... " + PROCESSING
  putTextFieldValue, Event, 'data_reduction_status_frame', status_text
  
  ;get command line to generate
  cmd = getTextFieldValue(Event,'comamnd_line_preview')
  
  ;display command line in log-book
  cmd_text = '> Command Line:'
  IDLsendToGeek_addLogBookText, Event, cmd_text
  cmd_text = '-> ' + cmd
  IDLsendToGeek_addLogBookText, Event, cmd_text
  cmd_text = '-> Running Command Line ... ' + PROCESSING
  IDLsendToGeek_addLogBookText, Event, cmd_text
  
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/hourglass
  ;running command
  
  start_time = SYSTIME(1,/SECONDS)
  SPAWN, cmd, listening, err_listening
  end_time = SYSTIME(1,/SECONDS)
  
  IF (err_listening[0] NE '') THEN BEGIN
    ;in log book
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
    logbook_text = 'Information from Verbose Mode:'
    IDLsendToGeek_addLogBookText, Event, listening
    IDLsendToGeek_addLogBookText, Event, err_listening
    ;in status dr frame
    status_text = 'Data Reduction ... FAILED (check log book)!'
    putTextFieldValue, Event, 'data_reduction_status_frame', status_text
  ENDIF ELSE BEGIN
    ;in log book
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
    timing = '-> Reduction ran in ' + $
      STRCOMPRESS(end_time - start_time,/REMOVE_ALL) + ' s'
    IDLsendToGeek_AddLogBookText, Event, timing
    ;in status dr frame
    status_text = 'Data Reduction ... DONE WITH SUCCESS!'
    putTextFieldValue, Event, 'data_reduction_status_frame', status_text
    
    root_value = STRCOMPRESS(getTextFieldValue(Event,$
      'reduce_jk_tab2_root_name_extension'),/REMOVE_ALL)
    output_path = STRCOMPRESS(getButtonValue(Event,$
      'reduce_jk_tab2_output_folder_button'),/REMOVE_ALL)
    output_file_name = output_path + root_value
    
    ;plot Iq if flag is on
    Iq = is_this_button_selected(Event,value='Iq')
    IF (Iq EQ 1) THEN BEGIN
      iq_output = output_file_name + '.iq'
      ;launch plot
      spawn, 'jzg -2 ' + iq_output + ' &'
    ENDIF
    
    ;plot IvQxQy if flag is on
    IvQxQy = is_this_button_selected(Event,value='IvQxQy')
    IF (IvQxQy EQ 1) THEN BEGIN
      ivQxQy_output = output_file_name + '.qxy'
      ;launch plot
      spawn, 'jzg -3m ' + ivQxQy_output + ' &'
    ENDIF
    
  ENDELSE
  
  ;turn off hourglass
  WIDGET_CONTROL,hourglass=0
  
END

