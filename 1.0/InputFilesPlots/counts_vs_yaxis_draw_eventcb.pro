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

pro px_vs_tof_counts_vs_yaxis_draw_eventcb, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_axis_plot
  
  global_px_vs_tof = (*global_axis_plot).global
  info_base = (*global_px_vs_tof).cursor_info_base
  ymax = (*global_axis_plot).ymax
  main_event = (*global_axis_plot).main_event
  yaxis_type = (*global_axis_plot).default_yscale_settings
  ymin = (yaxis_type eq 0) ? 0 : 1  ;0 for linear, 1 for log
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    
    ;refresh the plot
    base = (*global_axis_plot)._base
    px_vs_tof_plot_counts_vs_yaxis, base=base
    
    cursor, x, y, /data, /nowait
    xrange = (*global_axis_plot).xrange
    
    ;make sure we are in the range allowed
    if (x gt xrange[1]) then x=xrange[1]
    if (x lt xrange[0]) then x=xrange[0]
    
    plots, x, ymin, /data
    plots, x, ymax, /data,/continue, color=fsc_color('red'), linestyle=1
    
    if (widget_info(info_base,/valid_id)) then begin
    ;display the current value in CURSOR LIVE base
    live_pixel_value = fix(x)
    putValue, base=info_base, 'px_vs_tof_cursor_info_y_value_uname', $
      strcompress(fix(live_pixel_value),/remove_all)
    putValue, base=info_base, 'px_vs_tof_cursor_info_x_value_uname', $
      'N/A'
    putValue, base=info_base, 'px_vs_tof_cursor_info_z_value_uname', $
      'N/A'
      endif
      
    pixel_data = x
    pixel_device = px_vs_tof_px_data_to_px_device(global_px_vs_tof, $
    pixel=pixel_data)
    
    ;mouse interaction with plot
    if (event.press eq 1 && $
      event.clicks eq 1) then begin ;user left clicked the mouse
      (*global_axis_plot).left_clicked = 1b
      id = widget_info(event.top, $
        find_by_uname='px_vs_tof_counts_vs_yaxis_plot_uname')
      widget_control, id, get_value=plot_id
      wset, plot_id
      plots, x, ymin, /data
      plots, x, ymax, /data, /continue, color=fsc_color('green'), linestyle=2
      
      string_pixel_range_already_selected = getValue(base=info_base, $
        uname='px_vs_tof_cursor_info_y0y1_value_uname')
      pixel_range_already_selected = $
        strsplit(string_pixel_range_already_selected,'->',/extract)
        
      x1 = strcompress(pixel_range_already_selected[1],/remove_all)
      if (x1 eq 'N/A') then begin
        sxmin = strcompress(fix(x),/remove_all)
        sxmax = 'N/A'
      endif else begin
        int_x0 = fix(x)
        int_x1 = fix(x1)
        xmin = min([int_x0,int_x1], max=xmax)
        sxmin = strcompress(xmin,/remove_all)
        sxmax = strcompress(xmax,/remove_all)
      endelse
      
      string_pixel_range_already_selected = sxmin + ' -> ' + sxmax
      putValue, base=info_base, 'px_vs_tof_cursor_info_y0y1_value_uname', $
        string_pixel_range_already_selected
        
      ;record new selection corners
      save_draw_zoom_selection, main_event, pixel=[sxmin,sxmax]
      px_vs_tof_refresh_plot_with_selection, main_event, recalculate=1
      
    endif
    
    if (event.press eq 4 && $
      event.clicks eq 1) then begin ;user right clicked the mouse
      (*global_axis_plot).right_clicked = 1b
      id = widget_info(event.top, $
        find_by_uname='px_vs_tof_counts_vs_yaxis_plot_uname')
      widget_control, id, get_value=plot_id
      wset, plot_id
      plots, x, ymin, /data
      plots, x, ymax, /data,/continue, color=fsc_color('green'), linestyle=2
      
      string_pixel_range_already_selected = getValue(base=info_base,$
        uname='px_vs_tof_cursor_info_y0y1_value_uname')
      pixel_range_already_selected = $
        strsplit(string_pixel_range_already_selected,'->',/extract)
        
      x0 = strcompress(pixel_range_already_selected[0],/remove_all)
      if (x0 eq 'N/A') then begin
        sxmin = 'N/A'
        sxmax = strcompress(fix(x),/remove_all)
      endif else begin
        int_x0 = fix(x0)
        int_x1 = fix(x)
        xmin = min([int_x0,int_x1],max=xmax)
        sxmin = strcompress(xmin,/remove_all)
        sxmax = strcompress(xmax,/remove_all)
      endelse
      
      string_pixel_range_already_selected = sxmin + ' -> ' + sxmax
      putValue, base=info_base, 'px_vs_tof_cursor_info_y0y1_value_uname', $
        string_pixel_range_already_selected
        
      ;record new selection corners and plot it
      save_draw_zoom_selection, main_event, pixel=[sxmin,sxmax]
      px_vs_tof_refresh_plot_with_selection, main_event, recalculate=1
    endif
    
    if (event.release eq 1) then begin ;left click button released
      (*global_axis_plot).left_clicked = 0b
      string_pixel_range_already_selected = getValue(base=info_base,$
        uname='px_vs_tof_cursor_info_y0y1_value_uname')
      pixel_range_already_selected = $
        strsplit(string_pixel_range_already_selected,'->',/extract)
        
      x1 = strcompress(pixel_range_already_selected[1],/remove_all)
      if (x1 eq 'N/A') then begin
        sxmin = strcompress(fix(x),/remove_all)
        sxmax = 'N/A'
      endif else begin
        int_x0 = fix(x)
        int_x1 = fix(x1)
        xmin = min([int_x0,int_x1],max=xmax)
        sxmin = strcompress(xmin,/remove_all)
        sxmax = strcompress(xmax,/remove_all)
      endelse
      
      string_pixel_range_already_selected = sxmin + ' -> ' + sxmax
      putValue, base=info_base, 'px_vs_tof_cursor_info_y0y1_value_uname', $
        string_pixel_range_already_selected
    endif
    
    if (event.release eq 4) then begin ;right click released
      (*global_axis_plot).right_clicked = 0b
      string_pixel_range_already_selected = getValue(base=info_base,$
        uname='px_vs_tof_cursor_info_y0y1_value_uname')
      pixel_range_already_selected = $
        strsplit(string_pixel_range_already_selected,'->',/extract)
        
      x0 = strcompress(pixel_range_already_selected[0],/remove_all)
      if (x0 eq 'N/A') then begin
        sxmin = 'N/A'
        sxmax = strcompress(fix(x),/remove_all)
      endif else begin
        int_x0 = fix(x0)
        int_x1 = fix(x)
        xmin = min([int_x0,int_x1],max=xmax)
        sxmin= strcompress(xmin,/remove_all)
        sxmax = strcompress(xmax,/remove_all)
      endelse
      
      string_pixel_range_already_selected = sxmin + ' -> ' + sxmax
      putValue, base=info_base, 'px_vs_tof_cursor_info_y0y1_value_uname', $
        string_pixel_range_already_selected
        
      ;record new selection corners
      save_draw_zoom_selection, main_event, pixel=[sxmin,sxmax]
      px_vs_tof_refresh_plot_with_selection, main_event, recalculate=1
      
    endif
    
    ;moving the mouse with left button clicked
    if ((*global_axis_plot).left_clicked) then begin
      plots, x, 0, /data
      plots, x, ymax, /data,/continue, color=fsc_color('green'), linestyle=2
      
      ;update live the selection infos in 'cursor and selection infos base'
      string_pixel_range_already_selected = getValue(base=info_base,$
        uname='px_vs_tof_cursor_info_y0y1_value_uname')
      pixel_range_already_selected = $
        strsplit(string_pixel_range_already_selected,'->',/extract)
        
      sx1 = strcompress(pixel_range_already_selected[1],/remove_all)
      sx  = strcompress(fix(x),/remove_all)
      string_pixel_range_already_selected = sx + ' -> ' + sx1
      putValue, base=info_base, 'px_vs_tof_cursor_info_y0y1_value_uname', $
        string_pixel_range_already_selected
        
      ;record new selection corners
      save_draw_zoom_selection, main_event, pixel=[sx,sx1]
      px_vs_tof_refresh_plot_with_selection, main_event, recalculate=1
      
    endif
    
    ;moving the mouse with right button clicked
    if ((*global_axis_plot).right_clicked) then begin
      plots, x, 0, /data
      plots, x, ymax, /data,/continue, color=fsc_color('green'), linestyle=2
      
      ;update live the selection infos in 'cursor and selection infos base'
      string_pixel_range_already_selected = getValue(base=info_base,$
        uname='px_vs_tof_cursor_info_y0y1_value_uname')
      pixel_range_already_selected = $
        strsplit(string_pixel_range_already_selected,'->',/extract)
        
      sx0 = strcompress(pixel_range_already_selected[0],/remove_all)
      sx  = strcompress(fix(x),/remove_all)
      string_pixel_range_already_selected = sx0 + ' -> ' + sx
      putValue, base=info_base, 'px_vs_tof_cursor_info_y0y1_value_uname', $
        string_pixel_range_already_selected
        
      ;record new selection corners
      save_draw_zoom_selection, main_event, pixel=[sx0,sx]
      px_vs_tof_refresh_plot_with_selection, main_event, recalculate=1
      
    endif
    
    ;if there is already a selection, display the selection
    string_pixel_range_already_selected = getValue(base=info_base,$
      uname='px_vs_tof_cursor_info_y0y1_value_uname')
    pixel_range_already_selected = $
      strsplit(string_pixel_range_already_selected,'->',/extract)
    pixel_min_already_selected = $
      strcompress(pixel_range_already_selected[0],/remove_all)
    pixel_max_already_selected = $
      strcompress(pixel_range_already_selected[1],/remove_all)
      
    if (pixel_min_already_selected ne 'N/A') then begin
      if ((*global_axis_plot).right_clicked) then begin
        pixel_min = float(pixel_min_already_selected)
        id = widget_info(event.top, $
          find_by_uname='px_vs_tof_counts_vs_yaxis_plot_uname')
        widget_control, id, get_value=plot_id
        wset, plot_id
        plots, pixel_min, ymin, /data
        plots, pixel_min, ymax, /data,/continue, color=fsc_color('red'), $
          linestyle=0
      endif
    endif
    
    if (pixel_min_already_selected ne 'N/A') then begin
      if ((*global_axis_plot).left_clicked eq 0b) then begin
        pixel_min = float(pixel_min_already_selected)
        id = widget_info(event.top, $
          find_by_uname='px_vs_tof_counts_vs_yaxis_plot_uname')
        widget_control, id, get_value=plot_id
        wset, plot_id
        plots, pixel_min, ymin, /data
        plots, pixel_min, ymax, /data,/continue, color=fsc_color('red'), $
          linestyle=0
      endif
    endif
    
    if (pixel_max_already_selected ne 'N/A') then begin
      if ((*global_axis_plot).left_clicked) then begin
        pixel_max = float(pixel_max_already_selected)
        id = widget_info(event.top, $
          find_by_uname='px_vs_tof_counts_vs_yaxis_plot_uname')
        widget_control, id, get_value=plot_id
        wset, plot_id
        plots, pixel_max, ymin, /data
        plots, pixel_max, ymax, /data,/continue, color=fsc_color('red'), $
          linestyle=0
      endif
    endif
    
    if (pixel_max_already_selected ne 'N/A') then begin
      if ((*global_axis_plot).right_clicked eq 0b) then begin
        pixel_max = float(pixel_max_already_selected)
        id = widget_info(event.top, $
          find_by_uname='px_vs_tof_counts_vs_yaxis_plot_uname')
        widget_control, id, get_value=plot_id
        wset, plot_id
        plots, pixel_max, ymin, /data
        plots, pixel_max, ymax, /data,/continue, color=fsc_color('red'), $
          linestyle=0
      endif
    endif
    
    ;display the cursor position in the main plot
    px_vs_tof_refresh_plot, main_event
    
    plots, 0, pixel_device, /device
    xsize = (*global_px_vs_tof).congrid_xcoeff
    plots, xsize, pixel_device, /device, /continue, color=fsc_color('red'), $
      linestyle = 1
      
  endif else begin
  
    if (event.enter eq 0) then begin ;leaving the plot
      catch,/cancel ;comment out after debugging
      
      ;refresh the plot
      base = (*global_axis_plot)._base
      px_vs_tof_plot_counts_vs_yaxis, base=base
      
      putValue, base=info_base, 'px_vs_tof_cursor_info_y_value_uname', $
        'N/A'
      putValue, base=info_base, 'px_vs_tof_cursor_info_x_value_uname', $
        'N/A'
      putValue, base=info_base, 'px_vs_tof_cursor_info_z_value_uname', $
        'N/A'
        
      ;if there is already a selection, display the selection
      string_pixel_range_already_selected = getValue(base=info_base,$
        uname='px_vs_tof_cursor_info_y0y1_value_uname')
      pixel_range_already_selected = $
        strsplit(string_pixel_range_already_selected,'->',/extract)
      pixel_min_already_selected = $
        strcompress(pixel_range_already_selected[0],/remove_all)
      pixel_max_already_selected = $
        strcompress(pixel_range_already_selected[1],/remove_all)
        
      if (pixel_min_already_selected ne 'N/A') then begin
        pixel_min = float(pixel_min_already_selected)
        id = widget_info(event.top, $
          find_by_uname='px_vs_tof_counts_vs_yaxis_plot_uname')
        widget_control, id, get_value=plot_id
        wset, plot_id
        plots, pixel_min, ymin, /data
        plots, pixel_min, ymax, /data,/continue, color=fsc_color('red'), $
          linestyle=0
      endif
      
      if (pixel_max_already_selected ne 'N/A') then begin
        pixel_max = float(pixel_max_already_selected)
        id = widget_info(event.top, $
          find_by_uname='px_vs_tof_counts_vs_yaxis_plot_uname')
        widget_control, id, get_value=plot_id
        wset, plot_id
        plots, pixel_max, ymin, /data
        plots, pixel_max, ymax, /data,/continue, color=fsc_color('red'), $
          linestyle=0
      endif
      
      ;save in device units the TOF cursor position
      string_pixel_range_already_selected = getValue(base=info_base,$
        uname='px_vs_tof_cursor_info_y0y1_value_uname')
      pixel_range_already_selected = $
        strsplit(string_pixel_range_already_selected,'->',/extract)
      pixel_min_already_selected = $
        strcompress(pixel_range_already_selected[0],/remove_all)
      pixel_max_already_selected = $
        strcompress(pixel_range_already_selected[1],/remove_all)
        
      selection = (*global_px_vs_tof).draw_zoom_selection
      data_selection = (*global_px_vs_tof).draw_zoom_data_selection
      
      if (pixel_min_already_selected eq 'N/A') then begin
        selection[1] = -1
        data_selection[1] = -1
      endif else begin
        pixel_min = px_vs_tof_px_data_to_px_device(global_px_vs_tof, pixel=pixel_min)
        selection[1] = fix(pixel_min)
        data_selection[1] = fix(pixel_min_already_selected)
      endelse
      
      if (pixel_max_already_selected eq 'N/A') then begin
        data_selection[3] = -1
        selection[3] = -1
      endif else begin
        pixel_max = px_vs_tof_px_data_to_px_device(global_px_vs_tof, pixel=pixel_max)
        selection[3] = fix(pixel_max)
        data_selection[3] = fix(pixel_max_already_selected)
      endelse
      
      (*global_px_vs_tof).draw_zoom_selection = selection
      (*global_px_vs_tof).draw_zoom_data_selection = data_selection
      
      ;display the cursor position in the main plot
      px_vs_tof_refresh_plot, main_event
      px_vs_tof_refresh_plot_with_selection, main_event, recalculate=1
      
    endif
    
  endelse
  
  
;refresh the plot
  
  
;draw the dashed line
  
end