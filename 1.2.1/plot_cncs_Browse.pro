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

FUNCTION BrowseRunNumber, Event, $
                          default_extension, $
                          filter,$
                          title,$
                          path

full_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = default_extension,$
                                 FILTER            = filter,$
                                 TITLE             = title,$
                                 PATH              = path,$
                                 /MUST_EXIST)
RETURN, full_file_name
END






PRO BrowseEventRunNumber, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

default_extension = (*global).default_extension
filter            = (*global).event_filter
title             = 'Select an Event File ... '

event_full_file_name = BrowseRunNumber(Event, $
                                       default_extension, $
                                       filter, $
                                       title, $
                                       path)

IF (event_full_file_name NE '') THEN BEGIN
;put file name in widget_text
    putTextInTextField, Event, 'event_file', event_full_file_name
    message = 'User browsed for event file: ' + event_full_file_name
    appendLogBook, Event, message
ENDIF
END


PRO BrowseHistoFile, Event  
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

default_extension = (*global).default_extension
filter            = (*global).histo_map_filter
title             = 'Select an Histogram Mapped File ... '

path = (*global).browse_nexus_path

histo_full_file_name = BrowseRunNumber(Event, $
                                       default_extension, $
                                       filter, $
                                       title, $
                                       path)

IF (histo_full_file_name NE '') THEN BEGIN
;put file name in widget_text
    putTextInTextField, Event, 'histo_mapped_text_field', histo_full_file_name
    message = 'User browsed for histo. mapped file: ' + histo_full_file_name
    appendLogBook, Event, message
ENDIF
END
