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

FUNCTION MoveToEndOutputFlag, Event, cl_text

  error = 0
  ;CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
  ENDIF ELSE BEGIN
    ;get global structure
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
    
    part2_parsed = split_string(cl_text, PATTERN='--output=')
    
    ;keep path
    IF (N_ELEMENTS(part2_parsed) GT 1) THEN BEGIN ;there is the tag --output
    
      ;keep text between '--output=' and next space
      string_to_keep = split_string(part2_parsed[1],PATTERN=' ')
      
      ;path = FILE_DIRNAME(part2_parsed[1])
      path = FILE_DIRNAME(string_to_keep[0])
      path += '/'
      (*global).step1_output_path = path
      
      sz = N_ELEMENTS(string_to_keep)
      
      IF (sz GE 2) THEN BEGIN ;output path was not last
      
        IF (sz GT 2) THEN BEGIN ;join all the other part after 'output=....'
          new_part = STRJOIN(string_to_keep[2:sz-1],' ')
          end_string  = string_to_keep[0] + ' ' + new_part
        ENDIF ELSE BEGIN
          end_string = string_to_keep[1]
        ENDELSE
        cl_text = part2_parsed[0] + ' ' + end_string + $
          ' --output=' + path + (*global).output_suffix
          
      ENDIF ELSE BEGIN ;output path was last
      
        cl_text = part2_parsed[0] + ' --output=' + path + (*global).output_suffix
        
      ENDELSE
      
    ENDIF ELSE BEGIN
    
      cl_text = cl_text + ' --output=~/results/' +  $
        (*global).output_suffix
      (*global).step1_output_path = '~/results/'
      
    ENDELSE
    
  ENDELSE
  
  RETURN, cl_text
  
END

;------------------------------------------------------------------------------
PRO Create_step1_big_table, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  error_status = 0 ;by default, everything is fine
  (*global).tab1_activate_run_widgets = 0b
  
  cl_with_fields = (*global).cl_with_fields
  
  cl_with_fields = MoveToEndOutputFlag(Event, cl_with_fields)
  
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
  total_fields = field1_status + field2_status + field3_status
  
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
  
  cl_array = STRARR(sum/total_fields) + cl_with_fields ;array of cl strings
  IF (field1_status) THEN BEGIN ;work on field1
    sz = sz1
    index_sz = 0
    WHILE (index_sz LT sz) DO BEGIN
      ;divide cl at <field1>
      cl_field1_array = STRSPLIT(cl_array[index_sz],'<FIELD#1>',/EXTRACT,/REGEX)
      new_cl = cl_field1_array[0]
      new_cl += STRCOMPRESS(sequence_field1[index_sz],/REMOVE_ALL)
      ;IF (N_ELEMENTS(cl_fiedl1_array) GT 1) THEN BEGIN
      new_cl += cl_field1_array[1]
      ;ENDIF
      cl_array[index_sz] = new_cl
      index_sz++
    ENDWHILE
  ENDIF
  
  IF (field2_status) THEN BEGIN ;work on field2
    sz = sz2
    index_sz = 0
    WHILE (index_sz LT sz) DO BEGIN
      ;divide cl at <field1>
      cl_field2_array = STRSPLIT(cl_array[index_sz],'<FIELD#2>',/EXTRACT,/REGEX)
      new_cl = cl_field2_array[0]
      new_cl += STRCOMPRESS(sequence_field2[index_sz],/REMOVE_ALL)
      ;IF (N_ELEMENTS(cl_fiedl2_array) GT 1) THEN BEGIN
      new_cl += cl_field2_array[1]
      ;ENDIF
      cl_array[index_sz] = new_cl
      index_sz++
    ENDWHILE
  ENDIF
  
  IF (field3_status) THEN BEGIN ;work on field3
    sz = sz3
    index_sz = 0
    WHILE (index_sz LT sz) DO BEGIN
      ;divide cl at <field1>
      cl_field3_array = STRSPLIT(cl_array[index_sz],'<FIELD#3>',/EXTRACT,/REGEX)
      new_cl = cl_field3_array[0]
      new_cl += STRCOMPRESS(sequence_field3[index_sz],/REMOVE_ALL)
      ; IF (N_ELEMENTS(cl_fiedl3_array) GT 1) THEN BEGIN
      new_cl += cl_field3_array[1]
      ; ENDIF
      cl_array[index_sz] = new_cl
      index_sz++
    ENDWHILE
  ENDIF
  
  ;Create Big table
  dim1 = 4
  dim2 = sum/total_fields
  
  ;get the first sequence not empty
  IF (field1_status) THEN BEGIN
    sequence = sequence_field1
  ENDIF ELSE BEGIN
    IF (field2_status) THEN BEGIN
      sequence = sequence_field2
    ENDIF ELSE BEGIN
      sequence = sequence_field3
    ENDELSE
  ENDELSE
  
  index = 0
  WHILE (index LT dim2) DO BEGIN
    runs_array = STRSPLIT(sequence[index],',',/EXTRACT,count=nbr)
    runs = STRCOMPRESS(runs_array[0],/REMOVE_ALL)
    IF (nbr EQ 1) THEN BEGIN
      runs += '_' + STRCOMPRESS(nbr,/REMOVE_ALL) + 'run'
    ENDIF ELSE BEGIN
      runs += '_' + STRCOMPRESS(nbr,/REMOVE_ALL) + 'runs'
    ENDELSE
    cl_array[index]+= runs + (*global).output_prefix
    index++
  ENDWHILE
  
  big_table = STRARR(dim1,dim2)
  index = 0
  WHILE (index LE dim2-1) DO BEGIN
    IF (field1_status) THEN BEGIN
      big_table[0,index] = sequence_field1[index]
    ENDIF ELSE BEGIN
      big_table[0,index] = ''
    ENDELSE
    IF (field2_status) THEN BEGIN
      big_table[1,index] = sequence_field2[index]
    ENDIF ELSE BEGIN
      big_table[1,index] = ''
    ENDELSE
    IF (field3_status) THEN BEGIN
      big_table[2,index] = sequence_field3[index]
    ENDIF ELSE BEGIN
      big_table[2,index] = ''
    ENDELSE
    big_table[3,index] = cL_array[index]
    index++
  ENDWHILE
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='runs_table')
  WIDGET_CONTROL, id, TABLE_YSIZE = dim2
  putValue, Event, 'runs_table', big_table
  
  ;we can validated the bottom widgets
  (*global).tab1_activate_run_widgets = 1b
  
