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

pro px_vs_tof_counts_vs_xaxis_draw_eventcb, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_axis_plot
  
  global_px_vs_tof = (*global_axis_plot).global
  info_base = (*global_px_vs_tof).cursor_info_base
  ymax = (*global_axis_plot).ymax
  main_event = (*global_axis_plot).main_event
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    
    ;refresh the plot
    base = (*global_axis_plot)._base
    px_vs_tof_plot_counts_vs_xaxis, base=base
    
    cursor, x, y, /data, /nowait
    xrange = (*global_axis_plot).xrange
    
    ;make sure we are in the range allowed
    if (x gt xrange[1]) then return
    if (x lt xrange[0]) then return
    
    plots, x, 0, /data
    plots, x, ymax, /data,/continue, color=fsc_color('blue'), linestyle=1
    
    ;display the current value in CURSOR LIVE base
    live_tof_value = x
    putValue, base=info_base, 'px_vs_tof_cursor_info_y_value_uname', $
      'N/A'
    putValue, base=info_base, 'px_vs_tof_cursor_info_x_value_uname', $
      strcompress(live_tof_value,/remove_all)
    putValue, base=info_base, 'px_vs_tof_cursor_info_z_value_uname', $
      'N/A'
      
    tof_data = x
    tof_device = px_vs_tof_data_to_device(global_px_vs_tof, tof=tof_data)
    
    id = widget_info(event.top, find_by_uname='px_vs_tof_counts_vs_xaxis_plot_uname')
    widget_control, id, GET_VALUE = plot_id
    wset, plot_id
    
    ;Mouse interaction with plot
    if (event.press eq 1 && $
      event.clicks eq 1) then begin ;user left clicked the mouse
      (*global_axis_plot).left_clicked = 1b
      plots, x, 0, /data
      plots, x, ymax, /data,/continue, color=fsc_color('green'), linestyle=2
      
      string_tof_range_already_selected = getValue(base=info_base,$
        uname='px_vs_tof_cursor_info_x0x1_value_uname')
      tof_range_already_selected = $
        strsplit(string_tof_range_already_selected,'->',/extract)
      new_tof_min_selected = 'N/A'
      tof_max_already_selected = $
        strcompress(tof_range_already_selected[1],/remove_all)
      string_tof_range_already_selected = new_tof_min_selected + ' -> ' + $
        tof_max_already_selected
      putValue, base=info_base, 'px_vs_tof_cursor_info_x0x1_value_uname', $
        string_tof_range_already_selected
    endif
    
    if (event.press eq 4 && $
      event.clicks eq 1) then begin ;user right clicked the mouse
      (*global_axis_plot).right_clicked = 1b
      plots, x, 0, /data
      plots, x, ymax, /data,/continue, color=fsc_color('green'), linestyle=2
      
      string_tof_range_already_selected = getValue(base=info_base,$
        uname='px_vs_tof_cursor_info_x0x1_value_uname')
      tof_range_already_selected = $
        strsplit(string_tof_range_already_selected,'->',/extract)
      new_tof_max_selected = 'N/A'
      tof_min_already_selected = $
        strcompress(tof_range_already_selected[0],/remove_all)
      string_tof_range_already_selected = tof_min_already_selected + ' -> ' + $
        new_tof_max_selected
      putValue, base=info_base, 'px_vs_tof_cursor_info_x0x1_value_uname', $
        string_tof_range_already_selected
    endif
    
    if (event.release eq 1) then begin ;left click button released
      (*global_axis_plot).left_clicked = 0b
      string_tof_range_already_selected = getValue(base=info_base,$
        uname='px_vs_tof_cursor_info_x0x1_value_uname')
      tof_range_already_selected = $
        strsplit(string_tof_range_already_selected,'->',/extract)
        
      x1 = strcompress(tof_range_already_selected[1],/remove_all)
      if (x1 eq 'N/A') then begin
        sxmin = strcompress(x,/remove_all)
        sxmax = 'N/A'
      endif else begin
        float_x0 = float(x)
        float_x1 = float(x1)
        xmin = min([float_x0,float_x1],max=xmax)
        sxmin = strcompress(xmin,/remove_all)
        sxmax = strcompress(xmax,/remove_all)
      endelse
      
      string_tof_range_already_selected = sxmin + ' -> ' + sxmax
      putValue, base=info_base, 'px_vs_tof_cursor_info_x0x1_value_uname', $
        string_tof_range_already_selected
    endif
    
    if (event.release eq 4) then begin ;right click released
      (*global_axis_plot).right_clicked = 0b
      string_tof_range_already_selected = getValue(base=info_base,$
        uname='px_vs_tof_cursor_info_x0x1_value_uname')
      tof_range_already_selected = $
        strsplit(string_tof_range_already_selected,'->',/extract)
        
      x0 = strcompress(tof_range_already_selected[0],/remove_all)
      if (x0 eq 'N/A') then begin
        sxmin = 'N/A'
        sxmax = strcompress(x,/remove_all)
      endif else begin
        float_x0 = float(x0)
        float_x1 = float(x)
        xmin = min([float_x0,float_x1],max=xmax)
        sxmin = strcompress(xmin,/remove_all)
        sxmax = strcompress(xmax,/remove_all)
      endelse
      
      string_tof_range_already_selected = sxmin + ' -> ' + sxmax
      putValue, base=info_base, 'px_vs_tof_cursor_info_x0x1_value_uname', $
        string_tof_range_already_selected
    endif
    
    ;moving the mouse with left button clicked
    if ((*global_axis_plot).left_clicked) then begin
      plots, x, 0, /data
      plots, x, ymax, /data,/continue, color=fsc_color('green'), linestyle=2
    endif
    
    ;moving the mouse with right button clicked
    if ((*global_axis_plot).right_clicked) then begin
      plots, x, 0, /data
      plots, x, ymax, /data,/continue, color=fsc_color('green'), linestyle=2
    endif
    
    ;if there is already a selection, display the selection
    string_tof_range_already_selected = getValue(base=info_base,$
      uname='px_vs_tof_cursor_info_x0x1_value_uname')
    tof_range_already_selected = $
      strsplit(string_tof_range_already_selected,'->',/extract)
    tof_min_already_selected = $
      strcompress(tof_range_already_selected[0],/remove_all)
    tof_max_already_selected = $
      strcompress(tof_range_already_selected[1],/remove_all)
      
    if (tof_min_already_selected ne 'N/A') then begin
      tof_min = float(tof_min_already_selected)
      plots, tof_min, 0, /data
      plots, tof_min, ymax, /data,/continue, color=fsc_color('blue'), $
        linestyle=0
    endif
    
    if (tof_max_already_selected ne 'N/A') then begin
      tof_max = float(tof_max_already_selected)
      plots, tof_max, 0, /data
      plots, tof_max, ymax, /data,/continue, color=fsc_color('blue'), $
        linestyle=0
    endif
    
    ;display the cursor position in the main plot
    px_vs_tof_refresh_plot, main_event
    
    plots, tof_device, 0, /device
    ysize = (*global_px_vs_tof).congrid_ycoeff
    plots, tof_device, ysize, /device, /continue, color=fsc_color('blue'), $
      linestyle = 1
      
  endif else begin
  
    if (event.enter eq 0) then begin ;leaving the plot
      catch,/cancel ;comment out after debugging
      
      ;refresh the plot
      base = (*global_axis_plot)._base
      px_vs_tof_plot_counts_vs_xaxis, base=base
      
      putValue, base=info_base, 'px_vs_tof_cursor_info_y_value_uname', $
        'N/A'
      putValue, base=info_base, 'px_vs_tof_cursor_info_x_value_uname', $
        'N/A'
      putValue, base=info_base, 'px_vs_tof_cursor_info_z_value_uname', $
        'N/A'
        
      ;if there is already a selection, display the selection
      string_tof_range_already_selected = getValue(base=info_base,$
        uname='px_vs_tof_cursor_info_x0x1_value_uname')
      tof_range_already_selected = $
        strsplit(string_tof_range_already_selected,'->',/extract)
      tof_min_already_selected = $
        strcompress(tof_range_already_selected[0],/remove_all)
      tof_max_already_selected = $
        strcompress(tof_range_already_selected[1],/remove_all)
        
      if (tof_min_already_selected ne 'N/A') then begin
        tof_min = float(tof_min_already_selected)
        plots, tof_min, 0, /data
        plots, tof_min, ymax, /data,/continue, color=fsc_color('blue'), $
          linestyle=0
      endif
      
      if (tof_max_already_selected ne 'N/A') then begin
        tof_max = float(tof_max_already_selected)
        plots, tof_max, 0, /data
        plots, tof_max, ymax, /data,/continue, color=fsc_color('blue'), $
          linestyle=0
      endif
      
      ;display the cursor position in the main plot
      px_vs_tof_refresh_plot, main_event
      
    endif
    
  endelse
  
  
;refresh the plot
  
  
;draw the dashed line
  
end
