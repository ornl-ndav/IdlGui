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
pro discrete_selection_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_tof_selection
  main_event = (*global_tof_selection).main_event
  
  case Event.id of
  
    ;main draw
    widget_info(event.top, find_by_uname='discrete_selection_draw'): begin
    
      catch, error
      if (error ne 0) then begin ;selection
        catch,/cancel
        
        show_discrete_selection_cursor_info, event
        return
        
        if (event.press eq 1) then begin ;left click
        
          show_tof_selection_input_base, event
          show_tof_selection_counts_vs_tof_base, event
          
          ;left click activated
          (*global_tof_selection).left_click = 1b
          
          tof_value = strcompress(retrieve_tof_value(event),/remove_all)
          if ((*global_tof_selection).tof1_selected) then begin
            uname = 'discrete_selection_tof1_uname'
          endif else begin
            uname = 'discrete_selection_tof2_uname'
          endelse
          
          check_tof_value, tof_value, global_tof_selection
          if (tof_value eq -1) then tof_value = ''
          putValue, base=(*global_tof_selection).tof_selection_input_base, $
            uname, $
            tof_value
          save_tof_data, event=event
          display_tof_selection_tof, event=event
          
          ;display counts_vs_tof with selection
          plot_base = (*global_tof_selection).tof_selection_counts_vs_tof_base_id
          if (widget_info(plot_base, /valid_id) ne 0) then begin
            display_counts_vs_tof, $
              base=(*global_tof_selection).tof_selection_counts_vs_tof_base_id, $
              global_tof_selection
          endif
          
        endif
        
        
        ;release button
        if (event.release eq 1 && $
          (*global_tof_selection).left_click eq 1b) then begin
          (*global_tof_selection).left_click = 0b
        endif
        
        ;right click
        if (event.press eq 4) then begin
          ;          show_refpix_input_base, event
          if ((*global_tof_selection).tof1_selected) then begin
            (*global_tof_selection).tof1_selected = 0b
          endif else begin
            (*global_tof_selection).tof1_selected = 1b
          endelse
          display_tof_selection_tof, event=event
          
          ;display counts_vs_tof with selection
          plot_base = (*global_tof_selection).tof_selection_counts_vs_tof_base_id
          if (widget_info(plot_base, /valid_id) ne 0) then begin
            display_counts_vs_tof, $
              base=(*global_tof_selection).tof_selection_counts_vs_tof_base_id, $
              global_tof_selection
          endif
          
        endif
        
        ;moving mouse with left click pressed
        if ((*global_tof_selection).left_click) then begin
          tof_value = strcompress(retrieve_tof_value(event),/remove_all)
          if ((*global_tof_selection).tof1_selected) then begin
            uname = 'discrete_selection_tof1_uname'
          endif else begin
            uname = 'discrete_selection_tof2_uname'
          endelse
          check_tof_value, tof_value, global_tof_selection
          if (tof_value eq -1) then tof_value = ''
          putValue, base=(*global_tof_selection).tof_selection_input_base, $
            uname, $
            tof_value
          save_tof_data, event=event
          display_tof_selection_tof, event=event
          
          ;display counts_vs_tof with selection
          plot_base = (*global_tof_selection).tof_selection_counts_vs_tof_base_id
          if (widget_info(plot_base, /valid_id) ne 0) then begin
            display_counts_vs_tof, $
              base=(*global_tof_selection).tof_selection_counts_vs_tof_base_id, $
              global_tof_selection
          endif
          
        endif
        
      endif else begin ;entering or leaving widget_draw
      
        if (event.enter eq 0) then begin ;leaving plot
          file_name = (*global_tof_selection).file_name
          id = widget_info(event.top, find_by_uname='discrete_selection_base_uname')
          widget_control, id, tlb_set_title=file_name
          
        endif else begin ;entering plot
        
        endelse
      endelse
      
    end
    
    ;main base
    widget_info(event.top, find_by_uname='discrete_selection_base_uname'): begin
    
      id = widget_info(event.top, find_by_uname='discrete_selection_base_uname')
      geometry = widget_info(id,/geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      xoffset = geometry.xoffset
      yoffset = geometry.yoffset
      
      ;only if the tof input base is there
      id_tof_selection = (*global_tof_selection).tof_selection_input_base
      if (widget_info(id_tof_selection, /valid_id) ne 0) then begin
        widget_control, id_tof_selection, xoffset = xoffset + new_xsize
        widget_control, id_tof_selection, yoffset = yoffset
      endif
      
      if ((abs((*global_tof_selection).xsize - new_xsize) eq 70.0) && $
        abs((*global_tof_selection).ysize - new_ysize) eq 33.0) then return
        
      if ((abs((*global_tof_selection).xsize - new_xsize) eq 0.0) && $
        abs((*global_tof_selection).ysize - new_ysize) eq 33.0) then return
        
      (*global_tof_selection).xsize = new_xsize
      (*global_tof_selection).ysize = new_ysize
      
      widget_control, id, xsize = new_xsize
      widget_control, id, ysize = new_ysize
      
      border = (*global_tof_selection).border
      colorbar_xsize = (*global_tof_selection).colorbar_xsize
      
      id = widget_info(event.top, find_by_uname='discrete_selection_draw')
      widget_control, id, draw_xsize = new_xsize-2*border-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize-2*border
      
      id = widget_info(event.top,find_by_Uname='discrete_selection_scale')
      widget_control, id, draw_xsize = new_xsize-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize
      
      id = widget_info(event.top, find_by_uname='discrete_selection_colorbar')
      widget_control, id, xoffset=new_xsize-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize
      widget_control, id, draw_xsize = colorbar_xsize
      
      plot_discrete_selection_beam_center_scale, event=event
      refresh_discrete_selection_plot, event, recalculate=1
      refresh_plot_discrete_selection_colorbar, event
      display_discrete_selection_tof, event=event
      
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
    
    widget_info(event.top, $
      find_by_uname='show_discrete_selection_base'): begin
      pixel_base = (*global_tof_selection).tof_selection_input_base
      if (widget_info(pixel_base, /valid_id) eq 0) then begin
        tof_selection_input_base, parent_base_uname = 'discrete_selection_base_uname', $
          top_base = (*global_tof_selection).top_base, $
          event=event
      endif
    end
    
    ;show counts vs tof base
    widget_info(event.top, $
      find_by_uname='show_counts_vs_tof_base'): begin
      plot_base = (*global_tof_selection).tof_selection_counts_vs_tof_base_id
      if (widget_info(plot_base, /valid_id) eq 0) then begin
        tof_selection_counts_vs_tof_base, $
          parent_base_uname='tof_selection_base_uname', $
          top_base = (*global_tof_selection).top_base, $
          event=event
      endif
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    Bring to life the refpix input base
;
; :Params:
;    event
;
; :Author: j35
;-
pro show_discrete_selection_input_base, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_tof_selection
  
  _base = (*global_tof_selection).tof_selection_input_base
  if (widget_info(_base, /valid_id) eq 0) then begin
    tof_selection_input_base, parent_base_uname = 'tof_selection_base_uname', $
      top_base = (*global_tof_selection).top_base, $
      event=event
  endif
  
end

;+
; :Description:
;    Bring to life the refpix counts vs pixel base
;
; :Params:
;    event
;
; :Author: j35
;-
pro show_discrete_selection_counts_vs_tof_base, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_tof_selection
  
  plot_base = (*global_tof_selection).tof_selection_counts_vs_tof_base_id
  if (widget_info(plot_base, /valid_id) eq 0) then begin
    tof_selection_counts_vs_tof_base, parent_base_uname = 'tof_selection_base_uname', $
      top_base = (*global_tof_selection).top_base, $
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
function discrete_y_data_checked, event=event, base=base, data=data
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
;    Save the tof1 and 2 in data coordinates
;
; :Params:
;    event
;
; :Author: j35
;-
pro discrete_save_tof_data, event=event, base=base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_tof_selection
  endif else begin
    widget_control, base, get_uvalue=global_selection
  endelse
  
  tof_selection_input_base = (*global_tof_selection).tof_selection_input_base
  
  tof1 = getValue(base=tof_selection_input_base, $
    uname='discrete_selection_tof1_uname')
  tof2 = getValue(base=tof_selection_input_base, $
    uname='discrete_selection_tof2_uname')
    
  tof1 = (tof1 eq '') ? -1 : tof1
  tof2 = (tof2 eq '') ? -1 : tof2
  
  tof_min_max = [tof1, tof2]
  
  (*global_tof_selection).tof_selection_tof = tof_min_max
  
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
function discrete_from_data_to_device, event=event, base=base, xdata
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_tof_selection
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='discrete_selection_draw')
  endif else begin
    widget_control, base, get_uvalue=global_tof_selection
    id = WIDGET_INFO(base, FIND_BY_UNAME='discrete_selection_draw')
  endelse
  
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = geometry.xsize
  xrange = (*global_tof_selection).xrange
  
  ratio = float(xsize) / (float(xrange[1]) - float(xrange[0]))
  xdevice = ratio * (float(xdata) - float(xrange[0]))
  
  return, xdevice
  
