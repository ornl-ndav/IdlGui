function GetCWPspectrum, instrument, runnumber

  ; Let's first check to see if the NeXus file has been produced with the
  ; integrated views.

  ; TODO: We could do this by just looking for the array or check the
  ; version of TranslationService that was used?

  event2histo_nxl_exe = '/SNS/software/TESTING/bin/event2histo_nxl'
  
  
  runinfo_filename = get_runinfo_filename(instrument, runnumber)
  tmin = getMinTimefromPreNeXus(runinfo_filename)
  tmax = getMaxTimefromPreNeXus(runinfo_filename)
  tstep = getStepTimefromPreNeXus(runinfo_filename)
  event_file = get_event_filename(instrument, runnumber)
  
  ; Construct the output filename
  cache_dir = get_cwpcache_directory(INSTRUMENT, RUNNUMBER)
  outputfilename = cache_dir + '/' + STRCOMPRESS(string(runnumber),/REMOVE_ALL)
  outputfilename += '_cwp_histo.nxs'
  
  cmd_str = event2histo_nxl_exe + ' `findcalib -i ' + instrument + ' -m -b -T`'
  cmd_str += ' -i ' + event_file + ' -O ' + tmin + ' -M ' + tmax + ' -l ' + tstep
  cmd_str += ' -o ' + outputfilename
  
  ; Does the intended output file already exist?
  fileThere = FILE_TEST(outputFilename, /READ, /REGULAR)
 
  ; If the files not there then run the job 
  IF (fileThere EQ 0) THEN BEGIN
    ; make sure the spool/temp directory exists
    spawn, 'mkdir -p ' + cache_dir
    spawn, cmd_str
  ENDIF
  
  ; Now we need to read in this file and add up the spectra
  
  
  jobID = -1
  x = fltarr(1000)
  y = fltarr(1000)
  
  return, { x:x, $
    y:y, $
    jobID:jobID }
end
