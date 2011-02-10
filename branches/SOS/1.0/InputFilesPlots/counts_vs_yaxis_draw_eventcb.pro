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
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    
    ;refresh the plot
    base = (*global_axis_plot)._base
    px_vs_tof_plot_counts_vs_yaxis, base=base
    
    ;if there is already a selection, display the selection
    string_pixel_range_already_selected = getValue(base=info_base, $
      uname='px_vs_tof_cursor_info_y0y1_value_uname')
    pixel_range_already_selected = $
      strsplit(string_pixel_range_already_selected,'->',/extract)
    pixel_min_already_selected = $
      strcompress(pixel_range_already_selected[0],/remove_all)
    pixel_max_already_selected = $
      strcompress(pixel_range_already_selected[1],/remove_all)
      
    if (pixel_min_already_selected ne 'N/A') then begin
      pixel_min = fix(pixel_min_already_selected)
      plots, pixel_min, 0, /data
      plots, pixel_min, ymax, /data, /continue, color=fsc_color('red'), $
        linestyle=0
    endif
    
    if (pixel_max_already_selected ne 'N/A') then begin
      pixel_max = fix(pixel_max_already_selected)
      plots, pixel_max, 0, /data
      plots, pixel_max, ymax, /data, /continue, color=fsc_color('red'), $
        linestyle=0
    endif
    
    cursor, x, y, /data, /nowait
    xrange = (*global_axis_plot).xrange
    
    ;make sure we are in the range allowed
    if (x gt xrange[1]) then return
    if (x lt xrange[0]) then return
    
    plots, x, 0, /data
    plots, x, ymax, /data,/continue, color=fsc_color('red'), linestyle=1
    
    ;display the current value in CURSOR LIVE base
    live_pixel_value = x
    putValue, base=info_base, 'px_vs_tof_cursor_info_y_value_uname', $
      strcompress(fix(live_pixel_value),/remove_all)
    putValue, base=info_base, 'px_vs_tof_cursor_info_x_value_uname', $
      'N/A'
    putValue, base=info_base, 'px_vs_tof_cursor_info_z_value_uname', $
      'N/A'
      
      
      
    ;display the cursor position in the main plot
    px_vs_tof_refresh_plot, main_event
    
    pixel_data = x
    pixel_device = px_vs_tof_data_to_device(global_px_vs_tof, pixel=pixel_data)
    
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
      string_pixel_range_already_selected = getValue(base=info_base, $
        uname='px_vs_tof_cursor_info_y0y1_value_uname')
      pixel_range_already_selected = $
        strsplit(string_pixel_range_already_selected,'->',/extract)
      pixel_min_already_selected = $
        strcompress(pixel_range_already_selected[0],/remove_all)
      pixel_max_already_selected = $
        strcompress(pixel_range_already_selected[1],/remove_all)
        
      if (pixel_min_already_selected ne 'N/A') then begin
        pixel_min = fix(pixel_min_already_selected)
        plots, pixel_min, 0, /data
        plots, pixel_min, ymax, /data, /continue, color=fsc_color('red'), $
          linestyle=0
      endif
      
      if (pixel_max_already_selected ne 'N/A') then begin
        pixel_max = fix(pixel_max_already_selected)
        plots, pixel_max, 0, /data
        plots, pixel_max, ymax, /data, /continue, color=fsc_color('red'), $
          linestyle=0
      endif
      
      ;display the cursor position in the main plot
      px_vs_tof_refresh_plot, main_event
      
    endif
    
  endelse
  
  
;refresh the plot
  
  
;draw the dashed line
  
end