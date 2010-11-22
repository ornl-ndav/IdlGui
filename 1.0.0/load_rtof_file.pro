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
 
  nbr_pixels = size(pData,/dim)
  nbr_points = (size(*pData[0],/dim))[1]
  
  data_pixel_0 = (*pData[0])
  xaxis = data_pixel_0[0,*] 
  _pData_y = fltarr(nbr_pixels, nbr_points)
  _pData_y_error = fltarr(nbr_pixels, nbr_points)
  
  ;loop over all pixels and retrieve y and sigma_y values
  for j=0, (nbr_pixels[0]-1) do begin
  _pData_y[j,*] = (*pData[j])[1,*]
  _pData_y_error[j,*] = (*pData[j])[2,*]
  endfor
  
  return, 1b
  
END