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
pro px_vs_tof_counts_vs_axis_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_axis_plot
  
  case Event.id of
  
    ;counts vs tof plot
    widget_info(event.top, $
      find_by_uname='px_vs_tof_counts_vs_xaxis_plot_uname'): begin
      px_vs_tof_counts_vs_xaxis_draw_eventcb, event
    end
    
    ;counts vs pixel plot
    widget_info(event.top, $
      find_by_uname='px_vs_tof_counts_vs_yaxis_plot_uname'): begin
      px_vs_tof_counts_vs_yaxis_draw_eventcb, event
    end
    
    widget_info(event.top, $
      find_by_uname='px_vs_tof_counts_vs_axis_base'): begin
      
      id = widget_info(event.top, find_by_uname='px_vs_tof_counts_vs_axis_base')
      ;widget_control, id, /realize
      geometry = widget_info(id,/geometry)
      new_xsize = geometry.scr_xsize
      new_ysize = geometry.scr_ysize
      
      (*global_axis_plot).xsize = new_xsize
      (*global_axis_plot).ysize = new_ysize
      
      widget_control, id, xsize = new_xsize
      widget_control, id, ysize = new_ysize
      
      id = widget_info(event.top, find_by_uname=(*global_axis_plot).plot_uname)
      widget_control, id, draw_xsize = new_xsize
      widget_control, id, draw_ysize = new_ysize
      
    end
    
    else:
    
  endcase
  
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
pro px_vs_tof_counts_vs_axis_yaxis_type, event
  compile_opt idl2
  
  uname = widget_info(event.id, /uname)
  widget_control, event.top, get_uvalue=global_axis_plot
  global_px_vs_tof = (*global_axis_plot).global
  
  if (uname eq 'counts_vs_axis_yaxis_lin') then begin
    set1_value = '*  ' + 'linear'
    set2_value = '   ' + 'logarithmic'
    default_yscale_settings = 0
  endif else begin
    set1_value = '   ' + 'linear'
    set2_value = '*  ' + 'logarithmic'
    default_yscale_settings = 1
  endelse
  (*global_axis_plot).default_yscale_settings = default_yscale_settings
  
  putValue, event=event, 'counts_vs_axis_yaxis_lin', set1_value
  putValue, event=event, 'counts_vs_axis_yaxis_log', set2_value
  
  xaxis = (*global_axis_plot).xaxis
  
  case (xaxis) of
    'tof': begin
      px_vs_tof_plot_counts_vs_xaxis, event=event
    end
    'pixel': begin
      px_vs_tof_plot_counts_vs_yaxis, event=event
    end
    else:
  endcase
  
end


;+
; :Description:
;    Build the GUI
;
; :Params:
;    wBase
;    parent_base_geometry
;
; :Keywords:
;    yoffset
;    title
;    plot_uname
;    xsize
;    ysize
;
; :Author: j35
;-
pro px_vs_tof_counts_vs_axis_base_gui, wBase, $
    parent_base_geometry, $
    yoffset = yoffset, $
    title = title, $
    plot_uname = plot_uname, $
    xsize = xsize, $
    ysize = ysize, $
    yaxis_type = yaxis_type
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xsize
  xoffset += main_base_xoffset
  
  yoffset += main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  title = title
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'px_vs_tof_counts_vs_axis_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    kill_notify  = 'px_vs_tof_counts_vs_axis_base_killed', $
    /column,$
    mbar = bar1, $
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
  draw = widget_draw(wBase,$
    scr_xsize = xsize,$
    scr_ysize = ysize,$
    /retain,$
    /button_events, $
    /motion_events, $
    /tracking_events, $
    uname = plot_uname)
    
  yaxis = widget_button(bar1,$
    value = 'Y-axis',$
    /menu)
    
  if (yaxis_type eq 0) then begin
    value_lin = '*  linear'
    value_log = '   logarithmic'
  endif else begin
    value_lin = '   linear'
    value_log = '*  logarithmic'
  endelse
  
  lin = widget_button(yaxis,$
    value = value_lin, $
    event_pro = 'px_vs_tof_counts_vs_axis_yaxis_type',$
    uname = 'counts_vs_axis_yaxis_lin')
    
  log = widget_button(yaxis,$
    value = value_log, $
    event_pro = 'px_vs_tof_counts_vs_axis_yaxis_type',$
    uname = 'counts_vs_axis_yaxis_log')
    
