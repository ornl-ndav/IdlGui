function get_cwpfactor, instrument, runnumber

  data = GetCWPspectrum(instrument, runnumber)
  
  ; need to find the elastic position
  max_position = where(data.cwp_data EQ max(data.cwp_data))
  ; Uncentre the bins to get the correct position
  tof_array = uncentre_bins(data.tof)
  ; Lookup the time for the max value.
  real_elastic_tof = tof_array[max_position]
  
  ideal_elastic_tof = get_ideal_elastic_tof(instrument, ei, tzero)
  
  cwp = ideal_elastic_tof - real_elastic_tof
  
  return, cwp
end