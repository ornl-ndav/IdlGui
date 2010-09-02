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
;this function will return an array of two elements, at index 0
;will be what is before the selection, and at index 1, what is after
FUNCTION getCLtextArray, Event
  no_selection = 0
  CATCH, no_selection
  IF (no_selection NE 0) THEN BEGIN
    CATCH,/CANCEL
    return, ['']
  ENDIF ElSE BEGIN
    cl_text = getTextFieldValue(Event,'preview_cl_file_text_field')
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='preview_cl_file_text_field')
    text_selected_index = WIDGET_INFO(id, /TEXT_SELECT)
    cl_array = STRARR(2)
    
    start  = 0
    length = text_selected_index[0]
    cl_array[0] = STRMID(cl_text[0], start, length)
    
    start  = text_selected_index[0] + text_selected_index[1]
    length = STRLEN(cl_text[0]) - start
    cL_array[1] = STRMID(cl_text[0], start, length)
    
    return, cl_array
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION parseText, text, pattern
  result = STRSPLIT(text, pattern, COUNT=variable,/EXTRACT)
  RETURN, result
END

;------------------------------------------------------------------------------
FUNCTION removeCR, text
  IF ((size(text))(1) GT 1) THEN BEGIN
    sz = (size(text))(1)
    index = 0
    WHILE (index LT sz) DO BEGIN
      IF (index EQ 0) THEN BEGIN
        final_text = text[index]
      ENDIF ELSE BEGIN
        final_text += ',' + text[index]
      ENDELSE
      index++
    ENDWHILE
    RETURN, final_text
  ENDIF ELSE BEGIN
    RETURN, text[0]
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION replaceString, text, FIND=find, REPLACE=replace
  str = STRSPLIT(text, FIND, /EXTRACT, /REGEX)
  new_str = STRJOIN(str, REPLACE)
  RETURN, new_str
END

;------------------------------------------------------------------------------
FUNCTION split_string, text, PATTERN=pattern
  result_array = STRSPLIT(text, PATTERN, /EXTRACT, /REGEX)
  RETURN, result_array
END

;------------------------------------------------------------------------------
FUNCTION add_srun_queue, text, BASE_WORD=base_word, ADDED_WORD=added_word
  result_array = STRSPLIT(text, base_word, /REGEX)
  new_cmd = result_array[0] + ' ' + base_word + ' -p ' + added_word + ' ' + $
    result_array[1]
  RETURN,new_cmd
END

