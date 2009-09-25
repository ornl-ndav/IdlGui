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

  COMPILE_OPT hidden
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  wWidget =  Event.top            ;widget id
  
  CASE Event.id OF
  
    ;Instrument Selection
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='instrument_selection_validate_button'): begin
      REFreductionEventcb_InstrumentSelected, Event
    end
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='main_tab'): BEGIN
      tab_event, Event ;_eventcb
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step4_step2_tab'): BEGIN
      tab_step4_step2_event, Event ;_eventcb
    END
    
    ;111111111111111111111111111111111111111111111111111111111111111111111111111111
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab'): BEGIN
      reduce_tab_event, Event ;_eventcb
    END
    
    ;11111111 tab1 11111111 tab1 11111111 tab1 11111111 tab1 11111111 tab1 11111111
    
    ;Browse button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab1_browse_button'): BEGIN
      reduce_tab1_browse_button, Event ;_reduce_step1
      check_status_of_reduce_step1_buttons, Event
    END
    
    ;Run number cw_field
    WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab1_run_cw_field'):BEGIN
    reduce_tab1_run_cw_field, Event ;_reduce_step1
    check_status_of_reduce_step1_buttons, Event
  END
  
  ;OK button of the polarization state base
  WIDGET_INFO(wWidget, FIND_BY_UNAME= $
    'reduce_tab1_pola_base_valid_button'): BEGIN
    update_polarization_states_widgets, Event ;reduce_step1
    MapBase, Event, 'reduce_tab1_polarization_base', 0
    activate_widget, Event, 'reduce_step1_tab_base', 1
    
    AddNexusToReduceTab1Table, Event ;update the table
    check_reduce_step1_gui, Event ;_reduce_step1
    
    select_full_line, Event  ;_reduce_step1
  END
  
  ;table
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab1_table_uname'): BEGIN
    select_full_line, Event  ;_reduce_step1
  END
  
  ;Remove selected Run
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_step1_remove_selection_button'): BEGIN
    remove_selected_run, Event
  END
  
  ;spin states mode selection buttons
  ;spin states match
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_step1_spin_match'): BEGIN
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
      IF (event.press EQ 1) THEN BEGIN
        display_reduce_step1_buttons, EVENT=EVENT,$
          ACTIVATE=1,$
          global
        Reduce_step2_widget_tab_action, Event, ACTIVATE=1
        (*global).reduce_step1_spin_state_mode = 1
      ENDIF
    ENDIF ELSE BEGIN
      IF (Event.ENTER EQ 1) THEN BEGIN ;enter
        standard = 58
      ENDIF ELSE BEGIN
        standard = 31
      ENDELSE
      DEVICE, CURSOR_STANDARD=standard
    ENDELSE
  END
  
  ;spin states do not match (fixed)
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_step1_spin_do_not_match_fixed'): BEGIN
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
      IF (event.press EQ 1) THEN BEGIN
        display_reduce_step1_buttons, EVENT=EVENT,$
          ACTIVATE=2,$
          global
        Reduce_step2_widget_tab_action, Event, ACTIVATE=2
        (*global).reduce_step1_spin_state_mode = 2
      ENDIF
    ENDIF ELSE BEGIN
      IF (Event.ENTER EQ 1) THEN BEGIN ;enter
        standard = 58
      ENDIF ELSE BEGIN
        standard = 31
      ENDELSE
      DEVICE, CURSOR_STANDARD=standard
    ENDELSE
  END
  
  ;spin states do not match (user defined)
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_step1_spin_do_not_match_user_defined'): BEGIN
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
      IF (event.press EQ 1) THEN BEGIN
        display_reduce_step1_buttons, EVENT=EVENT,$
          ACTIVATE=3,$
          global
        Reduce_step2_widget_tab_action, Event, ACTIVATE=3
        (*global).reduce_step1_spin_state_mode = 3
      ENDIF
    ENDIF ELSE BEGIN
      IF (Event.ENTER EQ 1) THEN BEGIN ;enter
        standard = 58
      ENDIF ELSE BEGIN
        standard = 31
      ENDELSE
      DEVICE, CURSOR_STANDARD=standard
    ENDELSE
  END
  
  ;11111111 tab2 11111111 tab2 11111111 tab2 11111111 tab2 11111111 tab2 111111
  
  ;data spin states tab
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_step2_data_spin_state_tab_uname'): BEGIN
    reduce_step2_data_tab, Event
  END
  
  ;browse normalization file button
  WIDGET_INFO(wWidget, FIND_BY_UNAME= 'reduce_step2_browse_button'): BEGIN
    reduce_step2_browse_normalization, Event
    IF ((*global).instrument EQ 'REF_M') THEN BEGIN
      tab_id = WIDGET_INFO(Event.top,$
        FIND_BY_UNAME='reduce_step2_data_spin_state_tab_uname')
      CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
      CASE (currTabSelect) OF
        0: BEGIN ;off_off
          check_status_of_reduce_step2_data_spin_state_hidden_base, Event, $
            tab=1
        END
        1: BEGIN ;off_on
          check_status_of_reduce_step2_data_spin_state_hidden_base, Event, $
            tab=2
        END
        2: BEGIN ;on_off
          check_status_of_reduce_step2_data_spin_state_hidden_base, Event, $
            tab=3
        END
        3: BEGIN ;on_on
          check_status_of_reduce_step2_data_spin_state_hidden_base, Event, $
            tab=4
        END
      ENDCASE
    ENDIF
  END
  
  ;norm cw_field
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_step2_normalization_text_field'): BEGIN
    reduce_step2_run_number_normalization, Event
    putTextFieldValue, Event, 'reduce_step2_normalization_text_field', ''
    IF ((*global).instrument EQ 'REF_M') THEN BEGIN
      tab_id = WIDGET_INFO(Event.top,$
        FIND_BY_UNAME='reduce_step2_data_spin_state_tab_uname')
      CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
      CASE (currTabSelect) OF
        0: BEGIN ;off_off
          check_status_of_reduce_step2_data_spin_state_hidden_base, Event, tab=1
        END
        1: BEGIN ;off_on
          check_status_of_reduce_step2_data_spin_state_hidden_base, Event, tab=2
        END
        2: BEGIN ;on_off
          check_status_of_reduce_step2_data_spin_state_hidden_base, Event, tab=3
        END
        3: BEGIN ;on_on
          check_status_of_reduce_step2_data_spin_state_hidden_base, Event, tab=4
        END
      ENDCASE
    ENDIF
  END
  
  ;remove normalization button
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_step2_list_of_norm_files_remove_button'): BEGIN
    reduce_step2_remove_run, Event
  END
  
  ;Normalization combobox
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_norm_combo0'): BEGIN
    save_new_reduce_tab2_norm_combobox, Event, row=0
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_norm_combo1'): BEGIN
    save_new_reduce_tab2_norm_combobox, Event, row=1
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_norm_combo2'): BEGIN
    save_new_reduce_tab2_norm_combobox, Event, row=2
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_norm_combo3'): BEGIN
    save_new_reduce_tab2_norm_combobox, Event, row=3
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_norm_combo4'): BEGIN
    save_new_reduce_tab2_norm_combobox, Event, row=4
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_norm_combo5'): BEGIN
    save_new_reduce_tab2_norm_combobox, Event, row=5
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_norm_combo6'): BEGIN
    save_new_reduce_tab2_norm_combobox, Event, row=6
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_norm_combo7'): BEGIN
    save_new_reduce_tab2_norm_combobox, Event, row=7
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_norm_combo8'): BEGIN
    save_new_reduce_tab2_norm_combobox, Event, row=8
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_norm_combo9'): BEGIN
    save_new_reduce_tab2_norm_combobox, Event, row=9
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  
  ;============================================================================
  ;Norm spin state combobox of data spin state off_off
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_off0'): BEGIN
    ;    save_new_reduce_tab2_norm_combobox, Event, row=0
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_off1'): BEGIN
    ;    save_new_reduce_tab2_norm_combobox, Event, row=1
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_off2'): BEGIN
    ;    save_new_reduce_tab2_norm_combobox, Event, row=2
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_off3'): BEGIN
    ;   save_new_reduce_tab2_norm_combobox, Event, row=3
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_off4'): BEGIN
    ;   save_new_reduce_tab2_norm_combobox, Event, row=4
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_off5'): BEGIN
    ;   save_new_reduce_tab2_norm_combobox, Event, row=5
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_off6'): BEGIN
    ;   save_new_reduce_tab2_norm_combobox, Event, row=6
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_off7'): BEGIN
    ;   save_new_reduce_tab2_norm_combobox, Event, row=7
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_off8'): BEGIN
    ;   save_new_reduce_tab2_norm_combobox, Event, row=8
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_off9'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=9
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  
  ;Norm spin state combobox of data spin state off_on
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_on0'): BEGIN
    ;   save_new_reduce_tab2_norm_combobox, Event, row=0
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_on1'): BEGIN
    ;   save_new_reduce_tab2_norm_combobox, Event, row=1
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_on2'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=2
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_on3'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=3
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_on4'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=4
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_on5'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=5
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_on6'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=6
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_on7'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=7
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_on8'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=8
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_off_on9'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=9
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  
  ;Norm spin state combobox of data spin state on_off
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_off0'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=0
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_off1'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=1
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_off2'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=2
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_off3'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=3
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_off4'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=4
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_off5'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=5
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_off6'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=6
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_off7'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=7
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_off8'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=8
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_off9'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=9
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  
  ;Norm spin state combobox of data spin state on_on
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_on0'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=0
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_on1'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=1
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_on2'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=2
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_on3'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=3
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_on4'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=4
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_on5'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=5
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_on6'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=6
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_on7'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=7
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_on8'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=8
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_spin_combo_on_on9'): BEGIN
    ;  save_new_reduce_tab2_norm_combobox, Event, row=9
    ;this update the name of the roi files
    refresh_roi_file_name, Event
  END
  
  ;..........................................................................
  ;Browse for a ROI file button (0->9) for REF_L instrument
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_browse_button0'): BEGIN
    reduce_step2_browse_roi, Event, row=0
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_browse_button1'): BEGIN
    reduce_step2_browse_roi, Event, row=1
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_browse_button2'): BEGIN
    reduce_step2_browse_roi, Event, row=2
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_browse_button3'): BEGIN
    reduce_step2_browse_roi, Event, row=3
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_browse_button4'): BEGIN
    reduce_step2_browse_roi, Event, row=4
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_browse_button5'): BEGIN
    reduce_step2_browse_roi, Event, row=5
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_browse_button6'): BEGIN
    reduce_step2_browse_roi, Event, row=6
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_browse_button7'): BEGIN
    reduce_step2_browse_roi, Event, row=7
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_browse_button8'): BEGIN
    reduce_step2_browse_roi, Event, row=8
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_browse_button9'): BEGIN
    reduce_step2_browse_roi, Event, row=9
  END
  
  ;Browse for a ROI file buttons (0->9) data spin state off_off
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_off0'): BEGIN
    reduce_step2_browse_roi, Event, row=0, data_spin_state='Off_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_off1'): BEGIN
    reduce_step2_browse_roi, Event, row=1, data_spin_state='Off_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_off2'): BEGIN
    reduce_step2_browse_roi, Event, row=2, data_spin_state='Off_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_off3'): BEGIN
    reduce_step2_browse_roi, Event, row=3, data_spin_state='Off_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_off4'): BEGIN
    reduce_step2_browse_roi, Event, row=4, data_spin_state='Off_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_off5'): BEGIN
    reduce_step2_browse_roi, Event, row=5, data_spin_state='Off_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_off6'): BEGIN
    reduce_step2_browse_roi, Event, row=6, data_spin_state='Off_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_off7'): BEGIN
    reduce_step2_browse_roi, Event, row=7, data_spin_state='Off_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_off8'): BEGIN
    reduce_step2_browse_roi, Event, row=8, data_spin_state='Off_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_off9'): BEGIN
    reduce_step2_browse_roi, Event, row=9, data_spin_state='Off_Off'
  END
  
  ;Browse for a ROI file buttons (0->9) data spin state off_on
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_on0'): BEGIN
    reduce_step2_browse_roi, Event, row=0, data_spin_state='Off_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_on1'): BEGIN
    reduce_step2_browse_roi, Event, row=1, data_spin_state='Off_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_on2'): BEGIN
    reduce_step2_browse_roi, Event, row=2, data_spin_state='Off_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_on3'): BEGIN
    reduce_step2_browse_roi, Event, row=3, data_spin_state='Off_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_on4'): BEGIN
    reduce_step2_browse_roi, Event, row=4, data_spin_state='Off_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_on5'): BEGIN
    reduce_step2_browse_roi, Event, row=5, data_spin_state='Off_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_on6'): BEGIN
    reduce_step2_browse_roi, Event, row=6, data_spin_state='Off_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_on7'): BEGIN
    reduce_step2_browse_roi, Event, row=7, data_spin_state='Off_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_on8'): BEGIN
    reduce_step2_browse_roi, Event, row=8, data_spin_state='Off_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_off_on9'): BEGIN
    reduce_step2_browse_roi, Event, row=9, data_spin_state='Off_On'
  END
  
  ;Browse for a ROI file buttons (0->9) data spin state on_off
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_off0'): BEGIN
    reduce_step2_browse_roi, Event, row=0, data_spin_state='On_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_off1'): BEGIN
    reduce_step2_browse_roi, Event, row=1, data_spin_state='On_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_off2'): BEGIN
    reduce_step2_browse_roi, Event, row=2, data_spin_state='On_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_off3'): BEGIN
    reduce_step2_browse_roi, Event, row=3, data_spin_state='On_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_off4'): BEGIN
    reduce_step2_browse_roi, Event, row=4, data_spin_state='On_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_off5'): BEGIN
    reduce_step2_browse_roi, Event, row=5, data_spin_state='On_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_off6'): BEGIN
    reduce_step2_browse_roi, Event, row=6, data_spin_state='On_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_off7'): BEGIN
    reduce_step2_browse_roi, Event, row=7, data_spin_state='On_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_off8'): BEGIN
    reduce_step2_browse_roi, Event, row=8, data_spin_state='On_Off'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_off9'): BEGIN
    reduce_step2_browse_roi, Event, row=9, data_spin_state='On_Off'
  END
  
  ;Browse for a ROI file buttons (0->9) data spin state on_on
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_on0'): BEGIN
    reduce_step2_browse_roi, Event, row=0, data_spin_state='On_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_on1'): BEGIN
    reduce_step2_browse_roi, Event, row=1, data_spin_state='On_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_on2'): BEGIN
    reduce_step2_browse_roi, Event, row=2, data_spin_state='On_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_on3'): BEGIN
    reduce_step2_browse_roi, Event, row=3, data_spin_state='On_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_on4'): BEGIN
    reduce_step2_browse_roi, Event, row=4, data_spin_state='On_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_on5'): BEGIN
    reduce_step2_browse_roi, Event, row=5, data_spin_state='On_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_on6'): BEGIN
    reduce_step2_browse_roi, Event, row=6, data_spin_state='On_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_on7'): BEGIN
    reduce_step2_browse_roi, Event, row=7, data_spin_state='On_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_on8'): BEGIN
    reduce_step2_browse_roi, Event, row=8, data_spin_state='On_On'
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_browse_button_on_on9'): BEGIN
    reduce_step2_browse_roi, Event, row=9, data_spin_state='On_On'
  END
  
  ;----------------------------------------------------------------------------
  ;Create/Modify/Visualize ROI file (0->9) for REF_L
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_modify_button0'): BEGIN
    reduce_step2_create_roi, Event, row= 0
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 0
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_modify_button1'): BEGIN
    reduce_step2_create_roi, Event, row= 1
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 1
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_modify_button2'): BEGIN
    reduce_step2_create_roi, Event, row= 2
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 2
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_modify_button3'): BEGIN
    reduce_step2_create_roi, Event, row= 3
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 3
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_modify_button4'): BEGIN
    reduce_step2_create_roi, Event, row= 4
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 4
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_modify_button5'): BEGIN
    reduce_step2_create_roi, Event, row= 5
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 5
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_modify_button6'): BEGIN
    reduce_step2_create_roi, Event, row= 6
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 6
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_modify_button7'): BEGIN
    reduce_step2_create_roi, Event, row= 7
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 7
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_modify_button8'): BEGIN
    reduce_step2_create_roi, Event, row= 8
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 8
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab2_roi_modify_button9'): BEGIN
    reduce_step2_create_roi, Event, row= 9
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 9
  END
  
  ;----------------------------------------------------------------------------
  ;Create/Modify/Visualize ROI file (0->9) for off_off
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_off0'): BEGIN
    reduce_step2_create_roi, Event, row=0, data_spin_state='off_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 0
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_off1'): BEGIN
    reduce_step2_create_roi, Event, row=1, data_spin_state='off_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 1
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_off2'): BEGIN
    reduce_step2_create_roi, Event, row=2, data_spin_state='off_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 2
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_off3'): BEGIN
    reduce_step2_create_roi, Event, row=3, data_spin_state='off_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 3
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_off4'): BEGIN
    reduce_step2_create_roi, Event, row=4, data_spin_state='off_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 4
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_off5'): BEGIN
    reduce_step2_create_roi, Event, row=5, data_spin_state='off_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 5
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_off6'): BEGIN
    reduce_step2_create_roi, Event, row=6, data_spin_state='off_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 6
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_off7'): BEGIN
    reduce_step2_create_roi, Event, row=7, data_spin_state='off_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 7
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_off8'): BEGIN
    reduce_step2_create_roi, Event, row=8, data_spin_state='off_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 8
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_off9'): BEGIN
    reduce_step2_create_roi, Event, row=9, data_spin_state='off_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 9
  END
  
  ;Create/Modify/Visualize ROI file (0->9) for off_on
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_on0'): BEGIN
    reduce_step2_create_roi, Event, row=0, data_spin_state='off_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 0
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_on1'): BEGIN
    reduce_step2_create_roi, Event, row=1, data_spin_state='off_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 1
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_on2'): BEGIN
    reduce_step2_create_roi, Event, row=2, data_spin_state='off_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 2
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_on3'): BEGIN
    reduce_step2_create_roi, Event, row=3, data_spin_state='off_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 3
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_on4'): BEGIN
    reduce_step2_create_roi, Event, row=4, data_spin_state='off_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 4
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_on5'): BEGIN
    reduce_step2_create_roi, Event, row=5, data_spin_state='off_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 5
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_on6'): BEGIN
    reduce_step2_create_roi, Event, row=6, data_spin_state='off_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 6
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_on7'): BEGIN
    reduce_step2_create_roi, Event, row=7, data_spin_state='off_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 7
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_on8'): BEGIN
    reduce_step2_create_roi, Event, row=8, data_spin_state='off_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 8
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_off_on9'): BEGIN
    reduce_step2_create_roi, Event, row=9, data_spin_state='off_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 9
  END
  
  ;Create/Modify/Visualize ROI file (0->9) for on_off
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_off0'): BEGIN
    reduce_step2_create_roi, Event, row=0, data_spin_state='on_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 0
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_off1'): BEGIN
    reduce_step2_create_roi, Event, row=1, data_spin_state='on_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 1
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_off2'): BEGIN
    reduce_step2_create_roi, Event, row=2, data_spin_state='on_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 2
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_off3'): BEGIN
    reduce_step2_create_roi, Event, row=3, data_spin_state='on_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 3
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_off4'): BEGIN
    reduce_step2_create_roi, Event, row=4, data_spin_state='on_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 4
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_off5'): BEGIN
    reduce_step2_create_roi, Event, row=5, data_spin_state='on_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 5
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_off6'): BEGIN
    reduce_step2_create_roi, Event, row=6, data_spin_state='on_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 6
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_off7'): BEGIN
    reduce_step2_create_roi, Event, row=7, data_spin_state='on_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 7
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_off8'): BEGIN
    reduce_step2_create_roi, Event, row=8, data_spin_state='on_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 8
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_off9'): BEGIN
    reduce_step2_create_roi, Event, row=9, data_spin_state='on_off'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 9
  END
  
  ;Create/Modify/Visualize ROI file (0->9) for on_on
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_on0'): BEGIN
    reduce_step2_create_roi, Event, row=0, data_spin_state='on_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 0
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_on1'): BEGIN
    reduce_step2_create_roi, Event, row=1, data_spin_state='on_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 1
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_on2'): BEGIN
    reduce_step2_create_roi, Event, row=2, data_spin_state='on_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 2
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_on3'): BEGIN
    reduce_step2_create_roi, Event, row=3, data_spin_state='on_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 3
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_on4'): BEGIN
    reduce_step2_create_roi, Event, row=4, data_spin_state='on_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 4
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_on5'): BEGIN
    reduce_step2_create_roi, Event, row=5, data_spin_state='on_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 5
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_on6'): BEGIN
    reduce_step2_create_roi, Event, row=6, data_spin_state='on_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 6
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_on7'): BEGIN
    reduce_step2_create_roi, Event, row=7, data_spin_state='on_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 7
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_on8'): BEGIN
    reduce_step2_create_roi, Event, row=8, data_spin_state='on_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 8
  END
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab2_roi_modify_button_on_on9'): BEGIN
    reduce_step2_create_roi, Event, row=9, data_spin_state='on_on'
    check_reduce_step2_save_roi_validity, Event
    (*global).working_reduce_step2_row = 9
  END
  
  ;reduce step2 roi/norm draw
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_step2_create_roi_draw_uname'): BEGIN
    
    error = 0
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
      check_reduce_step2_save_roi_validity, Event
    ENDIF ELSE BEGIN
    
      CASE (event.key) OF ;Up and Down arrow keys
        7: BEGIN
          IF ((*global).reduce_step2_UD_keys_pressed) THEN BEGIN
            (*global).reduce_step2_UD_keys_pressed = 0
          ENDIF ELSE BEGIN
            plot_reduce_step2_norm, Event
            reduce_step2_manual_move, Event, key='up'
            (*global).reduce_step2_UD_keys_pressed = 1
          ENDELSE
        END
        8: BEGIN
          IF ((*global).reduce_step2_UD_keys_pressed) THEN BEGIN
            (*global).reduce_step2_UD_keys_pressed = 0
          ENDIF ELSE BEGIN
            plot_reduce_step2_norm, Event
            reduce_step2_manual_move, Event, key='down'
            (*global).reduce_step2_UD_keys_pressed = 1
          ENDELSE
        END
        ELSE:
      ENDCASE
      
      IF( Event.type EQ 0 )THEN BEGIN
        IF (Event.press EQ 1) THEN BEGIN ;left pressed
          (*global).mouse_left_pressed = 1
          plot_reduce_step2_norm, Event
          plot_reduce_step2_roi, Event
        ENDIF ELSE BEGIN ;right pressed
          inverse_y_selection, Event
          (*global).mouse_right_pressed = 1
        ENDELSE
      ENDIF
      
      IF (Event.type EQ 1) THEN BEGIN ;release
        IF ((*global).mouse_left_pressed) THEN BEGIN ;left mouse released
          (*global).mouse_left_pressed = 0
        ENDIF ELSE BEGIN ;right mouse released
          (*global).mouse_right_pressed = 0
        ENDELSE
        
      ENDIF
      IF (Event.type EQ 2) THEN BEGIN ;move with left pressed
        IF ((*global).mouse_left_pressed) THEN BEGIN
          plot_reduce_step2_norm, Event
          plot_reduce_step2_roi, Event
        ENDIF
      ENDIF
      
    ENDELSE
    check_reduce_step2_save_roi_validity, Event
  END
  
  ;y1 and y2 text field (for manual input of y1 and y2
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_step2_create_roi_y1_value'): BEGIN
    plot_reduce_step2_norm, Event
    plot_reduce_step2_y, event, uname='reduce_step2_create_roi_y2_value'
    plot_reduce_step2_y, event, uname='reduce_step2_create_roi_y1_value'
    check_reduce_step2_save_roi_validity, Event
  END
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_step2_create_roi_y2_value'): BEGIN
    plot_reduce_step2_norm, Event
    plot_reduce_step2_y, event, uname='reduce_step2_create_roi_y2_value'
    plot_reduce_step2_y, event, uname='reduce_step2_create_roi_y1_value'
    check_reduce_step2_save_roi_validity, Event
  END
  
  ;lin/log cw_bgroup
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_step2_create_roi_lin_log'): BEGIN
    plot_reduce_step2_norm, Event
    tmp = (*global).norm_roi_y_selected ;save old y_selected value
    (*global).norm_roi_y_selected = 'all'
    reduce_step2_manual_move, Event
    (*global).norm_roi_y_selected = tmp ;put back old y_selected value
  END
  
  ;browse/load ROI
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_step2_create_roi_browse_roi_button'): BEGIN
    browse_reduce_step2_roi_file, Event
  END
  
  ;SAVE ROI
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_step2_create_roi_save_roi'): BEGIN
    reduce_step2_save_roi, Event, quit_flag='off'
    refresh_roi_file_name, Event
  END
  
  ;SAVE ROI and QUIT
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_step2_create_roi_save_roi_quit'): BEGIN
    ;this update the name of the roi files
    reduce_step2_save_roi, Event, quit_flag='on'
    refresh_roi_file_name, Event
  END
  
  ;return to reduce step2 table
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_step2_return_to_table_button'): BEGIN
    ;this update the name of the roi files
    reduce_step2_return_to_table, Event
    refresh_roi_file_name, Event
  END
  
  ;11111111 tab3 11111111 tab3 11111111 tab3 11111111 tab3 11111111 tab3 111111
  
  ;big table
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reduce_tab3_main_spin_state_table_uname'): BEGIN
    check_status_of_reduce_step3_run_jobs_button, Event
  END
  
  ;define output folder button
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab3_output_folder_button'): BEGIN
    reduces_step3_output_folder, Event
  END
  
  ;Runs jobs
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab3_run_jobs'): BEGIN
    reduce_step3_run_jobs, Event
  END
  
  ;Runs jobs and plot
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab3_run_jobs_and_plot'): BEGIN
    reduce_step3_run_jobs, Event
    reduce_step3_plot_jobs, Event
  END
  
  ;check job manager
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_tab3_check_jobs'): BEGIN
    reduce_step3_job_mamager, Event
    ;show base that inform the user that the job manager is going to show up
    job_base = job_manager_info_base(Event)
    WAIT, 4
    WIDGET_CONTROL, job_base,/DESTROY
    
  END
  
  ;2222222222222222222222222222222222222222222222222222222222222222222222222222
  ;2222222222222222222222222222222222222222222222222222222222222222222222222222
  ;2222222222222222222222222222222222222222222222222222222222222222222222222222
  
  ;Browse ASCII file button
  WIDGET_INFO(wWidget, FIND_BY_UNAME='browse_ascii_file_button'): BEGIN
    browse_ascii_file, Event ;_browse_ascii
    (*global).step2_zmax_backup = (*global).step2_zmax
    (*global).step2_zmin_backup = (*global).step2_zmin
  END
  
  ;Ascii File list
  WIDGET_INFO(wWidget, FIND_BY_UNAME='ascii_file_list'): BEGIN
    activate_widget, Event, 'ascii_delete_button', 1
  END
  
  ;Preview ASCII file selected
  WIDGET_INFO(wWidget, FIND_BY_UNAME='ascii_preview_button'): BEGIN
    preview_ascii_file, Event ;_eventcb
  END
  
  ;Draw
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step2_draw'): BEGIN
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
    ENDIF ELSE BEGIN
      DEVICE, CURSOR_STANDARD=31
      current_list_OF_files = (*(*global).list_OF_ascii_files)
      IF (current_list_OF_files[0] NE '') THEN BEGIN
        delta_x = (*global).delta_x
        x = Event.x
        x1 = FLOAT(delta_x) * FLOAT(x)
        y = Event.y
        y1 = y / 2
        text  = 'x: ' + STRCOMPRESS(x1,/REMOVE_ALL)
        text += '  |  y: ' + STRCOMPRESS(y1,/REMOVE_ALL)
        
        total_array = (*(*global).total_array_untouched)
        size_x = (SIZE(total_array,/DIMENSION))[0]
        size_y = (SIZE(total_array,/DIMENSION))[1]
        IF (x LT size_x AND $
          y LT size_y) THEN BEGIN
          counts = total_array(x,y)
          sIntensity = STRING(counts,FORMAT='(e8.1)')
          intensity = STRCOMPRESS(sIntensity,/REMOVE_ALL)
        ENDIF ELSE BEGIN
          intensity = 'N/A'
        ENDELSE
        text += '  |  counts: ' + intensity
        putTextFieldValue, Event, 'xy_display_step2', text
      ENDIF
    ENDELSE
  END
  
  ;RefreshPlot
  WIDGET_INFO(wWidget, FIND_BY_UNAME='refresh_step2_plot'): BEGIN
    xaxis = (*(*global).x_axis)
    contour_plot, Event, xaxis ;_plot
    plotAsciiData, Event, RESCALE=1, TYPE='replot'
  ;        plotASCIIdata, Event, TYPE='replot' ;_plot
  END
  
  ;delete ascii files
  WIDGET_INFO(wWidget, FIND_BY_UNAME='ascii_delete_button'): BEGIN
    delete_ascii_file_from_list, Event ;_gui
  END
  
  ;transparency list of files droplist
  WIDGET_INFO(wWidget, FIND_BY_UNAME='transparency_file_list'): BEGIN
    update_transparency_coeff_display, Event ;_gui
  END
  
  ;transparency percentage text box
  WIDGET_INFO(wWidget, FIND_BY_UNAME='transparency_coeff'): BEGIN
    changeTransparencyCoeff, Event ;_plot
  END
  
  ;Transparency Full Reset
  WIDGET_INFO(wWidget, FIND_BY_UNAME='trans_full_reset'): BEGIN
    changeTransparencyFullReset, Event ;_plot
  END
  
  ;zmax widget_text
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step2_zmax'): BEGIN
    input_error = 0
    CATCH, input_error
    IF (input_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      (*global).zmax_g = (*global).zmax_g_backup
      (*global).zmin_g = (*global).zmin_g_backup
      double_error = 0
      CATCH, double_error
      IF (double_error NE 0) THEN BEGIN
        CATCH,/CANCEL
        plotAsciiData, Event, TYPE='replot'
      ENDIF ELSE BEGIN
        plotAsciiData, Event, RESCALE=1, TYPE='replot'
      ENDELSE
    ENDIF ELSE BEGIN
      populate_step2_range_widgets, Event
      plotAsciiData, Event, RESCALE=1, TYPE='replot'
      (*global).zmax_g_backup = (*global).zmax_g
      (*global).zmin_g_backup = (*global).zmin_g
    ENDELSE
  END
  
  ;zmin widget_text
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step2_zmin'): BEGIN
    input_error = 0
    CATCH, input_error
    IF (input_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      (*global).zmax_g = (*global).zmax_g_backup
      (*global).zmin_g = (*global).zmin_g_backup
      double_error = 0
      CATCH, double_error
      IF (double_error NE 0) THEN BEGIN
        CATCH,/CANCEL
        plotAsciiData, Event, TYPE='replot'
      ENDIF ELSE BEGIN
        plotAsciiData, Event, RESCALE=1, TYPE='replot'
      ENDELSE
    ENDIF ELSE BEGIN
      populate_step2_range_widgets, Event
      plotAsciiData, Event, RESCALE=1, TYPE='replot'
      (*global).zmax_g_backup = (*global).zmax_g
      (*global).zmin_g_backup = (*global).zmin_g
    ENDELSE
  END
  
  ;Reset zmin and zmax
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step2_z_reset'): BEGIN
    plotAsciiData, Event, TYPE='replot'
  END
  
  ;lin/log z-azis scale
  WIDGET_INFO(wWidget, FIND_BY_UNAME='z_axis_linear_log'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      plotAsciiData, Event, RESCALE=1, TYPE='replot'
    ENDIF
  END
  
  ;less x-axis ticks
  WIDGET_INFO(wWidget, FIND_BY_UNAME='x_axis_less_ticks'): BEGIN
    change_xaxis_ticks, Event, type='less' ;_plot
  END
  
  ;more x-axis ticks
  WIDGET_INFO(wWidget, FIND_BY_UNAME='x_axis_more_ticks'): BEGIN
    change_xaxis_ticks, Event, type='more' ;_plot
  END
  
  ;3333333333333333333333333333333333333333333333333333333333333333333333333333
  ;zmax widget_text
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step3_zmax'): BEGIN
    input_error = 0
    CATCH, input_error
    IF (input_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      (*global).zmax_g = (*global).zmax_g_backup
      (*global).zmin_g = (*global).zmin_g_backup
      IF ((*global).debugging EQ 'yes') THEN BEGIN
        PRINT, 'Catch statement of step3_zmax'
        PRINT, ' zmax_g: ' + STRCOMPRESS((*global).zmax_g)
        PRINT, ' zmin_g: ' + STRCOMPRESS((*global).zmin_g)
      ENDIF
      plotAsciiData_shifting, Event
    ENDIF ELSE BEGIN
      populate_step3_range_widgets, Event
      plotAsciiData_shifting, Event
      plotReferencedPixels, Event
      refresh_plot_selection_OF_2d_plot_mode, Event
    ENDELSE
    (*global).zmax_g_backup = (*global).zmax_g
    (*global).zmin_g_backup = (*global).zmin_g
  END
  
  ;zmin widget_text
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step3_zmin'): BEGIN
    input_error = 0
    CATCH, input_error
    IF (input_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      (*global).zmax_g = (*global).zmax_g_backup
      (*global).zmin_g = (*global).zmin_g_backup
      IF ((*global).debugging EQ 'yes') THEN BEGIN
        PRINT, 'Catch statement of step3_zmax'
        PRINT, ' zmax_g: ' + STRCOMPRESS((*global).zmax_g)
        PRINT, ' zmin_g: ' + STRCOMPRESS((*global).zmin_g)
      ENDIF
      plotAsciiData_shifting, Event
    ENDIF ELSE BEGIN
      populate_step3_range_widgets, Event
      plotAsciiData_shifting, Event
      plotReferencedPixels, Event
      refresh_plot_selection_OF_2d_plot_mode, Event
    ENDELSE
    (*global).zmax_g_backup = (*global).zmax_g
    (*global).zmin_g_backup = (*global).zmin_g
  END
  
  ;Reset zmin and zmax
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step3_z_reset'): BEGIN
    plotAsciiData_shifting, Event, RESET='yes'
    (*global).zmax_g_backup = (*global).zmax_g
    (*global).zmin_g_backup = (*global).zmin_g
  END
  
  ;lin/log z-azis scale
  WIDGET_INFO(wWidget, FIND_BY_UNAME='z_axis_linear_log_shifting'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      plotASCIIdata_shifting, Event ;_shifting
      plotReferencedPixels, Event ;_shifting
      plot_selection_OF_2d_plot_mode, Event
    ENDIF
  END
  
  ;less x-axis ticks
  WIDGET_INFO(wWidget, FIND_BY_UNAME='x_axis_less_ticks_shifting'): BEGIN
    change_xaxis_ticks_shifting, Event, type='less' ;_shifting
  END
  
  ;more x-axis ticks
  WIDGET_INFO(wWidget, FIND_BY_UNAME='x_axis_more_ticks_shifting'): BEGIN
    change_xaxis_ticks_shifting, Event, type='more' ;_shifting
  END
  
  ;Draw
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step3_draw'): BEGIN
    DEVICE, CURSOR_STANDARD=31
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
    
      delta_x = (*global).delta_x
      x = Event.x
      x1 = FLOAT(delta_x) * FLOAT(x)
      Xtext = 'X: ' + STRCOMPRESS(x1,/REMOVE_ALL)
      putTextFieldValue, Event, 'x_value_shifting', Xtext
      
      y = Event.y
      y1 = y / 2
      Ytext = 'Y: ' + STRCOMPRESS(y1,/REMOVE_ALL)
      putTextFieldValue, Event, 'y_value_shifting', Ytext
      
      total_array = (*(*global).total_array_untouched)
      size_x = (SIZE(total_array,/DIMENSION))[0]
      size_y = (SIZE(total_array,/DIMENSION))[1]
      IF (x LT size_x AND $
        y LT size_y) THEN BEGIN
        counts = total_array(x,y)
        sIntensity = STRING(counts,FORMAT='(e8.1)')
        intensity = STRCOMPRESS(sIntensity,/REMOVE_ALL)
      ENDIF ELSE BEGIN
        intensity = 'N/A'
      ENDELSE
      CountsText = 'Counts: ' + STRCOMPRESS(intensity,/REMOVE_ALL)
      putTextFieldValue, Event, 'counts_value_shifting', CountsText
      
      IF (Event.type EQ 2 AND $
        (*global).left_mouse_pressed EQ 1) THEN BEGIN ;move mouse
        IF (isPlot2DModeSelected(Event) EQ 0) THEN BEGIN
          SavePlotReferencePixel, Event ;_shifting
          replotAsciiData_shifting, Event ;_shifting
          plotReferencedPixels, Event ;_shifting
          refresh_plot_selection_OF_2d_plot_mode, Event
        ENDIF
      ENDIF
      
      ;selection mode
      IF (isPlot2DModeSelected(Event) EQ 0) THEN BEGIN
        IF (Event.type EQ 1) THEN BEGIN ;release mouse
          (*global).left_mouse_pressed = 0
          index = $
            getCWBgroupValue(Event, $
            'fast_selection_pixel_selection_mode')
          IF (index EQ 0) THEN BEGIN ;automatic mode
            move_to_next_active_file, Event ;_shifting
          ENDIF
          
        ENDIF
        
        IF (Event.press EQ 1) THEN BEGIN ;left click
          (*global).left_mouse_pressed = 1 ;selection mode
          SavePlotReferencePixel, Event ;_shifting
          replotAsciiData_shifting, Event ;_shifting
          plotReferencedPixels, Event ;_shifting
          CheckShiftingGui, Event ;_gui
          refresh_plot_selection_OF_2d_plot_mode, Event
        ENDIF
      ENDIF ELSE BEGIN
        ;plot2D mode
        IF (Event.type EQ 1) THEN BEGIN ;release mouse
          (*global).left_mouse_pressed = 0
        ENDIF
        
        IF (Event.press EQ 1) THEN BEGIN ;left click
          (*global).left_mouse_pressed = 1
          ref_off_spec_shifting_plot2d, $
            Event, $
            GROUP_LEADER=Event.top
          (*global).plot2d_x_left = Event.x
          (*global).plot2d_y_left = Event.y
        ENDIF
        
        IF (Event.type EQ 2) THEN BEGIN ;move mouse
          IF ((*global).left_mouse_pressed) THEN BEGIN
            (*global).plot2d_x_right = Event.x
            (*global).plot2d_y_right = Event.y
            plot_selection_OF_2d_plot_mode, Event ;shifting_plot2d
          ENDIF
        ENDIF
        
      ENDELSE
    ENDIF
    
  END
  
  ;Active file droplist
  WIDGET_INFO(wWidget, FIND_BY_UNAME='active_file_droplist_shifting'): BEGIN
    WIDGET_CONTROL,/HOURGLASS
    ActiveFileDroplist, Event ;_shifting
    plotAsciiData_shifting, Event ;_shifting
    plotReferencedPixels, Event ;_shifting
    CheckShiftingGui, Event
    refresh_plot_selection_OF_2d_plot_mode, Event
    WIDGET_CONTROL,HOURGLASS=0
  END
  
  ;Reference pixel value
  WIDGET_INFO(wWidget, FIND_BY_UNAME='reference_pixel_value_shifting'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      WIDGET_CONTROL,/HOURGLASS
      index = getDropListSelectedIndex(Event, $
        'active_file_droplist_shifting')
      ref_pixel_list = (*(*global).ref_pixel_list)
      pixel_value = getTextFieldValue(Event, $
        'reference_pixel_value_shifting')
      ref_pixel_list[index] = pixel_value
      (*(*global).ref_pixel_list) = ref_pixel_list
      plotAsciiData_shifting, Event ;_shifting
      plotReferencedPixels, Event ;_shifting
      refresh_plot_selection_OF_2d_plot_mode, Event
      WIDGET_CONTROL,HOURGLASS=0
      CheckShiftingGui, Event ;_gui
    ENDIF
  END
  
  ;Move Down selected reference pixel
  WIDGET_INFO(wWidget, FIND_BY_UNAME='pixel_down_selection_shifting'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      WIDGET_CONTROL,/HOURGLASS
      index = getDropListSelectedIndex(Event, $
        'active_file_droplist_shifting')
      ref_pixel_list = (*(*global).ref_pixel_list)
      pixel_value = getTextFieldValue(Event, $
        'reference_pixel_value_shifting')
      delta_x = getTextFieldValue(Event,'move_by_x_pixel_value_shifting')
      new_pixel_value = FLOAT(pixel_value) - FLOAT(delta_x)
      IF (new_pixel_value LT 0) THEN BEGIN
        new_pixel_value = 0
      ENDIF
      ref_pixel_list[index] = new_pixel_value
      putTextFieldValue, Event, $
        'reference_pixel_value_shifting', $
        STRCOMPRESS(FIX(new_pixel_value),/REMOVE_ALL)
      (*(*global).ref_pixel_list) = ref_pixel_list
      (*(*global).ref_pixel_list_original) = ref_pixel_list
      plotAsciiData_shifting, Event ;_shifting
      plotReferencedPixels, Event ;_shifting
      refresh_plot_selection_OF_2d_plot_mode, Event
      WIDGET_CONTROL,HOURGLASS=0
      CheckShiftingGui, Event ;_gui
    ENDIF
  END
  
  
  ;Move Up selected reference pixel
  WIDGET_INFO(wWidget, FIND_BY_UNAME='pixel_up_selection_shifting'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      WIDGET_CONTROL,/HOURGLASS
      index = getDropListSelectedIndex(Event, $
        'active_file_droplist_shifting')
      ref_pixel_list = (*(*global).ref_pixel_list)
      pixel_value = getTextFieldValue(Event, $
        'reference_pixel_value_shifting')
      delta_x = getTextFieldValue(Event,'move_by_x_pixel_value_shifting')
      new_pixel_value = FLOAT(pixel_value) + FLOAT(delta_x)
      IF (new_pixel_value GT 303) THEN BEGIN
        new_pixel_value = 303
      ENDIF
      ref_pixel_list[index] = new_pixel_value
      putTextFieldValue, Event, $
        'reference_pixel_value_shifting', $
        STRCOMPRESS(FIX(new_pixel_value),/REMOVE_ALL)
      (*(*global).ref_pixel_list) = ref_pixel_list
      (*(*global).ref_pixel_list_original) = ref_pixel_list
      plotAsciiData_shifting, Event ;_shifting
      plotReferencedPixels, Event ;_shifting
      refresh_plot_selection_OF_2d_plot_mode, Event
      WIDGET_CONTROL,HOURGLASS=0
      CheckShiftingGui, Event ;_gui
    ENDIF
  END
  
  ;help of 'Reference File'
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reference_file_name_shifting_help'): BEGIN
    display_shifting_help, Event, 'reference_file' ;_shifting
  END
  
  ;help of 'active file'
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='active_file_droplist_shifting_help'): BEGIN
    display_shifting_help, Event, 'active_file' ;_shifting
  END
  
  ;help of 'reference pixel'
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='reference_pixel_help'): BEGIN
    display_shifting_help, Event, 'reference_pixel' ;_shifting
  END
  
  ;help of 'move down & up'
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='pixel_down_up_help'): BEGIN
    display_shifting_help, Event, 'pixel_down_up' ;_shifting
  END
  
  ;Realign Data button
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='realign_data_button'): BEGIN
    realign_data, Event ;_shifting
  END
  
  ;Cancel Realign Data button
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='cancel_realign_data_button'): BEGIN
    cancel_realign_data, Event ;_shifting
  END
  
  ;Manual Mode - Move UP
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='data_up_shifting'): BEGIN
    manual_move_mode_shifting, Event, DIRECTION='up' ;_shifting
  END
  
  ;Manual Mode - Move DOWN
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='data_down_shifting'): BEGIN
    manual_move_mode_shifting, Event, DIRECTION='down' ;_shifting
  END
  
  ;----------------------------------------------------------------------------
  ;4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-
  ;----------------------------------------------------------------------------
  
  ;4_1/4_1/4_1/4_1/4_1/4_1/4_1/4_1/4_1/4_1/4_1/4_1/4_1/4_1/4_1/4_1/4_1/4_1/4_1/
  
  ;zmax widget_text
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step4_zmax'): BEGIN
    input_error = 0
    CATCH, input_error
    IF (input_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      (*global).zmax_g = (*global).zmax_g_backup
      (*global).zmin_g = (*global).zmin_g_backup
      IF ((*global).debugging EQ 'yes') THEN BEGIN
        PRINT, 'Catch statement of step4_zmax'
        PRINT, ' zmax_g: ' + STRCOMPRESS((*global).zmax_g)
        PRINT, ' zmin_g: ' + STRCOMPRESS((*global).zmin_g)
      ENDIF
      plotAsciiData_scaling_step1, Event
    ENDIF ELSE BEGIN
      populate_step4_range_widgets, Event
      plotAsciiData_scaling_step1, Event
    ENDELSE
    plotReferencedPixels, Event
    refresh_plotStep4Step1Selection, Event
    refresh_plot_selection_OF_2d_plot_mode, Event
    (*global).zmax_g_backup = (*global).zmax_g
    (*global).zmin_g_backup = (*global).zmin_g
  END
  
  ;zmin widget_text
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step4_zmin'): BEGIN
    input_error = 0
    CATCH, input_error
    IF (input_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      (*global).zmax_g = (*global).zmax_g_backup
      (*global).zmin_g = (*global).zmin_g_backup
      IF ((*global).debugging EQ 'yes') THEN BEGIN
        PRINT, 'Catch statement of step4_zmax'
        PRINT, ' zmax_g: ' + STRCOMPRESS((*global).zmax_g)
        PRINT, ' zmin_g: ' + STRCOMPRESS((*global).zmin_g)
      ENDIF
      plotAsciiData_scaling_step1, Event
    ENDIF ELSE BEGIN
      populate_step4_range_widgets, Event
      plotAsciiData_scaling_step1, Event
    ENDELSE
    plotReferencedPixels, Event
    refresh_plotStep4Step1Selection, Event
    refresh_plot_selection_OF_2d_plot_mode, Event
    (*global).zmax_g_backup = (*global).zmax_g
    (*global).zmin_g_backup = (*global).zmin_g
  END
  
  ;Reset zmin and zmax
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step4_z_reset'): BEGIN
    plotAsciiData_scaling_step1, Event, RESET='yes'
    (*global).zmax_g_backup = (*global).zmax_g
    (*global).zmin_g_backup = (*global).zmin_g
  END
  
  WIDGET_INFO(wWidget, FIND_BY_UNAME='scaling_main_tab'): BEGIN
    scaling_tab_event, Event ;_eventcb
  END
  
  ;lin/log z-azis scale
  WIDGET_INFO(wWidget, FIND_BY_UNAME= $
    'z_axis_linear_log_scaling_step1'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      refresh_step4_step1_plot, Event ;_scaling_step1
    ENDIF
  END
  
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step4_step1_draw'): BEGIN
    DEVICE, CURSOR_STANDARD=31
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
    
      delta_x = (*global).delta_x
      x = Event.x
      x1 = FLOAT(delta_x) * FLOAT(x)
      Xtext = 'X: ' + STRCOMPRESS(x1,/REMOVE_ALL)
      putTextFieldValue, Event, 'x_value_scaling_step1', Xtext
      
      y = Event.y
      y1 = y / 2
      Ytext = 'Y: ' + STRCOMPRESS(y1,/REMOVE_ALL)
      putTextFieldValue, Event, 'y_value_scaling_step1', Ytext
      
      total_array = (*(*global).total_array_untouched)
      size_x = (SIZE(total_array,/DIMENSION))[0]
      size_y = (SIZE(total_array,/DIMENSION))[1]
      IF (x LT size_x AND $
        y LT size_y AND $
        x GE 0 AND $
        y GE 0) THEN BEGIN
        counts = total_array(x,y)
        sIntensity = STRING(counts,FORMAT='(e8.1)')
        intensity = STRCOMPRESS(sIntensity,/REMOVE_ALL)
      ENDIF ELSE BEGIN
        intensity = 'N/A'
      ENDELSE
      CountsText = 'Counts: ' + STRCOMPRESS(intensity,/REMOVE_ALL)
      putTextFieldValue, Event, 'counts_value_scaling_step1', CountsText
      
      ;left click -------------------------------------------------------
      IF (Event.press EQ 1) THEN BEGIN ;left click
        bClick = $
          check_IF_click_OR_move_situation(Event) ;_scaling_step1
        (*global).bClick_step4_step1 = bClick
        (*global).step4_step1_left_mouse_pressed = 1
        (*global).ResizeOrMove = $
          check_IF_resize_OR_move_situation(Event)
        IF (bClick) THEN BEGIN ;left click (no resize)
          save_selection_left_position_step4_step1, $
            Event     ;_scaling_step1
          display_x_y_min_max_step4_step1, Event, TYPE='left_click'
        ENDIF ELSE BEGIN ;resize or move
          save_fix_corner, Event ;scaling_step1
        ENDELSE
        reset_step4_2_2_selection, Event ;scaling_step2_step2
      ENDIF               ;end of left click
      
      ;move mouse -------------------------------------------------------
      IF (Event.type EQ 2 AND $
        (*global).step4_step1_left_mouse_pressed) THEN BEGIN
        bClick = (*global).bClick_step4_step1
        replotAsciiData_scaling_step1, Event ;scaling_step1
        IF (bClick) THEN BEGIN
          plotStep4Step1Selection, Event ;scaling_step1
        ENDIF ELSE BEGIN ;move region
          move_selection_step4_step1, Event ;scaling_step1
          refresh_plotStep4Step1Selection, Event
        ENDELSE
        display_x_y_min_max_step4_step1, Event, TYPE='move'
        display_step4_step1_plot2d, Event
      ENDIF
      
      ;release mouse ----------------------------------------------------
      IF (Event.type EQ 1 AND $
        (*global).step4_step1_left_mouse_pressed) THEN BEGIN
        bClick = (*global).bClick_step4_step1
        (*global).step4_step1_left_mouse_pressed = 0
        replotAsciiData_scaling_step1, Event ;scaling_step1
        IF (bClick) THEN BEGIN
          plotStep4Step1Selection, Event ;scaling_step1
        ENDIF ELSE BEGIN
          refresh_plotStep4Step1Selection, Event
        ENDELSE
        save_y_error_step4_step1_plot2d, Event ;scaling_step1_plot2d
      ENDIF
    ENDIF
  END
  
  ;Selection Info Text Fields -------------------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='selection_info_xmin_value'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      move_selection_manually_step4_step1, Event ;scaling_step1
      display_step4_step1_plot2d, Event
    ENDIF
  END
  
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='selection_info_ymin_value'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      move_selection_manually_step4_step1, Event ;scaling_step1
      display_step4_step1_plot2d, Event
    ENDIF
  END
  
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='selection_info_xmax_value'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      move_selection_manually_step4_step1, Event ;scaling_step1
      display_step4_step1_plot2d, Event
    ENDIF
  END
  
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='selection_info_ymax_value'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      move_selection_manually_step4_step1, Event ;scaling_step1
      display_step4_step1_plot2d, Event
    ENDIF
  END
  
  ;Move Up, left, right and down button ---------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_step1_move_selection_left'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      move_step4_step1_selection, Event, DIRECTION='left' ;_scaling_step1
      display_step4_step1_plot2d, Event
    ENDIF
  END
  
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_step1_move_selection_right'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      move_step4_step1_selection, Event, DIRECTION='right'
      display_step4_step1_plot2d, Event
    ENDIF
  END
  
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_step1_move_selection_up'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      move_step4_step1_selection, Event, DIRECTION='up' ;_scaling_step1
      display_step4_step1_plot2d, Event
    ENDIF
  END
  
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_step1_move_selection_down'): BEGIN
    current_list_OF_files = (*(*global).list_OF_ascii_files)
    IF (current_list_OF_files[0] NE '') THEN BEGIN
      move_step4_step1_selection, Event, DIRECTION='down' ;_scaling_step1
      display_step4_step1_plot2d, Event
    ENDIF
  END
  
  ;4_2/4_2/4_2/4_2/4_2/4_2/4_2/4_2/4_2/4_2/4_2/4_2/4_2/4_2/4_2/4_2/4_2/4_2/4_2
  
  ;lin/log
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step4_step2_z_axis_linear_log'): BEGIN
    re_display_step4_step2_step1_selection, Event ;scaling_step2
    tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step2_tab')
    CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
    IF (CurrTabSelect EQ 1) THEN BEGIN
      re_plot_lambda_selected, Event ;scaling_step2
      re_plot_fitting, Event ;scaling_step2_step2
    ENDIF
  END
  
  ;X/Y/Min/Max
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step4_2_zoom_x_min'): BEGIN
    re_display_step4_step2_step1_selection, Event ;scaling_step2
    tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step2_tab')
    CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
    IF (CurrTabSelect EQ 1) THEN BEGIN
      re_plot_lambda_selected, Event ;scaling_step2
      re_plot_fitting, Event ;scaling_step2_step2
    ENDIF
  END
  
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step4_2_zoom_x_max'): BEGIN
    re_display_step4_step2_step1_selection, Event ;scaling_step2
    tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step2_tab')
    CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
    IF (CurrTabSelect EQ 1) THEN BEGIN
      re_plot_lambda_selected, Event ;scaling_step2
      re_plot_fitting, Event ;scaling_step2_step2
    ENDIF
  END
  
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step4_2_zoom_reset_axis'): BEGIN
    reset_zoom_widgets, Event ;scaling_step2
    re_display_step4_step2_step1_selection, Event ;scaling_step2_step1
    tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step2_tab')
    CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
    IF (CurrTabSelect EQ 1) THEN BEGIN
      plotLambdaSelected, Event ;scaling_step2_step2
      re_plot_fitting, Event ;scaling_step2_step2
    ENDIF
  END
  
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step4_2_zoom_y_min'): BEGIN
    re_display_step4_step2_step1_selection, Event ;scaling_step2
    tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step2_tab')
    CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
    IF (CurrTabSelect EQ 1) THEN BEGIN
      re_plot_lambda_selected, Event ;scaling_step2
      re_plot_fitting, Event ;scaling_step2_step2
    ENDIF
  END
  
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step4_2_zoom_y_max'): BEGIN
    re_display_step4_step2_step1_selection, Event ;scaling_step2
    tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step2_tab')
    CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
    IF (CurrTabSelect EQ 1) THEN BEGIN
      re_plot_lambda_selected, Event ;scaling_step2
      re_plot_fitting, Event ;scaling_step2_step2
    ENDIF
  END
  
  ;Critical Edge Tab ----------------------------------------------------------
  
  ;if mouse is over plot
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME= $
    'draw_step4_step2'): BEGIN
    DEVICE, CURSOR_STANDARD=31
    xy_position = (*global).step4_step1_selection
    IF (xy_position[0]+xy_position[2] NE 0 AND $
      xy_position[1]+xy_position[3] NE 0) THEN BEGIN ;valid selection
      tab_id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step4_step2_tab')
      CurrTabSelect = WIDGET_INFO(tab_id,/TAB_CURRENT)
      IF (CurrTabSelect EQ 1) THEN BEGIN ;CE file
      
        IF (Event.press EQ 1) THEN BEGIN ;left click
          (*global).step4_2_2_left_click = 1
          step4_2_left_click, Event ;scaling_step2_step2
        ENDIF
        
        IF (Event.press EQ 4) THEN BEGIN ;right click
          ;scaling_step2_step2
          step4_2_reverse_status_OF_lambda_selected, Event
          
        ENDIF
        
        IF (Event.type EQ 2) THEN BEGIN ;move mouse
          IF ((*global).step4_2_2_left_click) THEN BEGIN
            step4_2_move, Event ;scaling_step2_step2
          ENDIF
        ENDIF
        
        IF (Event.type EQ 1) THEN BEGIN ;release mouse
          reorder_step4_2_2_lambda, Event ;scaling_step2_step2
          (*global).step4_2_2_left_click = 0
        ENDIF
        
        ;check step4_step2_step2 gui
        check_step4_step2_step2, Event ;scaling_step2_step2
        
      ENDIF
    ENDIF
  END
  
  ;Lambda min and max text fields ---------------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_2_lambda1_text_field'): BEGIN
    manual_lambda_input, Event ;scaling_step2_step2
  END
  
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_2_lambda2_text_field'): BEGIN
    manual_lambda_input, Event ;scaling_step2_step2
  END
  
  ;Automatic fitting and scaling of data --------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_2_auto_button'): BEGIN
    step4_2_2_automatic_fitting_scaling, Event ;scaling_step4_step2
    check_step4_2_2_gui, Event ;scaling_step2_step2
  END
  
  ;SF text field --------------------------------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step2_manual_scaling_button'): BEGIN
    step4_2_2_manual_scaling, Event ;scaling_step2_step2
  END
  
  ;Manual scaling of data -----------------------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step2_sf_text_field'): BEGIN
    step4_2_2_manual_scaling, Event ;scaling_step2_step2
  END
  
  ;Reset scaling of data ------------------------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_2_reset_scaling_button'): BEGIN
    step4_2_2_reset_scaling, Event ;scaling_step2_step2
  END
  
  ;4_3/4_3/4_3/4_3/4_3/4_3/4_3/4_3/4_3/4_3/4_3/4_3/4_3/4_3/4_3/4_3/4_3/4_3/4_3/
  ;Scaling of Other Files
  
  ;Automatic Rescaling button -------------------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_3_automatic_rescale_button'): BEGIN
    step4_2_3_auto_scaling, Event ;scaling_step2_step3
  END
  
  ;Reset Rescaling button -----------------------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_3_reset_rescale_button'): BEGIN
    step4_2_3_reset_scaling, Event ;scaling_step2_step3
  END
  
  ;Working file droplist ------------------------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_3_work_on_file_droplist'): BEGIN
    step4_2_3_droplist, Event ;scaling_step2_step3
  END
  
  ;Moving up working file data by factor #4 -----------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_3_3increase_button'): BEGIN
    step4_2_3_manual_scaling, Event, FACTOR='-4' ;scaling_step2_step3
  END
  
  ;Moving up working file data by factor #3 -----------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_3_2increase_button'): BEGIN
    step4_2_3_manual_scaling, Event, FACTOR='-3' ;scaling_step2_step3
  END
  
  ;Moving up working file data by factor #2 -----------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_3_1increase_button'): BEGIN
    step4_2_3_manual_scaling, Event, FACTOR='-2' ;scaling_step2_step3
  END
  
  ;Moving down working file data by factor #4 ---------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_3_3decrease_button'): BEGIN
    step4_2_3_manual_scaling, Event, FACTOR='4' ;scaling_step2_step3
  END
  
  ;Moving down working file data by factor #3 ---------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_3_2decrease_button'): BEGIN
    step4_2_3_manual_scaling, Event, FACTOR='3' ;scaling_step2_step3
  END
  
  ;Moving down working file data by factor #2 ---------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_3_1decrease_button'): BEGIN
    step4_2_3_manual_scaling, Event, FACTOR='2' ;scaling_step2_step3
  END
  
  ;SF manual cw_field ---------------------------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step4_2_3_sf_text_field'): BEGIN
    step4_2_3_manual_scaling, Event, FACTOR='manual' ;scaling_step2_step3
  END
  
  ;----------------------------------------------------------------------------
  ;- RECAP - RECAP - RECAP - RECAP - RECAP - RECAP - RECAP - RECAP - RECAP -
  ;----------------------------------------------------------------------------
  
  ;lin/log --------------------------------------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='z_axis_linear_log_step5'): BEGIN
    refresh_recap_plot, Event ;_step5
  END
  
  ;zmax widget_text
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step5_zmax'): BEGIN
    input_error = 0
    CATCH, input_error
    IF (input_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      (*global).zmax_g_recap = (*global).zmax_g_recap_backup
      (*global).zmin_g_recap = (*global).zmin_g_recap_backup
      IF ((*global).debugging EQ 'yes') THEN BEGIN
        PRINT, 'Catch statement of step5_zmax'
        PRINT, ' zmax_g: ' + STRCOMPRESS((*global).zmax_g)
        PRINT, ' zmin_g: ' + STRCOMPRESS((*global).zmin_g)
      ENDIF
      double_error = 0
      CATCH, double_error
      IF (double_error NE 0) THEN BEGIN
        CATCH,/CANCEL
        refresh_recap_plot, Event
      ENDIF ELSE BEGIN
        refresh_recap_plot, Event, RESCALE=1
      ENDELSE
    ENDIF ELSE BEGIN
      populate_step5_range_widgets, Event
      refresh_recap_plot, Event, RESCALE=1
    ENDELSE
    (*global).zmax_g_recap_backup = (*global).zmax_g_recap
    (*global).zmin_g_recap_backup = (*global).zmin_g_recap
  END
  
  ;zmin widget_text
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step5_zmin'): BEGIN
    input_error = 0
    CATCH, input_error
    IF (input_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      (*global).zmax_g_recap = (*global).zmax_g_recap_backup
      (*global).zmin_g_recap = (*global).zmin_g_recap_backup
      IF ((*global).debugging EQ 'yes') THEN BEGIN
        PRINT, 'Catch statement of step4_zmax'
        PRINT, ' zmax_g: ' + STRCOMPRESS((*global).zmax_g_recap)
        PRINT, ' zmin_g: ' + STRCOMPRESS((*global).zmin_g_recap)
      ENDIF
      double_error = 0
      CATCH, double_error
      IF (double_error NE 0) THEN BEGIN
        CATCH,/CANCEL
        refresh_recap_plot, Event
      ENDIF  ELSE BEGIN
        refresh_recap_plot, Event, RESCALE=1
      ENDELSE
    ENDIF ELSE BEGIN
      populate_step5_range_widgets, Event
      refresh_recap_plot, Event, RESCALE=1
    ENDELSE
    (*global).zmax_g_recap_backup = (*global).zmax_g_recap
    (*global).zmin_g_recap_backup = (*global).zmin_g_recap
  END
  
  ;Reset zmin and zmax
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step5_z_reset'): BEGIN
    refresh_recap_plot, Event
    (*global).zmax_g_recap_backup = (*global).zmax_g_recap
    (*global).zmin_g_recap_backup = (*global).zmin_g_recap
  END
  
  WIDGET_INFO(wWidget, FIND_BY_UNAME='scaling_main_tab'): BEGIN
    scaling_tab_event, Event ;_eventcb
  END
  
  ;type of selection (none, i vs Q, ...) --------------------------------------
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step5_selection_group_uname'): BEGIN
    selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
    CASE (selection_value) OF
      0: IvsQbaseMap = 0
      1: IvsQbaseMap = 1
      2: IvsQbaseMap = 1
      ELSE: IvsQbaseMap = 0
    ENDCASE
    MapBase, Event, 'step5_counts_vs_q_base_uname', IvsQbaseMap
  END
  
  ;path button
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step5_browse_button_i_vs_q'): BEGIN
    step5_browse_path_button, Event ;_step5
  END
  
  ;name of file (text field)
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step5_file_name_i_vs_q'): BEGIN
    text = getTextFieldValue(Event,'step5_file_name_i_vs_q')
    IF (text NE '') THEN BEGIN
      go_button_sensitive = 1
    ENDIF ELSE BEGIN
      go_button_sensitive = 0
    ENDELSE
    activate_widget, Event, $
      'step5_create_button_i_vs_q', $
      go_button_sensitive
    ;check if preview button can be validated or not
    update_step5_preview_button, Event ;step5
  END
  
  ;create ascii file button
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step5_create_button_i_vs_q'): BEGIN
    produce_i_vs_q_output_file, Event
  END
  
  ;preview button
  WIDGET_INFO(wWidget, FIND_BY_UNAME='preview_button_i_vs_q'): BEGIN
    step5_preview_button, Event ;step5
  END
  
  ;----------------------------------------------------------------------------
  ;draw
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step5_draw'): BEGIN
    DEVICE, CURSOR_STANDARD=31
    LoadBaseStatus  = isBaseMapped(Event,'shifting_base_step5')
    ScaleBaseStatus = isBaseMapped(Event,'scaling_base_step5')
    IF (LoadBaseStatus + ScaleBaseStatus EQ 0) THEN BEGIN
      delta_x = (*global).delta_x
      x = Event.x
      x1 = FLOAT(delta_x) * FLOAT(x)
      Xtext = 'X: ' + STRCOMPRESS(x1,/REMOVE_ALL)
      putTextFieldValue, Event, 'x_value_step5', Xtext
      
      y = Event.y
      y1 = y / 2
      Ytext = 'Y: ' + STRCOMPRESS(y1,/REMOVE_ALL)
      putTextFieldValue, Event, 'y_value_step5', Ytext
      
      ;     print, 'x: ' + strcompress(x) + ' | y: ' + strcompress(y)
      
      total_array = (*(*global).total_array_untouched)
      size_x = (SIZE(total_array,/DIMENSION))[0]
      size_y = (SIZE(total_array,/DIMENSION))[1]
      IF (x LT size_x AND $
        y1   LT size_y AND $
        x GE 0 AND $
        y GE 0) THEN BEGIN
        counts = total_array(x,y1)
        sIntensity = STRING(counts,FORMAT='(e8.1)')
        intensity = STRCOMPRESS(sIntensity,/REMOVE_ALL)
      ENDIF ELSE BEGIN
        intensity = 'N/A'
      ENDELSE
      CountsText = 'Counts: ' + STRCOMPRESS(intensity,/REMOVE_ALL)
      putTextFieldValue, Event, 'counts_value_step5', CountsText
      
      selection_value = $
        getCWBgroupValue(Event,'step5_selection_group_uname')
        
      IF (selection_value NE 0) THEN BEGIN
      
        IF (event.press EQ 1) THEN BEGIN ;press left
          (*global).left_mouse_pressed = 1
          (*global).step5_x0 = Event.x
          (*global).step5_y0 = Event.y
        ENDIF
        
        IF (event.type EQ 2 AND $ ;move mouse with left pressed
          (*global).left_mouse_pressed EQ 1) THEN BEGIN
          CASE (selection_value) OF
            1: plot_step5_i_vs_Q_selection, Event ;_step5
            2: plot_step5_i_vs_Q_selection, Event ;_step5
            ELSE:
          ENDCASE
        ENDIF
        
        IF (event.type EQ 1) THEN BEGIN ;release mouse
          (*global).left_mouse_pressed = 0
          (*global).step5_x1 = Event.x
          (*global).step5_y1 = Event.y
          inform_log_book_step5_selection, Event ;_step5
          enabled_or_not_recap_rescale_button, Event
          MapBase, Event, 'step5_rescale_base', 1
          display_step5_rescale_plot_first_time, Event
          define_default_recap_output_file, Event
        ENDIF
        
      ENDIF ;end of 'if (selection_value NE 0)'
      
    ENDIF
    
  END
  
  ;============================================================================
  ;Rescale base
  ;============================================================================
  
  ;Return to rescale plot button
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step5_rescale_go_back_button'): BEGIN
    MapBase, Event, 'step5_rescale_base', 0
    ;refresh plot if necessary
    (*global).PrevTabSelect = 0 ;to force the refresh of the tab
    tab_event, Event
    (*global).first_recap_rescale_plot = 1
    (*global).x0y0x1y1 = [0.,0.,0.,0.]
    (*global).x0y0x1y1_graph = [0.,0.,0.,0.]
    (*global).recap_rescale_selection_left = 0.
    (*global).recap_rescale_selection_right = 0.
  END
  
  ;reset zoom
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step5_rescale_full_reset'): BEGIN
    display_step5_rescale_reset_zoom, Event
    (*global).first_recap_rescale_plot = 1
    plot_recap_rescale_other_selection, Event, type='all'
    replot_average_recap_rescale, Event
  END
  
  ;lin/log cw_bgroup
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step5_rescale_lin_log_plot'): BEGIN
    redisplay_step5_rescale_plot, Event
    plot_recap_rescale_other_selection, Event, type='all'
    replot_average_recap_rescale, Event
  END
  
  ;rescale widget draw
  WIDGET_INFO(wWidget, FIND_BY_UNAME='step5_rescale_draw'): BEGIN
    DEVICE, CURSOR_STANDARD=31
    ;zoom or selection
    isZoomSelected = isRecapScaleZoomSelected(Event)
    IF (isZoomSelected) THEN BEGIN ;using zoom
    
      IF (event.press EQ 1) THEN BEGIN ;press left
        (*global).recap_rescale_x0 = Event.x
        (*global).recap_rescale_y0 = Event.y
        CURSOR, x,y,/data,/nowait
        x0y0x1y1 = (*global).x0y0x1y1
        
        x0y0x1y1_graph = (*global).x0y0x1y1_graph
        x0_graph = x0y0x1y1_graph[0]
        y0_graph = x0y0x1y1_graph[1]
        x1_graph = x0y0x1y1_graph[2]
        y1_graph = x0y0x1y1_graph[3]
        
        IF (x LT x0y0x1y1_graph[0]) THEN x=x0y0x1y1_graph[0]
        IF (x GT x0y0x1y1_graph[2]) THEN x=x0y0x1y1_graph[2]
        IF (y LT x0y0x1y1_graph[1]) THEN y=x0y0x1y1_graph[1]
        IF (y GT x0y0x1y1_graph[3]) THEN y=x0y0x1y1_graph[3]
        
        x0y0x1y1[0] = x
        x0y0x1y1[1] = y
        
        (*global).x0y0x1y1 = x0y0x1y1
        (*global).recap_rescale_left_mouse = 1
        
        plot_recap_rescale_other_selection, Event, type='all'
        
      ENDIF
      
      IF (event.type EQ 2 AND $ ;move mouse with left pressed
        (*global).recap_rescale_left_mouse EQ 1) THEN BEGIN
        
        ;make sure the event.x stays within 5 and 1267
        ;make sure the event.y stays within 5 and 696
        IF (Event.x GT 5 AND $
          Event.x LT 1267 AND $
          Event.y GT 5 AND $
          Event.y LT 696) THEN BEGIN
          
          CURSOR, x,y, /DATA, /NOWAIT
          (*global).last_valid_x = x
          (*global).last_valid_y = y
          
          ;replot main plot
          display_step5_rescale_plot_from_zoom, Event, with_range=1
          
          ;display_step5_rescale_after_rescale_during_zoom_selection, Event
          ;plot selection
          (*global).recap_rescale_x1 = Event.x
          (*global).recap_rescale_y1 = Event.y
          plot_recap_rescale_selection, Event
          
          plot_recap_rescale_other_selection, Event, type='all'
          
        ENDIF
        
      ENDIF
      
      IF (event.release EQ 1) THEN BEGIN ;release mouse
      
        ;make sure the event.x stays within 5 and 1267
        ;make sure the event.y stays within 5 and 696
        IF (Event.x GT 5 AND $
          Event.x LT 1267 AND $
          Event.y GT 5 AND $
          Event.y LT 696) THEN BEGIN
          
          CURSOR,x,y,/data,/nowait
          
        ENDIF ELSE BEGIN
        
          x = (*global).last_valid_x
          y = (*global).last_valid_y
          
        ENDELSE
        
        (*global).recap_rescale_left_mouse = 0
        x0y0x1y1 = (*global).x0y0x1y1
        
        x0y0x1y1_graph = (*global).x0y0x1y1_graph
        x0_graph = x0y0x1y1_graph[0]
        y0_graph = x0y0x1y1_graph[1]
        x1_graph = x0y0x1y1_graph[2]
        y1_graph = x0y0x1y1_graph[3]
        xmin = MIN([x0_graph,x1_graph],MAX=xmax)
        ymin = MIN([y0_graph,y1_graph],MAX=ymax)
        
        IF (x LT 0) THEN x = xmax
        IF (y LT 0) THEN y = ymax
        
        x0y0x1y1[2] = x
        x0y0x1y1[3] = y
        (*global).x0y0x1y1 = x0y0x1y1
        (*global).x0y0x1y1_graph = x0y0x1y1
        
        redisplay_step5_rescale_plot, Event
        (*global).first_recap_rescale_plot = 0
        
        plot_selection_after_zoom, Event
      ENDIF
      
      replot_average_recap_rescale, Event
      
    ENDIF ELSE BEGIN ;selection selected
    
      IF (event.press EQ 1) THEN BEGIN ;press left
        IF ((*global).first_recap_rescale_plot) THEN BEGIN
          display_step5_rescale_plot, Event, with_range=1
        ENDIF ELSE BEGIN
          redisplay_step5_rescale_plot, Event
        ENDELSE
        plot_recap_rescale_CE_selection, Event
        (*global).recap_rescale_left_mouse = 1
        
        IF ((*global).recap_rescale_working_with EQ 'left') THEN BEGIN
          ;replot right line
          plot_recap_rescale_other_selection, Event, type='right'
        ENDIF ELSE BEGIN
          ;replot left line
          plot_recap_rescale_other_selection, Event, type='left'
        ENDELSE
      ENDIF
      
      IF (event.press EQ 4) THEN BEGIN ;press right
        IF ((*global).recap_rescale_working_with EQ 'left') THEN BEGIN
          (*global).recap_rescale_working_with = 'right'
        ENDIF ELSE BEGIN
          (*global).recap_rescale_working_with = 'left'
        ENDELSE
      ENDIF
      
      IF (event.type EQ 2 AND $ ;move mouse with left pressed
        (*global).recap_rescale_left_mouse EQ 1) THEN BEGIN
        ;replot main plot
        IF ((*global).first_recap_rescale_plot) THEN BEGIN
          display_step5_rescale_plot, Event, with_range=1
        ENDIF ELSE BEGIN
          redisplay_step5_rescale_plot, Event
        ENDELSE
        ;plot selection
        plot_recap_rescale_CE_selection, Event
        
        IF ((*global).recap_rescale_working_with EQ 'left') THEN BEGIN
          ;replot right line
          plot_recap_rescale_other_selection, Event, type='right'
        ENDIF ELSE BEGIN
          ;replot left line
          plot_recap_rescale_other_selection, Event, type='left'
        ENDELSE
      ENDIF
      
      IF (event.type EQ 1) THEN BEGIN ;release mouse
        CURSOR, x, y, /DATA, /NOWAIT
        IF ((*global).recap_rescale_working_with EQ 'left') THEN BEGIN
          (*global).recap_rescale_selection_left = x
        ENDIF ELSE BEGIN
          (*global).recap_rescale_selection_right = x
        ENDELSE
        ;check if we can enabled rescale button
        IF ((*global).recap_rescale_left_mouse) THEN BEGIN
          enabled_or_not_recap_rescale_button, Event
          plot_average_recap_rescale, Event
        ENDIF
        (*global).recap_rescale_left_mouse = 0
      ENDIF
      
    ENDELSE
    
  END
  
  ;scale to 1 selection
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step5_rescale_scale_to_1'): BEGIN
    ;(*global).first_recap_rescale_plot = 0
    calculate_average_recap_rescale, Event
    redisplay_step5_rescale_plot_after_scaling, Event
    plot_recap_rescale_other_selection, Event, type='all'
    plot_average_1_recap_rescale, Event ;plot the average horizontal value
    ;enabled the RESET SCALE button
    activate_widget, Event, 'step5_rescale_scale_to_1_reset', 1
  END
  
  ;reset scale button
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step5_rescale_scale_to_1_reset'): BEGIN
    display_step5_rescale_plot_first_time, Event
    activate_widget, Event, 'step5_rescale_scale_to_1_reset', 0
    (*global).recap_rescale_selection_left = 0
    (*global).recap_rescale_selection_right = 0
    (*global).recap_rescale_average = 0.0
  END
  
  ;----------------------------------------------------------------------------
  ;- CREATE OUTPUT - CREATE OUTPUT - CREATE OUTPUT - CREATE OUTPUT - CREATE....
  ;----------------------------------------------------------------------------
  
  ;output file path button
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='create_output_file_path_button'): BEGIN
    OutputFilePathButton, Event ;step5
  END
  
  ;File Name text field
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='create_output_file_name_text_field'): BEGIN
    RefreshOutputFileName, Event ;step5
  END
  
  ;Create output file button
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='create_output_file_create_button'): BEGIN
    create_output_file, Event ;step6
  END
  
  ;get preview of working pola state
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step6_preview_pola_state1'): BEGIN
    preview_OF_step6_file, Event, POLA_STATE='p0' ;step6
  END
  
  ;exclude polar #2
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='exclude_polarization_state2'): BEGIN
    value = getButtonStatus(Event,'exclude_polarization_state2')
    IF (value) THEN BEGIN ;exclude base
      sensitive = 0
    ENDIF ELSE BEGIN
      sensitive = 1
    ENDELSE
    activate_widget, Event, 'polarization_state2_summary_base', sensitive
    activate_widget, Event, 'polarization_state2_summary_base_title', sensitive
    activate_widget, Event, 'i_vs_q_output_file_spin_state2_base', sensitive
  END
  
  ;get preview of pola #2
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step6_preview_pola_state2'): BEGIN
    preview_OF_step6_file, Event, POLA_STATE='p1' ;step6
  END
  
  ;exclude polar #3
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='exclude_polarization_state3'): BEGIN
    value = getButtonStatus(Event,'exclude_polarization_state3')
    IF (value) THEN BEGIN ;exclude base
      sensitive = 0
    ENDIF ELSE BEGIN
      sensitive = 1
    ENDELSE
    activate_widget, Event, 'polarization_state3_summary_base', sensitive
    activate_widget, Event, 'polarization_state3_summary_base_title', sensitive
    activate_widget, Event, 'i_vs_q_output_file_spin_state3_base', sensitive
  END
  
  ;get preview of pola #3
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step6_preview_pola_state3'): BEGIN
    preview_OF_step6_file, Event, POLA_STATE='p2' ;step6
  END
  
  ;exclude polar #4
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='exclude_polarization_state4'): BEGIN
    value = getButtonStatus(Event,'exclude_polarization_state4')
    IF (value) THEN BEGIN ;exclude base
      sensitive = 0
    ENDIF ELSE BEGIN
      sensitive = 1
    ENDELSE
    activate_widget, Event, 'polarization_state4_summary_base', sensitive
    activate_widget, Event, 'polarization_state4_summary_base_title', sensitive
    activate_widget, Event, 'i_vs_q_output_file_spin_state4_base', sensitive
  END
  
  ;get preview of pola #4
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME='step6_preview_pola_state4'): BEGIN
    preview_OF_step6_file, Event, POLA_STATE='p3' ;step6
  END
  
  ;List of I vs Q or TOF files ------------------------------------------------
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME = 'i_vs_q_output_file_working_spin_state'): BEGIN
    uname = 'i_vs_q_output_file_working_spin_state'
    check_preview_button_of_i_vs_q_tab6, Event, uname
  END
  
  ;preview button of working spin state
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME = 'i_vs_q_output_file_working_spin_state_preview'): BEGIN
    preview_file, Event, text_uname = 'i_vs_q_output_file_working_spin_state'
  END
  
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME = 'i_vs_q_output_file_spin_state2'): BEGIN
    uname = 'i_vs_q_output_file_spin_state2'
    check_preview_button_of_i_vs_q_tab6, Event, uname
  END
  
  ;preview button of spin state 2
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME = 'i_vs_q_output_file_spin_state2_preview'): BEGIN
    preview_file, Event, text_uname = 'i_vs_q_output_file_spin_state2'
  END
  
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME = 'i_vs_q_output_file_spin_state3'): BEGIN
    uname = 'i_vs_q_output_file_spin_state3'
    check_preview_button_of_i_vs_q_tab6, Event, uname
  END
  
  ;preview button of spin state 3
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME = 'i_vs_q_output_file_spin_state3_preview'): BEGIN
    preview_file, Event, text_uname = 'i_vs_q_output_file_spin_state3'
  END
  
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME = 'i_vs_q_output_file_spin_state4'): BEGIN
    uname = 'i_vs_q_output_file_spin_state4'
    check_preview_button_of_i_vs_q_tab6, Event, uname
  END
  
  ;preview button of spin state 4
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME = 'i_vs_q_output_file_spin_state4_preview'): BEGIN
    preview_file, Event, text_uname = 'i_vs_q_output_file_spin_state4'
  END
  
  ;----------------------------------------------------------------------------
  ;- OPTIONS - OPTIONS - OPTIONS - OPTIONS - OPTIONS - OPTIONS - OPTIONS ------
  
  ;cw_bgroup of 'Use non active file attenuator'
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME= $
    'transparency_attenuator_shifting_options'): BEGIN
    index = getCWBgroupValue(Event, $
      'transparency_attenuator_' + $
      'shifting_options')
    IF (index EQ 0) THEN BEGIN
      status = 0
    ENDIF ELSE BEGIN
      status = 1
    ENDELSE
    activate_widget, Event, 'transparency_coeff_base', status
  END
  
  ;cw_bgroup of 'Fast Reference Pixel Selection Mode'
  WIDGET_INFO(wWidget, $
    FIND_BY_UNAME= $
    'fast_selection_pixel_selection_mode'): BEGIN
    index = getCWBgroupValue(Event, $
      'fast_selection_pixel_selection_mode')
    IF (index EQ 0) THEN BEGIN
      value = '-> Next file becomes active once the reference' + $
        ' pixel is done.'
    ENDIF ELSE BEGIN
      value = '-> User is in charge of changing ' + $
        'the active file.'
    ENDELSE
    putTextFieldValue, Event, $
      'fast_active_file_options_label',$
      value
  END
  
  
  ;----------------------------------------------------------------------------
  ;- LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK - LOG BOOK
  WIDGET_INFO(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
    SendToGeek, Event ;_IDLsendToGeek
  END
  
  ELSE:
  
ENDCASE

END
