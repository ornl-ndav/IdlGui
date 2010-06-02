function GetCWPspectrum, instrument, runnumber, ROWS=ROWS

  ; Let's first find the NeXus filename
  findnexus_cmd = 'findnexus -i ' + instrument + ' ' + strcompress(string(runnumber), /REMOVE_ALL)
  spawn, findnexus_cmd, listening
  nexusfile = listening[0]
  
  print, 'Reading ', nexusfile
  
  file_id = h5f_open(nexusfile)
  
  ; Let's get the tof array
  data_tof_id = H5D_OPEN(file_id, '/entry/bank1/time_of_flight')
  dataspace_tof_id = H5D_GET_SPACE(data_tof_id)
  tof = H5D_READ(data_tof_id, FILE_SPACE=dataspace_tof_id)
  
  ranges = getcwpdetectorrange(instrument, ROWS=ROWS)
  nchannels = N_ELEMENTS(tof) - 1
  nrows = ranges.upper_row - ranges.lower_row
  
  FOR index = ranges.lower_bank, ranges.upper_bank DO BEGIN
    dataset_id = H5D_OPEN(file_id, '/entry/bank'+STRCOMPRESS(string(index),/REMOVE_ALL)+'/data')
    dataspace_id = H5D_GET_SPACE(dataset_id)
    
    start = [0, ranges.lower_row, 0]
    count = [nchannels, nrows, 8]
    H5S_SELECT_HYPERSLAB, DATASPACE_ID, start, count, /RESET
    
    memory_space_id = H5S_CREATE_SIMPLE(count)
    
    data = H5D_READ(dataset_id, FILE_SPACE=dataspace_id, MEMORY_SPACE=memory_space_id)
    
    data_tmp1 = temporary(total(data, 3))
    data_tmp2 = temporary(total(data_tmp1, 2))
    
    if (n_elements(cwp_data) EQ 0) then begin
      cwp_data =   temporary(data_tmp2)
    endif else begin
      cwp_data = cwp_data + temporary(data_tmp2)
    endelse
    
    
  ENDFOR
  
  
  ; Close the NeXus file
  H5F_CLOSE, file_id
  
  return, { tof:tof, $
    cwp_data:cwp_data, $
    nrows:nrows}
    
end
