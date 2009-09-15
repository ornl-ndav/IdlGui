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

PRO browse_es_file, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  path = (*global).default_path
  title = 'Select Elastic Scan ASCII File'
  widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  result = DIALOG_PICKFILE(DIALOG_PARENT = widget_id, $
    PATH = path, $
    /MUST_EXIST, $
    get_path = new_path, $
    TITLE = title, $
    /READ)
    
  IF (result[0] NE '')  THEN BEGIN
  (*global).default_path = new_path
    putValue, Event, 'es_file_name', result[0]
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO es_input_file_name, Event

  file_name = getTextFieldValue(Event, 'es_input_file_name')
  IF (FILE_TEST(file_name[0])) THEN BEGIN ;file exist
    putValue, Event, 'es_file_name', file_name[0]
  ENDIF ELSE BEGIN
    widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
    message = file_name + ' does not exist!'
    result = DIALOG_MESSAGE(message,$
      /ERROR, $
      DIALOG_PARENT=widget_id, $
      TITLE = 'ES file does not exist!')
  ENDELSE
  putValue, Event, 'es_input_file_name', ''
  
END