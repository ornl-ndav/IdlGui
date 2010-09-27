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
;    Generate the commun x_axis
;    ex:
;     p
;
; :Params:
;    (*pData[0])[0] -> 2
;    (*pData[1])[0] -> 3,5
;    (*pData[2])[0] -> 2,7,8,9,11
;    will produce the following array
;    [2,3,5,7,8,9,11]
;
; :returns:
;   the commun x_axis
;
; :Author: j35
;-
function get_commun_x_axis, pData
  compile_opt idl2
  
  sz = n_elements(pData) ;number of pixels
  index = 0
  temp_global_x_axis = !NULL
  while (index lt sz) do begin
    _x_axis = float((*pData[index])[0,*])
    _sz = (size(_x_axis))[0]
    if (_sz ne 1) then begin
      _x_axis = transpose(_x_axis)
      temp_global_x_axis = [temp_global_x_axis,_x_axis]
    endif
    index++
  endwhile
  
  global_x_axis = temp_global_x_axis[uniq(temp_global_x_axis, sort(temp_global_x_axis))]
  
  return, global_x_axis[1:n_elements(global_x_axis)-1]
end

;+
; :Description:
;    this calculate the common x-axis of all the pixel
;    of a same data set
;
; :Params:
;    event
;    _pData_x   commun x-axis but with missing values (ex: [0,2,4,10,12,18])
;
; :Returns:
;   returns the x-axis without missing values (ex: [0,2,4,6,8,10,12,14,16,18])
;
; :Author: j35
;-
function create_x_axis_data_sets, event, _pData_x
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;retrieve minimum increment
  sz = n_elements(_pData_x)
  case (sz) of
    0: increment = 0
    1: increment = 0
    2: increment = _pData_x[1]-_pData_x[0]
    else: begin
      increment = _pData_x[1]-_pData_x[0]
      index = 2
      while(index lt sz) do begin
        tmp_increment = _pData_x[index]-_pData_x[index-1]
        if (tmp_increment lt increment) then increment = tmp_increment
        index++
      endwhile
    end
  endcase
  
  if (increment eq 0) then begin
    _pData_x_2d = !NULL
  endif else begin
    new_sz = (_pData_x[sz-1] - _pData_x[0]) / increment
    _pData_x_2d = indgen(new_sz+1) * increment + _pData_x[0]
  endelse
  
  (*(*global).tmp_pData_x_2d) = _pData_x_2d
  return, _pData_x_2d
  
end

;+
; :Description:
;    this will create the 2d of each data sets loaded to
;    be used directly by tv for right-click-> plot of data
;
; :Params:
;    event
;
; :Author: j35
;-
pro create_2d_data_sets, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  create_x_axis_data_sets, event
  _pData_x_2d = (*(*global).tmp_pData_x_2d)
  
  _pData_x = (*(*global).tmp_pData_x) ;x_axis -> help, _pData_x => Array[61]
  _pData_y = (*(*global).tmp_pData_y) ;y_axis -> help, -pData_y => Array[<nbr_pixel>,<nbr_x_axis_data>]
  _pData_y_error = (*(*global).tmp_pData_y_error)

  sz_2d_x_axis = (size(_pData_x_2d))[1]
  sz_x_axis    = (size(_pData_x))[1]

  if (sz_2d_x_axis eq sz_x_axis) then begin
  
  
  
  endif

end

