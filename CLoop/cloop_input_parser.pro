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
PRO parse_input_field, Event
  input_text = getTextFieldValue(Event,'input_text_field')
  
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
  WHILE(index LT length) DO BEGIN
    run_array = ['']
    cursor = STRMID(input_text,index,1)
    CASE (cursor) OF
      '-' : BEGIN
        cur_numb = 'right' ;we are now working on the right number
        cur_ope  = '-'     ;working operation is now '-'
      END
      ',' : BEGIN
        left     = ''     ;reinitialize left number
        cur_ope  = ''     ;reinitialize operation in progress
        cur_numb = 'left' ;we will now work on the left number again
      END
      '[' : BEGIN
        left     = ''
        cur_ope  = ''
        cur_numb = 'left'
        same_run = 1b
      END
      ']' : BEGIN
        cur_ope  = ''
        cur_numb = 'left'
        same_run = 0b
        left     = ''
      END
      ELSE: BEGIN
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
      END
    ENDCASE
    index++
  ENDWHILE
  
    



END