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
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL, id, GET_UVALUE=global
  
  wWidget = Event.top            ;widget id
  
  IF ((*global).data_nexus_file_name NE '') THEN BEGIN
    bAdvancedToolId = WIDGET_INFO((*global).advancedToolId, /VALID_ID)
    IF (bAdvancedToolId) THEN BEGIN
      status = 0
    ENDIF ELSE BEGIN
      status = 1
    ENDELSE
    uname_list = ['clear_selection_button',$
      'exclusion_base',$
      'clear_selection_button']
    activate_widget_list, Event, uname_list, status
  ENDIF
  
  CASE Event.id OF
  
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
          ;facility Selection
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='facility_selection_validate_button'): begin
      facility_selected, Event, (*global).scroll
    end
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='main_tab'): BEGIN
      tab_event, Event ;_eventcb
    END
    
    ;= TAB1 (LOAD DATA) =======================================================
    
    ;- MODE GROUP selection (transmission or background )----------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='mode_group_uname'): BEGIN
      RenewOutputFileName, Event
      ModeGuiUpdate, Event    ;_gui
    END
    
    ;- Main Plot --------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='draw_uname'): BEGIN
      IF ((*global).data_nexus_file_name NE '') THEN BEGIN
        getXYposition, Event ;_get
        IF ((*global).Xpixel  EQ 80L) THEN BEGIN
          putCountsValue, Event, Event.x/8., Event.y/8. ;_put
        ENDIF ELSE BEGIN
          putCountsValue, Event, Event.x/2., Event.y/2. ;_put
        ENDELSE
        ;check if user wants circle or rectangle
        id = WIDGET_INFO(wWidget, FIND_BY_UNAME='circle_in_out_button')
        IF (WIDGET_INFO(id, /BUTTON_SET) EQ 1) THEN BEGIN ;circle
          IF (Event.press EQ 1) THEN BEGIN
            IF ((*global).Xpixel  EQ 80L) THEN BEGIN
              X = Event.x/8.
              Y = Event.y/8.
            ENDIF ELSE BEGIN
              X = Event.x/2.
              Y = Event.y/2.
            ENDELSE
            putTextFieldValue, Event, $
              'x_center_value', $
              STRCOMPRESS(X)
            putTextFieldValue, Event, $
              'y_center_value', $
              STRCOMPRESS(Y)
          ENDIF
        ENDIF ELSE BEGIN    ;rectangle
          IF ((*global).data_nexus_file_name NE '') THEN BEGIN
            select_rectangle, Event ;_exclusion
          ENDIF
        ENDELSE
      ENDIF
    END
    
    ;-Linear of Logarithmic scale
    WIDGET_INFO(wWidget, FIND_BY_UNAME='z_axis_scale'): BEGIN
      lin_or_log_plot, Event
    END
    
    ;--------------------------------------------------------------------------
    ;- Range of TOF displayed -------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tof_range_cwbgroup'): BEGIN
      value = getCWBgroupValue(Event,'tof_range_cwbgroup')
      activate_widget, Event, 'tof_manual_base', value
    END
    
    ;- Tof min and max user defined cw_bgroup
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tof_range_min_cw_field'): BEGIN
      checkTofRange, Event    ;gui
      refresh_plot, Event     ;_plot
      RefreshRoiExclusionPlot, Event ;_selection
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tof_range_max_cw_field'): BEGIN
      checkTofRange, Event    ;gui
      refresh_plot, Event     ;_plot
      RefreshRoiExclusionPlot, Event   ;_selection
    END
    
    ;- Play button ------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tof_play_button'): BEGIN
      ;      activate_play_base, Event
      play_tof, Event         ;_eventcb
    END
    
    ;-Advanced Button ---------------------------------------------------------
    ;previous button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='previous_button'): BEGIN
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          status_buttons = (*global).status_buttons
          IF (status_buttons[0] EQ 0 OR $
            status_buttons[0] EQ 1) THEN BEGIN
            display_buttons, EVENT=EVENT, ACTIVATE=1, global
            play_previous_tof, Event         ;_eventcb
          ENDIF ;end of status_buttons[0]
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
    
    ;play button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='play_button'): BEGIN
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          status_buttons = (*global).status_buttons
          IF (status_buttons[1] EQ 0) THEN BEGIN
            display_buttons, EVENT=EVENT, ACTIVATE=2, global
            play_tof, Event         ;_eventcb
          ENDIF ;end of status_buttons[1]
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
    
    ;pause button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='pause_button'): BEGIN
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        (*global).previous_button_clicked = 3
        IF (event.press EQ 1) THEN BEGIN
          status_buttons = (*global).status_buttons
          IF (status_buttons[2] EQ 0) THEN BEGIN
            display_buttons, EVENT=EVENT, ACTIVATE=3, global
            (*global).previous_button_clicked = 3
            
          ENDIF ;end of status_buttons[2]
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          standard = 58
        ENDIF ELSE BEGIN
          standard = 31
        ENDELSE
        DEVICE, CURSOR_STANDARD=standard
      ;        (*global).previous_button_clicked = 3
      ENDELSE
    END
    
    ;stop button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='stop_button'): BEGIN
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        (*global).previous_button_clicked = 4
        IF (event.press EQ 1) THEN BEGIN
          status_buttons = (*global).status_buttons
          IF (status_buttons[3] EQ 0) THEN BEGIN
            display_buttons, EVENT=EVENT, ACTIVATE=4, global
            refresh_plot, Event     ;_plot
            RefreshRoiExclusionPlot, Event   ;_selection
            (*global).previous_button_clicked = 4
          ENDIF ;end of status_buttons[3]
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          standard = 58
        ENDIF ELSE BEGIN
          standard = 31
        ENDELSE
        DEVICE, CURSOR_STANDARD=standard
        (*global).previous_button_clicked = 4
      ENDELSE
    END
    
    ;next button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='next_button'): BEGIN
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          status_buttons = (*global).status_buttons
          IF (status_buttons[4] EQ 0 OR $
            status_buttons[4] EQ 1) THEN BEGIN
            display_buttons, EVENT=EVENT, ACTIVATE=5, global
            play_next_tof, Event         ;_eventcb
          ENDIF ;end of status_buttons[4]
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
    
    ;--------------------------------------------------------------------------
    ;- TOF reset button -------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tof_reset_range'): BEGIN
      putTextFIeldValue, Event, 'tof_range_min_cw_field',$
        STRCOMPRESS((*global).tof_min,/REMOVE_ALL)
      putTextFIeldValue, Event, 'tof_range_max_cw_field',$
        STRCOMPRESS((*global).tof_max,/REMOVE_ALL)
      refresh_plot, Event     ;_plot
      RefreshRoiExclusionPlot, Event ;_selection
      putTextFieldValue, Event, 'bin_range_value', ''
      putTextfieldValue, Event, 'tof_range_value', ''
    END
    
    ;- Run Number cw_field ----------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='run_number_cw_field'): BEGIN
      load_run_number, Event  ;_eventcb
      CheckCommandLine, Event ;_command_line
    END
    
    ;- Browse Button ----------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='browse_nexus_button'): BEGIN
      browse_nexus, Event ;_eventcb
      CheckCommandLine, Event ;_command_line
    END
    
    ;- Selection Button -------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_tool_button'): BEGIN
      selection_tool, Event ;_eventcb
    END
    
    ;- Browse Selection File --------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_browse_button'): BEGIN
      browse_selection_file, Event ;_selection
      update_tof_counts_selection_button, Event ;_gui
    END
    
    ;- Preview Selection File -------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_preview_button'): BEGIN
      preview_selection_file, Event ;_selection
    END
    
    ;- Selection File Name Text Field -----------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_file_name_text_field'): BEGIN
      selection_text_field, Event ;_selection
    END
    
    ;- Selection Load Button --------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_load_button'): BEGIN
      LoadPlotSelection, Event ;_selection
    END
    
    ;-Exclusion Region Selection Tool -----------------------------------------
    ;- Preview button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='preview_exclusion_region'): BEGIN
      PreviewExclusionRegionCircle, Event ;_exclusion
    END
    
    ;- Plot button (fast)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_fast_exclusion_region'): BEGIN
      FastExclusionRegionCircle, Event ;_exclusion
      update_tof_counts_selection_button, Event ;_gui
    END
    
    ;- Plot button (accurate)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_accurate_exclusion_region'): BEGIN
      AccurateExclusionRegionCircle, Event ;_exclusion
      update_tof_counts_selection_button, Event ;_gui
    END
    
    ;- Clear Input Boxed
    WIDGET_INFO(wWidget, FIND_BY_UNAME='clear_exclusion_input_boxes'): BEGIN
      ClearInputBoxes, Event ;_exclusion
    END
    
    ;- Rectangle or Circle selection ------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='circle_in_out_button'): BEGIN
      EnableCircleBase, Event ;_exclusion
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='rectangle_in_out_button'): BEGIN
      EnableRectangleBase, Event ;_exclusion
    END
    
    ;- Type of selection
    WIDGET_INFO(wWidget, FIND_BY_UNAME='exclusion_half_in'): BEGIN
      exclusion_type, Event, INDEX=0 ;_exclusion
    ;        ExclusionRegionCircle, Event ;_exclusion
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='exclusion_half_out'): BEGIN
      exclusion_type, Event, INDEX=1 ;_exclusion
    ;        ExclusionRegionCircle, Event ;_exclusion
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='exclusion_outside_in'): BEGIN
      exclusion_type, Event, INDEX=2 ;_exclusion
    ;        ExclusionRegionCircle, Event ;_exclusion
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='exclusion_outside_out'): BEGIN
      exclusion_type, Event, INDEX=3 ;_exclusion
    ;        ExclusionRegionCircle, Event ;_exclusion
    END
    
    ;- SAVE AS ...
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_as_roi_button'): BEGIN
      RenewOutputFileName, Event
      SaveAsExclusionRoi, Event ;_exclusion
      update_tof_counts_selection_button, Event ;_gui
    END
    
    ;- SAVE
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_roi_button'): BEGIN
      RenewOutputFileName, Event
      SaveExclusionFile, Event ;_exclusion
    ;update_tof_counts_selection_button, Event ;_gui
    END
    
    ;- SAVE AS folder button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_roi_folder_button'): BEGIN
      SaveExclusionRoiFolderButton, Event ;_exclusion
    END
    
    ;- ROI text field
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_roi_text_field'): BEGIN
      SaveRoiTextFieldInteraction, Event ;_exclusion
    END
    
    ;- Preview Roi button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='preview_roi_exclusion_file'): BEGIN
      PreviewRoiExclusionFile, Event ;_exclusion
    END
    
    ;-END of Exclusion Region Selection Tool ----------------------------------
    
    ;- Clear Selection Button -------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='clear_selection_button'): BEGIN
      clear_selection_tool, Event ;_selection
      CheckCommandLine, Event ;_command_line
    END
    
    ;- Refresh Plot -----------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='refresh_plot_button'): BEGIN
      refresh_plot, Event     ;_plot
      RefreshRoiExclusionPlot, Event   ;_selection
    END
    
    ;Linear/Log
    WIDGET_INFO(wWidget, FIND_BY_UNAME='z_axis_scale'): BEGIN
      refresh_plot, Event     ;_plot
      RefreshRoiExclusionPlot, Event   ;_selection
    END
    
    ;--------------------------------------------------------------------------
    ;- Counts vs TOF button of full detector ----------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='counts_vs_tof_full_detector_button'): $
      BEGIN
      launch_counts_vs_tof_full_detector_button, Event ;_tof
    END
    
    ;- Counts vs TOF button of selection --------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='counts_vs_tof_selection_button'): $
      BEGIN
      RenewOutputFileName, Event
      SaveExclusionFile, Event ;_exclusion
      launch_counts_vs_tof_selection_button, Event ;_tof
    END
    
    ;- Counts vs TOF button of monitor ----------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='counts_vs_tof_monitor_button'): $
      BEGIN
      launch_counts_vs_tof_monitor_button, Event ;_tof
    END
    
    ;= TAB2 (REDUCE) ==========================================================
    
    ;---- GO DATA REDUCTION button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='go_data_reduction_button'): BEGIN
      test_RunCommandLine, Event
    END
    
    ;==== tab2 ================================================================
    
    ;----Data File ------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_run_number_cw_field'): BEGIN
      LoadNeXus, Event, $
        'data_run_number_cw_field', $
        'data_file_name_text_field'
      RenewOutputFileName, Event
      CheckCommandLine, Event ;_command_line
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_file_name_text_field'): BEGIN
      RenewOutputFileName, Event
      CheckCommandLine, Event ;_command_line
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_browse_button'): BEGIN
      BrowseNexus, Event, $
        'data_browse_button',$
        'data_file_name_text_field'
      RenewOutputFileName, Event
      CheckCommandLine, Event ;_command_line
    END
    
    ;----ROI FIle -------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='roi_browse_button'): BEGIN
      BrowseNexus, Event, $
        'roi_browse_button',$
        'roi_file_name_text_field'
      RenewOutputFileName, Event
      CheckCommandLine, Event ;_command_line
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='roi_file_name_text_field'): BEGIN
      RenewOutputFileName, Event
      CheckCommandLine, Event  ;_command_line
    END
    
    ;----Transmission Background ----------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='transm_back_run_number_cw_field'): BEGIN
      LoadNeXus, Event, $
        'transm_back_run_number_cw_field',$
        'transm_back_file_name_text_field'
      RenewOutputFileName, Event
      CheckCommandLine, Event ;_command_line
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME=$
      'transm_back_file_name_text_field'): BEGIN
        RenewOutputFileName, Event
        CheckCommandLine, Event ;_command_line
      END
      
      WIDGET_INFO(wWidget, FIND_BY_UNAME='transm_back_browse_button'): BEGIN
        BrowseNexus, Event, $
          'transm_back_browse_button',$
          'transm_back_file_name_text_field'
        RenewOutputFileName, Event
        CheckCommandLine, Event ;_command_line
      END
      
      ;----Output folder ------------------------------------------------------
      WIDGET_INFO(wWidget,$
        FIND_BY_UNAME= $
        'output_folder'): BEGIN
        BrowseOutputFolder, Event ;_reduce_tab1
        RenewOutputFileName, Event
        CheckCommandLine, Event ;_command_line
      END
      
      ;Clear File Name text field button --------------------------------------
      WIDGET_INFO(wWidget, FIND_BY_UNAME='output_file_name'): BEGIN
        RenewOutputFileName, Event
        CheckCommandLine, Event ;_command_line
      END
      
      WIDGET_INFO(wWidget,$
        FIND_BY_UNAME= $
        'clear_output_file_name_button'): BEGIN
        clearOutputFileName, Event ;_reduce_tab1
        CheckCommandLine, Event  ;_command_line
      END
      
      ;Reset File Name --------------------------------------------------------
      WIDGET_INFO(wWidget,$
        FIND_BY_UNAME= $
        'reset_output_file_name_button'): BEGIN
        RenewOutputFileName, Event ;_gui
        CheckCommandLine, Event ;_command_line
      END
      
      ;Auto or Manual File Name
      WIDGET_INFO(wWidget,$
        FIND_BY_UNAME= $
        'auto_user_file_name_group'): BEGIN
        IF (getCWBgroupValue(Event, $
          'auto_user_file_name_group') EQ 0) THEN BEGIN
          auto_output_file_name = 1
        ENDIF ELSE BEGIN
          auto_output_file_name = 0
        ENDELSE
        (*global).auto_output_file_name = auto_output_file_name
        activate_widget, Event, $
          'reset_output_file_name_button', $
          auto_output_file_name
      END
      
      ;==== tab2 (PARAMETERS) =================================================
      
      WIDGET_INFO(wWidget, FIND_BY_UNAME='detector_efficiency_group'): BEGIN
        detector_efficiency_constant_gui, Event
        CheckCommandLine, Event
      END
      
      ;---- YES or NO geometry cw_bgroup --------------------------------------
      WIDGET_INFO(wWidget, FIND_BY_UNAME='overwrite_geometry_group'): BEGIN
        GeometryGroupInteraction, Event ;_reduce_tab2
        RenewOutputFileName, Event ;_gui
        CheckCommandLine, Event         ;_command_line
      END
      
      ;---- Browse button of the overwrite geometry button --------------------
      WIDGET_INFO(wWidget, FIND_BY_UNAME='overwrite_geometry_button'): BEGIN
        BrowseGeometry, Event ;_reduce_tab2
        RenewOutputFileName, Event ;_gui
        CheckCommandLine, Event ;_command_line
      END
      
      ;---- Time Zero Offset --------------------------------------------------
      WIDGET_INFO(wWidget, FIND_BY_UNAME='time_zero_offset_detector_uname'): $
        BEGIN
        RenewOutputFileName, Event ;_gui
        CheckCommandLine, Event ;_command_line
      END
      
      WIDGET_INFO(wWidget, FIND_BY_UNAME=$
        'time_zero_offset_beam_monitor_uname'): BEGIN
          RenewOutputFileName, Event ;_gui
          CheckCommandLine, Event ;_command_line
        END
        
        ;---- Monitor Efficiency ----------------------------------------------
        WIDGET_INFO(wWidget, FIND_BY_UNAME='monitor_efficiency_group'): BEGIN
          monitor_efficiency_constant_gui, Event  ;_reduce_tab2
          RenewOutputFileName, Event ;_gui
          CheckCommandLine, Event  ;_command_line
        END
        
        WIDGET_INFO(wWidget, FIND_BY_UNAME=$
          'monitor_efficiency_constant_value'): BEGIN
            RenewOutputFileName, Event ;_gui
            CheckCommandLine, Event ;_command_line
          END
          
          ;---- Wavelength Range ----------------------------------------------
          WIDGET_INFO(wWidget, FIND_BY_UNAME='wave_min_text_field'): BEGIN
            RenewOutputFileName, Event ;_gui
            CheckCommandLine, Event ;_command_line
          END
          
          WIDGET_INFO(wWidget, FIND_BY_UNAME='wave_max_text_field'): BEGIN
            RenewOutputFileName, Event ;_gui
            CheckCommandLine, Event ;_command_line
          END
          
          WIDGET_INFO(wWidget, FIND_BY_UNAME='wave_width_text_field'): BEGIN
            RenewOutputFileName, Event ;_gui
            CheckCommandLine, Event ;_command_line
          END
          
          WIDGET_INFO(wWidget, FIND_BY_UNAME='wave_scale_group'): BEGIN
            RenewOutputFileName, Event ;_gui
            CheckCommandLine, Event ;_command_line
          END
          
          ;---- ADT -----------------------------------------------------------
          WIDGET_INFO(wWidget, FIND_BY_UNAME= $
            'accelerator_down_time_text_field'): BEGIN
            RenewOutputFileName, Event ;_gui
            CheckCommandLine, Event ;_command_line
          END
          
          ;---- Verbose Mode --------------------------------------------------
          WIDGET_INFO(wWidget, FIND_BY_UNAME='verbose_mode_group'): BEGIN
            RenewOutputFileName, Event ;_gui
            CheckCommandLine, Event ;_command_line
          END
          
          ;---- min Lambda Cut off --------------------------------------------
          WIDGET_INFO(wWidget, FIND_BY_UNAME='minimum_lambda_cut_off_group'): BEGIN
            min_lambda_cut_off_gui, Event ;_reduce_tab2
            RenewOutputFileName, Event ;_gui
            CheckCommandLine, Event ;_command_line
          END
          
          WIDGET_INFO(wWidget, FIND_BY_UNAME='minimum_lambda_cut_off_value'): BEGIN
            RenewOutputFileName, Event ;_gui
            CheckCommandLine, Event ;_command_line
          END
          
          ;---- max Lambda Cut off --------------------------------------------
          WIDGET_INFO(wWidget, FIND_BY_UNAME='maximum_lambda_cut_off_group'): BEGIN
            max_lambda_cut_off_gui, Event ;_reduce_tab2
            RenewOutputFileName, Event ;_gui
            CheckCommandLine, Event ;_command_line
          END
          
          WIDGET_INFO(wWidget, FIND_BY_UNAME='maximum_lambda_cut_off_value'): BEGIN
            RenewOutputFileName, Event ;_gui
            CheckCommandLine, Event ;_command_line
          END
          
          ;==== tab2 (INTERMEDIATE FILE) ======================================
          WIDGET_INFO(wWidget, FIND_BY_UNAME='intermediate_group_uname'): BEGIN
            RenewOutputFileName, Event ;_gui
            CheckCommandLine, Event ;_command_line
          END
          
          ;= TAB3 (FITTING) ===================================================
          
          ;----- Refresh Plot -------------------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='refresh_fitting_button'): BEGIN
            ManualFitting, Event     ;_fitting
          END
          
          ;---- Browse Input Ascii file button --------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='input_file_browse_button'): BEGIN
            BrowseInputAsciiFile, Event ;_fitting
            UpdateFittingGui_preview, Event ;_fittign
          END
          
          ;---- Input Ascii text field ----------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='input_file_text_field'): BEGIN
            AsciiInputTextField, Event ;_fitting
            UpdateFittingGui_preview, Event ;_fitting
          END
          
          ;---- Input Ascii text field ----------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='input_file_load_button'): BEGIN
            LoadAsciiFile, Event ;_fitting
            UpdateFittingGui_preview, Event ;_fitting
          END
          
          ;---- Previw Ascii text file ----------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='input_file_preview_button'): BEGIN
            PreviewAsciiFile, Event ;_fitting
          END
          
          ;---- degree of the fitting group -----------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='fitting_polynomial_degree_cw_group'): BEGIN
            ChangeDegreeOfPolynome, Event ;_fitting
            redefinedOutputFileNameOnly, Event ;_fitting
          END
          
          ;---- Launch the Automatic Fitting ----------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='auto_fitting_button'): BEGIN
            AutoFit, Event ;_fitting
            UpdateFittingGui_save, Event ;_fitting
          END
          
          ;---- Show settings base --------------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='settings_button'): BEGIN
            map_base, Event, 'settings_base', 1
          END
          
          ;---- Show error bars group -----------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='plot_error_bars_group'): BEGIN
            ManualFitting, Event     ;replot ascii and fitting
          END
          
          ;---- Hide/close settings base --------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='close_fitting_settings_button'): BEGIN
            map_base, Event, 'settings_base', 0
          END
          
          ;---- Launch the Manual Fitting -------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='manual_fitting_button'): BEGIN
            ManualFitting, Event ;_fitting
            UpdateFittingGui_save, Event ;_fitting
          END
          
          ;---- Alternate Wavelength Axis -------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='alternate_wavelength_axis_cw_group'): BEGIN
            ChangeAlternateAxisOption, Event ;_fitting
            UpdateFittingGui_save, Event
          END
          
          ;---- Wave min ------------------------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='alternate_wave_min_text_field'): BEGIN
            UpdateFittingGui_save, Event
          END
          
          ;---- Wave max ------------------------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='alternate_wave_max_text_field'): BEGIN
            UpdateFittingGui_save, Event
          END
          
          ;---- Wave width ----------------------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='alternate_wave_width_text_field'): BEGIN
            UpdateFittingGui_save, Event
          END
          
          ;---- Wave Axis Preview ---------------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='wavelength_axis_preview_button'): BEGIN
            WaveUserDefinedAxisPreview, Event
          END
          
          ;---- CREATE FILE BUTTON --------------------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='output_file_save_button'): BEGIN
            OutputFileSave, Event ;_fitting
          END
          
          ;---- PREVIEW/EDIT/CREATE FILE BUTTON -------------------------------
          WIDGET_INFO(wWidget, $
            FIND_BY_UNAME='output_file_edit_save_button'): BEGIN
            OutputFileEditSave, Event ;_fitting
          END
          
          ;= TAB4 (LOG BOOK) ==================================================
          WIDGET_INFO(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
            SendToGeek, Event       ;_IDLsendToGeek
          END
          
          ELSE:
          
        ENDCASE
        
        
        
      END
