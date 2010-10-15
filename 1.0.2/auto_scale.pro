;===============================================================================
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
;===============================================================================

;+
; :Description:
;    Calculate the region of overlap between the two arrays given
;
; :Keywords:
;   left_array
;   right_array
;
; :Author: j35
;-
function get_overlap_region , left_array = left_array, $
    right_array = right_array
  compile_opt idl2
  
  tof_min = right_array[0]
  tof_max = left_array[-1]
  
  if (tof_min gt tof_max) then return, [-1,-1]
  
  return, [tof_min, tof_max]
  
end

;+
; :Description:
;    returns an array of index of the files sorted
;    accordingly to their tof axis
;
; :Params:
;    xArray
;
; ;Returns:
;   array of index
;
; :Author: j35
;-
function sort_files, xArray
  compile_opt idl2
  
  tof_min_array = !NULL
  sz = (size(xArray))[1]
  for i=0, sz-1 do begin
    _xArray = *xArray[i]
    tof_min_array = [tof_min_array, _xArray[0]]
  endfor
  
  return, sort(tof_min_array)
  
end

;+
; :Description:
;    returns the array of data of only the common region between the
;    left and right arrays
;
; :Params:
;   event
;
; :Keywords:
;    data
;    xaxis
;    overlap_tof_array
;    error      ;0: ok, -1: stop
;
; :Returns:
;     the common array region
;
; :Author: j35
;-
function get_overlap_array, event, $
    data=data,$
    xaxis=xaxis, $
    overlap_tof_array = overlap_tof_array, $
    error = error
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;left side
  index_left = where(overlap_tof_array[0] eq xaxis)
  
  ;right_side
  index_right = where(overlap_tof_array[1] eq xaxis)
  
  ;exclure top and bottom region
  top_bottom_exclusion_percentage = (*global).top_bottom_exclusion_percentage
  
  nbr_pixel = (size(data))[1]
  nbr_pixel_to_remove = fix((float(top_bottom_exclusion_percentage)/100.)*$
    float(nbr_pixel))
    
  ;make sure we remove at least 1 pixel
  if (nbr_pixel_to_remove eq 0) then nbr_pixel_to_remove++
  
  pixel_bottom_index = nbr_pixel_to_remove
  pixel_top_index = nbr_pixel - nbr_pixel_to_remove - 1
  
  if (pixel_bottom_index ge pixel_top_index) then begin
    error = 1
    return, data
  endif
  
  _data = data[pixel_bottom_index:pixel_top_index,index_left:index_right]
  return, _data
  
end

;+
; :Description:
;   Calculate the scaling factor
;
; :Params:
;    left_overlap_data
;    right_overlap_data
;
; :Returns:
;   the scaling factor to be applied to the right data set
;
; :Author: j35
;-
function calculate_SF, left_overlap_data, right_overlap_data
  compile_opt idl2
  
  nbr_tof = (size(left_overlap_data))[2]
  sf_mean = fltarr(nbr_tof)
  index = 0
  while (index lt nbr_tof) do begin
    left_mean = mean(float(left_overlap_data[*,index]))
    right_mean = mean(float(right_overlap_data[*,index]))
    _sf = right_mean/left_mean
    sf_mean[index] = _sf
    index++
  endwhile
  
  return, mean(sf_mean)
  
end

;+
; :Description:
;    This just creates a soft copy of the individual data sets.
;    This copy will be used to rescaled the data
;
; :Params:
;    event

; :Author: j35
;-
pro create_clone_of_pData_y, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  pData_y = (*global).pData_y ;big table
  nbr_files = (size(pData_y))[1]
  nbr_spin = (size(pData_y))[2]
  
  pData_y_scaled = ptrarr(nbr_files,nbr_spin,/allocate_heap)
  
  for iFile=0,(nbr_files-1) do begin
    for jSpin=0, (nbr_spin-1) do begin
      _pData_y = *pData_y[iFile, jSpin]
      pData_y_scaled[iFile, jSpin] = ptr_new(0L)
      *pData_y_scaled[iFile, jSpin] = _pData_y
    endfor
  endfor
  
  (*global).pData_y_scaled = pData_y_scaled
  
end

;+
; :Description:
;    Creates a copy of the individual error data sets.
;
; :Params:
;    event
;
; :Author: j35
;-
pro create_clone_of_pData_y_error, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  pData_y_error = (*global).pData_y_error ;big table
  nbr_files = (size(pData_y_error))[1]
  nbr_spin = (size(pData_y_error))[2]
  
  pData_y_error_scaled = ptrarr(nbr_files,nbr_spin,/allocate_heap)
  
  for iFile=0,(nbr_files-1) do begin
    for jSpin=0, (nbr_spin-1) do begin
      _pData_y_error = *pData_y_error[iFile, jSpin]
      pData_y_error_scaled[iFile, jSpin] = ptr_new(0L)
      *pData_y_error_scaled[iFile, jSpin] = _pData_y_error
    endfor
  endfor
  
  (*global).pData_y_error_scaled = pData_y_error_scaled
  