end

;+
; :Description:
;    refresh the background and display the two tof min and max
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro display_discrete_selection_tof, event=event, base=base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_tof_selection
    id = widget_info(event.top, find_by_uname='discrete_selection_draw')
  endif else begin
    widget_control, base, get_uvalue=global_tof_selection
    id = widget_info(base, find_by_uname='discrete_selection_draw')
  endelse
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  TV, (*(*global_tof_selection).background), true=3
  
  tof_selection_tof = (*global_tof_selection).tof_selection_tof
  
  tof_min = tof_selection_tof[0]
  tof_max = tof_selection_tof[1]
  
  tof_min_device = discrete_from_data_to_device(event=event, base=base, tof_min)
  tof_max_device = discrete_from_data_to_device(event=event, base=base, tof_max)
  
  ysize = (*global_tof_selection).ysize
  
  if (tof_min_device ne -1) then begin
  
    plots, tof_min_device, 0, fsc_color("green"),/device
    plots, tof_min_device, ysize, fsc_color("green"),/continue, linestyle=4,$
      /device
      
  endif
  
  if (tof_max_device ne -1) then begin
  
    plots, tof_max_device, 0, fsc_color("green"),/device
    plots, tof_max_device, ysize, fsc_color("green"),/continue, linestyle=4,$
      /device
      
  endif
  
  if ((*global_tof_selection).tof1_selected) then begin
    tof_device = tof_min_device
  endif else begin
    tof_device = tof_max_device
  endelse
  
  ;retrieve geometry of refpix draw
  geometry = widget_info(id,/geometry)
  draw_ysize = geometry.scr_ysize
  to_ysize = (draw_ysize/100.)*2.
  from_tof = tof_device - 10
  to_tof = tof_device + 10
  
  plots, [from_tof, tof_device, to_tof, tof_device, from_tof], $
    [0, 0, 0, to_ysize, 0], $
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
pro discrete_display_refpix_user_input_value, base=base
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
function discrete_retrieve_tof_value, event
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
function discrete_retrieve_pixel_value, event
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
function discrete_retrieve_counts_value, event
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
pro show_discrete_selection_cursor_info, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_tof_selection
  
  data = (*(*global_tof_selection).full_data)
  x_axis = (*global_tof_selection).x_axis
  y_axis = (*global_tof_selection).y_axis
  
  xcoeff = (*global_tof_selection).congrid_xcoeff
  ycoeff = (*global_tof_selection).congrid_ycoeff
  
  tof_value = strcompress(retrieve_tof_value(event),/remove_all)
  pixel_value = strcompress(retrieve_pixel_value(event),/remove_all)
  counts_value = strcompress(retrieve_counts_value(event),/remove_all)
  
  file_name = (*global_tof_selection).short_file_name
  
  if (tof_value eq 'N/A' || $
    pixel_value eq 'N/A' || $
    counts_value eq 'N/A') then begin
    text = file_name
  endif else begin
    text = file_name + ' (cursor is at TOF:'
    text += strcompress(tof_value,/remove_all) + 'ms ; pixel:'
    text += strcompress(pixel_value,/remove_all) + '; counts:'
    text += strcompress(counts_value,/remove_all) + ')'
  endelse
  id = widget_info(event.top, find_by_uname='discrete_selection_base_uname')
  widget_control, id, tlb_set_title=text
  
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
pro save_discrete_selection_background,  event=event, main_base=main_base, uname=uname
  compile_opt idl2
  
  if (~keyword_set(uname)) then uname = 'discrete_selection_draw'
  
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME=uname)
    widget_control, main_base, get_uvalue=global_tof_selection
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, event.top, GET_UVALUE=global_tof_selection
    id = WIDGET_INFO(Event.top,find_by_uname=uname)
  ENDELSE
  
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize   = geometry.xsize
  ysize   = geometry.ysize
  
  DEVICE, copy =[0, 0, xsize, ysize, 0, 0]
  
  (*(*global_tof_selection).background) = background
  
