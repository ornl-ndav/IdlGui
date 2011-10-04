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
pro px_vs_tof_plots_input_files_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_px_vs_tof
  main_event = (*global_px_vs_tof).main_event
  
  case Event.id of
  
    ;lin and log
    widget_info(event.top, $
      find_by_uname='px_vs_tof_local_scale_setting_log'): begin
      putValue, event=event, 'px_vs_tof_local_scale_setting_linear', $
        '  linear'
      putValue, event=event, 'px_vs_tof_local_scale_setting_log',  $
        '* logarithmic'
      (*global_px_vs_tof).default_scale_settings = 1
      px_vs_tof_lin_log_data, event=event
      px_vs_tof_refresh_plot_with_selection, event, recalculate=1
    end
    widget_info(event.top, $
      find_by_uname='px_vs_tof_local_scale_setting_linear'): begin
      putValue, event=event, 'px_vs_tof_local_scale_setting_linear', $
        '* linear'
      putValue, event=event, 'px_vs_tof_local_scale_setting_log',  $
        '  logarithmic'
      (*global_px_vs_tof).default_scale_settings = 0
      px_vs_tof_lin_log_data, event=event
      px_vs_tof_refresh_plot_with_selection, event, recalculate=1
    end
    
    widget_info(event.top, $
      find_by_uname='px_vs_tof_input_files_widget_base'): begin
      
      id = widget_info(event.top, $
        find_by_uname='px_vs_tof_input_files_widget_base')
      ;widget_control, id, /realize
      geometry = widget_info(id,/geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      
      px_vs_tof_base_move_info_bases, event
      
      if ((abs((*global_px_vs_tof).xsize - new_xsize) eq 0.0) && $
        abs((*global_px_vs_tof).ysize - new_ysize) eq 0.0) then return
        
      if ((abs((*global_px_vs_tof).xsize - new_xsize) eq 0.0) && $
        abs((*global_px_vs_tof).ysize - new_ysize) eq 33.0) then return
        
      (*global_px_vs_tof).xsize = new_xsize
      (*global_px_vs_tof).ysize = new_ysize
      
      border = (*global_px_vs_tof).border
      
      widget_control, id, xsize = new_xsize
      widget_control, id, ysize = new_ysize
      
      colorbar_xsize = (*global_px_vs_tof).colorbar_xsize
      
      id = widget_info(event.top, $
        find_by_uname='draw_px_vs_tof_input_files')
      widget_control, id, draw_xsize = new_xsize-2*border-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize-2*border
      
      id = widget_info(event.top, $
        find_by_Uname='scale_px_vs_tof_input_files')
      widget_control, id, draw_xsize = new_xsize-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize
      
      id = widget_info(event.top, $
        find_by_uname='colorbar_px_vs_tof_input_files')
      widget_control, id, xoffset=new_xsize-colorbar_xsize
      widget_control, id, draw_ysize = new_ysize
      widget_control, id, draw_xsize = colorbar_xsize
      
      px_vs_tof_plot_beam_center_scale, event=event
      px_vs_tof_refresh_plot, event, recalculate=1
      px_vs_tof_refresh_plot_colorbar, event
      
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
;    Plot the first time the scale on the right of the main plot
;
; :Params:
;    zmin
;    zmax
;
; :Keywords:
;    event
;    base
;    type   0 for linear, 1 for logarithmic
;
; :Author: j35
;-
pro px_vs_tof_plot_colorbar, event=event, base=base, zmin, zmax, type=type
  compile_opt idl2
  
  if (n_elements(event) ne 0) then begin
    id_draw = widget_info(event.top, $
      find_by_uname='colorbar_px_vs_tof_input_files')
    widget_control, event.top, get_uvalue=global_px_vs_tof
  endif else begin
    id_draw = widget_info(base, find_by_uname='colorbar_px_vs_tof_input_files')
    widget_control, base, get_uvalue=global_px_vs_tof
  endelse
  widget_control, id_draw, get_value=id_value
  wset,id_value
  erase
  
  default_loadct = (*global_px_vs_tof).default_loadct
  loadct, default_loadct, /silent
  
  default_scale_setting = (*global_px_vs_tof).default_scale_settings
  if (default_scale_setting eq 0) then begin ;linear
  
    divisions = 20
    perso_format = '(e8.1)'
    range = [zmin,zmax]
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = [0.75,0.01,0.95,0.99], $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      /VERTICAL
      
  endif else begin
  
    divisions = 10
    perso_format = '(e8.1)'
    range = float([zmin,zmax])
    
    if (default_loadct eq 6) then begin
      colorbar, $
        AnnotateColor = 'white',$
        NCOLORS      = 255, $
        POSITION     = [0.75,0.01,0.95,0.99], $
        RANGE        = range,$
        DIVISIONS    = divisions,$
        PERSO_FORMAT = perso_format,$
        /VERTICAL,$
        ylog = 1
        
    endif else begin
    
      colorbar, $
        NCOLORS      = 255, $
        POSITION     = [0.75,0.01,0.95,0.99], $
        RANGE        = range,$
        DIVISIONS    = divisions,$
        PERSO_FORMAT = perso_format,$
        /VERTICAL,$
        ylog = 1
        
    endelse
    
  endelse
  
end

;+
; :Description:
;    Refresh the colorbar scale
;
; :Params:
;    event
;
; :Author: j35
;-
pro px_vs_tof_refresh_plot_colorbar, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  zrange = (*global_px_vs_tof).zrange
  zmin = zrange[0]
  zmax = zrange[1]
  
  id_draw = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='colorbar_px_vs_tof_input_files')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  erase
  
  default_loadct = (*global_px_vs_tof).default_loadct
  loadct, default_loadct, /silent
  
  default_scale_setting = (*global_px_vs_tof).default_scale_settings
  if (default_scale_setting eq 0) then begin ;linear
  
    divisions = 20
    perso_format = '(e8.1)'
    range = [zmin,zmax]
    colorbar, $
      NCOLORS      = 255, $
      POSITION     = [0.75,0.01,0.95,0.99], $
      RANGE        = range,$
      DIVISIONS    = divisions,$
      PERSO_FORMAT = perso_format,$
      annotatecolor = 'white',$
      /VERTICAL
      
  endif else begin
  
    divisions = 10
    perso_format = '(e8.1)'
    range = float([zmin,zmax])
    
    if (default_loadct eq 6) then begin
    
      colorbar, $
        AnnotateColor = 'white',$
        NCOLORS      = 255, $
        POSITION     = [0.75,0.01,0.95,0.99], $
        RANGE        = range,$
        DIVISIONS    = divisions,$
        PERSO_FORMAT = perso_format,$
        /VERTICAL,$
        ylog = 1
        
    endif else begin
    
      colorbar, $
        NCOLORS      = 255, $
        POSITION     = [0.75,0.01,0.95,0.99], $
        RANGE        = range,$
        DIVISIONS    = divisions,$
        PERSO_FORMAT = perso_format,$
        /VERTICAL,$
        ylog = 1
        
    endelse
    
  endelse
  
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
pro px_vs_tof_lin_log_data, event=event, base=base
  compile_opt idl2
  
  ;get global structure
  if (n_elements(event) ne 0) then begin
    widget_control,event.top,get_uvalue=global_px_vs_tof
  endif else begin
    widget_control, base, get_uvalue=global_px_vs_tof
  endelse
  
  Data = (*(*global_px_vs_tof).data2d_linear)
  ;0 for lin, 1 for log
  scale_setting = (*global_px_vs_tof).default_scale_settings
  
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
  
  (*(*global_px_vs_tof).data2d) = Data
  
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
pro px_vs_tof_refresh_plot, event, recalculate=recalculate
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_px_vs_tof
  
  id = widget_info(event.top, find_by_uname='draw_px_vs_tof_input_files')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  if (n_elements(recalculate) eq 0) then begin
    TV, (*(*global_px_vs_tof).background), true=3
    return
  endif
  
  Data = (*(*global_px_vs_tof).data2d)
  new_xsize = (*global_px_vs_tof).xsize
  new_ysize = (*global_px_vs_tof).ysize
  border = (*global_px_vs_tof).border
  colorbar_xsize = (*global_px_vs_tof).colorbar_xsize
  
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  
  cData = congrid(Data, xsize, ysize)
  
  (*global_px_vs_tof).congrid_xcoeff = xsize
  (*global_px_vs_tof).congrid_ycoeff = ysize
  
  erase
  
  loadct, (*global_px_vs_tof).default_loadct, /silent
  
  tvscl, cData
  
  save_px_vs_tof_background, event=event, uname='draw_px_vs_tof_input_files'
  
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
pro px_vs_tof_refresh_plot_with_selection, event, recalculate=recalculate
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_px_vs_tof
  
  id = widget_info(event.top, find_by_uname='draw_px_vs_tof_input_files')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  if (n_elements(recalculate) eq 0) then begin
    TV, (*(*global_px_vs_tof).background), true=3
    return
  endif
  
  Data = (*(*global_px_vs_tof).data2d)
  new_xsize = (*global_px_vs_tof).xsize
  new_ysize = (*global_px_vs_tof).ysize
  border = (*global_px_vs_tof).border
  colorbar_xsize = (*global_px_vs_tof).colorbar_xsize
  
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  
  cData = congrid(Data, xsize, ysize)
  
  (*global_px_vs_tof).congrid_xcoeff = xsize
  (*global_px_vs_tof).congrid_ycoeff = ysize
  
  erase
  
  loadct, (*global_px_vs_tof).default_loadct, /silent
  tvscl, cData
  
  draw_zoom_selection = (*global_px_vs_tof).draw_zoom_selection
  
  xmin = draw_zoom_selection[0]
  xmax = draw_zoom_selection[2]
  ymin = draw_zoom_selection[1]
  ymax = draw_zoom_selection[3]
  
  if (xmin eq -1 || $
    xmax eq -1 || $
    ymin eq -1 || $
    ymax eq -1) then return
    
  plots, xmin, ymin, /device
  plots, xmin, ymax, /device, /continue, color=fsc_color('green')
  plots, xmax, ymax, /device, /continue, color=fsc_color('green')
  plots, xmax, ymin, /device, /continue, color=fsc_color('green')
  plots, xmin, ymin, /device, /continue, color=fsc_color('green')
  
  save_px_vs_tof_background, event=event, uname='draw_px_vs_tof_input_files'
  
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
pro px_vs_tof_change_loadct, event
  compile_opt idl2
  
  new_uname = widget_info(event.id, /uname)
  widget_control,event.top,get_uvalue=global_px_vs_tof
  
  ;get old loadct
  old_loadct = strcompress((*global_px_vs_tof).default_loadct,/remove_all)
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
  (*global_px_vs_tof).default_loadct = fix(new_uname_array[1])
  
  ;replot
  px_vs_tof_refresh_plot_with_selection, event, recalculate=1
  px_vs_tof_refresh_plot_colorbar, event
  
