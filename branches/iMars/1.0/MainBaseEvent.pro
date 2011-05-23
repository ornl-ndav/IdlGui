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
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  CASE Event.id OF
  
    WIDGET_INFO(event.top, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
    ;reset menu
    ;reset data files
    widget_info(event.top, find_by_uname='reset_data_files_uname'): begin
      reset_table, event=event, uname = 'data_files_table'
    end
    ;reset open beam files
    widget_info(event.top, find_by_uname='reset_open_beam_files_uname'): begin
      reset_table, event=event, uname = 'open_beam_table'
    end
    ;reset dark field files
    widget_info(event.top, find_by_uname='reset_dark_field_files_uname'): begin
      reset_table, event=event, uname = 'dark_field_table'
    end
    ;reset full session
    widget_info(event.top, find_by_uname='full_reset_of_session_uname'): begin
      reset_table, event=event, uname = 'data_files_table'
      reset_table, event=event, uname = 'open_beam_table'
      reset_table, event=event, uname = 'dark_field_table'
    end
    
    ;help menu
    ;log book
    widget_info(event.top, find_by_uname='log_book_uname'): begin
    display_log_book, event
    end
    ;about iMars
    widget_info(event.top, find_by_uname='about_imars_uname'): begin
    about_imars, event
    end
    
    ;browse buttons
    widget_info(event.top, find_by_uname='browse_data_files'): begin
      browse_files, event=event, file_type='data_file'
    end
    widget_info(event.top, find_by_uname='browse_open_beam'): begin
      browse_files, event=event, file_type='open_beam'
    end
    widget_info(event.top, find_by_uname='browse_dark_field'): begin
      browse_files, event=event, file_type='dark_field'
    end
    
    ;roi
    ;load roi
    widget_info(event.top, find_by_uname='roi_load'): begin 
    load_roi, event=event
    end
    ;save roi
    widget_info(event.top, find_by_uname='roi_save'): begin
    save_roi, event=event
    end
    
    ;output folder
    widget_info(event.top, find_by_uname='output_folder_button'): begin
    define_output_folder, event=event
    end
    
    ELSE:
    
  ENDCASE
  
END
