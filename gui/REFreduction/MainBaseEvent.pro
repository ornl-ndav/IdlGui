PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end

    widget_info(wWidget, FIND_BY_UNAME='main_tab'): begin
        tab_event, Event
    end

;Instrument Selection
    widget_info(wWidget, FIND_BY_UNAME='instrument_selection_validate_button'): begin
       REFreductionEventcb_InstrumentSelected, Event
    end
    
;**LOAD TAB**DATA**

;LOAD DATA file
    widget_info(wWidget, FIND_BY_UNAME='load_data_run_number_text_field'): begin
        REFreductionEventcb_LoadAndPlotDataFile, Event
    end

;##In list of nexus base##
;droplist
    widget_info(wWidget, FIND_BY_UNAME='data_list_nexus_droplist'): begin
        REFreductionEventcb_DisplayDataNxsummary, Event
    end
    
;ok button
    widget_info(wWidget, FIND_BY_UNAME='data_list_nexus_load_button'): begin
        REFreductionEventcb_LoadListOfDataNexus, Event
    end

;cancel button
    widget_info(wWidget, FIND_BY_UNAME='data_list_nexus_cancel_button'): begin
        REFreductionEventcb_CancelListOfDataNexus, Event
    end

;****1D PLOT TAB**
;1D_2D plot of DATA
    widget_info(wWidget, FIND_BY_UNAME='load_data_D_draw'): begin
        if ((*global).DataNeXusFound) then begin ;only if there is a NeXus loaded
            if( Event.type EQ 0 )then begin
                if (Event.press EQ 1) then $
                  REFreduction_DataSelectionPressLeft, Event ;left button
                if (Event.press EQ 4) then $
                  REFreduction_DataselectionPressRight, Event ;right button
            endif
            if (Event.type EQ 1) then $ ;release
              REFreduction_DataSelectionRelease, Event
            if (Event.type EQ 2) then $ ;move
              REFreduction_DataSelectionMove, Event
        endif
    end

;zoom and nxsummary tab
    widget_info(wWidget, FIND_BY_UNAME='data_nxsummary_zoom_tab'): begin
        REFreduction_DataNxsummaryZoomTab, Event
    end

    widget_info(wWidget, FIND_BY_UNAME='data_zoom_scale_cwfield'): begin
        REFreduction_ZoomRescaleData, Event
    end

;Background Ymin and Ymax
    widget_info(wWidget, FIND_BY_UNAME='data_d_selection_background_ymin_cw_field'): begin
        REFreduction_DataBackgroundPeakSelection, Event
    end

    widget_info(wWidget, FIND_BY_UNAME='data_d_selection_background_ymax_cw_field'): begin
        REFreduction_DataBackgroundPeakSelection, Event
    end

;Peak Ymin and Ymax
    widget_info(wWidget, FIND_BY_UNAME='data_d_selection_peak_ymin_cw_field'): begin
        REFreduction_DataBackgroundPeakSelection, Event
    end

    widget_info(wWidget, FIND_BY_UNAME='data_d_selection_peak_ymax_cw_field'): begin
        REFreduction_DataBackgroundPeakSelection, Event
    end

;SAVE Background Selection into a file
    widget_info(wWidget, FIND_BY_UNAME='data_roi_save_button'): begin
        REFreduction_CreateDataBackgroundROIFile, Event
    end

;LOAD background selection
    widget_info(wWidget, FIND_BY_UNAME='data_roi_load_button'): begin
        REFreduction_LoadDataBackgroundSelection, Event
    end

;CONTRAST TAB
;Contrast editor of data 1D tab
    widget_info(wWidget, FIND_BY_UNAME='data_contrast_droplist'): begin
        REFreductionEventcb_DataContrastEditor, Event
    end

;Reset Contrast Editor
    widget_info(wWidget, FIND_BY_UNAME='data_reset_contrast_button'): begin
        REFreductionEventcb_DataResetContrastEditor, Event
    end

;bottom slider
    widget_info(wWidget, FIND_BY_UNAME='data_contrast_bottom_slider'): begin
        REFreductionEventcb_DataContrastBottomSlider, Event
    end
   
;Number color slider
    widget_info(wWidget, FIND_BY_UNAME='data_contrast_number_slider'): begin
        REFreductionEventcb_DataContrastNumberSlider, Event
    end
        
