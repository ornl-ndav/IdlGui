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
;    This function retrieves the roi#1 from and to values and
;    roi#2 from and to values
;
; :Keywords:
;    array
;
; :Author: j35
;-
function retrieve_list_greg_roi, array=array
  compile_opt idl2
  
  sz = n_elements(array)
  
  list_px = !null
  prev_px = 0
  
  _index=0
  while (_index lt sz) do begin
  
    _line = strsplit(array[_index],'_',/extract,/regex)
    new_px = _line[2]
    
    if (new_px ne prev_px) then begin
      list_px = [list_px, new_px]
      prev_px = new_px
    endif
    
    _index++
  endwhile
  
  return, list_px
end

;+
; :Description:
;    determine the ROI#1 from and to pixels values
;    as well as the ROI#2 from and to pixels values
;
; :Keywords:
;    list_px
;
; :Author: j35
;-
function retrieve_roi12_from_to, list_px=list_px
  compile_opt idl2
  
  roi1_from = list_px[0]
  roi2_to = list_px[-1]
  
  sz = n_elements(list_px)
  previous = list_px[1]
  for i=2, sz-2 do begin
    new_value = list_px[i]
    if (fix(new_value) - fix(previous) gt 1) then begin
      roi1_to = previous
      roi2_from = new_value
      return, [roi1_from, roi1_to, roi2_from, roi2_to]
    endif else begin
      previous = new_value
    endelse
  endfor
  
  return, [roi1_from, roi2_to, 0 , 0 ]
end

;+
; :Description:
;    Reached by the LOAD roi button of the greg selection
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro load_greg_selection, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  path = (*global).dr_output_path
  ;pick filename
  filename = dialog_pickfile(dialog_parent=id, $
    filter=['*.txt'],$
    get_path=path, $
    path=path, $
    default_extension='txt',$
    /read,$
    title='Select background ROI file name!')
    
  if (filename[0] ne '') then begin
  
    filename = filename[0]
    (*global).dr_output_path = path
    
    openr, 1, filename
    nbr_lines = file_lines(filename)
    _array = STRARR(nbr_lines)
    readf, 1, _array
    close,1
    free_lun, 1
    
    list_greg_rois = retrieve_list_greg_roi(array=_array)
    roi12_from_to = retrieve_roi12_from_to(list_px=list_greg_rois)
    
    roi1_from = strcompress(roi12_from_to[0],/remove_all)
    roi1_to = strcompress(roi12_from_to[1],/remove_all)
    roi2_from = strcompress(roi12_from_to[2],/remove_all)
    roi2_to = strcompress(roi12_from_to[3],/remove_all)
    
    putValue, event=event, 'greg_roi1_from_value', roi1_from
    putvalue, event=event, 'greg_roi1_to_value', roi1_to
    putValue, event=event, 'greg_roi2_from_value', roi2_from
    putValue, event=event, 'greg_roi2_to_value', roi2_to
    
    (*global).greg_back_file_name = filename
    
  endif
  
end

;+
; :Description:
;    This function returns the intarr array that goes from from_pixel
;    to to_pixel
;
; :Keywords:
;    from_pixel
;    to_pixel
;
; :Author: j35
;-
function create_roi_array, from_pixel=from_pixel, to_pixel=to_pixel
  compile_opt idl2
  
  nbr_points = to_pixel - from_pixel + 1
  _array = indgen(nbr_points) + from_pixel
  
  return, _array
end

;+
; :Description:
;    This procedure is reached by the SAVE roi button of the greg selection
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro save_greg_selection, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  path = (*global).dr_output_path
  ;pick filename
  filename = dialog_pickfile(dialog_parent=id, $
    filter=['*.txt'],$
    get_path=path, $
    path=path, $
    default_extension='txt',$
    /write,$
    /overwrite_prompt, $
    title='Pick or define background ROI file name!')
    
  if (filename[0] ne '') then begin
  
    filename = filename[0]
    create_greg_selection, event=event, filename=filename
    (*global).dr_output_path = path
    
  endif
  
end

