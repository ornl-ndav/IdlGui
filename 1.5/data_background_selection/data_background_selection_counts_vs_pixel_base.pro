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
pro counts_vs_pixel_base_event, Event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_counts
  global_pixel_selection = (*global_counts).global_pixel_selection
  
  case Event.id of
  
    ;main base
    widget_info(event.top, find_by_uname=$
    'counts_vs_pixel_base'): begin
    
      id = widget_info(event.top, find_by_uname=$
      'counts_vs_pixel_base')
      geometry = widget_info(id, /geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      
     id = widget_info(event.top, find_by_uname=$
     'counts_vs_pixel_draw')
      widget_control, id, draw_xsize = new_xsize
      widget_control, id, draw_ysize = new_ysize
      
      data_background_display_counts_vs_pixel, event=event, $
      global_pixel_selection
    end
    
    ;linear scale
    widget_info(event.top, find_by_uname=$
    'tof_selection_counts_vs_tof_linear'): begin
      tof_selection_counts_switch_axex_type, event
    end
    
    widget_info(event.top, find_by_uname=$
    'tof_selection_counts_vs_tof_log'): begin
      tof_selection_counts_switch_axex_type, event
    end
    
    ;plot
    widget_info(event.top, find_by_uname=$
    'tof_selection_counts_vs_tof_draw'): begin
    
      if (event.press eq 1) then begin ;left click
        (*global_counts).left_click = 1b
        
        _id = widget_info(event.top, find_by_uname=$
        'tof_selection_counts_vs_tof_draw')
        widget_control, event.top, get_uvalue=global_counts
        widget_control, _id, GET_VALUE = _plot_id
        wset, _plot_id
        
        cursor, x,y, /data
        check_tof_value, x, global_tof_selection
        
        tof_selection_tof = (*global_tof_selection).tof_selection_tof
        tof1_selected = (*global_tof_selection).tof1_selected
        if (tof1_selected) then begin
        uname = 'tof_selection_tof1_uname'
        tof_selection_tof[0] = x
        endif else begin
        uname = 'tof_selection_tof2_uname'
        tof_selection_tof[1] = x
        endelse
        (*global_tof_selection).tof_selection_tof = tof_selection_tof
        
        x = (x eq -1) ? !values.F_nan : x
        
        putValue, base=(*global_tof_selection).tof_selection_input_base, $
        uname, strcompress(x,/remove_all)
        
        display_counts_vs_tof, event=event, global_tof_selection
        display_tof_selection_tof, base=(*global_counts).top_base

      endif
      
      ;switch pixel1 and pixel2 status
      if (event.press eq 4) then begin ;right click
        tof1_selected = (*global_tof_selection).tof1_selected
        if (tof1_selected) then begin
        (*global_tof_selection).tof1_selected = 0b
        endif else begin
        (*global_tof_selection).tof1_selected = 1b
        endelse
        display_counts_vs_tof, event=event, global_tof_selection
        display_tof_selection_tof, base=(*global_counts).top_base
      endif
      
      if (event.release eq 1 && $
        (*global_counts).left_click eq 1b) then begin ;release button
        (*global_counts).left_click = 0b
      endif
      
      
      ;moving mouse with left click
      if ((*global_counts).left_click && $
        (*global_counts).left_click eq 1b) then begin 
        
         _id = widget_info(event.top, find_by_uname=$
        'tof_selection_counts_vs_tof_draw')
        widget_control, event.top, get_uvalue=global_counts
        widget_control, _id, GET_VALUE = _plot_id
        wset, _plot_id
        
        cursor, x,y, /data
        check_tof_value, x, global_tof_selection
        
        tof_selection_tof = (*global_tof_selection).tof_selection_tof
        tof1_selected = (*global_tof_selection).tof1_selected
        if (tof1_selected) then begin
        uname = 'tof_selection_tof1_uname'
        tof_selection_tof[0] = x
        endif else begin
        uname = 'tof_selection_tof2_uname'
        tof_selection_tof[1] = x
        endelse
        (*global_tof_selection).tof_selection_tof = tof_selection_tof
        
                x = (x eq -1) ? !values.F_nan : x
                
        putValue, base=(*global_tof_selection).tof_selection_input_base, $
        uname, strcompress(x,/remove_all)
        
        display_counts_vs_tof, event=event, global_tof_selection
        display_tof_selection_tof, base=(*global_counts).top_base
        
        endif
      
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    Make sure the tof value is within the following range [0,tof_max]
;
; :Params:
;    x
;
; :Author: j35
;-
pro check_tof_value, x, global_tof_selection
  compile_opt idl2
  
  tof_range = (*global_tof_selection).xrange
  xmin = tof_range[0]
  xmax = tof_range[1]

  if (x lt xmin) then begin
    x=-1
    return
  endif
  
  if (x gt xmax) then begin
    x = -1
    return
  endif
  
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
pro tof_selection_counts_switch_axex_type, event
  compile_opt idl2
  
  uname = widget_info(event.id, /uname)
  widget_control, event.top, get_uvalue=global_counts
  global_tof_selection = (*global_counts).global_tof_selection
  
  if (uname eq 'tof_selection_counts_vs_tof_linear') then begin
    set1_value = '* ' + 'linear'
    set2_value = '  ' + 'logarithmic'
    (*global_tof_selection).counts_vs_tof_scale_is_linear = 1b
  endif else begin
    set1_value = '  ' + 'linear'
    set2_value = '* ' + 'logarithmic'
    (*global_tof_selection).counts_vs_tof_scale_is_linear = 0b
  endelse
  
  putValue, event=event, 'tof_selection_counts_vs_tof_linear', set1_value
  putValue, event=event, 'tof_selection_counts_vs_tof_log', set2_value
  
  display_counts_vs_tof, event=event, global_tof_selection
  
end

;+
; :Description:
;    Show the counts vs tof pixel
;
; :Params:
;    global_refpix
;
; :Keywords:
;    base
;    event
;
; :Author: j35
;-
pro data_background_display_counts_vs_pixel, base=base, event=event, global_pixel_selection
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    _id = widget_info(event.top, find_by_uname=$
    'counts_vs_pixel_draw')
    widget_control, event.top, get_uvalue=global_counts
  endif else begin
    _id = widget_info(base, find_by_uname='counts_vs_pixel_draw')
    widget_control, base, get_uvalue=global_counts
  endelse
  widget_control, _id, GET_VALUE = _plot_id
  wset, _plot_id
  
  counts_vs_pixel = (*(*global_pixel_selection).counts_vs_pixel)
  x_axis = (*global_pixel_selection).y_axis
  x_axis = x_axis[0:-2]
  
  ;xrange
  xrange = (*global_pixel_selection).xrange
  
  ;get ymax and ymin
  ymax = max(counts_vs_pixel,min=ymin)
  yrange = [1,ymax]
  
  counts_vs_pixel_scale_is_linear = $
    (*global_pixel_selection).counts_vs_pixel_scale_is_linear
    
  pixel1_selected = (*global_pixel_selection).pixel1_selected
  if (pixel1_selected) then begin
    _pixelmin_size = 3
    _pixelmax_size = 1
  endif else begin
    _pixelmin_size = 1
    _pixelmax_size = 3
  endelse
  
  ;if linear or log scale
  if (counts_vs_pixel_scale_is_linear eq 1) then begin ;linear scale
  
    plot, x_axis, $
      counts_vs_pixel, $
      xstyle=1, $
      xtitle='Pixel',$
      ytitle='Counts'
      
  endif else begin
  
    plot, x_axis, $
      counts_vs_pixel, $
      /ylog, $
      yrange=yrange, $
      xstyle=1, $
      xtitle='Pixel', $
      ytitle='Counts'
      
  endelse
  
  return
  
  tof_selection = (*global_tof_selection).tof_selection_tof
  
  tof_min = tof_selection[0]
  tof_max = tof_selection[1]
  if (tof_min ne -1 or tof_max ne -1) then begin
  
    if (tof_min ne -1) then begin
      plots, tof_min, 1, /data
      plots, tof_min, ymax, /data, /continue, $
        color=fsc_color("green"), $
        thick=_tofmin_size,$
        linestyle=2
    endif
    
    if (tof_max ne -1) then begin
      plots, tof_max, 1, /data
      plots, tof_max, ymax, /data, /continue, $
        color=fsc_color("green"), $
        thick=_tofmax_size,$
        linestyle=2
    endif
    
  endif
    
end

;+
; :Description:
;    Builds the GUI of the counts vs pixel
;
; :Params:
;    wBase
;    parent_base_geometry
;
; :Author: j35
;-
pro counts_vs_pixel_base_gui, wBase, $
    parent_base_geometry
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xsize
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset + 220
  
  ourGroup = WIDGET_BASE()
  
  title = 'Counts vs Pixel'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'counts_vs_pixel_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    /column,$
    /tlb_size_events,$
    mbar = bar1, $
    GROUP_LEADER = ourGroup)
    
  _plot = widget_draw(wBase,$
    scr_xsize = 500,$
    scr_ysize = 500,$
    /button_events, $
    /motion_events, $
    retain = 2,$
    uname = 'counts_vs_pixel_draw')
    
  axes = widget_button(bar1,$
    value = 'Axes',$
    /menu)
    
  lin = widget_button(axes,$
    value = '  linear',$
    uname = 'counts_vs_pixel_linear')
    
  log = widget_button(axes,$
    value = '* logarithmic',$
    uname = 'counts_vs_pixel_log')
    
