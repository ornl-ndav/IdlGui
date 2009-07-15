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

FUNCTION canWeValidateCountsVsTofButton, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global
  
  x1 = (*global).X1
  x2 = (*global).X2
  y1 = (*global).Y1
  y2 = (*global).Y2
  
  IF (x1 + x2 + y1 + y2 NE 0) THEN RETURN, 1
  RETURN, 0
  
END

;------------------------------------------------------------------------------
;mode is 'selection' or 'masking'
PRO update_selection_masking_mode, Event, mode=mode

  WIDGET_CONTROL, event.top, GET_UVALUE=global
  
  ;stop here if user clicked on already active mode
  IF ((*global).selection_mode EQ mode) THEN RETURN
  
  selection_unames = ['counts_vs_tof_selection']
  masking_unames =   ['masking_selection_tool',$
    'selection_input_example',$
    'masking_base']
    
  case (mode) OF
    'selection': BEGIN
      IF (canWeValidateCountsVsTofButton(Event)) THEN BEGIN
        selection_status = 1
      ENDIF ELSE BEGIN
        selection_status = 0
      ENDELSE
      masking_status = 0
      selection_png = 'plotCNCS_images/selection_mode_on.png'
      selection_tooltip = 'Selection mode is activated !'
      masking_tooltip = 'Click to activate the masking mode'
      masking_png = 'plotCNCS_images/masking_mode_off.png'
    END
    'masking': BEGIN
      selection_status = 0
      masking_status = 1
      selection_png = 'plotCNCS_images/selection_mode_off.png'
      selection_tooltip = 'Click to activate the selection mode'
      masking_tooltip = 'Masking mode is activated !'
      masking_png = 'plotCNCS_images/masking_mode_on.png'
    END
    ELSE:
  ENDCASE
  
  activateWidgets, Event, selection_unames, selection_status
  activateWidgets, Event, masking_unames, masking_status
  
  setTooltip, Event, 'selection_mode_button', selection_tooltip
  setTooltip, Event, 'masking_mode_button', masking_tooltip
  
  selection_button = READ_PNG(selection_png)
  mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='selection_mode_button')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, selection_button, 0, 0,/true
  
  masking_button = READ_PNG(masking_png)
  mode_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='masking_mode_button')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, masking_button, 0, 0,/true
  
  (*global).selection_mode = mode
  
END