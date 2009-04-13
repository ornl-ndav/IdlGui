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
    
;1111111111111111111111111111111111111111111111111111111111111111111111111111111

;#### Instrument Droplist ###
    widget_info(wWidget, FIND_BY_UNAME='list_of_instrument'): BEGIN
        ListOfInstrument, Event ;_eventcb
        ValidatePlotButton, Event ;_GUI
    END

;##### NeXus Run Number ####
    widget_info(wWidget, FIND_BY_UNAME='nexus_run_number'): BEGIN
        LoadRunNumber, Event ;_Load
        PopulateNumberOfBanks, Event ;_GUI
        ValidatePlotButton, Event ;_GUI
    END

;#### Nexus Run Number Clear button ####
    widget_info(wWidget, FIND_BY_UNAME='clear_nexus_run_number'): BEGIN
        ClearTextField, Event, 'nexus_run_number' ;_Gui
        ValidatePlotButton, Event ;_Gui
    END

;#### Browse Nexus File ####
    widget_info(wWidget, FIND_BY_UNAME='browse_nexus'): BEGIN
        BrowseNexusFile, Event ;_eventcb
        PopulateNumberOfBanks, Event ;_GUI
        ValidatePlotButton, Event ;_GUI
    END

;#### Nexus File Text Field
    widget_info(wWidget, FIND_BY_UNAME='nexus_file_text_field'): BEGIN
        PopulateNumberOfBanks, Event ;_GUI
        ValidatePlotButton, Event ;_GUI
    END

;#### Nexus File Text Field Clear button ####
    widget_info(wWidget, FIND_BY_UNAME='clear_nexus_file_text_field'): BEGIN
        ClearTextField, Event, 'nexus_file_text_field' ;_Gui
        ValidatePlotButton, Event ;_Gui
    END

;#### Browse Roi file ####
    widget_info(wWidget, FIND_BY_UNAME='browse_roi_button'): BEGIN
        BrowseRoiFile, Event  ;_eventcb
        ValidatePreviewButton, Event ;_GUI
    END

;#### Roi file Text Field ####
    widget_info(wWidget, FIND_BY_UNAME='roi_text_field'): BEGIN
        ValidatePreviewButton, Event  ;_GUI
    END

;#### ROI Text Field Clear button ####
    widget_info(wWidget, FIND_BY_UNAME='clear_roi_text_field'): BEGIN
        ClearTextField, Event, 'roi_text_field' ;_Gui
        ValidatePreviewButton, Event  ;_GUI
    END

;#### Roi Preview Button ####
    widget_info(wWidget, FIND_BY_UNAME='preview_roi_button'): BEGIN
        PreviewRoiFile, Event ;_eventcb
    END

;#### Bank Droplist ####
    widget_info(wWidget, FIND_BY_UNAME='bank_droplist'): BEGIN
        DisplayBankSelected, Event   ;_eventcb
    END
    
;#### PLOT button ####
    widget_info(wWidget, FIND_BY_UNAME='plot_button'): BEGIN
        PlotData, Event ;_Plot
    END

;#### Send To Geek ####
    widget_info(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
        SendToGeek, Event ;IDLsendToGeek__define
    END
    
    ELSE:
    
ENDCASE

END
