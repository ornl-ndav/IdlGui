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

;;+
;; :Description:
;;    returns 1 if there is a real selection, 0 otherwise
;;
;; :Params:
;;    event
;;    x1
;;    y1
;;
;; :Author: j35
;;-
;function is_real_selection, event, x1, y1
;  compile_opt idl2
;  
;  widget_control, event.top, get_uvalue=global_plot
;  
;  draw_zoom_selection = (*global_plot).draw_zoom_selection
;  x0 = draw_zoom_selection[0]
;  y0 = draw_zoom_selection[1]
;  
;  if (x0 eq x1 AND y0 eq y1) then return, 0
;  return, 1
;  
;end

;;+
;; :Description:
;;    calculate the x data from the x device
;;
;; :Params:
;;    event
;;
;; :Author: j35
;;-
;function retrieve_data_x_value, event
;  compile_opt idl2
;  
;  widget_control, event.top, get_uvalue=global_plot
;  
;  catch, error
;  if (error ne 0) then begin
;    catch,/cancel
;    return, 'N/A'
;  endif
;  
;  x_device = event.x
;  congrid_xcoeff = (*global_plot).congrid_xcoeff
;  xrange = float((*global_plot).xrange) ;min and max pixels
;  
;  rat = float(x_device) / float(congrid_xcoeff)
;  x_data = float(rat * (xrange[1] - xrange[0]) + xrange[0])
;  
;  return, x_data
;  
;end
;
;;+
;; :Description:
;;    calculate the y data from the y device
;;
;; :Params:
;;    event
;;
;; :Author: j35
;;-
;function retrieve_data_y_value, event
;  compile_opt idl2
;  
;  widget_control, event.top, get_uvalue=global_plot
;  
;  catch, error
;  if (error ne 0) then begin
;    catch,/cancel
;    return, 'N/A'
;  endif
;  
;  y_device = event.y
;  congrid_ycoeff = (*global_plot).congrid_ycoeff  ;using xcoeff because of transpose
;  yrange = float((*global_plot).yrange) ;min and max pixels
;  
;  rat = float(y_device) / float(congrid_ycoeff)
;  y_data = float(rat * (yrange[1] - yrange[0]) + yrange[0])
;  
;  return, y_data
;  
;end

;;+
;; :Description:
;;    returns the exact number of counts of the x and y device position
;;
;; :Params:
;;    event
;;
;; :Returns:
;;    counts
;;
;; :Author: j35
;;-
;function retrieve_data_z_value, event
;  compile_opt idl2
;  
;  widget_control, event.top, get_uvalue=global_plot
;  
;  catch, error
;  if (error ne 0) then begin
;    catch,/cancel
;    return, 'N/A'
;  endif
;  
;  data = (*(*global_plot).data_linear) ;[51,65] where 51 is #pixels
;  
;  xdata_max = (size(data))[1]
;  ydata_max = (size(data))[2]
;  
;  congrid_xcoeff = (*global_plot).congrid_xcoeff
;  congrid_ycoeff = (*global_plot).congrid_ycoeff
;  
;  xdata = fix(float(event.x) * float(xdata_max) / congrid_xcoeff)
;  ydata = fix(float(event.y) * float(ydata_max) / congrid_ycoeff)
;  
;  if ((*global_plot).shift_key_status) then begin
;  
;    xyEvent = (*global_plot).EventRangeSelection
;    x1event = xyEvent[0]
;    y1event = xyEvent[1]
;    
;    x1data = fix(float(x1event) * float(xdata_max) / congrid_xcoeff)
;    y1data = fix(float(y1event) * float(ydata_max) / congrid_ycoeff)
;    
;    xmin = min([xdata,x1data],max=xmax)
;    ymin = min([ydata,y1data],max=ymax)
;    
;    _data = total(data[xmin:xmax,ymin:ymax])
;    
;  endif else begin
;  
;    _data = data[xdata,ydata]
;    
;  endelse
;  
;  ;; Debugging code
;  ;  print, '(congrid_xcoeff,congrid_ycoeff)=(' + strcompress(congrid_xcoeff,/remove_all) + $
;  ;  ',' + strcompress(congrid_ycoeff,/remove_all) + ')'
;  ;  print, '(xdata,ydata)=(' + strcompress(xdata,/remove_all) + $
;  ;  ',' + strcompress(ydata,/remove_all) + ')'
;  ;  print, '(xdata_max,ydata_max)=(' + strcompress(xdata_max,/remove_all) + $
;  ;  ',' + strcompress(ydata_max,/remove_all) + ')'
;  ;  print
;  
;  return, _data
;  
;end

