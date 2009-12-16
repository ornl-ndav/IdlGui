function getTzero, instrument, runnumber, ei

  ; What we do depends on the instrument
  case (STRUPCASE(instrument)) of
    "ARCS": begin
      ; Calculate the Ei
      tzero = calcTzero(ei, instrument, runnumber)
    end
    "CNCS": begin
      tzero = 0.1982*(1+Ei)^(-0.84098)
      ; Convert to usec
      tzero = tzero * 1000.0
    end
    "SEQUOIA": begin
      ; Calculate the Ei
      tzero = calcTzero(ei, instrument, runnumber)
    end
    else: begin
      ; If we don't know the beamline then just assumed that the requested Ei is good enough!
      tzero = ''
    end
  endcase
  
  return, tzero
end
