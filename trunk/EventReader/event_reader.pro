;+
; !! Required IDL 8.0 or greater !!
; From any of our analysist computer do:
; > export IDL_DIR='/SNS/software/itt/idl8'
; before running that program.
; 
; to turn off IDL 8.0, 
; > export IDL_DIR=''
;
; :Description:
;    Reads an event file and create an histogram
;
; :Author: j35
;-
pro event_reader
  compile_opt idl2
  
  ;INPUT PARAMETERS ===========================================================
  
  main_path           = '/Users/j35/results/'  ;  <--- define where are the input file(s)
  
  ;Name of the various input files
  prenexus_event_file = 'CNCS_21410_neutron_event.dat'
  nexus_event_file    = 'CNCS_21410_event.nxs'
  nexus_histo_file    = 'CNCS_21410.nxs'
  
  ;mapping_file        = '/SNS/CNCS/2009_2_5_CAL/calibrations/CNCS_TS_2008_08_18.dat'
  mapping_file        = '~/results/CNCS_TS_2008_08_18.dat'
  
  ;number of banks of instrument
  nbr_bank = 50
  (scope_varfetch('nbr_bank',/enter, level=1)) = nbr_bank
  
  ;histogram parameters to use  <--- Define your histogram parameters (not used for nexus histo input)
  start_bin = 43000
  end_bin   = 63001
  bin_width = 1.0
  
  selection = ['prenexus_event','nexus_event','nexus_histo']
  input_select = 2 ;prenexus_event   <---- select which input file you want to use!
  
  ;=============================================================================
  
  data_array = !NULL ;1st column is time_stamp and 2nd column is detectorID
  case (input_select) of
    0: prenexus_event_reader, $ ;fast !
      input_file=main_path + prenexus_event_file, $
      data_array = data_array
    1: nexus_event_reader, $ ;fast !
      input_file = main_path + nexus_event_file, $
      data_array = data_array
    2: nexus_histo_reader, $ ;very very slow !!!! (several mn)
      input_file = main_path + nexus_histo_file, $
      data_array = data_array
    else:
  endcase
  
help, data_array

end

;+
; :Description:
;    Retrieve the histo data
;
; :Keywords:
;    input_file
;    data_array
;
; :Author: j35
;-
pro nexus_histo_reader, input_file = input_file, $
    data_array = data_array
  compile_opt idl2
  
  fileID = h5f_open(input_file)
  _nbrBank = scope_varfetch('nbr_bank',level=1)
  base_bank_path = ['/entry/bank','/data']
  data_array = !NULL
  for i=0,_nbrBank-1 do begin
    bank_path = base_bank_path[0] + strcompress(i+1,/remove_all) + base_bank_path[1]
    fieldID = h5d_open(fileID, bank_path)
    _data = h5d_read(fieldID)
    data_array = [data_array, _data]
    h5d_close, fieldID
  endfor
  h5f_close, fileID
  
end

;+
; :Description:
;    Retrieve the event data from the Event Nexus file
;
; :Keywords:
;    input_file
;    data_array
;
; :Author: j35
;-
pro nexus_event_reader, input_file = input_file, $
    data_array = data_array
  compile_opt idl2
  
  _nbrBank = scope_varfetch('nbr_bank',level=1)
  fileID = h5f_open(input_file)
  data_pixel_id = !NULL
  data_tof      = !NULL
  base_bank_path = ['/entry/bank','_events/']
  for i=0,_nbrBank-1 do begin
    bank_path = base_bank_path[0] + strcompress(i+1,/remove_all) + base_bank_path[1]
    
    ;pixelID
    bank_path_pixel_id = bank_path + 'event_pixel_id/'
    fieldID = h5d_open(fileID, bank_path_pixel_id)
    _data_pixel_id = h5d_read(fieldID)
    data_pixel_id = [data_pixel_id, _data_pixel_id]
    h5d_close, fieldID
    
    ;tof
    bank_path_tof = bank_path + 'event_time_of_flight/'
    fieldID = h5d_open(fileID, bank_path_tof)
    _data_tof = h5d_read(fieldID)
    data_tof = [data_tof, _data_tof]
    h5d_close, fieldID
    
  endfor
  h5f_close, fileID
  
  sz = n_elements(data_tof)
  data_array = fltarr(2,sz)
  data_array[0,*] = data_tof
  data_array[1,*] = data_pixel_id
  
end

;+
; :Description:
;    Read the event prenexus file, store the data in an array

; :Keywords:
;    input_file
;    data_array
;
; :Author: j35
;-
pro prenexus_event_reader, input_file=input_file, $
    data_array = data_array
  compile_opt idl2
  
  openr, 1, input_file
  fs = fstat(1)
  N = fs.size ; length of the file in bytes
  
  Nbytes = 4  ; data are Uint32 = 4 bytes
  nbr_elements = N / Nbytes
  event_array = lonarr(nbr_elements)
  
  readu, 1, event_array
  close, 1
  
  ;event_array = [time_stamp_0, detector_id_0, time_stamp_1, detector_id_1, ...]
  
  time_pixel = lonarr(2,nbr_elements/2)
  index_time = indgen(nbr_elements/2) * 2
  index_pixel = indgen(nbr_elements/2) * 2 + 1
  
  time_pixel[0,*] = event_array[index_time]
  time_pixel[1,*] = event_array[index_pixel]
  
  ;time_pixel is a 2d array where the first column is the list of time_stamps
  ;and the second column is the list of detector_ids
  
  data_array = time_pixel
  
end
