;=========================================================================a=====
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
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  wWidget =  Event.top            ;widget id
  
  CASE Event.id OF
  
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
    ;tab1 ---------------------------------------------------------------------
    
    widget_info(wWidget, find_by_uname='button1'): begin
      event_button, Event, uname='button1'
    end
    
    widget_info(wWidget, find_by_uname='button2'): begin
      event_button, Event, uname='button2'
    end
    
    widget_info(wWidget, find_by_uname='button3'): begin
      event_button, Event, uname='button3'
    end
    
    widget_info(wWidget, find_by_uname='button4'): begin
      event_button, Event, uname='button4'
    end
    
    widget_info(wWidget, find_by_uname='button5'): begin
      event_button, Event, uname='button5'
    end
    
    widget_info(wWidget, find_by_uname='button6'): begin
      event_button, Event, uname='button6'
    end
    
    widget_info(wWidget, find_by_uname='button7'): begin
      event_button, Event, uname='button7'
    end
    
    widget_info(wWidget, find_by_uname='button8'): begin
      event_button, Event, uname='button8'
    end
    
    widget_info(wWidget, find_by_uname='button9'): begin
      event_button, Event, uname='button9'
    end

    widget_info(wWidget, find_by_uname='button10'): begin
      event_button, Event, uname='button10'
    end

    widget_info(wWidget, find_by_uname='button11'): begin
      event_button, Event, uname='button11'
    end

    widget_info(wWidget, find_by_uname='button12'): begin
      event_button, Event, uname='button12'
    end

    widget_info(wWidget, find_by_uname='button13'): begin
      event_button, Event, uname='button13'
    end

    widget_info(wWidget, find_by_uname='button14'): begin
      event_button, Event, uname='button14'
    end

    ;send to tab2
    widget_info(wWidget, find_by_uname='send_to_tab2'): begin
      id1 = widget_info(event.top, find_by_uname='main_tab')
      widget_control, id1, set_tab_current = 1
    end

    ;Tab3
    widget_info(wWidget, find_by_uname='tab3_button1'): begin
      tab3_event_button, Event, uname='tab3_button1'
    end
    
    widget_info(wWidget, find_by_uname='tab3_button2'): begin
      tab3_event_button, Event, uname='tab3_button2'
    end
    
    widget_info(wWidget, find_by_uname='tab3_button3'): begin
      tab3_event_button, Event, uname='tab3_button3'
    end

    widget_info(wWidget, find_by_uname='tab3_button4'): begin
      tab3_event_button, Event, uname='tab3_button4'
    end

    ;tab2 ---------------------------------------------------------------------
    
;    ;Load Command Line File Button
;    WIDGET_INFO(wWidget, FIND_BY_UNAME='browse_path_button'): BEGIN
;      input_dave_ascii_path_button, Event
;    END
;    
;    ;prefix
;    WIDGET_INFO(wWidget, FIND_BY_UNAME='input_prefix_name'): BEGIN
;      parse_input_field_tab2, Event
;      check_run_jobs_button, Event
;    END
;    
;    ;suffix
;    WIDGET_INFO(wWidget, FIND_BY_UNAME='input_suffix_name'): BEGIN
;      parse_input_field_tab2, Event
;      check_run_jobs_button, Event
;    END
;    
;    ;<User_defined>
;    WIDGET_INFO(wWidget, FIND_BY_UNAME='input_sequence'): BEGIN
;      parse_input_field_tab2, Event
;      check_run_jobs_button, Event
;    END
;    
;    ;Help button
;    WIDGET_INFO(wWidget, FIND_BY_UNAME='input_sequence_help'): BEGIN
;      help_button, Event
;    END
;    
;    ;Browse ES button
;    WIDGET_INFO(wWidget, FIND_BY_UNAME='browse_es_file_button'): BEGIN
;      browse_es_file, Event
;      check_run_jobs_button, Event
;    END
;    
;    ;ES input text field
;    WIDGET_INFO(wWidget, FIND_BY_UNAME='es_input_file_name'): BEGIN
;      es_input_file_name, Event
;      check_run_jobs_button, Event
;    END
;    
;    ;Preview and / or edit button of ES file
;    WIDGET_INFO(wWidget, FIND_BY_UNAME='es_file_preview_button'): BEGIN
;      es_preview_file, Event
;    END
;    
;    ;refresh status of file in table
;    WIDGET_INFO(wWidget, FIND_BY_UNAME='refresh_table_uname'): BEGIN
;      refresh_status_of_table, Event
;      check_run_jobs_button, Event
;    END
;    
    ;Quit button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='quit_uname'): BEGIN
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='MAIN_BASE')
      WIDGET_CONTROL, id, /DESTROY
    END
    
;    ;run jobs
;    WIDGET_INFO(wWidget, FIND_BY_UNAME='run_uname'): BEGIN
;      run_divisions, Event
;    END
;    
    ELSE:
    
  ENDCASE
  
END
