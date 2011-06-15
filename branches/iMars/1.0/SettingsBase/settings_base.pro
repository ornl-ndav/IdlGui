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
pro settings_base_event, Event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_settings
  global = (*global_settings).global
  
  case Event.id of
  
    ;validate new settings
    widget_info(event.top, find_by_uname='validate_settings_uname'): begin
      validate_changes, event=event
      preview_currently_selected_file, event=(*global_settings).main_event, $
        type=(*global).current_type_selected
      widget_control, (*global_settings)._base, /destroy
    end
    

    ;gamma filtering buttons
    widget_info(event.top, find_by_uname='settings_lee_uname'): begin
      validate_changes, event=event
      preview_currently_selected_file, event=(*global_settings).main_event, $
        type=(*global).current_type_selected
    end
    widget_info(event.top, find_by_uname='settings_smooth_uname'): begin
      validate_changes, event=event
      preview_currently_selected_file, event=(*global_settings).main_event, $
        type=(*global).current_type_selected
    end
    ;gamma filtering coeff
    widget_info(event.top, find_by_uname='gamma_filtering_coeff_uname'): begin
      validate_changes, event=event
      preview_currently_selected_file, event=(*global_settings).main_event, $
        type=(*global).current_type_selected
    end

    ;mean or min multi-selection
    ;mean
    widget_info(event.top, find_by_uname='settings_mean_uname'): begin
      validate_changes, event=event
      preview_currently_selected_file, event=(*global_settings).main_event, $
        type=(*global).current_type_selected
    end
    ;minimum
    widget_info(event.top, find_by_uname='settings_minimum_uname'): begin
      validate_changes, event=event
      preview_currently_selected_file, event=(*global_settings).main_event, $
        type=(*global).current_type_selected
    end

  
    ;transformation
    ;rotation
    widget_info(event.top, find_by_uname='settings_rotation_uname'): begin
      validate_changes, event=event
      preview_currently_selected_file, event=(*global_settings).main_event, $
        type=(*global).current_type_selected    
    end
    ;transpose
    widget_info(event.top, find_by_uname='settings_transpose_uname'): begin
          validate_changes, event=event
      preview_currently_selected_file, event=(*global_settings).main_event, $
        type=(*global).current_type_selected
    end

    else:
    
  endcase
  
end

;+
; :Description:
;    Validate the changes
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro validate_changes, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_settings
  global = (*global_settings).global
  
  coeff_value = getValue(event=event, uname='gamma_filtering_coeff_uname')
  (*global).gamma_filtering_coeff = coeff_value
  
  ;button selected
  ;smooth
  if (isButtonSelected(event=event, uname='settings_smooth_uname')) then $
    button_value = 0
  if (isButtonSelected(event=event, uname='settings_lee_uname')) then $
    button_value = 1
  (*global).gamma_filtering = button_value
  
  ;min or mean multi-selection
  ;mean
  if (isButtonSelected(event=event, uname='settings_mean_uname')) then $
  button_value = 0
  if (isButtonSelected(event=event, uname='settings_minimum_uname')) then $
  button_value = 1
  (*global).multi_selection = button_value
  
  ;transformation
  ;rotation
  value = getValue(event=event, uname='settings_rotation_uname')
  (*global).settings_rotation  = value
  ;transpose
  if (isButtonSelected(event=event, uname='settings_transpose_uname')) then begin
  button_value = 1
  endif else begin
  button_value = 0
  endelse
  (*global).settings_transpose = button_value
  
end

