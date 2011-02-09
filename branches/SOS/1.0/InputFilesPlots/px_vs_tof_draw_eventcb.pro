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
      
    ;         ;shift key has been released
    ;      if (event.key eq 1 && event.press eq 0) then begin
    ;        (*global_plot).shift_key_status = 0b
    ;        refresh_plot, event, recalculate=1
    ;        save_background, event=event
    ;      endif
      
    endif
    
    ;if x,y and counts base is on, shows live values of x,y and counts
    if (widget_info(info_base, /valid_id) ne 0) then begin
    
      ;keep the main widget_draw activated
      id = widget_info(event.top, find_by_uname='draw_px_vs_tof_input_files')
      widget_control, id, /input_focus
      
      x = px_vs_tof_retrieve_data_x_value(event)
      y = px_vs_tof_retrieve_data_y_value(event)
      z = long(px_vs_tof_retrieve_data_z_value(event))
      
      ;      if ((*global_px_vs_tof).shift_key_status) then begin ;shift is clicked
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
      
      x = strcompress(x,/remove_all)
      y = strcompress(y,/remove_all)
      z = strcompress(z,/remove_all)
      
      ;     endelse
      
      putValue, base=info_base, 'px_vs_tof_cursor_info_x_value_uname', x
      putValue, base=info_base, 'px_vs_tof_cursor_info_y_value_uname', y
      putValue, base=info_base, 'px_vs_tof_cursor_info_z_value_uname', z
      
    endif
    
    ;if counts vs tof 2d plot is available
    if (widget_info(counts_vs_xaxis_plot_id,/valid_id)) then begin
      display_cursor_line_on_2d_plot, event=event, xaxis='tof'
    endif
    
    ;if counts vs pixel 2d plot is available
    if (widget_info(counts_vs_yaxis_plot_id,/valid_id)) then begin
      display_cursor_line_on_2d_plot, event=event, xaxis='pixel'
    endif
    
    ;save the background to keep the first big Cross as part of the background
    if (event.press eq 1 && event.key eq 1) then begin
      save_background, event=event
    endif
    
;    ;right click validated only if there is at least one of the infos base
;    if ((widget_info(counts_vs_xaxis_plot_id,/valid_id) ne 0) || $
;      (widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0)) then begin
;      
;;      if (event.press eq 4) then begin ;right click
;;      
;;        x=event.x
;;        y=event.y
;;        id = widget_info(event.top, find_by_uname='draw_px_vs_tof_input_files')
;;        geometry = widget_info(id,/geometry)
;;        xsize = geometry.xsize
;;        ysize = geometry.ysize
;;        
;;        widget_control, id, GET_VALUE = plot_id
;;        wset, plot_id
;;        
;;        off = 20
;;        
;;        plots, x, 0, /device
;;        plots, x, y-off, /device, /continue, color=fsc_color('red')
;;        plots, x, y+off, /device
;;        plots, x, ysize, /device, /continue, color=fsc_color('red')
;;        
;;        plots, 0, y, /device
;;        plots, x-off, y, /device, /continue, color=fsc_color('red')
;;        plots, x+off, y, /device
;;        plots, xsize, y, /device, /continue, color=fsc_color('red')
;;        
;;        default_base_file_name = create_default_base_file_name(event)
;;        
;;        validate_qx_base = widget_info(counts_vs_xaxis_plot_id,/valid_id)
;;        validate_qz_base = widget_info(counts_vs_yaxis_plot_id,/valid_id)
;;        
;;        output_info_base, event=event, $
;;          parent_base_uname = 'final_plot_base', $
;;          output_folder = (*global_plot).output_folder, $
;;          default_base_file = default_base_file_name, $
;;          validate_qx_base = validate_qx_base, $
;;          validate_qz_base = validate_qz_base, $
;;          counts_vs_qz_lin = (*global_plot).counts_vs_qz_lin, $
;;          counts_vs_qx_lin = (*global_plot).counts_vs_qx_lin
;;          
;;        return
;;      endif
;      
;    endif
    
    draw_zoom_selection = (*global_px_vs_tof).draw_zoom_selection
    
    if ((*global_px_vs_tof).left_click) then begin ;moving mouse with left click
      x1 = event.x
      y1 = event.y
      draw_zoom_selection[2] = x1
      draw_zoom_selection[3] = y1
      (*global_px_vs_tof).draw_zoom_selection = draw_zoom_selection
      refresh_zoom_px_vs_tof_selection, event
    endif
    
    if (event.press eq 1 && $
      event.clicks eq 1) then begin ;user left clicked the mouse
      
      px_vs_tof_refresh_plot, event, recalculate=1
      save_px_vs_tof_background, event=event
      
      ;;      if ((*global_plot).shift_key_status) then begin
      ;;        (*global_plot).shift_key_status = 0b
      ;;        refresh_plot, event, recalculate=1
      ;;        save_background, event=event
      ;;      endif
      ;
      (*global_px_vs_tof).left_click = 1b
      x0 = event.x
      y0 = event.y
      draw_zoom_selection[0] = x0
      draw_zoom_selection[1] = y0
      (*global_px_vs_tof).draw_zoom_selection = draw_zoom_selection
    endif
    
    if (event.release eq 1 && $
      (*global_px_vs_tof).left_click && $
      event.key ne 1) then begin ;user release left clicked
      (*global_px_vs_tof).left_click = 0b
      x1 = event.x
      y1 = event.y
      
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
      ;check that user selected a box,not only 1 pixel
      result = is_real_px_vs_tof_selection(event, x1, y1)
      if (result eq 0) then return
      
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
      
    ;          ;catch, error
    ;          error = 0
    ;          if (error ne 0) then begin
    ;            catch,/cancel
    ;          endif else begin
    ;            zoom_selection, event
    ;          endelse
      
    ;      refresh_plot, event
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
        
    ;      if ((*global_px_vs_tof).shift_key_status) then begin ;shift is clicked
    ;
    ;        QxQzrangeEvent = (*global_px_vs_tof).EventRangeSelection
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
      endif
      
      ;counts vs yaxis (pixel or angle)
      counts_vs_yaxis_plot_id = (*global_px_vs_tof).counts_vs_yaxis_base
      if (widget_info(counts_vs_yaxis_plot_id,/valid_id) ne 0) then begin
        px_vs_tof_plot_counts_vs_yaxis, base=counts_vs_yaxis_plot_id
      endif
      
    endif
    
  endelse
  
end