;RESCALE DATA TAB
;reset x axis
    widget_info(wWidget, FIND_BY_UNAME='data_reset_xaxis_button'): begin
        REFreduction_ResetXDataPlot, Event
    end

;reset y axis
    widget_info(wWidget, FIND_BY_UNAME='data_reset_yaxis_button'): begin
        REFreduction_ResetYDataPlot, Event
    end

;reset z axis
    widget_info(wWidget, FIND_BY_UNAME='data_reset_zaxis_button'): begin
        REFreduction_ResetZDataPlot, Event
    end

;reset all axis
    widget_info(wWidget, FIND_BY_UNAME='data_full_reset_button'): begin
        REFreduction_ResetFullDataPlot, Event
    end

;############################### 1D_3D PLOT TAB ################################
;reset z-axis
    widget_info(wWidget, FIND_BY_UNAME='data1d_z_axis_reset_button'): begin
        REFreduction_ResetData1D3DPlotZaxis, Event
    end

;reset xy_axis
    widget_info(wWidget, FIND_BY_UNAME='data1d_xy_axis_reset_button'): begin
        REFreduction_ResetData1D3DPlotXYaxis, Event
    end

;reset zz_axis
    widget_info(wWidget, FIND_BY_UNAME='data1d_zz_axis_reset_button'): begin
        REFreduction_ResetData1D3DPlotZZaxis, Event
    end

;Full reset
    widget_info(wWidget, FIND_BY_UNAME='data1d_full_reset_button'): begin
        REFreduction_FullResetData1D3DPlot_OrientationReset, Event
    end

;switch to manual mode
    widget_info(wWidget, FIND_BY_UNAME='data1d_switch_to_manual_mode_button'): begin
        REFreduction_SwitchToManualData1DMode, Event
    end

;Rotation interface (google)
;switch to auto mode
    widget_info(wWidget, FIND_BY_UNAME='data1d_switch_to_auto_mode_button'): begin
        REFreduction_SwitchToAutoData1DMode, Event
    end

;xy-axis MMM
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_xy_axis_mmm_button'): begin
        REFreduction_RotateData1D3DPlot_Orientation, Event, 'xy-axis',-10
    end
;xy-axis MM
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_xy_axis_mm_button'): begin
        REFreduction_RotateData1D3DPlot_Orientation, Event, 'xy-axis',-5
    end
;xy_axis M
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_xy_axis_m_button'): begin
        REFreduction_RotateData1D3DPlot_Orientation, Event, 'xy-axis',-2
    end
;xy_axis P
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_xy_axis_p_button'): begin
        REFreduction_RotateData1D3DPlot_Orientation, Event, 'xy-axis',2
    end
;xy-axis PP
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_xy_axis_pp_button'): begin
        REFreduction_RotateData1D3DPlot_Orientation, Event, 'xy-axis',5
    end
;xy-axis PPP
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_xy_axis_ppp_button'): begin
        REFreduction_RotateData1D3DPlot_Orientation, Event, 'xy-axis',+10
    end

;z-axis MMM
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_z_axis_mmm_button'): begin
        REFreduction_RotateData1D3DPlot_Orientation, Event, 'z-axis',-10
    end
;z-axis MM
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_z_axis_mm_button'): begin
        REFreduction_RotateData1D3DPlot_Orientation, Event, 'z-axis',-5
    end
;z_axis M
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_z_axis_m_button'): begin
        REFreduction_RotateData1D3DPlot_Orientation, Event, 'z-axis',-2
    end
;z_axis P
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_z_axis_p_button'): begin
        REFreduction_RotateData1D3DPlot_Orientation, Event, 'z-axis',2
    end
;z-axis PP
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_z_axis_pp_button'): begin
        REFreduction_RotateData1D3DPlot_Orientation, Event, 'z-axis',5
    end
;z-axis PPP
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_z_axis_ppp_button'): begin
        REFreduction_RotateData1D3DPlot_Orientation, Event, 'z-axis',10
    end

;reset
    widget_info(wWidget, FIND_BY_UNAME='data1d_google_reset_button'): begin
        REFreduction_ResetData1D3DPlot_OrientationReset, Event
    end

