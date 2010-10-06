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
;    returns 1 if there is a real selection, 0 otherwise
;
; :Params:
;    event
;    x1
;    y1
;
; :Author: j35
;-
function is_real_selection, event, x1, y1
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  
  draw_zoom_selection = (*global_plot).draw_zoom_selection
  x0 = draw_zoom_selection[0]
  y0 = draw_zoom_selection[1]
  
  if (x0 eq x1 AND y0 eq y1) then return, 0
  return, 1
  
end

;+
; :Description:
;    calculate the x data from the x device
;
; :Params:
;    event
;
; :Author: j35
;-
function retrieve_data_x_value, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, 'N/A'
  endif
  
  x_device = event.x
  congrid_xcoeff = (*global_plot).congrid_ycoeff  ;using ycoeff because of transpose
  xrange = float((*global_plot).xrange) ;min and max pixels
  
  rat = float(x_device) / float(congrid_xcoeff)
  x_data = long(rat * (xrange[1] - xrange[0]) + xrange[0])

  return, x_data
  
end

;+
; :Description:
;    calculate the y data from the y device
;
; :Params:
;    event
;
; :Author: j35
;-
function retrieve_data_y_value, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, 'N/A'
  endif
  
  y_device = event.y
  congrid_ycoeff = (*global_plot).congrid_xcoeff  ;using xcoeff because of transpose
  yrange = float((*global_plot).yrange) ;min and max pixels
  
  rat = float(y_device) / float(congrid_ycoeff)
  y_data = fix(rat * (yrange[1] - yrange[0]) + yrange[0])
  
  return, y_data
  
end

;+
; :Description:
;    returns the exact number of counts of the x and y device position
;
; :Params:
;    event
;
; :Returns:
;    counts
;
; :Author: j35
;-
function retrieve_data_z_value, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, 'N/A'
  endif
  
  data = (*(*global_plot).data_linear) ;[51,65] where 51 is #pixels
  
  xdata_max = (size(data))[2]
  ydata_max = (size(data))[1]
  
  congrid_xcoeff = (*global_plot).congrid_ycoeff  ;using ycoeff because of transpose
  congrid_ycoeff = (*global_plot).congrid_xcoeff  ;using xcoeff because of transpose
  
  xdata = fix(float(event.x) * float(xdata_max) / congrid_xcoeff)
  ydata = fix(float(event.y) * float(ydata_max) / congrid_ycoeff)
  
  return, data[ydata,xdata]
  
end

;+
; :Description:
;    display the counts vs tof (or lambda) plot
;    in the new widget_base on the right of the main GUI
;
; :Params:
;    event
;
; :Author: j35
;-
pro plot_counts_vs_xaxis, event, clear=clear
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  
  xaxis_plot_uname = (*global_plot).counts_vs_xaxis_plot_uname
  counts_vs_xaxis_base = (*global_plot).counts_vs_xaxis_base
  id = widget_info(counts_vs_xaxis_base, find_by_uname=xaxis_plot_uname)
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  if (n_elements(clear) ne 0) then begin
    erase
    return
  endif
  
  data = (*(*global_plot).data_linear) ;[51,65] where 51 is #pixels
  
  xdata_max = (size(data))[2]
  ydata_max = (size(data))[1]
  
  congrid_xcoeff = (*global_plot).congrid_xcoeff  ;using ycoeff because of transpose
  congrid_ycoeff = (*global_plot).congrid_ycoeff  ;using xcoeff because of transpose
  
  xdata = fix(float(event.x) * float(xdata_max) / congrid_xcoeff) ;tof
  ydata = fix(float(event.y) * float(ydata_max) / congrid_ycoeff) ;pixel
  
  xaxis_plot_uname = (*global_plot).counts_vs_xaxis_plot_uname
  counts_vs_xaxis_base = (*global_plot).counts_vs_xaxis_base
  id = widget_info(counts_vs_xaxis_base, find_by_uname=xaxis_plot_uname)
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  sz_x = (size(data))[1]
  if (ydata ge sz_x) then begin
    erase
    return
  endif
  
  nbr_pixel = n_elements(data[ydata,*])
  tof_axis = (*global_plot).tof_axis
  start_tof = tof_axis[0]
  delta_tof = (*global_plot).delta_tof
  yrange = indgen(nbr_pixel) * delta_tof + start_tof
  
  plot, yrange, data[ydata,*], xtitle='TOF (!4l!Xs)', ytitle='Counts'
  