end

;+
; :Description:
;
; :Keywords:
;    main_base
;    event
;
; :Author: j35
;-
pro data_background_counts_vs_pixel_base, event=event, $
    top_base=top_base, $
    pixel=pixel, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global_pixel_selection
    top_base = 0L
  endif else begin
    id = widget_info(top_base, find_by_uname=parent_base_uname)
    widget_control, top_base, get_uvalue=global_pixel_selection
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = 0L
  counts_vs_pixel_base_gui, _base, $
    parent_base_geometry
    
  global_counts = ptr_new({ global_pixel_selection: global_pixel_selection,$
    top_base: top_base, $
    left_click: 0b })
    
  (*global_pixel_selection).roi_selection_counts_vs_pixel_base_id = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  widget_control, _base, set_uvalue=global_counts
  
  XMANAGER, "counts_vs_pixel_base", _base, $
    GROUP_LEADER = ourGroup, $
    /NO_BLOCK
    
  data_background_display_counts_vs_pixel, base=_base, global_pixel_selection
  
  return
  
  pixel_selection = (*global_pixel_selection).pixel_selection
  
  tof_min = tof_selection[0]
  tof_max = tof_selection[1]
  if (tof_min ne -1 or tof_max ne -1) then begin
  
    counts_vs_tof = (*(*global_tof_selection).counts_vs_tof)
    ymax = max(counts_vs_tof,min=ymin)
    
    _id = widget_info(_base, find_by_uname='tof_selection_counts_vs_tof_draw')
    widget_control, _id, GET_VALUE = _plot_id
    wset, _plot_id
    
    if (tof_min ne -1) then begin
      plots, tof_min, 1, /data
      plots, tof_min, ymax, /data, /continue, $
        color=fsc_color("green"), $
        thick=2,$
        linestyle=1
    endif
    
    if (tof_max ne -1) then begin
      plots, tof_max, 1, /data
      plots, tof_max, ymax, /data, /continue, $
        color=fsc_color("green"), $
        thick=2,$
        linestyle=1
    endif
    
  endif
  
end

