pro px_vs_tof_counts_vs_yaxis_draw_eventcb, event
compile_opt idl2

   global_px_vs_tof = (*global_axis_plot).global
      info_base = (*global_px_vs_tof).cursor_info_base
      
      catch, error
      if (error ne 0) then begin
        catch,/cancel
        
        ;refresh the plot
        base = (*global_axis_plot)._base
        px_vs_tof_plot_counts_vs_yaxis, base=base
        
        cursor, x, y, /data, /nowait
        xrange = (*global_axis_plot).xrange
        ymax = (*global_axis_plot).ymax
        
        ;make sure we are in the range allowed
        if (x gt xrange[1]) then return
        if (x lt xrange[0]) then return
        
        plots, x, 0, /data
        plots, x, ymax, /data,/continue, color=fsc_color('red'), linestyle=1
        
        ;display the current value in CURSOR LIVE base
        live_pixel_value = x
        global_px_vs_tof = (*global_axis_plot).global
        info_base = (*global_px_vs_tof).cursor_info_base
        putValue, base=info_base, 'px_vs_tof_cursor_info_y_value_uname', $
          strcompress(fix(live_pixel_value),/remove_all)
        putValue, base=info_base, 'px_vs_tof_cursor_info_x_value_uname', $
          'N/A'
        putValue, base=info_base, 'px_vs_tof_cursor_info_z_value_uname', $
          'N/A'
          
      endif else begin
      
        if (event.enter eq 0) then begin ;leaving the plot
          catch,/cancel ;comment out after debugging
          
          ;refresh the plot
          base = (*global_axis_plot)._base
          px_vs_tof_plot_counts_vs_yaxis, base=base
          
          global_px_vs_tof = (*global_axis_plot).global
          info_base = (*global_px_vs_tof).cursor_info_base
          putValue, base=info_base, 'px_vs_tof_cursor_info_y_value_uname', $
            'N/A'
          putValue, base=info_base, 'px_vs_tof_cursor_info_x_value_uname', $
            'N/A'
          putValue, base=info_base, 'px_vs_tof_cursor_info_z_value_uname', $
            'N/A'
            
        endif
        
      endelse
      
      
    ;refresh the plot
      
      
    ;draw the dashed line
      
      end