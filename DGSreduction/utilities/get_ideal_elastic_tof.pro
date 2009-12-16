function get_ideal_elastic_tof, instrument, ei, tzero

  ; I am assuming that the energy is in meV
  lambda = double(sqrt(81.80320651/ei))
  
  neutron_mass = 1.674929e-27
  planck_const = 6.626076e-34
  c1 = neutron_mass / (planck_const * 1.0e4)
  
  case (STRUPCASE(instrument)) of
    "ARCS": begin
      primary = 0.0
      secondary = 0.0
    end
    "CNCS": begin
      ; Distances in metres
      primary = 32.262
      secondary = 3.5
    end
    "SEQUOIA": begin
      primary = 0.0
      secondary = 0.0
    end
    else: begin
      primary = 0.0
      secondary = 0.0
    end
  endcase
  
  tof = c1 * ei * (primary + secondary)
  
  return, tof
end