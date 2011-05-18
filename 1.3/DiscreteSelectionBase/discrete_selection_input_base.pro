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
;    Makes the conversion from tof_range value to tof_range index
;
; :Params:
;    tof_range
;    tof_axis
;
; :Author: j35
;-
function get_index_tof_range, tof_range, tof_axis
  compile_opt idl2
  
  tof_min = tof_range[0]
  case (tof_min) of
    -1: tof_axis_min = 0
    else: begin
      _index = where(tof_min ge tof_axis, nbr)
      if (nbr eq 0) then begin
        tof_axis_min = 0
      endif else begin
        tof_axis_min = _index[-1]+1
      endelse
    end
  endcase
  
  tof_max = tof_range[1]
  case (tof_max) of
    -1: tof_axis_max = -1
    else: begin
      _index = where(tof_axis le tof_max, nbr)
      if (nbr eq 0) then begin
        tof_axis_max = -1
      endif else begin
        tof_axis_max = _index[-1]
      endelse
    end
  endcase
  
  return, [tof_axis_min, tof_axis_max]
end

;+
; :Description:
;   main base event
;
; :Params:
;   Event
;
; :Author: j35
;-
pro discrete_selection_input_base_event, Event
  compile_opt idl2
  
  case Event.id of
  
    ;validate ROIs selected
    widget_info(event.top, $
      find_by_uname='validate_discrete_selection_selected_uname'): begin
      
      top_base = (*global_info).top_base
      widget_control, top_base, /destroy
      
    end
    
    ;cancel tof selected
    widget_info(event.top, $
      find_by_uname='cancel_discrete_selection_selected_uname'): begin
      widget_control, event.top, get_uvalue=global_info
      top_base = (*global_info).top_base
      widget_control, top_base, /destroy
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    Builds the GUI of the info base
;
; :Params:
;    wBase
;    parent_base_geometry
;
;
;
; :Author: j35
;-
pro discrete_selection_input_base_gui, wBase, $
    parent_base_geometry
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xsize
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  title = 'Discrete peaks selection'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'discrete_peak_selection_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    kill_notify  = 'discrete_peak_selection_base_killed', $
    /column,$
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
  row = widget_base(wBase,$
    /row)
    
  col1 =  widget_base(row,$
    /column)
  label = widget_label(col1,$
    value = 'ROIs (ex: Pxmin,Pxmax)')
  rois = widget_text(col1,$
    /editable,$
    xsize=10,$
    ysize=20,$
    uname = 'discrete_roi_selection_text_field')
    
  col2 = widget_base(row,$
    /column)
  load = widget_button(col2,$
    scr_xsize=100,$
    value = 'Load...')
  save = widget_button(col2,$
    scr_xsize=100,$
    value = 'Save...')
    
  for i=0,1 do begin
    space = widget_label(col2,$
      value = ' ')
  endfor
  
  row2=widget_base(col2,$
    /row)
  label = widget_label(row2,$
    value = 'From Px')
  value = widget_text(row2,$
    value = 'N/A',$
    xsize=3,$
    /editable,$
    uname='discrete_roi_selection_from_px')
    
  row2=widget_base(col2,$
    /row)
  label = widget_label(row2,$
    value = '  to Px')
  value = widget_text(row2,$
    value = 'N/A',$
    xsize=3,$
    /editable,$
    uname='discrete_roi_selection_to_px')
    
  plus = widget_button(col2,$
    value = '+',$
    scr_xsize=50,$
    uname='discrete_roi_selection_plus')
    
  row4 = widget_base(wBase,$
    /row)
  cancel = widget_button(row4,$
    value = 'Cancel',$
    uname = 'cancel_discrete_selection_selected_uname',$
    scr_xsize = 50)
  space = widget_label(row4,$
    value = '  ')
  row4 = widget_button(row4,$
    value = 'Use these ROIs and EXIT',$
    uname = 'validate_discrete_selection_selected_uname')
    
end

;+
; :Description:
;    Save the tof defined in the tof input boxes
;
; :Keywords:
;    base
;
; :Author: j35
;-
pro save_discrete_selection_tofs, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_info
  global_tof_selection = (*global_info).global_tof_selection
  
  tof_selection_tof = (*global_tof_selection).tof_selection_tof
  
  tof1 = getValue(event=event, uname='discrete_selection_tof1_uname')
  tof2 = getValue(event=event, uname='discrete_selection_tof2_uname')
  
  tof_range = (*global_tof_selection).xrange
  xmin = tof_range[0]
  xmax = tof_range[1]
  
  tof1 = (tof1 gt xmax) ? -1 : tof1
  tof2 = (tof2 gt xmax) ? -1 : tof2
  
  tof1 = (tof1 lt xmin) ? -1 : tof1
  tof2 = (tof2 lt xmin) ? -1 : tof2
  
  tof_selection_tof = [tof1,tof2]
  (*global_tof_selection).tof_selection_tof = tof_selection_tof
  
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
pro discrete_pixel_selection_base_killed, id
  compile_opt idl2
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return
  endif
  
  ;get global structure
  widget_control,id,get_uvalue=global_info
  event = (*global_info).parent_event
  refresh_plot, event
  
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
pro discrete_counts_info_base_cleanup, tlb
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
pro discrete_selection_input_base, event=event, $
    top_base=top_base, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof_selection
  endif else begin
    id = widget_info(top_base, find_by_uname=parent_base_uname)
    widget_control, top_base, get_uvalue=global_tof_selection
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  tof_selection_tof = (*global_tof_selection).tof_selection_tof
  
  _base = 0L
  discrete_selection_input_base_gui, _base, $
    parent_base_geometry
    
  (*global_tof_selection).tof_selection_input_base = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_info = PTR_NEW({ _base: _base,$
    top_base: top_base, $
    global_tof_selection: global_tof_selection })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_info
  
  XMANAGER, "discrete_selection_input_base", _base, GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup='discrete_counts_info_base_cleanup'
    
end

