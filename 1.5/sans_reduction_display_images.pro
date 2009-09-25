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

PRO display_images, MAIN_BASE=main_base, EVENT=event, $
    transmission=transmission, $
    beam_center=beam_center
    
  IF (N_ELEMENTS(transmission) EQ 0) THEN transmission = 'off'
  IF (N_ELEMENTS(beam_center) EQ 0) THEN beam_center = 'off'
  
  ;Transmission calculation button
  IF (transmission EQ 'off') THEN BEGIN
    raw_buttons = READ_PNG('SANSreduction_images/transmission_button_off.png')
  ENDIF ELSE BEGIN
    raw_buttons = READ_PNG('SANSreduction_images/transmission_button_on.png')
  ENDELSE
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, $
      FIND_BY_UNAME='transmission_calculation_button')
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='transmission_calculation_button')
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, raw_buttons, 0, 0,/true
  
  ;beam center button
  IF (beam_center EQ 'off') THEN BEGIN
    raw_buttons = READ_PNG('SANSreduction_images/beam_center_off.png')
  ENDIF ELSE BEGIN
    raw_buttons = READ_PNG('SANSreduction_images/beam_center_on.png')
  ENDELSE
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, $
      FIND_BY_UNAME='beam_center_calculation_button')
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='beam_center_calculation_button')
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, raw_buttons, 0, 0,/true
  
END

;------------------------------------------------------------------------------
PRO display_selection_images, MAIN_BASE=main_base, EVENT=event, $
    selection = selection, OFF=off
    
  uname = 'selection_inside_outside_base_uname'
  IF (N_ELEMENTS(off) NE 0) THEN BEGIN
  status = 0
  ENDIF ELSE BEGIN 
  status = 1
  ENDELSE
  
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    MapBase_from_base, BASE=MAIN_BASE, UNAME=uname, status
  ENDIF ELSE BEGIN
    MapBase, Event, UNAME=uname, status
  ENDELSE
  
  IF (N_ELEMENTS(selection) EQ 0) THEN selection = 'inside'
  
  ;selection
  CASE (selection) OF
    'inside' : BEGIN
      inside_image = READ_PNG('SANSreduction_images/selection_inside_on.png')
      outside_image = READ_PNG('SANSreduction_images/selection_outside_off.png')
    END
    'outside' : BEGIN
      inside_image = READ_PNG('SANSreduction_images/selection_inside_off.png')
      outside_image = READ_PNG('SANSreduction_images/selection_outside_on.png')
    END
    ELSE:
  ENDCASE
  
  uname = 'selection_inside_draw_uname'
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, $
      FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME=uname)
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, inside_image, 0, 0,/true
  
  uname = 'selection_outside_draw_uname'
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, $
      FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME=uname)
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, outside_image, 0, 0,/true
  
END

;------------------------------------------------------------------------------
PRO display_auto_base_launcher_images, main_base=main_base, $
    Event=event, $
    mode=mode
    
  IF (N_ELEMENTS(mode) EQ 0) THEN mode='off'
  
  path = 'SANSreduction_images/'
  auto_png = path + ['automatic_shift_on',$
    'automatic_shift_mouse_over',$
    'automatic_shift_mouse_off'] + '.png'
  manual_png = path + ['manual_shift_on',$
    'manual_shift_mouse_over',$
    'manual_shift_mouse_off'] + '.png'
    
  CASE (mode) OF
    'auto_on': BEGIN
      auto = auto_png[0]
      manual = manual_png[2]
    END
    'auto_over': BEGIN
      auto = auto_png[1]
      manual = manual_png[2]
    END
    'auto_off': BEGIN
      auto = auto_png[2]
      manual = manual_png[2]
    END
    'manual_on': BEGIN
      auto = auto_png[2]
      manual = manual_png[0]
    END
    'manual_off': BEGIN
      auto = auto_png[2]
      manual = manual_png[2]
    END
    'manual_over': BEGIN
      auto = auto_png[2]
      manual = manual_png[1]
    END
    'off': BEGIN
      auto = auto_png[2]
      manual = manual_png[2]
    END
  ENDCASE
  auto_button = READ_PNG(auto)
  manual_button = READ_PNG(manual)
  
  auto_uname = 'auto_mode_button'
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, $
      FIND_BY_UNAME=auto_uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME=auto_uname)
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, auto_button, 0, 0,/true
  
  manual_uname = 'manual_mode_button'
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, $
      FIND_BY_UNAME=manual_uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME=manual_uname)
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, manual_button, 0, 0,/true
  
END

;------------------------------------------------------------------------------
PRO  display_trans_manual_step2_3Dview_button, Event, MODE=mode

  CASE (mode) OF
    'on': image = 'SANSreduction_images/3dview_on.png'
    'off': image = 'SANSreduction_images/3dview_off.png'
    'disable': image = 'SANSreduction_images/3dview_off_disable.png'
  ENDCASE
  
  threeD_view_png = READ_PNG(image)
  uname = 'trans_manual_step2_3d_view_button'
  mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, threeD_view_png, 0, 0, /true
  
END