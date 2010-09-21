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
  OBJ_DESTROY, iClass
  
  ;get commun global x-axis
  x_axis = get_commun_x_axis(pData)
  
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
  
  return, 1b
      
END