end

;+
; :Description:
;    display the counts vs pixel (or angle) plot
;    in the new widget_base on the right of the main GUI
;
; :Params:
;    event
;
; :Author: j35
;-
pro plot_counts_vs_yaxis, event, clear=clear
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  
  yaxis_plot_uname = (*global_plot).counts_vs_yaxis_plot_uname
  counts_vs_yaxis_base = (*global_plot).counts_vs_yaxis_base
  id = widget_info(counts_vs_yaxis_base, find_by_uname=yaxis_plot_uname)
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  if (n_elements(clear) ne 0) then begin
    erase
    return
  endif
  
  data = (*(*global_plot).data_linear) ;[51,65] where 51 is #pixels
  
  xdata_max = (size(data))[2]
  ydata_max = (size(data))[1]
  
  congrid_xcoeff = (*global_plot).congrid_ycoeff  ;using ycoeff because of transpose
  congrid_ycoeff = (*global_plot).congrid_xcoeff  ;using xcoeff because of transpose
  
  xdata = fix(float(event.x) * float(xdata_max) / congrid_xcoeff) ;tof
  ydata = fix(float(event.y) * float(ydata_max) / congrid_ycoeff) ;pixel
  
  sz_y = (size(data))[2]
  if (xdata ge sz_y) then begin
    erase
    return
  endif
  
  nbr_pixel = n_elements(data[*,xdata])
  start_pixel = (*global_plot).start_pixel
  xrange = indgen(nbr_pixel) + start_pixel
    
  plot, xrange, data[*,xdata], xtitle='Pixel', ytitle='Counts'
  
end

