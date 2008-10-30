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

;##############################################################################
;******************************************************************************

;This function returns 1 if the input can be turned into
;a float, and 0 if it can't
FUNCTION isValueFloat, textString
  result = getNumeric(textString)
  IF (result EQ '') THEN BEGIN
     RETURN, 0
  ENDIF ELSE BEGIN
     RETURN, 1
  ENDELSE
END

;##############################################################################
;******************************************************************************

;This function checks if the 'textString' can be turned
;into a value or not
;1 means yes, and 0 means no
FUNCTION isNumeric, textString
;float
result = isValueFloat(textString)
RETURN, result
END

;##############################################################################
;******************************************************************************

;This function checks if the newly loaded file has alredy
;been loaded. Return 1 if yes and 0 if not
FUNCTION isFileAlreadyInList, ListOfFiles, file
sizeArray = size(ListOfFiles)
size = sizeArray[1]
FOR i=0, (size-1) DO BEGIN
    IF (ListOfFiles[i] EQ file) THEN BEGIN
        RETURN, 1
    ENDIF
ENDFOR
RETURN, 0
END

;##############################################################################
;******************************************************************************

;this function return 1 if the ListOfFiles is empty (first load)
;otherwise it returns 0
FUNCTION isListOfFilesSize0, ListOfFiles
         
sz = (size(ListOfFiles))(1)
IF (sz EQ 1) THEN BEGIN
;check if argument is empty string
    IF (ListOfFiles[0] EQ '') THEN BEGIN
        RETURN, 1
    ENDIF ELSE BEGIN
        RETURN, 0
    ENDELSE
ENDIF ELSE BEGIN
    RETURN, 0
ENDELSE
END

;##############################################################################
;******************************************************************************

;This function returns 1(true) if there is a batch file loaded in the
;batch table
FUNCTION isBatchFileLoaded, Event
batch_file_name = getBatchFileName(Event)
IF (batch_file_name EQ '') THEN RETURN, 0
RETURN, 1
END
