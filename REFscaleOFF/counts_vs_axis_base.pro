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
pro counts_vs_axis_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_axis_plot
  
  case Event.id of
  
    widget_info(event.top, find_by_uname='counts_vs_axis_base'): begin
    
      id = widget_info(event.top, find_by_uname='counts_vs_axis_base')
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
pro counts_vs_axis_base_gui, wBase, $
    parent_base_geometry, $
    yoffset = yoffset, $
    title = title, $
    plot_uname = plot_uname, $
    xsize = xsize, $
    ysize = ysize
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
    UNAME        = 'counts_vs_axis_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    kill_notify  = 'counts_vs_axis_base_killed', $
    /column,$
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
  draw = widget_draw(wBase,$
    scr_xsize = xsize,$
    scr_ysize = ysize,$
    uname = plot_uname)
    
end

pro counts_vs_axis_base_killed, id
  compile_opt idl2
  
    catch, error
  if (error ne 0) then begin
  catch,/cancel
  return
  endif
  
    widget_control, id, get_uvalue=global_axis_plot
    event = (*global_axis_plot).parent_event
   refresh_plot, event
  
end

;+
; :Description:
;   base that will show the x, y, counts values
;   as well as the counts vs tof and counts vs pixel of cursor
;   position
;
; :Keywords:
;    main_base
;    event
;
; :Author: j35
;-
pro counts_vs_axis_base, event=event, $
    parent_base_uname = parent_base_uname, $
    xaxis = xaxis ;'tof' or 'pixel'
  compile_opt idl2
  
  if (n_elements(spin_state) eq 0) then spin_state = 0
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_plot
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  case (xaxis) of
    'tof': begin
      yoffset = 20
      title = 'Counts vs tof'
      plot_uname = 'counts_vs_xaxis_plot_uname'
      (*global_plot).counts_vs_xaxis_plot_uname = plot_uname
    end
    'pixel': begin
      yoffset = 40
      title = 'Counts vs pixel'
      plot_uname = 'counts_vs_yaxis_plot_uname'
      (*global_plot).counts_vs_yaxis_plot_uname = plot_uname
    end
    else:
  endcase
  
  xsize = 300
  ysize = 300
  
  _base = ''
  counts_vs_axis_base_gui, _base, $
    parent_base_geometry, $
    yoffset = yoffset, $
    title = title, $
    plot_uname = plot_uname, $
    xsize = xsize, $
    ysize = ysize
    
  case (xaxis) of
    'tof': (*global_plot).counts_vs_xaxis_base = _base
    'pixel': (*global_plot).counts_vs_yaxis_base = _base
    else:
  endcase
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_axis_plot = PTR_NEW({ _base: _base,$
    xsize: xsize, $
    parent_event: event, $
    plot_uname: plot_uname, $
    ysize: ysize, $
    global: global_plot })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_axis_plot
  
  XMANAGER, "counts_vs_axis_base", _base, GROUP_LEADER = ourGroup, /NO_BLOCK
  
end

