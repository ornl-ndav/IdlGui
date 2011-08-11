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
pro px_vs_tof_plots_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_plot
  main_event = (*global_plot).main_event
  
  case Event.id of
  
    widget_info(event.top, find_by_unam='rtof_plot_setting_untouched'): begin
      rtof_switch_local_settings_plot_values, event
      rtof_refresh_plot, event, recalculate=1
      return
    end
    widget_info(event.top, find_by_unam='rtof_plot_setting_interpolated'): begin
      rtof_switch_local_settings_plot_values, event
      rtof_refresh_plot, event, recalculate=1
      return
    end
    
    widget_info(event.top, find_by_uname='px_vs_tof_widget_base'): begin
    
      id = widget_info(event.top, find_by_uname='px_vs_tof_widget_base')
      ;widget_control, id, /realize
      geometry = widget_info(id,/geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      
      (*global_plot).xsize = new_xsize
      (*global_plot).ysize = new_ysize
      
      widget_control, id, xsize = new_xsize
      widget_control, id, ysize = new_ysize
      
      border = (*global_plot).border
      colorbar_xsize = (*global_plot).colorbar_xsize
      
      id = widget_info(event.top, find_by_uname='draw_rtof')
      widget_control, id, draw_xsize = new_xsize-2*border-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize-2*border
      
      id = widget_info(event.top,find_by_Uname='scale')
      widget_control, id, draw_xsize = new_xsize-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize
      
      id = widget_info(event.top, find_by_uname='colorbar')
      widget_control, id, xoffset=new_xsize-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize
      widget_control, id, draw_xsize = colorbar_xsize
      
      rtof_plot_beam_center_scale, event=event
      rtof_refresh_plot, event, recalculate=1
      rtof_refresh_plot_colorbar, event
      
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
    
    else:
    
  endcase
  
end

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
pro rtof_lin_log_data, event=event, base=base
  compile_opt idl2
  
  ;get global structure
  if (n_elements(event) ne 0) then begin
    widget_control,event.top,get_uvalue=global_plot
  endif else begin
    widget_control, base, get_uvalue=global_plot
  endelse
  
  Data = (*(*global_plot).data_linear)
  scale_setting = (*global_plot).default_scale_settings ;0 for lin, 1 for log
  
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
  
  (*(*global_plot).data) = Data
  
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
pro rtof_refresh_plot, event, recalculate=recalculate
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_plot
  
    id = widget_info(event.top, find_by_uname='draw_rtof')
    widget_control, id, GET_VALUE = plot_id
    wset, plot_id

  if (n_elements(recalculate) eq 0) then begin
    TV, (*(*global_plot).background), true=3
    return
  endif
  
  Data = (*(*global_plot).data)
  new_xsize = (*global_plot).xsize
  new_ysize = (*global_plot).ysize
  border = (*global_plot).border
  colorbar_xsize = (*global_plot).colorbar_xsize
  
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  
  if ((*global_plot).plot_setting eq 'untouched') then begin
    cData = congrid(Data, ysize, xsize)
  endif else begin
    cData = congrid(Data, ysize, xsize,/interp)
  ;    cData = congrid(Data, new_ysize-2*border, new_xsize-2*border-colorbar_xsize,/interp)
  endelse
  (*global_plot).congrid_xcoeff = ysize
  (*global_plot).congrid_ycoeff = xsize
  
  erase
  
  loadct, (*global_plot).default_loadct, /silent
  
  tvscl, transpose(cData)
  
  save_background, event=event, uname='draw_rtof'
  
end

;+
; :Description:
;    Switch local label of plot settings button
;    validated.
;    add * at the beginning of string when button is validated
;
; :Params:
;    event
;
; :Author: j35
;-
pro rtof_switch_local_settings_plot_values, event
  compile_opt idl2
  
  widget_control,event.top,get_uvalue=global_plot
  
  plot_setting1 = (*global_plot).plot_setting1
  plot_setting2 = (*global_plot).plot_setting2
  
  set1_value = getValue(event=event, uname='rtof_plot_setting_untouched')
  
  if (set1_value eq ('   ' + plot_setting1)) then begin ;setting1 needs to be checked
    set1_value = '*  ' + plot_setting1
    set2_value = '   ' + plot_setting2
    (*global_plot).plot_setting = 'untouched'
  endif else begin
    set1_value = '   ' + plot_setting1
    set2_value = '*  ' + plot_setting2
    (*global_plot).plot_setting = 'interpolated'
  endelse
  
  putValue, event=event, 'rtof_plot_setting_untouched', set1_value
  putValue, event=event, 'rtof_plot_setting_interpolated', set2_value
  
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
pro rtof_change_loadct, event
  compile_opt idl2
  
  new_uname = widget_info(event.id, /uname)
  widget_control,event.top,get_uvalue=global_plot
  
  ;get old loadct
  old_loadct = strcompress((*global_plot).default_loadct,/remove_all)
  old_uname = 'loadct_' + old_loadct
  label = getValue(event=event,uname=old_uname)
  ;remove keep central part
  raw_label1 = strsplit(label,'>>',/regex,/extract)
  raw_label2 = strsplit(raw_label1[1],'<<',/regex,/extract)
  raw_label = strcompress(raw_label2[0],/remove_all)
  ;put it back
  putValue, event=event, old_uname, raw_label
  
  ;change value of new loadct
  new_label = getValue(event=event, uname=new_uname)
  new_label = strcompress(new_label,/remove_all)
  ;add selection string
  new_label = '>  > >> ' + new_label + ' << <  <'
  putValue, event=event, new_uname, new_label
  
  ;save new loadct
  new_uname_array = strsplit(new_uname,'_',/extract)
  (*global_plot).default_loadct = fix(new_uname_array[1])
  
  ;replot
  rtof_refresh_plot, event, recalculate=1
  rtof_refresh_plot_colorbar, event
  
end

;+
; :Description:
;   Reached when the settings base is killed
;
; :Params:
;    global_plot
;
; :Author: j35
;-
pro rtof_px_vs_tof_widget_killed, global_plot
  compile_opt idl2
  
  main_event = (*global_plot).main_event
  
  info_base = (*global_plot).cursor_info_base
  ;if x,y and counts base is on, shows live values of x,y and counts
  if (widget_info(info_base, /valid_id) ne 0) then begin
    widget_control, info_base, /destroy
  endif
  
  ;close the xaxis info if openned
  xaxis_info_base = (*global_plot).counts_vs_xaxis_base
  if (widget_info(xaxis_info_base, /valid_id) ne 0) then begin
    widget_control, xaxis_info_base, /destroy
  endif
  
  ;close the yaxis info if openned
  yaxis_info_base = (*global_plot).counts_vs_yaxis_base
  if (widget_info(yaxis_info_base, /valid_id) ne 0) then begin
    widget_control, yaxis_info_base, /destroy
  endif
  
end

;+
; :Description:
;    Shows the cursor, counts vs pixel and counts vs tof bases
;
; :Params:
;    event
;
; :Author: j35
;-
pro rtof_show_all_info, event
  compile_opt idl2
  
  rtof_show_cursor_info, event
  rtof_show_counts_vs_xaxis, event
  rtof_show_counts_vs_yaxis, event
  
end

;+
; :Description:
;    show the cursor info base
;
; :Params:
;    event
;
; :Author: j35
;-
pro rtof_show_cursor_info, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  
  info_base = (*global_plot).cursor_info_base
  
  if (widget_info(info_base, /valid_id) EQ 0) THEN BEGIN
    parent_base_uname = 'px_vs_tof_widget_base'
    rtof_cursor_info_base, event=event, $
      parent_base_uname=parent_base_uname
  endif
  
end

;+
; :Description:
;    show the counts vs tof (lambda) base
;
; :Params:
;    event
;
; :Author: j35
;-
pro rtof_show_counts_vs_xaxis, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  
  counts_vs_xaxis_plot_id = (*global_plot).counts_vs_xaxis_base
  if (obj_valid(counts_vs_xaxis_plot_id) eq 0) then begin ;no plot yet
    rtof_counts_vs_axis_base, event=event, $
      parent_base_uname = 'px_vs_tof_widget_base', $
      xaxis = 'tof'
  endif
  
end

;+
; :Description:
;    show the counts vs pixel (angle) base
;
; :Params:
;    event
;
; :Author: j35
;-
pro rtof_show_counts_vs_yaxis, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_plot
  
  counts_vs_yaxis_plot_id = (*global_plot).counts_vs_yaxis_base
  if (obj_valid(counts_vs_yaxis_plot_id) eq 0) then begin ;no plot yet
    rtof_counts_vs_axis_base, event=event, $
      parent_base_uname = 'px_vs_tof_widget_base', $
      xaxis = 'pixel'
  endif
  
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
pro px_vs_tof_plots_base_gui, wBase, $
    main_base_geometry, $
    global, $
    file_name, $
    offset, $
    border, $
    colorbar_xsize, $
    plot_setting1 = plot_setting1,$
    plot_setting2 = plot_setting2, $
    current_plot_setting = current_plot_setting, $
    scale_setting = scale_setting
    
  compile_opt idl2
  
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 600
  ysize = 600
  
  xoffset = (main_base_xsize - xsize) / 2
  xoffset += main_base_xoffset
  xoffset += offset
  
  yoffset = (main_base_ysize - ysize) / 2
  yoffset += main_base_yoffset
  yoffset += offset
  
  ourGroup = WIDGET_BASE()
  
  title = 'Pixel vs TOF of ' + file_name
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'px_vs_tof_widget_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = ysize,$
    SCR_XSIZE    = xsize+colorbar_xsize,$
    MAP          = 1,$
    ;    kill_notify  = 'px_vs_tof_widget_killed', $
    /BASE_ALIGN_CENTER,$
    /align_center,$
    /tlb_size_events,$
    mbar = bar1,$
    GROUP_LEADER = ourGroup)
    
  mPlot = widget_button(bar1, $
    value = 'Type ',$
    /menu)
    
  if (current_plot_setting eq 'untouched') then begin
    set2_value = '*  ' + plot_setting1
    set1_value = '   ' + plot_setting2
  endif else begin
    set2_value = '   ' + plot_setting1
    set1_value = '*  ' + plot_setting2
  endelse
  
  set2 = widget_button(mPlot, $
    value = set2_value,$
    uname = 'rtof_plot_setting_untouched')
    
  set1 = widget_button(mPlot, $
    value = set1_value,$
    uname = 'rtof_plot_setting_interpolated')
    
  list_loadct = ['B-W Linear',$
    'Blue/White',$
    'Green-Red-Blue-White',$
    'Red temperature',$
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
    uname = 'loadct_0',$
    event_pro = 'rtof_change_loadct',$
    /separator)
    
  sz = n_elements(list_loadct)
  for i=1L,(sz-1) do begin
    set = widget_button(mPlot,$
      value = list_loadct[i],$
      uname = 'loadct_' + strcompress(i,/remove_all),$
      event_pro = 'rtof_change_loadct')
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
    event_pro = 'rtof_local_switch_axes_type',$
    uname = 'local_scale_setting_linear')
    
  set2 = widget_button(mPlot, $
    value = set2_value,$
    event_pro = 'rtof_local_switch_axes_type',$
    uname = 'local_scale_setting_log')
    
  info = widget_button(bar1, $
    value = 'Infos',$
    /menu)
    
  set = widget_button(info, $
    value = 'Show all',$
    event_pro = 'rtof_show_all_info',$
    uname = 'show_all_info_uname')
    
  set1 = widget_button(info, $
    /separator,$
    value = 'Show Cursor Infos',$
    event_pro = 'rtof_show_cursor_info',$
    uname = 'show_or_hide_cursor_info_uname')
    
  set2 = widget_button(info, $
    value = 'Show Counts vs xaxis at cursor y position',$
    event_pro = 'rtof_show_counts_vs_xaxis',$
    uname = 'show_counts_vs_xaxis_uname')
    
  set3 = widget_button(info, $
    value = 'Show Counts vs yaxis at cursor x position',$
    event_pro = 'rtof_show_counts_vs_yaxis',$
    uname = 'show_counts_vs_yaxis_uname')
    
  ;-------- end of menu
    
  draw = widget_draw(wbase,$
    xoffset = border,$
    yoffset = border,$
    scr_xsize = xsize-2*border,$
    scr_ysize = ysize-2*border,$
    /button_events,$
    /motion_events,$
    /tracking_events,$
    retain=2, $
    event_pro = 'draw_rtof_eventcb',$
    uname = 'draw_rtof')
    
  scale = widget_draw(wBase,$
    uname = 'scale',$
    scr_xsize = xsize,$
    scr_ysize = ysize,$
    retain=2)
    
  colorbar =  widget_draw(wBase,$
    uname = 'colorbar',$
    xoffset = xsize,$
    scr_xsize = colorbar_xsize,$
    scr_ysize = ysize,$
    retain=2)
    
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
pro rtof_plot_beam_center_scale, base=base, event=event
  compile_opt idl2
  
  if (n_elements(base) ne 0) then begin
    id = widget_info(base,find_by_Uname='scale')
    id_base = widget_info(base, find_by_uname='px_vs_tof_widget_base')
    sys_color = widget_info(base,/system_colors)
    widget_control, base, get_uvalue=global_plot
  endif else begin
    id = widget_info(event.top, find_by_uname='scale')
    id_base = widget_info(event.top, find_by_uname='px_vs_tof_widget_base')
    sys_color = widget_info(event.top, /system_colors)
    widget_control, event.top, get_uvalue=global_plot
  endelse
  
  widget_control, id, get_value=id_value
  wset, id_value
  
  ;change color of background
  device, decomposed=1
  sys_color_window_bk = sys_color.window_bk
  
  tof_axis = (*global_plot).tof_axis
  
  min_x = tof_axis[0]
  max_x = tof_axis[1]
  
  ;minimum and maximum pixel
  nbr_pixel = (*global_plot).nbr_pixel
  min_y = (*global_plot).start_pixel
  max_y = min_y + nbr_pixel
  
  ;determine the number of xaxis data to show
  geometry = widget_info(id_base,/geometry)
  xsize = geometry.scr_xsize
  ;ysize = geometry.scr_ysize
  xticks = fix(xsize / 100)
  yticks = (max_y - min_y)
  
  xmargin = 6.6
  ymargin = 4
  
  xrange = [min_x, max_x]
  (*global_plot).xrange = xrange
  
  yrange = [min_y, max_y]
  (*global_plot).yrange = yrange
  
  ticklen = -0.0015
  
  plot, randomn(s,80), $
    XRANGE     = xrange,$
    YRANGE     = yrange,$
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
    XTITLE      = 'TOF (!4l!Xs)',$
    ;    YTITLE      = 'Pixels',$
    XMARGIN     = [xmargin, xmargin+0.2],$
    YMARGIN     = [ymargin, ymargin],$
    /NODATA
  axis, yaxis=1, YRANGE=yrange, YTICKS=yticks, YSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = ticklen
  axis, xaxis=1, XRANGE=xrange, XTICKS=xticks, XSTYLE=1, $
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
pro px_vs_tof_plots_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_plot, /no_copy
  
  rtof_px_vs_tof_widget_killed, global_plot
  
  if (n_elements(global_plot) eq 0) then return
  
  ptr_free, (*global_plot).data
  ptr_free, (*global_plot).data_linear
  
  ptr_free, global_plot
  
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
  
  rtof_lin_log_data, base=wBase
  
  ;number of pixels
  (*global_plot).nbr_pixel = (size(data_y))[1] ;nbr of pixels to plot
  
  Data = (*(*global_plot).data)
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='draw_rtof')
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  if ((*global_plot).plot_setting eq 'untouched') then begin
    ;cData = congrid(Data, default_plot_size[0]-2*border, default_plot_size[1]-2*border-colorbar_xsize)
    cData = congrid(Data, ysize, xsize)
  endif else begin
    cData = congrid(Data, ysize, xsize,/interp)
  endelse
  
  border = (*global_plot).border
  colorbar_xsize = (*global_plot).colorbar_xsize
  
  id = widget_info(wBase, find_by_uname='px_vs_tof_widget_base')
  geometry = widget_info(id,/geometry)
  _xsize = geometry.scr_xsize
  _ysize = geometry.scr_ysize
  (*global_plot).congrid_xcoeff = _ysize-2*border
  (*global_plot).congrid_ycoeff = _xsize-2*border-colorbar_xsize
  
  DEVICE, DECOMPOSED = 0
  loadct, default_loadct, /SILENT
  
  rtof_plot_beam_center_scale, base=wBase
  
  id = widget_info(wBase,find_by_uname='draw_rtof')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  tvscl, transpose(cData)
  
  zmin = 0
  zmax = max(Data)
  zrange = (*global_plot).zrange
  zrange[0] = zmin
  zrange[1] = zmax
  (*global_plot).zrange = zrange
  rtof_plot_colorbar, base=wBase, zmin, zmax, type=default_scale_settings
  
  ;change label of default loadct
  pre = '>  > >> '
  post = ' << <  <'
  uname = 'loadct_' + strcompress(default_loadct,/remove_all)
  value = getValue(base=wBase, uname)
  new_value = pre + value + post
  setValue, base=wBase, uname, new_value
  
  save_background,  main_base=wBase, uname='draw_rtof'
  
