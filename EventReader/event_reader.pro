;+
; :Description:
;    Reads an event file and create an histogram
;
; :Author: j35
;-
pro event_reader
  compile_opt idl2
  
  ;INPUT PARAMETERS ======================
  
  main_path           = '~/results/'  ;  <--- define where are the input file(s)
  ;Name of the various input files
  prenexus_event_file = 'CNCS_21410_neutron_event.dat'
  nexus_event_file    = 'CNCS_21410_event.nxs'
  nexus_histo_file    = 'CNCS_21410.nxs'
  
  ;mapping_file        = '/SNS/CNCS/2009_2_5_CAL/calibrations/CNCS_TS_2008_08_18.dat'
  mapping_file        = '~/results/CNCS_TS_2008_08_18.dat'
  
  ;histogram parameters to use  <--- Define your histogram parameters (not used for nexus histo input)
  start_bin = 43000
  end_bin   = 63001
  bin_width = 1.0
  
  selection = ['prenexus_event','nexus_event','nexus_histo']
  input_select = 0 ;prenexus_event   <---- select which input file you want to use!
  
  ;=========================================
  
  case (input_select) of
    0: prenexus_event_reader, $
      input_file=main_path + prenexus_event_file, $
      mapping_file = mapping_file, $
      bin_parameters = [start_bin, end_bin, bin_width]
;    1: nexus_event_reader, $
;      input_file = main_path + nexus_event_file, $
;      bin_parameters = [start_bin, end_bin, bin_width]
;    2: nexus_histo_reader, $
;      input_file = main_path + nexus_histo_file
    else:
  endcase
  
end

;+
; :Description:
;    Read the event prenexus file, store the data in an array and creates an histo
;    using the mapping file

; :Keywords:
;    input_file
;    mapping_file
;    bin_parameters
;
; :Author: j35
;-
pro prenexus_event_reader, input_file=input_file, $
    mapping_file=mapping_file, $
    bin_parameters=bin_parameters
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
  
  
  
  
end
