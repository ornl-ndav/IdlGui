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

FUNCTION getTextFieldValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value[0]
END

;------------------------------------------------------------------------------
;This function retrieves the run number of the First tab
FUNCTION getRunNumber, Event
RETURN, getTextFieldValue(Event,'run_number_cw_field')
END

;------------------------------------------------------------------------------
FUNCTION getProposalIndex, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='proposal_droplist')
index = WIDGET_INFO(id, /droplist_select)
RETURN, index
END

;------------------------------------------------------------------------------
FUNCTION getProposalSelected, Event, index
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='proposal_droplist')
index = WIDGET_INFO(id, /droplist_select)
WIDGET_CONTROL, id, GET_VALUE=list
RETURN, list[index]
END

;------------------------------------------------------------------------------
FUNCTION getButtonValue, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
PRO getXYposition, Event
;get global structure
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global
IF ((*global).data_nexus_file_name NE '') THEN BEGIN
    x = Event.x
    y = Event.y
    ScreenX = x / (*global).DrawXcoeff
    ScreenY = y / (*global).DrawXcoeff
    putTextFieldValue, Event, 'x_value', STRCOMPRESS(ScreenX,/REMOVE_ALL)
    putTextFieldValue, Event, 'y_value', STRCOMPRESS(ScreenY,/REMOVE_ALL)
ENDIF
END

;------------------------------------------------------------------------------
FUNCTION getDefaultReduceFileName, FullFileName, RunNumber = RunNumber
IF (N_ELEMENTS(RunNumber) EQ 0) THEN BEGIN
    iObject = OBJ_NEW('IDLgetMetadata',FullFileName)
    IF (OBJ_VALID(iObject)) THEN BEGIN
        RunNumber = iObject->getRunNumber()
    ENDIF ELSE BEGIN
        RunNumber = ''
    ENDELSE
ENDIF
default_name = 'SANS' 
IF (RunNumber NE '') THEN BEGIN
    default_name += '_' + STRCOMPRESS(RunNumber,/REMOVE_ALL)
ENDIF
DateIso = GenerateIsoTimeStamp()
default_name += '_' + DateIso
default_name += '.txt'
RETURN, default_name
END

;------------------------------------------------------------------------------
FUNCTION getDefaultROIFileName, Event, FullFileName, RunNumber = RunNumber
IF (N_ELEMENTS(RunNumber) EQ 0) THEN BEGIN
    iObject = OBJ_NEW('IDLgetMetadata',FullFileName)
    IF (OBJ_VALID(iObject)) THEN BEGIN
        RunNumber = iObject->getRunNumber()
    ENDIF ELSE BEGIN
        RunNumber = ''
    ENDELSE
ENDIF
default_name = 'SANS' 
IF (RunNumber NE '') THEN BEGIN
    default_name += '_' + STRCOMPRESS(RunNumber,/REMOVE_ALL)
ENDIF
DateIso = GenerateIsoTimeStamp()
default_name += '_' + DateIso
default_name += 'ROI.dat'

WIDGET_CONTROL, Event.top, GET_UVALUE=global
roi_path = (*global).selection_path
default_name = roi_path + default_name

RETURN, default_name
END
