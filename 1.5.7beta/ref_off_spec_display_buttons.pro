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

PRO  display_reduce_step2_polarization_mode1, $
    MAIN_BASE=MAIN_BASE, $
    EVENT=EVENT,$
    ACTIVATE=activate,$
    global
    
  ; 0: disable
  ; 1: enable
    
  case (activate) OF
    0: BEGIN ;nothing is activated
      mode1 = READ_PNG((*global).reduce_step2_polarization_mode1_disable)
    END
    1: BEGIN ;activate previous button
      mode1 = READ_PNG((*global).reduce_step2_polarization_mode1_enable)
    END
  ENDCASE
  
  IF (N_ELEMENTS(MAIN_BASE) NE 0) THEN BEGIN
    mode1_id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_step2_polarization_mode1_draw')
  ENDIF ELSE BEGIN
    mode1_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_step2_polarization_mode1_draw')
  ENDELSE
  
  ;mode1
  WIDGET_CONTROL, mode1_id, GET_VALUE=id
  WSET, id
  TV, mode1, 0,0,/true
  
END

;-----------------------------------------------------------------------------
PRO   display_reduce_step2_polarization_mode2, $
    MAIN_BASE=MAIN_BASE, $
    EVENT=EVENT,$
    ACTIVATE=activate,$
    global
    
  ; 0: disable
  ; 1: enable
  case (activate) OF
    0: BEGIN ;nothing is activated
      mode2 = READ_PNG((*global).reduce_step2_polarization_mode2_disable)
    END
    1: BEGIN ;activate previous button
      mode2 = READ_PNG((*global).reduce_step2_polarization_mode2_enable)
    END
  ENDCASE
  
  IF (N_ELEMENTS(MAIN_BASE) NE 0) THEN BEGIN
    mode2_id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='reduce_step2_polarization_mode2_draw')
  ENDIF ELSE BEGIN
    mode2_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='reduce_step2_polarization_mode2_draw')
  ENDELSE
  
  ;mode2
  WIDGET_CONTROL, mode2_id, GET_VALUE=id
  WSET, id
  TV, mode2, 0,0,/true
  
END

;-----------------------------------------------------------------------------
PRO display_reduce_step1_spin_states_match, $
    MAIN_BASE=MAIN_BASE, $
    EVENT=EVENT,$
    ACTIVATE=activate,$
    global
    
  ; 0: disable
  ; 1: enable
  case (activate) OF
    0: BEGIN ;nothing is activated
;      mode = READ_PNG((*global).reduce_step1_spin_match_disable)
      mode = READ_PNG((*global).Spins_Matching_Disable)
    END
    1: BEGIN ;activate previous button
;      mode = READ_PNG((*global).reduce_step1_spin_match_enable)
      mode = READ_PNG((*global).Spins_Matching_Enable)
    END
  ENDCASE
  
  uname = 'reduce_step1_spin_match'
  IF (N_ELEMENTS(MAIN_BASE) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  ENDELSE
  
  ;mode
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, mode, 0,0,/true
  
END

;-----------------------------------------------------------------------------
PRO display_reduce_step1_spin_states_do_not_match_fixed, $
    MAIN_BASE = main_base, $
    EVENT=EVENT,$
    ACTIVATE=activate,$
    global
    
  ; 0: disable
  ; 1: enable
  case (activate) OF
    0: BEGIN ;nothing is activated
;      mode = READ_PNG((*global).reduce_step1_spin_do_not_match_fixed_disable)
      mode = READ_PNG((*global).Spins_Not_Matching_Disable)
    END
    1: BEGIN ;activate previous button
;      mode = READ_PNG((*global).reduce_step1_spin_do_not_match_fixed_enable)
      mode = READ_PNG((*global).Spins_Not_Matching_Enable)
    END
  ENDCASE
  
  uname = 'reduce_step1_spin_do_not_match_fixed'
  IF (N_ELEMENTS(MAIN_BASE) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  ENDELSE
  
  ;mode
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, mode, 0,0,/true
  
END

;-----------------------------------------------------------------------------
PRO display_reduce_step1_spin_states_do_not_match_user_defined, $
    MAIN_BASE=MAIN_BASE, $
    EVENT=EVENT,$
    ACTIVATE=activate,$
    global
    
  ; 0: disable
  ; 1: enable
  case (activate) OF
    0: BEGIN ;nothing is activated
;      mode = READ_PNG((*global).reduce_step1_spin_do_not_match_user_defined_disable)
      mode = READ_PNG((*global).User_Defined_Spins_Matching_Disable)
    END
    1: BEGIN ;activate previous button
;      mode = READ_PNG((*global).reduce_step1_spin_do_not_match_user_defined_enable)
      mode = READ_PNG((*global).User_Defined_Spins_Matching_Enable)
    END
  ENDCASE
  
  uname = 'reduce_step1_spin_do_not_match_user_defined'
  IF (N_ELEMENTS(MAIN_BASE) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  ENDELSE
  
  ;mode
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, mode, 0,0,/true
  
END

;-----------------------------------------------------------------------------

PRO display_buttons, MAIN_BASE=MAIN_BASE, $
    EVENT=EVENT,$
    ACTIVATE=activate,$
    global
    
  activate_1 = 0^activate
  activate_2 = activate
  
  display_reduce_step2_polarization_mode1, MAIN_BASE=MAIN_BASE,$
    EVENT=EVENT,$
    ACTIVATE=activate_1,$
    global
    
  display_reduce_step2_polarization_mode2, MAIN_BASE=MAIN_BASE,$
    EVENT=EVENT,$
    ACTIVATE=activate_2,$
    global
    
END

;------------------------------------------------------------------------------
PRO display_reduce_step1_buttons, MAIN_BASE = main_base,$
    EVENT=EVENT,$
    ACTIVATE=activate,$
    global
    
  ;activate = 1 means first button activated
  ;activate = 2 means second button activated....
    
  CASE (activate) OF
    1: BEGIN
      activate_match = 1
      activate_no_match_fixed = 0
      activate_no_match_user = 0
    END
    2: BEGIN
      activate_match = 0
      activate_no_match_fixed = 1
      activate_no_match_user = 0
    END
    3: BEGIN
      activate_match = 0
      activate_no_match_fixed = 0
      activate_no_match_user = 1
    END
    ELSE:
  ENDCASE
; Change code (RC Ward, May 28, 2010): Comment these out - no longer used 
  
;  display_reduce_step1_spin_states_match, $
;    MAIN_BASE=MAIN_BASE,$
;    EVENT=EVENT,$
;    ACTIVATE=activate_match,$
;    global
    
;  display_reduce_step1_spin_states_do_not_match_fixed, $
;    MAIN_BASE=MAIN_BASE,$
;    EVENT=EVENT,$
;    ACTIVATE = activate_no_match_fixed,$
;    global
    
;  display_reduce_step1_spin_states_do_not_match_user_defined, $
;    MAIN_BASE=MAIN_BASE,$
;    EVENT=EVENT,$
;    ACTIVATE = activate_no_match_user,$
;    global
END

;------------------------------------------------------------------------------
PRO display_reduce_step1_sangle_buttons, MAIN_BASE=main_base, $
    EVENT=event, $
    global
    
  mode = READ_PNG((*global).reduce_step1_sangle_equation)
  
  uname = 'reduce_step1_sangle_equation'
  IF (N_ELEMENTS(MAIN_BASE) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  ENDELSE
  
  ;mode
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, mode, 0,0,/true
  
END
