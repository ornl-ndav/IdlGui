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
;    returns the data value from the device coordinates of TOF range
;
; :Params:
;    event
;    x_device
;    tof_range_status
;
;
; :Author: j35
;-
function data_background_getTOFDataFromDevice, event, x_device, tof_range_status
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_pixel_selection
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='pixel_selection_scale')
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = geometry.xsize
  xoffset = geometry.xoffset
  
  tof = (*global_pixel_selection).tmp_x_axis
  x_range = [tof[0],tof[-1]]/1000.
  tof1 = x_range[0]
  tof2 = x_range[1]
  
  if (x_device lt xoffset) then return, tof1
  if (x_device gt xsize-xoffset) then return, tof2
  
  ratio = (tof2-tof1)/(float(xsize)-2.*xoffset)
  x_data = (float(x_device)-xoffset)*ratio + tof1
  
  tof = ((*global_pixel_selection).x_axis)/1000.
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
;    returns the device value from the data TOF value
;
; :Params:
;    event
;    x_data
;
;
;
; :Author: j35
;-
function getTOFdeviceFromData, event, x_data
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_step2_scale_uname')
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = geometry.xsize
  xoffset = 40.
  
  ;tof = (*(*global).norm_tof)
  tof = (*(*global).tmp_norm_tof)
  x_range = [tof[0],tof[-1]]/1000.
  tof1 = x_range[0]
  tof2 = x_range[1]
  
  if (x_data lt tof1) then return, xoffset
  if (x_data gt tof2) then return, (xsize-xoffset)
  
  ratio = (float(xsize)-2.*xoffset)/(tof2-tof1)
  x_device = (float(x_data)-tof1)*ratio + xoffset
  
  return, x_device
  
end

;+
; :Description:
;    This routine displays the TOF range (tof1 and tof2) at the bottom
;    of the reduce/step2/roi selection base main plot.
;
; :Params:
;    event
;
; :Author: j35
;-
pro display_tof_range, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  tof = (*(*global).norm_tof)
  x_range = [tof[0],tof[-1]]/1000.
  
  tof1 = x_range[0]
  tof2 = x_range[1]
  
  putTextFieldValue, event, 'reduce_step2_tof1', strcompress(tof1,/remove_all)
  putTextFieldValue, event, 'reduce_step2_tof2', strcompress(tof2,/remove_all)
  
end

;+
; :Description:
;    This save the TOF device/data values when reached from the mouse
;    interaction
;
; :Params:
;    event
;
; :Author: j35
;-
pro save_scale_device_values, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  tof_device_data = (*global).tof_device_data
  tof_range_status = (*global).tof_range_status
  
  x_device = event.x
  if ((*global).tof_range_status eq 'left') then begin
    index = 0
  endif else begin
    index = 1
  endelse
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_step2_scale_uname')
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = geometry.xsize
  xoffset = 40.
  
  ;make sure we stay in the range of tof
  if (x_device le xoffset) then x_device=xoffset
  if (x_device ge xsize-xoffset) then x_device=xsize-xoffset
  
  tof_device_data[0,index] = x_device
  x_data = getTOFDataFromDevice(event,x_device,(*global).tof_range_status)
  tof_device_data[1,index] = x_data
  
  (*global).tof_device_data = tof_device_data
  
end

;+
; :Description:
;    This routine display the selection of TOF made in the reduce/step2/ROI
;    selection base tool.
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro display_scale_tof_range, event, full_range=full_range
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  if (keyword_set(full_range)) then begin
    plot_reduce_tab2_scale, event=event
    display_full_tof_range_marker, event
    return
  endif
  
  tof_device_data = (*global).tof_device_data
  tof_range_status = (*global).tof_range_status
  
  if (tof_range_status eq 'left') then begin
    uname = 'reduce_step2_tof1'
    tof_data = tof_device_data[1,0]
  endif else begin
    uname = 'reduce_step2_tof2'
    tof_data = tof_device_data[1,1]
  endelse
  putValue, event=event, uname, strcompress(tof_data,/remove_all)
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_step2_scale_uname')
  geometry = WIDGET_INFO(id,/GEOMETRY)
  ysize = geometry.ysize
  xsize = geometry.xsize
  widget_control, id, get_value=id_value
  wset, id_value
  
  tof1_device = tof_device_data[0,0]
  tof2_device = tof_device_data[0,1]
  
  plot_reduce_tab2_scale, event=event
  
  xoffset = 40
  if (tof1_device lt xoffset) then tof1_device = xoffset
  if (tof1_device gt (xsize-xoffset)) then tof1_device = (xsize-xoffset)
  plots, tof1_device, 0, color=fsc_color('yellow'),/device
  plots, tof1_device, ysize, color=fsc_color('yellow'), /continue,/device,$
    thick=3
    
  if (tof2_device lt xoffset) then tof2_device = xoffset
  if (tof2_device gt (xsize-xoffset)) then tof2_device = (xsize-xoffset)
  plots, tof2_device, 0, color=fsc_color('yellow'),/device
  plots, tof2_device, ysize, color=fsc_color('yellow'), /continue,/device, $
    thick=3
    
end

;+
; :Description:
;    This initialize the device_data array of TOF when first starting the
;    reduce/step2/roi selection base
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro init_scale_device_data_array, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  tof_device_data = (*global).tof_device_data
  tof = (*(*global).norm_tof)
  (*(*global).tmp_norm_tof) = tof
  x_range = [tof[0],tof[-1]]/1000.
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_step2_scale_uname')
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = geometry.xsize
  
  tof_device_data[1,0] = x_range[0]
  tof_device_data[1,1] = x_range[1]
  
  xoffset = 40
  tof_device1 = xoffset
  tof_device2 = xsize-xoffset
  
  tof_device_data[0,0] = tof_device1
  tof_device_data[0,1] = tof_device2
  
  (*global).tof_device_data = tof_device_data
  
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
pro  display_full_tof_range_marker, event
  compile_opt idl2
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_step2_scale_uname')
  geometry = WIDGET_INFO(id,/GEOMETRY)
  ysize = geometry.ysize
  xsize = geometry.xsize
  widget_control, id, get_value=id_value
  wset, id_value
  
  xoffset = 40
  tof1_device = xoffset
  tof2_device = xsize-xoffset
  
  if (tof1_device lt xoffset) then tof1_device = xoffset
  if (tof1_device gt (xsize-xoffset)) then tof1_device = (xsize-xoffset)
  plots, tof1_device, 0, color=fsc_color('yellow'),/device
  plots, tof1_device, ysize, color=fsc_color('yellow'), /continue,/device,$
    thick=3
    
  if (tof2_device lt xoffset) then tof2_device = xoffset
  if (tof2_device gt (xsize-xoffset)) then tof2_device = (xsize-xoffset)
  plots, tof2_device, 0, color=fsc_color('yellow'),/device
  plots, tof2_device, ysize, color=fsc_color('yellow'), /continue,/device, $
    thick=3
    
end