;+
; :Description:
;    display the counts vs tof
;    in the new widget_base on the right of the main GUI
;
; :Params:
;    event
;
; :Author: j35
;-
pro px_vs_tof_plot_counts_vs_xaxis, event=event, base=base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
  widget_control, event.top, get_uvalue=global_axis_plot
  endif else begin
  widget_control, base, get_uvalue=global_axis_plot
  endelse
  
  global_px_vs_tof = (*global_axis_plot).global
  xaxis_plot_uname = (*global_px_vs_tof).counts_vs_xaxis_plot_uname
  counts_vs_xaxis_base = base
  id = widget_info(counts_vs_xaxis_base, find_by_uname=xaxis_plot_uname)
  
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  ;2d data
  data = (*(*global_px_vs_tof).data2d_linear)
  _data = total(data,2)
  
;  xdata_max = (size(data))[1]
;  ydata_max = (size(data))[2]
  
;  ;using ycoeff because of transpose
;  congrid_xcoeff = (*global_plot).congrid_xcoeff  
;  ;using xcoeff because of transpose
;  congrid_ycoeff = (*global_plot).congrid_ycoeff  
  
;  xdata = fix(float(event.x) * float(xdata_max) / congrid_xcoeff)
;  ydata = fix(float(event.y) * float(ydata_max) / congrid_ycoeff)
  
;  xaxis_plot_uname = (*global_plot).counts_vs_xaxis_plot_uname
  ; counts_vs_xaxis_base = (*global_plot).counts_vs_xaxis_base
  ;id = widget_info(counts_vs_xaxis_base, find_by_uname=xaxis_plot_uname)
  ;widget_control, id, GET_VALUE = plot_id
  ;wset, plot_id
  
  ;sz_x = (size(data))[1]
  ;if (xdata ge sz_x) then begin
  ;  erase
  ;  return
  ;endif
  
  ;nbr_ = n_elements(data[xdata,*])
  x_axis = (*global_px_vs_tof).tof_axis
  xrange = fltarr(2)
  xrange[0] = x_axis[0]
  xrange[1] = x_axis[-1]
  (*global_axis_plot).xrange = xrange
  (*global_axis_plot).ymax = max(_data)
  
  yaxis_type = (*global_px_vs_tof).counts_vs_xaxis_yaxis_type
  is_linear = 1
  if (yaxis_type eq 0) then begin
  
    plot, x_axis, _data, xtitle='TOF (ms)', ytitle='Counts', xstyle=1
    
  endif else begin
  
    catch,error
    if (error ne 0) then begin
      catch,/cancel
      erase
      return
    endif
    
    ;remove the 0 values
    nan_array = where(data eq 0)
    data[nan_array] = !values.f_nan
    
    ymax = max(_data)
    yrange = [0.01,ymax]
    
    plot, x_axis, _data, $
      xstyle = 1, $
      xtitle='TOF (ms)', $
      ytitle='Counts', $
      yrange = yrange, $
      /ylog
    is_linear = 0
    
  endelse
  
end

