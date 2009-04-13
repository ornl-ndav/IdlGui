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

PRO BrowseRoiFile, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Ext    = (*global).BrowseROIExt
Filter = (*global).BrowseROIFilter
Path   = (*global).BrowseROIPath

RoiFileName = DIALOG_PICKFILE(GET_PATH          = newPath,$
                              PATH              = Path,$
                              FILTER            = Filter,$
                              DEFAULT_EXTENSION = Ext,$
                              TITLE             = 'Select a ROI File ...',$
                              /MUST_EXIST)
IF (RoiFileName NE '') THEN BEGIN
    (*global).BrowseDefaultPath = newPath
    putRoiFileName, Event, RoiFileName
    message = 'Browsed for ROI file name: ' + RoiFileName
    IDLsendToGeek_AddLogBookText, Event, message
ENDIF ELSE BEGIN
    putRoiFileName, Event, ''
ENDELSE
END

;------------------------------------------------------------------------------
PRO BrowseNexusFile, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

Ext    = (*global).BrowseNexusDefaultExt
Filter = (*global).BrowseFilter
Path   = (*global).BrowseDefaultPath

NexusFileName = DIALOG_PICKFILE(GET_PATH          = newPath,$
                                PATH              = Path,$
                                FILTER            = Filter,$
                                DEFAULT_EXTENSION = Ext,$
                                TITLE             = 'Select a Nexus File ...',$
                                /MUST_EXIST)
IF (NexusFileName NE '') THEN BEGIN
    (*global).BrowseDefaultPath = newPath
    putNexusFileName, Event, NexusFileName
    message = 'Browsed for NeXus file name: ' + NexusFileName
    IDLsendToGeek_putLogBookText, Event, message
ENDIF ELSE BEGIN
    putNexusFileName, Event, ''
ENDELSE
END

;------------------------------------------------------------------------------
PRO ListOfInstrument, Event
index = getDropListSelectedIndex(Event, 'list_of_instrument')
IF (index EQ 0) THEN BEGIN
    activateStatus = 0
ENDIF ELSE BEGIN
    activateStatus = 1
ENDELSE
MapBase, Event, 'nexus_run_number_base', activateStatus
END

;------------------------------------------------------------------------------
PRO PreviewRoiFile, Event 
;get RoiFileName
RoiFileName = getRoiFileName(Event) 
FileName    = RoiFileName[0]
title       = FileName
XDISPLAYFILE, FileName, TITLE = title
END

;------------------------------------------------------------------------------
PRO DisplayBankSelected, Event 
value = getDropListSelectedValue(Event, 'bank_droplist')
putTextFieldValue, Event, 'bank_text', value
END

;******************************************************************************

PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
END

PRO plot_roi_eventcb, event
END

