function getTzero, instrument, runnumber, ei

  ; What we do depends on the instrument
  case (STRUPCASE(instrument)) of
    "ARCS": begin
      ; Calculate the Ei
      Ei = calcTzero(ei, instrument, runnumber)
      tzero = 0.0
    end
    "CNCS": begin
      tzero = 0.1982*(1+Ei)^(-0.84098)
    end
    "SEQUOIA": begin
      ; Calculate the Ei
      Ei = calcei(requested_ei, instrument, runnumber)
    end
    else: begin
      ; If we don't know the beamline then just assumed that the requested Ei is good enough!
      ei = requested_ei
    end
  endcase
  
  return, tzero
end
