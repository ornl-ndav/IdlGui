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

PRO InputRunNumber, Event
;get global structure
widget_control,Event.top,get_uvalue=global

;clear log_book and status message
putStatus, Event, ''
putLogBook, Event, ''

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

;get Run Number
RunNumber = getEventRunNumber(Event)

message = 'Looking for folder with run number ' + RunNumber + ' ... ' + PROCESSING
putLogBook, Event, message
putStatus, Event, message
runFullPath = ''
IF (getRunPath(Event, RunNumber, runFullPath)) THEN BEGIN
    putTextAtEndOfLogBook, Event, OK, PROCESSING
    putTextAtEndOfStatus, Event, OK, PROCESSING
    message = ' -> full path to prenexus file is: ' + runFullPath
    appendLogBook, Event, message
    event_file = '/CNCS_' + RunNumber + (*global).neutron_event_dat_ext
    full_event_file = runFullPath + event_file
    message    = ' -> Looking for event_file ' + $
      full_event_file + ' ... ' + PROCESSING
    appendLogBook, Event, message
    putStatus, Event, message
    IF (FILE_TEST(full_event_file)) THEN BEGIN
        putTextAtEndOfLogBook, Event, OK, PROCESSING
        putTextAtEndOfStatus, Event, OK, PROCESSING
;display name of event file name in event file widget_text
        putTextInTextField, Event, 'event_file', full_event_file
;determine full name of runinfo file name
        runinfoFileName = runFullPath + '/CNCS_' + RunNumber + '_runinfo.xml'
        (*global).runinfoFileName = runinfoFileName
    ENDIF ELSE BEGIN
        putTextAtEndOfLogBook, Event, FAILED, PROCESSING
        putTextAtEndOfStatus, Event, FAILED, PROCESSING
;display name of event file name in event file widget_text
        putTextInTextField, Event, 'event_file', ''
;reset name of runinfo file name
        (*global).runinfoFileName = ''
    ENDELSE
ENDIF ELSE BEGIN
    putTextAtEndOfLogBook, Event, FAILED, PROCESSING
    message = ' -> prenexus folder can not be located'
    appendLogBook, Event, message
    putTextAtEndOfStatus, Event, FAILED, PROCESSING
    putTextInTextField, Event, 'event_file', ''
;reset name of runinfo file name
    (*global).runinfoFileName = ''
ENDELSE

;clear histo_mapped text box
putTextInTextField, Event, 'histo_mapped_text_field', ''

END
