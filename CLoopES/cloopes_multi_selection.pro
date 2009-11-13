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

PRO Create_step1_big_table, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  error_status = 0 ;by default, everything is fine
  
  cl_with_fields= (*global).cl_with_fields
  sequence_field1 = (*(*global).sequence_field1)
  sequence_field2 = (*(*global).sequence_field2)
  sequence_field3 = (*(*global).sequence_field3)
  
  sz1 = (size(sequence_field1))(1)
  sz2 = (size(sequence_field2))(1)
  sz3 = (size(sequence_field3))(1)
  
  ;check which selection fields have been validated (1:yes, 0:no)
  field1_status = isSelectionButtonActive(Event, BUTTON=1)
  field2_status = isSelectionButtonActive(Event, BUTTON=2)
  field3_status = isSelectionButtonActive(Event, BUTTON=3)
  
  ;if sum NE 1 then we need to be sure they have the same size
  total_fields = field1_status+field2_status+field3_status
  IF (total_fields NE 1) THEN BEGIN
    sum = 0
    ;make sure that if the replaced_by is empty (sz=1) we are not adding sum
    IF (field1_status) THEN BEGIN
      IF (sz1 EQ 1) THEN BEGIN
        IF (sequence_field1[0]NE '') THEN sum += sz1
      ENDIF ELSE BEGIN
        sum += sz1
      ENDELSE
    ENDIF
    
    IF (field2_status) THEN BEGIN
      IF (sz2 EQ 1) THEN BEGIN
        IF (sequence_field2[0]NE '') THEN sum += sz2
      ENDIF ELSE BEGIN
        sum += sz2
      ENDELSE
    ENDIF
    
    IF (field3_status) THEN BEGIN
      IF (sz3 EQ 1) THEN BEGIN
        IF (sequence_field3[0]NE '') THEN sum += sz3
      ENDIF ELSE BEGIN
        sum += sz3
      ENDELSE
    ENDIF
    
    IF (field1_status) THEN BEGIN
      IF (sz1 NE sum/total_fields) THEN error_status = 1
    ENDIF
    IF (field2_status) THEN BEGIN
      IF (sz2 NE sum/total_fields) THEN error_status = 1
    ENDIF
    IF (field3_status) THEN BEGIN
      IF (sz3 NE sum/total_fields) THEN error_status = 1
    ENDIF
    
    display_tab1_error, MAIN_BASE=main_base, Event=event, STATUS=error_status
    IF (error_status) THEN RETURN
    
    
    
  ENDIF ELSE BEGIN ;just 1 field to take into account
  
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO getListFromSelection, Event,SELECTION=selection

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;check that there is something to parse
  ;(by checking if to_replace is empty or not)
  uname = ['selection_1_replaced_by',$
    'selection_2_replaced_by',$
    'selection_3_replaced_by']
  input_text = $
    STRCOMPRESS(getTextFieldValue(Event,uname[selection-1]),/REMOVE_ALL)
  ;nothing to parse for this selection row
  IF (input_text EQ '') THEN BEGIN
    CASE (selection) OF
      1: (*(*global).sequence_field1) = PTR_NEW(0L)
      2: (*(*global).sequence_field2) = PTR_NEW(0L)
      3: (*(*global).sequence_field3) = PTR_NEW(0L)
    ENDCASE
  ENDIF
  
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
  
  CASE (selection) OF
    1: (*(*global).sequence_field1) = column_seq_number
    2: (*(*global).sequence_field2) = column_seq_number
    3: (*(*global).sequence_field3) = column_seq_number
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO determine_replaced_by_sequence, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  getListFromSelection, Event,SELECTION=1
  getListFromSelection, Event,SELECTION=2
  getListFromSelection, Event,SELECTION=3
  
  cl_with_fields = get_cl_with_fields(Event)
  (*global).cl_with_fields = cl_with_fields
  
END

;------------------------------------------------------------------------------
PRO tab1_selection_button, Event, button=button

  value_selected     = '>>>>>>>>'
  value_not_selected = ''
  
  CASE (button) OF
    1: BEGIN
      value1 = value_selected
      value2 = value_not_selected
      value3 = value_not_selected
    END
    2: BEGIN
      value1 = value_not_selected
      value2 = value_selected
      value3 = value_not_selected
    END
    3: BEGIN
      value1 = value_not_selected
      value2 = value_not_selected
      value3 = value_selected
    END
  ENDCASE
  
  putButtonValue, Event, 'selection_1', value1
  putButtonValue, Event, 'selection_2', value2
  putButtonValue, Event, 'selection_3', value3
  
