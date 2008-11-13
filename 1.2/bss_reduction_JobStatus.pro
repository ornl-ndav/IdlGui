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

PRO create_job_status, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

print, 'here'

iJob = OBJ_NEW('IDLreadLogFile',Event)
IF (OBJ_VALID(iJob)) THEN BEGIN
    pMetadata = iJob->getStructure()
    (*(*global).pMetadata) = pMetadata
    pMetadataValue = iJob->getMetadata()
    (*(*global).pMetadataValue) = pMetadataValue
    iDesign = OBJ_NEW('IDLmakeTree', Event, pMetadata)
    OBJ_DESTROY, iDesign

;select the first one by default and display value of this one in table
    select_first_node, Event ;Gui
    display_contain_OF_job_status, Event, 0

ENDIF ELSE BEGIN ;error refreshing the config file

ENDELSE
OBJ_DESTROY, iJob

END

;------------------------------------------------------------------------------
PRO refresh_job_status, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

pMetadata = (*(*global).pMetadata)
iDesign = OBJ_NEW('IDLrefreshTree', Event, pMetadata)
OBJ_DESTROY, iDesign

END

;------------------------------------------------------------------------------
PRO display_contain_OF_job_status, Event, index
WIDGET_CONTROL,Event.top,GET_UVALUE=global

aMetadataValue = (*(*(*global).pMetadataValue))
Nbr_metadata  = (size(aMetadataValue))(2)
aTable = STRARR(2,Nbr_metadata)

aTable[0,*] = aMetadataValue[0,*]
aTable[1,*] = aMetadataValue[index+1,*]

putTableValue, Event, 'job_status_table', aTable

END
