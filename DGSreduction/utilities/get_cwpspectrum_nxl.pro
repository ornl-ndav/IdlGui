function Get_CWPspectrum_NXL, instrument, runnumber

  ; Let's first check to see if the NeXus file has been produced with the
  ; integrated views.

  ; TODO: We could do this by just looking for the array or check the
  ; version of TranslationService that was used?


    event2histo_nxl_exe = '/SNS/software/TESTING/bin/event2histo_nxl'
    
    runinfo_filename = get_runinfo_filename(instrument, runnumber)
    tmin = get_MinTime_fromPreNeXus(runinfo_filename)
    tmax = get_MaxTime_fromPreNeXus(runinfo_filename)
    tstep = get_StepTime_fromPreNeXus(runinfo_filename)
    event_file = get_event_filename(instrument, runnumber)
    
    ; Construct the output filename
    cache_dir = get_cwpcache_directory(INSTRUMENT, RUNNUMBER)
    outputfilename = cache_dir + '/' + STRCOMPRESS(string(runnumber),/REMOVE_ALL)
    outputfilename += '_cwp_histo.nxs'
    
    cmd_str = event2histo_nxl_exe + ' `findcalib -i ' + instrument + ' -m -b -T`'
    cmd_str += ' -i ' + event_file + ' -O ' + tmin + ' -M ' + tmax + ' -l ' + tstep
    cmd_str += ' -o ' + outputfilename
    ; optional debug output
    cmd_str += ' > ' + outputfilename + '.log'
    ; and copy the command to a file as well?
    spawn, "echo " + cmd_str + " > " + outputfilename + ".cmd"
    
;    print, tmin
;    print, tmax
;    print, tstep
    
    ; Does the intended output file already exist?
    fileThere = FILE_TEST(outputFilename, /READ, /REGULAR)
    
    ; If the files not there then run the job
    IF (fileThere EQ 0) THEN BEGIN
      ; make sure the cache directory exists
      spawn, 'mkdir -p ' + cache_dir
      print, cmd_str
      spawn, cmd_str
    ENDIF
    
    ranges = get_cwpdetectorrange(instrument)
    
    ; Now we need to read in this file and add up the spectra
    file_id = h5f_open(outputFilename)
    
    nelements = (long(tmax) - long(tmin)) / long(tstep)
    tof = (findgen(nelements+1) * tstep) + tmin
    
    print, nelements
    
    cwp_data = fltarr(nelements)
    
    for index = ranges.lower_bank, ranges.upper_bank do begin
    
    
      dataset_id = H5D_OPEN(file_id, '/entry/bank'+STRCOMPRESS(string(index),/REMOVE_ALL)+'/data_y_time_of_flight')
      dataspace_id = H5D_GET_SPACE(dataset_id)
      
      start = [0, ranges.lower_row]
      count = [nelements, 10]
      H5S_SELECT_HYPERSLAB, DATASPACE_ID, start, count, /RESET
      memory_space_id = H5S_CREATE_SIMPLE(count)
      
      ; Read the data
      data = H5D_READ(dataset_id, FILE_SPACE=dataspace_id, MEMORY_SPACE=memory_space_id)
      
      H5S_CLOSE, memory_space_id
      H5S_CLOSE, dataspace_id
      H5D_CLOSE, dataset_id
      
      sum = total(data,2)
      cwp_data = data + TEMPORARY(sum)
      
    endfor
    
    ; Close the NeXus file
    H5F_CLOSE, file_id
    
    return, { tof:tof, $
      cwp_data:cwp_data }

end