;+
; :Description:
;    Add the tmp_pData_x, tmp_pData_y and tmp_pData_y_error
;    to the full list of data (x, y and error)
;
; :Params:
;    event
;
; :Author: j35
;-
pro add_data_to_list_of_loaded_data, event, spin_state=spin_state
  compile_opt idl2
  
  if (n_elements(spin_state) eq 0) then spin_state = 0
  
  widget_control, event.top, get_uvalue=global
  
  _pData_x = (*(*global).tmp_pData_x)
  _pData_y = (*(*global).tmp_pData_y)
  _pData_y_error = (*(*global).tmp_pData_y_error)
  
  ;find first empty entry using the table data
  files_SF_list = (*global).files_SF_list
  file_names = files_SF_list[spin_state,0,*]
  empty_index = where(file_names eq '',nbr)
  if (nbr ne -1) then new_entry_index = empty_index[0] ;where to put the new data
  
  pData_x       = (*global).pData_x
  pData_y       = (*global).pData_y
  pData_y_error = (*global).pData_y_error
  
  *pData_x[new_entry_index,spin_state]       = _pData_x
  *pData_y[new_entry_index,spin_state]       = _pData_y
  *pData_y_error[new_entry_index,spin_state] = _pData_y_error
  
  (*global).pData_x       = pData_x
  (*global).pData_y       = pData_y
  (*global).pData_y_error = pData_y_error


  ;!!!INFO!!!!
  ; use transpose *(pData_y[0,0]) to plot spin_state:0 or Off_Off
  ; 1st file loaded and x-axis is tof and y-axis if pixel
  ; help, *pData_x[0,0]
  ; help, *pData_y[0,0]
  ; tvscl, transpose(*pData_y[0,0])
  
  ;SEEMS USELESS FOR NOW
  ;create_2d_data_sets, event
  
  ;*pData_x_2d[new_entry_index,spin_state]       = (*(*global).tmp_pData_x_2d)
  ;*pData_y_2d[new_entry_index,spin_state]       = (*(*global).pData_y_2d)
  ;*pData_y_error_2d[new_entry_index,spin_state] = (*(*global).pData_y_error_2d)
  
  ;(*global).pData_x_2d       = pData_x_2d
  ;(*global).pData_y_2d       = pData_y_2d
  ;(*global).pData_y_error_2d = pData_y_error_2d
  
  
  
  
  
  
  
  
  
  
end

;+
; :Description:
;    Loads the rtof data into a big pointer array
;
; :Params:
;    event
;    file_name
;
; :Returns:
;   status of the load
;
; :Author: j35
;-
function load_rtof_file, event, file_name
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  iClass = OBJ_NEW('IDL3columnsASCIIparser', file_name)
  pData = iClass->getDataQuickly()
  start_pixel = iClass->getStartPixel()
  (*global).tmp_start_pixel = start_pixel
  OBJ_DESTROY, iClass
  
  ;get commun global x-axis
  tmp_x_axis = get_commun_x_axis(pData)
  x_axis = create_x_axis_data_sets(event, tmp_x_axis)
 
  ;keep only the second column
  _pData_x       = x_axis
  _pData_y       = fltarr(n_elements(pData),n_elements(_pData_x))
  _pData_y_error = fltarr(n_elements(pData),n_elements(_pData_x))
  
  ;loop over pixels
  for j=0,(n_elements(pData)-1) do begin ;retrieve y_array and error_y_array
    _xarray             = (*pData[j])[0,*] ;retrieve x-array
    sz = n_elements(_xarray)
    if (sz ge 2) then begin
      ;loop over yaxis values
      for i=0,sz-1 do begin
        _x = _xarray[i] ;retrieve local x value
        _x_index = where(_x eq x_axis, nbr) ;find position of x value in global x_axis
        if (nbr ne 0) then begin
          _pData_y[j,_x_index[0]] = (*pData[j])[1,i]
          _pData_y_error[j,_x_index[0]] = (*pData[j])[2,i]
        endif
      endfor
    endif
  ;Debug
  ;_pData_y[j,*]       = (*pData[j])[1,*]
  ;_pData_y_error[j,*] = (*pData[j])[2,*]
  endfor
  
  (*(*global).tmp_pData_x) = _pData_x ;x_axis -> help, _pData_x => Array[61]
  (*(*global).tmp_pData_y) = _pData_y ;y_axis -> help, -pData_y => Array[<nbr_pixel>,<nbr_x_axis_data>]
  (*(*global).tmp_pData_y_error) = _pData_y_error
  
  add_data_to_list_of_loaded_data, event
  
  return, 1b
  
END

