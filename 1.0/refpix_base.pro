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
pro refpix_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_refpix
  main_event = (*global_refpix).main_event
  
  case Event.id of
  
    widget_info(event.top, find_by_unam='plot_setting_untouched'): begin
      switch_local_settings_plot_values, event
      refresh_plot, event, recalculate=1
      return
    end
    widget_info(event.top, find_by_unam='plot_setting_interpolated'): begin
      switch_local_settings_plot_values, event
      refresh_plot, event, recalculate=1
      return
    end
    
    ;main draw
    widget_info(event.top, find_by_uname='refpix_draw'): begin
    
      catch, error
      if (error ne 0) then begin ;selection
        catch,/cancel
        
        show_refpix_cursor_info, event
        
        if (event.press eq 1) then begin ;left click
          (*global_refpix).left_click = 1b
          pixel_value = strcompress(retrieve_pixel_value(event),/remove_all)
          if ((*global_refpix).pixel1_selected) then begin
            uname = 'refpix_pixel1_uname'
          endif else begin
            uname = 'refpix_pixel2_uname'
          endelse
          putValue, base=(*global_refpix).refpix_input_base, uname, pixel_value
          save_refpixel_pixels, event
          display_refpixel_pixels, event=event
          
          return
        endif
        
        if (event.release eq 1 && $
          (*global_refpix).left_click eq 1b) then begin ;release button
          (*global_refpix).left_click = 0b
        endif
        
        if (event.press eq 4) then begin ;right click
          if ((*global_refpix).pixel1_selected) then begin
            (*global_refpix).pixel1_selected = 0b
          endif else begin
            (*global_refpix).pixel1_selected = 1b
          endelse
        endif
        
        if ((*global_refpix).left_click) then begin ;moving mouse
          pixel_value = strcompress(retrieve_pixel_value(event),/remove_all)
          if ((*global_refpix).pixel1_selected) then begin
            uname = 'refpix_pixel1_uname'
          endif else begin
            uname = 'refpix_pixel2_uname'
          endelse
          putValue, base=(*global_refpix).refpix_input_base, uname, pixel_value
          save_refpixel_pixels, event
          display_refpixel_pixels, event=event
        endif
        
      endif else begin ;entering or leaving widget_draw
      
        if (event.enter eq 0) then begin ;leaving plot
          file_name = (*global_refpix).file_name
          id = widget_info(event.top, find_by_uname='refpix_base_uname')
          widget_control, id, tlb_set_title=file_name
          
        endif else begin ;entering plot
        
        endelse
      endelse
    end
    
    ;main base
    widget_info(event.top, find_by_uname='refpix_base_uname'): begin
    
      id = widget_info(event.top, find_by_uname='refpix_base_uname')
      ;widget_control, id, /realize
      geometry = widget_info(id,/geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      xoffset = geometry.xoffset
      yoffset = geometry.yoffset
      
      ;only if the refpix input base is there
      id_refpix = (*global_refpix).refpix_input_base
      if (widget_info(id_refpix, /valid_id) ne 0) then begin
        widget_control, id_refpix, xoffset = xoffset + new_xsize
        widget_control, id_refpix, yoffset = yoffset
      endif
      
      ;      id_cursor = (*global_refpix).refpix_cursor_info_base
      ;      if (widget_info(id_cursor,/valid_id) ne 0) then begin
      ;        widget_control, id_cursor, xoffset = xoffset + new_xsize
      ;        widget_control, id_cursor, yoffset = yoffset + 170
      ;      endif
      ;
      if ((abs((*global_refpix).xsize - new_xsize) eq 70.0) && $
        abs((*global_refpix).ysize - new_ysize) eq 33.0) then return
        
      if ((abs((*global_refpix).xsize - new_xsize) eq 0.0) && $
        abs((*global_refpix).ysize - new_ysize) eq 33.0) then return
        
      (*global_refpix).xsize = new_xsize
      (*global_refpix).ysize = new_ysize
      
      widget_control, id, xsize = new_xsize
      widget_control, id, ysize = new_ysize
      
      border = (*global_refpix).border
      colorbar_xsize = (*global_refpix).colorbar_xsize
      
      id = widget_info(event.top, find_by_uname='refpix_draw')
      widget_control, id, draw_xsize = new_xsize-2*border-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize-2*border
      
      id = widget_info(event.top,find_by_Uname='refpix_scale')
      widget_control, id, draw_xsize = new_xsize-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize
      
      id = widget_info(event.top, find_by_uname='refpix_colorbar')
      widget_control, id, xoffset=new_xsize-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize
      widget_control, id, draw_xsize = colorbar_xsize
      
      plot_refpix_beam_center_scale, event=event
      refresh_refpix_plot, event, recalculate=1
      refresh_plot_refpix_colorbar, event
      display_refpixel_pixels, event=event
      
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
      find_by_uname='show_pixel_selection_base'): begin
      pixel_base = (*global_refpix).refpix_input_base
      if (widget_info(pixel_base, /valid_id) eq 0) then begin
        refpix_input_base, parent_base_uname = 'refpix_base_uname', $
          top_base = (*global_refpix).top_biase, $
          event=event
      endif
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    Save the pixels1 and 2 in data coordinates
;
; :Params:
;    event
;
; :Author: j35
;-
pro save_refpixel_pixels, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_refpix
  
  refpix_input_base = (*global_refpix).refpix_input_base
  
  pixel1 = getValue(base=refpix_input_base, uname='refpix_pixel1_uname')
  pixel2 = getValue(base=refpix_input_base, uname='refpix_pixel2_uname')
  
  refpix_pixels = [pixel1, pixel2]
  
  (*global_refpix).refpix_pixels = refpix_pixels
  
