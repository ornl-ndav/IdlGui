;###############################################################################
;*******************************************************************************

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

;###############################################################################
;*******************************************************************************

;This function checks if the 'textString' can be turned
;into a value or not
;1 means yes, and 0 means no
FUNCTION isNumeric, textString
;float
result = isValueFloat(textString)
RETURN, result
END

;###############################################################################
;*******************************************************************************

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

;###############################################################################
;*******************************************************************************
