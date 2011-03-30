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
;   main base event
;
; :Params:
;   Event
;
; :Author: j35
;-
pro data_background_selection_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_pixel_selection
  main_event = (*global_pixel_selection).main_event
  
  case Event.id of
  
    ;scale draw
    widget_info(event.top, find_by_uname='pixel_selection_scale'): begin
    
      ;interact with plot only if tof range tool base is mapped
      id_tof = (*global_pixel_selection).tof_range_selection_base
      if (widget_info(id_tof,/valid_id) ne 0) then begin
      
        if (event.type eq 0) then begin
          if (event.press eq 1) then begin ;left button pressed
            (*global_pixel_selection).scale_mouse_left_pressed = 1b
            data_background_save_scale_device_value, event
            data_background_display_scale_tof_range, event=event
          endif
          if (event.press eq 4) then begin ;right button pressed
            (*global_pixel_selection).scale_mouse_right_pressed = 1b
            if ((*global_pixel_selection).tof_range_status eq 'left') then begin
              (*global_pixel_selection).tof_range_status = 'right'
            endif else begin
              (*global_pixel_selection).tof_range_status = 'left'
            endelse
          endif
        endif ;end of button pressed
        
        if (event.type eq 1) then begin ;button released
          if ((*global_pixel_selection).scale_mouse_left_pressed) then begin ;left
            (*global_pixel_selection).scale_mouse_left_pressed = 0b
            data_background_save_scale_device_value, event
            data_background_display_scale_tof_range, event=event
          endif else begin ;right
            (*global_pixel_selection).scale_mouse_right_pressed = 0b
          endelse
        endif
        
        if (event.type eq 2) then begin ;moving mouse
          if ((*global_pixel_selection).scale_mouse_left_pressed) then begin
            data_background_save_scale_device_value, event
            data_background_display_scale_tof_range, event=event
          endif
        endif
        
      endif
      
    end
    
    ;main draw
    widget_info(event.top, find_by_uname='pixel_selection_draw'): begin
    
      catch, error
      if (error ne 0) then begin ;selection
        catch,/cancel
        
        cursor_info_base = (*global_pixel_selection).cursor_info_base
        if (widget_info(cursor_info_base,/valid_id) ne 0) then begin
          show_pixel_selection_cursor_info, event
        endif
        
        if (event.press eq 1) then begin ;left click
        
          show_pixel_selection_input_base, event
          show_pixel_selection_counts_vs_pixel_base, event
          
          ;left click activated
          (*global_pixel_selection).left_click = 1b
          
          pixel_value = strcompress(retrieve_pixel_value(event),/remove_all)
          if ((*global_pixel_selection).pixel1_selected) then begin
            uname = 'pixel_selection_pixel1_uname'
          endif else begin
            uname = 'pixel_selection_pixel2_uname'
          endelse
          
          check_pixel_value, pixel_value, global_pixel_selection
          if (pixel_value eq -1) then pixel_value = ''
          putValue, base=(*global_pixel_selection).pixel_selection_input_base, $
            uname, $
            pixel_value
          save_pixel_data, event=event
          display_pixel_selection, event=event
          
          ;display counts_vs_pixel with selection
          plot_base = $
            (*global_pixel_selection).roi_selection_counts_vs_pixel_base_id
          if (widget_info(plot_base, /valid_id) ne 0) then begin
            data_background_display_counts_vs_pixel, $
              base=$
              (*global_pixel_selection).roi_selection_counts_vs_pixel_base_id, $
              global_pixel_selection
          endif
          
        endif
        
        ;release button
        if (event.release eq 1 && $
          (*global_pixel_selection).left_click eq 1b) then begin
          (*global_pixel_selection).left_click = 0b
        endif
        
        ;right click
        if (event.press eq 4) then begin
          if ((*global_pixel_selection).pixel1_selected) then begin
            (*global_pixel_selection).pixel1_selected = 0b
          endif else begin
            (*global_pixel_selection).pixel1_selected = 1b
          endelse
          display_pixel_selection, event=event
          
          ;display counts_vs_pixel with selection
          plot_base = $
            (*global_pixel_selection).roi_selection_counts_vs_pixel_base_id
          if (widget_info(plot_base, /valid_id) ne 0) then begin
            data_background_display_counts_vs_pixel, $
              base=$
              (*global_pixel_selection).roi_selection_counts_vs_pixel_base_id, $
              global_pixel_selection
          endif
          
        endif
        
        ;moving mouse with left click pressed
        if ((*global_pixel_selection).left_click) then begin
          pixel_value = strcompress(retrieve_pixel_value(event),/remove_all)
          if ((*global_pixel_selection).pixel1_selected) then begin
            uname = 'pixel_selection_pixel1_uname'
          endif else begin
            uname = 'pixel_selection_pixel2_uname'
          endelse
          check_pixel_value, pixel_value, global_pixel_selection
          if (pixel_value eq -1) then pixel_value = ''
          putValue, base=(*global_pixel_selection).pixel_selection_input_base, $
            uname, $
            pixel_value
          save_pixel_data, event=event
          display_pixel_selection, event=event
          
          ;display counts_vs_tof with selection
          plot_base = $
            (*global_pixel_selection).roi_selection_counts_vs_pixel_base_id
          if (widget_info(plot_base, /valid_id) ne 0) then begin
            data_background_display_counts_vs_pixel, $
              base=plot_base, $
              global_pixel_selection
          endif
          
        endif
        
      endif else begin ;entering or leaving widget_draw
      
        if (event.enter eq 0) then begin ;leaving plot
          cursor_info_base = (*global_pixel_selection).cursor_info_base
          if (widget_info(cursor_info_base,/valid_id) ne 0) then begin
            base = (*global_pixel_selection).cursor_info_base
            putValue, base=base, 'cursor_info_tof', 'N/A'
            putValue, base=base, 'cursor_info_pixel', 'N/A'
            putValue, base=base, 'cursor_info_counts', 'N/A'
          endif
        endif else begin ;entering plot
        
        endelse
      endelse
      
    end
    
    ;TOF scale
    widget_info(event.top, find_by_uname='pixel_selection_scale'): begin
    
      if (event.type eq 0) then begin
        if (event.press eq 1) then begin ;left button pressed
          (*global_pixel_selection).scale_mouse_left_pressed = 1b
        endif
        if (event.press eq 4) then begin ;rigth button pressed
          (*global_pixel_selection).scale_mouse_right_pressed = 1b
          ;switch working tof
          if ((*global_pixel_selection).tof_range_status eq 'left') then begin
            (*global_pixel_selection).tof_range_status='right'
          endif else begin
            (*global_pixel_selection).tof_range_status='left'
          endelse
        endif
      endif ;end of button pressed
      
      if (event.type eq 1) then begin ;button released
        if ((*global_pixel_selection).scale_mouse_left_pressed) then begin ;left
          (*global_pixel_selection).scale_mouse_left_pressed = 0b
          
        endif else begin
          (*global_pixel_selection).scale_mouse_right_pressed = 0b
        endelse
      endif
      
      if (event.type eq 2) then begin ;moving mouse
        if ((*global_pixel_selection).scale_mouse_left_pressed) then begin
        
        endif
      endif
      
    end
    
    ;main base
    widget_info(event.top, find_by_uname='pixel_selection_base_uname'): begin
    
      id = widget_info(event.top, find_by_uname='pixel_selection_base_uname')
      geometry = widget_info(id,/geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      xoffset = geometry.xoffset
      yoffset = geometry.yoffset
      
      ;only if the tof input base is there
      id_pixel_selection = (*global_pixel_selection).pixel_selection_input_base
      if (widget_info(id_pixel_selection, /valid_id) ne 0) then begin
        widget_control, id_pixel_selection, xoffset = xoffset + new_xsize
        widget_control, id_pixel_selection, yoffset = yoffset
      endif
      
      ;only if the TOF range selection base is there
      id_tof_selection = (*global_pixel_selection).tof_range_selection_base
      if (widget_info(id_tof_selection,/valid_id) ne 0) then begin
        widget_control, id_tof_selection, xoffset = xoffset
        widget_control, id_tof_selection, yoffset = yoffset + new_ysize
      endif
      
      if ((abs((*global_pixel_selection).xsize - new_xsize) eq 70.0) && $
        abs((*global_pixel_selection).ysize - new_ysize) eq 33.0) then return
        
      if ((abs((*global_pixel_selection).xsize - new_xsize) eq 0.0) && $
        abs((*global_pixel_selection).ysize - new_ysize) eq 33.0) then return
        
      (*global_pixel_selection).xsize = new_xsize
      (*global_pixel_selection).ysize = new_ysize
      
      widget_control, id, xsize = new_xsize
      widget_control, id, ysize = new_ysize
      
      border = (*global_pixel_selection).border
      colorbar_xsize = (*global_pixel_selection).colorbar_xsize
      
      id = widget_info(event.top, find_by_uname='pixel_selection_draw')
      widget_control, id, draw_xsize = new_xsize-2*border-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize-2*border
      
      id = widget_info(event.top,find_by_Uname='pixel_selection_scale')
      widget_control, id, draw_xsize = new_xsize-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize
      
      id = widget_info(event.top, find_by_uname='pixel_selection_colorbar')
      widget_control, id, xoffset=new_xsize-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize
      widget_control, id, draw_xsize = colorbar_xsize
      
      ;plot_pixel_selection_beam_center_scale, event=event
      data_background_display_scale_tof_range, event=event
      refresh_pixel_selection_plot, event, recalculate=1
      refresh_plot_pixel_selection_colorbar, event
      display_pixel_selection, event=event
      
      return
    end
    
    widget_info(event.top, $
      find_by_uname='settings_base_close_button'): begin
      
      ;this will allow the settings tab to come back in the same state
      ;save_status_of_settings_button, event
      
      id = widget_info(Event.top, $
        find_by_uname='settings_widget_base')
      widget_control, id, /destroy
      
      return
    end
    
    ;show the cursor info base
    widget_info(event.top, $
      find_by_uname='show_pixel_cursor_base'): begin
      cursor_info_base = (*global_pixel_selection).cursor_info_base
      if (widget_info(cursor_info_base,/valid_id) eq 0) then begin
        cursor_info_base, top_base=(*global_pixel_selection).top_base, $
          parent_base_uname = 'pixel_selection_base_uname', $
          event=event
      endif
      
    end
    
    widget_info(event.top, $
      find_by_uname='show_pixel_selection_base'): begin
      pixel_base = (*global_pixel_selection).pixel_selection_input_base
      if (widget_info(pixel_base, /valid_id) eq 0) then begin
        pixel_selection_input_base, $
          parent_base_uname='pixel_selection_base_uname', $
          top_base = (*global_pixel_selection).top_base, $
          event=event
      endif
    end
    
    ;show counts vs tof base
    widget_info(event.top, $
      find_by_uname='show_counts_vs_pixel_base'): begin
      plot_base = $
        (*global_pixel_selection).roi_selection_counts_vs_pixel_base_id
      if (widget_info(plot_base, /valid_id) eq 0) then begin
        data_background_counts_vs_pixel_base, $
          parent_base_uname='pixel_selection_base_uname', $
          top_base = (*global_pixel_selection).top_base, $
          event=event
      endif
    end
    
    ;show TOF range selection base
    widget_info(event.top, $
      find_by_uname='show_tof_range_selection_base'): begin
      tof_base = (*global_pixel_selection).tof_range_selection_base
      if (widget_info(tof_base,/valid_id) eq 0) then begin
        data_background_tof_range_selection_base, event=event, $
          top_base=(*global_pixel_selection).top_base, $
          parent_base_uname = 'pixel_selection_base_uname'
        data_background_display_scale_tof_range, event=event
      endif
    end
    
    else:
    
  endcase
  
end

pro data_background_save_scale_device_value, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_pixel_selection
  
  tof_device_data = (*global_pixel_selection).tof_device_data
  tof_range_status = (*global_pixel_selection).tof_range_status
  
  x_device = event.x
  if ((*global_pixel_selection).tof_range_status eq 'left') then begin
    index = 0
  endif else begin
    index = 1
  endelse
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='pixel_selection_scale')
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = geometry.xsize
  id_draw = WIDGET_INFO(Event.top, FIND_BY_UNAME='pixel_selection_draw')
  geometry = WIDGET_INFO(id_draw,/GEOMETRY)
  xoffset = geometry.xoffset
  
  ;make sure we stay in the range of tof
  if (x_device le xoffset) then x_device=xoffset
  if (x_device ge xsize-xoffset) then x_device=xsize-xoffset
  
  tof_device_data[0,index] = x_device
  x_data = data_background_getTOFDataFromDevice(event,$
    x_device,$
    (*global_pixel_selection).tof_range_status)
  tof_device_data[1,index] = x_data
  
  (*global_pixel_selection).tof_device_data = tof_device_data
  
