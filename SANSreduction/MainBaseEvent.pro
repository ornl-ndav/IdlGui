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
  
    ;facility Selection
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='facility_selection_validate_button'): begin
      facility_selected, Event, (*global).scroll
    end
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='main_tab'): BEGIN
      tab_event, Event ;_eventcb
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='help_button'): BEGIN
      start_help, Event ;_eventcb
    END
    
    ;= TAB1 (LOAD DATA) =======================================================
    
    ;- Main Plot --------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='draw_uname'): BEGIN
      id = WIDGET_INFO(Event.top,find_by_uname='draw_uname')
      WIDGET_CONTROL, id, GET_VALUE=id_value
      WSET, id_value
      standard = 31
      DEVICE, CURSOR_STANDARD=standard
      IF ((*global).data_nexus_file_name NE '') THEN BEGIN
        getXYposition, Event ;_get
        IF ((*global).facility EQ 'LENS') THEN BEGIN
          IF ((*global).Xpixel  EQ 80L) THEN BEGIN
            putCountsValue, Event, Event.x/8., Event.y/8. ;_put
          ENDIF ELSE BEGIN
            putCountsValue, Event, Event.x/2., Event.y/2. ;_put
          ENDELSE
        ENDIF ELSE BEGIN
          CATCH, error
          IF (error NE 0) THEN BEGIN
            CATCH,/CANCEL
            RETURN
          ENDIF
          ;check if both panels are plotted
          id = WIDGET_INFO(Event.top,FIND_BY_UNAME='show_both_banks_button')
          value = WIDGET_INFO(id, /BUTTON_SET)
          coeff = 2
          IF (value EQ 1) THEN coeff = 1
          putCountsValue, Event, $
            Event.x/(coeff * (*global).congrid_x_coeff),$
            Event.y/(*global).congrid_y_coeff
        ENDELSE
      ENDIF
      IF (Event.press EQ 1) THEN BEGIN
        IF ((*global).facility EQ 'LENS') THEN BEGIN
          IF ((*global).Xpixel  EQ 80L) THEN BEGIN
            X = Event.x/8.
            Y = Event.y/8.
          ENDIF ELSE BEGIN
            X = Event.x/2.
            Y = Event.y/2.
          ENDELSE
        ENDIF ELSE BEGIN ;'SNS'
          (*global).left_button_clicked = 1
          
          ;check if both panels are plotted
          id = WIDGET_INFO(Event.top,FIND_BY_UNAME='show_both_banks_button')
          value = WIDGET_INFO(id, /BUTTON_SET)
          coeff = 2
          IF (value EQ 1) THEN coeff = 1
          X = Event.x / (coeff * (*global).congrid_x_coeff)
          Y = Event.y / (*global).congrid_y_coeff
          
          (*global).x0_device = Event.x
          (*global).y0_device = Event.y
          
        ENDELSE
        putTextFieldValue, Event, $
          'corner_pixel_xo', $
          STRCOMPRESS(X)
        putTextFieldValue, Event, $
          'corner_pixel_yo', $
          STRCOMPRESS(Y)
      ENDIF
      
      IF ((*global).facility EQ 'SNS') THEN BEGIN ;for SNS only
        ;display width and height
      
        IF (event.release EQ 1) THEN BEGIN ;left button release
          (*global).left_button_clicked = 0
        ENDIF
        
        IF (event.press EQ 0 AND $ ;moving mouse with left button clicked
          (*global).left_button_clicked EQ 1) THEN BEGIN
          
          x0 = getTextFieldValue(Event,'corner_pixel_xo')
          y0 = getTextFieldValue(Event,'corner_pixel_yo')
          ;check if both panels are plotted
          id = WIDGET_INFO(Event.top,FIND_BY_UNAME='show_both_banks_button')
          value = WIDGET_INFO(id, /BUTTON_SET)
          coeff = 2
          IF (value EQ 1) THEN coeff = 1
          x1 = Event.x / (coeff * (*global).congrid_x_coeff)
          y1 = Event.y / (*global).congrid_y_coeff
          
          width = x1 - x0
          height = y1 - y0
          
          putTextFieldValue, Event, 'corner_pixel_width', width
          putTextFieldValue, Event, 'corner_pixel_height', height
          
          lin_or_log_plot, Event ;refresh of main plot
          display_selection, Event, x1=Event.x, y1=Event.y
          
        ENDIF
        
      ENDIF
      
    END
    
    ;-Linear of Logarithmic scale
    WIDGET_INFO(wWidget, FIND_BY_UNAME='z_axis_scale'): BEGIN
      lin_or_log_plot, Event
      RefreshRoiExclusionPlot, Event   ;_plot
    END
    
    ;- Run Number cw_field ----------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='run_number_cw_field'): BEGIN
      load_run_number, Event     ;_eventcb
    END
    
    ;- Browse Button ----------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='browse_nexus_button'): BEGIN
      browse_nexus, Event ;_eventcb
    END
    
    ;- Selection Button -------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_tool_button'): BEGIN
      selection_tool, Event ;_eventcb
    END
    
    ;- Browse Selection File --------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_browse_button'): BEGIN
      browse_selection_file, Event ;_selection
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
    END
    
    ;- Plot button (accurate)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_accurate_exclusion_region'): BEGIN
      AccurateExclusionRegionCircle, Event ;_exclusion
    END
    
    ;- Clear Input Boxed
    WIDGET_INFO(wWidget, FIND_BY_UNAME='clear_exclusion_input_boxes'): BEGIN
      ClearInputBoxes, Event ;_exclusion
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
      SaveAsExclusionRoi, Event  ;_exclusion
    END
    
    ;- SAVE
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_roi_button'): BEGIN
      SaveExclusionFile, Event ;_exclusion
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
    END
    
    ;- Refresh Plot -----------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='refresh_plot_button'): BEGIN
      refresh_plot, Event ;_plot
      RefreshRoiExclusionPlot, Event   ;_plot
    END
    
    ;- Selection Color Button -------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_color_button'): BEGIN
      change_color_OF_selection, Event ;_selection
    END
    
    ;- Plot Color Button ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_color_button'): BEGIN
    END
    
    ;- Show front panels ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='show_front_bank_button'): BEGIN
      (*(*global).DataArray) = (*(*global).front_bank)
      refresh_plot, Event ;_plot
    ;RefreshRoiExclusionPlot, Event   ;_plot
    END
    
    ;- Show back panels ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='show_back_bank_button'): BEGIN
      (*(*global).DataArray) = (*(*global).back_bank)
      refresh_plot, Event ;_plot
    ;RefreshRoiExclusionPlot, Event   ;_plot
    END
    
    ;- Show front and back panels ---------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='show_both_banks_button'): BEGIN
      (*(*global).DataArray) = (*(*global).both_banks)
      refresh_plot, Event ;_plot
    ;RefreshRoiExclusionPlot, Event   ;_plot
    END
    
    ;= TAB2 (REDUCE) ==========================================================
    
    ;---- GO DATA REDUCTION button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='go_data_reduction_button'): BEGIN
      test_RunCommandLine, Event ;_run_commandline
    END
    
    ;==== tab1 (LOAD FILES (1)) ===============================================
    
    ;----Data File ------------------------------------------------------------
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
    
    ;----ROI FIle -------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='roi_browse_button'): BEGIN
      BrowseNexus, Event, $
        'roi_browse_button',$
        'roi_file_name_text_field'
    END
    
    ;----Solvant Buffer Only File ---------------------------------------------
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
    
    ;----Empty Can  -----------------------------------------------------------
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
    
    ;----Open Beam  -----------------------------------------------------------
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
    
    ;----Dark Current  --------------------------------------------------------
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
    
    ;----Sample Data File -----------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'sample_data_transmission_run_number_cw_field'): BEGIN
    ;       LoadNeXus, Event, $
    ;         'sample_data_transmission_run_number_cw_field', $
    ;         'sample_data_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'sample_data_transmission_browse_button'): BEGIN
      BrowseTxt, Event, $
        'sample_data_transmission_browse_button',$
        'sample_data_transmission_file_name_text_field'
    END
    
    ;----Empty Can Transmission -----------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'empty_can_transmission_run_number_cw_field'): BEGIN
    ;        LoadNeXus, Event, $
    ;          'empty_can_transmission_run_number_cw_field', $
    ;          'empty_can_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'empty_can_transmission_browse_button'): BEGIN
      BrowseTxt, Event, $
        'empty_can_transmission_browse_button',$
        'empty_can_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget,$
      FIND_BY_UNAME= $
      'output_folder'): BEGIN
      BrowseOutputFolder, Event ;_reduce_tab2
    END
    
    ;--- Solvent Transmission -------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'solvent_transmission_run_number_cw_field'): BEGIN
    ;        LoadNeXus, Event, $
    ;          'solvent_transmission_run_number_cw_field', $
    ;          'solvent_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'solvent_transmission_browse_button'): BEGIN
      BrowseTxt, Event, $
        'solvent_transmission_browse_button',$
        'solvent_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget,$
      FIND_BY_UNAME= $
      'output_folder'): BEGIN
      BrowseOutputFolder, Event ;_reduce_tab2
    END
    
    ;Clear File Name text field button ----------------------------------------
    WIDGET_INFO(wWidget,$
      FIND_BY_UNAME= $
      'clear_output_file_name_button'): BEGIN
      clearOutputFileName, Event ;_reduce_tab2
    END
    
    ;Reset File Name ----------------------------------------------------------
    WIDGET_INFO(wWidget,$
      FIND_BY_UNAME= $
      'reset_output_file_name_button'): BEGIN
      ResetOutputFileName, Event ;_reduce_tab2
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
    
    ;==== tab2 (PARAMETERS) ===================================================
    
    ;---- YES or NO geometry cw_bgroup ----------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='overwrite_geometry_group'): BEGIN
      GeometryGroupInteraction, Event ;_reduce_tab3
    END
    
    ;---- Browse button of the overwrite geometry button ----------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='overwrite_geometry_button'): BEGIN
      BrowseGeometry, Event ;_reduce_tab3
    END
    
    ;---- Monitor Efficiency --------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='monitor_efficiency_group'): BEGIN
      monitor_efficiency_constant_gui, Event ;_reduce_tab3
    END
    
    ;---- Detector Efficiency -------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='detector_efficiency_group'): BEGIN
      detector_efficiency_constant_gui, Event ;_reduce_tab3
    END
    
    ;---- Min Lambda Cut off --------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='minimum_lambda_cut_off_group'): BEGIN
      min_lambda_cut_off_gui, Event ;_reduce_tab3
    END
    
    ;---- Max Lambda Cut off --------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='maximum_lambda_cut_off_group'): BEGIN
      max_lambda_cut_off_gui, Event ;_reduce_tab3
    END
    
    ;---- Scaling Constant ----------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='scaling_constant_group'): BEGIN
      scaling_constant_gui, Event ;_reduce_tab3
    END
    
    ;---- Wavelength dependent background subtraction -------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='wave_help_button'): BEGIN
      id = WIDGET_INFO(wWidget, $
        FIND_BY_UNAME='wave_dependent_back_sub_text_field')
      id1 = WIDGET_INFO(wWidget, $
        FIND_BY_UNAME='wave_para_label_uname')
        
      IF (Event.select EQ 1) THEN BEGIN ;button pressed
        WIDGET_CONTROL, id, GET_VALUE = value
        (*global).wave_para_value = value
        WIDGET_CONTROL, id1, SET_VALUE = (*global).wave_para_help_label
        WIDGET_CONTROL, id, SET_VALUE = (*global).wave_para_help_value
      ENDIF ELSE BEGIN
        value = (*global).wave_para_value
        WIDGET_CONTROL, id1, SET_VALUE = (*global).wave_para_label
        WIDGET_CONTROL, id, SET_VALUE = value
      ENDELSE
      
      value = getTextFieldValue(Event,'wave_dependent_back_sub_text_field')
      IF (value EQ '') THEN BEGIN
        status = 0
      ENDIF ELSE BEGIN
        status = 1
      ENDELSE
      activate_widget, Event, 'acce_base', status
      
    END
    
    ;---- Browse button of Wavelength Dependent Back. subtraction -------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='wave_dependent_back_browse_button'): BEGIN
      BrowseLoadWaveFile, Event ;_reduce_tab3
      value = getTextFieldValue(Event,'wave_dependent_back_sub_text_field')
      IF (value EQ '') THEN BEGIN
        status = 0
      ENDIF ELSE BEGIN
        status = 1
      ENDELSE
      activate_widget, Event, 'acce_base', status
      
    END
    
    ;--- comma-delimited list of increasing coefficients ----------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='wave_dependent_back_sub_text_field'): BEGIN
      value = getTextFieldValue(Event,'wave_dependent_back_sub_text_field')
      IF (value EQ '') THEN BEGIN
        status = 0
      ENDIF ELSE BEGIN
        status = 1
      ENDELSE
      activate_widget, Event, 'acce_base', status
    END
    
    ;---- Clear Wavelength coefficient text field -----------------------------
    WIDGET_INFO(wWidget,$
      FIND_BY_UNAME= $
      'wave_clear_text_field'): BEGIN
      putTextFieldValue, Event, 'wave_dependent_back_sub_text_field',''
      (*global).scaling_value = ''
    END
    
    ;= TAB3 (PLOT) ============================================================
    
    ;---- Refresh plot --------------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='plot_refresh_plot_ascii_button'): BEGIN
      rePlotAsciiData, Event ;_tab_plot
    END
    
    ;---- Browse ASCII file ---------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='plot_input_file_browse_button'): BEGIN
      BrowseInputAsciiFile, Event ;_tab_plot
    END
    
    ;---- Input text field ----------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='plot_input_file_text_field'): BEGIN
      check_IF_file_exist, Event ;_tab_plot
    END
    
    ;---- Load File Button ----------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='plot_input_file_load_button'): BEGIN
      LoadAsciiFile, Event ;_tab_plot
    END
    
    ;---- Preview button ------------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='plot_input_file_preview_button'): BEGIN
      preview_ascii_file, event ;_tab_plot
    END
    
    
    ;= TAB4 (LOG BOOK) ========================================================
    WIDGET_INFO(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
      SendToGeek, Event       ;_IDLsendToGeek
    END
    
    ELSE:
    
  ENDCASE
  
  IF ((*global).build_command_line) THEN BEGIN
    CheckCommandLine, Event         ;_command_line
  ENDIF
  
END