;+
; :Description:
;    display the counts vs Qz
;    in the new widget_base on the right of the main GUI
;
; :Params:
;    event
;
; :Author: j35
;-
pro px_vs_tof_plot_counts_vs_yaxis,event=event, base=base, clear=clear
  compile_opt idl2
  
  if (keyword_set(event)) then begin
  widget_control, event.top, get_uvalue=global_axis_plot
  endif else begin
  widget_control, base, get_uvalue=global_axis_plot
  endelse
  
  global_px_vs_tof = (*global_axis_plot).global
  yaxis_plot_uname = (*global_px_vs_tof).counts_vs_yaxis_plot_uname
  counts_vs_xaxis_base = base
  id = widget_info(counts_vs_xaxis_base, find_by_uname=yaxis_plot_uname)
  
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  if (keyword_set(clear)) then begin
    erase
    return
  endif
  
  ;2d data
  data = (*(*global_px_vs_tof).data2d_linear)
  _data = total(data,1)
  
;  xdata_max = (size(data))[1]
;  ydata_max = (size(data))[2]
  
;  ;using ycoeff because of transpose
;  congrid_xcoeff = (*global_plot).congrid_xcoeff  
;  ;using xcoeff because of transpose
;  congrid_ycoeff = (*global_plot).congrid_ycoeff  
  
;  xdata = fix(float(event.x) * float(xdata_max) / congrid_xcoeff)
;  ydata = fix(float(event.y) * float(ydata_max) / congrid_ycoeff)
  
;  xaxis_plot_uname = (*global_plot).counts_vs_xaxis_plot_uname
  ; counts_vs_xaxis_base = (*global_plot).counts_vs_xaxis_base
  ;id = widget_info(counts_vs_xaxis_base, find_by_uname=xaxis_plot_uname)
  ;widget_control, id, GET_VALUE = plot_id
  ;wset, plot_id
  
  ;sz_x = (size(data))[1]
  ;if (xdata ge sz_x) then begin
  ;  erase
  ;  return
  ;endif
  
  ;nbr_ = n_elements(data[xdata,*])

  y_axis = indgen(n_elements(_data))
  
  xrange = fltarr(2)
  xrange[0] = y_axis[0]
  xrange[1] = y_axis[-1]
  (*global_axis_plot).xrange = xrange
  (*global_axis_plot).ymax = max(_data)
    
  yaxis_type = (*global_px_vs_tof).counts_vs_xaxis_yaxis_type
  is_linear = 1
  if (yaxis_type eq 0) then begin
  
    plot, y_axis, _data, xtitle='Pixel', ytitle='Counts', xstyle=1
    
  endif else begin
  
    catch,error
    if (error ne 0) then begin
      catch,/cancel
      erase
      return
    endif
    
    ;remove the 0 values
    nan_array = where(data eq 0)
    data[nan_array] = !values.f_nan
    
    ymax = max(_data)
    yrange = [0.01,ymax]
    
    plot, y_axis, _data, $
      xstyle = 1, $
      xtitle='Pixel',$
      ytitle='Counts', $
      yrange = yrange, $
      /ylog
    is_linear = 0
    
  endelse
  
end


