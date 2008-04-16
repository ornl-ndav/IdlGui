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
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global

wWidget = Event.top            ;widget id

CASE Event.id OF
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
;= TAB1 (LOAD DATA) ============================================================

;- Run Number cw_field ---------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='run_number_cw_field'): BEGIN
        load_run_number, Event     ;_eventcb
    END

;- Browse Button ---------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='browse_nexus_button'): BEGIN
        browse_nexus, Event ;_eventcb
    END

;= TAB2 (REDUCE) ===============================================================

;==== tab1 (LOAD FILES) ========================================================

;----Data File -----------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_run_number_cw_field'): BEGIN
        LoadNeXus, Event, $
          'data_run_number_cw_field', $
          'data_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_browse_button'): BEGIN
        BrowseNexus, Event, $
          'data_browse_button',$
          'data_file_name_text_field'
    END
    

;----Solvant Buffer Only File --------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='solvant_run_number_cw_field'): BEGIN
        LoadNeXus, Event, $
          'solvant_run_number_cw_field',$
          'solvant_file_name_text_field'
    END

    WIDGET_INFO(wWidget, FIND_BY_UNAME='solvant_browse_button'): BEGIN
        BrowseNexus, Event, $
          'solvant_browse_button',$
          'solvant_file_name_text_field'
    END

;----Empty Can  ----------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_run_number_cw_field'): BEGIN
        LoadNeXus, Event, $
          'empty_run_number_cw_field',$
          'empty_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_browse_button'): BEGIN
        BrowseNexus, Event, $
          'empty_browse_button',$
          'empty_file_name_text_field'
    END

;----Open Beam  ----------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='open_run_number_cw_field'): BEGIN
        LoadNeXus, Event, $
          'open_run_number_cw_field',$
          'open_file_name_text_field'
    END

    WIDGET_INFO(wWidget, FIND_BY_UNAME='open_browse_button'): BEGIN
        BrowseNexus, Event, $
          'open_browse_button',$
          'open_file_name_text_field'
    END

;----Dark Current  -------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='dark_run_number_cw_field'): BEGIN
        LoadNeXus, Event, $
          'dark_run_number_cw_field',$
          'dark_file_name_text_field'
    END

    WIDGET_INFO(wWidget, FIND_BY_UNAME='dark_browse_button'): BEGIN
        BrowseNexus, Event, $
          'dark_browse_button',$
          'dark_file_name_text_field'
    END

    ELSE:
    
ENDCASE

END
