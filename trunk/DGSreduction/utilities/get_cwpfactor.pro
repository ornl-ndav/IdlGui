function get_cwpfactor, instrument, runnumber, PLOT=PLOT

  data = GetCWPspectrum(instrument, runnumber)
  
  ; need to find the elastic position
  max_position = where(data.cwp_data EQ max(data.cwp_data))
  ; Uncentre the bins to get the correct position
  tof_array = uncentre_bins(data.tof)
  ; Lookup the time for the max value.
  real_elastic_tof = tof_array[max_position]  
  
  ei = getei(instrument, runnumber)
  tzero = gettzero(instrument, runnumber, ei)
  
  ideal_elastic_tof = get_ideal_elastic_tof(instrument, ei, tzero)

  ; Is this the correct way round ?
  cwp = real_elastic_tof - ideal_elastic_tof 
  
  IF KEYWORD_SET(plot) THEN BEGIN
    xmin = ideal_elastic_tof*0.995
    xmax = ideal_elastic_tof*1.005
    print, 'X-RANGE : [',xmin,',',xmax,']'
    plot, data.tof, data.cwp_data, xrange=[xmin,xmax]
    oplot, [ideal_elastic_tof, ideal_elastic_tof], [0.0, max(data.cwp_data)*2]
    oplot, [real_elastic_tof, real_elastic_tof], [0.0, max(data.cwp_data)] 
  ENDIF

  return, cwp
end