;1d_3d loadct
    widget_info(wWidget, FIND_BY_UNAME='data_loadct_1d_3d_droplist'): begin
        CurrentLoadctIndex = getDropListSelectedIndex(Event, 'data_loadct_1d_3d_droplist')
        PrevLoadctIndex = (*global).PrevData1d3dContrastDropList
        if (CurrentLoadctIndex NE PrevLoadctIndex) then begin
            REFreduction_RescaleData1D3DPlot, Event
            (*global).PrevData1d3dContrastDropList = CurrentLoadctIndex
        endif
    end

;############################### 2D_3D PLOT TAB ################################
;reset z-axis
    widget_info(wWidget, FIND_BY_UNAME='data2d_z_axis_reset_button'): begin
        REFreduction_ResetData2D3DPlotZaxis, Event
    end

;reset xy_axis
    widget_info(wWidget, FIND_BY_UNAME='data2d_xy_axis_reset_button'): begin
        REFreduction_ResetData2D3DPlotXYaxis, Event
    end

;reset zz_axis
    widget_info(wWidget, FIND_BY_UNAME='data2d_zz_axis_reset_button'): begin
        REFreduction_ResetData2D3DPlotZZaxis, Event
    end

;Full reset
    widget_info(wWidget, FIND_BY_UNAME='data2d_full_reset_button'): begin
        REFreduction_FullResetData2D3DPlot_OrientationReset, Event
    end

;switch to manual mode
    widget_info(wWidget, FIND_BY_UNAME='data2d_switch_to_manual_mode_button'): begin
        REFreduction_SwitchToManualData2DMode, Event
    end

;Rotation interface (google)
;switch to auto mode
    widget_info(wWidget, FIND_BY_UNAME='data2d_switch_to_auto_mode_button'): begin
        REFreduction_SwitchToAutoData2DMode, Event
    end

;xy-axis MMM
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_xy_axis_mmm_button'): begin
        REFreduction_RotateData2D3DPlot_Orientation, Event, 'xy-axis',-10
    end
;xy-axis MM
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_xy_axis_mm_button'): begin
        REFreduction_RotateData2D3DPlot_Orientation, Event, 'xy-axis',-5
    end
;xy_axis M
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_xy_axis_m_button'): begin
        REFreduction_RotateData2D3DPlot_Orientation, Event, 'xy-axis',-2
    end
;xy_axis P
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_xy_axis_p_button'): begin
        REFreduction_RotateData2D3DPlot_Orientation, Event, 'xy-axis',2
    end
;xy-axis PP
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_xy_axis_pp_button'): begin
        REFreduction_RotateData2D3DPlot_Orientation, Event, 'xy-axis',5
    end
;xy-axis PPP
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_xy_axis_ppp_button'): begin
        REFreduction_RotateData2D3DPlot_Orientation, Event, 'xy-axis',+10
    end

;z-axis MMM
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_z_axis_mmm_button'): begin
        REFreduction_RotateData2D3DPlot_Orientation, Event, 'z-axis',-10
    end
;z-axis MM
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_z_axis_mm_button'): begin
        REFreduction_RotateData2D3DPlot_Orientation, Event, 'z-axis',-5
    end
;z_axis M
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_z_axis_m_button'): begin
        REFreduction_RotateData2D3DPlot_Orientation, Event, 'z-axis',-2
    end
;z_axis P
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_z_axis_p_button'): begin
        REFreduction_RotateData2D3DPlot_Orientation, Event, 'z-axis',2
    end
;z-axis PP
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_z_axis_pp_button'): begin
        REFreduction_RotateData2D3DPlot_Orientation, Event, 'z-axis',5
    end
;z-axis PPP
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_z_axis_ppp_button'): begin
        REFreduction_RotateData2D3DPlot_Orientation, Event, 'z-axis',10
    end

;reset
    widget_info(wWidget, FIND_BY_UNAME='data2d_google_reset_button'): begin
        REFreduction_ResetData2D3DPlot_OrientationReset, Event
    end

;1d_3d loadct
    widget_info(wWidget, FIND_BY_UNAME='data_loadct_2d_3d_droplist'): begin
        CurrentLoadctIndex = getDropListSelectedIndex(Event, 'data_loadct_2d_3d_droplist')
        PrevLoadctIndex = (*global).PrevData2d3dContrastDropList
        if (CurrentLoadctIndex NE PrevLoadctIndex) then begin
            REFreduction_RescaleData2D3DPlot, Event
            (*global).PrevData2d3dContrastDropList = CurrentLoadctIndex
        endif
    end


