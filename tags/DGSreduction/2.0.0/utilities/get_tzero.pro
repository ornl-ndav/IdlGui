function get_Tzero, instrument, runnumber, ei

	; Make sure that Ei is a number
	ei = double(ei)

  ; What we do depends on the instrument
  case (STRUPCASE(instrument)) of
    "ARCS": begin
      ; Calculate the Ei
      result = calcei_python(instrument, runnumber, ei)
      tzero = result.tzero
    end
    "CNCS": begin
        tzero=double(0.1982*(1+Ei)^(-0.84098))      
      ; Convert to usec
      tzero = tzero * 1000.0
    end
    "SEQ": begin
      ; Calculate the Ei
      result = calcei_python(instrument, runnumber, ei)
      tzero = result.tzero
    end
    else: begin
      ; If we don't know the beamline then just assumed that the requested Ei is good enough!
      tzero = ''
    end
  endcase
  
  return, tzero
end
