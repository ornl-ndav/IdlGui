function get_ideal_elastic_tof, instrument, ei, tzero

  ; I am assuming that the energy is in meV
  lambda = double(sqrt(81.81/ei))
  vmmsec=3.9562/lambda
  
  neutron_mass = 1.674929e-27
  planck_const = 6.626076e-34
  c1 = double(neutron_mass / (planck_const * 1.0e4))
  
 
  
  case (STRUPCASE(instrument)) of
    "ARCS": begin
      primary = 0.0
      secondary = 0.0
    end
    "CNCS": begin
      ; Distances in metres
      primary = 36.262
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
  
  tof = double(c1 * lambda * (primary + secondary)) + tzero
  ;tof = (primary + secondary) / vmmsec
  
  return, tof
end
