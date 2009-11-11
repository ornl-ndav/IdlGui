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

PRO check_load_save_temperature_widgets, Event

  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    validate_load = 0
    validate_save = 0
  ENDIF ELSE BEGIN
  
    ;get table value
    table = getTableValue(Event,'tab2_table_uname')
    nbr_row = (SIZE(table))(2)
    
    ;if first column is not empty, then we can validate LOAD temperature button
    file_name = table[0,*]
    IF (file_name[0] NE '') THEN BEGIN
      validate_load = 1
    ENDIF ELSE BEGIN
      validate_load = 0
    ENDELSE
    
    ;if 3rd column (temperature) is not empty, validate SAVE temperature button
    temp = table[2,*]
    IF (temp[0] NE '') THEN BEGIN
      validate_save = 1
    ENDIF ELSE BEGIN
      validate_save = 0
    ENDELSE
    
  ENDELSE
  
  activate_widget, Event, 'load_temperature', validate_load
  activate_widget, Event, 'save_temperature', validate_save
  
END

;------------------------------------------------------------------------------
PRO save_temperature, Event

  ;display save temperature base
  save_temperature_base, Event
  
END

;------------------------------------------------------------------------------
PRO load_temperature, Event

  ;display load temperature base
  load_temperature_base, Event
  
END


