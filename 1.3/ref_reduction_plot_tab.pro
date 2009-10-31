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

PRO plot_tab_browse_button, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;retrieve parameters
  OK         = (*global).ok
  PROCESSING = (*global).processing
  FAILED     = (*global).failed
  
  extension  = (*global).plot_ascii_extension
  ;filter     = (*global).ascii_filter
  path       = (*global).dr_output_path
  title      = 'Browsing for an ASCII file ...'
  
  ;text = 'Browsing for an ASCII file ... ' + PROCESSING
  ;IDLsendToGeek_addLogBookText, Event, text
  
  ascii_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
    ;FILTER            = filter,$
    GET_PATH          = new_path,$
    PATH              = path,$
    TITLE             = title,$
    /MUST_EXIST)
    
  IF (ascii_file_name NE '') THEN BEGIN ;get one
  
    putTextFieldValue, Event, 'plot_tab_input_file_text_field', $
      ascii_file_name, 0
      
    ActivateWidget, Event, 'plot_tab_preview_button', 1  
      
  ;    (*global).ascii_path = new_path
      
  ;    putTextFieldValue, Event, 'plot_input_file_text_field', ascii_file_name
  ;    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
  ;    text = '-> Ascii file loaded: ' + ascii_file_name
  ;    IDLsendToGeek_addLogBookText, Event, text
      
  ;Load File
  ;    LoadAsciiFile, Event
  ENDIF ELSE BEGIN
  ;    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, 'INCOMPLETE!'
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO preview_ascii_file, Event
print, 'here'
  FileName = getTextFieldValue(Event, 'plot_tab_input_file_text_field')
  TITLE = 'Preview of the ASCII File: ' + FileName
  ref_reduction_xdisplayFile,  FileName,$
    TITLE       = title, $
    DONE_BUTTON = 'Done with Preview of ASCii file'
END

