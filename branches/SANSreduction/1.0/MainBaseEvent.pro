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

CASE Event.id OF
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='main_tab'): BEGIN
        tab_event, Event ;_eventcb
    END

;= TAB1 (LOAD DATA) ===========================================================

;- Main Plot ------------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='draw_uname'): BEGIN
        getXYposition, Event ;_get
        IF (Event.press EQ 1) THEN BEGIN
            putTextFieldValue, Event, $
              'x_center_value', $
              STRCOMPRESS(Event.x/8.)
            putTextFieldValue, Event, $
              'y_center_value', $
              STRCOMPRESS(Event.y/8.)
        ENDIF
    END

;- Run Number cw_field --------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='run_number_cw_field'): BEGIN
        load_run_number, Event     ;_eventcb
    END

;- Browse Button --------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='browse_nexus_button'): BEGIN
        browse_nexus, Event ;_eventcb
    END

;- Selection Button -----------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_tool_button'): BEGIN
        selection_tool, Event ;_eventcb
    END

;- Browse Selection File ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_browse_button'): BEGIN
        browse_selection_file, Event ;_selection
    END
    
;- Preview Selection File -----------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_preview_button'): BEGIN
        preview_selection_file, Event ;_selection
    END

;- Selection File Name Text Field ---------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_file_name_text_field'): BEGIN
        selection_text_field, Event ;_selection
    END

;- Selection Load Button ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_load_button'): BEGIN
        LoadPlotSelection, Event ;_selection
    END

;-Exclusion Region Selection Tool ---------------------------------------------
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

;-END of Exclusion Region Selection Tool --------------------------------------

;- Clear Selection Button -----------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='clear_selection_button'): BEGIN
        clear_selection_tool, Event ;_selection
    END

;- Refresh Plot ---------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='refresh_plot_button'): BEGIN
        refresh_plot, Event     ;_plot
        RefreshRoiExclusionPlot, Event   ;_selection
    END

;- Selection Color Button -----------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_color_button'): BEGIN
        change_color_OF_selection, Event ;_selection
    END

;- Plot Color Button ----------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_color_button'): BEGIN
    END


;= TAB2 (REDUCE) ==============================================================

;---- GO DATA REDUCTION button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='go_data_reduction_button'): BEGIN
        RunCommandLine, Event ;_run_commandline
    END

;==== tab1 (LOAD FILES (1)) ===================================================

;----Data File ----------------------------------------------------------------
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

;----ROI FIle -----------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='roi_browse_button'): BEGIN
        BrowseNexus, Event, $
          'roi_browse_button',$
          'roi_file_name_text_field'
    END

;----Solvant Buffer Only File -------------------------------------------------
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

;----Empty Can  ---------------------------------------------------------------
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

;----Open Beam  ---------------------------------------------------------------
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

;----Dark Current  ------------------------------------------------------------
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

;----Sample Data File ---------------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME= $
                'sample_data_transmission_run_number_cw_field'): BEGIN
        LoadNeXus, Event, $
          'sample_data_transmission_run_number_cw_field', $
          'sample_data_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME= $
                'sample_data_transmission_browse_button'): BEGIN
        BrowseNexus, Event, $
          'sample_data_transmission_browse_button',$
          'sample_data_transmission_file_name_text_field'
    END

;----Empty Can Transmission ---------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME= $
                'empty_can_transmission_run_number_cw_field'): BEGIN
        LoadNeXus, Event, $
          'empty_can_transmission_run_number_cw_field', $
          'empty_can_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME= $
                'empty_can_transmission_browse_button'): BEGIN
        BrowseNexus, Event, $
          'empty_can_transmission_browse_button',$
          'empty_can_transmission_file_name_text_field'
    END

    WIDGET_INFO(wWidget,$
                FIND_BY_UNAME= $
                'output_folder'): BEGIN
        BrowseOutputFolder, Event ;_reduce_tab2
    END

;--- Solvent Transmission ---------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME= $
                'solvent_transmission_run_number_cw_field'): BEGIN
        LoadNeXus, Event, $
          'solvent_transmission_run_number_cw_field', $
          'solvent_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME= $
                'solvent_transmission_browse_button'): BEGIN
        BrowseNexus, Event, $
          'solvent_transmission_browse_button',$
          'solvent_transmission_file_name_text_field'
    END

    WIDGET_INFO(wWidget,$
                FIND_BY_UNAME= $
                'output_folder'): BEGIN
        BrowseOutputFolder, Event ;_reduce_tab2
    END

;Clear File Name text field button --------------------------------------------
    WIDGET_INFO(wWidget,$
                FIND_BY_UNAME= $
                'clear_output_file_name_button'): BEGIN
       clearOutputFileName, Event ;_reduce_tab2
    END
    
;Reset File Name --------------------------------------------------------------
    WIDGET_INFO(wWidget,$
                FIND_BY_UNAME= $
                'reset_output_file_name_button'): BEGIN
       ResetOutputFileName, Event ;_reduce_tab2
    END

;==== tab2 (PARAMETERS) =======================================================

;---- YES or NO geometry cw_bgroup --------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='overwrite_geometry_group'): BEGIN
        GeometryGroupInteraction, Event ;_reduce_tab3
    END

;---- Browse button of the overwrite geometry button --------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='overwrite_geometry_button'): BEGIN
        BrowseGeometry, Event ;_reduce_tab3
    END

;---- Monitor Efficiency ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='monitor_efficiency_group'): BEGIN
        monitor_efficiency_constant_gui, Event ;_reduce_tab3
    END

;---- Min Lambda Cut off ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='minimum_lambda_cut_off_group'): BEGIN
        min_lambda_cut_off_gui, Event ;_reduce_tab3
    END

;---- Max Lambda Cut off ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='maximum_lambda_cut_off_group'): BEGIN
        max_lambda_cut_off_gui, Event ;_reduce_tab3
    END

;---- Scaling Constant --------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='scaling_constant_group'): BEGIN
        scaling_constant_gui, Event ;_reduce_tab3
    END

;---- Wavelength dependent background subtraction -----------------------------
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
    END

;---- Browse button of Wavelength Dependent Back. subtraction -----------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='wave_dependent_back_browse_button'): BEGIN
        BrowseLoadWaveFile, Event ;_reduce_tab3
    END

;= TAB3 (PLOT) ================================================================

;---- Refresh plot ------------------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='plot_refresh_plot_ascii_button'): BEGIN
    END

;---- Browse ASCII file -------------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='plot_input_file_browse_button'): BEGIN
        BrowseInputAsciiFile, Event ;_tab_plot
    END

;---- Input text field --------------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='plot_input_file_text_field'): BEGIN
        check_IF_file_exist, Event ;_tab_plot
    END

;---- Load File Button --------------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='plot_input_file_load_button'): BEGIN
    END

;---- Preview button ----------------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='plot_input_file_preview_button'): BEGIN
        preview_ascii_file, event ;_tab_plot
    END


;= TAB4 (LOG BOOK) ============================================================
    WIDGET_INFO(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
        SendToGeek, Event       ;_IDLsendToGeek
    END

    ELSE:
    
ENDCASE

CheckCommandLine, Event         ;_command_line

END