end

;+
; :Description:
;    plot the zoom selection
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro refresh_zoom_px_vs_tof_selection, event
  compile_opt idl2
  
  px_vs_tof_refresh_plot, event
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  selection = (*global_px_vs_tof).draw_zoom_selection
  
  id = widget_info(event.top,find_by_uname='draw_px_vs_tof_input_files')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  xrange = [selection[0],selection[2]]
  yrange = [selection[1],selection[3]]
  
  xmin = min(xrange, max=xmax)
  ymin = min(yrange, max=ymax)
  
  plots, [xmin, xmin, xmax, xmax, xmin],$
    [ymin, ymax, ymax, ymin, ymin],$
    /DEVICE,$
    LINESTYLE = 3,$
    COLOR = 200
    
end

;+
; :Description:
;   Reached when the settings base is killed
;
; :Params:
;    global_px_vs_tof
;
; :Author: j35
;-
pro px_vs_tof_widget_killed, global_px_vs_tof
  compile_opt idl2
  
  main_event = (*global_px_vs_tof).main_event
  
  info_base = (*global_px_vs_tof).cursor_info_base
  ;if x,y and counts base is on, shows live values of x,y and counts
  if (widget_info(info_base, /valid_id) ne 0) then begin
    widget_control, info_base, /destroy
  endif
  
  ;close the xaxis info if openned
  xaxis_info_base = (*global_px_vs_tof).counts_vs_xaxis_base
  if (widget_info(xaxis_info_base, /valid_id) ne 0) then begin
    widget_control, xaxis_info_base, /destroy
  endif
  
  ;close the yaxis info if openned
  yaxis_info_base = (*global_px_vs_tof).counts_vs_yaxis_base
  if (widget_info(yaxis_info_base, /valid_id) ne 0) then begin
    widget_control, yaxis_info_base, /destroy
  endif
  
  ;ask the user if he wants to save or not the new selection
  draw_zoom_data_selection = (*global_px_vs_tof).draw_zoom_data_selection
  tof0 = float(draw_zoom_data_selection[0])
  pixel0 = fix(draw_zoom_data_selection[1])
  tof1 = float(draw_zoom_data_selection[2])
  pixel1 = fix(draw_zoom_data_selection[3])
  
  tof0 = min([tof0,tof1],max=tof1)
  pixel0 = min([pixel0,pixel1],max=pixel1)
  
  message_text = ['Do you want to use the following range:',$
    '',$
    '   TOF (ms) : ' + strcompress(tof0,/remove_all) + ' -> ' + $
    strcompress(tof1,/remove_all), $
    '      Pixel : ' + strcompress(fix(pixel0),/remove_all) + ' -> ' + $
    strcompress(fix(pixel1),/remove_all)]
  result = dialog_message(message_text, $
    /center, $
    dialog_parent=(*global_px_vs_tof).wBase, $
    title = 'Selection to use',$
    /Question)
    
  if (strlowcase(result) eq 'yes') then begin
    putValue, event=main_event, 'tof_min', tof0
    putValue, event=main_event, 'tof_max', tof1
    putValue, event=main_event, 'pixel_min', pixel0
    putValue, event=main_event, 'pixel_max', pixel1
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
pro px_vs_tof_plots_input_files_base_gui, wBase, $
    main_base_geometry, $
    global, $
    file_name, $
    offset, $
    border, $
    colorbar_xsize, $
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
    UNAME        = 'px_vs_tof_input_files_widget_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    SCR_YSIZE    = ysize,$
    SCR_XSIZE    = xsize+colorbar_xsize,$
    MAP          = 1,$
    ;    kill_notify  = 'px_vs_tof_widget_killed', $
    /BASE_ALIGN_CENTER,$
    /align_center,$
    /tlb_size_events,$
    /tlb_move_events, $
    mbar = bar1,$
    GROUP_LEADER = ourGroup)
    
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
    uname = 'loadct_0',$
    event_pro = 'px_vs_tof_change_loadct',$
    /separator)
    
  sz = n_elements(list_loadct)
  for i=1L,(sz-1) do begin
    set = widget_button(mPlot,$
      value = list_loadct[i],$
      uname = 'loadct_' + strcompress(i,/remove_all),$
      event_pro = 'px_vs_tof_change_loadct')
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
    uname = 'px_vs_tof_local_scale_setting_linear')
    
  set2 = widget_button(mPlot, $
    value = set2_value,$
    uname = 'px_vs_tof_local_scale_setting_log')
    
  info = widget_button(bar1, $
    value = 'Infos',$
    /menu)
    
  set = widget_button(info, $
    value = 'Show all',$
    event_pro = 'px_vs_tof_show_all_info',$
    uname = 'show_all_info_uname')
    
  set1 = widget_button(info, $
    /separator,$
    value = 'Show Cursor Infos',$
    event_pro = 'px_vs_tof_show_cursor_info',$
    uname = 'show_or_hide_cursor_info_uname')
    
  set2 = widget_button(info, $
    value = 'Show Counts vs xaxis at cursor y position',$
    event_pro = 'px_vs_tof_show_counts_vs_xaxis',$
    uname = 'show_counts_vs_xaxis_uname')
    
  set3 = widget_button(info, $
    value = 'Show Counts vs yaxis at cursor x position',$
    event_pro = 'px_vs_tof_show_counts_vs_yaxis',$
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
    event_pro = 'px_vs_tof_draw_eventcb',$
    uname = 'draw_px_vs_tof_input_files')
    
  scale = widget_draw(wBase,$
    uname = 'scale_px_vs_tof_input_files',$
    scr_xsize = xsize,$
    scr_ysize = ysize,$
    retain=2)
    
  colorbar =  widget_draw(wBase,$
    uname = 'colorbar_px_vs_tof_input_files',$
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
pro px_vs_tof_plot_beam_center_scale, base=base, event=event
  compile_opt idl2
  
  if (n_elements(base) ne 0) then begin
    id = widget_info(base,find_by_Uname='scale_px_vs_tof_input_files')
    id_base = widget_info(base, $
      find_by_uname='px_vs_tof_input_files_widget_base')
    sys_color = widget_info(base,/system_colors)
    widget_control, base, get_uvalue=global_px_vs_tof
  endif else begin
    id = widget_info(event.top, find_by_uname='scale_px_vs_tof_input_files')
    id_base = widget_info(event.top, $
      find_by_uname='px_vs_tof_input_files_widget_base')
    sys_color = widget_info(event.top, /system_colors)
    widget_control, event.top, get_uvalue=global_px_vs_tof
  endelse
  
  widget_control, id, get_value=id_value
  wset, id_value
  
  ;change color of background
  device, decomposed=1
  sys_color_window_bk = sys_color.window_bk
  
  xrange = (*global_px_vs_tof).xrange
  ;tof_axis = (*global_px_vs_tof).tof_axis
  ;min_x = tof_axis[0]
  ;max_x = tof_axis[-1]
  
  nbr_pixel = (*global_px_vs_tof).nbr_pixel
  min_y = 0
  max_y = min_y + nbr_pixel
  
  ;determine the number of xaxis data to show
  geometry = widget_info(id_base,/geometry)
  xsize = geometry.scr_xsize
  ;ysize = geometry.scr_ysize
  xticks = fix(xsize / 100)
  yticks = (max_y - min_y)/10
  
  xmargin = 6.6
  ymargin = 4
  
  yrange = [min_y, max_y]
  (*global_px_vs_tof).yrange = yrange
  
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
    ;YTICKS      = yticks,$
    ;XTITLE      = 'TOF (!4l!Xs)',$
    xtitle = 'TOF (ms)', $
    ;    YTITLE      = 'Pixels',$
    XMARGIN     = [xmargin, xmargin+0.2],$
    YMARGIN     = [ymargin, ymargin],$
    /NODATA
  ;  axis, yaxis=1, YRANGE=yrange, YTICKS=yticks, YSTYLE=1, $
  ;    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = ticklen
  axis, yaxis=1, YRANGE=yrange, YSTYLE=1, $
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
pro px_vs_tof_plots_input_files_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_px_vs_tof, /no_copy
  
  px_vs_tof_widget_killed, global_px_vs_tof
  
  if (n_elements(global_px_vs_tof) eq 0) then return
  
  ptr_free, (*global_px_vs_tof).data2d
  ptr_free, (*global_px_vs_tof).data3d
  ptr_free, (*global_px_vs_tof).data2d_linear
  
  ptr_free, global_px_vs_tof
  
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
pro refresh_px_vs_tof_plots_input_files_base, wBase = wBase, $
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
pro px_vs_tof_plots_input_files_base,  main_base=main_base, $
    event=event, $
    file_name = file_name, $
    offset = offset, $
    data = data, $
    tof_axis = tof_axis
  compile_opt idl2
  
  default_scale_settings=1
  default_plot_size = [300,300]
  default_loadct=5
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='main_base')
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;SETUP
  border = 40
  colorbar_xsize = 70
  
  ;build gui
  wBase = ''
  px_vs_tof_plots_input_files_base_gui, wBase, $
    main_base_geometry, $
    global, $
    file_name, $
    offset, $
    border, $
    colorbar_xsize, $
    scale_setting = default_scale_settings
  ;(*global).auto_scale_plot_base = wBase
    
  WIDGET_CONTROL, wBase, /REALIZE
  
  global_px_vs_tof = PTR_NEW({ wbase: wbase,$
    global: global, $
    
    ;used to plot selection zoom
    file_name: file_name, $
    default_plot_size: default_plot_size, $
    
    counts_vs_xaxis_yaxis_type: 1,$ ;0 for linear, 1 for log
    counts_vs_yaxis_yaxis_type: 1,$ ;0 for linear, 1 for log
    
    cursor_info_base: 0L, $ ;id of info base
    counts_vs_xaxis_base: 0L, $ ;id of info counts vs x
    counts_vs_yaxis_base: 0L, $ ;id of info counts vs y
    counts_vs_xaxis_plot_uname: '',$
    counts_vs_yaxis_plot_uname: '',$
    
    data2d: ptr_new(0L), $
    data2d_linear: ptr_new(0L), $
    data3d: ptr_new(0L), $
    tof_axis: tof_axis, $ ;[0,200,400,600...]
    
    xsize: default_plot_size[0],$
    ysize: default_plot_size[1],$
    
    colorbar_xsize: colorbar_xsize,$
    default_loadct: default_loadct, $ ;prism by default
    default_scale_settings: default_scale_settings, $ ;lin or log z-axis
    
    border: border, $ ;border of main plot (space reserved for scale)
    
    delta_tof: 0., $ ;tof increment
    xrange: fltarr(2),$ ;[tof_min, tof_max]
    zrange: fltarr(2),$
    yrange: intarr(2),$ ;[min_pixel,max_pixel]
    nbr_pixel: 0L, $
    
    background: ptr_new(0L), $ ;background of main plot
    
    left_click: 0b,$ ;by default, left button is not clicked
    draw_zoom_selection: intarr(4),$ ;[x0,y0,x1,y1] /device
    draw_zoom_data_selection: fltarr(4), $ ;[x0,y0,x1,y1] /data
    
    plot_setting1: 0, $
    plot_setting2: 1, $
    
    info_base_counts_vs_xaxis_counts_max: 0L, $
    info_base_counts_vs_yaxis_counts_max: 0L, $
    
    ;x coeff used in the congrid function to plot main data
    congrid_xcoeff: 0., $
    ;y coeff used in the congrid function to plot main data
    congrid_ycoeff: 0., $
    
    main_event: event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_px_vs_tof
  
  XMANAGER, "px_vs_tof_plots_input_files_base", wBase, $
    GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup = 'px_vs_tof_plots_input_files_base_cleanup'
    
  ;retrieve scales
  start_tof = tof_axis[0]
  end_tof   = tof_axis[-1]
  delta_tof = tof_axis[1]-tof_axis[0]
  (*global_px_vs_tof).delta_tof = delta_tof
  
  (*global_px_vs_tof).xrange = [tof_axis[0],tof_axis[-2]]  ;ex: [0,20000]
  
  ;retrieve the data to plot
  ;  Data = *pData_y[file_index, spin_state]
  (*(*global_px_vs_tof).data3d) = Data ;[751,256,304]
  
  data2d_linear = total(data,2)
  (*(*global_px_vs_tof).data2d_linear) = data2d_linear
  sz = size(data2d_linear,/dim)
  (*global_px_vs_tof).nbr_pixel = sz[1]
  px_vs_tof_lin_log_data, base=wBase
  _data = (*(*global_px_vs_tof).data2d)
  
  ;number of pixels
  (*global_px_vs_tof).nbr_pixel = (size(_data,/dim))[1]
  
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='draw_px_vs_tof_input_files')
  draw_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = draw_geometry.xsize
  ysize = draw_geometry.ysize
  cData = congrid(_data, ysize, xsize)
  
  (*global_px_vs_tof).congrid_ycoeff = ysize
  (*global_px_vs_tof).congrid_xcoeff = xsize
  
  DEVICE, DECOMPOSED = 0
  loadct, default_loadct, /silent
  
  px_vs_tof_plot_beam_center_scale, base=wBase
  
  id = widget_info(wBase,find_by_uname='draw_px_vs_tof_input_files')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  tvscl, cData
  
  zmin = 0
  zmax = max(_Data)
  zrange = (*global_px_vs_tof).zrange
  zrange[0] = zmin
  zrange[1] = zmax
  (*global_px_vs_tof).zrange = zrange
  px_vs_tof_plot_colorbar, base=wBase, zmin, zmax, type=default_scale_settings
  
  ;change label of default loadct
  pre = '>  > >> '
  post = ' << <  <'
  uname = 'loadct_' + strcompress(default_loadct,/remove_all)
  value = getValue(base=wBase, uname=uname)
  new_value = pre + value + post
  setValue, base=wBase, uname, new_value
  
  id = widget_info(wBase, find_by_uname='px_vs_tof_input_files_widget_base')
  geometry = widget_info(id,/geometry)
  (*global_px_vs_tof).xsize = geometry.scr_xsize
  (*global_px_vs_tof).ysize = geometry.scr_ysize
  
  tof_min_data = getValue(event=event, uname='tof_min')
  tof_max_data = getValue(event=event, uname='tof_max')
  pixel_min_data = getValue(event=event, uname='pixel_min')
  pixel_max_data = getValue(event=event, uname='pixel_max')
  
  ;check here if it's a valid number
  on_ioerror, not_a_number
  tof_min_data = float(tof_min_data)
  tof_max_data = float(tof_max_data)
  pixel_min_data = fix(pixel_min_data)
  pixel_max_data = fix(pixel_max_data)
  
  f_tof_min = float(tof_min_data)
  f_tof_max = float(tof_max_data)
  f_pixel_min = fix(pixel_min_data)
  f_pixel_max = fix(pixel_max_data)
  
  tof_range = (*global_px_vs_tof).xrange
  if (f_tof_min lt tof_range[0] || f_tof_min gt tof_range[1]) then f_tof_min=-1
  if (f_tof_max lt tof_range[0] || f_tof_max gt tof_range[1]) then f_tof_max=-1
  
  pixel_range = [0,(*global_px_vs_tof).nbr_pixel]
  if (f_pixel_min lt pixel_range[0] || f_pixel_min gt pixel_range[1]) then $
    f_pixel_min=-1
  if (f_pixel_max lt pixel_range[0] || f_pixel_max gt pixel_range[1]) then $
    f_pixel_max=-1
    
  tof_min = min([f_tof_min,f_tof_max],max=tof_max)
  pixel_min = min([f_pixel_min,f_pixel_max], max=pixel_max)
  
  draw_zoom_data_selection = [tof_min, pixel_min, tof_max, pixel_max]
  (*global_px_vs_tof).draw_zoom_data_selection = draw_zoom_data_selection
  
  tof_min_device = px_vs_tof_tof_data_to_tof_device(global_px_vs_tof, $
    tof=tof_min)
  tof_max_device = px_vs_tof_tof_data_to_tof_device(global_px_vs_tof, $
    tof=tof_max)
    
  pixel_min_device = px_vs_tof_px_data_to_px_device(global_px_vs_tof, $
    pixel=pixel_min)
  pixel_max_device = px_vs_tof_px_data_to_px_device(global_px_vs_tof, $
    pixel=pixel_max)
    
  draw_zoom_selection = (*global_px_vs_tof).draw_zoom_selection
  draw_zoom_selection = [tof_min_device, pixel_min_device, tof_max_device, $
    pixel_max_device]
  (*global_px_vs_tof).draw_zoom_selection = draw_zoom_selection
  
  id = widget_info(wBase,find_by_uname='draw_px_vs_tof_input_files')
  widget_control, id, GET_VALUE = plot_id
  wset, plot_id
  
  plots, tof_min_device, pixel_min_device, /device
  plots, tof_min_device, pixel_max_device, /device, /continue, $
    color=fsc_color('green')
  plots, tof_max_device, pixel_max_device, /device, /continue, $
    color=fsc_color('green')
  plots, tof_max_device, pixel_min_device, /device, /continue, $
    color=fsc_color('green')
  plots, tof_min_device, pixel_min_device, /device, /continue, $
    color=fsc_color('green')
    
  not_a_number: ;jump here if numbers are not valid
  
  save_background,  main_base=wBase, uname='draw_px_vs_tof_input_files'
  
end

