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

FUNCTION find_full_nexus_name, Event, run_number, isNexusExist

cmd = "findnexus -iBSS "
cmd += " " + strcompress(run_number,/remove_all)
spawn, cmd, full_nexus_name, err_listening
;check if nexus exists
sz = (size(full_nexus_name))(1)
if (sz EQ 1) then begin
    result = strmatch(full_nexus_name,"error*",/FOLD_CASE)
    if (result GE 1) then begin
        isNeXusExist = 0
    endif else begin
        isNeXusExist = 1
    endelse
    return, full_nexus_name
endif else begin
    if (full_nexus_name EQ '') then begin
        isNeXusExist = 0
        return, full_nexus_name
    endif else begin
        isNeXusExist = 1
        return, full_nexus_name[0]
    endelse
endelse
end


;This function checks if a file exist or not
FUNCTION CheckIfNexusExist, NexusFullName
no_error = 0
CATCH, no_error
IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, 0
ENDIF ELSE BEGIN
    openr, u, NexusFullName, /get
    RETURN, 1
ENDELSE
END