;+
; :Description:
;    reach when the user interacts with the plot (left click, move mouse
;    with left click).
;
; :Params:
;    event
;;
; :Author: j35
;-
pro draw_eventcb, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    
    info_base = (*global_plot).cursor_info_base
    ;if x,y and counts base is on, shows live values of x,y and counts
    if (widget_info(info_base, /valid_id) ne 0) then begin
    
      x = retrieve_data_x_value(event)
      y = retrieve_data_y_value(event)
      z = retrieve_data_z_value(event)
      
      putValue, base=info_base, 'cursor_info_x_value_uname', strcompress(x,/remove_all)
      putValue, base=info_base, 'cursor_info_y_value_uname', strcompress(y,/remove_all)
      putValue, base=info_base, 'cursor_info_z_value_uname', strcompress(z,/remove_all)
      
    endif
    
    ;counts vs xaxis (tof or lambda)
    counts_vs_xaxis_plot_id = (*global_plot).counts_vs_xaxis_base
    if (widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0) then begin
      plot_counts_vs_xaxis, event
    endif
    
    ;counts vs yaxis (pixel or angle)
    counts_vs_yaxis_plot_id = (*global_plot).counts_vs_yaxis_base
    if (widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0) then begin
      plot_counts_vs_yaxis, event
    endif
        
    draw_zoom_selection = (*global_plot).draw_zoom_selection
    
    if ((*global_plot).left_click) then begin ;moving mouse with left click
      x1 = event.x
      y1 = event.y
      draw_zoom_selection[2] = x1
      draw_zoom_selection[3] = y1
      (*global_plot).draw_zoom_selection = draw_zoom_selection
      refresh_zoom_selection, event
    endif
    
    if (event.press eq 1) then begin ;user left clicked
      (*global_plot).left_click = 1b
      x0 = event.x
      y0 = event.y
      draw_zoom_selection[0] = x0
      draw_zoom_selection[1] = y0
      (*global_plot).draw_zoom_selection = draw_zoom_selection
    endif
    
    if (event.release eq 1) then begin ;user release left clicked
      (*global_plot).left_click = 0b
      x1 = event.x
      y1 = event.y
      
      ;make sure we stay within the display
      id = widget_info(event.top, find_by_uname='draw')
      geometry = widget_info(id, /geometry)
      xsize = geometry.xsize
      ysize = geometry.ysize
      
      if (x1 gt xsize) then x1 = xsize
      if (x1 lt 0) then x1 = 0
      if (y1 gt ysize) then y1 = ysize
      if (y1 lt 0) then y1 = 0
      
      ;check that user selected a box,not only 1 pixel
      result = is_real_selection(event, x1, y1)
      if (result eq 0) then return
      
      draw_zoom_selection[2] = x1
      draw_zoom_selection[3] = y1
      
      (*global_plot).draw_zoom_selection = draw_zoom_selection
      zoom_selection, event
      refresh_plot, event
    endif
    
    ;Draw vertical and horizontal lines when info mode is ON
    if (widget_info(info_base,/valid_id) ne 0 || $
    widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0 || $
    widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0) then begin

    if ((*global_plot).left_click) then begin
    endif else begin
    refresh_plot, event
    endelse
    
      x=event.x
      y=event.y
      id = widget_info(event.top, find_by_uname='draw')
      geometry = widget_info(id,/geometry)
      xsize = geometry.xsize
      ysize = geometry.ysize
      
      off = 20
      
      plots, x, 0, /device
      plots, x, y-off, /device, /continue, color=fsc_color('white')
      plots, x, y+off, /device
      plots, x, ysize, /device, /continue, color=fsc_color('white')

      plots, 0, y, /device
      plots, x-off, y, /device, /continue, color=fsc_color('white')
      plots, x+off, y, /device
      plots, xsize, y, /device, /continue, color=fsc_color('white')

    endif
    
  endif else begin ;endif of catch error
  
    if (event.enter eq 0) then begin ;leaving plot
      info_base = (*global_plot).cursor_info_base
      ;if x,y and counts base is on, shows live values of x,y and counts
      if (widget_info(info_base, /valid_id) ne 0) then begin
      
        na = 'N/A'
        putValue, base=info_base, 'cursor_info_x_value_uname', na
        putValue, base=info_base, 'cursor_info_y_value_uname', na
        putValue, base=info_base, 'cursor_info_z_value_uname', na
      endif
      
      ;counts vs xaxis (tof or lambda)
      counts_vs_xaxis_plot_id = (*global_plot).counts_vs_xaxis_base
      if (widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0) then begin
        plot_counts_vs_xaxis, event, clear=1
      endif
      
      ;counts vs yaxis (pixel or angle)
      counts_vs_yaxis_plot_id = (*global_plot).counts_vs_yaxis_base
      if (widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0) then begin
        plot_counts_vs_yaxis, event, clear=1
      endif
      
    endif
    
  endelse
  
end

;+
; :Description:
;    Using the device y0 and y1, this function returns the
;    data y0 and y1
;
; :Params:
;    event
;
; :Author: j35
;-
function determine_range_pixel_selected, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  
  draw_zoom_selection = (*global_plot).draw_zoom_selection
  y0_device = float(draw_zoom_selection[1])
  y1_device = float(draw_zoom_selection[3])
  
  congrid_ycoeff = (*global_plot).congrid_xcoeff  ;using xcoeff because of transpose
  
  yrange = float((*global_plot).yrange) ;min and max pixels
  
  ;calculation of y0_data value
  rat = float(y0_device) / float(congrid_ycoeff)
  y0_data = fix(rat * (yrange[1] - yrange[0]) + yrange[0])
  
  ;calculation of y1_data value
  rat = float(y1_device) / float(congrid_ycoeff)
  y1_data = fix(rat * (yrange[1] - yrange[0]) + yrange[0])
  
  return, [y0_data, y1_data]
  
