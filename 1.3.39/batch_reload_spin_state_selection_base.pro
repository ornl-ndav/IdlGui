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

function getButtonValidated, event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_settings
  
  spin_states = (*global_settings).spin_states
  nbr_spin = n_elements(spin_states)
  for i=0,(nbr_spin-1) do begin
    status_button = isButtonChecked(event,strlowcase(spin_states[i]))
    if (status_button) then return, i
  endfor
  
  return, -1
  
end


pro batch_reload_spin_state_selection_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_settings
  global = (*global_settings).global
  main_event = (*global_settings).main_event
  
  case Event.id of
  
    ;cancel button
    widget_info(event.top, $
      find_by_uname='cancel_button'): begin
      (*global).cancel_repopulating = 1b
      id = widget_info(Event.top, $
        find_by_uname='batch_reload_spin_state_selection_base')
      widget_control, id, /destroy
    end
    
    ;load button
    widget_info(event.top, find_by_uname='load_button'): begin
      ;check button validated
      index_validated = getButtonValidated(event)
      (*global).batch_spin_index_repopulated_selected = index_validated
      (*global).cancel_repopulating = 0b
      id = widget_info(Event.top, $
        find_by_uname='batch_reload_spin_state_selection_base')
      widget_control, id, /destroy
      
      data_spins = (*(*global).list_of_data_spins)
      norm_spins = (*(*global).list_of_norm_spins)
      
      (*global).data_spin_state_to_replot = data_spins[index_validated]
      (*global).norm_spin_state_to_replot = norm_spins[index_validated]
      
      RepopulateGui_ref_m_with_spin_states, $
        main_event, $
        spin_state_index = index_validated
        
    end
    
    else:
    
  endcase
  
end

;+
; :Description:
;   Determines the uname of the button clicked (but not used)
;
; :Params:
;    event

; :Author: j35
;-
pro batch_reload_spin_state_button, event
  uname = widget_info(event.id, /uname)
;print, uname
end

;+
; :Description:
;   Reached when the settings base is killed
;
; :Params:
;    event
;
; :Author: j35
;-
pro email_settings_killed, id
  compile_opt idl2
  
  ;get global structure
  widget_control,id,get_uvalue=global_settings
  global = (*global_settings).global
  main_event = (*global_settings).main_event
  
  if ((*global_settings).save_setup eq 0b) then begin
    message_text = ['New setup (if any) has not been saved!']
    title = 'Leaving without saving new setup!'
    result = dialog_message(message_text,$
      information = 1,$
      title = title, $
      /center,$
      dialog_parent = id)
    ActivateWidget, main_event, 'email_configure', 1
  endif else begin
    if ((*global_settings).turn_off_email_output eq 1b) then begin
      id1 = widget_info(main_event.top, find_by_uname='send_by_email_output')
      widget_control, id1, set_value = 1
      id2 = widget_info(main_event.top, find_by_uname='email_configure')
      widget_control, id2, sensitive = 0
    endif else begin
      ActivateWidget, main_event, 'email_configure', 1
    endelse
  endelse
  
  id = widget_info(id, $
    find_by_uname='email_configure_widget_base')
  widget_control, id, /destroy
  
end

;------------------------------------------------------------------------------
PRO batch_reload_spin_state_selection_gui, wBase, $
    main_base_geometry, $
    global, $
    spin_states=spin_states
    
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  nbr_spins = n_elements(spin_states)
  xsize = 300
  ysize = 25 + 30 * nbr_spins
  
  xoffset = (main_base_xsize - xsize) / 2
  xoffset += main_base_xoffset
  
  yoffset = (main_base_ysize - ysize) / 2
  yoffset += main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Select Spin State To Load',$
    UNAME        = 'batch_reload_spin_state_selection_base',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    ;    SCR_YSIZE    = ysize,$
    SCR_XSIZE    = xsize,$
    MAP          = 1,$
    ;    kill_notify  = 'email_settings_killed', $
    /BASE_ALIGN_CENTER,$
    /align_center,$
    /column,$
    GROUP_LEADER = ourGroup)
    
  base = widget_base(wBase,$
    /column,$
    /exclusive)
    
  button_to_validate = 0
  for i=0,(nbr_spins-1) do begin
    button1= widget_button(base,$
      value = spin_states[i],$
      /no_release,$
      event_pro = 'batch_reload_spin_state_button',$
      uname = strlowcase(spin_states[i]))
    if (i eq 0) then button_to_validate = button1
  endfor
  
  widget_control, button_to_validate, /set_button
  
  row = widget_base(wBase,$
    /row)
    
  cancel = widget_button(row,$
    value = 'CANCEL',$
    xsize = 150,$
    uname = 'cancel_button')
    
  load = widget_button(row,$
    value = 'LOAD',$
    xsize = 150,$
    uname = 'load_button')
    
END

;------------------------------------------------------------------------------
PRO batch_reload_spin_state_selection, main_base=main_base, Event=event, $
    spin_states=spin_states
    
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(main_base, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,main_base,GET_UVALUE=global
    event = 0
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;build gui
  wBase1 = ''
  batch_reload_spin_state_selection_gui, wBase1, $
    main_base_geometry, global, spin_states=spin_states
    
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_settings = PTR_NEW({ wbase: wbase1,$
    global: global, $
    spin_states: spin_states,$
    main_event: Event})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_settings
  
  XMANAGER, "batch_reload_spin_state_selection", wBase1, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END

