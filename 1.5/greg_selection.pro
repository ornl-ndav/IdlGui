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
;    Return the current active pixel selected (roi1_from, roi1_to, roi2_from
;    or roi2_to)
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
function getGregActivePixel, event=event
  compile_opt idl2
  
  roi1_from = getValue(event=event, uname='greg_roi1_from_selected')
  if (strcompress(roi1_from,/remove_all) eq '<<') then return, 'roi1_from'
  
  roi1_to = getValue(event=event, uname='greg_roi1_to_selected')
  if (strcompress(roi1_to,/remove_all) eq '<<') then return, 'roi1_to'
  
  roi2_from = getValue(event=event, uname='greg_roi2_from_selected')
  if (strcompress(roi2_from,/remove_all) eq '<<') then return, 'roi2_from'
  
  return, 'roi2_to'
end

;+
; :Description:
;    This routine is reached when user click on the main plot with
;    greg selection tab activated
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro greg_selection, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  if (event.press eq 4) then begin ;right click
    change_active_pixel, event
    return
  endif
  
  if (event.press eq 1b) then begin
    (*global).greg_left_click = 1b
  endif
  
  if ((*global).greg_left_click eq 1b && $ ;release left click
    event.release eq 1b) then begin
    (*global).greg_left_click = 0b
    return
  endif
  
  if ((*global).greg_left_click) then begin ;left click or moving with left click
  
    active_pixel_selected = getGregActivePixel(event=event)
    
    y_device=event.y
    y_data = getYDataFromDevice(event=event, type='data', device_value=y_device)
    
    case (active_pixel_selected) of
      'roi1_from': uname = 'greg_roi1_from_value'
      'roi1_to': uname = 'greg_roi1_to_value'
      'roi2_from': uname = 'greg_roi2_from_value'
      'roi2_to': uname = 'greg_roi2_to_value'
    endcase
    putValue, event=event, uname, strcompress(y_data,/remove_all)
    
    ;refresh plot, peak and from/to ROIs
    refresh_greg_selection, event, /refresh_main_plot, /refresh_peak
    
  endif
  
end

;+
; :Description:
;    This will check which pixel is currently activated and will move to the
;    next one
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro change_active_pixel, event
  compile_opt idl2
  
  roi1_from = getValue(event=event, uname='greg_roi1_from_selected')
  if (strcompress(roi1_from,/remove_all) eq '<<') then begin
    new_active = 'roi1_to'
  endif else begin
    roi1_to = getValue(event=event, uname='greg_roi1_to_selected')
    if (strcompress(roi1_to,/remove_all) eq '<<') then begin
      new_active = 'roi2_from'
    endif else begin
      roi2_from = getValue(event=event, uname='greg_roi2_from_selected')
      if (strcompress(roi2_from,/remove_all) eq '<<') then begin
        new_active = 'roi2_to'
      endif else begin
        new_active = 'roi1_from'
      endelse
    endelse
  endelse
  
  value = strarr(4) + '  '
  case (new_active) of
    'roi1_from': value[0] = '<<'
    'roi1_to': value[1] = '<<'
    'roi2_from': value[2] = '<<'
    'roi2_to': value[3] = '<<'
  endcase
  
  putValue, event=event, 'greg_roi1_from_selected', value[0]
  putValue, event=event, 'greg_roi1_to_selected', value[1]
  putValue, event=event, 'greg_roi2_from_selected', value[2]
  putValue, event=event, 'greg_roi2_to_selected', value[3]
  
end

;+
; :Description:
;    This routine will just refresh the background regions and the peak region
;    as well
;
; :Params:
;    event
;
; :Keywords:
;   refresh_peak
;   refresh_main_plot
;
;
; :Author: j35
;-
pro refresh_greg_selection, event, $
    refresh_peak=refresh_peak, $
    refresh_main_plot=refresh_main_plot
  compile_opt idl2
  
  ;stop here if greg back is not activated
  back_tab_value = getTabValue(event=event, uname='greg_selection_tab')
  if (back_tab_value ne 1) then return
  
  if (keyword_set(refresh_main_plot)) then REFReduction_RescaleDataPlot, Event
  
  roi1_from = fix(getValue(event=event, uname='greg_roi1_from_value'))
  roi1_to = fix(getValue(event=event, uname='greg_roi1_to_value'))
  
  roi2_from = fix(getValue(event=event, uname='greg_roi2_from_value'))
  roi2_to = fix(getValue(event=event, uname='greg_roi2_to_value'))
  
  id = widget_info(event.top, find_by_uname='load_data_D_draw')
  geometry = widget_info(id,/geometry)
  xsize_1d_draw = geometry.scr_xsize
  
  id_draw = widget_info(Event.top, find_by_uname='load_data_D_draw')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  
  if (roi1_from ne 0) then begin
    roi1_from_device = getYDeviceFromData(event=event, $
      type='data', $
      data_value=roi1_from)
      
    plots, 0, roi1_from_device, /device, color=fsc_color('green')
    plots, xsize_1d_draw, roi1_from_device, /device, color=fsc_color('green'), $
      /continue
      
  endif
  
  if (roi1_to ne 0) then begin
    roi1_to_device = getYDeviceFromData(event=event, $
      type='data', $
      data_value=roi1_to)
      
    plots, 0, roi1_to_device, /device, color=fsc_color('green')
    plots, xsize_1d_draw, roi1_to_device, /device, color=fsc_color('green'), $
      /continue
      
  endif
  
  if (roi2_from ne 0) then begin
    roi2_from_device = getYDeviceFromData(event=event, $
      type='data', $
      data_value=roi2_from)
      
    plots, 0, roi2_from_device, /device, color=fsc_color('green')
    plots, xsize_1d_draw, roi2_from_device, /device, color=fsc_color('green'), $
      /continue
      
  endif
  
  if (roi2_to ne 0) then begin
    roi2_to_device = getYDeviceFromData(event=event, $
      type='data', $
      data_value=roi2_to)
      
    plots, 0, roi2_to_device, /device, color=fsc_color('green')
    plots, xsize_1d_draw, roi2_to_device, /device, color=fsc_color('green'), $
      /continue
      
  endif
  
  if (keyword_set(refresh_peak)) then plot_data_peak_value, event
  
end

