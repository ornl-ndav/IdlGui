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

PRO tab1_selection_button, Event, button=button

  value_selected     = '>>>>>>>>'
  value_not_selected = ''
  
  CASE (button) OF
    1: BEGIN
      value1 = value_selected
      value2 = value_not_selected
      value3 = value_not_selected
    END
    2: BEGIN
      value1 = value_not_selected
      value2 = value_selected
      value3 = value_not_selected
    END
    3: BEGIN
      value1 = value_not_selected
      value2 = value_not_selected
      value3 = value_selected
    END
  ENDCASE
  
  putButtonValue, Event, 'selection_1', value1
  putButtonValue, Event, 'selection_2', value2
  putButtonValue, Event, 'selection_3', value3
  
END

;------------------------------------------------------------------------------
PRO display_part_of_file_selected_in_label, Event, value

  selection_button_activated = getSelectionButtonValue(Event)
  IF (selection_button_activated EQ -1) THEN RETURN
  CASE (selection_button_activated) OF
    1: uname = 'selection_1_to_replaced'
    2: uname = 'selection_2_to_replaced'
    3: uname = 'selection_3_to_replaced'
  ENDCASE
  putValue, Event, uname, value
  
END

;------------------------------------------------------------------------------
PRO activate_corresponding_to_replace_widget, Event

  selection_button_activated = getSelectionButtonValue(Event)
  IF (selection_button_activated EQ -1) THEN RETURN
  CASE (selection_button_activated) OF
    1: uname = 'selection_1_to_replaced'
    2: uname = 'selection_2_to_replaced'
    3: uname = 'selection_3_to_replaced'
  ENDCASE
  
  text = STRCOMPRESS(getTextFieldValue(Event,uname),/REMOVE_ALL)
  IF (text NE '') THEN BEGIN
    status = 1
  ENDIF ELSE BEGIN
    status = 0
  ENDELSE
  
  CASE (selection_button_activated) OF
    1: uname2 = 'selection_1_replaced'
    2: uname2 = 'selection_2_replaced'
    3: uname2 = 'selection_3_replaced'
  ENDCASE
  
  activate_widget, Event, uname2+'_by', status
  activate_widget, Event, uname2+'_by_label', status
  activate_widget, Event, uname2+'_by_clear', status
  activate_widget, Event, uname+'_clear', status
  
END