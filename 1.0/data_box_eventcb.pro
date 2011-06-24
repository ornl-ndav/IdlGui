;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

;+
; :Description:
;    Parse the Data run numbers text field and create the list of
;    data run numbers
;
; :Params:
;    event
;
; :Author: j35
;-
pro parse_data_run_numbers, event
  compile_opt idl2
  
  run_number_string = strcompress(getValue(event=event, $
    uname='data_run_numbers_text_field'),/remove_all)
    
  list_of_runs = !null
  widget_control, event.top, get_uvalue=global
  
  if (run_number_string eq '') then begin
    (*(*global).list_data_runs) = list_of_runs
    return
  endif
  
  split1 = strsplit(run_number_string,',',/extract,/regex)
  sz1 = n_elements(split1)
  index1 = 0
  while (index1 lt sz1) do begin
  
    split2 = strsplit(split1[index1],'-',/extract,/regex)
    sz2 = n_elements(split2)
    if (sz2 eq 1) then begin
      list_of_runs = [list_of_runs,strcompress(split2[0],/remove_all)]
    endif else begin
      new_runs = getSequence(from=split2[0], to=split2[1])
      list_of_runs = [list_of_runs, new_runs]
    endelse
    index1++
  endwhile
  
  (*(*global).list_data_runs) = list_of_runs
  ;message for log book
  message1 = '> Data run numbers input is: ' + run_number_string
  message2 = '-> Parsing data run number:'
  message = [message1, message2]
  sz = n_elements(list_of_runs)
  index = 0
  while (index lt sz) do begin
    message = [message, '    - ' + list_of_runs[index]]
    index++
  endwhile
  (*(*global).new_log_book_message) = message
  log_book_update, event
  
end

;+
; :Description:
;    Event reached by the 'Data run numbers:' text field
;
; :Params:
;    event

; :Author: j35
;-
pro data_run_numbers_event, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;parse the input text field and create the list of runs
  list_data_runs = parse_run_numbers(event, type='Data')
  (*(*global).list_data_runs) = list_data_runs
  
  ;create list of NeXus
  list_data_nexus = create_list_of_nexus(event, $
    list_runs=list_data_runs,$
    type='data')
    
  if (list_data_nexus eq !null) then return
    
  ;(*global).instrument = determine_instrument(list_data_nexus[0])
  
  add_list_of_nexus_to_table, event, list_data_nexus, type='data'
  refresh_big_table, event=event
  
end

;+
; :Description:
;    Routine reached by the browse data button
;
; :Params:
;    event
;
; :Author: j35
;-
pro browse_data_button_event, event
  compile_opt idl2
  
  title = 'Select the data NeXus files'
  list_of_nexus = browse_nexus_button(event, $
    title=title,$
    /multiple_files)
  if (list_of_nexus[0] ne '') then begin
    widget_control, event.top, get_uvalue=global
    
      widget_control, event.top, get_uvalue=global
      (*global).instrument = determine_instrument(list_of_nexus[0])
    
    add_list_of_nexus_to_table, event, list_of_nexus, type='data'
    refresh_big_table, event=event
    
    message = ['> Browsing for Data NeXus files: ']
    sz = n_elements(list_of_nexus)
    index = 0
    while (index lt sz) do begin
      _message = '-> #' + strcompress(index,/remove_all) + ': ' + $
        list_of_nexus[index]
      message = [message, _message]
      index++
    endwhile
    log_book_update, event, message=message
    
  endif
  
end

;+
; :Description:
;    retrieve the dimension of the detector (ex: 304 by 256 for the new
;    rotated REF_L detector, 304 being the number of pixels on the  x axis 
;    and 256 the number of pixels on the y axis)
;
; :Keywords:
;    event
;    main_base
;
; :Author: j35
;-
pro retrieve_detector_configuration, event=event, main_base=main_base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global
  endif else begin
    widget_control, main_base, get_uvalue=global
  endelse
  
  big_table = (*global).big_table
  if (big_table[0,0] eq '') then return ;quit if not files loaded
  
  instrument = (*global).instrument
  if (instrument eq 'REF_M') then begin
    first_data_nexus_array = strsplit(big_table[0,0],'(',/extract)
    first_data_nexus = strtrim(first_data_nexus_array[0],2)
    iNexus = obj_new('IDLnexusUtilities', first_data_nexus, $
      spin_state='Off_Off')
  endif else begin ;REF_L
    first_data_nexus = big_table[0,0]
    iNexus = obj_new('IDLnexusUtilities', first_data_nexus)
  endelse
  if (obj_valid(iNexus)) then begin
    detector_dimension = iNexus->get_detectorDimension()
    obj_destroy, iNexus
  endif
  
  _y = strcompress(detector_dimension[0],/remove_all)
  _x = strcompress(detector_dimension[1],/remove_all)
  
  putValue, base=main_base, event=event, 'detector_dimension_x', _x
  putValue, base=main_base, event=event, 'detector_dimension_y', _y
  
end

;+
; :Description:
;    Using the first data nexus file loaded, this routine
;    retrieves the distance Sample to Detector and Moderator to Detector
;
; :Keywords:
;    event
;    main_base
;
; :Author: j35
;-
pro retrieve_data_nexus_distances, event=event, main_base=main_base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global
  endif else begin
    widget_control, main_base, get_uvalue=global
  endelse
  
  big_table = (*global).big_table
  
  instrument = (*global).instrument
  if (instrument eq 'REF_M') then begin
  
    first_data_nexus_array = strsplit(big_table[0,0],'(',/extract)
    first_data_nexus = strtrim(first_data_nexus_array[0],2)
    if (first_data_nexus eq '') then return

    iNexus = obj_new('IDLnexusUtilities', first_data_nexus, $
      spin_state='Off_Off')
      
  endif else begin
  
    first_data_nexus = big_table[0,0]
    if (first_data_nexus eq '') then return
    
    iNexus = obj_new('IDLnexusUtilities', first_data_nexus)
    
  endelse
  
  d_SD = iNexus->get_d_SD()  
  d_MS = iNexus->get_d_MS()
  obj_destroy, iNexus
  d_SD_mm = abs(convert_distance(distance = d_SD.value,$
    from_unit = d_SD.units, $
    to_unit = 'mm'))
  d_MS_mm = abs(convert_distance(distance = d_MS.value,$
    from_unit = d_MS.units, $
    to_unit = 'mm'))
    
  d_MD_mm = d_MS_mm + d_SD_mm
  
  putValue, base=main_base, event=event, 'd_sd_uname', d_SD_mm
  putValue, base=main_base, event=event, 'd_md_uname', d_MD_mm
  
end