END

;------------------------------------------------------------------------------
PRO display_part_of_file_selected_in_label, Event, value

  selection_button_activated = getSelectionButtonValue(Event)
  IF (selection_button_activated EQ -1) THEN RETURN
  CASE (selection_button_activated) OF
    1: uname = 'selection_1_to_replaced'
    2: uname = 'selection_2_to_replaced'
    3: uname = 'selection_3_to_replaced'
  ENDCASE
  putValue, Event, uname, value
  
END

;------------------------------------------------------------------------------
PRO activate_corresponding_to_replace_widget, Event

  selection_button_activated = getSelectionButtonValue(Event)
  IF (selection_button_activated EQ -1) THEN RETURN
  CASE (selection_button_activated) OF
    1: uname = 'selection_1_to_replaced'
    2: uname = 'selection_2_to_replaced'
    3: uname = 'selection_3_to_replaced'
  ENDCASE
  
  text = STRCOMPRESS(getTextFieldValue(Event,uname),/REMOVE_ALL)
  IF (text NE '') THEN BEGIN
    status = 1
  ENDIF ELSE BEGIN
    status = 0
  ENDELSE
  
  CASE (selection_button_activated) OF
    1: uname2 = 'selection_1_replaced'
    2: uname2 = 'selection_2_replaced'
    3: uname2 = 'selection_3_replaced'
  ENDCASE
  
  activate_widget, Event, uname2+'_by', status
  activate_widget, Event, uname2+'_by_label', status
  activate_widget, Event, uname2+'_by_clear', status
  activate_widget, Event, uname+'_clear', status
  
END

;------------------------------------------------------------------------------
;IF the user click just 1 character and leave the widget_text 'preview of
;CL file loaded', the 'selection in progress ... ' is removed
PRO cleanup_selection_not_finalized, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  selection_number = getSelectionButtonValue(Event)
  uname = ['selection_1_to_replaced',$
    'selection_2_to_replaced',$
    'selection_3_to_replaced']
    
  uname_clear1 = ['selection_1_to_replaced_clear',$
    'selection_2_to_replaced_clear',$
    'selection_3_to_replaced_clear']
    
  uname_label = ['selection_1_replaced_by_label',$
    'selection_2_replaced_by_label',$
    'selection_3_replaced_by_label']
    
  uname_to_replaced = ['selection_1_replaced_by',$
    'selection_2_replaced_by',$
    'selection_3_replaced_by']
    
  uname_clear2 = ['selection_1_replaced_by_clear',$
    'selection_2_replaced_by_clear',$
    'selection_3_replaced_by_clear']
    
  text = getTextFieldValue(Event,uname[selection_number-1])
  IF (text EQ (*global).selection_in_progress ) THEN BEGIN
    text = ''
    putValue, Event, uname[selection_number-1], text
    activate_widget, Event, uname_clear1[selection_number-1], 0
    activate_widget, Event, uname_label[selection_number-1],0
    activate_widget, Event, uname_to_replaced[selection_number-1],0
    activate_widget, Event, uname_clear2[selection_number-1],0
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO disable_second_part_of_selection, Event, nbr

  uname_clear1 = ['selection_1_to_replaced_clear',$
    'selection_2_to_replaced_clear',$
    'selection_3_to_replaced_clear']
    
  uname_label = ['selection_1_replaced_by_label',$
    'selection_2_replaced_by_label',$
    'selection_3_replaced_by_label']
    
  uname_to_replaced = ['selection_1_replaced_by',$
    'selection_2_replaced_by',$
    'selection_3_replaced_by']
    
  uname_clear2 = ['selection_1_replaced_by_clear',$
    'selection_2_replaced_by_clear',$
    'selection_3_replaced_by_clear']
    
  activate_widget, Event, uname_clear1[nbr-1], 0
  activate_widget, Event, uname_label[nbr-1], 0
  activate_widget, Event, uname_to_replaced[nbr-1], 0
  activate_widget, Event, uname_clear2[nbr-1], 0
  
END