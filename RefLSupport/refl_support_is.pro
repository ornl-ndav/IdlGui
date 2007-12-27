;This function returns 1 if the input can be turned into
;a float, and 0 if it can't
FUNCTION isValueFloat, textString
  result = getNumeric(textString)
  if (result EQ '') then begin
     return, 0
  endif else begin
     return, 1
  endelse
END


;This function checks if the 'textString' can be turned
;into a value or not
;1 means yes, and 0 means no
FUNCTION isNumeric, textString
;float
result = isValueFloat(textString)
RETURN, result
END