end

;+
; :Description:
;    Bring to life the pixel input base
;
; :Params:
;    event
;
; :Author: j35
;-
pro show_pixel_selection_input_base, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_pixel_selection
  
  _base = (*global_pixel_selection).pixel_selection_input_base
  if (widget_info(_base, /valid_id) eq 0) then begin
    pixel_selection_input_base, $
      parent_base_uname='pixel_selection_base_uname', $
      top_base = (*global_pixel_selection).top_base, $
      event=event
  endif
  
end

;+
; :Description:
;    Bring to life the counts vs pixel base
;
; :Params:
;    event
;
; :Author: j35
;-
pro show_pixel_selection_counts_vs_pixel_base, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_pixel_selection
  
  plot_base = (*global_pixel_selection).roi_selection_counts_vs_pixel_base_id
  if (widget_info(plot_base, /valid_id) eq 0) then begin
    data_background_counts_vs_pixel_base, $
      parent_base_uname='pixel_selection_base_uname', $
      top_base = (*global_pixel_selection).top_base, $
      event=event
  endif
  
end

;+
; :Description:
;    Make sure that the data defined is within the range allowed
;
; :Keywords:
;    event
;    data
;
; :Author: j35
;-
function y_data_checked, event=event, base=base, data=data
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_refpix
  endif else begin
    widget_control, base, get_uvalue=global_refpix
  endelse
  
  xrange = (*global_refpix).xrange
  xmin = min(xrange,max=xmax)
  
  if (data lt xmin || data gt xmax) then return, 'N/A'
  return, data
  
