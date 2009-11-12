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

FUNCTION getListFromSelection, Event,SELECTION=selection

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;check that there is something to parse
  ;(by checking if to_replace is empty or not)
  uname = ['selection_1_to_replaced',$
    'selection_2_to_replaced',$
    'selection_3_to_replaced']
  text = STRCOMPRESS(getTextFieldValue(Event,uname[selection-1]),/REMOVE_ALL)
  IF (text EQ '') THEN RETURN, [''] ;nothing to parse for this selection row
  
  
  
  
  
  ;reinitialize column_sequence and column_cl
  (*global).column_sequence_tab2 = PTR_NEW(0L)
  (*global).column_file_name_tab2 = PTR_NEW(0L)
  
  input_text = getTextFieldValue(Event,'tab2_manual_input_sequence')
  
  ;remove ',,' if any
  input_text = replaceString(input_text, FIND= ",," ,REPLACE=",")
  
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
  
  
  
  
  
  
END

;------------------------------------------------------------------------------
PRO determine_replaced_by_sequence, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  list_selection1 = getListFromSelection(Event,SELECTION=1)
  list_selection2 = getListFromSelection(Event,SELECTION=2)
  list_selection3 = getListFromSelection(Event,SELECTION=3)
  
  
  
  
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