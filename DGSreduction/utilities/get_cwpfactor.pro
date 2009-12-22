function get_cwpfactor, instrument, runnumber, PLOT=PLOT, PRINT=PRINT, ROWS=ROWS

  data = GetCWPspectrum(instrument, runnumber, ROWS=ROWS)
  
  ; need to find the elastic position
  max_position = where(data.cwp_data EQ max(data.cwp_data))
  ; Uncentre the bins to get the correct position
  ;tof_array = uncentre_bins(data.tof)
  ; Lookup the time for the max value.
  ;real_elastic_tof = tof_array[max_position]  
  real_elastic_tof = data.tof[max_position]  
   
  ei = getei(instrument, runnumber)
  tzero = gettzero(instrument, runnumber, ei)
  
  ideal_elastic_tof = get_ideal_elastic_tof(instrument, ei, tzero)


  ; Is this the correct way round ?
  ;cwp = tzero - (real_elastic_tof - (ideal_elastic_tof - tzero))
  
  cwp = ideal_elastic_tof - real_elastic_tof
  
  IF KEYWORD_SET(print) THEN BEGIN
    print, 'Energy : ', ei
    print, 'Tzero : ', tzero 
    print, 'Ideal TOF : ', ideal_elastic_tof
    print, 'Real TOF : ', real_elastic_tof
    print, 'Rows summed : ', data.nrows
    print, 'CWP : ', cwp 
 ENDIF
  
  IF KEYWORD_SET(plot) THEN BEGIN
    xmin = ideal_elastic_tof*0.995
    xmax = ideal_elastic_tof*1.005
    print, 'X-RANGE : [',xmin,',',xmax,']'
    plot, data.tof, data.cwp_data, xrange=[xmin,xmax], psym=10
    oplot, [ideal_elastic_tof, ideal_elastic_tof], [0.0, max(data.cwp_data)*2]
    oplot, [real_elastic_tof, real_elastic_tof], [0.0, max(data.cwp_data)] 
  ENDIF

  return, cwp
end