;+
; :Description:
;    This routine used the filename passed as argument and creates the ROI
;    file
;
; :Keywords:
;    event
;    filename
;
; :Author: j35
;-
pro create_greg_selection, event=event, filename=filename
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  roi1_from = fix(getValue(event=event, uname='greg_roi1_from_value'))
  roi1_to = fix(getValue(event=event, uname='greg_roi1_to_value'))
  
  roi2_from = fix(getValue(event=event, uname='greg_roi2_from_value'))
  roi2_to = fix(getValue(event=event, uname='greg_roi2_to_value'))
  
  ;make sure roi1_from is < roi1_to, if not just complain and stop here
  if (roi1_from ge roi1_to) then begin
    message_text = ['Please check ROI #1 from and to values!','',$
      'ex: Make sure that ROI#1_from value is less than ROI#1_to!']
    result = dialog_message(message_text,$
      /center,$
      /error,$
      dialog_parent=id, $
      title='ROI file not created !')
    return
  endif
  
  ;make sure roi2_from is < roi2_to, if not just complain and stop here
  if (roi2_from ge roi2_to) then begin
    message_text = ['Please check ROI #2 from and to values!','',$
      'ex: Make sure that ROI#2_from value is less than ROI#2_to!']
    result = dialog_message(message_text,$
      /center,$
      /error,$
      dialog_parent=id, $
      title='ROI file not created !')
    return
  endif
  
  ;make sure roi1_from < roi2_from
  roi_from_min = min([roi1_from,roi2_from], max=roi_from_max)
  roi_to_min = min([roi1_to, roi2_to], max=roi_to_max)
  
  roi_array_1 = create_roi_array(from_pixel=roi_from_min,$
    to_pixel=roi_to_min)
    
  roi_array_2 = create_roi_array(from_pixel=roi_from_max,$
    to_pixel=roi_to_max)
    
  roi_array = [roi_array_1, roi_array_2]
  NxMax = (*global).Nx_REF_L
  
  openw, 1, filename
  sz = n_elements(roi_array)
  for i=0L, sz-1 do begin
    for j=0L, NxMax-1 do begin
      _line = 'bank1_' + strcompress(j,/remove_all)
      _line += '_' + strcompress(roi_array[i],/remove_all)
      printf, 1, _line
    endfor
  endfor
  close, 1
  free_lun, 1
  
  (*global).greg_back_file_name = filename
  
end

;+
; :Description:
;    this will use the filename given and the min and max pixel values to
;    create the roi file
;
;
;
; :Keywords:
;    event
;    filename
;    from_px
;    to_px
;
; :Author: j35
;-
pro create_greg_peak_file, event=event, $
    filename=filename, $
    from_px=from_px, $
    to_px=to_px
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  from_px = fix(from_px[0])
  to_px = fix(to_px[0])
  
  roi_array = create_roi_array(from_pixel=from_px, $
    to_pixel=to_px)
    
  NxMax = (*global).Nx_REF_L
  
  openw, 1, filename
  sz = n_elements(roi_array)
  for i=0L, sz-1 do begin
    for j=0L, NxMax-1 do begin
      _line = 'bank1_' + strcompress(j,/remove_all)
      _line += '_' + strcompress(roi_array[i],/remove_all)
      printf, 1, _line
    endfor
  endfor
  close, 1
  free_lun, 1
  
end

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

;+
; :Description:
;    This routine will check if the SAVE ROI button can be validated or not
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro check_save_greg_roi_button, event
  compile_opt idl2
  
  roi1_from = getValue(event=event, uname='greg_roi1_from_value')
  roi1_to = getValue(event=event, uname='greg_roi1_to_value')
  
  roi2_from = getValue(event=event, uname='greg_roi2_from_value')
  roi2_to = getValue(event=event, uname='greg_roi2_to_value')
  
  status=1
  if ((strcompress(roi1_from,/remove_all) eq '') or $
    (strcompress(roi1_to,/remove_all) eq '') or $
    (strcompress(roi2_from,/remove_all) eq '') or $
    (strcompress(roi2_to,/remove_all) eq '')) then begin
    status=0
  endif
  
  ActivateWidget, Event, 'save_greg_selection_button', status
  
end


