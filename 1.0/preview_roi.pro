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
;    This function parses the ROI text box and retrieves the ROIs as
;    [[xmin0,ymin0,xmax0,ymax0],[xmin1,ymin1,xmax1,ymax1]]
;
;
;
; :Keywords:
;    event
;    base
;
; :Author: j35
;-
function retrieve_list_roi, event=event, base=base
  compile_opt idl2
  
  pixel_list = getValue(event=event, base=base, uname='roi_text_field_uname')
  nbr_lines = n_elements(pixel_list)
  
  on_ioerror, format_error
  
  _index = 0
  list_roi = !null
  while (_index lt nbr_lines) do begin
  
    _line = strcompress(pixel_list[_index],/remove_all)
    if (_line eq '') then begin
      _index++
      continue
    endif
    
    _line_split = strsplit(_line,',',/extract,/regex)
    if (n_elements(_line_split) ne 4) then begin
      _index++
      continue
    endif
    
    list_roi = [list_roi, _line]
    
    _index++
  endwhile
  
  ;ok, we got rid of the empty lines or row with missing x or y
  sz = n_elements(list_roi)
  if (sz eq 0) then return, ['']
  
  final_list = intarr(sz,4)
  _index=0
  while (_index lt sz) do begin
  
    _line_split = strsplit(list_roi[_index],',',/extract,/regex)
    final_list[_index,*] = _line_split
    
    _index++
  endwhile
  
  on_ioerror, null
  return, final_list

  format_error:
    return, ['']
  
end

;+
; :Description:
;    Convert from data to device values the x0, y0, x1 and y1 values
;
; :Params:
;    data_array
;
; :Keywords:
;    event
;    base
;
; :Returns:
;   [x0_device, y0_device, x1_device, y1_device]
;
; :Author: j35
;-
function convert_data_to_device, event=event, base=base, data_array
  compile_opt idl2
  
  if (keyword_set(event)) then begin
  widget_control, event.top, get_uvalue=global
  id_draw = widget_info(Event.top, find_by_uname='preview_draw_uname')
  endif else begin
  widget_control, base, get_uvalue=global
  id_draw = widget_info(base, find_by_uname='preview_draw_uname')
  endelse
  
  size_preview_data = (*global).size_preview_data ;[2048,2048]
  xsize_data = size_preview_data[0]
  ysize_data = size_preview_data[1]
  
  geometry = widget_info(id_draw,/geometry)
  xsize = geometry.scr_xsize
  ysize = geometry.scr_ysize
  
  x0_data = float(data_array[0])
  y0_data = float(data_array[1])
  x1_data = float(data_array[2])
  y1_data = float(data_array[3])
  
  xcoeff = float(xsize) / float(xsize_data)
  ycoeff = float(ysize) / float(ysize_data)
  
  x0_device = xcoeff * x0_data
  y0_device = ycoeff * y0_data
  x1_device = xcoeff * x1_data
  y1_device = ycoeff * y1_data
  
  return, [x0_device, y0_device, x1_device, y1_device]
end

;+
; :Description:
;    Display the ROI on top of the preview data
;
;
;
; :Keywords:
;    event
;    base
;
; :Author: j35
;-
pro display_preview_roi, event=event, base=base
  compile_opt idl2
  
  list_roi = retrieve_list_roi(event=event, base=base)
  if (list_roi eq ['']) then return
  
  sz = size(list_roi,/dim)
  nbr_row = sz[0]
  _index = 0
  while (_index lt nbr_row) do begin
  
    x0y0x1y1_data = list_roi[_index,*]
    x0y0x1y1_device = convert_data_to_device(event=event, $
    base=base, $
    x0y0x1y1_data)
    
    plot_roi, event=event, base=base, device_array=x0y0x1y1_device
    
    _index++
  endwhile
  
end

;+
; :Description:
;    Plots the ROI on top of the preview widget_draw
;
;
;
; :Keywords:
;    event
;    base
;    device_array
;
; :Author: j35
;-
pro plot_roi, event=event, base=base, device_array=device_array
  compile_opt idl2
  
  x0 = device_array[0]
  y0 = device_array[1]
  x1 = device_array[2]
  y1 = device_array[3]
  
  if (keyword_set(event)) then begin
  id_draw = widget_info(Event.top, find_by_uname='preview_draw_uname')
  endif else begin
  id_draw = widget_info(base, find_by_uname='preview_draw_uname')
  endelse
  widget_control, id_draw, get_value=id_value
  wset,id_value
  
  color='white'
  
  plots, [x0,x1,x1,x0,x0],[y0,y0,y1,y1,y0],/device,color=fsc_color(color)
  
end

