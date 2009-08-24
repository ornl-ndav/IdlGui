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

PRO display_buttons_main_plot, WBASE=wBase, EVENT=event

  IF (N_ELEMENTS(wbase) NE 0) THEN BEGIN
    WIDGET_CONTROL, wbase, GET_UVALUE=global
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, event.top, GET_UVALUE=global
  ENDELSE
  
  raw_buttons = READ_PNG('plotCNCS_images/set_of_buttons_raw.png')
  IF (N_ELEMENTS(wbase) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='play_buttons')
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='play_buttons')
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, raw_buttons, 0, 0,/true
  
  pause_button = READ_PNG('plotCNCS_images/pause_disable.png')
  IF (N_ELEMENTS(wbase) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='pause_button')
  ENDIF ElSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='pause_button')
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, pause_button, 0, 0,/true
  
  stop_button = READ_PNG('plotCNCS_images/stop_disable.png')
  IF (N_ELEMENTS(wbase) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='stop_button')
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='stop_button')
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, stop_button, 0, 0,/true
  
  previous_button = READ_PNG('plotCNCS_images/previous_disable.png')
  IF (N_ELEMENTS(wbase) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='previous_button')
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='previous_button')
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, previous_button, 0, 0,/true
  
  play_button = READ_PNG('plotCNCS_images/play_disable.png')
  IF (N_ELEMENTS(wbase) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='play_button')
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='play_button')
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, play_button, 0, 0,/true
  
  next_button = READ_PNG('plotCNCS_images/next_disable.png')
  IF (N_ELEMENTS(wbase) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='next_button')
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='next_button')
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, next_button, 0, 0,/true
  
  IF ((*global).selection_mode EQ 'selection') THEN BEGIN
    selection_button = READ_PNG('plotCNCS_images/selection_mode_on.png')
    mask_button = READ_PNG('plotCNCS_images/masking_mode_off.png')
  ENDIF ELSE BEGIN
    selection_button = READ_PNG('plotCNCS_images/selection_mode_off.png')
    mask_button = READ_PNG('plotCNCS_images/masking_mode_on.png')
  ENDELSE
  
  IF (N_ELEMENTS(wbase) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='selection_mode_button')
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='selection_mode_button')
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, selection_button, 0, 0,/true
  
  IF (N_ELEMENTS(wbase) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(wBase, FIND_BY_UNAME='masking_mode_button')
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='masking_mode_button')
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, mask_button, 0, 0,/true
  
END