;**LOAD TAB**NORMALIZATION**

;LOAD NORMALIZATION file
    widget_info(wWidget, FIND_BY_UNAME='load_normalization_run_number_text_field'): begin
        REFreductionEventcb_LoadAndPlotNormFile, Event
    end

;##In list of nexus base##
;droplist
    widget_info(wWidget, FIND_BY_UNAME='normalization_list_nexus_droplist'): begin
        REFreductionEventcb_DisplayNormNxsummary, Event
    end
    
;ok button
    widget_info(wWidget, FIND_BY_UNAME='norm_list_nexus_load_button'): begin
        REFreductionEventcb_LoadListOfNormNexus, Event
    end

;cancel button
    widget_info(wWidget, FIND_BY_UNAME='norm_list_nexus_cancel_button'): begin
        REFreductionEventcb_CancelListOfNormNexus, Event
    end

;****1D PLOT TAB**
;1D plot of NORM
    widget_info(wWidget, FIND_BY_UNAME='load_normalization_D_draw'): begin
        if ((*global).NormNeXusFound) then begin ;only if there is a NeXus loaded
            if( Event.type EQ 0 )then begin
                if (Event.press EQ 1) then $
                  REFreduction_NormSelectionPressLeft, Event ;left button
                if (Event.press EQ 4) then $
                  REFreduction_NormselectionPressRight, Event ;right button
            endif
            if (Event.type EQ 1) then $ ;release
              REFreduction_NormSelectionRelease, Event
            if (Event.type EQ 2) then $ ;move
          REFreduction_NormSelectionMove, Event
        endif
    end

    ;zoom and nxsummary tab
    widget_info(wWidget, FIND_BY_UNAME='normalization_nxsummary_zoom_tab'): begin
        REFreduction_NormNxsummaryZoomTab, Event
    end

    widget_info(wWidget, FIND_BY_UNAME='normalization_zoom_scale_cwfield'): begin
        REFreduction_ZoomRescaleNormalization, Event
    end

;Background Ymin and Ymax
    widget_info(wWidget, $
                FIND_BY_UNAME='normalization_d_selection_background_ymin_cw_field'): begin
        REFreduction_NormBackgroundPeakSelection, Event
    end

    widget_info(wWidget, $
                FIND_BY_UNAME='normalization_d_selection_background_ymax_cw_field'): begin
        REFreduction_NormBackgroundPeakSelection, Event
    end

;Peak Ymin and Ymax
    widget_info(wWidget, FIND_BY_UNAME='normalization_d_selection_peak_ymin_cw_field'): begin
        REFreduction_NormBackgroundPeakSelection, Event
    end

    widget_info(wWidget, FIND_BY_UNAME='normalization_d_selection_peak_ymax_cw_field'): begin
        REFreduction_NormBackgroundPeakSelection, Event
    end

;SAVE Background Selection into a file
    widget_info(wWidget, FIND_BY_UNAME='normalization_roi_save_button'): begin
        REFreduction_CreateNormBackgroundROIFile, Event
    end

;LOAD background selection
    widget_info(wWidget, FIND_BY_UNAME='normalization_roi_load_button'): begin
        REFreduction_LoadNormBackgroundSelection, Event
    end

;CONTRAST TAB
;Contrast editor of data 1D tab
    widget_info(wWidget, FIND_BY_UNAME='normalization_contrast_button'): begin
        REFreductionEventcb_NormContrastEditor, Event
    end

;Reset Contrast Editor
    widget_info(wWidget, FIND_BY_UNAME='normalization_reset_contrast_button'): begin
        REFreductionEventcb_NormResetContrastEditor, Event
    end

;bottom slider
    widget_info(wWidget, FIND_BY_UNAME='normalization_contrast_bottom_slider'): begin
        REFreductionEventcb_NormContrastBottomSlider, Event
    end
   
;Number color slider
    widget_info(wWidget, FIND_BY_UNAME='normalization_contrast_number_slider'): begin
        REFreductionEventcb_NormContrastNumberSlider, Event
    end

