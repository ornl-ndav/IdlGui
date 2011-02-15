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
  
  wWidget =  Event.top            ;widget id
  
  CASE Event.id OF
  
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='main_tab'): BEGIN
      cloopes_tab, Event
    END
    
    ;selection buttons
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_1'): BEGIN
      tab1_selection_button, Event, button=1
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_2'): BEGIN
      tab1_selection_button, Event, button=2
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_3'): BEGIN
      tab1_selection_button, Event, button=3
    END
    
    ;clear to_replace text field buttons
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_1_to_replaced_clear'): BEGIN
      putValue, Event, 'selection_1_to_replaced', ''
      disable_second_part_of_selection, Event, 1
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_2_to_replaced_clear'): BEGIN
      putValue, Event, 'selection_2_to_replaced', ''
      disable_second_part_of_selection, Event, 2
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_3_to_replaced_clear'): BEGIN
      putValue, Event, 'selection_3_to_replaced', ''
      disable_second_part_of_selection, Event, 3
    END
    
    ;clear replace_by text field buttons
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_1_replaced_by_clear'): BEGIN
      putValue, Event, 'selection_1_replaced_by', ''
      (*(*global).sequence_field1) = PTR_NEW(0L)
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_2_replaced_by_clear'): BEGIN
      putValue, Event, 'selection_2_replaced_by', ''
      (*(*global).sequence_field2) = PTR_NEW(0L)
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_3_replaced_by_clear'): BEGIN
      putValue, Event, 'selection_3_replaced_by', ''
      (*(*global).sequence_field3) = PTR_NEW(0L)
    END
    
    ;selection to replace #1
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_1_replaced_by'): BEGIN
      determine_replaced_by_sequence, Event
      Create_step1_big_table, Event
      check_status_of_step1, Event
    END
    ;selection to replace #2
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_2_replaced_by'): BEGIN
      determine_replaced_by_sequence, Event
      Create_step1_big_table, Event
      check_status_of_step1, Event
    END
    ;selection to replace #3
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_3_replaced_by'): BEGIN
      determine_replaced_by_sequence, Event
      Create_step1_big_table, Event
      check_status_of_step1, Event
    END
    
    ;Load Command Line File Button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='load_cl_file_button'): BEGIN
      browse_cl_file, Event ;_browse
    END
    
    ;preview of CL
    WIDGET_INFO(wWidget, FIND_BY_UNAME='preview_cl_file_text_field'): BEGIN
    END
    
    ;;input text field
    ;WIDGET_INFO(wWidget, FIND_BY_UNAME='input_text_field'): BEGIN
    ;  print, 'in input'
    ;  parse_input_field, Event ;_input_parser
    ;END
    
    ;Help button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='help_button'): BEGIN
      help_button, Event ;_help
    END
    
    ;check status of jobs submitted button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='check_status_button'): BEGIN
      check_status, Event ;_eventcb
      ;show base that inform the user that the job manager is going to show up
      job_base = job_manager_info_base(Event)
      WAIT, 4
      WIDGET_CONTROL, job_base,/DESTROY
    END
    
    ;preview jobs button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='preview_jobs_button'): BEGIN
      preview_jobs, Event ;_eventcb
    END
    
    ;launch jobs in background button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='run_jobs_button'): BEGIN
      launch_jobs, Event ;_run_jobs
    END
    
    ;tab22222222222222222222222222222222222222222222222222222222222222222222222
    
    ;user and CLoopES convention tab
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='tab2_convention_tab'): BEGIN
      parse_input_field_tab2, Event
      check_tab2_run_jobs_button, Event
      check_load_save_temperature_widgets, Event
    END
    
    ;suffix and prefix of user and CLoopES convention
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_manual_input_suffix_name'): BEGIN
      parse_input_field_tab2, Event
      check_tab2_run_jobs_button, Event
      check_load_save_temperature_widgets, Event
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_manual_input_prefix_name'): BEGIN
      parse_input_field_tab2, Event
      check_tab2_run_jobs_button, Event
      check_load_save_temperature_widgets, Event
    END
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='tab2_user_manual_input_suffix_name'): BEGIN
      parse_input_field_tab2, Event
      check_tab2_run_jobs_button, Event
      check_load_save_temperature_widgets, Event
    END
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='tab2_user_manual_input_prefix_name'): BEGIN
      parse_input_field_tab2, Event
      check_tab2_run_jobs_button, Event
      check_load_save_temperature_widgets, Event
    END
    
    ;DAD's convention
    WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='tab3_manual_input_suffix_name'): BEGIN
      parse_input_field_tab2, Event
      check_tab2_run_jobs_button, Event
      check_load_save_temperature_widgets, Event
    END
    WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='tab3_manual_input_part2'): BEGIN
      parse_input_field_tab2, Event
      check_tab2_run_jobs_button, Event
      check_load_save_temperature_widgets, Event
    END
    WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='tab3_manual_input_prefix_name'): BEGIN
      parse_input_field_tab2, Event
      check_tab2_run_jobs_button, Event
      check_load_save_temperature_widgets, Event
    END
    
    ;Input File path button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_manual_input_folder'): BEGIN
      define_input_folder_tab2, Event
      parse_input_field_tab2, Event
      check_tab2_run_jobs_button, Event
      check_load_save_temperature_widgets, Event
    END
    
    ;<User_defined>
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_manual_input_sequence'): BEGIN
      parse_input_field_tab2, Event
      check_tab2_run_jobs_button, Event
      check_load_save_temperature_widgets, Event
    END
    
    ;help button of manual input
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='tab2_manual_input_sequence_help'): BEGIN
      help_button_tab2, Event ;_help
    END
    
    ;min energy integration range
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='energy_integration_range_min_value'): BEGIN
      check_tab2_run_jobs_button, Event
    END
    
    ;max energy integration range
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='energy_integration_range_max_value'): BEGIN
      check_tab2_run_jobs_button, Event
    END
    
    ;selection of LOOPER input
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_use_looper_input'): BEGIN
      IF (isLooperInputSelected(Event)) THEN BEGIN ;looper selected
        populate_tab2, Event
        check_load_save_temperature_widgets, Event
        check_tab2_run_jobs_button, Event
      ENDIF
    END
    
    ;selection of MANUAL input
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_use_manual_input'): BEGIN
      IF (~isLooperInputSelected(Event)) THEN BEGIN ;looper selected
        parse_input_field_tab2, Event
        check_load_save_temperature_widgets, Event
        check_tab2_run_jobs_button, Event
      ENDIF
    END
    
    ;load temperature button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='load_temperature'): BEGIN
      load_temperature, Event
      check_tab2_run_jobs_button, Event
    END
    
    ;update table
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_table_uname'): BEGIN
      update_temperature, Event
      check_load_save_temperature_widgets, Event
      check_tab2_run_jobs_button, Event
    END
    
    ;Refresh table
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_refresh_table_uname'): BEGIN
      refresh_tab2_table, Event
      check_tab2_run_jobs_button, Event
    END
    
    ;save command line
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_save_command_line'): BEGIN
      cmd = create_cmd(Event)
      save_command_line, Event, cmd=cmd
    END
    
    ;save temperature button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_temperature'): BEGIN
      save_temperature, Event
    END
    
    ;output folder button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_output_folder_button_uname'): BEGIN
      define_output_folder_tab2, Event
    END
    
    ;output file text field
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='tab2_output_file_name_text_field_uname'): BEGIN
      check_tab2_run_jobs_button, Event
    END
    
    ;Check Jobs Status
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_check_job_status_uname'): BEGIN
      check_status, Event ;_eventcb
      ;show base that inform the user that the job manager is going to show up
      job_base = job_manager_info_base(Event)
      WAIT, 4
      WIDGET_CONTROL, job_base,/DESTROY
    END
    
    ;Run Jobs
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tab2_run_jobs_uname'): BEGIN
      run_job_tab2, Event
    END
    
    ;preview of .txt file
    widget_info(wWidget, find_by_uname='tab2_preview_txt_file'): begin

   end
    
    ;tab33333333333333333333333333333333333333333333333333333333333333333333333
    ;- LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK
    WIDGET_INFO(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
      send_to_geek, Event ;_eventcb
    END
    
    ELSE:
    
  ENDCASE
  
END
