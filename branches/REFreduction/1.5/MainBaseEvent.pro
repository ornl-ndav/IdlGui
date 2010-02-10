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
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  wWidget =  Event.top            ;widget id
  
  CASE Event.id OF
  
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='main_tab'): begin
      tab_event, Event
    end
    
    ;HELP BUTTON
    WIDGET_INFO(wWidget, FIND_BY_UNAME='help_button'): BEGIN
      start_help ;_eventcb
    END
    
    ;MY HELP BUTTON
    WIDGET_INFO(wWidget, FIND_BY_UNAME='my_help_button'): BEGIN
      start_my_help, Event ;_eventcb
    END
    
    ;instrument selection cwbgroup
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='instrument_selection_cw_bgroup'): begin
    end
    
    ;Instrument Selection
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='instrument_selection_validate_button'): begin
      REFreductionEventcb_InstrumentSelected, Event
    end
    
    ;polarization state base --------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='cancel_pola_state'): BEGIN
      MapBase, Event, 'polarization_state', 0
      text = '> Selection of polarization state base has been canceled.'
      putLogBookMessage, Event, Text, Append=1
    END
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='ok_pola_state'): BEGIN
      ok_polarization_state, Event
    END
    
    ;data/normalization/empty cell tab
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_normalization_tab'): begin
      data_norma_empty_cell_tab_event, Event ;_tab
    end
    
    ;==========================================================================
    ;**LOAD TAB**DATA**--------------------------------------------------------
    ;==========================================================================
    
    ;plots Tab ----------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='load_data_d_dd_tab'): begin
      data_plots_tab_event, Event ;_eventcb
    END
    
    ;Browse NeXus file
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='browse_data_nexus_button'): begin
      (*global).data_path = ''
      BrowseDataNexus, Event
      DefineDefaultOutputName, Event
    END
    
    ;LOAD DATA file cw_field
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='load_data_run_number_text_field'): begin
      (*global).data_path = ''
      REFreductionEventcb_LoadAndPlotDataFile, Event ;_eventcb
      DefineDefaultOutputName, Event
    END
    
    ;LOAD DATA file archived cwbgroup
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_archived_or_full_cwbgroup'): BEGIN
      IF ((*global).archived_data_flag NE $
        isArchivedDataNexusDesired(Event)) THEN BEGIN
        (*global).archived_data_flag = isArchivedDataNexusDesired(Event)
        IF (getTextFieldValue(Event,'load_data_run_number_text_field') $
          NE 0) THEN BEGIN
          (*global).data_path = ''
          REFreductionEventcb_LoadAndPlotDataFile, Event
          DefineDefaultOutputName, Event
        ENDIF
      ENDIF
    end
    
    ;activate or not the proposal droplist -----------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='with_data_proposal_button'): BEGIN
      IF (event.select) THEN BEGIN
        activate = 1
      ENDIF ELSE BEGIN
        activate = 0
      ENDELSE
      ActivateWidget, Event, 'data_proposal_base_uname', activate
    END
    
    ;Save As JPEG button ------------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='save_as_jpeg_button_data'): BEGIN
      save_as_jpeg, Event     ;_jpeg
    END
    
    ;##In list of nexus base##
    ;droplist
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_list_nexus_droplist'): begin
      REFreductionEventcb_DisplayDataNxsummary, Event
    end
    
    ;ok button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_list_nexus_load_button'): begin
      REFreductionEventcb_LoadListOfDataNexus, Event
    end
    
    ;cancel button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_list_nexus_cancel_button'): begin
      REFreductionEventcb_CancelListOfDataNexus, Event
    end
    
    ;****1D PLOT TAB**
    ;1D_2D plot of DATA
    WIDGET_INFO(wWidget, FIND_BY_UNAME='load_data_D_draw'): begin
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
      ENDIF ELSE BEGIN
        IF ((*global).DataNeXusFound) THEN BEGIN
        
          ;show x/y and counts ************************************************
          putLabelValue, Event, $
            'data_x_info_value', $
            STRCOMPRESS(Event.x,/REMOVE_ALL)
          IF ((*global).miniVersion EQ 1) THEN BEGIN
            coeff = 1
          ENDIF ELSE BEGIN
            coeff = 2
          ENDELSE
          putLabelValue, $
            Event, $
            'data_y_info_value', $
            STRCOMPRESS(FIX((Event.y/coeff)),/REMOVE_ALL)
            
          tvimg = (*(*global).tvimg_data_ptr)
          
          putLabelValue, $
            Event, $
            'data_counts_info_value', $
            STRCOMPRESS(FIX(tvimg[Event.x,Event.y]),/REMOVE_ALL)
          ;********************************************************************
            
          IF ((*global).first_event) THEN BEGIN
            ;only if there is a NeXus loaded
            CASE (event.ch) OF ;u and d keys
              117: BEGIN
                REFreduction_ManuallyMoveDataBackPeakUp, Event
                IF ((*global).instrument EQ 'REF_M') THEN BEGIN
                  calculate_data_dirpix, Event
                  plot_average_data_peak_value, Event
                ENDIF
                
              END
              100: BEGIN
                REFreduction_ManuallyMoveDataBackPeakDown, Event
                IF ((*global).instrument EQ 'REF_M') THEN BEGIN
                  calculate_data_dirpix, Event
                  plot_average_data_peak_value, Event
                ENDIF
              END
              ELSE:
            ENDCASE
            CASE (event.key) OF ;Up and Down arrow keys
              7: BEGIN
                REFreduction_ManuallyMoveDataBackPeakUp, Event
                IF ((*global).instrument EQ 'REF_M') THEN BEGIN
                  calculate_data_dirpix, Event
                  plot_average_data_peak_value, Event
                ENDIF
                
              END
              8: BEGIN
                REFreduction_ManuallyMoveDataBackPeakDown, Event
                IF ((*global).instrument EQ 'REF_M') THEN BEGIN
                  calculate_data_dirpix, Event
                  plot_average_data_peak_value, Event
                ENDIF
              END
              ELSE:
            ENDCASE
            (*global).first_event = 0
            
          ENDIF ELSE BEGIN
            (*global).first_event = 1
          ENDELSE
          
          IF( Event.type EQ 0 )THEN BEGIN
            IF (Event.press EQ 1) THEN $
              REFreduction_DataSelectionPressLeft, Event ;left button
            IF (Event.press EQ 4) THEN $
              REFreduction_DataselectionPressRight, Event ;right button
          ENDIF
          IF (Event.type EQ 1) THEN BEGIN ;release
            REFreduction_DataSelectionRelease, Event
            IF ((*global).instrument EQ 'REF_M') THEN BEGIN
              calculate_data_dirpix, Event
              plot_average_data_peak_value, Event
            ENDIF
          ENDIF
          IF (Event.type EQ 2) THEN BEGIN ;move
            REFreduction_DataSelectionMove, Event
          ;           calculate_data_dirpix, Event
          ENDIF
        ENDIF
        
      ENDELSE
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_1d_selection'): begin
      REFreduction_DataBackPeakZoomEvent, Event
    end
    
    ;zoom and nxsummary tab
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_nxsummary_zoom_tab'): begin
      REFreduction_DataNxsummaryZoomTab, Event
    end
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_zoom_scale_cwfield'): begin
      REFreduction_ZoomRescaleData, Event
    end
    
    ;ROI Ymin and Ymax --------------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'data_d_selection_roi_ymin_cw_field'): begin
      REFreduction_DataBackgroundPeakSelection, Event, 'roi_ymin'
      plot_average_data_peak_value, Event
    end
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'data_d_selection_roi_ymax_cw_field'): begin
      REFreduction_DataBackgroundPeakSelection, Event, 'roi_ymax'
      plot_average_data_peak_value, Event
    end
    
    ;SAVE ROI Selection into a file -------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_roi_save_button'): begin
      ;      file_name = $
      ;        getTextFieldValue(Event,$
      ;        'data_roi_selection_file_text_field')
      ;      file_name = file_name[0]
      ;      path = FILE_DIRNAME(file_name)
      ;      check_create_output_folder, Event, PATH=path
      REFreduction_CreateDataBackgroundROIFile, Event, 'roi'
    end
    
    ;LOAD ROI selection
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_roi_load_button'): begin
      REFreduction_LoadDataROISelection, Event
      IF ((*global).instrument EQ 'REF_M') THEN BEGIN
        calculate_data_dirpix, Event
      ENDIF
    end
    
    ;dirpix widget_text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_geometry_dirpix_value_user'): BEGIN
      coefficient = getUDCoefficient(Event)
      REFreduction_ManuallyMoveDataBackPeak, Event, 0
      
    ;REFreduction_DataSelectionMove, event
    ;REFReduction_RescaleDataPlot, Event
    ;dirpix = getTextFieldValue(Event,'data_geometry_dirpix_value_user')
    ;(*global).dirpix = FLOAT(dirpix)
    ;plot_average_data_peak_value, Event
    END
    
    ;Peak Ymin and Ymax -------------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data_d_selection_peak_ymin_cw_field'): begin
      REFreduction_DataBackgroundPeakSelection, Event, 'peak_ymin'
    end
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data_d_selection_peak_ymax_cw_field'): begin
      REFreduction_DataBackgroundPeakSelection, Event, 'peak_ymax'
    end
    
    ;Background Ymin and Ymax -------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'data_d_selection_background_ymin_cw_field'): begin
      REFreduction_DataBackgroundPeakSelection, Event, 'back_ymin'
    end
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'data_d_selection_background_ymax_cw_field'): begin
      REFreduction_DataBackgroundPeakSelection, Event, 'back_ymax'
    end
    
    ;SAVE Background Selection into a file ------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_back_save_button'): begin
      ;      file_name = $
      ;        getTextFieldValue(Event,$
      ;        'data_back_d_selection_file_text_field')
      ;      file_name = file_name[0]
      ;      path = FILE_DIRNAME(file_name)
      ;      check_create_output_folder, Event, PATH=path
      REFreduction_CreateDataBackgroundROIFile, Event, 'back'
    end
    
    ;LOAD background selection
    WIDGET_INFO(wWidget, FIND_BY_UNAME= $
      'data_d_selection_back_load_button'): begin
      REFreduction_LoadDataBackSelection, Event ;_LoadBackgroundSelection
    end
    
    ;Peak/Background tab (peak/background cw_bgroup)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='peak_data_back_group'): BEGIN
      SwitchPeakBackgroundDataBase, Event ;_GUIinteraction
      SwitchPeakBackgroundReduceDatabase, Event ;_GUIinteraction
      ;replot the selection activated
      REFReduction_RescaleDataPlot,Event
      ;       RePlot1DDataFile, Event
      ReplotAllSelection, Event
    END
    
    ;CONTRAST TAB
    ;Contrast editor of data 1D tab
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_contrast_droplist'): begin
      REFreductionEventcb_DataContrastEditor, Event
      (*global).data_loadct_contrast_changed = 1
    end
    
    ;Reset Contrast Editor
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_reset_contrast_button'): begin
      REFreductionEventcb_DataResetContrastEditor, Event
      (*global).data_loadct_contrast_changed = 1
    end
    
    ;bottom slider
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_contrast_bottom_slider'): begin
      REFreductionEventcb_DataContrastBottomSlider, Event
      (*global).data_loadct_contrast_changed = 1
    end
    
    ;Number color slider
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_contrast_number_slider'): begin
      REFreductionEventcb_DataContrastNumberSlider, Event
      (*global).data_loadct_contrast_changed = 1
    end
    
    ;RESCALE DATA TAB
    ;reset x axis
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_reset_xaxis_button'): begin
      REFreduction_ResetXDataPlot, Event
    end
    
    ;reset y axis
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_reset_yaxis_button'): begin
      REFreduction_ResetYDataPlot, Event
    end
    
    ;reset z axis
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_reset_zaxis_button'): begin
      REFreduction_ResetZDataPlot, Event
    end
    
    ;reset all axis
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_full_reset_button'): begin
      REFreduction_ResetFullDataPlot, Event
    end
    
    ;############################### 1D_3D PLOT TAB ###########################
    ;reset z-axis
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_z_axis_reset_button'): begin
      REFreduction_ResetData1D3DPlotZaxis, Event
    end
    
    ;reset xy_axis
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_xy_axis_reset_button'): begin
      REFreduction_ResetData1D3DPlotXYaxis, Event
    end
    
    ;reset zz_axis
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_zz_axis_reset_button'): begin
      REFreduction_ResetData1D3DPlotZZaxis, Event
    end
    
    ;Full reset
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_full_reset_button'): begin
      REFreduction_FullResetData1D3DPlot_OrientationReset, Event
    end
    
    ;switch to manual mode
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data1d_switch_to_manual_mode_button'): begin
      REFreduction_SwitchToManualData1DMode, Event
    end
    
    ;Rotation interface (google)
    ;switch to auto mode
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data1d_switch_to_auto_mode_button'): begin
      REFreduction_SwitchToAutoData1DMode, Event
    end
    
    ;xy-axis MMM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data1d_google_xy_axis_mmm_button'): begin
      REFreduction_RotateData1D3DPlot_Orientation, Event, 'xy-axis',-10
    end
    ;xy-axis MM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data1d_google_xy_axis_mm_button'): begin
      REFreduction_RotateData1D3DPlot_Orientation, Event, 'xy-axis',-5
    end
    ;xy_axis M
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data1d_google_xy_axis_m_button'): begin
      REFreduction_RotateData1D3DPlot_Orientation, Event, 'xy-axis',-2
    end
    ;xy_axis P
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_google_xy_axis_p_button'): begin
      REFreduction_RotateData1D3DPlot_Orientation, Event, 'xy-axis',2
    end
    ;xy-axis PP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data1d_google_xy_axis_pp_button'): begin
      REFreduction_RotateData1D3DPlot_Orientation, Event, 'xy-axis',5
    end
    ;xy-axis PPP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data1d_google_xy_axis_ppp_button'): begin
      REFreduction_RotateData1D3DPlot_Orientation, Event, 'xy-axis',+10
    end
    
    ;z-axis MMM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data1d_google_z_axis_mmm_button'): begin
      REFreduction_RotateData1D3DPlot_Orientation, Event, 'z-axis',-10
    end
    ;z-axis MM
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_google_z_axis_mm_button'): begin
      REFreduction_RotateData1D3DPlot_Orientation, Event, 'z-axis',-5
    end
    ;z_axis M
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_google_z_axis_m_button'): begin
      REFreduction_RotateData1D3DPlot_Orientation, Event, 'z-axis',-2
    end
    ;z_axis P
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_google_z_axis_p_button'): begin
      REFreduction_RotateData1D3DPlot_Orientation, Event, 'z-axis',2
    end
    ;z-axis PP
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_google_z_axis_pp_button'): begin
      REFreduction_RotateData1D3DPlot_Orientation, Event, 'z-axis',5
    end
    ;z-axis PPP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data1d_google_z_axis_ppp_button'): begin
      REFreduction_RotateData1D3DPlot_Orientation, Event, 'z-axis',10
    end
    
    ;reset
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_google_reset_button'): begin
      REFreduction_ResetData1D3DPlot_OrientationReset, Event
    end
    
    ;1d_3d loadct
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_loadct_1d_3d_droplist'): begin
      CurrentLoadctIndex = $
        getDropListSelectedIndex(Event, 'data_loadct_1d_3d_droplist')
      PrevLoadctIndex = (*global).PrevData1d3dContrastDropList
      if (CurrentLoadctIndex NE PrevLoadctIndex) then begin
        REFreduction_RescaleData1D3DPlot, Event
        (*global).PrevData1d3dContrastDropList = CurrentLoadctIndex
      endif
    end
    
    ;############################### 2D_3D PLOT TAB ###########################
    ;reset z-axis
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_z_axis_reset_button'): begin
      REFreduction_ResetData2D3DPlotZaxis, Event
    end
    
    ;reset xy_axis
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_xy_axis_reset_button'): begin
      REFreduction_ResetData2D3DPlotXYaxis, Event
    end
    
    ;reset zz_axis
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_zz_axis_reset_button'): begin
      REFreduction_ResetData2D3DPlotZZaxis, Event
    end
    
    ;Full reset
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_full_reset_button'): begin
      REFreduction_FullResetData2D3DPlot_OrientationReset, Event
    end
    
    ;switch to manual mode
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data2d_switch_to_manual_mode_button'): begin
      REFreduction_SwitchToManualData2DMode, Event
    end
    
    ;Rotation interface (google)
    ;switch to auto mode
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data2d_switch_to_auto_mode_button'): begin
      REFreduction_SwitchToAutoData2DMode, Event
    end
    
    ;xy-axis MMM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data2d_google_xy_axis_mmm_button'): begin
      REFreduction_RotateData2D3DPlot_Orientation, Event, 'xy-axis',-10
    end
    ;xy-axis MM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data2d_google_xy_axis_mm_button'): begin
      REFreduction_RotateData2D3DPlot_Orientation, Event, 'xy-axis',-5
    end
    ;xy_axis M
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_google_xy_axis_m_button'): begin
      REFreduction_RotateData2D3DPlot_Orientation, Event, 'xy-axis',-2
    end
    ;xy_axis P
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_google_xy_axis_p_button'): begin
      REFreduction_RotateData2D3DPlot_Orientation, Event, 'xy-axis',2
    end
    ;xy-axis PP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data2d_google_xy_axis_pp_button'): begin
      REFreduction_RotateData2D3DPlot_Orientation, Event, 'xy-axis',5
    end
    ;xy-axis PPP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data2d_google_xy_axis_ppp_button'): begin
      REFreduction_RotateData2D3DPlot_Orientation, Event, 'xy-axis',+10
    end
    
    ;z-axis MMM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data2d_google_z_axis_mmm_button'): begin
      REFreduction_RotateData2D3DPlot_Orientation, Event, 'z-axis',-10
    end
    ;z-axis MM
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_google_z_axis_mm_button'): begin
      REFreduction_RotateData2D3DPlot_Orientation, Event, 'z-axis',-5
    end
    ;z_axis M
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_google_z_axis_m_button'): begin
      REFreduction_RotateData2D3DPlot_Orientation, Event, 'z-axis',-2
    end
    ;z_axis P
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_google_z_axis_p_button'): begin
      REFreduction_RotateData2D3DPlot_Orientation, Event, 'z-axis',2
    end
    ;z-axis PP
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_google_z_axis_pp_button'): begin
      REFreduction_RotateData2D3DPlot_Orientation, Event, 'z-axis',5
    end
    ;z-axis PPP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='data2d_google_z_axis_ppp_button'): begin
      REFreduction_RotateData2D3DPlot_Orientation, Event, 'z-axis',10
    end
    
    ;reset
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_google_reset_button'): begin
      REFreduction_ResetData2D3DPlot_OrientationReset, Event
    end
    
    ;1d_3d loadct
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_loadct_2d_3d_droplist'): begin
      CurrentLoadctIndex = $
        getDropListSelectedIndex(Event, 'data_loadct_2d_3d_droplist')
      PrevLoadctIndex = (*global).PrevData2d3dContrastDropList
      if (CurrentLoadctIndex NE PrevLoadctIndex) then begin
        REFreduction_RescaleData2D3DPlot, Event
        (*global).PrevData2d3dContrastDropList = CurrentLoadctIndex
      endif
    end
    
    ;==========================================================================
    ;**LOAD TAB**NORMALIZATION**-----------------------------------------------
    ;==========================================================================
    
    ;plots Tab --------------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='load_normalization_d_dd_tab'): begin
      norm_plots_tab_event, Event ;_eventcb
    END
    
    ;Browse NeXus file
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='browse_norm_nexus_button'): begin
      (*global).norm_path = ''
      BrowseNormNexus, Event
    END
    
    ;LOAD NORMALIZATION file
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'load_normalization_run_number_text_field'): begin
      (*global).norm_path = ''
      REFreductionEventcb_LoadAndPlotNormFile, Event
    end
    
    ;activate or not the proposal droplist -----------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='with_norm_proposal_button'): BEGIN
      IF (event.select) THEN BEGIN
        activate = 1
      ENDIF ELSE BEGIN
        activate = 0
      ENDELSE
      ActivateWidget, Event, 'normalization_proposal_base_uname', activate
    END
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_archived_or_full_cwbgroup'): begin
      IF ((*global).archived_norm_flag NE $
        isArchivedNormNexusDesired(Event)) THEN BEGIN
        (*global).archived_norm_flag = isArchivedNormNexusDesired(Event)
        IF (getTextFieldValue(Event, $
          'load_normalization_run_number_text_field') $
          NE 0) THEN BEGIN
          (*global).norm_path = ''
          REFreductionEventcb_LoadAndPlotNormFile, Event
        ENDIF
      ENDIF
    END
    
    ;Save As JPEG button ------------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='save_as_jpeg_button_normalization'): BEGIN
      save_as_jpeg, Event ;_jpeg
    END
    
    ;##In list of nexus base##
    ;droplist
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_list_nexus_droplist'): begin
      REFreductionEventcb_DisplayNormNxsummary, Event
    end
    
    ;ok button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='norm_list_nexus_load_button'): begin
      REFreductionEventcb_LoadListOfNormNexus, Event
    end
    
    ;cancel button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='norm_list_nexus_cancel_button'): begin
      REFreductionEventcb_CancelListOfNormNexus, Event
    end
    
    ;****1D PLOT TAB**
    ;1D plot of NORM
    WIDGET_INFO(wWidget, FIND_BY_UNAME='load_normalization_D_draw'): begin
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
      ENDIF ELSE BEGIN
        IF ((*global).NormNeXusFound) THEN BEGIN
          ;only if there is a NeXus loaded
        
          ;show x/y and counts ************************************************
          putLabelValue, Event, $
            'norm_x_info_value', $
            STRCOMPRESS(Event.x,/REMOVE_ALL)
          IF ((*global).miniVersion EQ 1) THEN BEGIN
            coeff = 1
          ENDIF ELSE BEGIN
            coeff = 2
          ENDELSE
          putLabelValue, $
            Event, $
            'norm_y_info_value', $
            STRCOMPRESS(FIX((Event.y/coeff)+1),/REMOVE_ALL)
            
          tvimg = (*(*global).tvimg_norm_ptr)
          putLabelValue, $
            Event, $
            'norm_counts_info_value', $
            STRCOMPRESS(FIX(tvimg[Event.x,Event.y]),/REMOVE_ALL)
          ;********************************************************************
            
          IF ((*global).first_event) THEN BEGIN
            CASE (event.ch) OF ;u and d keys
              117: REFreduction_ManuallyMoveNormBackPeakUp, Event
              100: REFreduction_ManuallyMoveNormBackPeakDown, Event
              ELSE:
            ENDCASE
            CASE (event.key) OF ;Up and Down arrow keys
              7: REFreduction_ManuallyMoveNormBackPeakUp, Event
              8: REFreduction_ManuallyMoveNormBackPeakDown, Event
              ELSE:
            ENDCASE
            (*global).first_event = 0
          ENDIF ELSE BEGIN
            (*global).first_event = 1
          ENDELSE
          IF( Event.type EQ 0 )THEN BEGIN
            IF (Event.press EQ 1) THEN $
              REFreduction_NormSelectionPressLeft, Event ;left button
            IF (Event.press EQ 4) THEN $
              REFreduction_NormselectionPressRight, Event ;right button
          ENDIF
          IF (Event.type EQ 1) THEN $ ;release
            REFreduction_NormSelectionRelease, Event
          IF (Event.type EQ 2) THEN $ ;move
            REFreduction_NormSelectionMove, Event
        ENDIF
      ENDELSE
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization_1d_selection'): begin
      REFreduction_NormBackPeakZoomEvent, Event
    end
    
    ;zoom and nxsummary tab
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_nxsummary_zoom_tab'): begin
      REFreduction_NormNxsummaryZoomTab, Event
    end
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_zoom_scale_cwfield'): begin
      REFreduction_ZoomRescaleNormalization, Event
    end
    
    ;ROI Ymin and Ymax --------------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'nom_d_selection_roi_ymin_cw_field'): begin
      REFreduction_NormBackgroundPeakSelection, Event, 'roi_ymin'
    end
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'norm_d_selection_roi_ymax_cw_field'): begin
      REFreduction_NormBackgroundPeakSelection, Event, 'roi_ymax'
    end
    
    ;SAVE ROI Selection into a file -------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='norm_roi_save_button'): begin
      ;      file_name = $
      ;        getTextFieldValue(Event,$
      ;        'norm_roi_selection_file_text_field')
      ;      file_name = file_name[0]
      ;      path = FILE_DIRNAME(file_name)
      ;      check_create_output_folder, Event, PATH=path
      REFreduction_CreateNormBackgroundROIFile, Event, 'roi'
    end
    
    ;LOAD ROI selection
    WIDGET_INFO(wWidget, FIND_BY_UNAME='norm_roi_load_button'): begin
      REFreduction_LoadNormROISelection, Event
    end
    
    ;Peak Ymin and Ymax -------------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='norm_d_selection_peak_ymin_cw_field'): begin
      REFreduction_NormBackgroundPeakSelection, Event, 'peak_ymin'
    end
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='norm_d_selection_peak_ymax_cw_field'): begin
      REFreduction_NormBackgroundPeakSelection, Event, 'peak_ymax'
    end
    
    ;Background Ymin and Ymax -------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'norm_d_selection_background_ymin_cw_field'): begin
      REFreduction_NormBackgroundPeakSelection, Event, 'back_ymin'
    end
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'norm_d_selection_background_ymax_cw_field'): begin
      REFreduction_NormBackgroundPeakSelection, Event, 'back_ymax'
    end
    
    ;SAVE Background Selection into a file ------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='norm_back_save_button'): begin
      ;      file_name = $
      ;        getTextFieldValue(Event,$
      ;        'norm_back_d_selection_file_text_field')
      ;      file_name = file_name[0]
      ;      path = FILE_DIRNAME(file_name)
      ;      check_create_output_folder, Event, PATH=path
      REFreduction_CreateNormBackgroundROIFile, Event, 'back'
    end
    
    ;LOAD background selection
    WIDGET_INFO(wWidget, FIND_BY_UNAME= $
      'norm_d_selection_norm_load_button'): begin
      REFreduction_LoadNormBackgroundSelection, Event
    ;_LoadBackgroundSelection
    end
    
    ;Peak/Background tab (peak/background cw_bgroup)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='peak_norm_back_group'): BEGIN
      SwitchPeakBackgroundNormBase, Event ;_GUI
      SwitchPeakBackgroundReduceNormBase, Event ;_GUI
      ;replot the selection activated
      REFReduction_RescaleNormalizationPlot,Event
      ;       RePlot1DNormFile, Event
      ReplotNormAllSelection, Event
    END
    
    ;**************************************************************************
    
    ;CONTRAST TAB
    ;Contrast editor of data 1D tab
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_contrast_droplist'): begin
      REFreductionEventcb_NormContrastEditor, Event
      (*global).norm_loadct_contrast_changed = 1
    end
    
    ;Reset Contrast Editor
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_reset_contrast_button'): begin
      REFreductionEventcb_NormResetContrastEditor, Event
      (*global).norm_loadct_contrast_changed = 1
    end
    
    ;bottom slider
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_contrast_bottom_slider'): begin
      REFreductionEventcb_NormContrastBottomSlider, Event
      (*global).norm_loadct_contrast_changed = 1
    end
    
    ;Number color slider
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_contrast_number_slider'): begin
      REFreductionEventcb_NormContrastNumberSlider, Event
      (*global).norm_loadct_contrast_changed = 1
    end
    
    ;RESCALE DATA TAB
    ;reset x axis
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_reset_xaxis_button'): begin
      REFreduction_ResetXNormPlot, Event
    end
    
    ;reset y axis
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_reset_yaxis_button'): begin
      REFreduction_ResetYNormPlot, Event
    end
    
    ;reset z axis
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_reset_zaxis_button'): begin
      REFreduction_ResetZNormPlot, Event
    end
    
    ;reset all axis
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_full_reset_button'): begin
      REFreduction_ResetFullNormPlot, Event
    end
    
    ;############################### 1D_3D PLOT TAB ###########################
    ;reset z-axis
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_z_axis_reset_button'): begin
      REFreduction_ResetNorm1D3DPlotZaxis, Event
    end
    
    ;reset xy-axis
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_xy_axis_reset_button'): begin
      REFreduction_ResetNorm1D3DPlotXYaxis, Event
    end
    
    ;reset zz-axis
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_zz_axis_reset_button'): begin
      REFreduction_ResetNorm1D3DPlotZZaxis, Event
    end
    
    ;Full reset
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_full_reset_button'): begin
      REFreduction_FullResetNorm1D3DPlot_OrientationReset, Event
    end
    
    ;switch to manual mode
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization1d_switch_to_manual_mode_button'): begin
      REFreduction_SwitchToManualNorm1DMode, Event
    end
    
    ;Rotation interface (google)
    ;switch to auto mode
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization1d_switch_to_auto_mode_button'): begin
      REFreduction_SwitchToAutoNorm1DMode, Event
    end
    
    ;xy-axis MMM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization1d_google_xy_axis_mmm_button'): begin
      REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'xy-axis',-10
    end
    ;xy-axis MM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization1d_google_xy_axis_mm_button'): begin
      REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'xy-axis',-5
    end
    ;xy_axis M
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization1d_google_xy_axis_m_button'): begin
      REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'xy-axis',-2
    end
    ;xy_axis P
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_google_xy_axis_p_button'): begin
      REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'xy-axis',2
    end
    ;xy-axis PP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization1d_google_xy_axis_pp_button'): begin
      REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'xy-axis',5
    end
    ;xy-axis PPP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization1d_google_xy_axis_ppp_button'): begin
      REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'xy-axis',+10
    end
    
    ;z-axis MMM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization1d_google_z_axis_mmm_button'): begin
      REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'z-axis',-10
    end
    ;z-axis MM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_google_z_axis_mm_button'): begin
      REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'z-axis',-5
    end
    ;z_axis M
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_google_z_axis_m_button'): begin
      REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'z-axis',-2
    end
    ;z_axis P
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_google_z_axis_p_button'): begin
      REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'z-axis',2
    end
    ;z-axis PP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_google_z_axis_pp_button'): begin
      REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'z-axis',5
    end
    ;z-axis PPP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization1d_google_z_axis_ppp_button'): begin
      REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'z-axis',10
    end
    
    ;reset
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_google_reset_button'): begin
      REFreduction_ResetNorm1D3DPlot_OrientationReset, Event
    end
    
    ;1d_3d loadct
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_loadct_1d_3d_droplist'): begin
      CurrentLoadctIndex = $
        getDropListSelectedIndex(Event, $
        'normalization_loadct_1d_3d_droplist')
      PrevLoadctIndex = (*global).PrevNorm1d3dContrastDropList
      if (CurrentLoadctIndex NE PrevLoadctIndex) then begin
        REFreduction_RescaleNorm1D3DPlot, Event
        (*global).PrevNorm1d3dContrastDropList = CurrentLoadctIndex
      endif
    end
    
    ;############################## 2D_3D PLOT TAB ############################
    ;reset z-axis
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_z_axis_reset_button'): begin
      REFreduction_ResetNormalization2D3DPlotZaxis, Event
    end
    
    ;reset xy_axis
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_xy_axis_reset_button'): begin
      REFreduction_ResetNormalization2D3DPlotXYaxis, Event
    end
    
    ;reset zz_axis
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_zz_axis_reset_button'): begin
      REFreduction_ResetNormalization2D3DPlotZZaxis, Event
    end
    
    ;Full reset
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_full_reset_button'): begin
      REFreduction_FullResetNormalization2D3DPlot_OrientationReset, Event
    end
    
    ;switch to manual mode
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization2d_switch_to_manual_mode_button'): begin
      REFreduction_SwitchToManualNorm2DMode, Event
    end
    
    ;Rotation interface (google)
    ;switch to auto mode
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization2d_switch_to_auto_mode_button'): begin
      REFreduction_SwitchToAutoNorm2DMode, Event
    end
    
    ;xy-axis MMM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization2d_google_xy_axis_mmm_button'): begin
      REFreduction_RotateNormalization2D3DPlot_Orientation, $
        Event, 'xy-axis',-10
    end
    ;xy-axis MM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization2d_google_xy_axis_mm_button'): begin
      REFreduction_RotateNormalization2D3DPlot_Orientation, $
        Event, 'xy-axis',-5
    end
    ;xy_axis M
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization2d_google_xy_axis_m_button'): begin
      REFreduction_RotateNormalization2D3DPlot_Orientation, $
        Event, 'xy-axis',-2
    end
    ;xy_axis P
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_google_xy_axis_p_button'): begin
      REFreduction_RotateNormalization2D3DPlot_Orientation, $
        Event, 'xy-axis',2
    end
    ;xy-axis PP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization2d_google_xy_axis_pp_button'): begin
      REFreduction_RotateNormalization2D3DPlot_Orientation, $
        Event, 'xy-axis',5
    end
    ;xy-axis PPP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization2d_google_xy_axis_ppp_button'): begin
      REFreduction_RotateNormalization2D3DPlot_Orientation, $
        Event, 'xy-axis',+10
    end
    
    ;z-axis MMM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization2d_google_z_axis_mmm_button'): begin
      REFreduction_RotateNormalization2D3DPlot_Orientation, $
        Event, 'z-axis',-10
    end
    ;z-axis MM
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_google_z_axis_mm_button'): begin
      REFreduction_RotateNormalization2D3DPlot_Orientation, $
        Event, 'z-axis',-5
    end
    ;z_axis M
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_google_z_axis_m_button'): begin
      REFreduction_RotateNormalization2D3DPlot_Orientation, $
        Event, 'z-axis',-2
    end
    ;z_axis P
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_google_z_axis_p_button'): begin
      REFreduction_RotateNormalization2D3DPlot_Orientation, $
        Event, 'z-axis',2
    end
    ;z-axis PP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_google_z_axis_pp_button'): begin
      REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'z-axis',5
    end
    ;z-axis PPP
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'normalization2d_google_z_axis_ppp_button'): begin
      REFreduction_RotateNormalization2D3DPlot_Orientation, $
        Event, 'z-axis',10
    end
    
    ;reset
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_google_reset_button'): begin
      REFreduction_ResetNormalization2D3DPlot_OrientationReset, Event
    end
    
    ;2d_3d loadct
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_loadct_2d_3d_droplist'): begin
      CurrentLoadctIndex = $
        getDropListSelectedIndex(Event, $
        'normalization_loadct_2d_3d_droplist')
      PrevLoadctIndex = (*global).PrevNorm2d3dContrastDropList
      if (CurrentLoadctIndex NE PrevLoadctIndex) then begin
        REFreduction_RescaleNormalization2D3DPlot, Event
        (*global).PrevNorm2d3dContrastDropList = CurrentLoadctIndex
      endif
    end
    
    ;==========================================================================
    ;**LOAD TAB**EMPTY CELL**--------------------------------------------------
    ;==========================================================================
    
    ;Browse NeXus file
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='browse_empty_cell_nexus_button'): begin
      IF ((*global).debugging_on_mac EQ 'no') THEN BEGIN
        BrowseEmptyCellNexus, Event
      ENDIF ELSE BEGIN
        BrowseEmptyCellNexus_onMac, Event
      ENDELSE
    END
    
    ;LOAD empty_cell file cw_field
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='empty_cell_nexus_run_number'): begin
      REFreduction_LoadEmptyCell, Event, isNeXusFound, NbrNexus ;_empty_cell
    END
    
    ;activate or not the proposal droplist -----------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='with_empty_cell_proposal_button'): BEGIN
      IF (event.select) THEN BEGIN
        activate = 1
      ENDIF ELSE BEGIN
        activate = 0
      ENDELSE
      ActivateWidget, Event, 'empty_cell_proposal_base_uname', activate
    END
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='empty_cell_archived_or_all_uname'): BEGIN
      IF ((*global).archived_empty_cell_flag NE $
        isArchivedemptyCellNexusDesired(Event)) THEN BEGIN
        (*global).archived_empty_cell_flag = $
          isArchivedEmptyCellNexusDesired(Event)
        IF (getTextFieldValue(Event, $
          'empty_cell_nexus_run_number') $
          NE 0) THEN BEGIN
          (*global).empty_cell_path = ''
          REFreduction_LoadEmptyCell, Event, isNeXusFound, NbrNexus
        ENDIF
      ENDIF
    END
    
    ;##In list of nexus base##
    ;droplist
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_nexus_droplist'): BEGIN
      DisplayEmptyCellNxsummary, Event ;_empty_cell
    END
    
    ;output folder button  ------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_output_folder_button'): begin
      empty_cell_output_folder, Event ;_output_empty_cell
    end
    
    ;output recap plot file name text field  ------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='empty_cell_output_file_name_text_field'): begin
      check_empty_cell_recap_output_file_name, Event
    end
    
    ;create empty cell output file -------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='empty_cell_create_output_file_button'): begin
      path = getButtonValue(Event,'empty_cell_output_folder_button')
      check_create_output_folder, Event, PATH=path
      create_empty_cell_output_file, Event ;_output_empty_cell
    end
    
    ;preview button of output recap file
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='empty_cell_preview_of_ascii_button'): begin
      preview_empty_cell_output_file, Event
    end
    
    ;--------------------------------------------------------------------
    
    ;lin/log cw_bgroup
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_sf_z_axis'): begin
      empty_cell_lin_log, Event
    END
    
    ;ok button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_list_load_button'): begin
      LoadListOfEmptyCellNexus, Event ;_empty_cell
    end
    
    ;cancel button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_list_cancel_button'): begin
      CancelListOfEmptyCellNexus, Event ;_empty_cell
    end
    
    ;Substrate Transmission equation ..........................................
    
    ;Substrate type droplist
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_substrate_list'): BEGIN
      substrate_type_droplist_event, Event ;_empty_cell
      update_substrate_equation, Event ;_empty_cell
    END
    
    ;A Equation
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_substrate_a'): BEGIN
      update_substrate_equation, Event ;_empty_cell
    END
    
    ;B Equation
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_substrate_b'): BEGIN
      update_substrate_equation, Event ;_empty_cell
    END
    
    ;Diameter
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_diameter'): BEGIN
      update_substrate_equation, Event ;_empty_cell
    END
    
    ;Scaling Factor
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_scaling_factor'): BEGIN
      update_substrate_equation, Event ;_empty_cell
    END
    
    ;Scaling Factor button (to launch the calculation of the SF)
    WIDGET_INFO(wWidget, FIND_BY_UNAME= $
      'empty_cell_scaling_factor_button'): BEGIN
      WIDGET_CONTROL, HOURGLASS=1
      start_sf_scaling_factor_calculation_mode, Event ;_sf_empty_cell
      (*global).bRecapPlot =  0b
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;Calculate Scaling Factor Base ............................................
    
    ;empty cell draw
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'empty_cell_scaling_factor_base_data_draw'): BEGIN
      IF (TAG_NAMES(event, /STRUCTURE_NAME) EQ 'WIDGET_TRACKING') $
        THEN BEGIN
        IF (event.ENTER EQ 0) THEN BEGIN
          reset_sf_calculation_base_data_info, Event ;_sf_empty_cell
        ENDIF
      ENDIF ELSE BEGIN
        display_sf_calculation_base_data_info, Event ;_sf_empty_cell
        
        IF (Event.press EQ 1) THEN BEGIN ;left click
          (*global).sf_x0 = Event.x
          (*global).sf_y0 = Event.y
          (*global).ec_left_click = 1
        ENDIF
        
        IF (Event.type EQ 2) THEN BEGIN ;move mouse
          IF ((*global).ec_left_click) THEN BEGIN
            display_sf_data_selection, Event, $ ;_sf_empty_cell
              X1 = Event.x,$
              Y1 = Event.y
          ENDIF
        ENDIF
        
        IF (Event.type EQ 1) THEN BEGIN ;release mouse
          (*global).sf_x1 = Event.x
          (*global).sf_y1 = Event.y
          (*global).ec_left_click = 0
          calculate_sf, Event ;_sf_empty_cell
        ENDIF
        
      ENDELSE
    END
    
    ;empty cell draw
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'empty_cell_scaling_factor_base_empty_cell_draw'): BEGIN
      IF (TAG_NAMES(event, /STRUCTURE_NAME) EQ 'WIDGET_TRACKING') $
        THEN BEGIN
        IF (event.ENTER EQ 0) THEN BEGIN
          reset_sf_calculation_base_empty_cell_info, Event
        ENDIF
      ENDIF ELSE BEGIN
        display_sf_calculation_base_empty_cell_info, Event ;_sf_empty_cell
      ENDELSE
    END
    
    ;Scaling Factor, C= 'text field'
    WIDGET_INFO(wWidget, FIND_BY_UNAME='scaling_factor_equation_value'): BEGIN
      replot_recap_with_manual_sf, Event ;_sf_empty_cell
      check_empty_cell_recap_output_file_name, Event
    END
    
    ;recap draw
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'empty_cell_scaling_factor_base_recap_draw'): BEGIN
      IF (TAG_NAMES(event, /STRUCTURE_NAME) EQ 'WIDGET_TRACKING') $
        THEN BEGIN
        IF (event.ENTER EQ 0) THEN BEGIN
          reset_sf_calculation_base_recap_info, Event
        ENDIF
      ENDIF ELSE BEGIN
        display_sf_calculation_base_recap_info, Event ;_sf_empty_cell
      ENDELSE
    END
    
    ;cancel button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_sf_base_cancel'): BEGIN
      MapBase, Event, 'empty_cell_scaling_factor_calculation_base', 0
    END
    
    ;ok button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_sf_base_ok'): BEGIN
      ;copy A value into empty cell main base and refresh equation
      SF_value = getTextFieldValue(Event,'scaling_factor_equation_value')
      putTextFieldValue, Event, 'empty_cell_scaling_factor', $
        STRCOMPRESS(SF_value,/REMOVE_ALL), 0
      update_substrate_equation, Event ;_empty_cell
      MapBase, Event, 'empty_cell_scaling_factor_calculation_base', 0
    END
    
    ;END of Calculate Scaling Factor Base .....................................
    
    
    ;==========================================================================
    ;**REDUCE TAB -------------------------------------------------------------
    ;==========================================================================
    
    ;yes or no data background
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_background_cw_bgroup'): BEGIN
      MapBase, Event, 'background_message_uname', 0
      substrateValue = getCWBgroupValue(Event,'empty_cell_substrate_group')
      IF (isDataWithBackground(Event) EQ 1 AND $
        substrateValue EQ 0) THEN BEGIN
        focus_empty_cell_base, Event, 0
        MapBase, Event, 'empty_cell_or_data_background_base', 1
      ENDIF ELSE BEGIN
        REFreduction_CommandLineGenerator, Event
      ENDELSE
    END
    
    ;empty cell yes or no
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_substrate_group'): BEGIN
      substrateValue = getCWBgroupValue(Event,'empty_cell_substrate_group')
      IF (isDataWithBackground(Event) EQ 1 AND $
        substrateValue EQ 0) THEN BEGIN
        ;display data background message
        MapBase, Event, 'background_message_uname', 1
        SetCWBgroup, Event, 'data_background_cw_bgroup', 1
      ENDIF ELSE BEGIN
        MapBase, Event, 'background_message_uname', 0
      ENDELSE
      REFreduction_CommandLineGenerator, Event
    END
    
    ;Make up your mind base ---------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='confuse_background'): BEGIN
      ;get images files
      sImages = (*(*global).empty_cell_images)
      ;display normal data background image
      data_background_draw = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='data_background_draw')
      WIDGET_CONTROL, data_background_draw, GET_VALUE=id
      WSET, id
      image = READ_PNG(sImages.data_background)
      TV, image, 0,0,/true
      ;display normal empty cell image
      empty_cell_draw = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='empty_cell_draw')
      WIDGET_CONTROL, empty_cell_draw, GET_VALUE=id
      WSET, id
      image = READ_PNG(sImages.empty_cell)
      TV, image, 0,0,/true
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_background_draw'): BEGIN
      ;get images files
      sImages = (*(*global).empty_cell_images)
      ;display mouse over data background image
      data_background_draw = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='data_background_draw')
      WIDGET_CONTROL, data_background_draw, GET_VALUE=id
      WSET, id
      image = READ_PNG(sImages.data_background_mouse_over)
      TV, image, 0,0,/true
      ;display normal empty cell image
      empty_cell_draw = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='empty_cell_draw')
      WIDGET_CONTROL, empty_cell_draw, GET_VALUE=id
      WSET, id
      image = READ_PNG(sImages.empty_cell)
      TV, image, 0,0,/true
      
      IF (Event.press EQ 1) THEN BEGIN ;left click
        ;display mouse over data background image
        WIDGET_CONTROL, data_background_draw, GET_VALUE=id
        WSET, id
        image = READ_PNG(sImages.data_background_mouse_click)
        TV, image, 0,0,/true
        
        ;desactivate empty cell and destroy base
        WIDGET_CONTROL,/HOURGLASS
        WAIT, 0.5
        
        id = WIDGET_INFO(event.top, $
          FIND_BY_UNAME='empty_cell_substrate_group')
        WIDGET_CONTROL, id, SET_VALUE=1.0
        
        WIDGET_CONTROL,HOURGLASS=0
        
        id = WIDGET_INFO(wWidget, $
          FIND_BY_UNAME='empty_cell_or_data_background_base')
          
        REFreduction_CommandLineGenerator, event
        
        focus_empty_cell_base, Event, 1
        WIDGET_CONTROL, id, MAP=0
        
      ENDIF
      
      IF (Event.type EQ 1) THEN BEGIN ;release mouse
        ;display mouse over data background image
        WIDGET_CONTROL, data_background_draw, GET_VALUE=id
        WSET, id
        image = READ_PNG(sImages.data_background_mouse_over)
        TV, image, 0,0,/true
      ENDIF
      
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_cell_draw'): BEGIN
      ;get images files
      sImages = (*(*global).empty_cell_images)
      ;display normal data background image
      data_background_draw = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='data_background_draw')
      WIDGET_CONTROL, data_background_draw, GET_VALUE=id
      WSET, id
      image = READ_PNG(sImages.data_background)
      TV, image, 0,0,/true
      ;display empty cell mouse over image
      empty_cell_draw = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='empty_cell_draw')
      WIDGET_CONTROL, empty_cell_draw, GET_VALUE=id
      WSET, id
      image = READ_PNG(sImages.empty_cell_mouse_over)
      TV, image, 0,0,/true
      
      IF (Event.press EQ 1) THEN BEGIN
        ;display mouse over empty cellimage
        WIDGET_CONTROL, empty_cell_draw, GET_VALUE=id
        WSET, id
        image = READ_PNG(sImages.empty_cell_mouse_click)
        TV, image, 0,0,/true
        
        ;desactivate empty cell and destroy base
        WIDGET_CONTROL,/HOURGLASS
        WAIT, 0.5
        
        id = WIDGET_INFO(event.top, $
          FIND_BY_UNAME='data_background_cw_bgroup')
        WIDGET_CONTROL, id, SET_VALUE=1.0
        
        WIDGET_CONTROL,HOURGLASS=0
        
        id = WIDGET_INFO(wWidget, $
          FIND_BY_UNAME='empty_cell_or_data_background_base')
          
        REFreduction_CommandLineGenerator, event
        
        focus_empty_cell_base, Event, 1
        WIDGET_CONTROL, id, MAP=0
        
      ENDIF
      
      IF (Event.type EQ 1) THEN BEGIN
        ;display mouse over empty cell image
        WIDGET_CONTROL, empty_cell_draw, GET_VALUE=id
        WSET, id
        image = READ_PNG(sImages.empty_cell_mouse_over)
        TV, image, 0,0,/true
      ENDIF
      
    END
    
    ;yes or no normalization
    WIDGET_INFO(wWidget, FIND_BY_UNAME='yes_no_normalization_bgroup'): begin
      REFreduction_ReduceNormalizationUpdateGui, Event
    end
    
    ;Intermediate plots
    WIDGET_INFO(wWidget, FIND_BY_UNAME='intermediate_plot_cwbgroup'): begin
      REFreduction_ReduceIntermediatePlotUpdateGui, Event
    end
    
    ;Overwrite Data Instrument Geometry
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'overwrite_data_instrument_geometry_cwbgroup'): begin
      REFreduction_ReduceOverwriteDataInstrumentGeometryGui, Event
    end
    
    ;Data Instrument geometry button
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'overwrite_data_intrument_geometry_button'): begin
      REFreduction_OverwriteDataInstrumentGeometry, Event
    end
    
    ;Overwrite Norm Instrument Geometry
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'overwrite_norm_instrument_geometry_cwbgroup'): begin
      REFreduction_ReduceOverwriteNormInstrumentGeometryGui, Event
    end
    
    ;Norm Instrument geometry button
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'overwrite_norm_instrument_geometry_button'): begin
      REFreduction_OverwriteNormInstrumentGeometry, Event
    end
    
    ;Q Auto/Manual
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'q_mode_group'): begin
      ActivateOrNotAutoQmode, Event ;_GUI
      REFreduction_CommandLineGenerator, Event
    end
    
    ;output path/file
    WIDGET_INFO(wWidget, FIND_BY_UNAME='of_button'): begin
      REFreduction_DefineOutputPath, Event ;in ref_reduction_OutputPath.pro
      REFreduction_CommandLineGenerator, Event
    end
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='of_text'): begin
      REFreduction_DefineOutputFile, Event ;in ref_reduction_OutputPath.pro
      REFreduction_CommandLineGenerator, Event
    end
    
    ;Run data reduction
    WIDGET_INFO(wWidget, FIND_BY_UNAME='start_data_reduction_button'): begin
      REFreductionEventcb_ProcessingCommandLine, Event
    end
    
    ;****output command line****
    ;CL folder button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='cl_directory_button'): begin
      CL_directoryButton, Event
    end
    
    ;CL folder text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='cl_directory_text'): begin
      CL_directoryText, Event
    end
    
    ;CL file button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='cl_file_button'): begin
      CL_fileButton, Event
    end
    
    ;CL file text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='cl_file_text'): begin
      CL_fileText, Event
    end
    
    ;output cl into file
    WIDGET_INFO(wWidget, FIND_BY_UNAME='output_cl_button'): begin
      CL_outputButton, Event
    end
    
    ;Preview of the command line text box
    ;    WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_cmd_line_preview'):BEGIN
    ;        print, 'here'
    ;    END
    
    ;**************************************************************************
    ;**PLOTS TAB*
    ;*************************************************************************
    
    ;lin and log y-axis scale
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_y_axis_lin'): BEGIN
      rePlotAsciiData, Event
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_y_axis_log'): BEGIN
      rePlotAsciiData, Event
    END
    
    ;main plot
    WIDGET_INFO(wWidget, FIND_BY_UNAME='main_plot_draw'): BEGIN
    
      IF ((*global).ascii_file_load_status) THEN BEGIN ;we can interact with plot
      
        IF ((*global).plot_tab_left_click) THEN BEGIN ;moving mouse
          CURSOR, X, Y, /DEVICE, /NOWAIT
          id = WIDGET_INFO(Event.top, FIND_BY_UNAME='main_plot_draw')
          geometry = WIDGET_INFO(id,/GEOMETRY)
          xsize = geometry.draw_xsize
          ysize = geometry.draw_ysize
          IF (X LE 0) THEN RETURN
          IF (X GE xsize) THEN RETURN
          IF (Y LE 0) THEN RETURN
          IF (Y GE ysize) THEN RETURN
          
          rePlotAsciiData, Event ;_tab_plot
          CURSOR, X, Y, /DATA, /NOWAIT
          xyminmax = (*global).xyminmax
          xyminmax[2] = X
          xyminmax[3] = Y
          (*global).xyminmax = xyminmax
          plot_zoom_selection_plot_tab, Event
        ENDIF
        
        IF (event.press EQ 1) THEN BEGIN ;left click
          (*global).plot_tab_left_click = 1b
          CURSOR, X, Y, /DATA
          xyminmax = FLTARR(4)
          xyminmax[0] = X
          xyminmax[1] = Y
          (*global).xyminmax = xyminmax
        ENDIF
        
        IF (event.release EQ 1) THEN BEGIN ;release left click
          (*global).plot_tab_left_click = 0b
          (*global).old_xyminmax = (*global).xyminmax
          rePlotAsciiData, Event ;_tab_plot
        ENDIF
        
      ENDIF
      
    END
    
    ;browse button
    WIDGET_INFO(wWidget, FIND_BY_UNAME  ='plot_tab_browse_input_file_button'): BEGIN
      plot_tab_browse_button, Event
      LoadAsciiFile, Event
    END
    
    ;file name text field
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_input_file_text_field'): BEGIN
      file_name = getTextFieldValue(Event,'plot_tab_input_file_text_field')
      IF (FILE_TEST(file_name,/READ)) THEN BEGIN
        plot_tab_loading_widgets, Event, 1
      ENDIF ELSE BEGIN
        plot_tab_loading_widgets, Event, 0
      ENDELSE
    END
    
    ;PREVIEW of file
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_preview_button'): begin
      preview_ascii_file, Event
    end
    
    ;Load button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_load_file_button'): BEGIN
      LoadAsciiFile, Event
    END
    
    ;REFRESH plot
    WIDGET_INFO(wWidget, FIND_BY_UNAME='refresh_plot_button'): begin
      rePlotAsciiData, Event
    end
    
    ;**************************************************************************
    ; BATCH MODE TAB
    ;**************************************************************************
    
    ;;Main table
    WIDGET_INFO(wWidget, FIND_BY_UNAME='batch_table_widget'): begin
      status = 0
      DataNormFieldInput, Event, status ;_BatchDataNorm
      IF (status) THEN BEGIN
        BatchTab_WidgetTable, Event ;in ref_reduction_BatchTab.pro
      ENDIF
    END
    
    ;;Activate or not
    WIDGET_INFO(wWidget, FIND_BY_UNAME='batch_run_active_status'): begin
      BatchTab_ActivateRow, Event ;in ref_reduction_BatchTab.pro
    end
    
    ;;Change Data Run number
    WIDGET_INFO(wWidget, FIND_BY_UNAME='batch_data_run_field_status'): begin
      WIDGET_CONTROL, /hourglass
      BatchTab_ChangeDataNormRunNumber, Event
      SaveDataNormInputValues, Event ;_batchDataNorm
      WIDGET_CONTROL, hourglass=0
    end
    
    ;;Repopulate GUI
    WIDGET_INFO(wWidget, FIND_BY_UNAME='repopulate_gui'): begin
      DataNormFieldInput, Event
      RepopulateGUI, Event    ;_BatchRepopulateGui
    end
    
    ;;Processing Base YES (continue)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='pro_yes'): begin
      WIDGET_CONTROL, /hourglass
      BatchTab_ContinueProcessing, Event
      WIDGET_CONTROL, hourglass=0
    end
    
    ;;Processing Base NO (continue)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='pro_no'): begin
      WIDGET_CONTROL, /hourglass
      BatchTab_StopProcessing, Event
      WIDGET_CONTROL, /hourglass
    end
    
    ;;Change Normalization Run number
    WIDGET_INFO(wWidget, FIND_BY_UNAME='batch_norm_run_field_status'): begin
      WIDGET_CONTROL, /hourglass
      BatchTab_ChangeDataNormRunNumber, Event
      SaveDataNormInputValues, Event ;_batchDataNorm
      WIDGET_CONTROL, hourglass=0
    end
    
    ;;Move Up Selection
    WIDGET_INFO(wWidget, FIND_BY_UNAME='move_up_selection_button'): begin
      BatchTab_MoveUpSelection, Event
    end
    
    ;;Move Down Selection
    WIDGET_INFO(wWidget, FIND_BY_UNAME='move_down_selection_button'): begin
      BatchTab_MoveDownSelection, Event
    end
    
    ;;Delete Selection
    WIDGET_INFO(wWidget, FIND_BY_UNAME='delete_selection_button'): begin
      BatchTab_DeleteSelection, Event
      SaveDataNormInputValues, Event
    end
    
    ;;Delete Active
    WIDGET_INFO(wWidget, FIND_BY_UNAME='delete_active_button'): begin
      BatchTab_WarningDeleteActive, Event
      SaveDataNormInputValues, Event
    end
    
    ;;Run Active live
    WIDGET_INFO(wWidget, FIND_BY_UNAME='run_active_button'): begin
      BatchTab_RunActive, Event
    end
    
    ;;Run Active in Background
    WIDGET_INFO(wWidget, FIND_BY_UNAME='run_active_background_button'): begin
      BatchTab_RunActiveBackground, Event
    end
    
    ;;Load Batch File
    WIDGET_INFO(wWidget, FIND_BY_UNAME='load_batch_button'): begin
      BatchTab_LoadBatchFile, Event
      SaveDataNormInputValues, Event
    end
    
    ;;Refresh Batch File
    WIDGET_INFO(wWidget, FIND_BY_UNAME='refresh_batch_file_button'): begin
      BatchTab_ReloadBatchFile, Event ;_tab
      SaveDataNormInputValues, Event
    end
    
    ;;Launch REFscale
    WIDGET_INFO(wWidget, FIND_BY_UNAME='launch_refscale_button'): BEGIN
      BatchTab_LaunchREFscale, Event ;_BatchTab
    end
    
    ;;Browse for path
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_as_path'): begin
      BatchTab_BrowsePath, Event
    end
    
    ;;Save set of command lines
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_as_file_button'): begin
      BatchTab_SaveCommands, Event
    end
    
    ;;Reach each time something change in the save_as text_field (name of
    ;;the batch file)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_as_file_name'): begin
      CheckRefreshButton, Event
    end
    
    ;**LOG_BOOK TAB**
    
    ;send log book button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='send_log_book_button'): begin
      RefReduction_LogBookInterface, Event
    end
    
    ;DATA runs widget_text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_data_runs_text_field'): begin
      REFreduction_CommandLineGenerator, Event
    end
    
    ;NORM runs widget_text
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='reduce_normalization_runs_text_field'): begin
      REFreduction_CommandLineGenerator, Event
    end
    
    ELSE:
    
  ENDCASE
  
  ;**REDUCE TAB**
  ;command line generator
  SWITCH Event.id OF
    WIDGET_INFO(wWidget, FIND_BY_UNAME='yes_no_normalization_bgroup'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization_background_cw_bgroup'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization_pola_state'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='intermediate_plot_cwbgroup'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='intermediate_plot_list'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='detector_value_text_field'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='detector_error_text_field'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='detector_units_b_group'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='q_min_text_field'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tof_cutting_min'): 
    WIDGET_INFO(wWidget, FIND_BY_UNAME='tof_cutting_max'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_data_tof_units_micros'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='reduce_data_tof_units_ms'): 
    WIDGET_INFO(wWidget, FIND_BY_UNAME='q_max_text_field'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='q_width_text_field'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='q_scale_b_group'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='filtering_data_cwbgroup'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='delta_t_over_t_cwbgroup'):
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='overwrite_data_instrument_geometry_cwbgroup'):
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'overwrite_norm_instrument_geometry_cwbgroup'): begin
      REFreduction_CommandLineGenerator, Event
    end
    Else:
  ENDSWITCH
  
  ;RESCALE DATA TAB
  SWITCH Event.id OF
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_rescale_xmin_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_rescale_xmax_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_rescale_ymin_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_rescale_ymax_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_rescale_zmin_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_rescale_zmax_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_rescale_z_droplist')  : BEGIN
      REFreduction_RescaleDataPlot, Event
      ReplotAllSelection, Event
    END
    ELSE:
  ENDSWITCH
  
  ;RESCALE NORMALIZATION TAB
  SWITCH Event.id OF
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization_rescale_xmin_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization_rescale_xmax_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization_rescale_ymin_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization_rescale_ymax_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization_rescale_zmin_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization_rescale_zmax_cwfield'):
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization_rescale_z_droplist'): begin
      REFreduction_RescaleNormalizationPlot, Event
      ReplotNormAllSelection, Event
    end
    Else:
  ENDSWITCH
  
  ;1D_3D DATA
  SWITCH Event.id OF
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_x_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_x_axis_scale'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_y_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_y_axis_scale'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_z_axis_min_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_z_axis_max_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_xy_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_zz_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data1d_z_axis_scale'): begin
      REFreduction_RescaleData1D3DPlot, Event
    end
    Else:
  ENDSWITCH
  
  ;1D_3D NORM
  SWITCH Event.id OF
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_x_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization1d_x_axis_scale'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization1d_y_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization1d_y_axis_scale'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization1d_z_axis_min_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization1d_z_axis_max_cwfield'):
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_xy_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization1d_zz_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization1d_z_axis_scale'): begin
      REFreduction_RescaleNorm1D3DPlot, Event
    end
    Else:
  ENDSWITCH
  
  ;2D_3D DATA
  SWITCH Event.id OF
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_x_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_x_axis_scale'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_y_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_y_axis_scale'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_z_axis_min_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_z_axis_max_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_xy_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_zz_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data2d_z_axis_scale'): begin
      REFreduction_RescaleData2D3DPlot, Event
    end
    Else:
  ENDSWITCH
  
  ;2D_3D NORMALIZATION
  SWITCH Event.id OF
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_x_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization2d_x_axis_scale'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization2d_y_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization2d_y_axis_scale'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization2d_z_axis_min_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization2d_z_axis_max_cwfield'):
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_xy_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='normalization2d_zz_axis_angle_cwfield'):
    WIDGET_INFO(wWidget, FIND_BY_UNAME='normalization2d_z_axis_scale'): begin
      REFreduction_RescaleNormalization2D3DPlot, Event
    end
    Else:
  ENDSWITCH
  
END