;;+
;; :Description:
;;    Using the device y0 and y1, this function returns the
;;    data y0 and y1
;;
;; :Params:
;;    event
;;
;; :Author: j35
;;-
;function determine_range_qz_selected, event
;  compile_opt idl2
;  
;  widget_control, event.top, get_uvalue=global_plot
;  
;  draw_zoom_selection = (*global_plot).draw_zoom_selection
;  y0_device = float(draw_zoom_selection[1])
;  y1_device = float(draw_zoom_selection[3])
;  
;  congrid_ycoeff = (*global_plot).congrid_ycoeff  ;using xcoeff because of transpose
;  
;  yrange = float((*global_plot).yrange) ;min and max Qz
;  
;  ;calculation of y0_data value
;  rat = float(y0_device) / float(congrid_ycoeff)
;  y0_data = float(rat * (yrange[1] - yrange[0]) + yrange[0])
;  
;  ;calculation of y1_data value
;  rat = float(y1_device) / float(congrid_ycoeff)
;  y1_data = float(rat * (yrange[1] - yrange[0]) + yrange[0])
;  
;  return, [y0_data, y1_data]
;  
;end
;
;;+
;; :Description:
;;    Using the device x0 and y=x1, this function returns the
;;    data x0 and x1
;;
;; :Params:
;;    event
;;
;; :Author: j35
;;-
;function determine_range_Qx_selected, event
;  compile_opt idl2
;  
;  widget_control, event.top, get_uvalue=global_plot
;  
;  draw_zoom_selection = (*global_plot).draw_zoom_selection
;  x0_device = float(draw_zoom_selection[0])
;  x1_device = float(draw_zoom_selection[2])
;  
;  congrid_xcoeff = (*global_plot).congrid_xcoeff
;  
;  xrange = float((*global_plot).xrange) ;min and max Qx
;  
;  ;calculation of x0_data value
;  rat = float(x0_device) / float(congrid_xcoeff)
;  x0_data = double(rat * (xrange[1] - xrange[0]) + xrange[0])
;  
;  ;calculation of x1_data value
;  rat = float(x1_device) / float(congrid_xcoeff)
;  x1_data = double(rat * (xrange[1] - xrange[0]) + xrange[0])
;  
;  return, [x0_data, x1_data]
;  
;end
;
;;+
;; :Description:
;;   Bring a new window with the zoom of the data
;;
;; :Params:
;;    event
;;
;; :Author: j35
;;-
;pro zoom_selection, event
;  compile_opt idl2
;  
;  qz_range = determine_range_Qz_selected(event)
;  qz_range = qz_range[sort(qz_range)]
;  qx_range   = determine_range_Qx_selected(event)
;  qx_range = qx_range[sort(qx_range)]
;  
;  ;retrieve selected region from big array
;  widget_control, event.top, get_uvalue=global_plot
;  
;  ;calculate qx and qz index range
;  data_x = (*global_plot).x_axis
;  
;  qx_min = qx_range[0]
;  qx_max = qx_range[1]
;  
;  qx_range_index_left = where(qx_min ge data_x)
;  qx_range_index_min = qx_range_index_left[-1]
;  
;  qx_range_index_right = where(data_x ge qx_max)
;  qx_range_index_max = qx_range_index_right[0]
;  
;  qx_range_index = fix([qx_range_index_min, qx_range_index_max])
;  
;  ;qz
;  data_y = (*global_plot).y_axis
;  
;  qz_min = qz_range[0]
;  qz_max = qz_range[1]
;  
;  qz_range_index_left = where(qz_min ge data_y)
;  qz_range_index_min = qz_range_index_left[-1]
;  
;  qz_range_index_right = where(data_y ge qz_max)
;  qz_range_index_max = qz_range_index_right[0]
;  
;  qz_range_index = fix([qz_range_index_min, qz_range_index_max])
;  
;  ;create new array of selected region
;  data_z = (*(*global_plot).data_linear) ;Array[qx,qz]
;  
;  zoom_data_x = Data_x[qx_range_index[0]:qx_range_index[1]]
;  zoom_data_y = Data_y[qz_range_index[0]:qz_range_index[1]]
;  
;  zoom_data_z = data_z[qx_range_index[0]:qx_range_index[1],$
;    qz_range_index[0]:qz_range_index[1]]
;    
;  final_plot, event=event, $
;    offset = 50, $
;    data = zoom_data_z, $
;    time_stamp = (*global_plot).time_stamp, $
;    x_axis = zoom_data_x, $
;    y_axis = zoom_data_y, $
;    default_loadct = (*global_plot).default_loadct, $
;    default_plot_size = (*global_plot).default_plot_size, $
;    main_base_uname = 'final_plot_base', $
;    smooth_coefficient = (*global_plot).smooth_coefficient, $
;    metadata = (*global_plot).metadata, $
;    output_folder = (*global_plot).output_folder
;    
;end

