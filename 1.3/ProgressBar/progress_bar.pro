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
  
  widget_control, event.top, get_uvalue=global_progress
  global = (*global_progress).global
  
  case Event.id of
  
    ;cancel broad reduction
    widget_info(event.top, $
      find_by_uname='cancel_broad_reflective_peak_mode_reduction'): begin
      (*global).stop_broad_reduction = 1b
    end
    
    ;done button (will close the base)
    widget_info(event.top, $
      find_by_uname='close_progress_bar_base_uname'): begin
      id = widget_info(event.top, find_by_uname='broad_mode_progress_bar_base')
      widget_control, id, /destroy
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;    This routine update the various progress bars (spin states and
;    post processing)
;
; :Keywords:
;    event
;    base
;    spin_state      = 'Off_Off'|'Off_On'|'On_Off'|'On_On'
;    post_processing = 1b|0b
;    pre_processing  = 1b|0b
;    increment       = 1b|ob
;
; :Author: j35
;-
pro update_progress_bar, event=event, $
    base=base, $
    spin_state=spin_state, $
    post_processing=post_processing, $
    pre_processing=pre_processing, $
    increment=increment
  compile_opt idl2
  
  if (keyword_set(spin_state)) then begin
    draw_uname = 'progress_bar_of_spin_state_' + spin_state
  endif
  
  if (keyword_set(post_processing)) then begin
    draw_uname = 'post_processing_uname'
  endif
  
  if (keyword_set(pre_processing)) then begin
    draw_uname = 'pre_processing_uname'
  endif
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global_progress
    draw1 = WIDGET_INFO(event,FIND_BY_UNAME=draw_uname)
  endif else begin
    widget_control, base, get_uvalue=global_progress
    draw1 = WIDGET_INFO(base,FIND_BY_UNAME=draw_uname)
  endelse
  
  WIDGET_CONTROL, draw1, GET_VALUE=id
  WSET, id
  erase
  
  geometry = WIDGET_INFO(draw1,/GEOMETRY)
  xsize = geometry.xsize
  ysize = geometry.ysize
  
  ;spin state processing ******************************************************
  if (keyword_set(spin_state)) then begin
  
    map_base, base=base, uname='time_left_base_uname', status=1
    
    spin_state_nbr_steps = (*global_progress).pixel_nbr_steps
    step = (*global_progress).current_step
    
    x1=0
    x2=(float(xsize)/float(spin_state_nbr_steps))*float(step)
    y1=0
    y2=ysize
    
    color=fsc_color("red")
    Polyfill, [x1, x1, x2, x2, x1], [y1, y2, y2, y1, y1], /Device, Color=color
    
    ;get percentage
    percent = (float(step) / float(spin_state_nbr_steps)) * 100.
    text = strcompress(fix(percent),/remove_all) + '%'
    XYouts, x2, y2/2., text, color=fsc_color("blue"), /device
    
    if (step eq spin_state_nbr_steps) then begin
      step=1
    endif else begin
      step++
    endelse
    (*global_progress).current_step = step
    
    global_current_step = (*global_progress).global_current_step
    global_current_step++
    (*global_progress).global_current_step = global_current_step
    
    previous_time = (*global_progress).time_init_s
    current_time = systime(/seconds)
    (*global_progress).time_init_s = current_time
    
    delta_time = current_time - previous_time
    global_current_step = (*global_progress).global_current_step
    total_number_steps = (*global_progress).total_number_steps
    
    _steps_left = total_number_steps - global_current_step
    _time_left = (_steps_left * delta_time)
    
    if (_time_left gt 60) then begin
      putValue, base=base, 'time_left_units_uname', $
        'mn  (recalculated after each step)'
      putValue, base=base, 'time_left_value_uname', $
        strcompress(_time_left/60.,/remove_all)
    endif else begin
      putValue, base=base, 'time_left_units_uname', $
        's  (recalculated after each step)'
      putValue, base=base, 'time_left_value_uname', $
        strcompress(fix(_time_left),/remove_all)
    endelse
    
  endif
  
  
  ;post processing ************************************************************
  if (keyword_set(post_processing)) then begin
  
    map_base, base=base, uname='time_left_base_uname', status=0
    
    post_processing_nbr_steps = (*global_progress).post_processing_nbr_steps
    step = (*global_progress).current_step
    
    x1=0
    x2=(float(xsize)/float(post_processing_nbr_steps))*float(step)
    y1=0
    y2=ysize
    
    color=fsc_color("pink")
    Polyfill, [x1, x1, x2, x2, x1], [y1, y2, y2, y1, y1], /Device, Color=color
    
    ;get percentage
    percent = (float(step) / float(post_processing_nbr_steps)) * 100.
    text = strcompress(fix(percent),/remove_all) + '%'
    XYouts, x2, y2/2., text, color=fsc_color("blue"), /device
    
    if (step eq post_processing_nbr_steps) then begin
      step=0
    endif else begin
      step++
    endelse
    (*global_progress).current_step = step
    
  endif
  
  
  ;pre processing ************************************************************
  if (keyword_set(pre_processing)) then begin
  
    map_base, base=base, uname='time_left_base_uname', status=0
    
    pre_processing_nbr_steps = (*global_progress).pre_processing_nbr_steps
    step = (*global_progress).current_pre_step
    
    x1=0
    x2=(float(xsize)/float(pre_processing_nbr_steps))*float(step)
    y1=0
    y2=ysize
    
    color=fsc_color("pink")
    Polyfill, [x1, x1, x2, x2, x1], [y1, y2, y2, y1, y1], /Device, Color=color
    
    ;get percentage
    percent = (float(step) / float(pre_processing_nbr_steps)) * 100.
    text = strcompress(fix(percent),/remove_all) + '%'
    XYouts, x2, y2/2., text, color=fsc_color("blue"), /device
    
    if (step eq pre_processing_nbr_steps) then begin
      step=0
    endif else begin
      step++
    endelse
    (*global_progress).current_pre_step = step
    
  endif
  
