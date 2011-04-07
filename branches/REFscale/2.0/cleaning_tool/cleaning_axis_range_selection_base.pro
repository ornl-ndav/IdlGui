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
pro xy_range_input_base_event, Event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_info
  main_base_id = (*global_info).main_base_id
  global_plot = (*global_info).global_plot
  
  case Event.id of
  
    ;full reset
    widget_info(event.top, find_by_uname='xy_range_full_reset_uname'): begin
      refresh_plot, base=main_base_id, /init
      refresh_xy_range_input_fields, event=event, global_plot=global_plot
    end
    
    ;xmin, xmax, ymin and ymax
    widget_info(event.top, find_by_uname='xy_range_xmin_uname'): begin
      save_new_xy_range_input_fields, event
      refresh_plot, base=main_base_id
    end
    widget_info(event.top, find_by_uname='xy_range_xmax_uname'): begin
      save_new_xy_range_input_fields, event
      refresh_plot, base=main_base_id
    end
    widget_info(event.top, find_by_uname='xy_range_ymin_uname'): begin
      save_new_xy_range_input_fields, event
      refresh_plot, base=main_base_id
    end
    widget_info(event.top, find_by_uname='xy_range_ymax_uname'): begin
      save_new_xy_range_input_fields, event
      refresh_plot, base=main_base_id
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    Retrieves the various xmin, xmax, ymin and ymax values from the
;    range input base and reorder them, save them in xrange and yrange
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro save_new_xy_range_input_fields, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_info
  global_plot = (*global_info).global_plot
  
  x1 = float(getValue(event=event, uname='xy_range_xmin_uname'))
  x2 = float(getValue(event=event, uname='xy_range_xmax_uname'))
  
  y1 = float(getValue(event=event, uname='xy_range_ymin_uname'))
  y2 = float(getValue(event=event, uname='xy_range_ymax_uname'))
  
  xmin = min([x1,x2],max=xmax)
  ymin = min([y1,y2],max=ymax)
  
  putValue, event=event, uname='xy_range_xmin_uname', value=xmin
  putValue, event=event, uname='xy_range_xmax_uname', value=xmax
  
  putValue, event=event, uname='xy_range_ymin_uname', value=ymin
  putValue, event=event, uname='xy_range_ymax_uname', value=ymax
  
  xrange = fltarr(2)
  yrange = fltarr(2)
  
  xrange[0] = xmin
  xrange[1] = xmax
  
  yrange[0] = ymin
  yrange[1] = ymax
  
  (*global_plot).xrange = xrange
  (*global_plot).yrange = yrange
  
end

;+
; :Description:
;    This routine refresh the contains (xmin, xmax, ymin and ymax) of the
;    'X and Y range selection tool' input base with the full x and y range
;    (full reset of axes)
;
;
;
; :Keywords:
;    event
;    global_plot
;
; :Author: j35
;-
pro refresh_xy_range_input_fields, event=event, global_plot=global_plot
  compile_opt idl2
  
  xrange = (*global_plot).xrange
  yrange = (*global_plot).yrange
  
  xmin = xrange[0]
  xmax = xrange[1]
  ymin = yrange[0]
  ymax = yrange[1]
  
  putValue, event=event, uname='xy_range_xmin_uname', $
    value=strcompress(xmin,/remove_all)
  putValue, event=event, uname='xy_range_xmax_uname', $
    value=strcompress(xmax,/remove_all)
    
  putValue, event=event, uname='xy_range_ymin_uname', $
    value=strcompress(ymin,/remove_all)
  putValue, event=event, uname='xy_range_ymax_uname', $
    value=strcompress(ymax,/remove_all)
    
end

;+
; :Description:
;    Builds the GUI of the X & Y input range base
;
; :Params:
;    wBase
;    parent_base_geometry
;
;
;
; :Author: j35
;-
pro xy_range_input_base_gui, wBase, $
    parent_base_geometry, $
    xrange, $
    yrange
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xsize
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  title = 'X and Y range selection tool'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'xy_range_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    kill_notify  = 'xy_range_base_killed', $
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
  min_x_value = xrange[0]
  max_x_value = xrange[1]
  min_y_value = yrange[0]
  max_y_value = yrange[1]
  
  ;xrange
  xminbase = widget_base(wBase,$
    xoffset = 130,$
    yoffset = 255,$
    /row)
  xmin = cw_field(xminbase,$
    xsize = 10,$
    /float,$
    /row,$
    title='',$
    value = min_x_value,$
    /return_events, $
    uname = 'xy_range_xmin_uname')
    
  xmaxbase = widget_base(wBase,$
    xoffset = 285,$
    yoffset = 255,$
    /row)
  xmax = cw_field(xmaxbase,$
    xsize = 10,$
    /float,$
    /row,$
    title='',$
    value = max_x_value,$
    /return_events, $
    uname = 'xy_range_xmax_uname')
    
  ;yrange
  yminbase = widget_base(wBase,$
    xoffset = 20,$
    yoffset = 180,$
    /row)
  ymin = cw_field(yminbase,$
    xsize = 10,$
    /float,$
    /row,$
    title='',$
    value = min_y_value,$
    /return_events, $
    uname = 'xy_range_ymin_uname')
    
  ymaxbase = widget_base(wBase,$
    xoffset = 20,$
    yoffset = 10,$
    /row)
  ymax = cw_field(ymaxbase,$
    xsize = 10,$
    /float,$
    /row,$
    title='',$
    value = max_y_value,$
    /return_events, $
    uname = 'xy_range_ymax_uname')
    
  reset = widget_button(wBase,$
    xoffset = 200,$
    yoffset = 80,$
    value = 'range full reset',$
    uname = 'xy_range_full_reset_uname',$
    scr_xsize = 150,$
    scr_ysize = 35)
    
  draw = widget_draw(wBase,$
    xsize  = 385,$
    ysize  = 322,$
    retain = 2,$
    uname  = 'xy_range_draw')
    
end

;+
; :Description:
;    Killed routine
;
; :Params:
;    id
;
;
;
; :Author: j35
;-
pro xy_range_base_killed, id
  compile_opt idl2
  
  ;  catch, error
  ;  if (error ne 0) then begin
  ;    catch,/cancel
  ;    return
  ;  endif
  
  ;get global structure
  widget_control,id,get_uvalue=global_info
  event = (*global_info).parent_event
  
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
pro xy_range_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_info, /no_copy
  
  if (n_elements(global_info) eq 0) then return
  
  ptr_free, global_info
  
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
pro xy_range_input_base, event=event, $
    main_base_id=main_base_id, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global_plot
  endif else begin
    widget_control, main_base_id, get_uvalue=global_plot
    id = main_base_id
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  xrange = (*global_plot).xrange
  yrange = (*global_plot).yrange
  
  _base = 0L
  xy_range_input_base_gui, _base, $
    parent_base_geometry, $
    xrange, $
    yrange
    
  (*global_plot).xy_range_input_base_id = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_info = PTR_NEW({ _base: _base,$
    main_base_id: id, $
    ;    main_event: event, $
    global_plot: global_plot })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_info
  
  XMANAGER, "xy_range_input_base", _base, GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup='xy_range_base_cleanup'
    
  mode = read_png('REFscale_images/RangePlot.png')
  uname = 'xy_range_draw'
  mode_id = WIDGET_INFO(_base, FIND_BY_UNAME=uname)
  ;mode
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, mode, 0,0,/true
  
end

