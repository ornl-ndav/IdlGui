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
; @author : Erik Watkins
;           (refashioned by j35@ornl.gov)
;
;==============================================================================

;+
; :Description:
;    Loads the rtof data
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
  
  _file_name = file_name[0]
  iClass = obj_new('IDL3columnsASCIIparser', _file_name)
  pData = iClass->getDataQuickly()
  obj_destroy, iClass
  
;  help, *pData[10]

  _pData_x       = (*pData[0])[0]
  help, _pData_x
  
  return, 1
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