;------------------------------------------------------------------------------
PRO create_cl_array, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  cl_array = getCLtextArray(Event)
  (*global).cl_array = cl_array
  
  ;check if sbatch has been found
  sbatch = (*global).sbatch_driver
  match_sbatch = '*' + sbatch + '*'
  IF (STRMATCH(cl_array[0], match_sbatch)) THEN BEGIN ;sbatch was found
  
    ;;;let's suppose for now that if there is srun, there is a p queue
    ;check if -p flag has been found'
    ;    IF (STRMATCH(cl_array[0],'* -p *')) THEN BEGIN ;-p was found
    ;      RETURN
    ;    ENDIF ELSE BEGIN
    ;      ;retrieve srun queue to use
    ;      srun_queue = getSrunQueue(Event)
    ;      added_word = ' -p ' + srun_queue
    ;      cl_first_part = add_srun_queue(cl_array[0],$
    ;        BASE_WORD=sbatch,$
    ;        ADDED_WORD=added_word)
    ;      cl_array[0] = cl_first
    ;      RETURN
    ;    ENDELSE
  
    RETURN
  ENDIF
  
  ;check if the srun command is found
  srun = (*global).srun_driver
  match_srun = '*' + srun + ' *'
  IF (STRMATCH(cl_array[0], match_srun)) THEN BEGIN ;srun is there
  
    ;remove srun and put sbatch instead
    cmd = split_string(cl_array[0], PATTERN=srun)
    sz = N_ELEMENTS(cmd)
    new_cmd = sbatch + ' ' + cmd[sz-1]
    
    ;found --batch
    match_batch = '*' + ' --batch ' + '*'
    IF (STRMATCH(cl_array[0], match_batch)) THEN BEGIN
      ;remove srun and --batch and put just sbatch instead
    
      ;remove --batch
      cmd1 = split_string(new_cmd, PATTERN='--batch')
      cl_array[0] = cmd1[0] + ' ' + cmd1[1]
      (*global).cl_array = cl_array
      RETURN
    ENDIF
    
    ;found -b
    match_batch = '*' + ' -b ' + '*'
    IF (STRMATCH(cl_array[0], match_batch)) THEN BEGIN
    
      ;remove -b
      cmd1 = split_string(new_cmd, PATTERN='--b')
      cl_array[0] = cmd1[0] + ' ' + cmd1[1]
      (*global).cl_array = cl_array
      RETURN
    ENDIF
    
    cl_array[0] = new_cmd
    (*global).cl_array = cl_array
    RETURN
    
  ENDIF ELSE BEGIN ;srun was not found
  
    IF ((*global).debugging NE 'yes') THEN BEGIN
      srun_queue = getSrunQueue()
    ENDIF ELSE BEGIN
      srun_queue = 'bac'
    ENDELSE
    added_word = ' -p ' + srun_queue
    new_cmd = sbatch + added_word + ' ' + cl_array[0]
    cl_array[0] = new_cmd
    (*global).cl_array = cl_array
    RETURN
    
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO displayTextRemoved, Event
  cl_text = getTextFieldValue(Event,'preview_cl_file_text_field')
  cl_text = strjoin(cl_text, ' ')
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='preview_cl_file_text_field')
  text_selected_index = WIDGET_INFO(id, /TEXT_SELECT)
  
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF (text_selected_index[1] EQ 0) THEN BEGIN
    value = (*global).selection_in_progress
    status = 0
  ENDIF ELSE BEGIN
    start  = text_selected_index[0]
    length = text_selected_index[1]
    text_removed = STRMID(cl_text, start, length)
    value = text_removed[0]
    status = 1
  ENDELSE
  value = value
  display_part_of_file_selected_in_label, Event, value
  activate_corresponding_to_replace_widget, Event
END

;------------------------------------------------------------------------------
PRO displayNumberOfCLs, Event, array

  sz = N_ELEMENTS(array)
  title = 'Number of processes that will be launched: '
  IF (array[0] NE '') THEN BEGIN
    value = STRCOMPRESS(sz,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    value = 'N/A'
  ENDELSE
  putValue, Event, 'info_line2_label', title + value
  
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
PRO createCLOfRunsSequence, Event, seq_number, CL_text_array
  ;  print, '***** entering createCLOfRunsSequence *****'
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  seq_number = STRJOIN(seq_number,',')
  seq_number = STRCOMPRESS(seq_number,/REMOVE_ALL)
  
  column_sequence = (*(*global).column_sequence)
  column_cl       = (*(*global).column_cl)
  
  IF (column_sequence[0] EQ '') THEN BEGIN ;table empty
    column_sequence = [seq_number]
    column_cl[0] = CL_text_array[0] + seq_number + ' ' + $
      CL_text_array[1]
  ENDIF ELSE BEGIN
    column_sequence = [column_sequence, seq_number]
    new_cl = CL_text_array[0] + seq_number + ' ' + CL_text_array[1]
    column_cl = [column_cl, new_cl]
  ENDELSE
  
  (*(*global).column_sequence) = column_sequence
  (*(*global).column_cl) = column_cl
;  print, '***** leaving createCLOfRunsSequence *****'
END

;------------------------------------------------------------------------------
PRO parse_input_field, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;reinitialize column_sequence and column_cl
  (*global).column_sequence = PTR_NEW(0L)
  (*global).column_cl = PTR_NEW(0L)
  
  input_text = getTextFieldValue(Event,'input_text_field')
  
  ;get CL with text selected removed
  CL_text_array = (*global).cl_array
  
  ;create just one string (in case the user put some [CR])
  input_text = removeCR(input_text)
  
  ;remove ',,' if any
  input_text = replaceString(input_text,FIND=",,",REPLACE=",")
  
  left     = STRMID(input_text, 0,1) ;retrieve 1st character from input_text
  right    = ''
  cur_numb = 'left' ;we are currently working on the left number of the ope.
  cur_ope  = '' ;there is no current operation in progress
  IF (left EQ '[') THEN BEGIN
    same_run = 1b ;next runs are part of the same CL
  ENDIF ELSE BEGIN
    same_run = 0b ;next runs are not part of the same CL
  ENDELSE
  length   = STRLEN(input_text) ;number of characters
  
  index    = 1
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
            createCLsOfRunSequence, Event, seq_number, CL_text_array
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
        createCLOfRunsSequence, Event, run_array  , CL_text_array
        
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
        
        IF (index EQ (length-1)) THEN BEGIN
          IF (cur_ope EQ '-') THEN BEGIN
            createCLsOfRunSequence, $
              Event, $
              seq_number, $
              CL_text_array
          ENDIF
        ENDIF
      END
      
    ENDCASE
    index++
  ENDWHILE
  
  column_sequence = (*(*global).column_sequence)
  column_cl = (*(*global).column_cl)
  sz = N_ELEMENTS(column_sequence)
  
  Table = STRARR(2,sz)
  Table[0,*] = column_sequence[*]
  Table[1,*] = column_cl[*]
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='runs_table')
  WIDGET_CONTROL, id, TABLE_YSIZE = sz
  putValue, Event, 'runs_table', Table
  
  displayNumberOfCLs, Event, column_sequence
  
  ;activate or not the 'Launch Jobs in Background'
  IF (column_sequence[0] NE '') THEN BEGIN
    status = 1
  ENDIF ELSE BEGIN
    status = 0
  ENDELSE
  activate_widget, Event, 'run_jobs_button', status
  activate_widget, Event, 'preview_jobs_button', status
  
