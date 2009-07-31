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

PRO display_images, MAIN_BASE=main_base, EVENT=event

  ;Transmission calculation button
  raw_buttons = READ_PNG('SANSreduction_images/transmission_button.png')
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
  
;  ;beam center button
;  raw_buttons = READ_PNG('SANSreduction_images/beam_center.png')
;  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
;    mode_id = WIDGET_INFO(main_base, $
;      FIND_BY_UNAME='beam_center_calculation_button')
;  ENDIF ELSE BEGIN
;    mode_id = WIDGET_INFO(Event.top, $
;      FIND_BY_UNAME='beam_center_calculation_button')
;  ENDELSE
;  WIDGET_CONTROL, mode_id, GET_VALUE=id
;  WSET, id
;  TV, raw_buttons, 0, 0,/true
  
END