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
pro center_px_counts_vs_pixel_base_event, Event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_counts
  global = (*global_counts).global
  
  case Event.id of
  
    ;main base
    widget_info(event.top, find_by_uname='center_px_counts_vs_pixel_base'): begin
    
      id = widget_info(event.top, find_by_uname='center_px_counts_vs_pixel_base')
      geometry = widget_info(id, /geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      
      id = widget_info(event.top, find_by_uname='center_px_counts_vs_pixel_draw')
      widget_control, id, draw_xsize = new_xsize
      widget_control, id, draw_ysize = new_ysize
      
      refresh_counts_vs_pixel, event=event, global
      
    end
    
    ;linear scale
    widget_info(event.top, find_by_uname='center_px_counts_vs_pixel_linear'): begin
      counts_vs_pixel_switch_axex_type, event
    end
    
    widget_info(event.top, find_by_uname='center_px_counts_vs_pixel_log'): begin
      counts_vs_pixel_switch_axex_type, event
    end
    
    ;plot
    widget_info(event.top, find_by_uname='center_px_counts_vs_pixel_draw'): begin
      return
      
      if (event.press eq 1) then begin ;left click
        (*global_counts).left_click = 1b
        
        refpix_pixels = (*global).refpix_pixels
        
        _id = widget_info(event.top, find_by_uname='refpix_counts_vs_pixel_draw')
        widget_control, event.top, get_uvalue=global_counts
        widget_control, _id, GET_VALUE = _plot_id
        wset, _plot_id
        
        cursor, x,y, /data
        check_pixel_value, x, event
        
        ;1b for pixel1, 0b for pixel2
        pixel1_working = (*global_refpix).pixel1_selected
        if (pixel1_working) then begin
          refpix_pixels[0] = x
          uname = 'refpix_pixel1_uname'
        endif else begin
          refpix_pixels[1] = x
          uname = 'refpix_pixel2_uname'
        endelse
        (*global_refpix).refpix_pixels = refpix_pixels
        refpix_input_base = (*global_refpix).refpix_input_base
        top_base = (*global_refpix).top_base
        putValue, base=refpix_input_base, uname, strcompress(x,/remove_all)
        calculate_refpix, base=top_base
        display_counts_vs_pixel, event=event, global_refpix
        display_refpixel_pixels, base=(*global_refpix).top_base
      endif
      
      ;switch pixel1 and pixel2 status
      if (event.press eq 4) then begin ;right click
        pixel1_working = (*global_refpix).pixel1_selected
        if (pixel1_working) then begin
          (*global_refpix).pixel1_selected = 0b
        endif else begin
          (*global_refpix).pixel1_selected = 1b
        endelse
        display_counts_vs_pixel, event=event, global_refpix
      endif
      
      if (event.release eq 1 && $
        (*global_counts).left_click eq 1b) then begin ;release button
        (*global_counts).left_click = 0b
      endif
      
      if ((*global_counts).left_click && $
        (*global_counts).left_click eq 1b) then begin ;moving mouse with left click
        
        refpix_pixels = (*global_refpix).refpix_pixels
        
        _id = widget_info(event.top, find_by_uname='refpix_counts_vs_pixel_draw')
        widget_control, event.top, get_uvalue=global_counts
        widget_control, _id, GET_VALUE = _plot_id
        wset, _plot_id
        
        cursor, x,y, /data, /nowait
        check_pixel_value, x, event
        
        ;1b for pixel1, 0b for pixel2
        pixel1_working = (*global_refpix).pixel1_selected
        if (pixel1_working) then begin
          refpix_pixels[0] = x
          uname = 'refpix_pixel1_uname'
        endif else begin
          refpix_pixels[1] = x
          uname = 'refpix_pixel2_uname'
        endelse
        (*global_refpix).refpix_pixels = refpix_pixels
        refpix_input_base = (*global_refpix).refpix_input_base
        putValue, base=refpix_input_base, uname, strcompress(x,/remove_all)
        top_base = (*global_refpix).top_base
        calculate_refpix, base=top_base
        display_counts_vs_pixel, event=event, global_refpix
        display_refpixel_pixels, base=(*global_refpix).top_base
      endif
      
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    This routine bring to life the Counts vs pixel base, or refresh it
;    if the base is already alive
;
; :Params:
;    event
;
; :Author: j35
;-
pro bring_to_life_or_refresh_counts_vs_pixel, event
  widget_Control, event.top, get_uvalue= global
  
  _base = (*global).center_px_counts_vs_pixel_base_id
  
  ;create plot/base and plot counts vs pixel
  if (widget_info(_base, /valid_id) eq 0) then begin
  
    top_base = widget_info(event.top, find_by_uname='MAIN_BASE')
    center_pixel = (*global).dirpix
    parent_base_uname = 'MAIN_BASE'
    center_px_counts_vs_pixel_base, event=event, $
      top_base=top_base, $
      center_pixel=center_pixel, $
      parent_base_uname = parent_base_uname
      
  endif else begin ;just refresh
  
    refresh_counts_vs_pixel, base=_base, global
    
  endelse
  
end

;+
; :Description:
;    This routine will update the counts vs pixel plot only if
;    the base is mapped.
;
; :Params:
;    event
;
; :Author: j35
;-
pro refresh_counts_vs_pixel_if_existing, event
  compile_opt idl2
  
  widget_Control, event.top, get_uvalue= global
  
  _base = (*global).center_px_counts_vs_pixel_base_id
  
  if (widget_info(_base, /valid_id) ne 0) then $
    refresh_counts_vs_pixel, base=_base, global
    
end

;+
; :Description:
;    Make sure the pixel value is within the following range [0,pixel_max]
;
; :Params:
;    x
;
; :Author: j35
;-
pro check_pixel_value, x, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_counts
  global_refpix = (*global_counts).global_refpix
  
  if (x lt 0) then begin
    x=0
    return
  endif
  
  pixel_range = (*global_refpix).yrange
  xmax = pixel_range[1]
  if (x gt xmax) then begin
    x = xmax
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
pro counts_vs_pixel_switch_axex_type, event
  compile_opt idl2
  
  uname = widget_info(event.id, /uname)
  widget_control, event.top, get_uvalue=global_counts
  global = (*global_counts).global
  
  if (uname eq 'center_px_counts_vs_pixel_linear') then begin
    set1_value = '* ' + 'linear'
    set2_value = '  ' + 'logarithmic'
    (*global_counts).counts_vs_pixel_scale_is_linear = 1b
  endif else begin
    set1_value = '  ' + 'linear'
    set2_value = '* ' + 'logarithmic'
    (*global_counts).counts_vs_pixel_scale_is_linear = 0b
  endelse
  
  putValue, event=event, 'center_px_counts_vs_pixel_linear', set1_value
  putValue, event=event, 'center_px_counts_vs_pixel_log', set2_value
  
  display_counts_vs_pixel, event=event, global
  
end

;+
; :Description:
;    Show the counts vs tof pixel and the ymin, ymax and center pixel
;    selected in the peak tab of the main base
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
pro display_counts_vs_pixel, base=base, event=event, global
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    _id = widget_info(event.top, find_by_uname='center_px_counts_vs_pixel_draw')
    widget_control, event.top, get_uvalue=global_counts
  endif else begin
    _id = widget_info(base, find_by_uname='center_px_counts_vs_pixel_draw')
    widget_control, base, get_uvalue=global_counts
  endelse
  widget_control, _id, GET_VALUE = _plot_id
  wset, _plot_id
  
  data = (*(*global).bank1_data)  ;[tof,y,x]
  counts_vs_pixel_pixel = total(data,1)
  counts_vs_pixel = total(counts_vs_pixel_pixel,2)
  (*(*global).counts_vs_pixel) = counts_vs_pixel
  
  ;create yaxis
  ymax = max(counts_vs_pixel,min=ymin)
  yrange = [1,ymax]
  
  ;create xaxis
  xrange = [0,256]
  
  ;retrieve peak value of Ymin, Ymax and center pixel
  main_event = (*global_counts).main_event
  xmin = fix(getValue(event=main_event,uname='data_d_selection_peak_ymin_cw_field'))
  xmax = fix(getValue(event=main_event,uname='data_d_selection_peak_ymax_cw_field'))
  center_pixel = getValue(event=main_event,uname='data_center_pixel_uname')
  if (center_pixel ne 'N/A') then begin
    center_pixel = float(center_pixel)
  endif else begin
    center_pixel = 0.0
  endelse
  
  ;if linear or log scale
  if ((*global_counts).counts_vs_pixel_scale_is_linear eq 1) then begin ;linear scale
  
    plot, counts_vs_pixel, $
      xrange=xrange, $
      xstyle=1, $
      xtitle='Pixel',$
      ytitle='Counts'
      
  endif else begin
  
    plot, counts_vs_pixel, $
      /ylog, $
      yrange=yrange, $
      xrange=xrange, $
      xstyle=1, $
      xtitle='Pixel', $
      ytitle='Counts'
      
  endelse
  
  if (xmin ne 0) then begin
    plots, xmin, 1
    plots, xmin, ymax, /continue, color=fsc_color("red")
  endif
  
  if (xmax ne 0) then begin
    plots, xmax, 1
    plots, xmax, ymax, /continue, color=fsc_color("red")
  endif
  
  if (center_pixel ne 0) then begin
    plots, center_pixel, 1
    plots, center_pixel, ymax, /continue, color=fsc_color("blue")
  endif
  
  plot_background_selection, event=main_event, ymax=ymax

end

;+
; :Description:
;    This plot/refresh the background selection made by the user
;
; :Keywords:
;    event
;    ymax
;
; :Author: j35
;-
pro plot_background_selection, event=main_event, ymax=ymax
compile_opt idl2  

  ;retrieve background values
  back_ymin = fix(getValue(event=main_event, $
    uname='data_d_selection_roi_ymin_cw_field'))
  back_ymax = fix(getValue(event=main_event, $
    uname='data_d_selection_roi_ymax_cw_field'))
    
  if (back_ymin ne 0) then begin
    plots, back_ymin, 1
    plots, back_ymin, ymax, /continue, color=fsc_color("green")
  endif
  
  if (back_ymax ne 0) then begin
    plots, back_ymax, 1
    plots, back_ymax, ymax, /continue, color=fsc_color("green")
  endif

end

;+
; :Description:
;    Refresh the plot Counts vs Pixel and display the ymin, ymax and
;    center pixel of the peak selection
;
; :Params:
;    global
;
; :Keywords:
;    base
;    event
;
; :Author: j35
;-
pro refresh_counts_vs_pixel, base=base, event=event, global
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    _id = widget_info(event.top, find_by_uname='center_px_counts_vs_pixel_draw')
    widget_control, event.top, get_uvalue=global_counts
  endif else begin
    _id = widget_info(base, find_by_uname='center_px_counts_vs_pixel_draw')
    widget_control, base, get_uvalue=global_counts
  endelse
  widget_control, _id, GET_VALUE = _plot_id
  wset, _plot_id
  
  counts_vs_pixel = (*(*global).counts_vs_pixel)
  
  ;get ymax and ymin
  ymax = max(counts_vs_pixel,min=ymin)
  yrange = [1,ymax]
  
  xrange = [0,256]
  
  ;retrieve value of Ymin, Ymax and center pixel
  main_event = (*global_counts).main_event
  xmin = fix(getValue(event=main_event,uname='data_d_selection_peak_ymin_cw_field'))
  xmax = fix(getValue(event=main_event,uname='data_d_selection_peak_ymax_cw_field'))
  center_pixel = getValue(event=main_event,uname='data_center_pixel_uname')
  if (center_pixel ne 'N/A') then begin
    center_pixel = float(center_pixel)
  endif else begin
    center_pixel = 0.0
  endelse
  
  ;if linear or log scale
  if ((*global_counts).counts_vs_pixel_scale_is_linear eq 1) then begin ;linear scale
  
    plot, counts_vs_pixel, $
      xrange=xrange, $
      xstyle=1, $
      xtitle='Pixel',$
      ytitle='Counts'
      
  endif else begin
  
    plot, counts_vs_pixel, $
      /ylog, $
      yrange=yrange, $
      xrange=xrange, $
      xstyle=1, $
      xtitle='Pixel', $
      ytitle='Counts'
      
  endelse
  
  if (xmin ne 0) then begin
    plots, xmin, 1
    plots, xmin, ymax, /continue, color=fsc_color("red")
  endif
  
  if (xmax ne 0) then begin
    plots, xmax, 1
    plots, xmax, ymax, /continue, color=fsc_color("red")
  endif
  
  if (center_pixel ne 0) then begin
    plots, center_pixel, 1
    plots, center_pixel, ymax, /continue, color=fsc_color("blue")
  endif
  
   plot_background_selection, event=main_event, ymax=ymax
  
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
pro center_px_counts_vs_pixel_base_gui, wBase, $
    parent_base_geometry
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xsize
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset + 170
  
  ourGroup = WIDGET_BASE()
  
  title = 'Counts vs Pixel'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'center_px_counts_vs_pixel_base', $
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
    uname = 'center_px_counts_vs_pixel_draw')
    
  axes = widget_button(bar1,$
    value = 'Axes',$
    /menu)
    
  lin = widget_button(axes,$
    value = '  linear',$
    uname = 'center_px_counts_vs_pixel_linear')
    
  log = widget_button(axes,$
    value = '* logarithmic',$
    uname = 'center_px_counts_vs_pixel_log')
    
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
pro center_px_counts_vs_pixel_base, event=event, $
    top_base=top_base, $
    center_pixel=center_pixel, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
    top_base = 0L
  endif else begin
    id = widget_info(top_base, find_by_uname=parent_base_uname)
    widget_control, top_base, get_uvalue=global
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = 0L
  center_px_counts_vs_pixel_base_gui, _base, $
    parent_base_geometry
    
  global_counts = ptr_new({ global: global,$
    counts_vs_pixel_scale_is_linear: 0b, $
    main_event: event, $
    top_base: top_base, $
    left_click: 0b })
    
  (*global).center_px_counts_vs_pixel_base_id = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  widget_control, _base, set_uvalue=global_counts
  
  XMANAGER, "center_px_counts_vs_pixel_base", _base, $
    GROUP_LEADER = ourGroup, $
    /NO_BLOCK
    
  _id = widget_info(_base, find_by_uname='center_px_counts_vs_pixel_draw')
  widget_control, _id, GET_VALUE = _plot_id
  wset, _plot_id
  
  display_counts_vs_pixel, base=_base, global
  
end