end

;+
; :Description:
;    Save the pixel1 and 2 in data coordinates
;
; :Params:
;    event
;
; :Author: j35
;-
pro save_pixel_data, event=event, base=base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_pixel_selection
  endif else begin
    widget_control, base, get_uvalue=global_pixel_selection
  endelse
  
  pixel_selection_input_base = $
    (*global_pixel_selection).pixel_selection_input_base
    
  pixel1 = getValue(base=pixel_selection_input_base, $
    uname='pixel_selection_pixel1_uname')
  pixel2 = getValue(base=pixel_selection_input_base, $
    uname='pixel_selection_pixel2_uname')
    
  pixel1 = (pixel1 eq '') ? -1 : pixel1
  pixel2 = (pixel2 eq '') ? -1 : pixel2
  
  pixel_min_max = [pixel1, pixel2]
  
  (*global_pixel_selection).pixel_selection = pixel_min_max
  
end

;+
; :Description:
;    Go from data to device
;
; :Params:
;    data
;
; :Author: j35
;-
function from_data_to_device, event=event, base=base, ydata
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_pixel_selection
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='pixel_selection_draw')
  endif else begin
    widget_control, base, get_uvalue=global_pixel_selection
    id = WIDGET_INFO(base, FIND_BY_UNAME='pixel_selection_draw')
  endelse
  
  geometry = WIDGET_INFO(id,/GEOMETRY)
  ysize = geometry.ysize
  yrange = (*global_pixel_selection).yrange
  
  ratio = float(ysize) / (float(yrange[1]) - float(yrange[0]))
  ydevice = ratio * (float(ydata) - float(yrange[0]))
  
  return, ydevice
  
end

;+
; :Description:
;    refresh the background and display the two pixels min and max
;
; :Keywords:
;    event
;    base
;    recalculate
;
; :Author: j35
;-
pro display_pixel_selection, event=event, base=base, recalculate=recalculate
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_pixel_selection
    id = widget_info(event.top, find_by_uname='pixel_selection_draw')
  endif else begin
    widget_control, base, get_uvalue=global_pixel_selection
    id = widget_info(base, find_by_uname='pixel_selection_draw')
  endelse
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  if (keyword_set(recalculate)) then begin
  
  
  
  
  
  
  
  
  
  
  endif else begin
  
    TV, (*(*global_pixel_selection).background), true=3
    
  endelse
  
  pixel_selection = (*global_pixel_selection).pixel_selection
  
  pixel_min = pixel_selection[0]
  pixel_max = pixel_selection[1]
  
  pixel_min_device = from_data_to_device(event=event, base=base, pixel_min)
  pixel_max_device = from_data_to_device(event=event, base=base, pixel_max)
  
  xsize = (*global_pixel_selection).xsize
  
  if (pixel_min_device ne -1) then begin
  
    plots, 0, pixel_min_device, fsc_color("green"),/device
    plots, xsize, pixel_min_device, fsc_color("green"),/continue, linestyle=4,$
      /device
      
  endif
  
  if (pixel_max_device ne -1) then begin
  
    plots, 0, pixel_max_device, fsc_color("green"),/device
    plots, xsize, pixel_max_device, fsc_color("green"),/continue, linestyle=4,$
      /device
      
  endif
  
  if ((*global_pixel_selection).pixel1_selected) then begin
    pixel_device = pixel_min_device
  endif else begin
    pixel_device = pixel_max_device
  endelse
  
  ;retrieve geometry of refpix draw
  geometry = widget_info(id,/geometry)
  draw_ysize = geometry.scr_ysize
  to_ysize = (draw_ysize/100.)*2.
  from_pixel = pixel_device - 10
  to_pixel = pixel_device + 10
  
  plots,    [0, 0, 0, to_ysize, 0], $
    [from_pixel, pixel_device, to_pixel, pixel_device, from_pixel], $
    /device, $
    linestyle = 0,$
    color = fsc_color("red")
    
end

;+
; :Description:
;    display the refpix line only (reached by the refpix input value)
;    when the user manually input the refpix
;
; :Keywords:
;    base
;
; :Author: j35
;-
pro display_refpix_user_input_value, base=base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_refpix
    id = widget_info(event.top, find_by_uname='refpix_draw')
  endif else begin
    widget_control, base, get_uvalue=global_refpix
    id = widget_info(base, find_by_uname='refpix_draw')
    widget_control, id, GET_VALUE = plot_id
  endelse
  
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  TV, (*(*global_refpix).background), true=3
  
  refpix_input_base = (*global_refpix).refpix_input_base
  refpix_data = getValue(base=refpix_input_base, uname='refpix_value_uname')
  refpix_device = from_device_to_data(base=base, refpix_data)
  xsize = (*global_refpix).xsize
  plots, [0, 0, xsize, xsize, 0],$
    [refpix_device, refpix_device, refpix_device, refpix_device, $
    refpix_device],$
    /DEVICE,$
    LINESTYLE = 2,$
    COLOR = fsc_color("purple")
    
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
function retrieve_tof_value, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_refpix
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, 'N/A'
  endif
  
  x_device = event.x
  congrid_xcoeff = (*global_refpix).congrid_xcoeff
  xrange = float((*global_refpix).xrange) ;min and max tof
  
  rat = float(x_device) / float(congrid_xcoeff)
  x_data = float(rat * (xrange[1] - xrange[0]) + xrange[0])
  
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
function retrieve_pixel_value, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_tof_selection
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, 'N/A'
  endif
  
  y_device = event.y
  congrid_ycoeff = (*global_tof_selection).congrid_ycoeff
  yrange = float((*global_tof_selection).yrange) ;min and max pixels
  
  rat = float(y_device) / float(congrid_ycoeff)
  y_data = float(rat * (yrange[1] - yrange[0]) + yrange[0])
  
  return, fix(y_data)
  
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
function retrieve_counts_value, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_refpix
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, 'N/A'
  endif
  
  data = (*(*global_refpix).data_linear) ;ex: [51,304] 51->tof, 304->pixels
  
  xdata_max = (size(data))[1]
  ydata_max = (size(data))[2]
  
  congrid_xcoeff = (*global_refpix).congrid_xcoeff
  congrid_ycoeff = (*global_refpix).congrid_ycoeff
  
  xdata = fix(float(event.x) * float(xdata_max) / congrid_xcoeff)
  ydata = fix(float(event.y) * float(ydata_max) / congrid_ycoeff)
  
  _data = data[xdata,ydata]
  
  return, long(_data)
  
