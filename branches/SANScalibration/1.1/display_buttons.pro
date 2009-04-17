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

PRO display_buttons, MAIN_BASE=MAIN_BASE, $
    EVENT=EVENT,$
    ACTIVATE=activate,$
    global
    
  ;-1: disable
  ; 0: enable
  ; 1: enable
  status_buttons = INTARR(5)
  
  case (activate) OF
    0: BEGIN ;nothing is activated
      previous = READ_PNG((*global).previous_disable_button)
      play     = READ_PNG((*global).play_button)
      pause    = READ_PNG((*global).pause_disable_button)
      stop     = READ_PNG((*global).stop_disable_button)
      next     = READ_PNG((*global).next_disable_button)
      status_buttons = [-1,0,-1,-1,-1]
    END
    1: BEGIN ;activate previous button
      previous = READ_PNG((*global).previous_button_active)
      play     = READ_PNG((*global).play_button)
      pause    = READ_PNG((*global).pause_disable_button)
      stop     = READ_PNG((*global).stop_button)
      next     = READ_PNG((*global).next_button)
      status_buttons = [1,0,-1,0,0]
    END
    2: BEGIN ;activate play button
      previous = READ_PNG((*global).previous_button)
      play     = READ_PNG((*global).play_button_active)
      pause    = READ_PNG((*global).pause_button)
      stop     = READ_PNG((*global).stop_button)
      next     = READ_PNG((*global).next_button)
      status_buttons = [0,1,0,0,0]
    END
    3: BEGIN ;activate pause button
      previous = READ_PNG((*global).previous_button)
      play     = READ_PNG((*global).play_button)
      pause    = READ_PNG((*global).pause_button_active)
      stop     = READ_PNG((*global).stop_button)
      next     = READ_PNG((*global).next_button)
      status_buttons = [0,0,1,0,0]      
    END
    4: BEGIN ;activate stop button
      previous = READ_PNG((*global).previous_disable_button)
      play     = READ_PNG((*global).play_button)
      pause    = READ_PNG((*global).pause_disable_button)
      stop     = READ_PNG((*global).stop_button_active)
      next     = READ_PNG((*global).next_disable_button)
      status_buttons = [-1,0,-1,1,-1]      
    END
    5: BEGIN ;activate next button
      previous = READ_PNG((*global).previous_button)
      play     = READ_PNG((*global).play_button)
      pause    = READ_PNG((*global).pause_disable_button)
      stop     = READ_PNG((*global).stop_button)
      next     = READ_PNG((*global).next_button_active)
      status_buttons = [0,0,-1,0,1]      
    END
  ENDCASE
  
  (*global).status_buttons = status_buttons
  (*global).tof_buttons_activated = activate
  
  IF (N_ELEMENTS(MAIN_BASE) NE 0) THEN BEGIN
  
    draw_previous = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='previous_button')
    draw_play  = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='play_button')
    draw_pause = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='pause_button')
    draw_stop  = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='stop_button')
    draw_next  = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='next_button')
    
  ENDIF ELSE BEGIN
  
    draw_previous = WIDGET_INFO(Event.top,FIND_BY_UNAME='previous_button')
    draw_play = WIDGET_INFO(Event.top,FIND_BY_UNAME='play_button')
    draw_pause = WIDGET_INFO(Event.top,FIND_BY_UNAME='pause_button')
    draw_stop = WIDGET_INFO(Event.top,FIND_BY_UNAME='stop_button')
    draw_next = WIDGET_INFO(Event.top,FIND_BY_UNAME='next_button')
    
  ENDELSE
  
  ;previous button
  WIDGET_CONTROL, draw_previous, GET_VALUE=id_previous
  WSET, id_previous
  TV, previous, 0,0,/true
  
  ;play button
  WIDGET_CONTROL, draw_play, GET_VALUE=id_play
  WSET, id_play
  TV, play, 0,0,/true
  
  ;pause button
  WIDGET_CONTROL, draw_pause, GET_VALUE=id_pause
  WSET, id_pause
  TV, pause, 0,0,/true
  
  ;stop button
  WIDGET_CONTROL, draw_stop, GET_VALUE=id_stop
  WSET, id_stop
  TV, stop, 0,0,/true
  
  ;next button
  WIDGET_CONTROL, draw_next, GET_VALUE=id_next
  WSET, id_next
  TV, next, 0,0,/true
  
END

;-----------------------------------------------------------------------------