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

PRO define_input_folder_tab2, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='MAIN_BASE')
  
  path = (*global).ascii_input_path
  title = 'Select the Input folder'
  
  folder = DIALOG_PICKFILE(/DIRECTORY,$
    DIALOG_PARENT=id,$
    /MUST_EXIST,$
    TITLE = title,$
    PATH = path)
    
  IF (folder NE '') THEN BEGIN
    (*global).ascii_input_path = folder
    putButtonValue, Event, 'tab2_manual_input_folder', folder
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO define_output_folder_tab2, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='MAIN_BASE')
  
  path = (*global).ascii_path
  title = 'Select the output folder'
  
  folder = DIALOG_PICKFILE(/DIRECTORY,$
    DIALOG_PARENT=id,$
    /MUST_EXIST,$
    TITLE = title,$
    PATH = path)
    
  IF (folder NE '') THEN BEGIN
    (*global).ascii_path = folder
    putButtonValue, Event, 'tab2_output_folder_button_uname', folder
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO populate_tab2, Event

  PRINT, 'in populate_tab2'
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  tab2_table = (*(*global).tab2_table)
  HELP, tab2_table
  PRINT, tab2_table
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    refresh_button_status = 0
  ENDIF ELSE BEGIN
    ;get table
    tab2_table = (*(*global).tab2_table)
    sz = (SIZE(tab2_table))(2)
    index = 0
    WHILE (index LT sz AND $
    STRCOMPRESS(tab2_table[0,index],/REMOVE_ALL) NE '') DO BEGIN
      IF (FILE_TEST(tab2_table[0,index])) THEN BEGIN
        message = 'READY'
      ENDIF ELSE BEGIN
        message = 'NOT READY'
      ENDELSE
      tab2_table[1,index] = message
      index++
    ENDWHILE
    putValue, Event, 'tab2_table_uname', tab2_table
    refresh_button_status = 1
  ENDELSE
  activate_widget, Event, 'tab2_refresh_table_uname', refresh_button_status
  check_tab2_run_jobs_button, Event
END

