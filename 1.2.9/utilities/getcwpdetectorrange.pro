;+
; :Description:
;    Returns a structure containing the lower/upper detector
;    bank numbers and the lower/upper row numbers for a
;    given beamline that will be summed up in order to get a
;    spectrum to use for the CWP correction.
;
; :Params:
;    instrument - Instrument name as a string
;
; :Author: scu
;-
FUNCTION getCWPDetectorRange, instrument, ROWS=ROWS

  IF N_ELEMENTS(instrument) EQ 0 THEN INSTRUMENT = ""
  
  IF KEYWORD_SET(ROWS) THEN BEGIN
    rows_to_sum = ROWS
  ENDIF ELSE BEGIN
    rows_to_sum = 10
  ENDELSE
  
  lower_bank = 0
  upper_bank = 0
  
  lower_row = 63 - (rows_to_sum/2)
  upper_row = 63 + (rows_to_sum/2)
  
  case (STRUPCASE(instrument)) of
    "ARCS": begin
      lower_bank = 0
      upper_bank = 0
    end
    "CNCS": begin
      lower_bank = 1
      upper_bank = 48
    end
    "SEQUOIA": begin
      lower_bank = 0
      upper_bank = 0
    end
    else: begin
      lower_bank = 0
      upper_bank = 0
    end
  endcase
  
  result = { lower_bank:lower_bank, $
    upper_bank:upper_bank, $
    lower_row:lower_row, $
    upper_row:upper_row }
    
  RETURN, result
  
END
