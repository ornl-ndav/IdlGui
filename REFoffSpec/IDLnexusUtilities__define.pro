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

FUNCTION check_number_polarization_state, nexus_file_name, $
                                          list_pola_state

cmd = 'nxdir ' + nexus_file_name
SPAWN, cmd, listening, err_listening

list_pola_state = listening     ;keep record of name of pola states

IF (err_listening[0] NE '') THEN RETURN, 0
RETURN, 1
END

;------------------------------------------------------------------------------
FUNCTION IDLnexusUtilities::getPolarization
RETURN, self.list_pola_state
END

;------------------------------------------------------------------------------i
FUNCTION IDLnexusUtilities::init, full_nexus_name

;check if nexus file exist
IF (FILE_TEST(full_nexus_name) NE 1) THEN RETURN, 0

;get list of pola state
status = check_number_polarization_state(full_nexus_name, list_pola_state)

IF (status EQ 0) THEN RETURN, 0
self.list_pola_state = PTR_NEW(list_pola_state)

;if value is '/entry/' that means it's the old format
test_list_OF_pola = *self.list_pola_state
IF (STRCOMPRESS(test_list_OF_pola[0],/REMOVE_ALL) EQ $
    '/entry/') THEN RETURN, 0 

RETURN, 1
END

;******************************************************************************
;******  Class Define *********************************************************
;******************************************************************************
PRO IDLnexusUtilities__define
STRUCT = { IDLnexusUtilities, $
           list_pola_state: PTR_NEW(0L),$
           var: ''}
END
;******************************************************************************
;******************************************************************************