end

;+
; :Description:
;    This routine will retrieve the x(tof), y(pixel) and z(counts) infos
;    of the current cursor position and will display them in the cursor base
;
; :Params:
;    event
;
; :Author: j35
;-
pro show_pixel_selection_cursor_info, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_pixel_selection
  
  tof_value = strcompress(retrieve_tof_value(event),/remove_all)
  pixel_value = strcompress(retrieve_pixel_value(event),/remove_all)
  counts_value = strcompress(retrieve_counts_value(event),/remove_all)
  
  base = (*global_pixel_selection).cursor_info_base
  putValue, base=base, 'cursor_info_tof', tof_value
  putValue, base=base, 'cursor_info_pixel', pixel_value
  putValue, base=base, 'cursor_info_counts', counts_value
  
end

;+
; :Description:
;    save the background image to be able
;    to replot it quicker
;
;  use the following to display it:
;   TV, (*(*global).background), true=3
;
; :Params:
;    event
;
; :Keywords:
;    main_base
;
; :Author: j35
;-
pro save_pixel_selection_background,  event=event, main_base=main_base, $
    uname=uname
  compile_opt idl2
  
  if (~keyword_set(uname)) then uname = 'pixel_selection_draw'
  
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME=uname)
    widget_control, main_base, get_uvalue=global_pixel_selection
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, event.top, GET_UVALUE=global_pixel_selection
    id = WIDGET_INFO(Event.top,find_by_uname=uname)
  ENDELSE
  
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize   = geometry.xsize
  ysize   = geometry.ysize
  
  DEVICE, copy =[0, 0, xsize, ysize, 0, 0]
  
  (*(*global_pixel_selection).background) = background
  
END

;+
; :Description:
;    Switch linear/log plot
;
; :Keywords:
;    event
;    base
;    init
;
; :Author: j35
;-
pro pixel_selection_lin_log_data, event=event, base=base, init=init
  compile_opt idl2
  
  ;get global structure
  if (n_elements(event) ne 0) then begin
    widget_control,event.top,get_uvalue=global_pixel_selection
  endif else begin
    widget_control, base, get_uvalue=global_pixel_selection
  endelse
  
  Data = (*(*global_pixel_selection).data_linear)
  ;0 for lin, 1 for log
  scale_setting = (*global_pixel_selection).default_scale_settings
  
  if (keyword_set(init)) then begin
  
    Data = (*(*global_pixel_selection).data_linear)
    ;remove 0 values and replace with NAN
    ;and calculate log
    index = where(Data eq 0, nbr)
    if (nbr GT 0) then begin
      Data[index] = !VALUES.D_NAN
    endif
    Data = ALOG10(Data)
    Data = BYTSCL(Data,/NAN)
    
    (*(*global_pixel_selection).data_log) = data
    
  endif

  if (scale_setting eq 1) then begin ;log
    data = (*(*global_pixel_selection).data_log)
  endif
  
  (*(*global_pixel_selection).data) = Data
  
end

;+
; :Description:
;    refresh the 2d plot
;
; :Params:
;    event
;    
; :Keywords:
;   base
;   recalculate
;
; :Author: j35
;-
pro refresh_pixel_selection_plot, event, base=base, recalculate=recalculate
  compile_opt idl2
  
  ;get global structure
  if (~keyword_set(base)) then begin
  widget_control,event.top,get_uvalue=global_pixel_selection
    id = widget_info(event.top, find_by_uname='pixel_selection_draw')
  endif else begin
  widget_control,base,get_uvalue=global_pixel_selection
    id = widget_info(base, find_by_uname='pixel_selection_draw')
  endelse
  
  if (n_elements(recalculate) eq 0) then begin
    widget_control, id, GET_VALUE = plot_id
    wset, plot_id
    TV, (*(*global_pixel_selection).background), true=3
    return
  endif
  
  Data = (*(*global_pixel_selection).data)
  new_xsize = (*global_pixel_selection).xsize
  new_ysize = (*global_pixel_selection).ysize
  
  ;retrieve range to plot
  tof_device_data = (*global_pixel_selection).tof_device_data
  tof1 = tof_device_data[1,0]
  tof2 = tof_device_data[1,1]
  tof_min = min([tof1,tof2],max=tof_max)
  
  x_axis = (*global_pixel_selection).x_axis
  index_tof1 = getIndexOfValueInArray(array=x_axis, value=tof_min, /from)
  index_tof2 = getIndexOfValueInArray(array=x_axis, value=tof_max, /to)
  
  tmp_x_axis = x_axis[index_tof1:index_tof2]
  (*(*global_pixel_selection).tmp_x_axis) = tmp_x_axis
  
  sz_data = size(data,/dim)
  if (index_tof2 eq sz_data[0]) then index_tof2--
  
  help, data
  print, 'index_tof1: ' , index_tof1
  print, 'index_tof2: ', index_tof2
  print
  
  data = data[index_tof1:index_tof2,*]
  
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  
  ;  if ((*global_plot).plot_setting eq 'untouched') then begin
  cData = congrid(Data, xsize, ysize)
  ;  endif else begin
  ;    cData = congrid(Data, ysize, xsize,/interp)
  ;  endelse
  (*global_pixel_selection).congrid_xcoeff = xsize
  (*global_pixel_selection).congrid_ycoeff = ysize
  
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  erase
  
  loadct, (*global_pixel_selection).default_loadct, /silent
  
  tvscl, cData
  
  save_pixel_selection_background, event=event, main_base=base
  
end

;+
; :Description:
;    Switches the selected button in the individual plot bases
;
; :Params:
;    event
;
; :Author: j35
;-
pro pixel_selection_local_switch_axes_type, event
  compile_opt idl2
  
  uname = widget_info(event.id, /uname)
  widget_control, event.top, get_uvalue=global_pixel_selection
  
  if (uname eq 'pixel_selection_local_scale_setting_linear') then begin
    set1_value = '*  ' + 'linear'
    set2_value = '   ' + 'logarithmic'
    (*global_pixel_selection).default_scale_settings = 0
  endif else begin
    set1_value = '   ' + 'linear'
    set2_value = '*  ' + 'logarithmic'
    (*global_pixel_selection).default_scale_settings = 1
  endelse
  
  putValue, event=event, 'pixel_selection_local_scale_setting_linear', $
    set1_value
  putValue, event=event, 'pixel_selection_local_scale_setting_log', $
    set2_value
    
  pixel_selection_lin_log_data, event=event
  refresh_pixel_selection_plot, event, recalculate=1
  refresh_plot_pixel_selection_colorbar, event
  
  save_pixel_selection_background,  event=event
  
  display_pixel_selection, event=event
  
end

