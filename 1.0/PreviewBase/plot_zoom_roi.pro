;+
; :Description:
;    Convert from data to device values the x0, y0, x1 and y1 values
;
; :Params:
;    data_array
;
; :Keywords:
;    event
;
; :Returns:
;   [x0_device, y0_device, x1_device, y1_device]
;
; :Author: j35
;-
function convert_zoom_data_to_device, event=event, base=base, data_array
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_preview
  endif else begin
    widget_control, base, get_uvalue=global_preview
  endelse
  
  global = (*global_preview).global
  
  size_preview_data = (*global).size_preview_data ;[2048,2048]
  xsize_data = size_preview_data[0]
  ysize_data = size_preview_data[1]
  
  if (keyword_set(event)) then begin
    id_draw = widget_info(Event.top, find_by_uname='zoom_draw')
  endif else begin
    id_draw = widget_info(base, find_by_uname='zoom_draw')
  endelse
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
;    This convert the device array into a data array of the ROI selected
;
; :Params:
;    device_array
;
; :Keywords:
;    event
;    base
;
; :Author: j35
;-
function convert_zoom_device_to_data, event=event, base=base, device_array
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_preview
  endif else begin
    widget_control, base, get_uvalue=global_preview
  endelse
  
  global = (*global_preview).global
  
  size_preview_data = (*global).size_preview_data ;[2048,2048]
  xsize_data = size_preview_data[0]
  ysize_data = size_preview_data[1]
  
  if (keyword_set(event)) then begin
    id_draw = widget_info(Event.top, find_by_uname='zoom_draw')
  endif else begin
    id_draw = widget_info(base, find_by_uname='zoom_draw')
  endelse
  geometry = widget_info(id_draw,/geometry)
  xsize = geometry.scr_xsize
  ysize = geometry.scr_ysize
  
  x0_device = float(device_array[0])
  y0_device = float(device_array[1])
  x1_device = float(device_array[2])
  y1_device = float(device_array[3])
  
  xcoeff = float(xsize_data) / float(xsize)
  ycoeff = float(ysize_data) / float(ysize)
  
  x0_data = xcoeff * x0_device
  x1_data = xcoeff * x1_device
  y0_data = ycoeff * y0_device
  y1_data = ycoeff * y1_device
  
  return, [x0_data, y0_data, x1_data, y1_data]
end

;+
; :Description:
;    This will display the ROI previously defined in the main base
;
;
;
; :Keywords:
;    base
;    event
;
; :Author: j35
;-
pro plot_zoom_roi, base=base, event=event
  compile_opt idl2
  
  if (keyword_set(base)) then begin
    widget_control, base, get_uvalue=global_preview
  endif else begin
    widget_control, event.top, get_uvalue=global_preview
    base = (*global_preview)._base
  endelse
  
  ;set where we want to display the plot
  id = widget_info(base,find_by_uname='zoom_draw')
  widget_control, id, get_value=plot_id
  wset, plot_id
  
  ;retrieve list of roi
  main_base = (*global_preview).top_base
  
  list_roi = retrieve_list_roi(base=main_base)
  
  if (list_roi eq ['']) then return
  
  sz = size(list_roi,/dim)
  nbr_row = sz[0]
  _index = 0
  while (_index lt nbr_row) do begin
  
    x0y0x1y1_data = list_roi[_index,*]
    x0y0x1y1_device = convert_zoom_data_to_device(base=base, $
      event=event, $
      x0y0x1y1_data)
      
    _plot_zoom_roi, base=base, event=event, device_array=x0y0x1y1_device
    
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
;    base
;    event
;    device_array
;
; :Author: j35
;-
pro _plot_zoom_roi, event=event, base=base, device_array=device_array
  compile_opt idl2
  
  x0 = device_array[0]
  y0 = device_array[1]
  x1 = device_array[2]
  y1 = device_array[3]
  
  if (keyword_set(event)) then begin
    id_draw = widget_info(Event.top, find_by_uname='zoom_draw')
  endif else begin
    id_draw = widget_info(base, find_by_uname='zoom_draw')
  endelse
  widget_control, id_draw, get_value=id_value
  wset,id_value
  
  color='white'
  
  plots, [x0,x1,x1,x0,x0],[y0,y0,y1,y1,y0],/device,color=fsc_color(color)
  
end

;+
; :Description:
;    this procedure appends the roi into the ROI table
;
;
;
; :Keywords:
;    event
;    new_roi
;
; :Author: j35
;-
pro add_new_selection_to_list_of_roi, event=event, new_roi=new_roi
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_preview
  
  top_base = (*global_preview).top_base
  current_roi_list = getValue(base=top_base,uname='roi_text_field_uname')
  string_new_roi = strcompress(strjoin(fix(new_roi),','),/remove_all)
  
  ;find the last empty row
  nbr_lines = n_elements(current_roi_list)
  _index=0
  found_empty_row=0b
  while (_index lt nbr_lines) do begin
    if (strcompress(current_roi_list[_index],/remove_all) eq '') then begin
      current_roi_list[_index] = string_new_roi
      found_empty_row=1b
      exit
    endif
    _index++
  endwhile
  
  if (found_empty_row eq 0b) then begin
    current_roi_list = [current_roi_list,string_new_roi]
  endif
  
  putValue, base=top_base, 'roi_text_field_uname', current_roi_list
  
end



