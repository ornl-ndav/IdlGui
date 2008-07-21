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

;- Run Number cw_field --------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='run_number_cw_field'): BEGIN
        load_run_number, Event     ;_eventcb
        CheckCommandLine, Event    ;_command_line
    END

;- Browse Button --------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='browse_nexus_button'): BEGIN
        browse_nexus, Event ;_eventcb
        CheckCommandLine, Event ;_command_line
    END

;- Selection Button -----------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_tool_button'): BEGIN
        selection_tool, Event ;_eventcb
    END

;= TAB2 (REDUCE) ==============================================================

;---- GO DATA REDUCTION button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='go_data_reduction_button'): BEGIN
        RunCommandLine, Event ;_run_commandline
    END

;==== tab1 ====================================================================

;----Data File ----------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_run_number_cw_field'): BEGIN
        LoadNeXus, Event, $
          'data_run_number_cw_field', $
          'data_file_name_text_field'
        CheckCommandLine, Event ;_command_line
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_file_name_text_field'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_browse_button'): BEGIN
        BrowseNexus, Event, $
          'data_browse_button',$
          'data_file_name_text_field'
        CheckCommandLine, Event ;_command_line
    END

;----ROI FIle -----------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='roi_browse_button'): BEGIN
        BrowseNexus, Event, $
          'roi_browse_button',$
          'roi_file_name_text_field'
        CheckCommandLine, Event ;_command_line
    END

    WIDGET_INFO(wWidget, FIND_BY_UNAME='roi_file_name_text_field'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END

;----Transmission Background --------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='transm_back_run_number_cw_field'): BEGIN
        LoadNeXus, Event, $
          'transm_back_run_number_cw_field',$
          'transm_back_file_name_text_field'
        CheckCommandLine, Event ;_command_line
    END

    WIDGET_INFO(wWidget, FIND_BY_UNAME=$
                'transm_back_file_name_text_field'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END

    WIDGET_INFO(wWidget, FIND_BY_UNAME='transm_back_browse_button'): BEGIN
        BrowseNexus, Event, $
          'transm_back_browse_button',$
          'transm_back_file_name_text_field'
        CheckCommandLine, Event ;_command_line
    END

;----Output folder ------------------------------------------------------------
    WIDGET_INFO(wWidget,$
                FIND_BY_UNAME= $
                'output_folder'): BEGIN
        BrowseOutputFolder, Event ;_reduce_tab1
        CheckCommandLine, Event   ;_command_line    
     END

;Clear File Name text field button --------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='output_file_name'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END

    WIDGET_INFO(wWidget,$
                FIND_BY_UNAME= $
                'clear_output_file_name_button'): BEGIN
       clearOutputFileName, Event ;_reduce_tab1
       CheckCommandLine, Event    ;_command_line
    END
    
;Reset File Name --------------------------------------------------------------
    WIDGET_INFO(wWidget,$
                FIND_BY_UNAME= $
                'reset_output_file_name_button'): BEGIN
       ResetOutputFileName, Event ;_reduce_tab1
       CheckCommandLine, Event    ;_command_line
    END

;==== tab2 (PARAMETERS) =======================================================

;---- YES or NO geometry cw_bgroup --------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='overwrite_geometry_group'): BEGIN
        GeometryGroupInteraction, Event ;_reduce_tab2
        CheckCommandLine, Event         ;_command_line
    END

;---- Browse button of the overwrite geometry button --------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='overwrite_geometry_button'): BEGIN
        BrowseGeometry, Event ;_reduce_tab2
        CheckCommandLine, Event ;_command_line
    END

;---- Time Zero Offset --------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='time_zero_offset_detector_uname'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME=$
                'time_zero_offset_beam_monitor_uname'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END
    
;---- Monitor Efficiency ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='monitor_efficiency_group'): BEGIN
       monitor_efficiency_constant_gui, Event  ;_reduce_tab2
       CheckCommandLine, Event                 ;_command_line
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME=$
                'monitor_efficiency_constant_value'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END
    
;---- Wavelength Range --------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='wave_min_text_field'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='wave_max_text_field'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END

    WIDGET_INFO(wWidget, FIND_BY_UNAME='wave_width_text_field'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END

    WIDGET_INFO(wWidget, FIND_BY_UNAME='wave_scale_group'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END
    
;---- Verbose Mode ------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='verbose_mode_group'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END

;---- min Lambda Cut off ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='minimum_lambda_cut_off_group'): BEGIN
        min_lambda_cut_off_gui, Event ;_reduce_tab2
        CheckCommandLine, Event       ;_command_line
    END

    WIDGET_INFO(wWidget, FIND_BY_UNAME='minimum_lambda_cut_off_value'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END

;---- max Lambda Cut off ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='maximum_lambda_cut_off_group'): BEGIN
        max_lambda_cut_off_gui, Event ;_reduce_tab2
        CheckCommandLine, Event       ;_command_line
    END

    WIDGET_INFO(wWidget, FIND_BY_UNAME='maximum_lambda_cut_off_value'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END

;==== tab2 (INTERMEDIATE FILE) ================================================
    WIDGET_INFO(wWidget, FIND_BY_UNAME='intermediate_group_uname'): BEGIN
       CheckCommandLine, Event  ;_command_line
    END

;= TAB3 (FITTING) =============================================================

;---- Browse Input Ascii file button ------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='input_file_browse_button'): BEGIN
        BrowseInputAsciiFile, Event ;_fitting
        UpdateFittingGui_preview, Event ;_fittign
    END

;---- Input Ascii text field --------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='input_file_text_field'): BEGIN
        AsciiInputTextField, Event ;_fitting
        UpdateFittingGui_preview, Event ;_fitting
     END

;---- Input Ascii text field --------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='input_file_load_button'): BEGIN
        LoadAsciiFile, Event ;_fitting
        UpdateFittingGui_preview, Event ;_fitting
    END

;---- Previw Ascii text file --------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='input_file_preview_button'): BEGIN
        PreviewAsciiFile, Event ;_fitting
    END

;---- degree of the fitting group ---------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='fitting_polynomial_degree_cw_group'): BEGIN
        ChangeDegreeOfPolynome, Event ;_fitting
        redefinedOutputFileNameOnly, Event ;_fitting
    END

;---- Launch the Automatic Fitting --------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='auto_fitting_button'): BEGIN
        AutoFit, Event ;_fitting
        UpdateFittingGui_save, Event ;_fitting
    END
    
;---- Show settings base ------------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='settings_button'): BEGIN
        map_base, Event, 'settings_base', 1
    END

;---- Show error bars group ---------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='plot_error_bars_group'): BEGIN
       ManualFitting, Event     ;replot ascii and fitting 
    END

;---- Hide/close settings base ------------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='close_fitting_settings_button'): BEGIN
        map_base, Event, 'settings_base', 0
    END

;---- Launch the Manual Fitting --------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='manual_fitting_button'): BEGIN
        ManualFitting, Event ;_fitting
        UpdateFittingGui_save, Event ;_fitting
    END

;---- Alternate Wavelength Axis -----------------------------------------------
    WIDGET_INFO(wWidget, $
                FIND_BY_UNAME='alternate_wavelength_axis_cw_group'): BEGIN
        ChangeAlternateAxisOption, Event ;_fitting
    END


;= TAB4 (LOG BOOK) ============================================================
    WIDGET_INFO(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
        SendToGeek, Event       ;_IDLsendToGeek
    END

    ELSE:
    
ENDCASE



END
