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
function is_real_px_vs_tof_selection, event, x1, y1
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  draw_zoom_selection = (*global_px_vs_tof).draw_zoom_selection
  x0 = draw_zoom_selection[0]
  y0 = draw_zoom_selection[1]
  
  if (x0 eq x1 AND y0 eq y1) then return, 0
  return, 1
  
end

;+
; :Description:
;    Will display a verticale line at the position of the cursor on the
;    2d plots mapped
;
; :Keywords:
;    event
;    xaxis      'tof' or 'pixel'
;
; :Author: j35
;-
pro display_cursor_line_on_2d_plot, event=event, xaxis=xaxis
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  case (xaxis) of
    'tof': begin
      _base = (*global_px_vs_tof).counts_vs_xaxis_base
      _draw_uname = (*global_px_vs_tof).counts_vs_xaxis_plot_uname
      px_vs_tof_plot_counts_vs_xaxis, base=_base
      data = (*(*global_px_vs_tof).data2d_linear)
      _data = total(data,2)
      max_y = max(_data)
      (*global_px_vs_tof).info_base_counts_vs_xaxis_counts_max = max_y
      x = px_vs_tof_retrieve_data_x_value(event)
      color= 'blue'
    end
    'pixel': begin
      _base = (*global_px_vs_tof).counts_vs_yaxis_base
      _draw_uname = (*global_px_vs_tof).counts_vs_yaxis_plot_uname
      px_vs_tof_plot_counts_vs_yaxis, base=_base
      data = (*(*global_px_vs_tof).data2d_linear)
      _data = total(data,1)
      max_y = max(_data)
      (*global_px_vs_tof).info_base_counts_vs_yaxis_counts_max = max_y
      x = px_vs_tof_retrieve_data_y_value(event)
      color='red'
    end
  endcase
  
  _id = widget_info(_base, find_by_uname= _draw_uname)
  widget_control, _id, GET_VALUE = plot_id
  wset, plot_id
  
  plots, x, 0, /data
  plots, x, max_y, /data, /continue, color=fsc_color(color), $
    linestyle=1
    
end

;+
; :Description:
;    Describe the procedure.
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro display_corner_of_selection_in_info_bases, event, xaxis=xaxis
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  case (xaxis) of
    'tof': begin
    
      counts_vs_xaxis_plot_id = (*global_px_vs_tof).counts_vs_xaxis_base
      if (widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0) then begin
      
        draw_zoom_data_selection = (*global_px_vs_tof).draw_zoom_data_selection
        x0 = draw_zoom_data_selection[0]
        x1 = draw_zoom_data_selection[2]
        
        max_y = (*global_px_vs_tof).info_base_counts_vs_xaxis_counts_max
        
        xaxis_plot_uname = (*global_px_vs_tof).counts_vs_xaxis_plot_uname
        id = widget_info(counts_vs_xaxis_plot_id, find_by_uname=xaxis_plot_uname)
        widget_control, id, GET_VALUE = plot_id
        wset, plot_id
        
        if (x0 eq -1 && x1 eq -1) then return
        
        _base = (*global_px_vs_tof).counts_vs_xaxis_base
        ;px_vs_tof_plot_counts_vs_xaxis, base=_base
        
        if (x0 ne -1) then begin
          plots, x0, 0, /data
          plots, x0, max_y, /data, /continue, color=fsc_color('blue'), $
            linestyle=0
        endif
        
        if (x1 ne -1) then begin
          plots, x1, 0, /data
          plots, x1, max_y, /data, /continue, color=fsc_color('blue'), $
            linestyle=0
        endif
      endif
      
    end
    
    'pixel': begin
    
      counts_vs_yaxis_plot_id = (*global_px_vs_tof).counts_vs_yaxis_base
      if (widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0) then begin
      
        draw_zoom_data_selection = (*global_px_vs_tof).draw_zoom_data_selection
        x0 = draw_zoom_data_selection[1]
        x1 = draw_zoom_data_selection[3]
        
        max_y = (*global_px_vs_tof).info_base_counts_vs_yaxis_counts_max
        
        yaxis_plot_uname = (*global_px_vs_tof).counts_vs_yaxis_plot_uname
        id = widget_info(counts_vs_yaxis_plot_id, find_by_uname=yaxis_plot_uname)
        widget_control, id, GET_VALUE = plot_id
        wset, plot_id
        
        if (x0 eq -1 && x1 eq -1) then return
        
        _base = (*global_px_vs_tof).counts_vs_yaxis_base
        ;px_vs_tof_plot_counts_vs_xaxis, base=_base
        
        if (x0 ne -1) then begin
          plots, x0, 0, /data
          plots, x0, max_y, /data, /continue, color=fsc_color('red'), $
            linestyle=0
        endif
        
        if (x1 ne -1) then begin
          plots, x1, 0, /data
          plots, x1, max_y, /data, /continue, color=fsc_color('red'), $
            linestyle=0
        endif
        
      endif
      
    end
    
  endcase
  
