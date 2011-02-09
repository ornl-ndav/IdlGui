pro px_vs_tof_counts_vs_xaxis_draw_eventcb, event
compile_opt idl2

     global_px_vs_tof = (*global_axis_plot).global
      info_base = (*global_px_vs_tof).cursor_info_base
      
      catch, error
      if (error ne 0) then begin
        catch,/cancel
        
        ;refresh the plot
        base = (*global_axis_plot)._base
        px_vs_tof_plot_counts_vs_xaxis, base=base
        
        ymax = (*global_axis_plot).ymax
        
        ;if there is already a selection, display the selection
        string_tof_range_already_selected = getValue(base=info_base,$
          uname='px_vs_tof_cursor_info_x0x1_value_uname')
        tof_range_already_selected = strsplit(string_tof_range_already_selected,'->',/extract)
        tof_min_already_selected = strcompress(tof_range_already_selected[0],/remove_all)
        tof_max_already_selected = strcompress(tof_range_already_selected[1],/remove_all)
        
        if (tof_min_already_selected ne 'N/A') then begin
          tof_min = float(tof_min_already_selected)
          plots, tof_min, 0, /data
          plots, tof_min, ymax, /data,/continue, color=fsc_color('blue'), linestyle=0
        endif
        
        if (tof_max_already_selected ne 'N/A') then begin
          tof_max = float(tof_max_already_selected)
          plots, tof_max, 0, /data
          plots, tof_max, ymax, /data,/continue, color=fsc_color('blue'), linestyle=0
        endif
        
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
            
          ymax = (*global_axis_plot).ymax
          
          ;if there is already a selection, display the selection
          string_tof_range_already_selected = getValue(base=info_base,$
            uname='px_vs_tof_cursor_info_x0x1_value_uname')
          tof_range_already_selected = strsplit(string_tof_range_already_selected,'->',/extract)
          tof_min_already_selected = strcompress(tof_range_already_selected[0],/remove_all)
          tof_max_already_selected = strcompress(tof_range_already_selected[1],/remove_all)
          
          if (tof_min_already_selected ne 'N/A') then begin
            tof_min = float(tof_min_already_selected)
            plots, tof_min, 0, /data
            plots, tof_min, ymax, /data,/continue, color=fsc_color('blue'), linestyle=0
          endif
          
          if (tof_max_already_selected ne 'N/A') then begin
            tof_max = float(tof_max_already_selected)
            plots, tof_max, 0, /data
            plots, tof_max, ymax, /data,/continue, color=fsc_color('blue'), linestyle=0
          endif
          
        endif
        
      endelse
      
      
    ;refresh the plot
      
      
    ;draw the dashed line
    
    end
      