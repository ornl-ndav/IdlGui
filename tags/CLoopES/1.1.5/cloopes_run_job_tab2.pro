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
  
  cmd = 'srun --batch -p bac2q'
  
  ;get driver
  driver = (*global).es_driver
  cmd += ' ' + driver
  
  ;output folder
  output_path = getButtonValue(Event, 'tab2_output_folder_button_uname')
  ;output file name
  output_file_name = getTextFieldValue(Event, $
    'tab2_output_file_name_text_field_uname')
  full_output_file_name = output_path + output_file_name
  cmd += ' --output=' + full_output_file_name
  
  ;add data files
  cmd += ' --data='
  ;get table value
  table = getTableValue(Event, 'tab2_table_uname')
  
  dim = (size(table))(0)
  IF (dim EQ 2) THEN BEGIN ;more than 1 file
    sz = (SIZE(table))(2)
    index = 0
    first_data = 1
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
    
    ;add Energy integration range
    inte_min = getTextFieldValue(Event,'energy_integration_range_min_value')
    inte_max = getTextFieldValue(Event,'energy_integration_range_max_value')
    cmd += ' --int-range=' + STRCOMPRESS(inte_min,/REMOVE_ALL)
    cmd += ' ' + STRCOMPRESS(inte_max,/REMOVE_ALL)
    
    ;add temperature
    cmd += ' --temps='
    ;get table value
    index = 0
    first_data = 1
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
    
  ENDIF ELSE BEGIN
  
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

;------------------------------------------------------------------------------
PRO run_job_tab2, Event

  cmd = create_cmd(Event)
  
  output_path = getButtonValue(Event, 'tab2_output_folder_button_uname')
  cd, output_path
  
  cmd_text = '-> Launching job: '
  cmd_text += cmd
  IDLsendLogBook_addLogBookText, Event, ALT=alt, cmd_text
  SPAWN, cmd
  
END