END

;------------------------------------------------------------------------------
;This procedure adds the list of runs to the array
PRO addSequencesToRunArray, run_array, seq_number

  IF (seq_number[0] NE '') THEN BEGIN
    IF (run_array[0] EQ '') THEN BEGIN
      run_array = [seq_number]
    ENDIF ELSE BEGIN
      run_array = [run_array,seq_number]
    ENDELSE
  ENDIF
END

;------------------------------------------------------------------------------
PRO remove_output_file_name, Event

  error = 0
  ;CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
  ENDIF ELSE BEGIN
    ;get global structure
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
    
    ;get CL with text selected removed
    CL_text_array = (*global).cl_array
    
    part2 = CL_text_array[1]
    part2_parsed = split_string(part2, PATTERN='--output=')
    
    ;keep path
    IF (N_ELEMENTS(part2_parsed) GT 1) THEN BEGIN ;there is the tag --output
    
      ;keep text between '--output=' and next space
      string_to_keep = split_string(part2_parsed[1],PATTERN=' ')
      
      ;path = FILE_DIRNAME(part2_parsed[1])
      path = FILE_DIRNAME(string_to_keep[0])
      path += '/'
      (*global).step1_output_path = path
      
      IF (N_ELEMENTS(string_to_keep) GT 1) THEN BEGIN ;output path was not last
      
        ;part2_2_parsed = split_string(part2_parsed[1], PATTERN=' ')
        part2_2_parsed = split_string(string_to_keep[1], PATTERN=' ')
        sz = N_ELEMENTS(part2_2_parsed)
        IF (sz GT 1) THEN BEGIN ;join all the other part after 'output=....'
          ;new_part = STRJOIN(part2_2_parsed[1:sz-1],' ')
          new_part = STRJOIN(string_to_keep[1:sz-1],' ')
          ;CL_text_array[1] = part2_parsed[0] + ' ' + new_part
          end_string  = string_to_keep[0] + ' ' + new_part
        ENDIF ELSE BEGIN
          end_string = ''
        ENDELSE
        cl_text_array[1] = part2_parsed[0] + ' ' + end_string + $
          ' --output=' + path + (*global).output_suffix
          
      ENDIF ELSE BEGIN ;output path was last
      
        cl_text_array[1] = part2_parsed[0] + ' --output=' + path + (*global).output_suffix
        
      ENDELSE
      
      (*global).cl_array = CL_text_array
      
    ENDIF ELSE BEGIN
    
      (*global).cl_array = cl_text_array + ' --output=~/results/' +  $
        (*global).output_suffix
      (*global).step1_output_path = '~/results/'
      
    ENDELSE
    
  ENDELSE
END