END

;+
; :Description:
;    Switch linear/log plot
;
; :Keywords:
;    event
;    base
;
; :Author: j35
;-
pro discrete_selection_lin_log_data, event=event, base=base
  compile_opt idl2
  
  ;get global structure
  if (n_elements(event) ne 0) then begin
    widget_control,event.top,get_uvalue=global_tof_selection
  endif else begin
    widget_control, base, get_uvalue=global_tof_selection
  endelse
  
  Data = (*(*global_tof_selection).data_linear)
  scale_setting = (*global_tof_selection).default_scale_settings ;0 for lin, 1 for log
  
  if (scale_setting eq 1) then begin ;log
  
    ;remove 0 values and replace with NAN
    ;and calculate log
    index = where(Data eq 0, nbr)
    if (nbr GT 0) then begin
      Data[index] = !VALUES.D_NAN
    endif
    Data = ALOG10(Data)
    Data = BYTSCL(Data,/NAN)
    
  endif
  
  (*(*global_tof_selection).data) = Data
  
end

;+
; :Description:
;    refresh the 2d plot
;
; :Params:
;    event
;
; :Author: j35
;-
pro refresh_discrete_selection_plot, event, recalculate=recalculate
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_tof_selection
  
  if (n_elements(recalculate) eq 0) then begin
    id = widget_info(event.top, find_by_uname='discrete_selection_draw')
    widget_control, id, GET_VALUE = plot_id
    wset, plot_id
    TV, (*(*global_tof_selection).background), true=3
    return
  endif
  
  Data = (*(*global_tof_selection).data)
  new_xsize = (*global_tof_selection).xsize
  new_ysize = (*global_tof_selection).ysize
  
  id = WIDGET_INFO(event.top, FIND_BY_UNAME='discrete_selection_draw')
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  
  ;  if ((*global_plot).plot_setting eq 'untouched') then begin
  cData = congrid(Data, xsize, ysize)
  ;  endif else begin
  ;    cData = congrid(Data, ysize, xsize,/interp)
  ;  endelse
  (*global_tof_selection).congrid_xcoeff = xsize
  (*global_tof_selection).congrid_ycoeff = ysize
  
  id = widget_info(event.top, find_by_uname='discrete_selection_draw')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  erase
  
  loadct, (*global_tof_selection).default_loadct, /silent
  
  tvscl, cData
  
  save_discrete_selection_background, event=event
  
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
pro discrete_selection_local_switch_axes_type, event
  compile_opt idl2
  
  uname = widget_info(event.id, /uname)
  widget_control, event.top, get_uvalue=global_tof_selection
  
  if (uname eq 'discrete_selection_local_scale_setting_linear') then begin
    set1_value = '*  ' + 'linear'
    set2_value = '   ' + 'logarithmic'
    (*global_tof_selection).default_scale_settings = 0
  endif else begin
    set1_value = '   ' + 'linear'
    set2_value = '*  ' + 'logarithmic'
    (*global_tof_selection).default_scale_settings = 1
  endelse
  
  putValue, event=event, 'discrete_selection_local_scale_setting_linear', set1_value
  putValue, event=event, 'discrete_selection_local_scale_setting_log', set2_value
  
  discrete_selection_lin_log_data, event=event
  refresh_discrete_selection_plot, event, recalculate=1
  refresh_plot_discrete_selection_colorbar, event
  
  save_discrete_selection_background,  event=event
  
  display_discrete_selection_tof, event=event
  
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
pro change_discrete_selection_loadct, event
  compile_opt idl2
  
  new_uname = widget_info(event.id, /uname)
  widget_control,event.top,get_uvalue=global_tof_selection
  
  ;get old loadct
  old_loadct = strcompress((*global_tof_selection).default_loadct,/remove_all)
  old_uname = 'discrete_selection_loadct_' + old_loadct
  label = getValue(event=event,uname=old_uname)
  
  ;remove keep central part
  raw_label1 = strsplit(label,'>>',/regex,/extract)
  raw_label2 = strsplit(raw_label1[1],'<<',/regex,/extract)
  ;raw_label = strcompress(raw_label2[0],/remove_all)
  ;put it back
  putValue, event=event, old_uname, strtrim(raw_label2[0],2)
  
  ;change value of new loadct
  new_label = getValue(event=event, uname=new_uname)
  ;  new_label = strcompress(new_label,/remove_all)
  ;add selection string
  new_label = '>  > >> ' + new_label + ' << <  <'
  putValue, event=event, new_uname, new_label
  
  ;save new loadct
  new_uname_array = strsplit(new_uname,'_',/extract)
  
  (*global_tof_selection).default_loadct = fix(new_uname_array[3])
  
  ;replot
  refresh_discrete_selection_plot, event, recalculate=1
  refresh_plot_discrete_selection_colorbar, event
  display_discrete_selection_tof, event=event
  
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
pro discrete_selection_base_uname_killed, global_tof_selection
  compile_opt idl2
  
  id_input = (*global_tof_selection).tof_selection_input_base
  if (widget_info(id_input, /valid_id) ne 0) then begin
    widget_control, id_input, /destroy
  endif
  
  id_counts = (*global_tof_selection).tof_selection_counts_vs_tof_base_id
  if (widget_info(id_counts, /valid_id) ne 0) then begin
    widget_control, id_counts, /destroy
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
pro plot_discrete_selection_beam_center_scale, base=base, event=event
  compile_opt idl2
  
  if (n_elements(base) ne 0) then begin
    id = widget_info(base,find_by_Uname='discrete_selection_scale')
    id_base = widget_info(base, find_by_uname='discrete_selection_base_uname')
    sys_color = widget_info(base,/system_colors)
    widget_control, base, get_uvalue=global_tof_selection
  endif else begin
    id = widget_info(event.top, find_by_uname='discrete_selection_scale')
    id_base = widget_info(event.top, find_by_uname='discrete_selection_base_uname')
    sys_color = widget_info(event.top, /system_colors)
    widget_control, event.top, get_uvalue=global_tof_selection
  endelse
  
  widget_control, id, get_value=id_value
  wset, id_value
  
  ;change color of background
  device, decomposed=1
  sys_color_window_bk = sys_color.window_bk
  
  x_range = (*global_tof_selection).xrange
  min_x = x_range[0]
  max_x = x_range[1]
  
  y_range = (*global_tof_selection).yrange
  min_y = y_range[0]
  max_y = y_range[1]
  
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
;    Cleanup routine
;
; :Params:
;    tlb
;
; :Author: j35
;-
pro discrete_selection_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_tof_selection, /no_copy
  
  tof_selection_base_uname_killed, global_tof_selection
  
  if (n_elements(global_tof_selection) eq 0) then return
  
  ptr_free, (*global_tof_selection).full_data
  ptr_free, (*global_tof_selection).data
  ptr_free, (*global_tof_selection).data_linear
  ptr_free, (*global_tof_selection).background
  ptr_free, (*global_tof_selection).counts_vs_qx_xaxis
  ptr_free, (*global_tof_selection).counts_vs_qx_data
  ptr_free, (*global_tof_selection).counts_vs_qz_xaxis
  ptr_free, (*global_tof_selection).counts_vs_qz_data
  ptr_free, (*global_tof_selection).counts_vs_tof
  
  ptr_free, global_tof_selection
  
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
pro refresh_discrete_px_vs_tof_plots_base, wBase = wBase, $
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
pro discrete_selection_base_gui, wBase, $
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
    UNAME        = 'discrete_selection_base_uname', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = ysize+ysize_tof_selection_row,$
    SCR_XSIZE    = xsize+colorbar_xsize,$
    MAP          = 1,$
    ;    /tlb_kill_request_events,$
    ;    kill_notify  = 'refpix_base_uname_killed', $
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
    ;    event_pro = 'refpix_draw_eventcb',$
    uname = 'discrete_selection_draw')
    
  scale = widget_draw(wBase,$
    uname = 'discrete_selection_scale',$
    scr_xsize = xsize,$
    scr_ysize = ysize,$
    retain=2)
    
  colorbar =  widget_draw(wBase,$
    uname = 'discrete_selection_colorbar',$
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
    uname = 'discrete_selection_loadct_0',$
    event_pro = 'change_discrete_selection_loadct',$
    /separator)
    
  sz = n_elements(list_loadct)
  for i=1L,(sz-1) do begin
    set = widget_button(mPlot,$
      value = list_loadct[i],$
      uname = 'discrete_selection_loadct_' + strcompress(i,/remove_all),$
      event_pro = 'change_discrete_selection_loadct')
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
    event_pro = 'discrete_selection_local_switch_axes_type',$
    uname = 'discrete_selection_local_scale_setting_linear')
    
  set2 = widget_button(mPlot, $
    value = set2_value,$
    event_pro = 'discrete_selection_local_switch_axes_type',$
    uname = 'discrete_selection_local_scale_setting_log')
    
  pixel = widget_button(bar1,$
    value = 'Extra',$
    /menu)
    
  show = widget_button(pixel,$
    value = 'Show TOF selection window',$
    uname = 'show_tof_selection_base')
    