end

;+
; :Description:
;    Save the big table when the user changes any of the SF values
;
; :Params:
;    event
;
; :Keywords:
;    spin_state
;
; :Author: j35
;-
pro save_table, event, spin_state=spin_state
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  files_SF_list = (*global).files_SF_list
  
  if (n_elements(spin_state) eq 0) then spin_state = 0
  
  table = getValue(id = event.id)
  files_SF_list[spin_state,*,*] = table
  (*global).files_SF_list = files_SF_list
  
end

;+
; :Description:
;    Performs the automatic scaling of the data
;
; :Params:
;    event
;
; :Author: j35
;-
pro auto_scale, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  files_SF_list = (*global).files_SF_list
  
  pData_x = (*global).pData_x ;tof axis  [row, spin_state]
  
  ;copy pData_y data into pData_y_scaled
  create_clone_of_pData_y, event
  pData_y_scaled = (*global).pData_y_scaled
  ;copy pData_y_error into pData_y_error_scaled
  create_clone_of_pData_y_error, event
  pData_y_error_scaled = (*global).pData_y_error_scaled
  
  file_index_sorted = (*global).file_index_sorted
  
  for spin=0,3 do begin ;go over all the spin states
    nbr_files = get_number_of_files_loaded(event, spin_state=spin)
    
    ;0 or just 1 file loaded for that spin state so we don't need
    ;to do anything
    if (nbr_files le 1) then continue
    
    ;make sure the files are sorted relative to their tof axis
    ;this will return an array of index of the input files
    _file_index_sorted = sort_files(pData_x[0:(nbr_files-1), spin])
    *file_index_sorted[spin] = _file_index_sorted
    
    ;go 2 by 2
    ;Method: - find the overlap region
    ;        - remove default 5% region on top and bottom
    ;        - calculate average value for each tof (left and right) and find SF
    ;        - determine average SF of all the SF
    
    left_file_index = 0
    right_file_index = 1
    while (right_file_index le (nbr_files-1)) do begin
    
      left_array = *pData_x[_file_index_sorted[left_file_index], spin]
      right_array = *pData_x[_file_index_sorted[right_file_index], spin]
      
      overlap_tof_array = get_overlap_region(left_array = left_array, $
        right_array = right_array)
      if (overlap_tof_array[0] eq -1) then begin
        ;FIXME
        ;no overlap region
        ;pop up dialog message
        return
      endif
      
      error = 0
      ;isolate left and right arrays of this region
      left_data = *pData_y_scaled[_file_index_sorted[left_file_index],spin]
      left_overlap_array = get_overlap_array(event, $
        data=left_data,$
        xaxis=left_array, $
        overlap_tof_array = overlap_tof_array,$
        error = error)
      if (error) then begin
        ;FIXME
        ;dialog message about not enough pixels to be able to remove $
        ;top and bottom percentage
        return
      endif
      
      right_data = *pData_y_scaled[_file_index_sorted[right_file_index],spin]
      right_overlap_array = get_overlap_array(event, $
        data=right_data,$
        xaxis=right_array, $
        overlap_tof_array = overlap_tof_array, $
        error = error)
      if (error) then begin
        ;FIXME
        ;dialog message about not enough pixels to be able to remove 
        ;top and bottom percentage
        return
      endif
      
      ;calculate SF
      SF = calculate_SF(left_overlap_array, right_overlap_array)
      
      ;put 1 as SF for first file
      if (left_file_index eq 0) then begin
        files_SF_list[spin, 1, _file_index_sorted[0]] = $
        strcompress(1,/remove_all)
      endif
      
      files_SF_list[spin, 1, _file_index_sorted[right_file_index]] = $
      strcompress(SF,/remove_all)
      
      *pData_y_scaled[_file_index_sorted[right_file_index],spin] /= SF
      *pData_y_error_scaled[_file_index_sorted[right_file_index],spin] /= SF
      
      left_file_index = right_file_index
      right_file_index++
    endwhile
    
  endfor
  
  (*global).pData_y_scaled = pData_y_scaled
  (*global).pData_y_error_scaled = pData_y_error_scaled
  (*global).file_index_sorted = file_index_sorted
  
  (*global).files_SF_list = files_SF_list
  refresh_table, event
  
end