end

;+
; :Description:
;    Display on the right of the cursor and selection infos base the
;    current pixel and tof range of the selection
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro display_selection_information, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  info_base = (*global_px_vs_tof).cursor_info_base
  
  if (~widget_info(info_base,/valid_id)) then return
  
  ;display information about selection in cursor/selection info base
  draw_zoom_data_selection = (*global_px_vs_tof).draw_zoom_data_selection
  x0 = draw_zoom_data_selection[0]
  x1 = draw_zoom_data_selection[2]
  y0 = fix(draw_zoom_data_selection[1])
  y1 = fix(draw_zoom_data_selection[3])
  
  if (x0 ne -1) then begin
    if (x1 ne -1) then begin
      xmin = min([x0,x1],max=xmax)
      label_x = strcompress(xmin,/remove_all) + ' -> ' + $
        strcompress(xmax,/remove_all)
    endif else begin
      label_x = strcompress(x0,/remove_all) + ' -> N/A'
    endelse
  endif else begin
    label_x = 'N/A -> N/A'
  endelse
  putValue, base=info_base, 'px_vs_tof_cursor_info_x0x1_value_uname', $
    label_x
    
  if (y0 ne -1) then begin
    if (y1 ne -1) then begin
      ymin = min([y0,y1],max=ymax)
      label_y = strcompress(ymin,/remove_all) + ' -> ' + $
        strcompress(ymax,/remove_all)
    endif else begin
      label_y = strcompress(y0,/remove_all) + ' -> N/A'
    endelse
  endif else begin
    label_y = 'N/A -> N/A'
  endelse
  putValue, base=info_base, 'px_vs_tof_cursor_info_y0y1_value_uname', $
    label_y
    
end

