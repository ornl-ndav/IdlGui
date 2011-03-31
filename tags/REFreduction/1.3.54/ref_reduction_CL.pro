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
PRO ActivateOutputButtonStatus, Event
  output_path = getTextFieldValue(Event,'cl_directory_text')
  output_name = getTextFieldValue(Event,'cl_file_text')
  IF (FILE_TEST(output_path,/DIRECTORY) AND $
    output_name NE '') THEN BEGIN
    activate_status = 1
  ENDIF ELSE BEGIN
    activate_status = 0
  ENDELSE
  ActivateWidget, Event, 'output_cl_button', activate_status
END


;REACH by 'CL DIRECTORY ...' button
PRO CL_directoryButton, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;get default cl_ouput_path
  path  = (*global).cl_output_path
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
  title = 'Select a place where to put the file...'
  output_path = DIALOG_PICKFILE(PATH  = path,$
    dialog_parent=widget_id,$
    TITLE = title,$
    /DIRECTORY)
  ;do something only if output_path is not empty and
  ;if it exists
  IF (output_path NE '' AND $
    FILE_TEST(output_path,/DIRECTORY)) THEN BEGIN
    putTextFieldValue, event, 'cl_directory_text', output_path, 0
  ENDIF
  ActivateOutputButtonStatus, Event
END


;REACH by the CL directory text
PRO CL_directoryText, Event
  ActivateOutputButtonStatus, Event
END


;REACH by 'CL FILE ...' button
PRO CL_fileButton, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  ;get default cl_file_ext
  filter = (*global).cl_file_ext3
  path   = (*global).cl_output_path
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
  title  = 'Select file name that will contain the command line text...'
  output_file = DIALOG_PICKFILE(PATH = path,$
  dialog_parent=widget_id,$
    TITLE             = title,$
    FILTER = filter)
  IF (output_file NE '' AND $
    FILE_TEST(output_file)) THEN BEGIN
    ;get only the file name (without full path)
    file_array = strsplit(output_file,'/',COUNT=count,/EXTRACT)
    output_file = file_array[count-1]
    putTextFieldValue, event, 'cl_file_text', output_file, 0
  ENDIF
  ActivateOutputButtonStatus, Event
END


;REACH by the CL file text
PRO CL_fileText, Event
  ActivateOutputButtonStatus, Event
END


;REACH by the 'CREATE COMMAND LINE FILE'
PRO CL_outputButton, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  PROCESSING = (*global).processing_message
  OK         = 'OK'
  FAILED     = 'FAILED'
  
  LogBookText = '> Create file with a copy of the Command Line (CL):'
  putLogBookMessage, Event, LogBookText, Append=1
  ;get output_path and output_filename
  output_path = getTextFieldValue(Event,'cl_directory_text')
  LogBookText = '-> Output path is : ' + output_path
  putLogBookMessage, Event, LogBookText, Append=1
  ;if this one does not exist, create it
  IF (~FILE_TEST(output_path,/directory)) THEN BEGIN
    LogBookText = '--> Checking if output path exist ... NO'
    putLogBookMessage, Event, LogBookText, Append=1
    spawn, 'mkdir ' + output_path, listening, err_listening
    IF (err_listening[0] NE '') THEN BEGIN
      LogBookText = '--> Creating output folder ... FAILED'
      putLogBookMessage, Event, LogBookText, Append=1
      putLogBookMessage, Event, err_listening, Append=1
    ENDIF ELSE BEGIN
      LogBookText = '--> Creating output folder ... OK'
    ENDELSE
  ENDIF ELSE BEGIN
    LogBookText = '--> Checking if output path exist ... YES'
    putLogBookMessage, Event, LogBookText, Append=1
  ENDELSE
  
  output_name = getTextFieldValue(Event,'cl_file_text')
  LogBookText = '-> Output file name is : ' + output_name
  putLogBookMessage, Event, LogBookText, Append=1
  
  full_output_filename = output_path + '/' + output_name
  LogBookText = '-> Full Output file name is : ' + full_output_filename
  putLogBookMessage, Event, LogBookText, Append=1
  
  ;get command line string
  cml_text = getTextFieldValue(Event,'reduce_cmd_line_preview')
  LogBookText = '-> Command line string is : ' + cml_text
  putLogBookMessage, Event, LogBookText, Append=1
  
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    catch,/cancel
    LogBookText = '=> Process FAILED !!
    putLogBookMessage, Event, LogBookText, Append=1
  endif else begin
    ;create file
    openw, 1, full_output_filename
    printf,1,cml_text
    close, 1
    free_lun, 1
    LogBookText = '=> File has been created with success : ' + full_output_filename
    putLogBookMessage, Event, LogBookText, Append=1
  endelse
  
END
