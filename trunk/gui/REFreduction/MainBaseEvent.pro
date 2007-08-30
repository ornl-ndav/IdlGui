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

;****1D PLOT TAB**
;1D plot of DATA
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

;**LOAD TAB**NORMALIZATION**

;LOAD NORMALIZATION file
    widget_info(wWidget, FIND_BY_UNAME='load_normalization_run_number_text_field'): begin
        REFreductionEventcb_LoadAndPlotNormalizationFile, Event
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

;Background Ymin and Ymax
    widget_info(wWidget, FIND_BY_UNAME='normalization_d_selection_background_ymin_cw_field'): begin
        REFreduction_NormBackgroundPeakSelection, Event
    end

    widget_info(wWidget, FIND_BY_UNAME='normalization_d_selection_background_ymax_cw_field'): begin
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

END
