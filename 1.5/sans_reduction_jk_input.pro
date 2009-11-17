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

PRO validate_or_not_get_run_information, Event

  run_number = getTextFieldValue(Event,'reduce_jk_tab1_run_number')
  IF (STRCOMPRESS(run_number,/REMOVE_ALL) EQ '') THEN BEGIN
    activate_widget, Event, 'reduce_jk_tab1_get_run_information', 0
    RETURN
  ENDIF
  
  ON_IOERROR, error
  
  fix_value = FIX(run_number)
  activate_widget, Event, 'reduce_jk_tab1_get_run_information', 1
  RETURN
  
  error:
  activate_widget, Event, 'reduce_jk_tab1_get_run_information', 0
  
END

;------------------------------------------------------------------------------
PRO jk_get_run_information, Event

  ;get run number
  run_number = STRCOMPRESS(getTextFieldValue(Event,$
    'reduce_jk_tab1_run_number'),/REMOVE_ALL)
  
  cmd = 'eqsans_reduce  -r ' + run_number + ' -ri'
  WIDGET_CONTROL, /HOURGLASS
  spawn, cmd, listening, err_listening
  WIDGET_CONTROL, HOURGLASS=0
  
  ;add title to message
  message = STRARR(2)
  message[0] = '****** Run Information about run number ' + run_number + $
  ' ******'
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_text', $
  [message, listening]

END