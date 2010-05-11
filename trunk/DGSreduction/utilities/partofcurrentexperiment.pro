function PartOfCurrentExperiment, instrument, runnumber

  match = 0

  ; Get the beamtime info file for the runnumber
  beamtime_info_filename = get_beamtimeinfo_filename(instrument, runnumber)
  ; Get the proposal
  run_proposal = get_Proposal_fromPreNeXus(beamtime_info_filename)

  ; Now let's get the latest run
  lastrun = get_lastrun(instrument)
  ; Get the lastest beamtime info file...
  current_beamtime_info = get_beamtimeinfo_filename(instrument, lastrun)
  ; and use this to get the latest proposal
  current_proposal = get_Proposal_fromPreNeXus(current_beamtime_info)

  IF (run_proposal EQ current_proposal) THEN match = 1

  return, match
end
