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

PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END

;Proposal Folder
;    widget_info(wWidget, FIND_BY_UNAME='proposal_droplist'): begin
;        IF ((*global).EnteringProposal EQ 1) THEN BEGIN
;            (*global).EnteringProposal = 0
;            refreshProposalList, Event ;in _eventcb
;        ENDIF ELSE BEGIN
;            (*global).EnteringProposal = 1
;        ENDELSE
;    END
    
;Instrument
    WIDGET_INFO(wWidget, FIND_BY_UNAME='instrument_droplist'): BEGIN
        repopulateProposalList, Event ;in _eventcb
        instrument      = getInstrument(Event)
        ListOfProposal  = getListOfProposal(instrument)
        IF ((size(ListOfProposal))(1) EQ 1) THEN BEGIN
            putLogBook, Event, 'Please Select another instrument !'
        ENDIF ELSE BEGIN
            putLogBook, Event, ''
            InstrumentMessageBox, Event, instrument ;_eventcb
        ENDELSE
    END

;Histogramming parameters
    widget_info(wWidget, FIND_BY_UNAME='time_offset'): begin
        validateOrNotGoButton, Event
    end
    widget_info(wWidget, FIND_BY_UNAME='time_max'): begin
        validateOrNotGoButton, Event
    end
    widget_info(wWidget, FIND_BY_UNAME='time_bin'): begin
        validateOrNotGoButton, Event
    end

;Preview of Runinfo file
    widget_info(wWidget, FIND_BY_UNAME='preview_button'): begin
        PreviewOfRunInfoFile, Event
    end

;Run Number 
    widget_info(wWidget, FIND_BY_UNAME='run_number_cw_field'): begin
        run_number, Event       ;in _eventcb
        validateOrNotGoButton, Event
    end
    
;Output path
    widget_info(wWidget, FIND_BY_UNAME='output_button'): begin
        output_path, Event      ;in _eventcb
        validateOrNotGoButton, Event
    end
    
;Output path text
    widget_info(wWidget, FIND_BY_UNAME='output_path_text'): begin
        validateOrNotGoButton, Event
    end
    
;Create NeXus
    widget_info(wWidget, FIND_BY_UNAME='create_nexus_button'): begin
       validateCreateNexusButton, Event, 0
        status = CreateNexus(Event) ;_eventcb
        IF ((*global).ArchivedUser) THEN BEGIN
            ValidateArchivedButton, Event, status
        ENDIF
    end

;Archived NeXus
    widget_info(wWidget, FIND_BY_UNAME='archived_button'): begin
        archived_nexus, Event   ;_archived
        ValidateArchivedButton, Event, 0 ;_archived
    end
    
;Send to Geek
    widget_info(wWidget, FIND_BY_UNAME='send_to_geek_button'): begin
        makenexus_LogBookInterface, Event
    end
    
;HELP BUTTON
    WIDGET_INFO(wWidget, FIND_BY_UNAME='help_button'): BEGIN
        start_help              ;_eventcb
    END
    
;MY HELP BUTTON
    WIDGET_INFO(wWidget, FIND_BY_UNAME='my_help_button'): BEGIN
        start_my_help, Event           ;_eventcb
    END
    
    ELSE:
    
ENDCASE

;Histogram Widgets
SWITCH (Event.id) OF
    widget_info(wWidget, FIND_BY_UNAME='time_offset'):
    widget_info(wWidget, FIND_BY_UNAME='time_max'):
    widget_info(wWidget, FIND_BY_UNAME='time_bin'):
    widget_info(wWidget, FIND_BY_UNAME='bin_type_droplist'): BEGIN
        validateOrNotGoButton, Event
    END
    ELSE:
ENDSWITCH

END
