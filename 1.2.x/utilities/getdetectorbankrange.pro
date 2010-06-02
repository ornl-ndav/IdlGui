;+
; :Description:
;    Returns a structure containing the lower/upper detector
;    bank numbers for a given beamline.
;
; :Params:
;    instrument - Instrument name as a string
;
; :Author: scu
;-
FUNCTION getDetectorBankRange, instrument

  IF N_ELEMENTS(instrument) EQ 0 THEN INSTRUMENT = ""
  
  lower = 0
  upper = 0
  
  case (STRUPCASE(instrument)) of
    "ARCS": begin
      lower = 1
      upper = 115
    end
    "CNCS": begin
      lower = 1
      upper = 48
    end
    "SEQUOIA": begin
      lower = 38
      upper = 150
    end
    "MAPS": begin
      lower = 0
      upper = 0
    end
    "MARI": begin
      lower = 0
      upper = 0
    end
    "MERLIN": begin
      lower = 0
      upper = 0
    end
    else: begin
      lower = 0
      upper = 0
    end
  endcase
  
  result = { lower:lower, upper:upper }
  
  RETURN, result
  
END
