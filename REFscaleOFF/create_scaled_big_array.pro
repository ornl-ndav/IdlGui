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
;    Creates the common axis to the two given axes
;    ex: _axis_left = [0,2,4,8,10,15]
;        _axis_right = [10,12,20,22,24]
;        returns: [0,2,4,6,8,10,12,14,16,18,20,22,24]
;
; :Params:
;    _axis_left
;    _axis_right
;
; :Author: j35
;-
function create_merged_common_axis, _axis_left, _axis_right
  compile_opt idl2
  
  ;get min and max values -> min and max values of common axis
  _min = min([_axis_left,_axis_right],max=_max)
  
  ;get min interval
  sz1 = n_elements(_axis_left)
  delta1 = !NULL
  if (sz1 ge 2) then begin
    delta1 = _axis_left[1]-_axis_left[0]
    _index_left = 1
    while (_index_left lt sz1-1) do begin
      _delta1 = _axis_left[_index_left+1] - _axis_left[_index_left]
      delta1 = (_delta1 lt _delta1) ? _delta1 : delta1
      _index_left++
    endwhile
  endif
  
  sz2 = n_elements(_axis_right)
  delta2 = !NULL
  if (sz2 ge 2) then begin
    delta2 = _axis_right[1]-_axis_right[0]
    _index_right = 1
    while (_index_right lt sz2-1) do begin
      _delta2 = _axis_right[_index_right+1] - _axis_right[_index_right]
      delta2 = (_delta2 lt _delta2) ? _delta2 : delta2
      _index_right++
    endwhile
  endif
  
  delta = min(delta1,delta2)
  new_element = _min
  _common_axis = !NULL
  while (new_element le _max) do begin
    _common_axis = [_common_axis,new_element]
    new_element += delta
  endwhile
  
  return, _common_axis
  
end

;+
; :Description:
;    Creates the common x-axis of the data loaded
;
; :Params:
;    event
;
; :Author: j35
;-
function  create_common_xaxis, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  pData_x = (*global).pData_x
  file_index_sorted = (*global).file_index_sorted
  
  common_xaxis = ptrarr(4,/allocate_heap) ;for the 4 spin states
  
  for spin=0,3 do begin ;go over all the spin states
  
    nbr_files = get_number_of_files_loaded(event, spin_state=spin)
    
    ;0 or just 1 file loaded for that spin state so we don't need
    ;to do anything
    if (nbr_files le 1) then continue
    
    _file_index_sorted = *file_index_sorted[spin] ;local list of index of files sorted
    
    left_file_index = 0
    right_file_index = 1
    
    ;initialize the array of common xaxis for current spin
    *common_xaxis[spin] = ptr_new(0L)
    _common_xaxis = *pData_x[_file_index_sorted[left_file_index]]
    
    while (right_file_index le (nbr_files-1)) do begin
    
      _xaxis_left = _common_xaxis
      _xaxis_right = *pData_x[_file_index_sorted[right_file_index]]
      
      _common_xaxis = create_merged_common_axis(_xaxis_left, _xaxis_right)
      
      left_file_index = right_file_index
      right_file_index++
    endwhile
    
    *common_xaxis[spin] = _common_xaxis
    
  endfor
  
  return, common_xaxis
  
end

;+
; :Description:
;    Create the master scaled data and error data sets
;
; :Params:
;    event
;
; :Keywords:
;    xaxis
;
; :Author: j35
;-
pro create_common_global_data, event, xaxis=xaxis
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  data = (*global).pData_y_scaled
  data_error = (*global).pData_y_error_scaled
  
  master_data = ptrarr(4,/allocate_heap) ;for the 4 spin states
  master_data_error = ptrarr(4,/allocate_heap) ;data error for the 4 spin states
  pData_x = (*global).pData_x
  file_index_sorted = (*global).file_index_sorted
  
  for spin=0,3 do begin ;go over all the spin states
  
    nbr_files = get_number_of_files_loaded(event, spin_state=spin)
    
    ;0 or just 1 file loaded for that spin state so we don't need
    ;to do anything
    if (nbr_files le 1) then continue
    
    _file_index_sorted = *file_index_sorted[spin]
    
    ;get size of xaxis for that spin (tof)
    _xaxis_spin = *xaxis[spin] ;common global x axis of given spin state
    _x_sz = n_elements(_xaxis_spin)
    
    ;get number of element in yaxis (pixels)
    _data_spin = *data[0,spin] ;scaled data of given spin state
    _y_sz = (size(_data_spin))[1]
    
    ;initialize master array
    *master_data[spin] = ptr_new(0L)
    _master_data = fltarr(_y_sz, _x_sz) ;Array[<pixel>,<tof>]
    *master_data_error[spin] = ptr_new(0L)
    _master_data_error = fltarr(_y_sz, _x_sz) ;ex [<pixel>,<tof>]

    ;Method
    ;loop over all the files
    ;then loop over each xaxis
    ;find where they are in the global axis and keep that index
    ;check if there are any values already in the global rescale data at that
    ;index and if yes, add mean, otherwise just add all tof array at that location
    iFile = 0
    while (iFile lt nbr_files) do begin
    
      _xaxis = *pData_x[_file_index_sorted[iFile]]
      _ydata = *data[_file_index_sorted[iFile],spin]
      _ydata_error = *data_error[_file_index_sorted[iFile],spin]
      
      _sz_axis = n_elements(_xaxis)
      for i=0,(_sz_axis-1) do begin
      
        ;where the local tof index is in the global axis axis
        _where = where(_xaxis[i] eq _xaxis_spin)

        _new_tof_array_at_given_tof = _ydata[*,i]
        _new_tof_array_error_at_given_tof = _ydata_error[*,i]
        _total_global_tof_array_at_given_tof = total(_master_data[*,_where[0]])
        if (_total_global_tof_array_at_given_tof ne 0) then begin
          
          ;value
          _new = _new_tof_array_at_given_tof
          _prev = _master_data[*,_where[0]]
          
          ;value error
          _new_error = _new_tof_array_error_at_given_tof
          _prev_error = _master_data_error[*,_where[0]]
          
          ;global var
          _new_error_2 = _new_error * _new_error
          _1_new_error_2 = 1./_new_error_2
          _prev_error_2 = _prev_error * _prev_error
          _1_prev_error_2 = 1./_prev_error_2
          
          ;average value
          _num = _prev * _1_prev_error_2 + _new * _1_new_error_2
          _den = _1_prev_error_2 + _1_new_error_2
          _average = _num / _den

          ;average value error
          _average_error = 1./sqrt(_den)
          
          _master_data[*,_where[0]] = _average
          _master_data_error[*,_where[0]] = _average_error
  
        endif else begin
  
          _master_data[*,_where[0]] = _new_tof_array_at_given_tof
          _master_data_error[*,_where[0]] = _new_tof_array_error_at_given_tof
    
        endelse
        
      endfor
      
      iFile++
    endwhile
    
    *master_data[spin] = _master_data
    *master_data_error[spin] = _master_data_error
    
  endfor
  
  (*global).master_data_error = master_data_error
  (*global).master_data = master_data
  
end

;+
; :Description:
;    This takes the scaled individual arrays and creates the big array of data
;    as well as the common x-axis
;
; :Params:
;    event

; :Author: j35
;-
pro create_scaled_big_array, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  xaxis = create_common_xaxis(event)
  (*global).master_xaxis = xaxis
  
  create_common_global_data, event, xaxis=xaxis
    
end
