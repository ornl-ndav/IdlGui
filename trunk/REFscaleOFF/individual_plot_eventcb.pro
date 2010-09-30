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
    
    draw_zoom_selection[2] = x1
    draw_zoom_selection[3] = y1
    
    (*global_plot).draw_zoom_selection = draw_zoom_selection
    zoom_selection, event
    refresh_plot, event
  endif
  
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
  
  congrid_xcoeff = (*global_plot).congrid_ycoeff  ;using ycoeff because of transpose
  
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