;RESCALE DATA TAB
;reset x axis
    widget_info(wWidget, FIND_BY_UNAME='normalization_reset_xaxis_button'): begin
        REFreduction_ResetXNormPlot, Event
    end

;reset y axis
    widget_info(wWidget, FIND_BY_UNAME='normalization_reset_yaxis_button'): begin
        REFreduction_ResetYNormPlot, Event
    end

;reset z axis
    widget_info(wWidget, FIND_BY_UNAME='normalization_reset_zaxis_button'): begin
        REFreduction_ResetZNormPlot, Event
    end

;reset all axis
    widget_info(wWidget, FIND_BY_UNAME='normalization_full_reset_button'): begin
        REFreduction_ResetFullNormPlot, Event
    end

;****1D_3D PLOT TAB**
;reset z-axis
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_z_axis_reset_button'): begin
        REFreduction_ResetNorm1D3DPlotZaxis, Event
    end

;reset xy-axis
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_xy_axis_reset_button'): begin
        REFreduction_ResetNorm1D3DPlotXYaxis, Event
    end
    
;reset zz-axis
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_zz_axis_reset_button'): begin
        REFreduction_ResetNorm1D3DPlotZZaxis, Event
    end

;Full reset
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_full_reset_button'): begin
        REFreduction_FullResetNorm1D3DPlot_OrientationReset, Event
    end

;Rotation interface (google)
;xy-axis MMM
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_xy_axis_mmm_button'): begin
        REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'xy-axis',-10
    end
;xy-axis MM
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_xy_axis_mm_button'): begin
        REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'xy-axis',-5
    end
;xy_axis M
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_xy_axis_m_button'): begin
        REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'xy-axis',-2
    end
;xy_axis P
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_xy_axis_p_button'): begin
        REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'xy-axis',2
    end
;xy-axis PP
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_xy_axis_pp_button'): begin
        REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'xy-axis',5
    end
;xy-axis PPP
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_xy_axis_ppp_button'): begin
        REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'xy-axis',+10
    end

;z-axis MMM
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_z_axis_mmm_button'): begin
        REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'z-axis',-10
    end
;z-axis MM
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_z_axis_mm_button'): begin
        REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'z-axis',-5
    end
;z_axis M
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_z_axis_m_button'): begin
        REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'z-axis',-2
    end
;z_axis P
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_z_axis_p_button'): begin
        REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'z-axis',2
    end
;z-axis PP
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_z_axis_pp_button'): begin
        REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'z-axis',5
    end
;z-axis PPP
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_z_axis_ppp_button'): begin
        REFreduction_RotateNorm1D3DPlot_Orientation, Event, 'z-axis',10
    end

;reset
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_google_reset_button'): begin
        REFreduction_ResetNorm1D3DPlot_OrientationReset, Event
    end

;1d_3d loadct
    widget_info(wWidget, FIND_BY_UNAME='normalization_loadct_1d_3d_droplist'): begin
        CurrentLoadctIndex = $
          getDropListSelectedIndex(Event, $
                                   'normalization_loadct_1d_3d_droplist')
        PrevLoadctIndex = (*global).PrevNorm1d3dContrastDropList
        if (CurrentLoadctIndex NE PrevLoadctIndex) then begin
            REFreduction_RescaleNorm1D3DPlot, Event
            (*global).PrevNorm1d3dContrastDropList = CurrentLoadctIndex
        endif
    end

;############################### 2D_3D PLOT TAB ################################
;reset z-axis
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_z_axis_reset_button'): begin
        REFreduction_ResetNormalization2D3DPlotZaxis, Event
    end

;reset xy_axis
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_xy_axis_reset_button'): begin
        REFreduction_ResetNormalization2D3DPlotXYaxis, Event
    end

;reset zz_axis
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_zz_axis_reset_button'): begin
        REFreduction_ResetNormalization2D3DPlotZZaxis, Event
    end

;Full reset
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_full_reset_button'): begin
        REFreduction_FullResetNormalization2D3DPlot_OrientationReset, Event
    end

;Rotation interface (google)
;xy-axis MMM
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_xy_axis_mmm_button'): begin
        REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'xy-axis',-10
    end
;xy-axis MM
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_xy_axis_mm_button'): begin
        REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'xy-axis',-5
    end