end

;+
; :Description:
;    Builds the GUI
;
; :Params:
;    wBase
;    parent_base_geometry
;    list_working_spin_states     ex: ['Off_Off','Off_On']
;
;
; :Author: j35
;-
pro progress_bar_gui, wBase, $
    parent_base_geometry, $
    list_working_spin_states
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
  label = widget_label(row1,$
    value = 'Pre Processing')
  space = widget_label(row1,$
    value = '   ')
  post_processing = widget_draw(row1,$
    scr_xsize = 250,$
    scr_ysize = 35,$
    uname = 'pre_processing_uname')
    
  space = widget_label(top_base,$
    value = ' ')
    
  ;1 row for each spin state
  spin_list = list_working_spin_states
  sz = n_elements(spin_list)
  i=0
  while (i lt sz) do begin
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
    i++
  endwhile
  
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
    uname = 'time_left_base_uname',$
    map=0,$
    /row)
  label = widget_label(row4,$
    value = 'Estimated time left:')
  value = widget_label(row4,$
    value = 'Calculating ...',$
    frame=1,$
    uname = 'time_left_value_uname')
  units = widget_label(row4,$
    uname = 'time_left_units_uname',$
    /align_left, $
    value = 'mn (recalculated after each step)')
    
  space = widget_label(top_base,$
    value = ' ')
    
  button_row = widget_base(top_base,$
    /row)
    
  ;  cancel = widget_button(button_row,$
  ;    value = 'CANCEL',$
  ;    sensitive=0,$
  ;    scr_xsize = 50,$
  ;    uname = 'cancel_broad_reflective_peak_mode_reduction')
    
  space = widget_label(button_row,$
    value = '                        ')
    
  done = widget_button(button_row,$
    value = 'CLOSE',$
    scr_xsize = 100,$
    uname = 'close_progress_bar_base_uname',$
    sensitive=1)
    
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
pro progress_bar_cleanup, tlb
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
;    pixel_nbr_steps  ; represents the number of pixels for each spin state
;    list_working_spin_states ; ex: ['Off_Off','Off_On']
;
; :Author: j35
;-
pro progress_bar, event=event, $
    top_base=top_base, $
    parent_base_uname = parent_base_uname, $
    pixel_nbr_steps = pixel_nbr_steps, $
    list_working_spin_states = list_working_spin_states
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
  progress_bar_gui, _base, $
    parent_base_geometry, $
    list_working_spin_states
  (*global).progress_bar_base = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  time_init_s = systime(/seconds)
  
  global_progress = PTR_NEW({ _base: _base,$
    top_base: top_base, $
    time_init_s: systime(/seconds), $
    
    current_step: 1, $  ;0,1,2.... spin_state_nbr_steps
    current_pre_step: 1, $
    
    pixel_nbr_steps: pixel_nbr_steps, $
    global_current_step: 1, $
    
    ;+1 is for the cleaning of the temporary ROI files
    post_processing_nbr_steps: n_elements(list_working_spin_states)+1, $
    
    ;this is where all the temporary ROI files will be created
    pre_processing_nbr_steps: pixel_nbr_steps, $
    
    list_working_spin_states: list_working_spin_states, $
    total_number_steps: pixel_nbr_steps * $
    n_elements(list_working_spin_states), $
    global: global})
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_progress
  
  XMANAGER, "progress_bar", _base, GROUP_LEADER = ourGroup, $
    /NO_BLOCK, $
    cleanup='progress_bar_cleanup'
    
end

