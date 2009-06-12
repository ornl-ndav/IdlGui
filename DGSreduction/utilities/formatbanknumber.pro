;+
; :Description:
;    Given a detector bank number it returns the bank 
;    number as a string in a 3 number format.
;    e.g. '001', '023' or '123'
;
; :Params:
;    bank
;
; :Author: scu
;-
FUNCTION formatBankNumber, bank
  output = '000'
  
  ; Make sure that the bank number of +ve
  bank = abs(bank)
  
  IF (bank LT 10) THEN BEGIN
    output = '00'+ STRTRIM(STRING(bank), 2)
    RETURN, output
  ENDIF 
  
  IF ((bank GE 10) AND (bank LT 100)) THEN BEGIN
    output = '0'+ STRTRIM(STRING(bank), 2)
    RETURN, output
  ENDIF 
  
  IF (bank GE 100) THEN BEGIN
    output = STRTRIM(STRING(bank), 2)
    RETURN, output
  ENDIF 
  
  RETURN, output
END