;  _plot = widget_button(pixel,$
;    value = 'Show Counts vs TOF window',$
;    uname = 'show_counts_vs_tof_base')
    
end

;+
; :Description:
;     Creates the base and plot the pixel vs tof of the
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
pro discrete_selection_base, main_base=main_base, $
    event=event, $
    tof_min_max = tof_min_max, $
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
  discrete_selection_base_gui, wBase, $
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
  
  global_tof_selection = PTR_NEW({ wbase: wbase,$
    global: global, $
    
    run_number: run_number, $
    file_name: file_name, $
    short_file_name: short_file_name, $
    
    tof_selection_input_base: 0L, $ ;id of refpix_input_base
    tof_selection_counts_vs_tof_base_id: 0L, $ 'id of refpix_counts_vs_tof_base
  counts_vs_tof_scale_is_linear: 0b, $ ;counts vs tof (linear/log)
  
    ;used to plot selection zoom
    default_plot_size: default_plot_size, $
    
    counts_vs_xaxis_yaxis_type: 0,$ ;0 for linear, 1 for log
    counts_vs_yaxis_yaxis_type: 0,$ ;0 for linear, 1 for log
    
    cursor_info_base: 0L, $ ;id of info base
    counts_vs_xaxis_base: 0L, $ ;id of info counts vs x
    counts_vs_yaxis_base: 0L, $ ;id of info counts vs y
    counts_vs_xaxis_plot_uname: '',$
    counts_vs_yaxis_plot_uname: '',$
    
    full_data: ptr_new(0L), $
    data: ptr_new(0L), $
    data_linear: ptr_new(0L), $
    counts_vs_tof: ptr_new(0L), $
    
    x_axis: x_axis, $ ; [-0.004, -0.003, -0.002...]
    y_axis: y_axis, $ ; [0.0, 0.1, 0.2, 0.3]
    
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
    tof1_selected: 1b, $ ;to show tof1 or tof2 current selection
    tof_selection_tof: tof_min_max, $ ;[tof_min,tof_max] in ms
    
    ;x coeff used in the congrid function to plot main data
    congrid_xcoeff: 0., $
    ;y coeff used in the congrid function to plot main data
    congrid_ycoeff: 0., $
    
    top_base: wBase, $
    main_event: event})
    
  (*(*global_tof_selection).full_data) = data
  
  data_2d = total(data,2)
  counts_vs_tof = total(data_2d,2)
  (*(*global_tof_selection).counts_vs_tof) = counts_vs_tof
  
  (*(*global_tof_selection).data_linear) = data_2d
  (*(*global_tof_selection).data) = data_2d
  
  xrange = [x_axis[0], x_axis[-1]]
  (*global_tof_selection).xrange = xrange
  
  yrange = [y_axis[0], y_axis[-1]+1]
  (*global_tof_selection).yrange = yrange
  
  WIDGET_CONTROL, wBase, SET_UVALUE = global_tof_selection
  
  XMANAGER, "discrete_selection_base", wBase, $
    GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup = 'discrete_selection_base_cleanup'
    
  discrete_selection_lin_log_data, base=wBase
  
  Data = (*(*global_tof_selection).data)
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='discrete_selection_draw')
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  
  cData = congrid(Data, xsize, ysize)
  
  id = widget_info(wBase, find_by_uname='discrete_selection_base_uname')
  geometry = widget_info(id,/geometry)
  _xsize = geometry.scr_xsize
  _ysize = geometry.scr_ysize
  
  (*global_tof_selection).congrid_xcoeff = xsize
  (*global_tof_selection).congrid_ycoeff = ysize
  
  DEVICE, DECOMPOSED = 0
  loadct, (*global_tof_selection).default_loadct, /SILENT
  
  plot_discrete_selection_beam_center_scale, base=wBase
  
  id = widget_info(wBase,find_by_uname='discrete_selection_draw')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  ;tvscl, transpose(cData)
  tvscl, cData
  
  ;Scale
  zmin = 0
  zmax = max((*(*global_tof_selection).data_linear))
  zrange = (*global_tof_selection).zrange
  zrange[0] = zmin
  zrange[1] = zmax
  
  (*global_tof_selection).zrange = zrange
  
  plot_discrete_selection_colorbar, base=wBase, $
    zmin, $
    zmax, $
    type=default_scale_settings
    
  pre = '>  > >> '
  post = ' << <  <'
  uname = 'discrete_selection_loadct_' + strcompress(default_loadct,/remove_all)
  value = getValue(base=wBase, uname=uname)
  new_value = pre + value + post
  setValue, base=wBase, uname, new_value
  
  save_discrete_selection_background,  main_base=wBase
  
  ;bring to life the refpix pixel1 and 2 input base
  discrete_selection_input_base, parent_base_uname = 'discrete_selection_base_uname', $
    top_base=wBase_copy1
  
  
  return
    
  ;bring to life the base that show counts vs tof
  discrete_selection_counts_vs_tof_base, $
    parent_base_uname='discrete_selection_base_uname', $
    top_base=wBase_copy
    
  ;display the already selected tof range ------------------------------------
  tof_min = tof_min_max[0]
  tof_max = tof_min_max[1]
  
  if (tof_min ne -1) then begin
  
    widget_control, wBase_copy, get_uvalue=global_tof_selection
    id = widget_info(wBase_copy, find_by_uname='discrete_selection_draw')
    widget_control, id, GET_VALUE = plot_id
    wset, plot_id
    
    tof_min_device = discrete_from_data_to_device(base=wBase_copy, tof_min)
    
    plots, tof_min_device, 0, fsc_color("green"),/device
    plots, tof_min_device, ysize, fsc_color("green"),/continue, linestyle=4,$
      /device
      
  endif
  
  if (tof_max ne -1) then begin
  
    widget_control, wBase_copy, get_uvalue=global_tof_selection
    id = widget_info(wBase_copy, find_by_uname='discrete_selection_draw')
    widget_control, id, GET_VALUE = plot_id
    wset, plot_id
    
    tof_max_device = discrete_from_data_to_device(base=wBase_copy, tof_max)
    
    plots, tof_max_device, 0, fsc_color("green"),/device
    plots, tof_max_device, ysize, fsc_color("green"),/continue, linestyle=4,$
      /device
      
  endif
  
end

