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
    cl_array[0] = STRMID(cl_text, start, length)
    
    start  = text_selected_index[0] + text_selected_index[1]
    length = STRLEN(cl_text) - start
    cL_array[1] = STRMID(cl_text, start, length)
    
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
FUNCTION getSequence, left, right

  print, 'in getSequence'
  print, 'left: ' + strcompress(left)
  print, 'right: ' + strcompress(right)
  
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, ['']
  ENDIF ELSE BEGIN
    ON_IOERROR, done
    iLeft  = FIX(left)
    iRight = FIX(right)
    print, iRight
    print, iLeft
    sequence = INDGEN(iRight-iLeft+1)+iLeft
    RETURN, STRING(sequence)
    done:
    RETURN, ['']
  ENDELSE
END

;------------------------------------------------------------------------------
PRO createCLsOfRunSequence, Event, seq_number, CL_text_array

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  print, 'in CreateCLsOfRunSequence'
  print, seq_number
  
  column_sequence = (*(*global).column_sequence)
  column_cl       = (*(*global).column_cl)
  
  sz = N_ELEMENTS(seq_number)
  index = 0
  WHILE (index LT sz) DO BEGIN
    nbr_row = (size(column_sequence))(1)
    
    IF (column_sequence[0] EQ '') THEN BEGIN ;table empty
      column_sequence[0] = seq_number[index]
      column_cl[0] = CL_text_array[0] + Seq_number[index] + ' ' + $
        CL_text_array[1]
    ENDIF ELSE BEGIN
      column_sequence = [column_sequence,seq_number[index]]
      new_cl = CL_text_array[0] + seq_number[index] + ' ' + CL_text_array[1]
      column_cl = [column_cl, new_cl]
    ENDELSE
    
    index++
  ENDWHILE
  
  (*(*global).column_sequence) = column_sequence
  (*(*global).column_cl) = column_cl
  
  print, 'at the enf of createCLsOfRunSequence'
  print, column_sequence
  help, column_sequence
  
END

;------------------------------------------------------------------------------
PRO createCLOfRunsSequence, Event, seq_number, CL_text_array

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  seq_number = STRJOIN(seq_number,',')
  
  column_sequence = (*(*global).column_sequence)
  column_cl       = (*(*global).column_cl)
  
  IF (column_sequence[0] EQ '') THEN BEGIN ;table empty
    column_sequence[0] = seq_number
    column_cl[0] = CL_text_array[0] + seq_number + ' ' + $
      CL_text_array[1]
  ENDIF ELSE BEGIN
    column_sequence = [column_sequence, seq_number]
    new_cl = CL_text_array[0] + seq_number + ' ' + CL_text_array[1]
    column_cl = [column_cl, new_cl]
  ENDELSE
  
  (*(*global).column_sequence) = column_sequence
  (*(*global).column_cl) = column_cl
  
END

;------------------------------------------------------------------------------
PRO parse_input_field, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  input_text = getTextFieldValue(Event,'input_text_field')
  
  ;get CL with text selected removed
  CL_text_array = getCLtextArray(Event)
  
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
    print, 'cursor: ' + cursor
    CASE (cursor) OF
    
      '-' : BEGIN ;............................................................
        cur_numb = 'right' ;we are now working on the right number
        cur_ope  = '-'     ;working operation is now '-'
      END
      
      ',' : BEGIN ;............................................................
        IF (cur_ope EQ '-') THEN BEGIN ;sequence of numbers
          seq_number = getSequence(left, right)
        ENDIF ELSE BEGIN
          seq_number = left
        ENDELSE
        
        IF (same_run) THEN BEGIN
          print, 'in same run'
          help, run_array
          addSequencesToRunArray, run_array, seq_number
          print, 'after same run'
          help, run_array
        ENDIF ELSE BEGIN
          createCLsOfRunSequence, Event, seq_number, CL_text_array
        ENDELSE
        
        right    = ''     ;reinitialize right number
        left     = ''
        cur_ope  = ''     ;reinitialize operation in progress
        cur_numb = 'left' ;we will now work on the left number again
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
        
        createCLsOfRunSequence, Event, seq_number, CL_text_array
    
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
  
  print, '---------------------------------'
  print, 'end of parse_input_text'
  print, (*(*global).column_sequence)
  
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
  print, 'in add sequencesto runarray'
  print, run_array
END