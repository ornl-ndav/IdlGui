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
;    function that returns the name of the first data nexus name
;
; :Params:
;    all_tags
;
; :Returns:
;   first data nexus file name
;
; :Author: j35
;-
function get_first_data_nexus, all_tags
  compile_opt idl2
  
  sz = n_elements(all_tags)
  _index = 0
  while (_index lt sz) do begin
    if (strmatch(all_tags[_index],'#F data:*')) then begin
      part2 = strsplit(all_tags[_index],':',/extract)
      return, part2[1]
    endif
    _index++
  endwhile
  return, ''
  
end

;+
; :Description:
;    Loads the rtof data and retrieve the name of the first nexus data
;    file. This one will be used to get the geometry of the instrument and
;    perform the conversion pixel/tof -> Qz/Qx
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
  if (~obj_valid(iClass)) then begin
  
    ;if there is already a rtof file loaded, keep the rtof_nexus_base alive
    rtof_file = getValue(event=event, uname='rtof_file_text_field_uname')
    if (~file_test(rtof_file[0])) then begin
      mapBase, event=event, uname='rtof_nexus_base', status=0
    endif
    return, 0b
    
  endif
  
  pData = iClass->getDataQuickly()
  all_tags = iClass->getAllTag()
  obj_destroy, iClass
  
  first_data_nexus = get_first_data_nexus(all_tags)
  first_data_nexus = strtrim(first_data_nexus,2)
  if (first_data_nexus ne '') then begin
    putValue, event=event, 'rtof_nexus_geometry_file', first_data_nexus
    mapBase, event=event, uname='rtof_nexus_base', status=1
    
    ;check that file is where it's supposed to !
    if (file_test(first_data_nexus,/read)) then begin
      (*global).rtof_nexus_geometry_exist = 1b
      display_file_found_or_not, event=event, status=1
    endif else begin
      (*global).rtof_nexus_geometry_exist = 0b
      display_file_found_or_not, event=event, status=0
    endelse
  endif
  
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