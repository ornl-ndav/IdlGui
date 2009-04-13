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

PRO MapBase, Event, uname, MapStatus
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, MAP=MapStatus
END

;-------------------------------------------------------------------------------
PRO  ActivateWidget, Event, uname, ActivateStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, sensitive=ActivateStatus
END

;*******************************************************************************
;*******************************************************************************
PRO ValidatePlotButton, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;check first that the file exist
NexusFileName = getFullNexusFileName(Event)
IF (FILE_TEST(NexusFileName) AND $
    (*global).ValidNexus EQ 1) THEN BEGIN
;is Full Nexus Name not empty
    IF (isFullNexusNameEmpty(Event) EQ 1) THEN BEGIN
        validateStatus = 0
    ENDIF ELSE BEGIN
        validateStatus = 1
    ENDELSE
ENDIF ELSE BEGIN
    validateStatus = 0
ENDELSE
ActivateWidget, Event, 'plot_button', validateStatus
ActivateWidget, Event, 'bank_droplist', validateStatus
ActivateWidget, Event, 'bank_text', validateStatus
END

;-------------------------------------------------------------------------------
PRO ValidatePreviewButton, Event 
;get Roi file name
RoiFileName = getRoiFileName(Event)
IF (FILE_TEST(RoiFileName)) THEN BEGIN
    activatePreviewButton = 1
ENDIF ELSE BEGIN
    activatePreviewButton = 0
ENDELSE
ActivateWidget, Event, 'preview_roi_button', activatePreviewButton
END

;-------------------------------------------------------------------------------
PRO setBankDroplistValue, Event, value
id = widget_info(Event.top,find_by_uname='bank_droplist')
widget_control, id, set_value=value
END

;-------------------------------------------------------------------------------
PRO PopulateBankDroplist, Event, NbrBank, Instrument
NbrBank    = LONG(NbrBank)
prefix     = 'bank'
BankArray  = strarr(NbrBank)
IF (Instrument EQ 'ARCS') THEN BEGIN
    index=-1
;work on bottom banks
    FOR i=1,38 DO BEGIN
        BankArray[++index] = prefix + 'B' + STRCOMPRESS(i,/REMOVE_ALL)
    ENDFOR
;work on middle banks
    FOR i=1,38 DO BEGIN
        IF (i EQ 32) THEN BEGIN
            BankArray[++index] = prefix + 'M' + STRCOMPRESS(i,/REMOVE_ALL) + 'A'
            BankArray[++index] = prefix + 'M' + STRCOMPRESS(i,/REMOVE_ALL) + 'B'
        ENDIF ELSE BEGIN
            BankArray[++index] = prefix + 'M' + STRCOMPRESS(i,/REMOVE_ALL)
        ENDELSE
    ENDFOR
;work on top banks
    FOR i=1,38 DO BEGIN
        BankArray[++index] = prefix + 'T' + STRCOMPRESS(i,/REMOVE_ALL)
    ENDFOR
ENDIF ELSE BEGIN
    FOR i=0,(NbrBank-1) DO BEGIN
        BankArray[i] = prefix + STRCOMPRESS(i+1,/REMOVE_ALL)
    ENDFOR
ENDELSE
setBankDroplistValue, Event, BankArray
;get bank selected
BankValue = getDropListSelectedValue(Event, 'bank_droplist')
putTextFieldValue, Event, 'bank_text', BankValue
END

;^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^
PRO PopulateNumberOfBanks, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
FullNexusName = getFullNexusFileName(Event)
IF (FullNexusName NE '') THEN BEGIN
;    Instrument = getInstrument(Event)
    NexusInstance = obj_new('IDLgetNexusMetadata', $ ;_IDLgetNexusMetadata
                            FullNexusName, $
                            NbrBank    = 1)
;                            Instrument = Instrument)
    IF (OBJ_VALID(NexusInstance)) THEN BEGIN
        NbrBank = NexusInstance->getNbrBank()
;activate NbrBank
        (*global).ValidNexus = 1
    ENDIF ELSE BEGIN
        NbrBank = 1
;desactivate NbrBank
        (*global).ValidNexus = 0
    ENDELSE
    instrument = ''
    PopulateBankDroplist, Event, NbrBank, Instrument ;_Gui
ENDIF ELSE BEGIN
;desactivate NbrBank
    (*global).ValidNexus = 0
ENDELSE
END

;-------------------------------------------------------------------------------
PRO ClearTextField, Event, uname
putTextFieldValue, Event, uname, ''
END

;-------------------------------------------------------------------------------
