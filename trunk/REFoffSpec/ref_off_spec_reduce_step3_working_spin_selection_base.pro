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

PRO spin_base_event, event

  COMPILE_OPT hidden
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_roi
  
  wWidget =  Event.top            ;widget id
  
  CASE Event.id OF
  
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
    UNAME = 'reduce_step3_spin_state_off_off_draw')
    
  ;off_on
  off_on = WIDGET_DRAW(spin_base,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'reduce_step3_spin_state_off_on_draw')
    
  ;on_off
  on_off = WIDGET_DRAW(spin_base,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'reduce_step3_spin_state_on_off_draw')
    
  ;on_on
  on_on = WIDGET_DRAW(spin_base,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
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
    
  WIDGET_CONTROL, spin_base, SET_UVALUE=global_spin
  XMANAGER, "spin_base", spin_base, GROUP_LEADER = id
  
END

