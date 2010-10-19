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

PRO main_base_event, Event

  ;get global structure
  wWidget =  Event.top          ;widget id
  widget_control, wWidget, get_uvalue=global
  
  case (Event.id) of
  
    widget_info(wWidget, find_by_uname='main_base'): BEGIN
    end
    
    ;spins or no spins buttons
    widget_info(wWidget, find_by_uname='no_spins_uname'): begin
    mapBase, event=event, status=0, uname='spins_base'
    end
    widget_info(wWidget, find_by_uname='spins_uname'): begin
    mapBase, event=event, status=1, uname='spins_base'    
    end
    
    ;full reset
    widget_info(wWidget, find_by_uname='full_reset'): begin
     delete_entry, event, 0, 19
      (*global).table_changed = 1b
      refresh_table, event
      full_reset, event
    end
    
    ;main tab
    widget_info(wWidget, find_by_uname='tab_uname'): begin
      tab_selected = getTabSelected(id=event.id)
      if (tab_selected eq 1) then begin ;tab #2
        check_status_of_tab2_buttons, event
      endif
    end
    
    widget_info(wWidget, find_by_unam='plot_setting_untouched'): begin
      switch_settings_plot_values, event
    end
    widget_info(wWidget, find_by_unam='plot_setting_interpolated'): begin
      switch_settings_plot_values, event
    end
    
    ;interaction with table of tab1 (LOAD and SCALE)
    widget_info(wWidget, find_by_uname='tab1_table'): begin
      IF (tag_names(event, /structure_name) EQ 'WIDGET_CONTEXT') THEN BEGIN
        ;        IF (tab1_table_not_empty(Event) EQ 1b AND $
        ;          at_last_one_not_empty_selected_cell(Event) EQ 1b) THEN BEGIN
        id = widget_info(event.top, find_by_uname='context_base')
        widget_displaycontextmenu, event.id, event.X, event.Y, id
      ;        ENDIF
      endif
      save_table, event
    end
    
    ;right click in table -> plot of file(s) selected
    widget_info(wWidget, find_by_uname='table_plot'): begin
      selection = get_table_lines_selected(event)
      plot_rtof_files, event, selection[1], selection[3]
    end
    
    ;right click in table -> preview of file(s) selected
    widget_info(wWidget, find_by_uname='table_preview'): begin
      selection = get_table_lines_selected(event)
      preview_files, event, selection[1], selection[3]
    end
    
    ;right click in table -> delete selected entries.
    widget_info(wWidget, find_by_uname='table_delete'): begin
      selection = get_table_lines_selected(event)
      delete_entry, event, selection[1], selection[3]
      
      ;check the current spin state selected
      spin_state = get_current_spin_state_selected(event)  
      _files_SF_list = (*global).files_SF_list
      full_reset, event
      load_files, event, _files_SF_list[spin_state, 0,*]
      (*global).table_changed = 1b
      ;refresh_table, event
    end
    
    ;Manual scaling button
    widget_info(wWidget, find_by_uname='manual_scaling'): begin
      manual_scale, event
      create_scaled_big_array, event
      (*global).table_changed = 0b
      check_status_of_tab1_buttons, event
    end
    
    ;Manual scaling button and show plot
    widget_info(wWidget, find_by_uname='manual_scaling_and_plot'): begin
      manual_scale, event
      create_scaled_big_array, event
      (*global).table_changed = 0b
      check_status_of_tab1_buttons, event
      show_big_array, event
    end
    
    ;Automatic Scaling button
    widget_info(wWidget, find_by_uname='automatic_scaling'): begin
      (*global).stop_scaling_spin_status = intarr(4)
      auto_scale, event
      create_scaled_big_array, event
      (*global).table_changed = 0b
      check_status_of_tab1_buttons, event
    end
    
    ;Automatic Scaling button and show plot
    widget_info(wWidget, find_by_uname='automatic_scaling_and_plot'): begin
      (*global).stop_scaling_spin_status = intarr(4)
      auto_scale, event
      create_scaled_big_array, event
      show_big_array, event
      (*global).table_changed = 0b
      check_status_of_tab1_buttons, event
    end
    
    ;configuration of automatic scaling
    widget_info(wWidget, find_by_uname='configure_auto_scale'): begin
      configure_auto_scale_base, event
    end

    ;Show plot button
    widget_info(wWidget, find_by_uname='show_plot'): begin
      show_big_array, event
    end
    
    ;********************** OUTPUT TAB ******************
    widget_info(wWidget, find_by_uname='2d_table_ascii_button'): begin
      check_status_of_tab2_buttons, event
    end
    widget_info(wWidget, find_by_uname='3_columns_ascii_button'): begin
      check_status_of_tab2_buttons, event
    end
    widget_info(wWidget, find_by_uname='output_base_file_name'): begin
      check_status_of_tab2_buttons, event
    end
    
    widget_info(wWidget, find_by_uname='create_output_button'): begin
    create_output, event
    end
    
    else:
  endcase
  
end