END

;------------------------------------------------------------------------------
PRO check_status_of_step1, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  status = (*global).tab1_activate_run_widgets
  
  uname_array = ['preview_jobs_button',$
    'run_jobs_button']
  sz = N_ELEMENTS(uname_array)
  FOR i=0,sz-1 DO BEGIN
    activate_widget, Event, uname_array[i], status
  ENDFOR
  
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
  
  cleanup_seq_number, column_seq_number
  
  ;add individuals list to global sequence
  ;ex [1,2,5-7,9] -> will create run [1,2,5-7,9],1,2,5,6,7,9
  add_bracket_runs_to_sequence, column_seq_number
  
  CASE (selection) OF
    1: (*(*global).sequence_field1) = column_seq_number
    2: (*(*global).sequence_field2) = column_seq_number
    3: (*(*global).sequence_field3) = column_seq_number
  ENDCASE
  
END

;+
; :Description:
;    This parse the various seq number and create the full sequence array
;
; :Params:
;    column_seq_number

; :Author: j35
;-
pro add_bracket_runs_to_sequence, column_seq_number
  compile_opt idl2
  
  sz = n_elements(column_seq_number)
  index = 0
  final_seq = strarr(1)
  while (index lt sz) do begin
    line_parsed = strsplit(column_seq_number[index],',',/extract,count=nbr)
    if (nbr gt 1) then begin
      final_seq = [final_seq, column_seq_number[index]]
      for i=0,nbr-1 do begin
        final_seq = [final_seq,line_parsed[i]]
      endfor
    endif else begin
      final_seq = [final_seq, line_parsed[0]]
    endelse
    index++
  endwhile
  
  column_seq_number = final_seq
  sz = n_elements(column_seq_number)
  if (sz gt 2) then begin
    column_seq_number = temporary(column_seq_number[1:n_elements(column_seq_number)-1])
  endif else begin
    final_array = strarr(1)
    final_array[0] = column_seq_number[1]
    column_seq_number = final_array
;    column_seq_number = temporary(column_seq_number[1])
  endelse
  
  return
  
end

;+
; :Description:
;   This routine remove all the empty value
;
; :Params:
;    column_seq_number
;
; :Author: j35
;-
pro cleanup_seq_number, column_seq_number
  compile_opt idl2
  
  index = where(column_seq_number ne '', nbr)
  if (nbr gt 0) then begin
    column_seq_number = temporary(column_seq_number[index])
  endif
  
end

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