;+
; :Description:
;    this procedure is reached by the loadct menu and change the default loadct
;
; :Params:
;    event
;
; :Author: j35
;-
pro change_pixel_selection_loadct, event
  compile_opt idl2
  
  new_uname = widget_info(event.id, /uname)
  widget_control,event.top,get_uvalue=global_pixel_selection
  
  ;get old loadct
  old_loadct = strcompress((*global_pixel_selection).default_loadct,/remove_all)
  old_uname = 'pixel_selection_loadct_' + old_loadct
  label = getValue(event=event,uname=old_uname)
  
  ;remove keep central part
  raw_label1 = strsplit(label,'>>',/regex,/extract)
  raw_label2 = strsplit(raw_label1[1],'<<',/regex,/extract)
  ;put it back
  putValue, event=event, old_uname, strtrim(raw_label2[0],2)
  
  ;change value of new loadct
  new_label = getValue(event=event, uname=new_uname)
  ;add selection string
  new_label = '>  > >> ' + new_label + ' << <  <'
  putValue, event=event, new_uname, new_label
  
  ;save new loadct
  new_uname_array = strsplit(new_uname,'_',/extract)
  
  (*global_pixel_selection).default_loadct = fix(new_uname_array[3])
  
  ;replot
  refresh_pixel_selection_plot, event, recalculate=1
  refresh_plot_pixel_selection_colorbar, event
  display_pixel_selection, event=event
  
end

;+
; :Description:
;   Reached when the main base is killed
;
; :Params:
;    global_plot
;
; :Author: j35
;-
pro pixel_selection_base_uname_killed, global_pixel_selection
  compile_opt idl2
  
  id_info = (*global_pixel_selection).cursor_info_base
  if (widget_info(id_info,/valid_id) ne 0) then begin
    widget_control, id_info, /destroy
  endif
  
  id_input = (*global_pixel_selection).pixel_selection_input_base
  if (widget_info(id_input, /valid_id) ne 0) then begin
    widget_control, id_input, /destroy
  endif
  
  id_counts = (*global_pixel_selection).roi_selection_counts_vs_pixel_base_id
  if (widget_info(id_counts, /valid_id) ne 0) then begin
    widget_control, id_counts, /destroy
  endif
  
  id_tof = (*global_pixel_selection).tof_range_selection_base
  if (widget_info(id_tof,/valid_id) ne 0) then begin
    widget_control, id_tof, /destroy
  endif
  
end

;+
; :Description:
;    Plot the scale around the plot
;
; :Params:
;    base
;
; :Author: j35
;-
pro plot_pixel_selection_beam_center_scale, base=base, $
    event=event, $
    plot_range=plot_range
    
  compile_opt idl2
  
  if (n_elements(base) ne 0) then begin
    id = widget_info(base,find_by_Uname='pixel_selection_scale')
    id_base = widget_info(base, find_by_uname='pixel_selection_base_uname')
    sys_color = widget_info(base,/system_colors)
    widget_control, base, get_uvalue=global_pixel_selection
  endif else begin
    id = widget_info(event.top, find_by_uname='pixel_selection_scale')
    id_base = widget_info(event.top, find_by_uname='pixel_selection_base_uname')
    sys_color = widget_info(event.top, /system_colors)
    widget_control, event.top, get_uvalue=global_pixel_selection
  endelse
  
  widget_control, id, get_value=id_value
  wset, id_value
  
  ;change color of background
  device, decomposed=1
  sys_color_window_bk = sys_color.window_bk
  
  y_range = (*global_pixel_selection).yrange
  min_y = y_range[0]
  max_y = y_range[1]
  
  x_range = (*global_pixel_selection).xrange
  if (keyword_set(plot_range)) then begin
  
    tof = (*(*global_pixel_selection).x_axis)
  ;  tof_range_selected = (*global_pixel_selection).tof_range_selected
    tof_device_data = (*(*global_pixel_selection).tof_device_data)
    tof_range_selected = [tof_device_data[1,0],tof_device_data[1,1]]
    
    tof1 = min(tof_range_selected,max=tof1)
    
    ;if no tof range selected on any of the two sides, select full range
    if (tof1 eq -1) then tof1 = x_range[0]
    if (tof2 eq -1) then tof2 = x_range[1]
    
    index_tof1 = getIndexOfValueInArray(array=tof, value=tof1, from=1)
    index_tof2 = getIndexOfValueInArray(array=tof, value=tof2, to=1)
    
    _tof_min = tof[index_tof1]
    _tof_max = tof[index_tof2]
    x_range = [_tof_min, _tof_max]
    
  endif
  
  ;determine the number of xaxis data to show
  geometry = widget_info(id_base,/geometry)
  xsize = geometry.scr_xsize
  
  xticks = 8
  yticks = max_y/8
  
  xmargin = 6.6
  ymargin = 4
  
  ticklen = -0.0015
  
  plot, randomn(s,80), $
    XRANGE     = x_range,$
    YRANGE     = y_range,$
    COLOR      = convert_rgb([0B,0B,255B]), $
    BACKGROUND = convert_rgb(sys_color_window_bk),$
    THICK      = 0.5, $
    TICKLEN    = ticklen, $
    XTICKLAYOUT = 0,$
    XSTYLE      = 1,$
    YSTYLE      = 1,$
    YTICKLAYOUT = 0,$
    XTICKS      = xticks,$
    XMINOR      = 2,$
    ;YMINOR      = 2,$
    YTICKS      = yticks,$
    XTITLE      = 'TOF (ms)',$
    YTITLE      = 'Pixels',$
    XMARGIN     = [xmargin, xmargin+0.2],$
    YMARGIN     = [ymargin, ymargin],$
    /NODATA
  axis, yaxis=1, YRANGE=y_range, YTICKS=yticks, YSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = ticklen
  axis, xaxis=1, XRANGE=x_range, XTICKS=xticks, XSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = ticklen
    
  device, decomposed=0
  
end

