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
pro refpix_counts_vs_pixel_base_event, Event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_counts
  global_refpix = (*global_counts).global_refpix
  
  case Event.id of
  
    ;main base
    widget_info(event.top, find_by_uname='refpix_counts_vs_pixel_base'): begin
    
      id = widget_info(event.top, find_by_uname='refpix_counts_vs_pixel_base')
      geometry = widget_info(id, /geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      
      id = widget_info(event.top, find_by_uname='refpix_counts_vs_pixel_draw')
      widget_control, id, draw_xsize = new_xsize
      widget_control, id, draw_ysize = new_ysize
      
      display_counts_vs_pixel, event=event, global_refpix
    end
    
    ;linear scale
    widget_info(event.top, find_by_uname='refpix_counts_vs_pixel_linear'): begin
      refpix_counts_switch_axex_type, event
    end
    
    widget_info(event.top, find_by_uname='refpix_counts_vs_pixel_log'): begin
      refpix_counts_switch_axex_type, event
    end
    
    ;plot
    widget_info(event.top, find_by_uname='refpix_counts_vs_pixel_draw'): begin
    
      if (event.press eq 1) then begin ;left click
        (*global_counts).left_click = 1b
        
        refpix_pixels = (*global_refpix).refpix_pixels
        
        _id = widget_info(event.top, find_by_uname='refpix_counts_vs_pixel_draw')
        widget_control, event.top, get_uvalue=global_counts
        widget_control, _id, GET_VALUE = _plot_id
        wset, _plot_id
        
        cursor, x,y, /data
        check_pixel_value, x
        
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
        check_pixel_value, x
        
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
;    Make sure the pixel value is within the following range [0,303]
;
; :Params:
;    x
;
; :Author: j35
;-
pro check_pixel_value, x
  compile_opt idl2
  
  if (x lt 0) then begin
    x=0
    return
  endif
  
  if (x gt 303) then begin
    x = 303
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
pro refpix_counts_switch_axex_type, event
  compile_opt idl2
  
  uname = widget_info(event.id, /uname)
  widget_control, event.top, get_uvalue=global_counts
  global_refpix = (*global_counts).global_refpix
  
  if (uname eq 'refpix_counts_vs_pixel_linear') then begin
    set1_value = '* ' + 'linear'
    set2_value = '  ' + 'logarithmic'
    (*global_refpix).counts_vs_pixel_scale_is_linear = 1b
  endif else begin
    set1_value = '  ' + 'linear'
    set2_value = '* ' + 'logarithmic'
    (*global_refpix).counts_vs_pixel_scale_is_linear = 0b
  endelse
  
  putValue, event=event, 'refpix_counts_vs_pixel_linear', set1_value
  putValue, event=event, 'refpix_counts_vs_pixel_log', set2_value
  
  display_counts_vs_pixel, event=event, global_refpix
  
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
pro display_counts_vs_pixel, base=base, event=event, global_refpix
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    _id = widget_info(event.top, find_by_uname='refpix_counts_vs_pixel_draw')
    widget_control, event.top, get_uvalue=global_counts
  endif else begin
    _id = widget_info(base, find_by_uname='refpix_counts_vs_pixel_draw')
    widget_control, base, get_uvalue=global_counts
  endelse
  widget_control, _id, GET_VALUE = _plot_id
  wset, _plot_id
  
  counts_vs_pixel = (*(*global_refpix).counts_vs_pixel)
  
  ;xrange
  xrange = [0,303]
  
  ;get ymax and ymin
  ymax = max(counts_vs_pixel,min=ymin)
  yrange = [1,ymax]
  
  counts_vs_pixel_scale_is_linear = $
    (*global_refpix).counts_vs_pixel_scale_is_linear
    
  refpix_pixels = (*global_refpix).refpix_pixels
  pixel1 = refpix_pixels[0]
  pixel2 = refpix_pixels[1]
  
  ;1b for pixel1, 0b for pixel2
  pixel1_working = (*global_refpix).pixel1_selected
  if (pixel1_working) then begin
    _pixel1_size = 3
    _pixel2_size = 1
  endif else begin
    _pixel1_size = 1
    _pixel2_size = 3
  endelse
  
  ;if linear or log scale
  if (counts_vs_pixel_scale_is_linear eq 1) then begin ;linear scale
  
    plot, counts_vs_pixel, $
      xrange=xrange, $
      xstyle=1, $
      xtitle='Pixel',$
      ytitle='Counts'
      
    if (pixel1 ne 0) then begin
      plots, pixel1, 0
      plots, pixel1, ymax, /continue, color=fsc_color("red"), $
        thick=_pixel1_size
    endif
    
    if (pixel2 ne 0) then begin
      plots, pixel2, 0, /data
      plots, pixel2, ymax, /data, /continue, color=fsc_color("red"), $
        thick=_pixel2_size
    endif
    
    if (pixel1 ne 0 && pixel2 ne 0) then begin
      refpix = (float(pixel1) + float(pixel2))/2.
      plots, refpix, 0, /data
      plots, refpix, ymax, /data, /continue, color=fsc_color("blue")
    endif
    
  endif else begin
  
    plot, counts_vs_pixel, $
      /ylog, $
      yrange=yrange, $
      xrange=xrange, $
      xstyle=1, $
      xtitle='Pixel', $
      ytitle='Counts'
      
    if (pixel1 ne 0) then begin
      plots, pixel1, 1, /data
      plots, pixel1, ymax, /data, /continue, color=fsc_color("red"), $
        thick=_pixel1_size
    endif
    
    if (pixel2 ne 0) then begin
      plots, pixel2, 1, /data
      plots, pixel2, ymax, /data, /continue, color=fsc_color("red"), $
        thick=_pixel2_size
    endif
    
    if (pixel1 ne 0 && pixel2 ne 0) then begin
      refpix = (float(pixel1) + float(pixel2))/2.
      plots, refpix, 1, /data
      plots, refpix, ymax, /data, /continue, color=fsc_color("blue")
    endif
    
  endelse
  
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
pro refpix_counts_vs_pixel_base_gui, wBase, $
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
    UNAME        = 'refpix_counts_vs_pixel_base', $
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
    uname = 'refpix_counts_vs_pixel_draw')
    
  axes = widget_button(bar1,$
    value = 'Axes',$
    /menu)
    
  lin = widget_button(axes,$
    value = '  linear',$
    uname = 'refpix_counts_vs_pixel_linear')
    
  log = widget_button(axes,$
    value = '* logarithmic',$
    uname = 'refpix_counts_vs_pixel_log')
    
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
pro refpix_counts_vs_pixel_base, event=event, $
    top_base=top_base, $
    refpix=refpix, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global_refpix
    top_base = 0L
  endif else begin
    id = widget_info(top_base, find_by_uname=parent_base_uname)
    widget_control, top_base, get_uvalue=global_refpix
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = 0L
  refpix_counts_vs_pixel_base_gui, _base, $
    parent_base_geometry
    
  global_counts = ptr_new({ global_refpix: global_refpix,$
    top_base: top_base, $
    left_click: 0b })
    
  (*global_refpix).refpix_counts_vs_pixel_base_id = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  widget_control, _base, set_uvalue=global_counts
  
  XMANAGER, "refpix_counts_vs_pixel_base", _base, $
    GROUP_LEADER = ourGroup, $
    /NO_BLOCK
    
  display_counts_vs_pixel, base=_base, global_refpix
  
  if (refpix ne '') then begin
  
  
    counts_vs_pixel = (*(*global_refpix).counts_vs_pixel)
    ymax = max(counts_vs_pixel,min=ymin)
    
    _id = widget_info(_base, find_by_uname='refpix_counts_vs_pixel_draw')
    widget_control, _id, GET_VALUE = _plot_id
    wset, _plot_id
    _refpix = float(refpix)
    plots, _refpix, 1, /data
    plots, _refpix, ymax, /data, /continue, $
      color=fsc_color("green"), $
      thick=2,$
      linestyle=1
      
  endif
  
end

