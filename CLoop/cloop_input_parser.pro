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
PRO parse_input_field, Event
input_text = getTextFieldValue(Event,'input_text_field')

;create just one string (in case the user put some [CR])
input_text = removeCR(input_text)

;remove ',,' if any
input_text = replaceString(input_text,FIND=",,",REPLACE=",")
print, input_text




;find out how many '[' we have
;result = STRSPLIT(input_text,'[',COUNT=nbr)
;print, nbr

;Step1 : parse input text for ",["
;result = STRPOS(input_text,'[')

;print, result

END