end

;+
; :Description:
;    Go from device to data coordinates
;
; :Params:
;    data
;
; :Author: j35
;-
function from_device_to_data, event, ydata
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_refpix
  
  ysize = (*global_refpix).ysize
  yrange = (*global_refpix).yrange
  border = (*global_refpix).border
  _ysize = ysize-2*border
  
  print, 'ysize: ' , _ysize
  print, 'yrange[1]: ', yrange[1]
  print, 'ydata: ' , ydata
  print
  
  ydevice = float(ydata)*float(_ysize)/float(yrange[1])
  
  return, ydevice
  
end

;+
; :Description:
;    refresh the background and display the two pixels
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro display_refpixel_pixels, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_refpix
  
  id = widget_info(event.top, find_by_uname='refpix_draw')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  TV, (*(*global_refpix).background), true=3
  
  refpix_pixels = (*global_refpix).refpix_pixels ;in data coordinates
  
  pixel1_data = refpix_pixels[0]
  pixel2_data = refpix_pixels[1]
  
  pixel1_device = from_device_to_data(event, pixel1_data)
  pixel2_device = from_device_to_data(event, pixel2_data)
  
  xsize = (*global_refpix).xsize
  
  if (pixel1_device gt 0) then begin
  plots, [0, 0, xsize, xsize, 0],$
    [pixel1_device, pixel1_device, pixel1_device, pixel1_device, pixel1_device],$
    /DEVICE,$
    LINESTYLE = 3,$
    COLOR = fsc_color("white")
    endif
    
    if (pixel2_device gt 0) then begin
  plots, [0, 0, xsize, xsize, 0],$
    [pixel2_device, pixel2_device, pixel2_device, pixel2_device, pixel2_device],$
    /DEVICE,$
    LINESTYLE = 3,$
    COLOR = fsc_color("white")
    endif
    
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
  
  widget_control, event.top, get_uvalue=global_refpix
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, 'N/A'
  endif
  
  y_device = event.y
  congrid_ycoeff = (*global_refpix).congrid_ycoeff
  yrange = float((*global_refpix).yrange) ;min and max pixels
  
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
pro show_refpix_cursor_info, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_refpix
  
  data = (*(*global_refpix).full_data)
  x_axis = (*global_refpix).x_axis
  y_axis = (*global_refpix).y_axis
  
  xcoeff = (*global_refpix).congrid_xcoeff
  ycoeff = (*global_refpix).congrid_ycoeff
  
  tof_value = strcompress(retrieve_tof_value(event),/remove_all)
  pixel_value = strcompress(retrieve_pixel_value(event),/remove_all)
  counts_value = strcompress(retrieve_counts_value(event),/remove_all)
  
  file_name = (*global_refpix).file_name
  
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
  id = widget_info(event.top, find_by_uname='refpix_base_uname')
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
pro save_refpix_background,  event=event, main_base=main_base, uname=uname
  compile_opt idl2
  
  if (~keyword_set(uname)) then uname = 'refpix_draw'
  
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME=uname)
    widget_control, main_base, get_uvalue=global_refpix
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, event.top, GET_UVALUE=global_refpix
    id = WIDGET_INFO(Event.top,find_by_uname=uname)
  ENDELSE
  
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize   = geometry.xsize
  ysize   = geometry.ysize
  
  ;DEVICE, copy =[0, 0, xsize, ysize, 0, 0, id_value]
  DEVICE, copy =[0, 0, xsize, ysize, 0, 0]
  
  (*(*global_refpix).background) = background
  
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
pro refpix_lin_log_data, event=event, base=base
  compile_opt idl2
  
  ;get global structure
  if (n_elements(event) ne 0) then begin
    widget_control,event.top,get_uvalue=global_refpix
  endif else begin
    widget_control, base, get_uvalue=global_refpix
  endelse
  
  Data = (*(*global_refpix).data_linear)
  scale_setting = (*global_refpix).default_scale_settings ;0 for lin, 1 for log
  
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
  
  (*(*global_refpix).data) = Data
  
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
pro refresh_refpix_plot, event, recalculate=recalculate
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_refpix
  
  if (n_elements(recalculate) eq 0) then begin
    id = widget_info(event.top, find_by_uname='refpix_draw')
    widget_control, id, GET_VALUE = plot_id
    wset, plot_id
    TV, (*(*global_refpix).background), true=3
    return
  endif
  
  Data = (*(*global_refpix).data)
  new_xsize = (*global_refpix).xsize
  new_ysize = (*global_refpix).ysize
  
  id = WIDGET_INFO(event.top, FIND_BY_UNAME='refpix_draw')
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  
  ;  if ((*global_plot).plot_setting eq 'untouched') then begin
  cData = congrid(Data, xsize, ysize)
  ;  endif else begin
  ;    cData = congrid(Data, ysize, xsize,/interp)
  ;  endelse
  (*global_refpix).congrid_xcoeff = xsize
  (*global_refpix).congrid_ycoeff = ysize
  
  id = widget_info(event.top, find_by_uname='refpix_draw')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  erase
  
  loadct, (*global_refpix).default_loadct, /silent
  
  tvscl, cData
  
  save_refpix_background, event=event
  
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
pro refpix_local_switch_axes_type, event
  compile_opt idl2
  
  uname = widget_info(event.id, /uname)
  widget_control, event.top, get_uvalue=global_refpix
  
  if (uname eq 'refpix_local_scale_setting_linear') then begin
    set1_value = '*  ' + 'linear'
    set2_value = '   ' + 'logarithmic'
    (*global_refpix).default_scale_settings = 0
  endif else begin
    set1_value = '   ' + 'linear'
    set2_value = '*  ' + 'logarithmic'
    (*global_refpix).default_scale_settings = 1
  endelse
  
  putValue, event=event, 'refpix_local_scale_setting_linear', set1_value
  putValue, event=event, 'refpix_local_scale_setting_log', set2_value
  
  refpix_lin_log_data, event=event
  refresh_refpix_plot, event, recalculate=1
  refresh_plot_refpix_colorbar, event
  
  save_refpix_background,  event=event
  
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
pro change_refpix_loadct, event
  compile_opt idl2
  
  new_uname = widget_info(event.id, /uname)
  widget_control,event.top,get_uvalue=global_refpix
  
  ;get old loadct
  old_loadct = strcompress((*global_refpix).default_loadct,/remove_all)
  old_uname = 'refpix_loadct_' + old_loadct
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
  (*global_refpix).default_loadct = fix(new_uname_array[2])
  
  ;replot
  refresh_refpix_plot, event, recalculate=1
  refresh_plot_refpix_colorbar, event
  
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
pro refpix_base_uname_killed, global_refpix
  compile_opt idl2
  
  id_refpix = (*global_refpix).refpix_input_base
  if (widget_info(id_refpix, /valid_id) ne 0) then begin
    widget_control, id_refpix, /destroy
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
pro plot_refpix_beam_center_scale, base=base, event=event
  compile_opt idl2
  
  if (n_elements(base) ne 0) then begin
    id = widget_info(base,find_by_Uname='refpix_scale')
    id_base = widget_info(base, find_by_uname='refpix_base_uname')
    sys_color = widget_info(base,/system_colors)
    widget_control, base, get_uvalue=global_refpix
  endif else begin
    id = widget_info(event.top, find_by_uname='refpix_scale')
    id_base = widget_info(event.top, find_by_uname='refpix_base_uname')
    sys_color = widget_info(event.top, /system_colors)
    widget_control, event.top, get_uvalue=global_refpix
  endelse
  
  widget_control, id, get_value=id_value
  wset, id_value
  
  ;change color of background
  device, decomposed=1
  sys_color_window_bk = sys_color.window_bk
  
  x_range = (*global_refpix).xrange
  min_x = x_range[0]
  max_x = x_range[1]
  
  y_range = (*global_refpix).yrange
  min_y = y_range[0]
  max_y = y_range[1]
  
  ;determine the number of xaxis data to show
  geometry = widget_info(id_base,/geometry)
  xsize = geometry.scr_xsize
  
  print, max_y
  
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
pro refpix_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_refpix, /no_copy
  
  refpix_base_uname_killed, global_refpix
  
  if (n_elements(global_refpix) eq 0) then return
  
  ptr_free, (*global_refpix).full_data
  ptr_free, (*global_refpix).data
  ptr_free, (*global_refpix).data_linear
  ptr_free, (*global_refpix).background
  ptr_free, (*global_refpix).counts_vs_qx_xaxis
  ptr_free, (*global_refpix).counts_vs_qx_data
  ptr_free, (*global_refpix).counts_vs_qz_xaxis
  ptr_free, (*global_refpix).counts_vs_qz_data
  
  ptr_free, global_refpix
  
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
pro refpix_base_gui, wBase, $
    main_base_geometry, $
    global, $
    offset, $
    border, $
    colorbar_xsize, $
    file_name = file_name, $
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
  
  ysize_refpix_row = 0 ;vertical size of refpix row
  
  ourGroup = WIDGET_BASE()
  
  title = file_name
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'refpix_base_uname', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = ysize+ysize_refpix_row,$
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
    uname = 'refpix_draw')
    
  scale = widget_draw(wBase,$
    uname = 'refpix_scale',$
    scr_xsize = xsize,$
    scr_ysize = ysize,$
    retain=2)
    
  colorbar =  widget_draw(wBase,$
    uname = 'refpix_colorbar',$
    xoffset = xsize,$
    scr_xsize = colorbar_xsize,$
    scr_ysize = ysize,$
    retain=2)
    
  ;  ;refpix selection row
  ;  row2 = widget_base(wBase,$
  ;  xoffset = 0,$
  ;  yoffset = ysize,$
  ;  /row)
  ;
  ;  space = widget_label(row2, $
  ;  value = '    ')
  ;  pixel1 = cw_field(row2, $
  ;  title = 'Pixel 1:', $
  ;  /integer, $
  ;  xsize = 3, $
  ;  /return_events, $
  ;  /row, $
  ;  value = '')
  ;
  ;  pixel2 = cw_field(row2, $
  ;  title = '    Pixel 2:', $
  ;  /integer, $
  ;  xsize = 3, $
  ;  /return_events, $
  ;  /row, $
  ;  value = '')
  ;
  ;  label = widget_label(row2,$
  ;  value = '     ----->     refpix:')
  ;  refpix = widget_label(row2,$
  ;  value = 'N/A',$
  ;  scr_xsize = 50,$
  ;  /align_left,$
  ;  uname = 'refpix_value')
    
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
    uname = 'refpix_loadct_0',$
    event_pro = 'change_refpix_loadct',$
    /separator)
    
  sz = n_elements(list_loadct)
  for i=1L,(sz-1) do begin
    set = widget_button(mPlot,$
      value = list_loadct[i],$
      uname = 'refpix_loadct_' + strcompress(i,/remove_all),$
      event_pro = 'change_refpix_loadct')
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
    event_pro = 'refpix_local_switch_axes_type',$
    uname = 'refpix_local_scale_setting_linear')
    
  set2 = widget_button(mPlot, $
    value = set2_value,$
    event_pro = 'refpix_local_switch_axes_type',$
    uname = 'refpix_local_scale_setting_log')
    
  pixel = widget_button(bar1,$
    value = 'Pixels selection',$
    /menu)
    
  show = widget_button(pixel,$
    value = 'Show pixel selection window',$
    uname = 'show_pixel_selection_base')
    
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
;    row_index    row used to plot NeXus file
;    x_axis       (ex:Array of float [52])
;    y_axis       (ex:Array of int [304])
;    data         (ex:Array of ulong [51,256,304])
;    file_name    (ex:REF_M_3454.nxs)
;
; :Author: j35
;-
pro refpix_base, main_base=main_base, $
    event=event, $
    row_index = row_index, $
    offset = offset, $
    x_axis = x_axis, $
    y_axis = y_axis, $
    data = data, $
    file_name = file_name
    
  compile_opt idl2
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='main_base')
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
  refpix_base_gui, wBase, $
    main_base_geometry, $
    global, $
    offset, $
    border, $
    colorbar_xsize, $
    file_name = file_name, $
    scale_setting = default_scale_setting,$
    default_plot_size = default_plot_size
  _wBase = wBase
  
  WIDGET_CONTROL, wBase, /REALIZE
  
  global_refpix = PTR_NEW({ wbase: wbase,$
    global: global, $
    
    row_index: row_index, $
    
    file_name: file_name, $
    
    refpix_input_base: 0L, $ ;id of refpix_input_base
    ;    refpix_cursor_info_base: 0L, $ 'id of refpix_cursor_info_base
    
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
    
    x_axis: x_axis, $ ; [-0.004, -0.003, -0.002...]
    y_axis: y_axis, $ ; [0.0, 0.1, 0.2, 0.3]
    
    ;pointers used to output the counts vs qx/qz ascii files
    counts_vs_qx_xaxis: ptr_new(0L), $
    counts_vs_qx_data: ptr_new(0L), $
    counts_vs_qz_xaxis: ptr_new(0L), $
    counts_vs_qz_data: ptr_new(0L), $
    
    shift_key_status: 0b, $ ;when range is selected to produce 2d plots
    QxQzrange: fltarr(2), $ ; [Qx0, Qz0]
    EventRangeSelection: intarr(2), $ ;[event.x, event.y] when using first shift left click
    
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
    refpix_pixels: lonarr(2), $ ;pixels 1 and 2 in data coordinates
    
    congrid_xcoeff: 0., $ ;x coeff used in the congrid function to plot main data
    congrid_ycoeff: 0., $ ;y coeff used in the congrid function to plot main data
    
    ;plot_setting1: plot_setting1,$
    ;plot_setting2: plot_setting2,$
    ;plot_setting: current_plot_setting,$ ;untouched or interpolated
    
    top_base: wBase, $
    main_event: event})
    
  (*(*global_refpix).full_data) = data
  
  data_2d = total(data,2)
  
  (*(*global_refpix).data_linear) = data_2d
  (*(*global_refpix).data) = data_2d
  
  xrange = [x_axis[0], x_axis[-1]]
  (*global_refpix).xrange = xrange
  
  yrange = [y_axis[0], y_axis[-1]+1]
  (*global_refpix).yrange = yrange
  
  WIDGET_CONTROL, wBase, SET_UVALUE = global_refpix
  
  XMANAGER, "refpix_base", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK, $
    cleanup = 'refpix_base_cleanup'
    
  refpix_lin_log_data, base=wBase
  
  Data = (*(*global_refpix).data)
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='refpix_draw')
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  ;  if ((*global_plot).plot_setting eq 'untouched') then begin
  
  cData = congrid(Data, xsize, ysize)
  
  id = widget_info(wBase, find_by_uname='refpix_base_uname')
  geometry = widget_info(id,/geometry)
  _xsize = geometry.scr_xsize
  _ysize = geometry.scr_ysize
  
  ;  (*global_plot).congrid_xcoeff = _xsize-2*border-colorbar_xsize
  ;  (*global_plot).congrid_ycoeff = _ysize-2*border
  
  (*global_refpix).congrid_xcoeff = xsize
  (*global_refpix).congrid_ycoeff = ysize
  
  DEVICE, DECOMPOSED = 0
  loadct, (*global_refpix).default_loadct, /SILENT
  
  plot_refpix_beam_center_scale, base=wBase
  
  id = widget_info(wBase,find_by_uname='refpix_draw')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  ;tvscl, transpose(cData)
  tvscl, cData
  
  ;Scale
  zmin = 0
  zmax = max((*(*global_refpix).data_linear))
  zrange = (*global_refpix).zrange
  zrange[0] = zmin
  zrange[1] = zmax
  
  (*global_refpix).zrange = zrange
  
  plot_refpix_colorbar, base=wBase, zmin, zmax, type=default_scale_settings
  
  pre = '>  > >> '
  post = ' << <  <'
  uname = 'refpix_loadct_' + strcompress(default_loadct,/remove_all)
  value = getValue(base=wBase, uname=uname)
  new_value = pre + value + post
  setValue, base=wBase, uname, new_value
  
  save_refpix_background,  main_base=wBase
  
  ;bring to life the refpix pixel1 and 2 input base
  refpix_input_base, parent_base_uname = 'refpix_base_uname', $
    top_base=wBase
    
;  ;bring to life the cursor information
;  refpix_cursor_info_base, parent_base_uname='refpix_base_uname', $
;    top_base=_wBase
    
end

