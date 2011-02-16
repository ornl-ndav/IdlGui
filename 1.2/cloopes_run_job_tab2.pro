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

FUNCTION create_cmd, Event

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;cmd = 'srun --batch -p bac2q'
  ;cmd = 'amrun_dev -p bac2q --batch'
  cmd = 'amrun_dev -p bac2q'
  
  ;get driver
  driver = (*global).es_driver
  cmd += ' ' + driver
  
  ;output folder
  output_path = getButtonValue(Event, 'tab2_output_folder_button_uname')
  ;output file name
  output_file_name = getTextFieldValue(Event, $
    'tab2_output_file_name_text_field_uname')
  full_output_file_name = output_path + output_file_name + '.txt'
  cmd += ' --output=' + full_output_file_name
  
  ;add data files
  cmd += ' --data='
  ;get table value
  table = getTableValue(Event, 'tab2_table_uname')
  
  dim = (size(table))(0)
  IF (dim EQ 2) THEN BEGIN ;more than 1 file
  
    ;checking if we are working with increasing T
    temp0 = float(table[2,0])
    temp1 = float(table[2,1])
    delta_temp = temp1 - temp0
    if (delta_temp gt 0) then begin
      bIncreasingTemp = 1b
    endif else begin
      bIncreasingTemp = 0b
    endelse
    
    sz = (SIZE(table))(2)
    first_data = 1
    if (bIncreasingTemp) then begin ;increasing temp
      index = 0
      WHILE (index LT sz) DO BEGIN
        file_name = table[0,index]
        IF (file_name NE '') THEN BEGIN
          IF (first_data) THEN BEGIN
            cmd += file_name
            first_data = 0
          ENDIF ELSE BEGIN
            cmd += ',' + file_name
          ENDELSE
        ENDIF
        index++
      ENDWHILE
    endif else begin ;decreasing temp
      index = sz-1
      while (index ge 0) do begin
        file_name = table[0,index]
        if (file_name ne '') then begin
          if (first_data) then begin
            cmd += file_name
            first_data = 0
          endif else begin
            cmd += ',' + file_name
          endelse
        endif
        index--
      endwhile
    endelse
    
    ;add Energy integration range
    inte_min = getTextFieldValue(Event,'energy_integration_range_min_value')
    inte_max = getTextFieldValue(Event,'energy_integration_range_max_value')
    cmd += ' --int-range=' + STRCOMPRESS(inte_min,/REMOVE_ALL)
    cmd += ' ' + STRCOMPRESS(inte_max,/REMOVE_ALL)
    
    ;add temperature
    cmd += ' --temps='
    ;get table value
    first_data = 1
    if (bIncreasingTemp) then begin ;increasing temp
      index = 0
      WHILE (index LT sz) DO BEGIN
        temperature = STRCOMPRESS(table[2,index],/REMOVE_ALL)
        IF (table[0,index] NE '') THEN BEGIN
          IF (first_data) THEN BEGIN
            cmd += temperature
            first_data = 0
          ENDIF ELSE BEGIN
            cmd += ',' + temperature
          ENDELSE
        ENDIF
        index++
      ENDWHILE
    endif else begin ;decreasing temp
      index = sz-1
      while (index ge 0) do begin
        temperature = STRCOMPRESS(table[2,index],/REMOVE_ALL)
        IF (table[0,index] NE '') THEN BEGIN
          IF (first_data) THEN BEGIN
            cmd += temperature
            first_data = 0
          ENDIF ELSE BEGIN
            cmd += ',' + temperature
          ENDELSE
        ENDIF
        index--
      ENDWHILE
    endelse
    
  ENDIF ELSE BEGIN ;just one file
  
    file_name = table[0]
    cmd += file_name
    
    ;add Energy integration range
    inte_min = getTextFieldValue(Event,'energy_integration_range_min_value')
    inte_max = getTextFieldValue(Event,'energy_integration_range_max_value')
    cmd += ' --int-range=' + STRCOMPRESS(inte_min,/REMOVE_ALL)
    cmd += ' ' + STRCOMPRESS(inte_max,/REMOVE_ALL)
    
    ;add temperature
    cmd += ' --temps='
    temperature = STRCOMPRESS(table[2],/REMOVE_ALL)
    cmd += temperature
    
  ENDELSE
  
  RETURN, cmd
  
END

