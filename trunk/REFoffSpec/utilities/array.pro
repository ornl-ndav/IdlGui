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

PRO addElementToArray, ARRAY=array, new_element=new_element
  sz = N_ELEMENTS(array)
  IF (sz EQ 1 AND array[0] EQ '') THEN BEGIN
    array[0] = new_element
  ENDIF ELSE BEGIN
    array = [array,new_element]
  ENDELSE
  RETURN
END

;------------------------------------------------------------------------------
FUNCTION RemoveEmptyElement, array

  type = (SIZE(array))(0)
  IF (type EQ 1) THEN RETURN, STRARR(1)
  
  new_array = STRARR(1)
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH, /CANCEL
    RETURN, STRARR(1)
  ENDIF ELSE BEGIN
    sz = (SIZE(array))(2)
    index = 0
    WHILE (index LT sz) DO BEGIN
      IF (array[index] NE '') THEN BEGIN
        addElementToArray, ARRAY=new_array, new_element=array[index]
      ENDIF
      index++
    ENDWHILE
  ENDELSE
  RETURN, new_array
  
END

;-----------------------------------------------------------------------------
FUNCTION push_array, ARRAY=array, NEW_ELEMENT=new_element
  sz = (SIZE(array))(1)
  IF (sz EQ 1 AND $
    array[0] EQ '') THEN BEGIN
    RETURN, [new_element]
  ENDIF ELSE BEGIN
    RETURN, [new_element, array]
  ENDELSE
END













