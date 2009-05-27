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

PRO help_button, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

IF (Event.select EQ 1) THEN BEGIN ;button pressed
    old_input_text = getTextFieldValue(Event,'input_text_field')
    (*(*global).old_input_text) = old_input_text
    new_input_text = '[1001-1003,1010],1020,1025-1027'
    putValue, Event, 'input_text_field', new_input_text
    help_text1 = '[1001-1003,1010] = 1001,1002,1003 and 1010 are ' + $
    'combined into 1 run (1 CL).'
    old_help_text1 = getTextFieldvalue(Event,'info_line1_label')
    (*global).old_help_text1 = old_help_text1
    putValue, Event, 'info_line1_label', help_text1
    help_text2 = '1020,1025-1027 = 1020,1025,1026 and 1027 creates ' + $
    '4 runs (4 CLs).'
    old_help_text2 = getTextFieldvalue(Event,'info_line2_label')
    (*global).old_help_text2 = old_help_text2
    putValue, Event, 'info_line2_label', help_text2
ENDIF ELSE BEGIN ;button released
    new_input_text = (*(*global).old_input_text)
    new_help_text1 = (*global).old_help_text1
    new_help_text2 = (*global).old_help_text2
    putValue, Event, 'input_text_field', new_input_text
    putValue, Event, 'info_line1_label', new_help_text1
    putValue, Event, 'info_line2_label', new_help_text2  
ENDELSE

END

;------------------------------------------------------------------------------
PRO help_button_tab2, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

IF (Event.select EQ 1) THEN BEGIN ;button pressed
    old_input_text = getTextFieldValue(Event,'tab2_manual_input_sequence')
    (*(*global).old_input_text) = old_input_text
    new_input_text = '[1001-1003,1010],1020,1025-1027'
    putValue, Event, 'tab2_manual_input_sequence', new_input_text
;    help_text1 = '[1001-1003,1010] = 1001,1002,1003 and 1010 are ' + $
;    'combined into 1 run (1 CL).'
;    old_help_text1 = getTextFieldvalue(Event,'info_line1_label')
;    (*global).old_help_text1 = old_help_text1
;    putValue, Event, 'info_line1_label', help_text1
;    help_text2 = '1020,1025-1027 = 1020,1025,1026 and 1027 creates ' + $
;    '4 runs (4 CLs).'
;    old_help_text2 = getTextFieldvalue(Event,'info_line2_label')
;    (*global).old_help_text2 = old_help_text2
;    putValue, Event, 'info_line2_label', help_text2
ENDIF ELSE BEGIN ;button released
    new_input_text = (*(*global).old_input_text)
;    new_help_text1 = (*global).old_help_text1
;    new_help_text2 = (*global).old_help_text2
    putValue, Event, 'tab2_manual_input_sequence', new_input_text
;    putValue, Event, 'info_line1_label', new_help_text1
;    putValue, Event, 'info_line2_label', new_help_text2  
ENDELSE

END

