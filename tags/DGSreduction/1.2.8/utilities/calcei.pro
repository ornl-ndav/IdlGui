function CalcEi, Instrument, RunNumber, Estimate, NEXUSFILE=nexusfile

  Ei = 0.0
  fileThere = 0
  
  findnexus_exe = 'findnexus'
  cvlog_extract_exe = 'simple_cvlog_reader.py'
  
  ; Uppercase the instrument name
  instrument = STRUPCASE(instrument)
  
  ; Has the NeXus file been specified ?
  IF KEYWORD_SET(NEXUSFILE) THEN BEGIN
    nxfile = NEXUSFILE
  ENDIF ELSE BEGIN
    ; Else just find the NeXus file
    findnexus_cmd = findnexus_exe + ' -i ' + instrument + ' ' + strcompress(string(runnumber), /REMOVE_ALL)
    spawn, findnexus_cmd, listening
    nxfile = listening[0]
  ENDELSE
  
  ; Let's see if the first string returned by findnexus exists and is readable
  nexusThere = FILE_TEST(nxfile, /READ, /REGULAR)
  
  ; If the NeXus file isn't readable then just return (and print and error message)
  IF (nexusThere EQ 0) THEN BEGIN
    ok = ERROR_MESSAGE("NeXus file (" + nxfile + ") does not exist.  Please check run number(s)")
    return, Estimate
  ENDIF
  
  print, 'Opening NeXus file : ' + NXFILE
  
  ; Open the file
  fileID = h5f_open(nxfile)
  
  
  ; Now lets read the moderator distance
  moderatorDistance_fieldID = H5D_OPEN(FILEID, '/entry/instrument/moderator/distance')
  sample_moderator_distance = H5D_READ(moderatorDistance_fieldID)
  ; Let's swap this around to be a moderator->sample distance
  moderator_sample_distance = sample_moderator_distance * (-1.0)
  print, 'Moderator -> Sample Distance is ' + STRCOMPRESS(moderator_sample_distance, /REMOVE_ALL) + ' metres'
  
  ; Monitor 1
  monitor1Distance_fieldID = H5D_OPEN(FILEID, '/entry/monitor1/distance')
  monitor1_distance = H5D_READ(monitor1Distance_fieldID)
  ; Make distance relative to moderator
  monitor1_distance += moderator_sample_distance
  print, 'Monitor 1 Distance is ' + STRCOMPRESS(monitor1_distance, /REMOVE_ALL) + ' metres'
  ; Get TOF array
  monitor1_tof_fieldID = H5D_OPEN(FILEID, '/entry/monitor1/time_of_flight')
  monitor1_tof_raw = H5D_READ(monitor1_tof_fieldID)
  ; Take the centre of the bins
  monitor1_tof = uncentre_bins(monitor1_tof_raw)
  ; Get the Counts...
  monitor1_counts_fieldID = H5D_OPEN(FILEID, '/entry/monitor1/data')
  monitor1_counts = H5D_READ(monitor1_counts_fieldID)
  
  plot,monitor1_tof, monitor1_counts
  
  ; Monitor 2
  monitor2Distance_fieldID = H5D_OPEN(FILEID, '/entry/monitor2/distance')
  monitor2_distance = H5D_READ(monitor2Distance_fieldID)
  ; Make distance relative to moderator
  monitor2_distance += moderator_sample_distance
  print, 'Monitor 2 Distance is ' + STRCOMPRESS(monitor2_distance, /REMOVE_ALL) + ' metres'
  ; Get TOF array
  monitor2_tof_fieldID = H5D_OPEN(FILEID, '/entry/monitor2/time_of_flight')
  monitor2_tof_raw = H5D_READ(monitor2_tof_fieldID)
  ; Take the centre of the bins
  monitor2_tof = uncentre_bins(monitor2_tof_raw)
  ; Get the Counts...
  monitor2_counts_fieldID = H5D_OPEN(FILEID, '/entry/monitor2/data')
  monitor2_counts = H5D_READ(monitor2_counts_fieldID)
  
  oplot, monitor2_tof, monitor2_counts, COLOR=160
  
  ; Duration
  duration_fieldID = H5D_OPEN(FILEID, '/entry/duration')
  duration = H5D_READ(duration_fieldID)
  print,'Duration = ', duration
  
  ; Proton Charge
  proton_fieldID = H5D_OPEN(FILEID, '/entry/proton_charge')
  proton_charge = H5D_READ(proton_fieldID)
  print,'Proton Charge = ', proton_charge
  
  
  
  ; For now we are just going to return the estimate!
  result = estimate
  
  return, result
end