;+
; :Description:
;    Builds the GUI of the settings base
;
; :Params:
;    wBase
;
; :Keywords:
;   global
;   parent_base_geometry
;
;
; :Author: j35
;-
pro settings_base_gui, wBase, $
    global=global, $
    parent_base_geometry=parent_base_geometry
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
  xoffset = main_base_xsize/3 + $
    main_base_xoffset
    
  yoffset = main_base_yoffset + $
    main_base_ysize/3
    
  ourGroup = WIDGET_BASE()
  
  title = 'Settings'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'setings_base_uname', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    scr_xsize = 380,$
    scr_ysize = 200,$
    /align_center, $
    GROUP_LEADER = ourGroup)
    
  ;gamma
  title = widget_label(wBase,$
    value = 'Gamma filtering',$
    xoffset = 20,$
    yoffset = 10)
  gamma_base = widget_base(wBase,$
    xoffset = 10,$
    yoffset = 20,$
    /row,$
    /base_align_center,$
    frame = 1)
  button_base = widget_base(gamma_base,$
    /column,$
    /exclusive)
  smooth_button = widget_button(button_base,$
    value = 'Smooth',$
    /no_release, $
    uname = 'settings_smooth_uname')
  lee_button = widget_button(button_base,$
    value = 'Lee filtering   ',$
    /no_release, $
    uname = 'settings_lee_uname')
    
  case ((*global).gamma_filtering) of
    0: widget_control, smooth_button, /set_button
    1: widget_control, lee_button, /set_button
  endcase

  coeff_base = widget_base(gamma_base,$
    /row)
  label = widget_label(coeff_base,$
    value='Coeff:')
  value = widget_text(coeff_base,$
    xsize = 3,$
    uname = 'gamma_filtering_coeff_uname', $
    value = strcompress((*global).gamma_filtering_coeff,/remove_all),$
    /editable)
    
  ;multiselection
  yoff = 20
  xoff = 250
  title = widget_label(wBase,$
    value = 'Multi-selection',$
    xoffset = xoff+10,$
    yoffset = yoff-10)
  multi_base = widget_base(wBase,$
    xoffset = xoff,$
    xsize = 110,$
    yoffset = yoff,$
    /row,$
    /base_align_center,$
    frame = 1)
  button_base = widget_base(multi_base,$
    /column,$
    /exclusive)
  mean_button = widget_button(button_base,$
    value = 'Mean',$
    /no_release, $
    uname = 'settings_mean_uname')
  minimum_button = widget_button(button_base,$
    value = 'Minimum',$
    /no_release, $
    uname = 'settings_minimum_uname')
    case ((*global).multi_selection) of
    0: widget_control, mean_button, /set_button
    1: widget_control, minimum_button, /set_button
    endcase
    
  ;transformation
  yoff = 105
  xoff = 10
  title = widget_label(wBase,$
    value = 'Transformation',$
    xoffset = 10+xoff,$
    yoffset = yoff-10)
  transformation_base = widget_base(wBase,$
    xoffset = xoff,$
    yoffset = yoff,$
    /column,$
    /base_align_center,$
    frame = 1)
  rotation = cw_bgroup(transformation_base,$
  ['0','90','180','270'],$
  /row,$
  set_value=(*global).settings_rotation,$
  /exclusive,$
  label_left = 'Rotation:',$
  uname = 'settings_rotation_uname')
  trans_base = widget_base(transformation_base,$
  /nonexclusive,$
  /align_left, $
  /row)
  trans_button = widget_button(trans_base,$
  value = 'Transpose',$
  uname = 'settings_transpose_uname')
  if ((*global).settings_transpose) then begin
  widget_control, trans_button, /set_button
  endif

  bottom_row = widget_base(wBase,$
    xoffset = 270,$
    yoffset = 150,$
    /base_align_right,$
    /row)
  ok = widget_button(bottom_row,$
    value = 'VALIDATE',$
    scr_xsize = 80,$
    uname = 'validate_settings_uname')
    
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
pro settings_base, event=event, $
    top_base=top_base, $
    parent_base_uname = parent_base_uname
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
    top_base = (*global).top_base
  endif else begin
    id = widget_info(top_base, find_by_uname=parent_base_uname)
    widget_control, top_base, get_uvalue=global
  endelse
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = 0L
  settings_base_gui, _base, $
    global=global, $
    parent_base_geometry=parent_base_geometry
  (*global).settings_base_id = _base
  
  WIDGET_CONTROL, _base, /REALIZE
  
  global_settings = PTR_NEW({ _base: _base,$
    main_event: event, $
    global: global })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_settings
  
  XMANAGER, "settings_base", $
    _base, $
    GROUP_LEADER=ourGroup, $
    /NO_BLOCK
    
end


;+
; :Description:
;    This routine launch the settings
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro launch_settings_base, event=event
  compile_opt idl2
  
  top_base = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  settings_base, event=event, $
    top_base=top_base, $
    parent_base_uname='MAIN_BASE'
    
end

