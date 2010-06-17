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

PRO display_reduce_step3_spin_states_match, $
    spin_base=spin_base,$
    main_event = main_event,$
    local_event = local_event,$
    ACTIVATE=activate,$
    png_enable = png_enable,$
    png_disable = png_disable,$
    png_unavailable = png_unavailable,$
    uname
    
  ; 0: disable
  ; 1: enable
  case (activate) OF
    -1: BEGIN ;disable
      mode = READ_PNG(png_unavailable)
    END
    0: BEGIN ;nothing is activated
      mode = READ_PNG(png_disable)
    END
    1: BEGIN ;activate previous button
      mode = READ_PNG(png_enable)
    END
  ENDCASE
  
  IF (N_ELEMENTS(spin_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(spin_base, FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(local_event.top, FIND_BY_UNAME=uname)
  ENDELSE
  
  ;mode
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, mode, 0,0,/true
  
END

;..............................................................................
PRO display_step3_spin_states_button, $
    local_event = local_event, $
    main_event= main_event,$
    spin_base=spin_base,$
    button_selected= button_selected,$
    global = global
    
  ;-1: disable
  ;0: unselected
  ;1: selected
    
  ;ex: [1,1,0,0] -> Off_Off and Off_On only
  data_spin_states = getListOfDataSpinStates(main_event)
  
  status = data_spin_states - 1 ;1->0 and 0-> -1
  
  CASE (button_selected) OF
    'off_off': BEGIN
      IF (status[0] NE -1) THEN status[0] = 1
    END
    'off_on': BEGIN
      IF (status[1] NE -1) THEN status[1] = 1
    END
    'on_off': BEGIN
      IF (status[2] NE -1) THEN status[2] = 1
    END
    'on_on': BEGIN
      IF (status[3] NE -1) THEN status[3] = 1
    END
    ELSE:
  ENDCASE
  
  uname_list = ['reduce_step3_spin_state_off_off_draw',$
    'reduce_step3_spin_state_off_on_draw',$
    'reduce_step3_spin_state_on_off_draw',$
    'reduce_step3_spin_state_on_on_draw']
    
  png_list = [(*global).reduce_step3_spin_off_off_disable,$
    (*global).reduce_step3_spin_off_off_enable,$
    (*global).reduce_step3_spin_off_off_unavailable,$
    (*global).reduce_step3_spin_off_on_disable,$
    (*global).reduce_step3_spin_off_on_enable,$
    (*global).reduce_step3_spin_off_on_unavailable,$
    (*global).reduce_step3_spin_on_off_disable,$
    (*global).reduce_step3_spin_on_off_enable,$
    (*global).reduce_step3_spin_on_off_unavailable,$
    (*global).reduce_step3_spin_on_on_disable,$
    (*global).reduce_step3_spin_on_on_enable,$
    (*global).reduce_step3_spin_on_on_unavailable]
    
  FOR i=0,3 do BEGIN
  
    display_reduce_step3_spin_states_match, $
      spin_base=spin_base,$
      main_event=main_event,$
      local_event = local_event,$
      ACTIVATE=status[i],$
      png_enable = png_list[3*i+1],$
      png_disable = png_list[3*i],$
      png_unavailable = png_list[3*i+2],$
      uname_list[i]
      
  ENDFOR
  
END

;==============================================================================
PRO spin_base_event, event

  COMPILE_OPT hidden
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_spin
  
  wWidget =  Event.top            ;widget id
  main_event = global_spin.event
  main_global = global_spin.global
  
  CASE Event.id OF
  
    ;off_off
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='reduce_step3_spin_state_off_off_draw'): BEGIN
      data_spin_states = getListOfDataSpinStates(main_event)
      spin_state = data_spin_states[0]
      
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          IF (spin_state NE 0) THEN BEGIN
            display_step3_spin_states_button, local_event=event,$
              main_event = global_spin.event,$
              button_selected= 'off_off',$
              global = global_spin.global
            (*main_global).step3_working_spin = 'Off_Off'
          ENDIF
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          data_spin_states = getListOfDataSpinStates(main_event)
          IF (spin_state EQ 0) THEN BEGIN
            standard = 39
          ENDIF ELSE BEGIN
            standard = 58
          ENDELSE
        ENDIF ELSE BEGIN
          standard = 31
        ENDELSE
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE
    END
    
    ;off_on
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='reduce_step3_spin_state_off_on_draw'): BEGIN
      data_spin_states = getListOfDataSpinStates(main_event)
      spin_state = data_spin_states[1]
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          IF (spin_state NE 0) THEN BEGIN
            display_step3_spin_states_button, local_event=event,$
              main_event = global_spin.event,$
              button_selected= 'off_on',$
              global = global_spin.global
            (*main_global).step3_working_spin = 'Off_On'
          ENDIF
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          IF (spin_state EQ 0) THEN BEGIN
            standard = 39
          ENDIF ELSE BEGIN
            standard = 58
          ENDELSE
        ENDIF ELSE BEGIN
          standard = 31
        ENDELSE
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE
    END
    
    ;on_off
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='reduce_step3_spin_state_on_off_draw'): BEGIN
      data_spin_states = getListOfDataSpinStates(main_event)
      spin_state = data_spin_states[2]
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          IF (spin_state NE 0) THEN BEGIN
            display_step3_spin_states_button, local_event=event,$
              main_event = global_spin.event,$
              button_selected= 'on_off',$
              global = global_spin.global
            (*main_global).step3_working_spin = 'On_Off'
          ;  status_buttons = (*global).status_buttons
          ;  IF (status_buttons[0] EQ 0 OR $
          ;    status_buttons[0] EQ 1) THEN BEGIN
          ;    display_buttons, EVENT=EVENT, ACTIVATE=1, global
          ;    play_previous_tof, Event         ;_eventcb
          ;  ENDIF ;end of status_buttons[0]
          ENDIF
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          IF (spin_state EQ 0) THEN BEGIN
            standard = 39
          ENDIF ELSE BEGIN
            standard = 58
          ENDELSE
        ENDIF ELSE BEGIN
          standard = 31
        ENDELSE
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE
    END
    
    ;on_on
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='reduce_step3_spin_state_on_on_draw'): BEGIN
      data_spin_states = getListOfDataSpinStates(main_event)
      spin_state = data_spin_states[3]
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          IF (spin_state NE 0) THEN BEGIN
            display_step3_spin_states_button, local_event=event,$
              main_event = global_spin.event,$
              button_selected= 'on_on',$
              global = global_spin.global
            (*main_global).step3_working_spin = 'On_On'
          ;  status_buttons = (*global).status_buttons
          ;  IF (status_buttons[0] EQ 0 OR $
          ;    status_buttons[0] EQ 1) THEN BEGIN
          ;    display_buttons, EVENT=EVENT, ACTIVATE=1, global
          ;    play_previous_tof, Event         ;_eventcb
          ;  ENDIF ;end of status_buttons[0]
          ENDIF
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          IF (spin_state EQ 0) THEN BEGIN
            standard = 39
          ENDIF ELSE BEGIN
            standard = 58
          ENDELSE
        ENDIF ELSE BEGIN
          standard = 31
        ENDELSE
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE
    END
    
    ;CANCEL button
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME = 'reduce_step3_spin_state_cancel'): BEGIN
      WIDGET_CONTROL, global_spin.ourGroup,/DESTROY
    END
    
    ;ok button
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME = 'reduce_step3_spin_state_ok'): BEGIN
      global = global_spin.global
      Event =  global_spin.event
      working_spin_state = (*global).step3_working_spin
      WIDGET_CONTROL, global_spin.ourGroup,/DESTROY
      checking_spin_state, Event, working_spin_state = working_spin_state
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO working_spin_state, Event

  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='MAIN_BASE')
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;our_group = widget_base(
  spin_base = WIDGET_BASE(GROUP_LEADER=id,$
    /MODAL,$
    /COLUMN,$
    /BASE_ALIGN_CENTER,$
    SCR_XSIZE = 310,$
    frame = 5,$
    title = 'Select Working Spin State (shift/scale)')
    
  ;*****************************************
    
  xsize = 300
  ysize = 100
  
  ;off_off
  off_off = WIDGET_DRAW(spin_base,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    /TRACKING_EVENTS,$
    /BUTTON_EVENTS,$
    UNAME = 'reduce_step3_spin_state_off_off_draw')
    
  ;off_on
  off_on = WIDGET_DRAW(spin_base,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    /TRACKING_EVENTS,$
    /BUTTON_EVENTS,$
    UNAME = 'reduce_step3_spin_state_off_on_draw')
    
  ;on_off
  on_off = WIDGET_DRAW(spin_base,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    /TRACKING_EVENTS,$
    /BUTTON_EVENTS,$
    UNAME = 'reduce_step3_spin_state_on_off_draw')
    
  ;on_on
  on_on = WIDGET_DRAW(spin_base,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    /TRACKING_EVENTS,$
    /BUTTON_EVENTS,$
    UNAME = 'reduce_step3_spin_state_on_on_draw')
    
  ;last row
  last_row = WIDGET_BASE(spin_base,$
    /ROW)
    
  xsize_button = 150
  
  cancel = WIDGET_BUTTON(last_row,$
    VALUE = ' CANCEL ',$
    SCR_XSIZE = xsize_button,$
    FRAME = 0,$
    uname = 'reduce_step3_spin_state_cancel')
    
  ok = WIDGET_BUTTON(last_row,$
    VALUE = ' OK ',$
    SCR_XSIZE = xsize_button,$
    FRAME = 0,$
    uname = 'reduce_step3_spin_state_ok')
      
  WIDGET_CONTROL, spin_base, /realize
  
  global_spin = { global: global,$
    event: event,$
    ourGroup: spin_base }
    
  ;find out which state to select by default
  data_spin_states = getListOfDataSpinStates(Event)
  spin_states = ['off_off','off_on','on_off','on_on']
  button_selected = 'off_off'
  button_ok_validate = 0
  FOR i=0,3 DO BEGIN
    IF (data_spin_states[i] EQ 1) THEN BEGIN
      button_selected = spin_states[i]
      button_ok_validate = 1
      (*global).step3_working_spin = button_selected
      BREAK
    ENDIF
  ENDFOR
  
  WIDGET_CONTROL, ok, SENSITIVE=button_ok_validate
  
  ;display buttons and select button 1 as default selection
  display_step3_spin_states_button, main_event=Event, $
    local_event=local_event,$
    spin_base=spin_base,$
    button_selected=button_selected,$
    global = global
    
  WIDGET_CONTROL, spin_base, SET_UVALUE=global_spin
  XMANAGER, "spin_base", spin_base, GROUP_LEADER = id
  
END
