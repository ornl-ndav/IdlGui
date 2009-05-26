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

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    refresh_button_status = 0
  ENDIF ELSE BEGIN
    ;get table
    tab2_table = (*(*global).tab2_table)
    putValue, Event, 'tab2_table_uname', tab2_table
    refresh_button_status = 1
  ENDELSE
  activate_widget, Event, 'tab2_refresh_table_uname', refresh_button_status
  
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
  
  length = STRLEN(input_text)
  index = 1
  WHILE (index LT length) DO BEGIN
  
    ;current cursor value
    cursor = STRMID(input_text, index, 1)
    
    CASE (cursor) OF
      '0': addNumber, left, right, cursor, cur_ope
      '1': addNumber, left, right, cursor, cur_ope
      '2': addNumber, left, right, cursor, cur_ope
      '3': addNumber, left, right, cursor, cur_ope
      '4': addNumber, left, right, cursor, cur_ope
      '5': addNumber, left, right, cursor, cur_ope
      '6': addNumber, left, right, cursor, cur_ope
      '7': addNumber, left, right, cursor, cur_ope
      '8': addNumber, left, right, cursor, cur_ope
      '9': addNumber, left, right, cursor, cur_ope
      '-': BEGIN
        cur_ope = '-'
      END
      ',': BEGIN
        full_reset, left, right, cur_ope
      END
      '[': BEGIN
        full_reset, left, right, cur_ope
        same_run = 1b
      END
      ']': BEGIN
        full_reset, left, right, cur_ope
        same_run = 0b
      END
      ',':
      ELSE: ;[ENTER]
    ENDCASE
    
    
    index++
  ENDWHILE
  
  
  
  
  
  
  
end


















pro tmp


  run_array = ['']
  
  WHILE(index LT length) DO BEGIN
  
    cursor = STRMID(input_text,index,1)
    ;    print, 'cursor: ' + cursor
    CASE (cursor) OF
    
      '-' : BEGIN ;............................................................
        cur_numb = 'right' ;we are now working on the right number
        cur_ope  = '-'     ;working operation is now '-'
      END
      
      ',' : BEGIN ;............................................................
        IF (left NE '') THEN BEGIN
          IF (cur_ope EQ '-') THEN BEGIN ;sequence of numbers
            seq_number = getSequence(left, right)
          ENDIF ELSE BEGIN
            seq_number = left
          ENDELSE
          IF (same_run) THEN BEGIN
            addSequencesToRunArray, run_array, seq_number
          ENDIF ELSE BEGIN
            createCLsOfRunsSequence_tab2, Event, seq_number, CL_text_array
          ENDELSE
          
          right    = ''     ;reinitialize right number
          left     = ''
          cur_ope  = ''     ;reinitialize operation in progress
          cur_numb = 'left' ;we will now work on the left number again
        ENDIF
      END
      
      '[' : BEGIN ;............................................................
        left     = ''
        right    = ''
        cur_ope  = ''
        cur_numb = 'left'
        same_run = 1b
      END
      
      ']' : BEGIN ;............................................................
        IF (cur_ope EQ '-') THEN BEGIN ;sequence of numbers
          seq_number = getSequence(left, right)
        ENDIF ELSE BEGIN
          seq_number = left
        ENDELSE
        
        addSequencesToRunArray, run_array, seq_number
        createCLsOfRunsSequence_tab2, Event, run_array  , CL_text_array
        
        right    = ''
        left     = ''
        cur_ope  = ''
        cur_numb = 'left'
        same_run = 0b
        left     = ''
        run_array = ['']
        
      END
      
      ELSE: BEGIN ;............................................................
        IF (cur_numb EQ 'left') THEN BEGIN
        
          IF (left EQ '') THEN BEGIN
            left = cursor
          ENDIF ELSE BEGIN
            left = left + cursor
          ENDELSE
          
        ENDIF ELSE BEGIN
        
          IF (right EQ '') THEN BEGIN
            right = cursor
          ENDIF ELSE BEGIN
            right = right + cursor
          ENDELSE
          
        ENDELSE
        
        PRINT, 'index: ' + STRCOMPRESS(index)
        PRINT, 'length-1: ' + STRCOMPRESS(length-1)
        PRINT, 'left: ' + left
        
        IF (index EQ (length-1)) THEN BEGIN ;end
          IF (cur_ope EQ '-') THEN BEGIN
            createCLsOfRunsSequence_tab2, $
              Event, $
              seq_number, $
              CL_text_array
          ENDIF ELSE BEGIN
            createCLsOfRunsSequence_tab2, $
              Event, $
              [left], $
              CL_text_array
          ENDELSE
        ENDIF
      END
      
    ENDCASE
    index++
    PRINT
  ENDWHILE
  
  column_sequence = (*(*global).column_sequence)
  column_cl = (*(*global).column_cl)
  
  ;print, column_cl
  HELP, column_sequence
  PRINT, column_sequence
  
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
PRO addNumber, left, right, cursor, cur_ope
  IF (cur_ope EQ '-') THEN BEGIN ;add cursor to right number
    right += cursor
  ENDIF ELSE BEGIN ;add cursor to left number
    left += cursor
  ENDELSE
END

;------------------------------------------------------------------------------
PRO full_reset, left, right, cur_ope
  left = ''
  right = ''
  cur_ope = ''
END

