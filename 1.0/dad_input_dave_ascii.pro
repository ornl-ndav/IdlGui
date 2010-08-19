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

;------------------------------------------------------------------------------
FUNCTION replaceString, text, FIND=find, REPLACE=replace
  str = STRSPLIT(text, FIND, /EXTRACT, /REGEX)
  new_str = STRJOIN(str, REPLACE)
  RETURN, new_str
END

;------------------------------------------------------------------------------
FUNCTION getSequence, left, right

  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ['']
  ENDIF ELSE BEGIN
    ON_IOERROR, done
    iLeft  = FIX(left)
    iRight = FIX(right)
    sequence = INDGEN(iRight-iLeft+1)+iLeft
    RETURN, STRING(sequence)
    done:
    RETURN, [STRCOMPRESS(left,/REMOVE_ALL)]
  ENDELSE
END

;------------------------------------------------------------------------------
PRO createCLsOfRunSequence, Event, seq_number, CL_text_array
  ;  print, '***** entering createCLsOfRunSequence *****'
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  column_sequence = (*(*global).column_sequence)
  column_cl       = (*(*global).column_cl)
  
  sz = N_ELEMENTS(seq_number)
  index = 0
  WHILE (index LT sz) DO BEGIN
    nbr_row = (size(column_sequence))(1)
    
    IF (column_sequence[0] EQ '') THEN BEGIN ;table empty
      seq_number_1 = STRCOMPRESS(seq_number[0],/REMOVE_ALL)
      column_sequence = [seq_number_1]
      column_cl = [CL_text_array[0] + seq_number_1 + ' ' + $
        CL_text_array[1]]
    ENDIF ELSE BEGIN
      seq_number_1 = STRCOMPRESS(seq_number[index],/REMOVE_ALL)
      column_sequence = [column_sequence, seq_number_1]
      new_cl = CL_text_array[0] + seq_number_1 + ' ' + CL_text_array[1]
      column_cl = [column_cl, new_cl]
    ENDELSE
    
    index++
  ENDWHILE
  
  (*(*global).column_sequence) = column_sequence
  (*(*global).column_cl) = column_cl
  
;  print, '***** leaving createCLsOfRunSequence****'
END

;------------------------------------------------------------------------------
PRO input_dave_ascii_path_button, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  path = (*global).default_path
  title = 'Select Input Path'
  widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  result = DIALOG_PICKFILE(/DIRECTORY, $
    DIALOG_PARENT = widget_id, $
    /MUST_EXIST, $
    path = path,$
    TITLE = title)
    
  IF (result[0] NE '')  THEN BEGIN
    putValue, Event, 'browse_path_button', result[0]
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO parse_input_field_tab2, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;reinitialize column_sequence and column_cl
  (*global).column_file_name_tab2 = PTR_NEW(0L)
  
  input_text = getTextFieldValue(Event,'input_sequence')
  
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
  path   = getButtonValue(Event,'browse_path_button')
  prefix = getTextFieldValue(Event,'input_suffix_name')
  suffix = getTextFieldValue(Event,'input_prefix_name')
  
  nbr_files = N_ELEMENTS(column_seq_number)
  table = STRARR(4,nbr_files)
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
      file_name_first_part = path + prefix + '_' + add_string
      file_name = file_name_first_part + '.' + suffix
      table[0,table_index]= file_name
      IF (FILE_TEST(file_name)) THEN BEGIN
        message = 'FOUND'
      ENDIF ELSE BEGIN
        message = 'NOT FOUND'
      ENDELSE
      table[1,table_index] = message
      
      ;define name of output file
      output_file_name = file_name_first_part + '_divided'
      output_file_name += '.' + suffix
      table[2,table_index]= output_file_name
      
      table_index++
      
    ENDIF
    index++
  ENDWHILE
  
  IF (nbr_files GT 0 AND $
    table[0,0] NE '') THEN BEGIN
    activate_widget, Event, 'refresh_table_uname', 1
  ENDIF ELSE BEGIN
    activate_widget, Event, 'refresh_table_uname', 0
  ENDELSE
  
  putValue, Event,'table_uname', table
  
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
PRO add_seq_number_to_global_seq_number, tmp_seq_number, seq_number
  IF (tmp_seq_number[0] EQ '') THEN BEGIN
    tmp_seq_number = STRCOMPRESS(seq_number,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    tmp_seq_number = [tmp_seq_number,STRCOMPRESS(seq_number,/REMOVE_ALL)]
  ENDELSE
END

;------------------------------------------------------------------------------
PRO full_reset, left, right, cur_ope
  left = ''
  right = ''
  cur_ope = ''
END

;------------------------------------------------------------------------------
PRO help_button, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  IF (Event.select EQ 1) THEN BEGIN ;button pressed
    old_input_text = getTextFieldValue(Event,'input_sequence')
    (*(*global).old_input_text) = old_input_text
    new_input_text = '[1001-1003,1010],1020,1025-1027'
    putValue, Event, 'input_sequence', new_input_text
  ENDIF ELSE BEGIN ;button released
    new_input_text = (*(*global).old_input_text)
    putValue, Event, 'input_sequence', new_input_text
  ENDELSE
  
END
