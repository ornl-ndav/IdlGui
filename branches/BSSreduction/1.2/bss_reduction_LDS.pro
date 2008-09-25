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

PRO load_live_data_streaming, Event

;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global
WIDGET_CONTROL,/HOURGLASS

PROCESSING = (*global).processing
OK         = 'OK'
FAILED     = 'FAILED'

findlivenexus = (*global).findlivenexus
cmd = findlivenexus + ' -i BSS'
cmd_text = '> Looking for current Live Nexus File (' + cmd + ') ... ' + $
  PROCESSING
AppendLogBookMessage, Event, cmd_text

spawn, cmd, listening, err_listening

IF (listening EQ '') THEN BEGIN ;no file found
    putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
    putTextFieldValue, Event, 'nexus_full_path_label', $
      ' No Live NeXus File Found !!!', 0
ENDIF ELSE BEGIN
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
    ArraySplit    = STRSPLIT(listening,'/',/EXTRACT)
    sz = N_ELEMENTS(ArraySplit)
    ShortFileName = ArraySplit[sz-1]
    putTextFieldValue, Event, 'nexus_full_path_label', $
      ShortFileName, 0
    LogBookText = '-> Full live NeXus name: ' + listening
    AppendLogBookMessage, Event, LogBookText
    iNexus = OBJ_NEW('IDLgetMetadata',listening)
    sRunNumber = STRCOMPRESS(iNexus->getRunNumber())
    LogBookText = '-> Run Number: ' + sRunNumber
    putTextFieldValue, Event,$
      'nexus_run_number',$
      sRunNumber, 0
;load nexus file (retrieve data and plot)
    load_live_nexus, Event, listening, sRunNumber ;_LoadNexus

ENDELSE

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0

END