;
;+
; :Description:
;    reach when the user interacts with the plot (left click, move mouse
;    with left click).
;
; :Params:
;    event
;
; :Author: j35
;-
pro px_vs_tof_draw_eventcb, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    info_base = (*global_px_vs_tof).cursor_info_base
    counts_vs_xaxis_plot_id = (*global_px_vs_tof).counts_vs_xaxis_base
    counts_vs_yaxis_plot_id = (*global_px_vs_tof).counts_vs_yaxis_base
    
    ;Draw vertical and horizontal lines when info mode is ON
    if (widget_info(info_base,/valid_id) ne 0 || $
      widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0 || $
      widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0) then begin
      
      ;if user click shift key in the same time, enlarge the size of the
      ;cursor info base to provide from ... to ... labels
      if (event.press eq 1 && event.key eq 1) then begin
        (*global_px_vs_tof).shift_key_status = 1b
        
        tof_0   = px_vs_tof_retrieve_data_x_value(event)
        pixel_0 = px_vs_tof_retrieve_data_y_value(event)
        
        QxQzrange = [Qx0, Qz0]
        QxQzrangeEvent = [Event.x, event.y]
        (*global_plot).QxQzrange = QxQzrange
        (*global_plot).EventRangeSelection = QxQzrangeEvent
        
      endif
      
    endif
    
    ;if x,y and counts base is on, shows live values of x,y and counts
    if (widget_info(info_base, /valid_id) ne 0) then begin
    
      ;keep the main widget_draw activated
      id = widget_info(event.top, find_by_uname='draw_px_vs_tof_input_files')
      widget_control, id, /input_focus
      
      x = px_vs_tof_retrieve_data_x_value(event)
      y = fix(px_vs_tof_retrieve_data_y_value(event))
      z = long(px_vs_tof_retrieve_data_z_value(event))
      
      x = strcompress(x,/remove_all)
      y = strcompress(y,/remove_all)
      z = strcompress(z,/remove_all)
      
      putValue, base=info_base, 'px_vs_tof_cursor_info_x_value_uname', x
      putValue, base=info_base, 'px_vs_tof_cursor_info_y_value_uname', y
      putValue, base=info_base, 'px_vs_tof_cursor_info_z_value_uname', z
      
      display_selection_information, event
      
    endif
    
    ;if counts vs tof 2d plot is available
    if (widget_info(counts_vs_xaxis_plot_id,/valid_id)) then begin
      display_cursor_line_on_2d_plot, event=event, xaxis='tof'
      display_corner_of_selection_in_info_bases, event, xaxis='tof'
    endif
    
    ;if counts vs pixel 2d plot is available
    if (widget_info(counts_vs_yaxis_plot_id,/valid_id)) then begin
      display_cursor_line_on_2d_plot, event=event, xaxis='pixel'
      display_corner_of_selection_in_info_bases, event, xaxis='pixel'
    endif
    
    ;save the background to keep the first big Cross as part of the background
    if (event.press eq 1 && event.key eq 1) then begin
      save_background, event=event
    endif
    
    draw_zoom_selection = (*global_px_vs_tof).draw_zoom_selection
    draw_zoom_data_selection = (*global_px_vs_tof).draw_zoom_data_selection
    
    if ((*global_px_vs_tof).left_click) then begin ;moving mouse with left click
      x1 = event.x
      y1 = event.y
      draw_zoom_selection[2] = x1
      draw_zoom_selection[3] = fix(y1)
      (*global_px_vs_tof).draw_zoom_selection = draw_zoom_selection
      
      x1_data = px_vs_tof_retrieve_data_x_value(event)
      y1_data = px_vs_tof_retrieve_data_y_value(event)
      draw_zoom_data_selection[2] = x1_data
      draw_zoom_data_selection[3] = y1_data
      (*global_px_vs_tof).draw_zoom_data_selection = draw_zoom_data_selection
      
      refresh_zoom_px_vs_tof_selection, event
      
    endif
    
    if (event.press eq 1 && $
      event.clicks eq 1) then begin ;user left clicked the mouse
      
      px_vs_tof_refresh_plot, event, recalculate=1
      save_px_vs_tof_background, event=event
      
      (*global_px_vs_tof).left_click = 1b
      x0 = event.x
      y0 = event.y
      draw_zoom_selection[0] = x0
      draw_zoom_selection[1] = fix(y0)
      draw_zoom_selection[2] = -1.
      draw_zoom_selection[3] = -1.
      (*global_px_vs_tof).draw_zoom_selection = draw_zoom_selection
      
      x0_data = px_vs_tof_retrieve_data_x_value(event)
      y0_data = px_vs_tof_retrieve_data_y_value(event)
      draw_zoom_data_selection[0] = x0_data
      draw_zoom_data_selection[1] = y0_data
      draw_zoom_data_selection[2] = -1
      draw_zoom_data_selection[3] = -1
      (*global_px_vs_tof).draw_zoom_data_selection = draw_zoom_data_selection
      
     if (widget_info(info_base, /valid_id) ne 0) then begin
      display_selection_information, event
      endif
      
        ;if counts vs tof 2d plot is available
    if (widget_info(counts_vs_xaxis_plot_id,/valid_id)) then begin
         display_cursor_line_on_2d_plot, event=event, xaxis='tof'
      display_corner_of_selection_in_info_bases, event, xaxis='tof'
    endif
    
    ;if counts vs pixel 2d plot is available
    if (widget_info(counts_vs_yaxis_plot_id,/valid_id)) then begin
         display_cursor_line_on_2d_plot, event=event, xaxis='pixel'
      display_corner_of_selection_in_info_bases, event, xaxis='pixel'
    endif
      
    endif
    
    if (event.release eq 1 && $
      (*global_px_vs_tof).left_click && $
      event.key ne 1) then begin ;user release left clicked
      (*global_px_vs_tof).left_click = 0b
      x1 = event.x
      y1 = event.y
      
      ;check that user selected a box,not only 1 pixel
      result = is_real_px_vs_tof_selection(event, x1, y1)
      if (result eq 0) then begin
        ;ok, then we reset the selection
        draw_zoom_data_selection[0] = -1
        draw_zoom_data_selection[1] = -1
        draw_zoom_data_selection[2] = -1
        draw_zoom_data_selection[3] = -1
        (*global_px_vs_tof).draw_zoom_data_selection = draw_zoom_data_selection
        display_selection_information, event

        ;if counts vs tof 2d plot is available
    if (widget_info(counts_vs_xaxis_plot_id,/valid_id)) then begin
         display_cursor_line_on_2d_plot, event=event, xaxis='tof'
      display_corner_of_selection_in_info_bases, event, xaxis='tof'
    endif
    
    ;if counts vs pixel 2d plot is available
    if (widget_info(counts_vs_yaxis_plot_id,/valid_id)) then begin
         display_cursor_line_on_2d_plot, event=event, xaxis='pixel'
      display_corner_of_selection_in_info_bases, event, xaxis='pixel'
    endif

        return
      endif
      
      draw_zoom_selection[2] = x1
      draw_zoom_selection[3] = y1
      
      (*global_px_vs_tof).draw_zoom_selection = draw_zoom_selection
      
      xmin = min([draw_zoom_selection[0],x1],max=xmax)
      ymin = min([draw_zoom_selection[1],y1],max=ymax)
      
      plots, xmin, ymin, /device
      plots, xmin, ymax, /device, /continue, color=fsc_color('green')
      plots, xmax, ymax, /device, /continue, color=fsc_color('green')
      plots, xmax, ymin, /device, /continue, color=fsc_color('green')
      plots, xmin, ymin, /device, /continue, color=fsc_color('green')
      
      save_px_vs_tof_background, event=event
      
    endif
    
    ;Draw vertical and horizontal lines when info mode is ON
    if (widget_info(info_base,/valid_id) ne 0 || $
      widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0 || $
      widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0) then begin
      
      if ((*global_px_vs_tof).left_click) then begin
      endif else begin
        px_vs_tof_refresh_plot, event
      endelse
      
      x=event.x
      y=event.y
      id = widget_info(event.top, find_by_uname='draw_px_vs_tof_input_files')
      geometry = widget_info(id,/geometry)
      xsize = geometry.xsize
      ysize = geometry.ysize
      
      widget_control, id, GET_VALUE = plot_id
      wset, plot_id
      
      off = 20
      
      plots, x, 0, /device
      plots, x, y-off, /device, /continue, color=fsc_color('blue'), $
        linestyle=1
        
      plots, x, y+off, /device
      plots, x, ysize, /device, /continue, color=fsc_color('blue'), $
        linestyle = 1
        
        
      plots, 0, y, /device
      plots, x-off, y, /device, /continue, color=fsc_color('red'), $
        linestyle = 1
      plots, x+off, y, /device
      plots, xsize, y, /device, /continue, color=fsc_color('red'), $
        linestyle = 1
        
    endif
    
  endif else begin ;endif of catch error
  
    if (event.enter eq 0) then begin ;leaving plot
    
      ;catch, /cancel ;turn off comment just for debugging
    
      info_base = (*global_px_vs_tof).cursor_info_base
      ;if x,y and counts base is on, shows live values of x,y and counts
      if (widget_info(info_base, /valid_id) ne 0) then begin
        na = 'N/A'
        px_vs_tof_refresh_plot, event
        putValue, base=info_base, 'px_vs_tof_cursor_info_x_value_uname', na
        putValue, base=info_base, 'px_vs_tof_cursor_info_y_value_uname', na
        putValue, base=info_base, 'px_vs_tof_cursor_info_z_value_uname', na
      endif
      
      ;counts vs xaxis (tof or lambda)
      counts_vs_xaxis_plot_id = (*global_px_vs_tof).counts_vs_xaxis_base
      if (widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0) then begin
        px_vs_tof_plot_counts_vs_xaxis, base=counts_vs_xaxis_plot_id
        display_corner_of_selection_in_info_bases, event, xaxis='tof'
      endif
      
      ;counts vs yaxis (pixel or angle)
      counts_vs_yaxis_plot_id = (*global_px_vs_tof).counts_vs_yaxis_base
      if (widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0) then begin
        px_vs_tof_plot_counts_vs_yaxis, base=counts_vs_yaxis_plot_id
        display_corner_of_selection_in_info_bases, event, xaxis='pixel'
      endif
      
    endif
    
  endelse
  
end