end

pro px_vs_tof_counts_vs_axis_base_killed, id
  compile_opt idl2
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return
  endif
  
  widget_control, id, get_uvalue=global_axis_plot
  event = (*global_axis_plot).parent_event
  px_vs_tof_refresh_plot, event
  
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
pro px_vs_tof_counts_vs_axis_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_axis_plot, /no_copy
  
  if (n_elements(global_axis_plot) eq 0) then return
  
  ptr_free, global_axis_plot
  
end

;+
; :Description:
;   base that will show the x, y, counts values
;   as well as the counts vs qx and counts vs qz of cursor
;   position
;
; :Keywords:
;    main_base
;    event
;
; :Author: j35
;-
pro px_vs_tof_counts_vs_axis_base, event=event, $
    parent_base_uname = parent_base_uname, $
    xaxis = xaxis ;'tof' or 'pixel'
  compile_opt idl2
  
  if (n_elements(spin_state) eq 0) then spin_state = 0
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_px_vs_tof
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  case (xaxis) of
    'tof': begin
      yoffset = 130
      title = 'Counts vs tof (integrated over all pixels)'
      plot_uname = 'px_vs_tof_counts_vs_xaxis_plot_uname'
      (*global_px_vs_tof).counts_vs_xaxis_plot_uname = plot_uname
      yaxis_type = (*global_px_vs_tof).counts_vs_xaxis_yaxis_type
    end
    'pixel': begin
      yoffset = 500
      title = 'Counts vs pixel (integrated over all TOFs)'
      plot_uname = 'px_vs_tof_counts_vs_yaxis_plot_uname'
      (*global_px_vs_tof).counts_vs_yaxis_plot_uname = plot_uname
      yaxis_type = (*global_px_vs_tof).counts_vs_yaxis_yaxis_type
    end
    else:
  endcase
  
  xsize = 600
  ysize = 300
  
  _base = ''
  px_vs_tof_counts_vs_axis_base_gui, _base, $
    parent_base_geometry, $
    yoffset = yoffset, $
    title = title, $
    plot_uname = plot_uname, $
    xsize = xsize, $
    ysize = ysize, $
    yaxis_type = yaxis_type
    
  data2d_linear = (*(*global_px_vs_tof).data2d_linear)
  case (xaxis) of
    'tof': begin
      (*global_px_vs_tof).counts_vs_xaxis_base = _base
    end
    'pixel': begin
      (*global_px_vs_tof).counts_vs_yaxis_base = _base
    end
    else:
  endcase
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_axis_plot = PTR_NEW({ _base: _base,$
    xsize: xsize, $
    default_yscale_settings: yaxis_type, $ ;0 for linear, 1 for logarithmic
    parent_event: event, $
    xaxis: xaxis, $ ;'tof' or 'pixel'
    plot_uname: plot_uname, $
    ysize: ysize, $
    xrange: fltarr(2), $  ;ex: 0,20,000   xaxis min and max value
    ymax: 0L, $       ;max y value (counts)
    main_event: event, $
    left_clicked: 0b, $ ;status of left click button
    right_clicked: 0b, $  ;status of right click button
    global: global_px_vs_tof })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_axis_plot
  
  XMANAGER, "px_vs_tof_counts_vs_axis_base", _base, $
    GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup='px_vs_tof_counts_vs_axis_base_cleanup'
    
  case (xaxis) of
    'tof': begin
      px_vs_tof_plot_counts_vs_xaxis, base=_base
    end
    'pixel': begin
      px_vs_tof_plot_counts_vs_yaxis, base=_base
    end
    else:
  endcase
  
  ;display edge of selection if there is already one
  px_vs_tof_plot_counts_vs_axis_selection, base=_base, $
    xaxis=xaxis, $
    (*global_px_vs_tof).draw_zoom_data_selection
    
end