;+
; :Description:
;    This routine display the selection of TOF made in the data background
;    selection base tool for REF_L
;
; :Keywords:
;    event
;    base
;    full_range
;    no_range: if we don't want to display the from_tof and to_tof
;
; :Author: j35
;-
pro data_background_display_scale_tof_range, event=event, base=base, $
    full_range=full_range, no_range=no_range
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_pixel_selection
  endif else begin
    widget_control, base, get_uvalue=global_pixel_selection
  endelse
  
  if (keyword_set(full_range)) then begin
    plot_pixel_selection_beam_center_scale, event=event, base=base
    id_tof = (*global_pixel_selection).tof_range_selection_base
    if (widget_info(id_tof,/valid_id) ne 0) then begin
      data_background_display_full_tof_range_marker, event=event, base=base
    endif
    return
  endif
  
  plot_pixel_selection_beam_center_scale, event=event, base=base
  
  if (keyword_set(no_range)) then return
  
  id_tof = (*global_pixel_selection).tof_range_selection_base
  if (widget_info(id_tof,/valid_id) ne 0) then begin
  
    tof_range_status = (*global_pixel_selection).tof_range_status
    tof_device_data = (*global_pixel_selection).tof_device_data
    if (tof_range_status eq 'left') then begin
      uname = 'data_background_tof1'
      tof_data = tof_device_data[1,0]
    endif else begin
      uname = 'data_background_tof2'
      tof_data = tof_device_data[1,1]
    endelse
    _tof_base = (*global_pixel_selection).tof_range_selection_base
    putValue, base=_tof_base, uname, strcompress(tof_data,/remove_all)
    
    if (keyword_set(event)) then begin
      id = WIDGET_INFO(Event.top, FIND_By_UNAME='pixel_selection_scale')
    endif else begin
      id = WIDGET_INFO(base, FIND_By_UNAME='pixel_selection_scale')
    endelse
    geometry = WIDGET_INFO(id,/GEOMETRY)
    ysize = geometry.ysize
    xsize = geometry.xsize
    widget_control, id, get_value=id_value
    wset, id_value
    
    tof1_device = tof_device_data[0,0]
    tof2_device = tof_device_data[0,1]
    
    xoffset = 40
    if (tof1_device lt xoffset) then tof1_device = xoffset
    if (tof1_device gt (xsize-xoffset)) then tof1_device = (xsize-xoffset)
    plots, tof1_device, 0, color=fsc_color('yellow'),/device
    plots, tof1_device, ysize, color=fsc_color('yellow'), /continue,/device,$
      thick=3
      
    if (tof2_device lt xoffset) then tof2_device = xoffset
    if (tof2_device gt (xsize-xoffset)) then tof2_device = (xsize-xoffset)
    plots, tof2_device, 0, color=fsc_color('yellow'),/device
    plots, tof2_device, ysize, color=fsc_color('yellow'), /continue,/device, $
      thick=3
      
  endif
  
end

;+
; :Description:
;    This routine display the ticks showing the current range selection around
;    the full set of data (always like that when nothing has been selected
;    yet)
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro data_background_display_full_tof_range_marker, event=event, base=base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='pixel_selection_scale')
  endif else begin
    id = WIDGET_INFO(base, FIND_BY_UNAME='pixel_selection_scale')
  endelse
  
  geometry = WIDGET_INFO(id,/GEOMETRY)
  ysize = geometry.ysize
  xsize = geometry.xsize
  widget_control, id, get_value=id_value
  wset, id_value
  
  xoffset = 40
  tof1_device = xoffset
  tof2_device = xsize-xoffset
  
  if (tof1_device lt xoffset) then tof1_device = xoffset
  if (tof1_device gt (xsize-xoffset)) then tof1_device = (xsize-xoffset)
  plots, tof1_device, 0, color=fsc_color('yellow'),/device
  plots, tof1_device, ysize, color=fsc_color('yellow'), /continue,/device,$
    thick=3
    
  if (tof2_device lt xoffset) then tof2_device = xoffset
  if (tof2_device gt (xsize-xoffset)) then tof2_device = (xsize-xoffset)
  plots, tof2_device, 0, color=fsc_color('yellow'),/device
  plots, tof2_device, ysize, color=fsc_color('yellow'), /continue,/device, $
    thick=3
    
end

;+
; :Description:
;    Cleanup routine
;
; :Params:
;    tlb
;
; :Author: j35
;-
pro pixel_selection_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_pixel_selection, /no_copy
  
  pixel_selection_base_uname_killed, global_pixel_selection
  
  if (n_elements(global_pixel_selection) eq 0) then return
  
  ptr_free, (*global_pixel_selection).full_data
  ptr_free, (*global_pixel_selection).data
  ptr_free, (*global_pixel_selection).data_linear
  ptr_free, (*global_pixel_selection).data_log
  ptr_free, (*global_pixel_selection).tmp_x_axis
  ptr_free, (*global_pixel_selection).background
  ptr_free, (*global_pixel_selection).counts_vs_qx_xaxis
  ptr_free, (*global_pixel_selection).counts_vs_qx_data
  ptr_free, (*global_pixel_selection).counts_vs_qz_xaxis
  ptr_free, (*global_pixel_selection).counts_vs_qz_data
  ptr_free, (*global_pixel_selection).counts_vs_pixel
  
  ptr_free, global_pixel_selection
  
end

;+
; :Description:
;     refresh the plot
;
; :Keywords:
;    base
;    default_loadct
;    default_scale_settings
;    current_plot_setting
;    Data_x
;    Data_y
;    start_pixel
;
; :Author: j35
;-
pro refresh_px_vs_tof_plots_base, wBase = wBase, $
    default_loadct = default_loadct, $
    default_scale_settings = default_scale_settings, $
    current_plot_setting = current_plot_setting, $
    Data_x =  Data_x, $
    Data_y = Data_y, $
    start_pixel = start_pixel
    
  compile_opt idl2
  
  widget_control, wBase, get_uvalue=global_plot
  
  default_loadct = (*global_plot).default_loadct
  default_scale_settings = (*global_plot).default_scale_settings
  current_plot_setting = (*global_plot).plot_setting
  
  ;retrieve scale
  start_tof = Data_x[0]
  end_tof = Data_x[-1]
  delta_tof = Data_x[1]-Data_x[0]
  (*global_plot).delta_tof = delta_tof
  tof_axis = (*global_plot).tof_axis
  tof_axis[0] = start_tof
  tof_axis[1] = end_tof + delta_tof
  (*global_plot).tof_axis = tof_axis
  
  ;retrieve the data to plot
  ;  Data = *pData_y[file_index, spin_state]
  (*(*global_plot).data_linear) = Data_y
  
  lin_log_data, base=wBase
  
  ;number of pixels
  (*global_plot).nbr_pixel = (size(data_y))[1] ;nbr of pixels to plot
  
  Data = (*(*global_plot).data)
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='draw')
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  if ((*global_plot).plot_setting eq 'untouched') then begin
    cData = congrid(Data, ysize, xsize)
  endif else begin
    cData = congrid(Data, ysize, xsize,/interp)
  endelse
  
  border = (*global_plot).border
  colorbar_xsize = (*global_plot).colorbar_xsize
  
  id = widget_info(wBase, find_by_uname='final_plot_base')
  geometry = widget_info(id,/geometry)
  _xsize = geometry.scr_xsize
  _ysize = geometry.scr_ysize
  (*global_plot).congrid_xcoeff = _ysize-2*border
  (*global_plot).congrid_ycoeff = _xsize-2*border-colorbar_xsize
  
  DEVICE, DECOMPOSED = 0
  loadct, default_loadct, /SILENT
  
  plot_beam_center_scale, base=wBase
  
  id = widget_info(wBase,find_by_uname='draw')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  tvscl, transpose(cData)
  
  zmin = 0
  zmax = max(Data)
  zrange = (*global_plot).zrange
  zrange[0] = zmin
  zrange[1] = zmax
  (*global_plot).zrange = zrange
  plot_colorbar, base=wBase, zmin, zmax, type=default_scale_settings
  
  ;change label of default loadct
  pre = '>  > >> '
  post = ' << <  <'
  uname = 'loadct_' + strcompress(default_loadct,/remove_all)
  value = getValue(base=wBase, uname)
  new_value = pre + value + post
  setValue, base=wBase, uname, new_value
  
  save_background,  main_base=wBase
  
