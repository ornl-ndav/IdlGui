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

pro configure_spin_state_event, Event

  ;get global structure
  widget_control,event.top,get_uvalue=global_spin_state
  global = (*global_spin_state).global
  
  case Event.id of
  
    widget_info(event.top, find_by_uname='spin_state_base_close_button'): begin
      id = widget_info(Event.top, $
        find_by_uname='spin_state_widget_base')
      widget_control, id, /destroy
      event = (*global_spin_state).main_event
      command_line_generator_for_ref_m, event
    end
    
    ;Off_Off
    widget_info(event.top, find_by_uname='spin_state_off_off'): begin
      off_off_value = isButtonSelected(Event, 'spin_state_off_off')
      spin_state_config = (*global).spin_state_config
      spin_state_config[0] = off_off_value
      (*global).spin_state_config = spin_state_config
    end
    ;Off_On
    widget_info(event.top, find_by_uname='spin_state_off_on'): begin
      off_on_value = isButtonSelected(Event, 'spin_state_off_on')
      spin_state_config = (*global).spin_state_config
      spin_state_config[1] = off_on_value
      (*global).spin_state_config = spin_state_config
    end
    ;On_Off
    widget_info(event.top, find_by_uname='spin_state_on_off'): begin
      on_off_value = isButtonSelected(Event, 'spin_state_on_off')
      spin_state_config = (*global).spin_state_config
      spin_state_config[2] = on_off_value
      (*global).spin_state_config = spin_state_config
    end
    ;On_On
    widget_info(event.top, find_by_uname='spin_state_on_on'): begin
      on_on_value = isButtonSelected(Event, 'spin_state_on_on')
      spin_state_config = (*global).spin_state_config
      spin_state_config[3] = on_on_value
      (*global).spin_state_config = spin_state_config
    end
    
;    ;yes/no direct beam spin states
;    widget_info(event.top, find_by_uname='match_spin_state'): begin
;      value = isButtonSelected(Event, 'match_spin_state')
;      (*global).match_spin_states = value
;    end
    
    else:
    
  endcase
  
end

;------------------------------------------------------------------------------
PRO configure_spin_state_gui, wBase, main_base_geometry

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  spin_state_xsize = 300
  spin_state_ysize = 165
  
  spin_state_xoffset = (main_base_xsize - spin_state_xsize) / 2
  spin_state_xoffset += main_base_xoffset
  
  spin_state_yoffset = (main_base_ysize - spin_state_ysize) / 2
  spin_state_yoffset += main_base_yoffset
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Spin State Configuration',$
    UNAME        = 'spin_state_widget_base',$
    XOFFSET      = spin_state_xoffset,$
    YOFFSET      = spin_state_yoffset,$
    SCR_YSIZE    = spin_state_ysize,$
    SCR_XSIZE    = spin_state_xsize,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    /align_center,$
    /column,$
    GROUP_LEADER = ourGroup)
    
  space = widget_label(wBase,$
    value = ' ')
  title = widget_label(wBase,$
    value = 'Repeat reduction for following spin states:')
  ;spin states selection
  base1 = widget_base(wBase,$
    ;    yoffset = 20,$
    ;    xoffset = 10,$
    frame = 1,$
    /align_center,$
    /column)
  base2 = widget_base(base1,$
    /nonexclusive,$
    xsize = 150,$
    /row)
  button1 = widget_button(base2,$
    value = 'Off-Off',$
    uname = 'spin_state_off_off')
  button2 = widget_button(base2,$
    value = 'Off-On',$
    uname = 'spin_state_off_on')
  widget_control, button1, /set_button
  base3 = widget_base(base1,$
    /row,$
    /nonexclusive)
  button3 = widget_button(base3,$
    value = 'On-Off ',$
    uname = 'spin_state_on_off')
  button4 = widget_button(base3,$
    value = 'On-On',$
    uname = 'spin_state_on_on')
  widget_control, button3, /set_button
  space = widget_label(wBase,$
    value = ' ')

;  title = widget_label(wBase,$
;    value = 'Match Data and Direct Beam spin states:')
;  base4 = widget_base(wBase,$
;    frame = 1,$
;    xsize = 200,$
;    /exclusive,$
;    /row)
;  button1 = widget_button(base4,$
;    value = 'yes    ',$
;    uname = 'match_spin_state')
;  button2 = widget_button(base4,$
;    value = 'no (use Off-Off)',$
;    uname = 'not_match_spin_state')
;  widget_control, button2, /set_button
;  
;  space = widget_label(wBase,$
;    value = ' ')
  close = widget_button(wBase,$
    value = 'CLOSE',$
    xsize = 150,$
    uname = 'spin_state_base_close_button')
    
END

;------------------------------------------------------------------------------
PRO configure_spin_state, main_base=main_base, Event=event

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
  configure_spin_state_gui, wBase1, $
    main_base_geometry
  ;  (*global).tof_tools_base = wBase1
    
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_spin_state = PTR_NEW({ wbase: wbase1,$
    global: global, $
    main_event: Event})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_spin_state
  
  XMANAGER, "configure_spin_state", wBase1, GROUP_LEADER = ourGroup, /NO_BLOCK
  
END