;;+
;; :Description:
;;    plot the zoom selection
;;
;; :Params:
;;    event
;;
;;
;;
;; :Author: j35
;;-
;pro refresh_zoom_selection, event
;  compile_opt idl2
;  
;  refresh_plot, event
;  
;  widget_control, event.top, get_uvalue=global_plot
;  
;  selection = (*global_plot).draw_zoom_selection
;  
;  id = widget_info(event.top,find_by_uname='draw')
;  widget_control, id, GET_VALUE = plot_id
;  wset, plot_id
;  
;  xrange = [selection[0],selection[2]]
;  yrange = [selection[1],selection[3]]
;  
;  xmin = min(xrange, max=xmax)
;  ymin = min(yrange, max=ymax)
;  
;  plots, [xmin, xmin, xmax, xmax, xmin],$
;    [ymin, ymax, ymax, ymin, ymin],$
;    /DEVICE,$
;    LINESTYLE = 3,$
;    COLOR = 200
;    
;end
;
;;+
;; :Description:
;;    Using the date, this will produce a
;;    default file name that will be used when producing the output files
;;
;; :Params:
;;    event
;;
;; :Returns:
;;   default output file name
;;
;; :Author: j35
;;-
;function create_default_base_file_name, event
;  compile_opt idl2
;  
;  _time_stamp = GenerateIsoTimeStamp()
;  _base_file_name = 'SOS_infos_' + _time_stamp
;  
;  return, _base_file_name
;end

