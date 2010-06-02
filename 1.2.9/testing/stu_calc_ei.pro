;+
; :Description:
;    Describe the procedure.
;
; :Params:
;    filename : in, Type=String
;      name of the nexus file.
;
; :Keywords:
;    Debug : optional
;      switches on debugging output
;
; :Author: scu
;-
pro stu_calc_ei, filename, Debug=debug

  ; lets read in some test data
  filename = "/SNS/users/scu/IDLWorkspace/CalcEi/data/ARCS_1005.nxs"
  ;filename = "/SNS/ARCS/IPTS-1119/11/573/NeXus/ARCS_573.nxs"
  
  ; Lets get the monitors
  mon1 = get_monitor(filename, 1)
  mon2 = get_monitor(filename, 2)
  
  ; moderator (for the distance)
  moderator=get_moderator(filename)
  
  monitor1_distance = -moderator.distance+mon1.distance
  monitor2_distance = -moderator.distance+mon2.distance
  
  if KEYWORD_SET(debug) then begin
    print,'FILENAME: '+filename
    print,' Monitor #1'
    print,'   --> Distance from moderator : '+STRTRIM(monitor1_distance, 2)+' metres'
    print,' Monitor #2'
    print,'   --> Distance from moderator : '+STRTRIM(monitor2_distance, 2)+' metres'
  endif
  
  ; At the moment, let us just take the maximum of the data set and use that to fit
  ; a gaussian  
  ; TODO - needs improving...
  mon1fit = GAUSSFIT(uncentre_bins(mon1.tof), mon1.data, mon1coeffs)
  monitor1_tof = mon1coeffs[1]
 
  
  ;plot, uncentre_bins(mon1.tof), mon1.data, xrange=[monitor1_tof-(0.1*monitor1_tof),monitor1_tof+(0.1*monitor1_tof)]
  plot, uncentre_bins(mon1.tof), mon1.data
  oplot, uncentre_bins(mon1.tof), mon1fit
  
  print,' TOF = '+STRTRIM(monitor1_tof, 2)
  
  
  monitor1_lambda = monitor1_tof / (252.8*monitor1_distance)
  
  monitor1_energy = 81.787 / (monitor1_lambda*monitor1_lambda)
  
  print,' Wavelength = '+STRTRIM(monitor1_lambda, 2)
  print,' Energy = '+STRTRIM(monitor1_energy, 2)
  
end