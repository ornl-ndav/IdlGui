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

;------------------------------------------------------------------------------
PRO BrowseDataNexus, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global
filter    = '*.nxs'
extension = 'nxs'
title     = 'Select a NeXus file ...'
path      = (*global).browse_data_path
path = '/SNS/REF_M/IPTS-758/9/3981/NeXus/' ;remove_me
nexus_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
                                  FILTER            = filter,$
                                  TITLE             = title, $
                                  PATH              = path,$
                                  GET_PATH          = new_path,$
                                  /FIX_FILTER,$
                                  /READ)
IF (nexus_file_name NE '') THEN BEGIN
    (*global).browse_data_path = new_path
;load browse nexus file
    load_browse_nexus, Event, nexus_file_name
ENDIF

END

;------------------------------------------------------------------------------
PRO load_browse_nexus, Event, nexus_file_name
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

PROCESSING = (*global).processing_message ;processing message

;get run number
iNexus = OBJ_NEW('IDLgetMetadata', nexus_file_name)
DataRunNumber = iNexus->getRunNumber()
OBJ_DESTROY, iNexus
(*global).DataRunNumber = strcompress(DataRunNumber,/remove_all)
;put run number in DATA RUN NUMBER cw_field

LogBookText = '-> Openning Browsed DATA Run Number: ' + DataRunNumber
text = getLogBookText(Event)
LogBookText += ' ... ' + PROCESSING 
if (text[0] EQ '') then begin
    putLogBookMessage, Event, LogBookText
endif else begin
    putLogBookMessage, Event, LogBookText, Append=1
endelse
putDataLogBookMessage, Event, LogBookText
        
;indicate reading data with hourglass icon
widget_control,/hourglass

NbrNexus = 1
OpenDataNexusFile, Event, DataRunNumber, nexus_file_name

;plot data now
REFreduction_Plot1D2DDataFile, Event 

(*global).DataNeXusFound = 1

;update GUI according to result of NeXus found or not
RefReduction_update_data_gui_if_NeXus_found, Event, 1

DataLogBookText = getDataLogBookText(Event)
putTextAtEndOfDataLogBookLastLine,$
  Event,$
  DataLogBookText,$
  'OK',$
  PROCESSING


END
