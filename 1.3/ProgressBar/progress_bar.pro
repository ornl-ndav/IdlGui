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
pro progress_bar_event, Event
  compile_opt idl2
  
  case Event.id of
  
    ;cancel tof selected
    widget_info(event.top, $
      find_by_uname='cancel_tof_selection_selected_uname'): begin
      widget_control, event.top, get_uvalue=global_info
      top_base = (*global_info).top_base
      widget_control, top_base, /destroy
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    Builds the GUI
;
; :Params:
;    wBase
;    parent_base_geometry
;
;
;
; :Author: j35
;-
pro progress_bar_gui, wBase, $
    parent_base_geometry
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xsize/3
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset + main_base_ysize/3
  
  ourGroup = WIDGET_BASE()
  
  title = 'Broad Reflective Peak Mode Status'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'broad_mode_progress_bar_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    ;    kill_notify  = 'tof_selection_base_killed', $
    /column,$
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
  top_base = widget_base(wBase,$
    /column)
    
  row1 = widget_base(top_base,$
    /row)
  label1 = widget_label(row1,$
    value = 'Spin States')
  space = widget_label(row1,$
    value = '                       ')
  label2 = widget_label(row1,$
    value = 'Progress')
    
  ;1 row for each spin state
  spin_list = ['Off_Off',$
    'Off_On','On_Off','On_On']
  for i=0,3 do begin
    row2 = widget_base(top_base,$
      uname = 'progress_bar_base_of_spin_state_' + spin_list[i],$
      /row)
    label1 = widget_label(row2,$
      scr_xsize = 60,$
      /align_right,$
      value = spin_list[i])
    space = widget_label(row2,$
      value = '   ')
    progress_bar_draw = widget_draw(row2,$
      scr_xsize = 300,$
      scr_ysize = 35,$
      uname = 'progress_bar_of_spin_state_' + spin_list[i])
  endfor
  
  space = widget_label(top_base,$
    value = ' ')
    
  row3 = widget_base(top_base,$
    /row)
  label = widget_label(row3,$
    value = 'Post Processing')
  space = widget_label(row3,$
    value = '   ')
  post_processing = widget_draw(row3,$
    scr_xsize = 250,$
    scr_ysize = 35,$
    uname = 'post_processing_uname')
    
  space = widget_label(top_base,$
    value = ' ')
    
  row4 = widget_base(top_base,$
    /row)
  label = widget_label(row4,$
    value = 'Estimated time left:')
  value = widget_label(row4,$
    value = 'Calculating ...',$
    frame=1,$
    uname = 'time_left_value_uname')
  units = widget_label(row4,$
    value = 'mn (recalculated after each step)')
    
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
pro pixel_selection_base_killed, id
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
pro counts_info_base_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global_progress, /no_copy
  
  if (n_elements(global_progress) eq 0) then return
  
  ptr_free, global_progress
  
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
pro progress_bar, event=event, $
    top_base=top_base, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  endif else begin
    id = widget_info(top_base, find_by_uname=parent_base_uname)
    widget_control, top_base, get_uvalue=global
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = 0L
  progress_bar_gui, _base, $
    parent_base_geometry
    
  WIDGET_CONTROL, _base, /REALIZE
  
  global_progress = PTR_NEW({ _base: _base,$
    top_base: top_base, $
    global: global})
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_progress
  
  XMANAGER, "progress_bar", _base, GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup='progress_bar_cleanup'
    
end