end

;+
; :Description:
;    Using the device x0 and y=x1, this function returns the
;    data x0 and x1
;
; :Params:
;    event
;
; :Author: j35
;-
function determine_range_tof_selected, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  
  draw_zoom_selection = (*global_plot).draw_zoom_selection
  x0_device = float(draw_zoom_selection[0])
  x1_device = float(draw_zoom_selection[2])
  
  congrid_xcoeff = (*global_plot).congrid_ycoeff
  
  xrange = float((*global_plot).xrange) ;min and max pixels
  
  ;calculation of x0_data value
  rat = float(x0_device) / float(congrid_xcoeff)
  x0_data = long(rat * (xrange[1] - xrange[0]) + xrange[0])
  
  ;calculation of x1_data value
  rat = float(x1_device) / float(congrid_xcoeff)
  x1_data = long(rat * (xrange[1] - xrange[0]) + xrange[0])
  
  return, [x0_data, x1_data]

end

;+
; :Description:
;   Bring a new window with the zoom of the data
;
; :Params:
;    event
;
; :Author: j35
;-
pro zoom_selection, event
  compile_opt idl2
  
  pixel_range = determine_range_pixel_selected(event)
  pixel_range = pixel_range[sort(pixel_range)]
  tof_range   = determine_range_tof_selected(event)
  tof_range = tof_range[sort(tof_range)]
  
  ;retrieve selected region from big array
  widget_control, event.top, get_uvalue=global_plot
  
  ;calculate pixel and tof index range
  
  ;pixel
  start_pixel = (*global_plot).start_pixel
  pixel_range_index = pixel_range - start_pixel
  pixel_range_index = pixel_range_index[sort(pixel_range_index)]
  
  ;tof
  tof_min = min(tof_range,max=tof_max)
  Data_x = (*global_plot).Data_x
  
  ;left tof
  tof_range_index_left = where(tof_min ge Data_x)
  tof_range_index_min = tof_range_index_left[-1]
  
  ;right tof
  tof_range_index_right = where(Data_x ge tof_max)
  tof_range_index_max = tof_range_index_right[0]
  
  tof_range_index = [tof_range_index_min, tof_range_index_max]
  
  ;create new array of selected region
  data_y = (*(*global_plot).data_linear) ;Array[pixel,tof]
  zoom_data_x = Data_x[tof_range_index[0]:tof_range_index_max]
  zoom_data_y = data_y[pixel_range_index[0]:pixel_range_index[1],$
    tof_range_index[0]:tof_range_index[1]]
    
  px_vs_tof_plots_base, event = event, $
    main_base_uname = 'px_vs_tof_widget_base', $
    file_name = (*global_plot).file_name, $
    offset = 50, $
    default_loadct = (*global_plot).default_loadct, $
    default_scale_settings = (*global_plot).default_scale_settings, $
    default_plot_size = (*global_plot).default_plot_size, $
    current_plot_setting = (*global_plot).plot_setting, $
    Data_x =  zoom_data_x, $ ;tof
    Data_y = zoom_data_y, $ ;Data_y, $
    start_pixel = pixel_range[0]
    
end

;+
; :Description:
;    plot the zoom selection
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro refresh_zoom_selection, event
  compile_opt idl2
  
  refresh_plot, event
  
  widget_control, event.top, get_uvalue=global_plot
  
  selection = (*global_plot).draw_zoom_selection
  
  id = widget_info(event.top,find_by_uname='draw')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  xrange = [selection[0],selection[2]]
  yrange = [selection[1],selection[3]]
  
  xmin = min(xrange, max=xmax)
  ymin = min(yrange, max=ymax)
  
  plots, [xmin, xmin, xmax, xmax, xmin],$
    [ymin, ymax, ymax, ymin, ymin],$
    /DEVICE,$
    LINESTYLE = 3,$
    COLOR = 200
    
end