;+
; :Description:
;    this procedure is executed when the thread is done (command executed)
;
; :Params:
;    status
;    error
;    oBridge
;    userdata
;
;
;
; :Author: j35
;-
pro command_ran, status, error, oBridge, userdata

  ;checked that the first file has been created with success
  isFile1 = file_test(userdata.file1)
  
  ;if the file exists, then we can parsed it to create the second file
  if (isFile1) then begin
  
    create_dave_output_file, input_file=userdata.file1, $
      output_file = userdata.file2
      
    isFile2 = file_test(userdata.file2)
  endif else begin
  
    ;because first file can not be created, the second won't be for sure as well
    isFile2 = 0
    
  endelse
  file1_status = (isFile1 eq 1) ? 'OK' : 'FAILED!'
  file2_status = (isFile2 eq 1) ? 'OK' : 'FAILED!'
  
  message_text = ['Following status of the files created:',$
    '',' -> ' + userdata.file1 + ' ... ' + file1_status, $
    ' -> ' + userdata.file2 + ' ... ' + file2_status]
    
  result = dialog_message(message_text, $
    title='Jobs done!', $
    /center, $
    dialog_parent=userdata.topId,$
    /information)
    
  ;activate or not preview buttons
  event = userdata.event
  if (isFile1) then begin
  activate_widget, event, 'tab2_preview_txt_file', 1
  endif else begin
  activate_widget, event, 'tab2_preview_txt_file', 0
  endelse
  
  if (isFile2) then begin
  activate_widget, event, 'tab2_preview_fordave_txt_file',1
  endif else begin
  activate_widget, event, 'tab2_preview_fordave_txt_file',0
  endelse
    
end

;+
; :Description:
;    This run the job from tab #2
;
; :Params:
;    Event
;
; :Author: j35
;-
PRO run_job_tab2, Event
  compile_opt idl2
  
  widget_control, /hourglass
  
  ;get name of files that will be created
  path = getTextFieldValue(event,'tab2_output_folder_button_uname')
  file = getTextFieldValue(event,'tab2_output_file_name_text_field_uname')
  file1 = path + file + '.txt'
  file2 = path + file + '.hscn'
  
  file1 = file1[0]
  file2 = file2[0]
  
  test_file1 = file_test(file1)
  test_file2 = file_test(file2)
  if (test_file1 || test_file2) then begin
    message_text = ['  The following file(s) already exist on your computer:  ']
    if (test_file1) then begin
      message_text = [message_text,'    -> ' + file1]
    endif
    if (test_file2) then begin
      message_text = [message_text, '    -> ' + file2]
    endif
    message_text = [message_text, ' ', 'Do you want to replace them?']
    id = widget_info(event.top, find_by_uname='MAIN_BASE')
    result = dialog_message(message_text, $
      /center, $
      dialog_parent = id, $
      title = 'File(s) with same name(s) found!', $
      /question)
      
    if (result eq 'No') then begin
      widget_control, hourglass=0
      return
    endif
    
  endif
  
  cmd = create_cmd(Event)
  
  ;output folder
  output_path = getButtonValue(Event, 'tab2_output_folder_button_uname')
  CD, output_path, CURRENT=old_path
  
  cmd_text = '-> Launching job: '
  cmd_text += cmd
  IDLsendLogBook_addLogBookText, Event, ALT=alt, cmd_text
  
  spawn, cmd, listening, error_listening
  cd, old_path

  widget_control, hourglass=0

  ;checked that the first file has been created with success
  isFile1 = file_test(file1)
  
  ;if the file exists, then we can parsed it to create the second file
  if (isFile1) then begin
  
    create_dave_output_file, input_file=file1, output_file = file2
    isFile2 = file_test(file2)

  endif else begin
  
    ;because first file can not be created, the second won't be for sure as well
    isFile2 = 0
    
  endelse
  file1_status = (isFile1 eq 1) ? 'OK' : 'FAILED!'
  file2_status = (isFile2 eq 1) ? 'OK' : 'FAILED!'
  
  message_text = ['Following status of the files created:',$
    '',' -> ' + file1 + ' ... ' + file1_status, $
       ' -> ' + file2 + ' ... ' + file2_status]
    
  topId = widget_info(event.top,find_by_uname='MAIN_BASE')
  result = dialog_message(message_text, $
    title='Jobs done!', $
    /center, $
    dialog_parent=topId,$
    /information)
    
  ;activate or not preview buttons
  if (isFile1) then begin
    activate_widget, event, 'tab2_preview_txt_file', 1
  endif else begin
  activate_widget, event, 'tab2_preview_txt_file', 0
  endelse
  
  if (isFile2) then begin
  activate_widget, event, 'tab2_preview_fordave_txt_file',1
  endif else begin
  activate_widget, event, 'tab2_preview_fordave_txt_file',0
  endelse
        
end





