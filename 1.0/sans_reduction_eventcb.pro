;===============================================================================
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
;===============================================================================

;This function browse a nexus file
PRO browse_nexus, Event

;get global structure
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global

;retrieve infos
PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed
extension  = (*global).nexus_extension
filter     = (*global).nexus_filter
title      = (*global).nexus_title
path       = (*global).nexus_path

IDLsendToGeek_putLogBookText, Event, '> Browsing and Plotting a NeXus file :'

FullNexusName = BrowseRunNumber(Event, $       ;IDLloadNexus__define
                                extension, $
                                filter, $
                                title,$
                                GET_PATH=new_path,$
                                path)

IF (FullNexusName NE '') THEN BEGIN
;display name of nexus file name
    putTab1NexusFileName, Event, FullNexusName
;change default path
    (*global).nexus_path = path
    message = '-> Full NeXus File Name: ' + FullNexusName
    IDLsendToGeek_addLogBookText, Event, message
    message = '-> Retrieving Data : ' + PROCESSING
    IDLsendToGeek_addLogBookText, Event, message
;retrieving data from NeXus file
    retrieveStatus = retrieveData(Event, FullNexusName, DataArray) ;_plot
    IF (retrieveStatus EQ 0) THEN BEGIN
        IDLsendToGeek_addLogBookText, Event, '-> Plotting the NeXus file FAILED'
    ENDIF ELSE BEGIN
        sz_array = size(DataArray)
        Ntof     = (sz_array)(1)
        Y        = (sz_array)(2)
        X        = (sz_array)(3)
        IDLsendToGeek_addLogBookText, Event, '--> X    : ' + $
          STRCOMPRESS(X,/REMOVE_ALL)
        IDLsendToGeek_addLogBookText, Event, '--> Y    : ' + $
          STRCOMPRESS(Y,/REMOVE_ALL)
        IDLsendToGeek_addLogBookText, Event, '--> Ntof : ' + $
          STRCOMPRESS(Ntof,/REMOVE_ALL)
;plotting data
        message = '-> Plotting NeXus  : ' + PROCESSING
        IDLsendToGeek_addLogBookText, Event, message
        plotDataResult = plotData(Event, DataArray, X, Y) ;_plot
        IF (plotDataResult EQ 0) THEN BEGIN ;failed
            IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
        ENDIF ELSE BEGIN
            IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
        ENDELSE
    ENDELSE
ENDIF ELSE BEGIN
;display name of nexus file name
    putTab1NexusFileName, Event, ''
    message = '-> No NeXus File Loaded'
    IDLsendToGeek_addLogBookText, Event, message
ENDELSE    
END

;===============================================================================
PRO load_run_number, Event    
;get global structure
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global

;retrieve infos
PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed
extension  = (*global).nexus_extension
filter     = (*global).nexus_filter
title      = (*global).nexus_title
path       = (*global).nexus_path

RunNumber = getRunNumber(Event)

IF (RunNumber NE 0) THEN BEGIN
    IDLsendToGeek_putLogBookText, Event, '> Looking for Run Number ' + $
    STRCOMPRESS(RunNumber,/REMOVE_ALL) + ' ... ' + PROCESSING

    isNexusExist = 0
    full_nexus_name = find_full_nexus_name(Event,$
                                           RunNumber,$
                                           'SANS',$
                                           isNexusExist)
    IF (isNexusExist EQ 1 AND $
        full_nexus_name NE '') THEN BEGIN ;success
        IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
        message = '-> NeXus File Name : ' + full_nexus_name
        IDLsendToGeek_addLogBookText, Event, message
    ENDIF ELSE BEGIN
        IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
    ENDELSE
ENDIF

END







;===============================================================================
PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
END

;===============================================================================
PRO sans_reduction_eventcb, event
END

;===============================================================================