end

;+
; :Description:
;     Creates the base and plot the pixel vs tof of the
;     given file index
;
; :Keywords:
;    main_base
;    event
;
; :Author: j35
;-
pro px_vs_tof_plots_base, main_base=main_base, $
    event=event, $
    file_name = file_name, $
    offset = offset, $
    default_loadct = default_loadct, $
    default_scale_settings = default_scale_settings, $
    default_plot_size = default_plot_size, $
    current_plot_setting = current_plot_setting, $
    Data_x = Data_x, $
    Data_y = Data_y, $ ;Data_y
    start_pixel = start_pixel, $
    main_base_uname = main_base_uname
    
  compile_opt idl2
  
  if (n_elements(spin_state) eq 0) then spin_state = 0
  if (~keyword_set(default_scale_settings)) then default_scale_settings=1
  if (~keyword_set(default_plot_size)) then default_plot_size = [300,300]
  if (~keyword_set(default_loadct)) then default_loadct=5
  if (~keyword_set(current_plot_setting)) then current_plot_setting='untouched'
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=main_base_uname)
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;SETUP
  border = 40
  colorbar_xsize = 70
  
  plot_setting1 = 'Untouched plots'
  plot_setting2 = 'Interpolated plots'
  
  ;build gui
  wBase = ''
  px_vs_tof_plots_base_gui, wBase, $
    main_base_geometry, $
    global, $
    file_name, $
    offset, $
    border, $
    colorbar_xsize, $
    plot_setting1 = plot_setting1,$
    plot_setting2 = plot_setting2, $
    current_plot_setting = current_plot_setting, $
    scale_setting = default_scale_settings
  ;(*global).auto_scale_plot_base = wBase
  
  WIDGET_CONTROL, wBase, /REALIZE
  
  global_plot = PTR_NEW({ wbase: wbase,$
    global: global, $
    
    ;used to plot selection zoom
    file_name: file_name, $
    default_plot_size: default_plot_size, $
    
    counts_vs_xaxis_yaxis_type: 0,$ ;0 for linear, 1 for log
    counts_vs_yaxis_yaxis_type: 0,$ ;0 for linear, 1 for log
    
    cursor_info_base: 0L, $ ;id of info base
    counts_vs_xaxis_base: 0L, $ ;id of info counts vs x
    counts_vs_yaxis_base: 0L, $ ;id of info counts vs y
    counts_vs_xaxis_plot_uname: '',$
    counts_vs_yaxis_plot_uname: '',$
    
    data: ptr_new(0L), $
    data_linear: ptr_new(0L), $
    data_x: Data_x, $ ;[0,200,400,600...]
    xsize: default_plot_size[0],$
    ysize: default_plot_size[1],$
    start_pixel: start_pixel,$
    nbr_pixel: 0L,$
    colorbar_xsize: colorbar_xsize,$
    default_loadct: default_loadct, $ ;prism by default
    default_scale_settings: default_scale_settings, $ ;lin or log z-axis
    border: border, $ ;border of main plot (space reserved for scale)
    tof_axis: fltarr(2),$  ;[start, end]
    delta_tof: 0., $ ;tof increment
    xrange: fltarr(2),$ ;[tof_min, tof_max]
    zrange: fltarr(2),$
    yrange: intarr(2),$ ;[min_pixel,max_pixel]
    
    background: ptr_new(0L), $ ;background of main plot
    
    left_click: 0b,$ ;by default, left button is not clicked
    draw_zoom_selection: intarr(4),$ ;[x0,y0,x1,y1]
    
    congrid_xcoeff: 0., $ ;x coeff used in the congrid function to plot main data
    congrid_ycoeff: 0., $ ;y coeff used in the congrid function to plot main data
    
    plot_setting1: plot_setting1,$
    plot_setting2: plot_setting2,$
    plot_setting: current_plot_setting,$ ;untouched or interpolated
    
    main_event: event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_plot
  
  XMANAGER, "px_vs_tof_plots_base", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK, $
    cleanup = 'px_vs_tof_plots_base_cleanup'
    
  ;retrieve scale
  ;  Data_x = *pData_x[file_index,spin_state]
  start_tof = Data_x[0]
  end_tof = Data_x[-1]
  delta_tof = Data_x[1]-Data_x[0]
  (*global_plot).delta_tof = delta_tof
  ;tof_axis = (*global_plot).tof_axis
  ;tof_axis = data_x
  ;tof_axis[0] = start_tof
  ;tof_axis[1] = end_tof + delta_tof
  ;(*global_plot).tof_axis = tof_axis
  (*global_plot).tof_axis = [data_x[0],data_x[-2]]
  (*global_plot).xrange = [data_x[0],data_x[-2]]
 
  ;retrieve the data to plot
  ;  Data = *pData_y[file_index, spin_state]
  (*(*global_plot).data_linear) = Data_y
  
  rtof_lin_log_data, base=wBase
  
  ;number of pixels
  (*global_plot).nbr_pixel = (size(data_y))[1] ;nbr of pixels to plot
  
  Data = (*(*global_plot).data)
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='draw_rtof')
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  if ((*global_plot).plot_setting eq 'untouched') then begin
    ;cData = congrid(Data, default_plot_size[0]-2*border, default_plot_size[1]-2*border-colorbar_xsize)
    cData = congrid(Data, ysize, xsize)
  endif else begin
    cData = congrid(Data, ysize, xsize,/interp)
  endelse
  
  id = widget_info(wBase, find_by_uname='px_vs_tof_widget_base')
  geometry = widget_info(id,/geometry)
  _xsize = geometry.scr_xsize
  _ysize = geometry.scr_ysize
  (*global_plot).congrid_xcoeff = _ysize-2*border
  (*global_plot).congrid_ycoeff = _xsize-2*border-colorbar_xsize
  
  DEVICE, DECOMPOSED = 0
  loadct, default_loadct, /SILENT
  
  rtof_plot_beam_center_scale, base=wBase
  
  id = widget_info(wBase,find_by_uname='draw_rtof')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  tvscl, transpose(cData)
  
  zmin = 0
  zmax = max(Data)
  zrange = (*global_plot).zrange
  zrange[0] = zmin
  zrange[1] = zmax
  (*global_plot).zrange = zrange
  rtof_plot_colorbar, base=wBase, zmin, zmax, type=default_scale_settings
  
  ;change label of default loadct
  pre = '>  > >> '
  post = ' << <  <'
  uname = 'loadct_' + strcompress(default_loadct,/remove_all)
  value = getValue(base=wBase, uname=uname)
  new_value = pre + value + post
  setValue, base=wBase, uname, new_value
  
  save_background,  main_base=wBase, uname='draw_rtof'
  
end