;xy_axis M
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_xy_axis_m_button'): begin
        REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'xy-axis',-2
    end
;xy_axis P
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_xy_axis_p_button'): begin
        REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'xy-axis',2
    end
;xy-axis PP
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_xy_axis_pp_button'): begin
        REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'xy-axis',5
    end
;xy-axis PPP
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_xy_axis_ppp_button'): begin
        REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'xy-axis',+10
    end

;z-axis MMM
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_z_axis_mmm_button'): begin
        REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'z-axis',-10
    end
;z-axis MM
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_z_axis_mm_button'): begin
        REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'z-axis',-5
    end
;z_axis M
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_z_axis_m_button'): begin
        REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'z-axis',-2
    end
;z_axis P
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_z_axis_p_button'): begin
        REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'z-axis',2
    end
;z-axis PP
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_z_axis_pp_button'): begin
        REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'z-axis',5
    end
;z-axis PPP
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_z_axis_ppp_button'): begin
        REFreduction_RotateNormalization2D3DPlot_Orientation, Event, 'z-axis',10
    end

;reset
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_google_reset_button'): begin
        REFreduction_ResetNormalization2D3DPlot_OrientationReset, Event
    end

;2d_3d loadct
    widget_info(wWidget, FIND_BY_UNAME='normalization_loadct_2d_3d_droplist'): begin
        CurrentLoadctIndex = getDropListSelectedIndex(Event, $
                                                      'normalization_loadct_2d_3d_droplist')
        PrevLoadctIndex = (*global).PrevNorm2d3dContrastDropList
        if (CurrentLoadctIndex NE PrevLoadctIndex) then begin
            REFreduction_RescaleNormalization2D3DPlot, Event
            (*global).PrevNorm2d3dContrastDropList = CurrentLoadctIndex
        endif
    end

;**REDUCE TAB**
    ;yes or no normalization
    widget_info(wWidget, FIND_BY_UNAME='yes_no_normalization_bgroup'): begin
        REFreduction_ReduceNormalizationUpdateGui, Event
    end

    ;Intermediate plots
    widget_info(wWidget, FIND_BY_UNAME='intermediate_plot_cwbgroup'): begin
        REFreduction_ReduceIntermediatePlotUpdateGui, Event
    end

    ;Overwrite Instrument Geometry
    widget_info(wWidget, FIND_BY_UNAME='overwrite_instrument_geometry_cwbgroup'): begin
        REFreduction_ReduceOverwriteInstrumentGeometryGui, Event
    end

    ;Instrument geometry button
    widget_info(wWidget, FIND_BY_UNAME='overwrite_intrument_geometry_button'): begin
        REFreduction_OverwriteInstrumentGeometry, Event
    end

    ;Run data reduction
    widget_info(wWidget, FIND_BY_UNAME='start_data_reduction_button'): begin
        REFreductionEventcb_ProcessingCommandLine, Event
    end

;**PLOTS TAB**

    ;droplist of plots to plot
    widget_info(wWidget, FIND_BY_UNAME='plots_droplist'): begin
         RefReduction_PlotMainIntermediateFiles, Event
    end
    
;**LOG_BOOK TAB**

    ;send log book button
    widget_info(wWidget, FIND_BY_UNAME='send_log_book_button'): begin
         RefReduction_LogBookInterface, Event
    end

;**SETTINGS TAB**

    ELSE:
    
ENDCASE


;**REDUCE TAB**
;command line generator
SWITCH Event.id OF
    widget_info(wWidget, FIND_BY_UNAME='reduce_data_runs_text_field'): 
    widget_info(wWidget, FIND_BY_UNAME='data_background_cw_bgroup'): 
    widget_info(wWidget, FIND_BY_UNAME='yes_no_normalization_bgroup'): 
    widget_info(wWidget, FIND_BY_UNAME='reduce_normalization_runs_text_field'):     
    widget_info(wWidget, FIND_BY_UNAME='normalization_background_cw_bgroup'): 
    widget_info(wWidget, FIND_BY_UNAME='intermediate_plot_cwbgroup'): 
    widget_info(wWidget, FIND_BY_UNAME='intermediate_plot_list'): 
    widget_info(wWidget, FIND_BY_UNAME='detector_value_text_field'): 
    widget_info(wWidget, FIND_BY_UNAME='detector_error_text_field'): 
    widget_info(wWidget, FIND_BY_UNAME='detector_units_b_group'): 
    widget_info(wWidget, FIND_BY_UNAME='q_min_text_field'): 
    widget_info(wWidget, FIND_BY_UNAME='q_max_text_field'): 
    widget_info(wWidget, FIND_BY_UNAME='q_width_text_field'): 
    widget_info(wWidget, FIND_BY_UNAME='q_scale_b_group'): 
    widget_info(wWidget, FIND_BY_UNAME='filtering_data_cwbgroup'): 
    widget_info(wWidget, FIND_BY_UNAME='delta_t_over_t_cwbgroup'): 
    widget_info(wWidget, FIND_BY_UNAME='overwrite_instrument_geometry_cwbgroup'): begin
        REFreduction_CommandLineGenerator, Event
    end
    Else:
