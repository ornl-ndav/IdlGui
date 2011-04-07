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
  
  case Event.id of
      
    else:
    
  endcase
  
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
    /column,$
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
  min_x_value = xrange[0]
  max_x_value = xrange[1]
  min_y_value = yrange[0]
  max_y_value = yrange[1]
  
  ;xrange
  row1 = widget_base(wBase,$
    /row)

  xmin = cw_field(row1,$
  xsize = 10,$
  /float,$
  title = 'Xmin:',$
  /row,$
  value = min_x_value,$
  /return_events, $
  uname = 'xy_range_xmin_uname')
  
  space = widget_label(row1,$
  value = '     ')
  
  xmax = cw_field(row1,$
  xsize = 10,$
  /float,$
  title = 'Xmax:',$
  /row,$
  value = max_x_value,$
  /return_events, $
  uname = 'xy_range_xmax_uname')
  
  ;yrange
  row2 = widget_base(wBase,$
    /row)

  ymin = cw_field(row2,$
  xsize = 10,$
  /float,$
  title = 'Ymin:',$
  /row,$
  value = min_y_value,$
  /return_events, $
  uname = 'xy_range_ymin_uname')
  
  space = widget_label(row2,$
  value = '     ')
  
  ymax = cw_field(row2,$
  xsize = 10,$
  /float,$
  title = 'Ymax:',$
  /row,$
  value = max_y_value,$
  /return_events, $
  uname = 'xy_range_ymax_uname')

  ;full reset
  row3 = widget_base(wBase,$
  /align_center, $
  /row)
  
  reset = widget_button(row3,$
  value = 'Full reset',$
  uname = 'xy_range_full_reset_uname',$
  scr_xsize = 100)
    
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
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global_plot
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
    main_event: event, $
    global_plot: global_plot })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_info
  
  XMANAGER, "xy_range_input_base", _base, GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup='xy_range_base_cleanup'
    
end

