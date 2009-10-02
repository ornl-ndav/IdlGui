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

;when we want only the archived one
FUNCTION findnexus, Event, $
    RUN_NUMBER = run_number, $
    INSTRUMENT = instrument, $
    PROPOSAL   = proposal, $
    isNexusExist
    
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  IF (N_ELEMENTS(RUN_NUMBER) EQ 0) THEN RETURN, 'ERROR'
  
  cmd = 'findnexus --archive'
  
  IF (N_ELEMENTS(INSTRUMENT)) THEN BEGIN
    cmd += ' -i ' + INSTRUMENT
  ENDIF
  
  IF (N_ELEMENTS(PROPOSAL) NE 0) THEN BEGIN
    IF (PROPOSAL NE '') THEN BEGIN
      cmd += ' -p ' + PROPOSAL
    ENDIF
  ENDIF
  
  cmd += ' ' + STRCOMPRESS(RUN_NUMBER,/REMOVE_ALL)
  SPAWN, cmd, full_nexus_name, err_listening
  
  ;check if nexus exists
  sz = (SIZE(full_nexus_name))(1)
  IF (sz EQ 1) THEN BEGIN
    result = STRMATCH(full_nexus_name,"ERROR*")
    IF (result GE 1) THEN BEGIN
      isNeXusExist = 0
    ENDIF ELSE BEGIN
      isNeXusExist = 1
    ENDELSE
    RETURN, full_nexus_name
  ENDIF ELSE BEGIN
    isNeXusExist = 1
    RETURN, full_nexus_name[0]
  ENDELSE
END