;;+
;; :Description:
;;    reach when the user interacts with the plot (left click, move mouse
;;    with left click).
;;
;; :Params:
;;    event
;;
;; :Author: j35
;;-
;pro draw_eventcb, event
;  compile_opt idl2
;  
;  widget_control, event.top, get_uvalue=global_plot
;  
;  catch, error
;  if (error ne 0) then begin
;    catch,/cancel
;    info_base = (*global_plot).cursor_info_base
;    counts_vs_xaxis_plot_id = (*global_plot).counts_vs_xaxis_base
;    counts_vs_yaxis_plot_id = (*global_plot).counts_vs_yaxis_base
;    
;    ;Draw vertical and horizontal lines when info mode is ON
;    if (widget_info(info_base,/valid_id) ne 0 || $
;      widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0 || $
;      widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0) then begin
;      
;      ;if user click shift key in the same time, enlarge the size of the
;      ;cursor info base to provide from ... to ... labels
;      if (event.press eq 1 && event.key eq 1) then begin
;        (*global_plot).shift_key_status = 1b
;        
;        Qx0 = retrieve_data_x_value(event)
;        Qz0 = retrieve_data_y_value(event)
;        QxQzrange = [Qx0, Qz0]
;        QxQzrangeEvent = [Event.x, event.y]
;        (*global_plot).QxQzrange = QxQzrange
;        (*global_plot).EventRangeSelection = QxQzrangeEvent
;        
;      endif
;      
;      ;shift key has been released
;      if (event.key eq 1 && event.press eq 0) then begin
;        (*global_plot).shift_key_status = 0b
;        refresh_plot, event, recalculate=1
;        save_background, event=event
;      endif
;      
;    endif
;    
;    ;if x,y and counts base is on, shows live values of x,y and counts
;    if (widget_info(info_base, /valid_id) ne 0) then begin
;    
;      ;keep the main widget_draw activated
;      id = widget_info(event.top, find_by_uname='draw')
;      widget_control, id, /input_focus
;      
;      x = retrieve_data_x_value(event)
;      y = retrieve_data_y_value(event)
;      z = retrieve_data_z_value(event)
;      
;      if ((*global_plot).shift_key_status) then begin ;shift is clicked
;      
;        QxQzrange = (*global_plot).QxQzrange
;        
;        Qx0 = QxQzrange[0]
;        Qz0 = QxQzrange[1]
;        
;        Qxmin = min([Qx0,x],max=Qxmax)
;        Qzmin = min([Qz0,y],max=Qzmax)
;        
;        x = strcompress(qxmin,/remove_all) + ' --> ' + $
;          strcompress(qxmax,/remove_all)
;        y = strcompress(qzmin,/remove_all) + ' --> ' + $
;          strcompress(qzmax,/remove_all)
;        z = strcompress(z,/remove_all)
;        
;      endif else begin
;      
;        x = strcompress(x,/remove_all)
;        y = strcompress(y,/remove_all)
;        z = strcompress(z,/remove_all)
;        
;      endelse
;      
;      putValue, base=info_base, 'cursor_info_x_value_uname', x
;      putValue, base=info_base, 'cursor_info_y_value_uname', y
;      putValue, base=info_base, 'cursor_info_z_value_uname', z
;      
;    endif
;    
;    ;save the background to keep the first big Cross as part of the background
;    if (event.press eq 1 && event.key eq 1) then begin
;      save_background, event=event
;    endif
;    
;    ;counts vs xaxis (qx)
;    if (widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0) then begin
;      ;keep the main widget_draw activated
;      id = widget_info(event.top, find_by_uname='draw')
;      widget_control, id, /input_focus
;      plot_counts_vs_xaxis, event
;    endif
;    
;    ;counts vs yaxis (qz)
;    if (widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0) then begin
;      ;keep the main widget_draw activated
;      id = widget_info(event.top, find_by_uname='draw')
;      widget_control, id, /input_focus
;      plot_counts_vs_yaxis, event
;    endif
;    
;    ;right click validated only if there is at least one of the infos base
;    if ((widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0) || $
;      (widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0)) then begin
;      
;      if (event.press eq 4) then begin ;right click
;      
;        x=event.x
;        y=event.y
;        id = widget_info(event.top, find_by_uname='draw')
;        geometry = widget_info(id,/geometry)
;        xsize = geometry.xsize
;        ysize = geometry.ysize
;        
;        widget_control, id, GET_VALUE = plot_id
;        wset, plot_id
;        
;        off = 20
;        
;        plots, x, 0, /device
;        plots, x, y-off, /device, /continue, color=fsc_color('red')
;        plots, x, y+off, /device
;        plots, x, ysize, /device, /continue, color=fsc_color('red')
;        
;        plots, 0, y, /device
;        plots, x-off, y, /device, /continue, color=fsc_color('red')
;        plots, x+off, y, /device
;        plots, xsize, y, /device, /continue, color=fsc_color('red')
;        
;        default_base_file_name = create_default_base_file_name(event)
;        
;        validate_qx_base = widget_info(counts_vs_xaxis_plot_id,/valid_id)
;        validate_qz_base = widget_info(counts_vs_yaxis_plot_id,/valid_id)
;        
;        output_info_base, event=event, $
;          parent_base_uname = 'final_plot_base', $
;          output_folder = (*global_plot).output_folder, $
;          default_base_file = default_base_file_name, $
;          validate_qx_base = validate_qx_base, $
;          validate_qz_base = validate_qz_base, $
;          counts_vs_qz_lin = (*global_plot).counts_vs_qz_lin, $
;          counts_vs_qx_lin = (*global_plot).counts_vs_qx_lin
;          
;        return
;      endif
;      
;    endif
;    
;    draw_zoom_selection = (*global_plot).draw_zoom_selection
;    
;    if ((*global_plot).left_click) then begin ;moving mouse with left click
;      x1 = event.x
;      y1 = event.y
;      draw_zoom_selection[2] = x1
;      draw_zoom_selection[3] = y1
;      (*global_plot).draw_zoom_selection = draw_zoom_selection
;      refresh_zoom_selection, event
;    endif
;    
;    if (event.press eq 1 && $
;      event.clicks eq 1) then begin ;user left clicked the mouse
;      
;      if ((*global_plot).shift_key_status) then begin
;        (*global_plot).shift_key_status = 0b
;        refresh_plot, event, recalculate=1
;        save_background, event=event
;      endif
;      
;      (*global_plot).left_click = 1b
;      x0 = event.x
;      y0 = event.y
;      draw_zoom_selection[0] = x0
;      draw_zoom_selection[1] = y0
;      (*global_plot).draw_zoom_selection = draw_zoom_selection
;    endif
;    
;    if (event.release eq 1 && $
;      (*global_plot).left_click && $
;      event.key ne 1) then begin ;user release left clicked
;      (*global_plot).left_click = 0b
;      x1 = event.x
;      y1 = event.y
;      
;      ;make sure we stay within the display
;      id = widget_info(event.top, find_by_uname='draw')
;      geometry = widget_info(id, /geometry)
;      xsize = geometry.xsize
;      ysize = geometry.ysize
;      
;      if (x1 gt xsize) then x1 = xsize
;      if (x1 lt 0) then x1 = 0
;      if (y1 gt ysize) then y1 = ysize
;      if (y1 lt 0) then y1 = 0
;      
;      ;check that user selected a box,not only 1 pixel
;      result = is_real_selection(event, x1, y1)
;      if (result eq 0) then return
;      
;      draw_zoom_selection[2] = x1
;      draw_zoom_selection[3] = y1
;      
;      (*global_plot).draw_zoom_selection = draw_zoom_selection
;      
;      catch, error
;      if (error ne 0) then begin
;        catch,/cancel
;      endif else begin
;        zoom_selection, event
;      endelse
;      
;      refresh_plot, event
;    endif
;    
;    ;Draw vertical and horizontal lines when info mode is ON
;    if (widget_info(info_base,/valid_id) ne 0 || $
;      widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0 || $
;      widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0) then begin
;      
;      if ((*global_plot).left_click) then begin
;      endif else begin
;        refresh_plot, event
;      endelse
;      
;      x=event.x
;      y=event.y
;      id = widget_info(event.top, find_by_uname='draw')
;      geometry = widget_info(id,/geometry)
;      xsize = geometry.xsize
;      ysize = geometry.ysize
;      
;      widget_control, id, GET_VALUE = plot_id
;      wset, plot_id
;      
;      off = 20
;      
;      plots, x, 0, /device
;      plots, x, y-off, /device, /continue, color=fsc_color('white')
;      plots, x, y+off, /device
;      plots, x, ysize, /device, /continue, color=fsc_color('white')
;      
;      plots, 0, y, /device
;      plots, x-off, y, /device, /continue, color=fsc_color('white')
;      plots, x+off, y, /device
;      plots, xsize, y, /device, /continue, color=fsc_color('white')
;      
;      if ((*global_plot).shift_key_status) then begin ;shift is clicked
;      
;        QxQzrangeEvent = (*global_plot).EventRangeSelection
;        
;        xmin = min([QxQzrangeEvent[0],x],max=xmax)
;        ymin = min([QxQzrangeEvent[1],y],max=ymax)
;        
;        plots, xmin, ymin, /device
;        plots, xmin, ymax, /device, /continue, color=fsc_color('green')
;        plots, xmax, ymax, /device, /continue, color=fsc_color('green')
;        plots, xmax, ymin, /device, /continue, color=fsc_color('green')
;        plots, xmin, ymin, /device, /continue, color=fsc_color('green')
;        
;      endif
;      
;    endif
;    
;  endif else begin ;endif of catch error
;  
;    if (event.enter eq 0) then begin ;leaving plot
;      info_base = (*global_plot).cursor_info_base
;      ;if x,y and counts base is on, shows live values of x,y and counts
;      if (widget_info(info_base, /valid_id) ne 0) then begin
;        na = 'N/A'
;        refresh_plot, event
;        putValue, base=info_base, 'cursor_info_x_value_uname', na
;        putValue, base=info_base, 'cursor_info_y_value_uname', na
;        putValue, base=info_base, 'cursor_info_z_value_uname', na
;      endif
;      
;      ;counts vs xaxis (tof or lambda)
;      counts_vs_xaxis_plot_id = (*global_plot).counts_vs_xaxis_base
;      if (widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0) then begin
;        plot_counts_vs_xaxis, event, clear=1
;      endif
;      
;      ;counts vs yaxis (pixel or angle)
;      counts_vs_yaxis_plot_id = (*global_plot).counts_vs_yaxis_base
;      if (widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0) then begin
;        plot_counts_vs_yaxis, event, clear=1
;      endif
;      
;    endif
;    
;  endelse
;  
;end
