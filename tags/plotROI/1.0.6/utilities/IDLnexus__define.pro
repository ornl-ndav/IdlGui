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

;*******************************************************************************
FUNCTION getFullNexusName, instrument , RunNumber, isNexusExist

cmd = "findnexus --archive -i" + instrument 
cmd += " " + strcompress(RunNumber,/REMOVE_ALL)
spawn, cmd, full_nexus_name, err_listening

print, cmd ;remove_me

;check if nexus exists
sz = (size(full_nexus_name))(1)
IF (sz EQ 1) then begin
    result = STRMATCH(full_nexus_name,"ERROR*")
    IF (result EQ 1) THEN BEGIN
        isNeXusExist = 0
    ENDIF ELSE BEGIN
        isNeXusExist = 1
    ENDELSE
    RETURN, full_nexus_name
ENDIF ELSE BEGIN
    IF (full_nexus_name EQ '') THEN BEGIN
        isNexusExist = 0
    ENDIF ELSE BEGIN
        isNeXusExist = 1
    ENDELSE
    RETURN, full_nexus_name[0]
ENDELSE
isNexusExist = 0
RETURN, 0
END

;*******************************************************************************
;Get full nexus name
FUNCTION IDLnexus::getFullNexusName
RETURN, self.FullNexusName
END

;*******************************************************************************
;Is nexus exist
FUNCTION IDLnexus::isNexusExist
RETURN, self.isNexusExist
END

;*******************************************************************************
FUNCTION IDLnexus::init, $
                 INSTRUMENT=instrument, $
                 RunNumber=RunNumber, $
                 ARCHIVED=archived
                 
IF (n_elements(ARCHIVED) EQ 0) THEN ARCHIVED = 1
self.FullNexusName = getFullNexusName(instrument, RunNumber, isNexusExist)
self.isNexusExist = isNexusExist
RETURN, 1
END

;*******************************************************************************
;******  Class Define **********************************************************
;*******************************************************************************
PRO IDLnexus__define
STRUCT = { IDLnexus,$
           FullNexusName : '',$
           isNexusExist  : 0}
END
;*******************************************************************************
;*******************************************************************************