end

;+
; :Description:
;   create the base
;
; :Params:
;    wBase
;    main_base_geometry
;    global
;
; :Author: j35
;-
pro data_background_selection_base_gui, wBase, $
    main_base_geometry, $
    global, $
    offset, $
    border, $
    colorbar_xsize, $
    run_number = run_number, $
    scale_setting = scale_setting, $
    default_plot_size = default_plot_size
    
  compile_opt idl2
  
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = default_plot_size[0]
  ysize = default_plot_size[1]
  
  xoffset = (main_base_xsize - xsize) / 2
  xoffset += main_base_xoffset
  xoffset += offset
  
  yoffset = (main_base_ysize - ysize) / 2
  yoffset += main_base_yoffset
  yoffset += offset
  
  ysize_tof_selection_row = 0 ;vertical size of tof row
  
  ourGroup = WIDGET_BASE()
  
  title = 'Run number: ' + strcompress(run_number[0],/remove_all)
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'pixel_selection_base_uname', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = ysize+ysize_tof_selection_row,$
    SCR_XSIZE    = xsize+colorbar_xsize,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    /align_center,$
    /tlb_move_events, $
    /tlb_size_events,$
    mbar = bar1,$
    GROUP_LEADER = ourGroup)
    
  draw = widget_draw(wbase,$
    xoffset = border,$
    yoffset = border,$
    scr_xsize = xsize-2*border,$
    scr_ysize = ysize-2*border,$
    /button_events, $
    /motion_events, $
    /tracking_events, $
    keyboard_events=2, $
    retain=2, $
    uname = 'pixel_selection_draw')
    
  scale = widget_draw(wBase,$
    uname = 'pixel_selection_scale',$
    scr_xsize = xsize,$
    scr_ysize = ysize,$
    /button_events, $
    /motion_events, $
    retain=2)
    
  colorbar =  widget_draw(wBase,$
    uname = 'pixel_selection_colorbar',$
    xoffset = xsize,$
    scr_xsize = colorbar_xsize,$
    scr_ysize = ysize,$
    retain=2)
    
  mPlot = widget_button(bar1, $
    value = 'Type ',$
    /menu)
    
  list_loadct = ['B-W Linear',$
    'Blue/White',$
    'Green-Red-Blue-White',$
    'Red temperature',$
    'Blue/Green/Red/Yellow',$
    'Std Gamma-II',$
    'Prism',$
    'Red-Purple',$
    'Green/White Linear',$
    'Green/White Exponential                  ',$
    'Green-Pink',$
    'Blue-Red',$
    '16 level',$
    'Rainbow',$
    'Steps',$
    'Stern Special',$
    'Haze',$
    'Blue-Pastel-R',$
    'Pastels',$
    'Hue Sat Lightness 1',$
    'Hue Sat Ligthness 2',$
    'Hue Sat Value 1',$
    'Hue Sat Value 2',$
    'Purple-Red + Stri',$
    'Beach',$
    'Mac Style',$
    'Eos A',$
    'Eos B',$
    'Hardcandy',$
    'Nature',$
    'Ocean',$
    'Peppermint',$
    'Plasma',$
    'Blue-Red',$
    'Rainbow',$
    'Blue Waves',$
    'Volcano',$
    'Waves',$
    'Rainbow18',$
    'Rainbow + white',$
    'Rainbow + black']
    
  set = widget_button(mPlot,$
    value = list_loadct[0],$
    uname = 'pixel_selection_loadct_0',$
    event_pro = 'change_pixel_selection_loadct',$
    /separator)
    
  sz = n_elements(list_loadct)
  for i=1L,(sz-1) do begin
    set = widget_button(mPlot,$
      value = list_loadct[i],$
      uname = 'pixel_selection_loadct_' + strcompress(i,/remove_all),$
      event_pro = 'change_pixel_selection_loadct')
  endfor
  
  if (scale_setting eq 0) then begin
    set1_value = '*  linear'
    set2_value = '   logarithmic'
  endif else begin
    set1_value = '   linear'
    set2_value = '*  logarithmic'
  endelse
  
  mPlot = widget_button(bar1, $
    value = 'Axes',$
    /menu)
    
  set1 = widget_button(mPlot, $
    value = set1_value, $
    event_pro = 'pixel_selection_local_switch_axes_type',$
    uname = 'pixel_selection_local_scale_setting_linear')
    
  set2 = widget_button(mPlot, $
    value = set2_value,$
    event_pro = 'pixel_selection_local_switch_axes_type',$
    uname = 'pixel_selection_local_scale_setting_log')
    
  pixel = widget_button(bar1,$
    value = 'Window',$
    /menu)
    
  info = widget_button(pixel,$
    value = 'Show cursor infos',$
    uname = 'show_pixel_cursor_base')
    
  show = widget_button(pixel,$
    value = 'Show pixel selection window',$
    uname = 'show_pixel_selection_base')
    
  _plot = widget_button(pixel,$
    value = 'Show Counts vs pixel window',$
    uname = 'show_counts_vs_pixel_base')
    
  tof = widget_button(pixel,$
    value = 'Show TOF range selection window',$
    uname = 'show_tof_range_selection_base')
    
end

