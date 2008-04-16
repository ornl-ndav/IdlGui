;===============================================================================
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
;===============================================================================

PRO CheckCommandLine, Event
;get global structure
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global

;default parameters
cmd_status = 1 ;by default, cmd can be activated

;Check first tab
cmd = (*global).ReducePara.driver_name ;driver to launch

;- LOAD FILES TAB --------------------------------------------------------------

;-Data File-
file_run = getTextFieldValue(Event,'data_file_name_text_field')
IF (file_run NE '' AND $
    FILE_TEST(file_run)) THEN BEGIN
    cmd += ' ' + file_run
ENDIF ELSE BEGIN
    cmd_status = 0
END

;-Solvant Buffer Only-
file_run = getTextFieldValue(Event,'solvant_file_name_text_field')
IF (file_run NE '' AND $
    FILE_TEST(file_run)) THEN BEGIN
    cmd += ' ' + file_run
ENDIF 

;-Emtpy Can-
file_run = getTextFieldValue(Event,'empty_file_name_text_field')
IF (file_run NE '' AND $
    FILE_TEST(file_run)) THEN BEGIN
    cmd += ' ' + file_run
ENDIF 

;-Open Beam-
file_run = getTextFieldValue(Event,'open_file_name_text_field')
IF (file_run NE '' AND $
    FILE_TEST(file_run)) THEN BEGIN
    cmd += ' ' + file_run
ENDIF 

;-Dark Current-
file_run = getTextFieldValue(Event,'dark_file_name_text_field')
IF (file_run NE '' AND $
    FILE_TEST(file_run)) THEN BEGIN
    cmd += ' ' + file_run
ENDIF 


;- Put cmd in the text box -
putCommandLine, Event, cmd

END
