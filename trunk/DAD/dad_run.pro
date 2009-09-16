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

FUNCTION retrieve_info_from_es_file, Event, FILE_NAME = file_name

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global

  iASCII = OBJ_NEW('IDL3columnsASCIIparser', file_name, TYPE='Sq(E)')
  iData = iASCII->getDataQuickly(TRange, QRange)
  ;if there is more than 1 temperature, ask user to select which temperature
  ;he wants to use
  nbr_t = (size(TRange))(1)
  IF (nbr_t GT 1) THEN BEGIN
    es_temperature_selection_base, Event, TRange
    IF ((*global).continue_to_run_divisions) THEN BEGIN
    ;temp_index = (*global).es_temp_index
    ENDIF ELSE BEGIN
      RETURN, 0
    ENDELSE
  ENDIF ELSE BEGIN
    temp_index = 0
  ENDELSE
  
  RETURN, 1
  
END

;==============================================================================
;==============================================================================
PRO run_divisions, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global

  ;get ES file name
  es_file_name = getTextFieldValue(event, 'es_file_name')
  status = retrieve_info_from_es_file(Event, FILE_NAME=es_file_name)
  IF (status EQ 0) THEN RETURN ;quit run divisions
  
END

