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

PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
;Instrument
    widget_info(wWidget, FIND_BY_UNAME='instrument_droplist'): begin
        run_number, Event       ;in _eventcb.pro
        validateOrNotGoButton, Event
    end

;Run Number 
    widget_info(wWidget, FIND_BY_UNAME='run_number_cw_field'): begin
        run_number, Event       ;in _eventcb.pro
        validateOrNotGoButton, Event
    end
    
;Output path
    widget_info(wWidget, FIND_BY_UNAME='output_button'): begin
        output_path, Event      ;in _eventcb.pro
        validateOrNotGoButton, Event
    end
    
;Output path text
    widget_info(wWidget, FIND_BY_UNAME='output_path_text'): begin
        validateOrNotGoButton, Event
    end
    
;Create NeXus
    widget_info(wWidget, FIND_BY_UNAME='create_nexus_button'): begin
        validateCreateNexusButton, Event, 0
        status = CreateNexus(Event) ;_eventcb.pro
        ValidateArchivedButton, Event, status
        validateCreateNexusButton, Event, 1
    end

;Archived NeXus
    widget_info(wWidget, FIND_BY_UNAME='archived_button'): begin
        archived_nexus, Event ;_archived
        ValidateArchivedButton, Event, 0 ;_archived.pro
    end

;Send to Geek
    widget_info(wWidget, FIND_BY_UNAME='send_to_geek_button'): begin
       makenexus_LogBookInterface, Event
    end

    ELSE:
    
ENDCASE

END
