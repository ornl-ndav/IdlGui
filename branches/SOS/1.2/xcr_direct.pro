;reads x column data

function xcr_direct, input_file, x, nexus=nexus
  compile_opt idl2
  
  if (keyword_set(nexus)) then begin ;nexus
  
    file_id = h5f_open(input_file)
    data_id = h5d_open(file_id, '/entry/bank1/data_y_time_of_flight')
    data_tof = h5d_read(data_id)
    data = total(data_tof,2)
    h5d_close, data_id
    
    tof_id = h5d_open(file_id,'/entry/bank1/time_of_flight')
    tof = h5d_read(tof_id)
    tof=float(tof)/1000.0
    h5d_close, tof_id
    
    sz = size(data,/dim)
    nbr_tof = sz[0]
    array = fltarr(2,nbr_tof)
    
    for i=0, nbr_tof-1 do begin
      array[0,i] = tof[i]
      array[1,i] = data[i]
    endfor
    return, array
    
  endif else begin
  
    f=0
    g=0
    
    ;open reduced data file and count lines of data
    
    GET_LUN, unit
    openr, unit, input_file
    
    while (not EOF(unit)) do begin
      readf, unit, FORMAT = '(E,:)'
      g = g+1
    endwhile
    
    
    array = MAKE_ARRAY(x, g, /float)
    
    POINT_LUN, unit, 0
    
    readf, unit, array
    
    
    FREE_LUN, unit
    
  endelse
  
  return, array
END