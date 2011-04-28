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
;    returns the data value from the device coordinates of sangle TOF range
;
; :Params:
;    event
;    x_device
;    tof_range_status
;
;
; :Author: j35
;-
function getSangleTOFDataFromDevice, event, x_device, tof_range_status
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_sangle_y_scale')
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = geometry.xsize
  xoffset = 40.
  
  tof = (*(*global).tmp_sangle_tof)
  
  ;sangle_tof_device_range = (*global).sangle_tof_device_data
  ;tof = [sangle_tof_device_range[1,0],sangle_tof_device_range[1,1]]
  ;x_range = tof
  tof1 = tof[0]
  tof2 = tof[-1]
  
  if (x_device le xoffset) then return, tof1
  if (x_device ge (*global).sangle_xsize_draw+xoffset) then return, tof2
  
  ratio = (tof2-tof1)/((*global).sangle_xsize_draw)
  ratio *= (float(x_device) - xoffset)
  
  x_data = ratio + tof1
  
  sz_tof = n_elements(tof)
  if (tof_range_status eq 'left') then begin
    ;we want the real tof value smaller or equal to x_data
    _le_index = where(x_data ge tof, nbr)
    if (nbr eq sz_tof) then begin
      return, tof[_le_index[-1]]
    endif else begin
      return, tof[_le_index[-1]+1]
    endelse
  endif else begin
    ;we want the real tof value greater or equal to x_data
    _ge_index = where(tof le x_data, nbr)
    if (nbr eq sz_tof) then begin
      return, tof[_ge_index[-1]]
    endif else begin
      return, tof[_ge_index[-1]+1]
    endelse
  endelse
end

;+
; :Description:
;    this save the TOF device/data values when reached from the mouse
;    interaction on the sangle tof scale
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro sangle_save_scale_device_values, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  sangle_tof_device_data = (*global).sangle_tof_device_data
  sangle_tof_range_status = (*global).sangle_tof_range_status
  
  x_device = event.x
  if ((*global).sangle_tof_range_status eq 'left') then begin
    index=0
  endif else begin
    index=1
  endelse
  
  id = widget_info(event.top, find_by_uname='reduce_sangle_y_scale')
  geometry=widget_info(id,/geometry)
  xsize=geometry.xsize
  xoffset=40
  
  ;make sure we stay in the range of tof
  if (x_device le xoffset) then x_device=xoffset
  if (x_device ge (*global).sangle_xsize_draw+xoffset) then x_device=$
  (*global).sangle_xsize_draw + xoffset
  
  sangle_tof_device_data[0,index] = x_device
  x_data = getSangleTOFDataFromDevice(event, $
    x_device, $
    (*global).sangle_tof_range_status)
    sangle_tof_device_data[1,index] = x_data

  (*global).sangle_tof_device_data = sangle_tof_device_data

end

;+
; :Description:
;    This routine display the selection of TOF made in the sangle
;    selection base tool.
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro display_sangle_scale_tof_range, event, full_range=full_range
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  if (keyword_set(full_range)) then begin
    display_reduce_step1_sangle_scale, event=event
    display_full_sangle_tof_range_marker, event
    return
  endif
  
  tof_device_data = (*global).sangle_tof_device_data
  tof_range_status = (*global).sangle_tof_range_status
  
  if (tof_range_status eq 'left') then begin
    uname = 'reduce_step1_tof1'
    tof_data = tof_device_data[1,0]
  endif else begin
    uname = 'reduce_step1_tof2'
    tof_data = tof_device_data[1,1]
  endelse
  putValue, event=event, uname, strcompress(tof_data,/remove_all)
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_sangle_y_scale')
  geometry = WIDGET_INFO(id,/GEOMETRY)
  ysize = geometry.ysize
  xsize = (*global).sangle_xsize_draw
  widget_control, id, get_value=id_value
  wset, id_value
  
  tof1_device = tof_device_data[0,0]
  tof2_device = tof_device_data[0,1]
  
  display_reduce_step1_sangle_scale, event=event
  
  xoffset = 40
  if (tof1_device lt xoffset) then tof1_device = xoffset
  if (tof1_device gt (xsize+xoffset)) then tof1_device = (xsize+xoffset)
  plots, tof1_device, 0, color=fsc_color('yellow'),/device
  plots, tof1_device, ysize, color=fsc_color('yellow'), /continue,/device,$
    thick=3
    
  if (tof2_device lt xoffset) then tof2_device = xoffset
  if (tof2_device gt (xsize+xoffset)) then tof2_device = (xsize+xoffset)
  plots, tof2_device, 0, color=fsc_color('yellow'),/device
  plots, tof2_device, ysize, color=fsc_color('yellow'), /continue,/device, $
    thick=3
    
end

;+
; :Description:
;    This routine display the ticks showing the current range selection around
;    the full set of data (always like that when nothing has been selected
;    yet)
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro  display_full_sangle_tof_range_marker, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_sangle_y_scale')
  geometry = WIDGET_INFO(id,/GEOMETRY)
  ysize = geometry.ysize
  xsize = (*global).sangle_xsize_draw
  widget_control, id, get_value=id_value
  wset, id_value
  
  xoffset = 40
  tof1_device = xoffset
  tof2_device = xsize+xoffset
  
  if (tof1_device lt xoffset) then tof1_device = xoffset
  if (tof1_device gt (xsize+xoffset)) then tof1_device = (xsize+xoffset)
  plots, tof1_device, 0, color=fsc_color('yellow'),/device
  plots, tof1_device, ysize, color=fsc_color('yellow'), /continue,/device,$
    thick=3
    
  if (tof2_device lt xoffset) then tof2_device = xoffset
  if (tof2_device gt (xsize+xoffset)) then tof2_device = (xsize+xoffset)
  plots, tof2_device, 0, color=fsc_color('yellow'),/device
  plots, tof2_device, ysize, color=fsc_color('yellow'), /continue,/device, $
    thick=3
    
end

;+
; :Description:
;    This initialize the device_data array of TOF when first starting the
;    reduce/step1/roi selection base
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro init_sangle_scale_device_data_array, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  tof_device_data = (*global).sangle_tof_device_data
  tof = (*(*global).sangle_tof)
  (*(*global).tmp_sangle_tof) = tof
  x_range = [tof[0],tof[-1]]
  
  xsize = (*global).sangle_xsize_draw
  
  tof_device_data[1,0] = x_range[0]
  tof_device_data[1,1] = x_range[1]
  
  xoffset = 40
  tof_device1 = xoffset
  tof_device2 = xsize-xoffset
  
  tof_device_data[0,0] = tof_device1
  tof_device_data[0,1] = tof_device2
  
  (*global).sangle_tof_device_data = tof_device_data
  
end