;+
; :Description:
;     Creates the base and plot the pixel vs pixel of the
;     given file index
;
; :Keywords:
;    main_base
;    event
;    offset
;    tof_min_max  [tof_min,tof_max] in ms defined by the user (reduce tab)
;    row_index    row used to plot NeXus file
;    x_axis       (ex:Array of float [52])
;    y_axis       (ex:Array of int [304])
;    data         (ex:Array of ulong [51,256,304])
;    file_name    (ex:REF_M_3454.nxs)
;
; :Author: j35
;-
pro data_background_selection_base, main_base=main_base, $
    event=event, $
    offset = offset, $
    x_axis = x_axis, $
    y_axis = y_axis, $
    data = data, $
    run_number = run_number, $
    file_name = file_name
    
  compile_opt idl2
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;SETUP
  border = 40
  colorbar_xsize = 70
  
  default_plot_size = [600,600]
  default_scale_setting = 1 ;log by default
  default_loadct = 5
  
  ;build gui
  wBase = ''
  data_background_selection_base_gui, wBase, $
    main_base_geometry, $
    global, $
    offset, $
    border, $
    colorbar_xsize, $
    run_number = run_number, $
    scale_setting = default_scale_setting,$
    default_plot_size = default_plot_size
  wBase_copy = wBase
  wBase_copy1 = wBase
  
  WIDGET_CONTROL, wBase, /REALIZE
  
  short_file_name = file_basename(file_name)
  
  global_pixel_selection = PTR_NEW({ wbase: wbase,$
    global: global, $
    
    run_number: run_number, $
    file_name: file_name, $
    short_file_name: short_file_name, $
    
    tof_range_selection_base: 0L, $
    cursor_info_base: 0L, $
    pixel_selection_input_base: 0L, $ ;id of refpix_input_base
    ;'id of refpix_counts_vs_tof_base
    roi_selection_counts_vs_pixel_base_id: 0L, $
    counts_vs_pixel_scale_is_linear: 0b, $ ;counts vs tof (linear/log)
    pixel_selection: [-1,-1], $
    
    tof_range_selected: [-1.,-1.], $
    tof_device_data: fltarr(2,2), $
    
    ;mouse interaction with tof axis of main scale plot
    scale_mouse_left_pressed: 0b, $
    scale_mouse_right_pressed: 0b, $
    tof_range_status: 'left', $
    
    ;used to plot selection zoom
    default_plot_size: default_plot_size, $
    
    counts_vs_xaxis_yaxis_type: 0,$ ;0 for linear, 1 for log
    counts_vs_yaxis_yaxis_type: 0,$ ;0 for linear, 1 for log
    
    counts_vs_xaxis_base: 0L, $ ;id of info counts vs x
    counts_vs_yaxis_base: 0L, $ ;id of info counts vs y
    counts_vs_xaxis_plot_uname: '',$
    counts_vs_yaxis_plot_uname: '',$
    
    full_data: ptr_new(0L), $
    data: ptr_new(0L), $
    data_linear: ptr_new(0L), $
    data_log: ptr_new(0L), $
    counts_vs_pixel: ptr_new(0L), $
    
    x_axis: x_axis, $ ; [0.2, 0.4....] tof
    tmp_x_axis: ptr_new(0L), $
    y_axis: y_axis, $ ; pixel range
    
    ;pointers used to output the counts vs qx/qz ascii files
    counts_vs_qx_xaxis: ptr_new(0L), $
    counts_vs_qx_data: ptr_new(0L), $
    counts_vs_qz_xaxis: ptr_new(0L), $
    counts_vs_qz_data: ptr_new(0L), $
    
    shift_key_status: 0b, $ ;when range is selected to produce 2d plots
    QxQzrange: fltarr(2), $ ; [Qx0, Qz0]
    EventRangeSelection: intarr(2), $ ;[event.x, event.y]
    ;when using first shift left click
    
    counts_vs_qx_lin: 0, $ ;0 is plot is linear, 1 if it's log
    counts_vs_qz_lin: 0, $
    
    xsize: default_plot_size[0],$
    ysize: default_plot_size[1],$
    
    nbr_pixel: 0L,$
    
    colorbar_xsize: colorbar_xsize, $
    default_loadct: default_loadct, $
    default_scale_settings: default_scale_setting, $ ;lin or log z-axis
    
    border: border, $ ;border of main plot (space reserved for scale)
    
    Qx_axis: fltarr(2),$  ;[start, end]
    ;    delta_Qx: 0., $ ;Qx increment
    
    xrange: fltarr(2),$
    zrange: fltarr(2),$
    yrange: fltarr(2),$
    
    background: ptr_new(0L), $ ;background of main plot
    
    left_click: 0b,$ ;by default, left button is not clicked
    pixel1_selected: 1b, $ ;to show pixel1 or pixel2 current selection
    
    ;x coeff used in the congrid function to plot main data
    congrid_xcoeff: 0., $
    ;y coeff used in the congrid function to plot main data
    congrid_ycoeff: 0., $
    
    top_base: wBase, $
    main_event: event})
    
  (*(*global_pixel_selection).tmp_x_axis) = x_axis  
    
  (*(*global_pixel_selection).full_data) = data
  
  data_2d = total(data,3)
  
  counts_vs_pixel = total(data_2d,1)
  (*(*global_pixel_selection).counts_vs_pixel) = counts_vs_pixel
  
  (*(*global_pixel_selection).data_linear) = data_2d
  (*(*global_pixel_selection).data) = data_2d
  
  xrange = [x_axis[0], x_axis[-1]]
  (*global_pixel_selection).xrange = xrange
  (*global_pixel_selection).tof_range_selected = [x_axis[0],x_axis[-1]]
  
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='pixel_selection_draw')
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  xoffset = draw_geometry.xoffset
  
  tof_device_data = (*global_pixel_selection).tof_device_data
  tof_device_data[0,0] = xoffset
  tof_device_data[0,1] = xsize+xoffset
  tof_device_data[1,0] = x_axis[0]
  tof_device_data[1,1] = x_axis[-1]
  (*global_pixel_selection).tof_device_data = tof_device_data
  
  yrange = [y_axis[0], y_axis[-1]+1]
  (*global_pixel_selection).yrange = yrange
  
  WIDGET_CONTROL, wBase, SET_UVALUE = global_pixel_selection
  
  XMANAGER, "data_background_selection_base", wBase, $
    GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup = 'pixel_selection_base_cleanup'
    
  pixel_selection_lin_log_data, base=wBase, /init
  
  Data = (*(*global_pixel_selection).data)
  
  cData = congrid(Data, xsize, ysize)
  
  id = widget_info(wBase, find_by_uname='pixel_selection_base_uname')
  geometry = widget_info(id,/geometry)
  _xsize = geometry.scr_xsize
  _ysize = geometry.scr_ysize
  
  (*global_pixel_selection).congrid_xcoeff = xsize
  (*global_pixel_selection).congrid_ycoeff = ysize
  
  DEVICE, DECOMPOSED = 0
  loadct, (*global_pixel_selection).default_loadct, /SILENT
  
  data_background_tof_range_selection_base, $
    top_base=(*global_pixel_selection).top_base, $
    parent_base_uname = 'pixel_selection_base_uname'
    
  ;initialize scale
  data_background_display_scale_tof_range, base=wBase,/full_range
  ;plot_pixel_selection_beam_center_scale, base=wBase
  
  id = widget_info(wBase,find_by_uname='pixel_selection_draw')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  tvscl, cData
  
  ;Scale
  zmin = 0
  zmax = max((*(*global_pixel_selection).data_linear))
  zrange = (*global_pixel_selection).zrange
  zrange[0] = zmin
  zrange[1] = zmax
  
  (*global_pixel_selection).zrange = zrange
  
  plot_pixel_selection_colorbar, base=wBase, $
    zmin, $
    zmax, $
    type=default_scale_settings
    
  pre = '>  > >> '
  post = ' << <  <'
  uname = 'pixel_selection_loadct_' + strcompress(default_loadct,/remove_all)
  value = getValue(base=wBase, uname=uname)
  new_value = pre + value + post
  setValue, base=wBase, uname, new_value
  
  save_pixel_selection_background,  main_base=wBase
  
  ;bring to life the ROI pixel1 and 2 input base
  pixel_selection_input_base, parent_base_uname='pixel_selection_base_uname', $
    top_base=wBase_copy1
    
  ;bring to life the base that show counts vs tof
  data_background_counts_vs_pixel_base, $
    parent_base_uname='pixel_selection_base_uname', $
    top_base=wBase_copy
    
end

