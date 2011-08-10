;------------------------------------------------------------------------------
FUNCTION getSequence, left, right
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ['']
  ENDIF ELSE BEGIN
    ON_IOERROR, done
    iLeft  = FIX(left[0])
    iRight = FIX(right[0])
    sequence = INDGEN(iRight-iLeft+1)+iLeft
    RETURN, STRING(sequence)
    done:
    RETURN, [STRCOMPRESS(left,/REMOVE_ALL)]
  ENDELSE
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




PRO getListFromSelection, Event, input_text
compile_opt idl2

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
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
  ;add_bracket_runs_to_sequence, column_seq_number
 
  (*(*global).list_of_data_nexus) = column_seq_number
  
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
PRO full_reset, left, right, cur_ope
  left = ''
  right = ''
  cur_ope = ''
END