;------------------------------------------------------------------------------
PRO update_temperature, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  error = 0
  ; CATCH, error ;remove_me (important if user try to edit STATUS column
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
  ENDIF ELSE BEGIN
  
    ;get table value
    table = getTableValue(Event,'tab2_table_uname')
    ;    PRINT, SIZE(table)
    nbr_row = (SIZE(table))(2)
    
    ;get row and column edited
    rc_array = getCellSelectedTab1(Event, 'tab2_table_uname')
    column = rc_array[0]
    row = rc_array[1]
    
    ;continue work only if column 2 is selected
    IF (column EQ 2) THEN BEGIN
    
      CASE (row) OF
        0: TABLE[2,0] = STRCOMPRESS(FLOAT(table[2,0]))
        ELSE: BEGIN
          table[2,row] = STRCOMPRESS(FLOAT(table[2,row]))
          IF (row LT (nbr_row - 1)) THEN BEGIN
            increment = FLOAT(table[2,row]) - FLOAT(table[2,row-1])
            index = (row+1)
            WHILE (index LT nbr_row) DO BEGIN
              table[2,index] = STRCOMPRESS(table[2,index-1] + increment)
              index++
            ENDWHILE
          ENDIF
        END
      ENDCASE
      
      putValue, Event, 'tab2_table_uname', table
      
    ENDIF
    
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO createCLsOfRunsSequence_tab2, Event, seq_number, CL_text_array
  ;  print, '***** entering createCLsOfRunSequence *****'
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  column_sequence = (*(*global).column_sequence)
  column_cl       = (*(*global).column_cl)
  
  sz = N_ELEMENTS(seq_number)
  index = 0
  WHILE (index LT sz) DO BEGIN
    nbr_row = (SIZE(column_sequence))(1)
    
    IF (column_sequence[0] EQ '') THEN BEGIN ;table empty
      seq_number_1 = STRCOMPRESS(seq_number[0],/REMOVE_ALL)
      column_sequence = [seq_number_1]
      column_cl = [CL_text_array[0] + seq_number_1 + CL_text_array[1]]
    ENDIF ELSE BEGIN
      seq_number_1 = STRCOMPRESS(seq_number[index],/REMOVE_ALL)
      column_sequence = [column_sequence, seq_number_1]
      new_cl = CL_text_array[0] + seq_number_1 + CL_text_array[1]
      column_cl = [column_cl, new_cl]
    ENDELSE
    
    index++
  ENDWHILE
  
  (*(*global).column_sequence) = column_sequence
  (*(*global).column_cl) = column_cl
  
;  print, '***** leaving createCLsOfRunSequence****'
END

;------------------------------------------------------------------------------
PRO createCLOfRunSequence_tab2, Event, seq_number, CL_text_array
  ;  print, '***** entering createCLOfRunsSequence *****'
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  seq_number = STRJOIN(seq_number,',')
  seq_number = STRCOMPRESS(seq_number,/REMOVE_ALL)
  
  column_sequence = (*(*global).column_sequence)
  column_cl       = (*(*global).column_cl)
  
  IF (column_sequence[0] EQ '') THEN BEGIN ;table empty
    column_sequence = [seq_number]
    column_cl[0] = CL_text_array[0] + seq_number + CL_text_array[1]
  ENDIF ELSE BEGIN
    column_sequence = [column_sequence, seq_number]
    new_cl = CL_text_array[0] + seq_number + CL_text_array[1]
    column_cl = [column_cl, new_cl]
  ENDELSE
  
  (*(*global).column_sequence) = column_sequence
  (*(*global).column_cl) = column_cl
;  print, '***** leaving createCLOfRunsSequence *****'
END

;------------------------------------------------------------------------------
PRO parse_input_field_tab2, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;reinitialize column_sequence and column_cl
  (*global).column_sequence_tab2 = PTR_NEW(0L)
  (*global).column_file_name_tab2 = PTR_NEW(0L)
  
  input_text = getTextFieldValue(Event,'tab2_manual_input_sequence')
  
  ;remove ',,' if any
  input_text = replaceString(input_text,FIND=",,",REPLACE=",")
  
  ;remove [cr]
  input_text = STRCOMPRESS(input_text,/REMOVE_ALL)
  
  ;create column_sequence_tab2
  ;ex:  10,20-22,[30,35,37]
  ;column_sequence_tab2 = ['10',
  ;                        '20',
  ;                        '21',
  ;                        '22',
  ;                        '30,35,37']
  
  cursor_0 = STRMID(input_text, 0, 1) ;retrieve first character of line
  IF (cursor_0 EQ '[') THEN BEGIN
    same_run = 1b
    left     = ''
  ENDIF ELSE BEGIN
    same_run = 0b
    left     = cursor_0
  ENDELSE
  right   = ''
  cur_ope = '' ;'-' or ''
  tmp_seq_number = ['']   ;when working with same_run
  column_seq_number = ['']  ;1 element per run (not same_run)
  last_cursor_is_number = 1b
  
  length = STRLEN(input_text)
  index = 1
  WHILE (index LT length) DO BEGIN
  
    ;current cursor value
    cursor = STRMID(input_text, index, 1)
    
    CASE (cursor) OF
      '0': addNumber, left, right, cursor, cur_ope, last_cursor_is_number
      '1': addNumber, left, right, cursor, cur_ope, last_cursor_is_number
      '2': addNumber, left, right, cursor, cur_ope, last_cursor_is_number
      '3': addNumber, left, right, cursor, cur_ope, last_cursor_is_number
      '4': addNumber, left, right, cursor, cur_ope, last_cursor_is_number
      '5': addNumber, left, right, cursor, cur_ope, last_cursor_is_number
      '6': addNumber, left, right, cursor, cur_ope, last_cursor_is_number
      '7': addNumber, left, right, cursor, cur_ope, last_cursor_is_number
      '8': addNumber, left, right, cursor, cur_ope, last_cursor_is_number
      '9': addNumber, left, right, cursor, cur_ope, last_cursor_is_number
      '-': BEGIN
        cur_ope = '-'
        last_cursor_is_number = 0b
      END
      ',': BEGIN
        IF (cur_ope EQ '-') THEN BEGIN ;sequence of numbers
          seq_number = getSequence(left, right)
        ENDIF ELSE BEGIN
          seq_number = left
        ENDELSE
        IF (same_run) THEN BEGIN
          add_seq_number_to_same_seq_number, tmp_seq_number, seq_number
        ENDIF ELSE BEGIN
          add_seq_number_to_global_seq_number, column_seq_number,seq_number
        ENDELSE
        right    = ''     ;reinitialize right number
        left     = ''
        cur_ope  = ''     ;reinitialize operation in progress
        cur_numb = 'left' ;we will now work on the left number again
        full_reset, left, right, cur_ope
        last_cursor_is_number = 0b
      END
      '[': BEGIN
        full_reset, left, right, cur_ope
        tmp_seq_number = ['']
        same_run = 1b
        last_cursor_is_number = 0b
      END
      ']': BEGIN
        IF (cur_ope EQ '-') THEN BEGIN ;sequence of numbers
          seq_number = getSequence(left, right)
        ENDIF ELSE BEGIN
          seq_number = left
        ENDELSE
        add_seq_number_to_same_seq_number, tmp_seq_number, seq_number
        add_seq_number_to_global_seq_number, column_seq_number, tmp_seq_number
        full_reset, left, right, cur_ope
        same_run = 0b
        last_cursor_is_number = 0b
        tmp_seq_number = ''
      END
      ELSE: ;[ENTER]
    ENDCASE
    
    index++
  ENDWHILE
  
  IF (last_cursor_is_number EQ 1b) THEN BEGIN
    IF (cur_ope EQ '-') THEN BEGIN ;sequence of numbers
      seq_number = getSequence(left, right)
    ENDIF ELSE BEGIN
      seq_number = left
    ENDELSE
    add_seq_number_to_global_seq_number, tmp_seq_number, seq_number
    add_seq_number_to_global_seq_number, column_seq_number, tmp_seq_number
  ENDIF
  
  ;get path, prefix and suffix for output files
  path   = getButtonValue(Event,'tab2_manual_input_folder')
  prefix = getTextFieldValue(Event,'tab2_manual_input_suffix_name')
  suffix = getTextFieldValue(Event,'tab2_manual_input_prefix_name')
  
  nbr_files = N_ELEMENTS(column_seq_number)
  table = STRARR(3,nbr_files)
  index = 0
  table_index = 0
  WHILE (index LT nbr_files) DO BEGIN
    IF (column_seq_number[index] NE '') THEN BEGIN
      ;check if there are several runs
      seq_array = STRSPLIT(column_seq_number[index],',',/EXTRACT)
      nbr = N_ELEMENTS(seq_array)
      CASE (nbr) OF
        1: add_string = column_seq_number[index] + '_1run'
        ELSE: add_string = seq_array[0] + '_' + STRCOMPRESS(nbr,/REMOVE_ALL) + $
          'runs'
      ENDCASE
      
      ;update big table
      file_name = path + prefix + '_' + add_string + '.' + suffix
      table[0,table_index]= file_name
      IF (FILE_TEST(file_name)) THEN BEGIN
        message = 'READY'
      ENDIF ELSE BEGIN
        message = 'NOT READY'
      ENDELSE
      table[1,table_index] = message
      table_index++
      
    ENDIF
    index++
  ENDWHILE
  
  ;check that Manual Input is selected
  IF (isLooperInputSelected(Event)) THEN BEGIN ;looper selected
    message_text = 'Switch to MANUAL input and take into account ' + $
      '<user_defined> runs ?'
    title = 'Conflict in the Input Selection!'
    result = DIALOG_MESSAGE(message_text,$
      TITLE=title,$
      /QUESTION)
    IF (result EQ 'Yes') THEN BEGIN ;switch to manual input
      putValue, Event,'tab2_table_uname', table
      id = WIDGET_INFO(Event.top, FIND_BY_UNAME='tab2_use_manual_input')
      WIDGET_CONTROL, id, /SET_BUTTON
    ENDIF
  ENDIF ELSE BEGIN
    putValue, Event,'tab2_table_uname', table
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO TMP
;sz = N_ELEMENTS(column_sequence)
;Table = STRARR(3,sz)
;Table[0,*] = column_cl[*]
;  Table[1,*] =
;id = WIDGET_INFO(Event.top,FIND_BY_UNAME='tab2_table_uname')
;WIDGET_CONTROL, id, TABLE_YSIZE = sz
;putValue, Event, 'tab2_table_uname', Table

;  ;activate or not the 'Launch Jobs in Background'
;  IF (column_sequence[0] NE '') THEN BEGIN
;    status = 1
;  ENDIF ELSE BEGIN
;    status = 0
;  ENDELSE
;  activate_widget, Event, 'run_jobs_button', status
;  activate_widget, Event, 'preview_jobs_button', status
END

;------------------------------------------------------------------------------
;This function adds the cursor to the left number if the current operator
;is not '-' otherwise it's added to the right operator
PRO addNumber, left, right, cursor, cur_ope, last_cursor_is_number
  IF (cur_ope EQ '-') THEN BEGIN ;add cursor to right number
    right += cursor
  ENDIF ELSE BEGIN ;add cursor to left number
    left += cursor
  ENDELSE
  last_cursor_is_number = 1b
END

;------------------------------------------------------------------------------
PRO full_reset, left, right, cur_ope
  left = ''
  right = ''
  cur_ope = ''
END

;------------------------------------------------------------------------------
PRO add_seq_number_to_global_seq_number, tmp_seq_number, seq_number
  IF (tmp_seq_number[0] EQ '') THEN BEGIN
    tmp_seq_number = STRCOMPRESS(seq_number,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    tmp_seq_number = [tmp_seq_number,STRCOMPRESS(seq_number,/REMOVE_ALL)]
  ENDELSE
END

;------------------------------------------------------------------------------
PRO add_seq_number_to_same_seq_number, tmp_seq_number, seq_number
  sz = N_ELEMENTS(seq_number)
  index = 0
  WHILE (index LT sz) DO BEGIN
    IF (tmp_seq_number NE '') THEN BEGIN
      tmp_seq_number += ',' + STRCOMPRESS(seq_number[index],/REMOVE_ALL)
    ENDIF ELSE BEGIN
      tmp_seq_number = STRCOMPRESS(seq_number[index],/REMOVE_ALL)
    ENDELSE
    index++
  ENDWHILE
END

;------------------------------------------------------------------------------
PRO check_tab2_run_jobs_button, Event

  ;get table value
  table = getTableValue(Event, 'tab2_table_uname')
  sz = (SIZE(table))(2)
  
  ;check that all the files exist and temperature defined
  index = 0
  WHILE (index LT sz AND $
    STRCOMPRESS(table[0,index],/REMOVE_ALL) NE '') DO BEGIN
    IF (~FILE_TEST(table[0,index])) THEN BEGIN
      activate_widget, Event, 'tab2_run_jobs_uname', 0
      RETURN
    ENDIF
    IF (STRCOMPRESS(table[2,index],/REMOVE_ALL) EQ '') THEN BEGIN
      activate_widget, Event, 'tab2_run_jobs_uname', 0
      RETURN
    ENDIF
    index++
  ENDWHILE
  
  ;check that there is an output file name
  output_file_name = getTextFieldValue(Event,$
    'tab2_output_file_name_text_field_uname')
  IF (STRCOMPRESS(output_file_name,/REMOVE_ALL) EQ '') THEN BEGIN
    activate_widget, Event, 'tab2_run_jobs_uname', 0
    RETURN
  ENDIF
  
  ;check that there is a min and max energy Integration Range
  energy_min = getTextFieldValue(Event,'energy_integration_range_min_value')
  IF (STRCOMPRESS(energy_min,/REMOVE_ALL) EQ '') THEN BEGIN
    activate_widget, Event, 'tab2_run_jobs_uname', 0
    RETURN
  ENDIF
  energy_max = getTextFieldValue(Event,'energy_integration_range_max_value')
  IF (STRCOMPRESS(energy_max,/REMOVE_ALL) EQ '') THEN BEGIN
    activate_widget, Event, 'tab2_run_jobs_uname', 0
    RETURN
  ENDIF
  
  
  
  
END