ENDSWITCH

;RESCALE DATA TAB
SWITCH Event.id OF
    widget_info(wWidget, FIND_BY_UNAME='data_rescale_xmin_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='data_rescale_xmax_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='data_rescale_x_droplist'): 
    widget_info(wWidget, FIND_BY_UNAME='data_rescale_ymin_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='data_rescale_ymax_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='data_rescale_zmin_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='data_rescale_zmax_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='data_rescale_z_droplist'): begin
        REFreduction_RescaleDataPlot, Event
    end
    Else:
ENDSWITCH

;RESCALE NORMALIZATION TAB
SWITCH Event.id OF
    widget_info(wWidget, FIND_BY_UNAME='normalization_rescale_xmin_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='normalization_rescale_xmax_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='normalization_rescale_x_droplist'): 
    widget_info(wWidget, FIND_BY_UNAME='normalization_rescale_ymin_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='normalization_rescale_ymax_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='normalization_rescale_zmin_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='normalization_rescale_zmax_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='normalization_rescale_z_droplist'): begin
        REFreduction_RescaleNormalizationPlot, Event
    end
    Else:
ENDSWITCH

;1D_3D DATA
SWITCH Event.id OF
    widget_info(wWidget, FIND_BY_UNAME='data1d_x_axis_angle_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='data1d_x_axis_scale'): 
    widget_info(wWidget, FIND_BY_UNAME='data1d_y_axis_angle_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='data1d_y_axis_scale'):
    widget_info(wWidget, FIND_BY_UNAME='data1d_z_axis_min_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='data1d_z_axis_max_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='data1d_xy_axis_angle_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='data1d_zz_axis_angle_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='data1d_z_axis_scale'): begin
        REFreduction_RescaleData1D3DPlot, Event
    end
    Else:
ENDSWITCH

;1D_3D NORM
SWITCH Event.id OF
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_x_axis_angle_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_x_axis_scale'): 
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_y_axis_angle_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_y_axis_scale'):
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_z_axis_min_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_z_axis_max_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_xy_axis_angle_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_zz_axis_angle_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='normalization1d_z_axis_scale'): begin
        REFreduction_RescaleNorm1D3DPlot, Event
    end
    Else:
ENDSWITCH

;2D_3D DATA
SWITCH Event.id OF
    widget_info(wWidget, FIND_BY_UNAME='data2d_x_axis_angle_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='data2d_x_axis_scale'): 
    widget_info(wWidget, FIND_BY_UNAME='data2d_y_axis_angle_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='data2d_y_axis_scale'):
    widget_info(wWidget, FIND_BY_UNAME='data2d_z_axis_min_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='data2d_z_axis_max_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='data2d_xy_axis_angle_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='data2d_zz_axis_angle_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='data2d_z_axis_scale'): begin
        REFreduction_RescaleData2D3DPlot, Event
    end
    Else:
ENDSWITCH

;2D_3D NORMALIZATION
SWITCH Event.id OF
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_x_axis_angle_cwfield'): 
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_x_axis_scale'): 
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_y_axis_angle_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_y_axis_scale'):
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_z_axis_min_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_z_axis_max_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_xy_axis_angle_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_zz_axis_angle_cwfield'):
    widget_info(wWidget, FIND_BY_UNAME='normalization2d_z_axis_scale'): begin
        REFreduction_RescaleNormalization2D3DPlot, Event
    end
    Else:
ENDSWITCH

END
