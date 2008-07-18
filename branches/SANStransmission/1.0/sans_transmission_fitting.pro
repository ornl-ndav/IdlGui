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
;change the label of the automatic button
PRO ChangeDegreeOfPolynome, Event
value_OF_group = getCWBgroupValue(Event,'fitting_polynomial_degree_cw_group')
IF (value_OF_group EQ 0) THEN BEGIN
    label = 'AUTOMATIC FITTING with Y = A + BX'
ENDIF ELSE BEGIN
    label = 'AUTOMATIC FITTING with Y = A + BX + CX^2'
ENDELSE
putNewButtonValue, Event, 'auto_fitting_button', label
END

;==============================================================================
PRO ChangeAlternateAxisOption, Event
value_OF_group = getCWBgroupValue(Event,'alternate_wavelength_axis_cw_group')
IF (value_OF_group EQ 0) THEN BEGIN
    status = 1
ENDIF ELSE BEGIN
    status = 0
ENDELSE
map_base, Event, 'alternate_base', status
END

;==============================================================================
PRO BrowseInputAsciiFile, Event 
;get global structure
;id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, Event.top, GET_UVALUE=global

;retrieve parameters
OK         = (*global).ok
PROCESSING = (*global).processing
FAILED     = (*global).failed
filter     = (*global).ascii_filter
extension  = (*global).ascii_extension
path       = (*global).ascii_path
title      = (*global).ascii_title

ascii_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
                                  FILTER            = filter,$
                                  GET_PATH          = new_path,$
                                  PATH              = path,$
                                  TITLE             = title,$
                                  /MUST_EXIST)

IF (ascii_file_name NE '') THEN BEGIN ;get one
    (*global).ascii_path = new_path
    putTextFieldValue, Event, 'input_file_text_field',ascii_file_name
ENDIF

END
