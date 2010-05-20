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

PRO MAIN_BASE_ref_scale_event, Event

  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,get_uvalue=global
  
  wWidget =  Event.top          ;widget id
  
  CASE (Event.id) OF
  
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE_ref_scale'): BEGIN
    END
    
    ;------------------------------------------------------------------------------
    ;***** GENERAL FUNCTION *******************************************************
    ;------------------------------------------------------------------------------
    
    ;Event triggered by 'X-axis  min:' widget_text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='XaxisMinTextField'): BEGIN
      (*global).replot_me = 1
      replot_main_plot, Event ;_Plot
    END
    
    ;Event triggered by 'X-axis  max:' widget_text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='XaxisMaxTextField'): BEGIN
      (*global).replot_me = 1
      replot_main_plot, Event ;_Plot
    END
    
    ;Event triggered by 'Y-axis  min:' widget_text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='YaxisMinTextField'): BEGIN
      (*global).replot_me = 1
      replot_main_plot, Event ;_Plot
    END
    
    ;Event triggered by 'Y-axis  max:' widget_text
    WIDGET_INFO(wWidget, FIND_BY_UNAME='YaxisMaxTextField'): BEGIN
      (*global).replot_me = 1
      replot_main_plot, Event ;_Plot
    END
    
    ;Event of lin or log switch of Y axis
    WIDGET_INFO(wWidget, FIND_BY_UNAME='YaxisLinLog'): BEGIN
      (*global).replot_me = 1
      replot_main_plot, Event ;_Plot
    END
    
    ;Event of the main widget_tab
    WIDGET_INFO(wWidget, FIND_BY_UNAME='steps_tab'): BEGIN
      steps_tab, Event, 0  ;_Tabs
    END
    
    ;Main Plot Drawing Window
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_window'): BEGIN
      IF (getNbrOfFiles(Event) GT 0) THEN BEGIN
        steps_tab_id  = WIDGET_INFO(Event.top, find_by_uname='steps_tab')
        ;current tab selected
        CurrTabSelect = WIDGET_INFO(steps_tab_id,/tab_current)
        CASE (CurrTabSelect) OF
          1: BEGIN
            ;only for CE tab (step2) AND only if more than 1 file
            IF (getTabSelected(Event) EQ 1 AND $
              getNbrOfFiles(Event) GE 1) THEN BEGIN
              XMinMax = getDrawXMin(Event)
              CASE (Event.type) OF
                0 : BEGIN
                  CASE (Event.press) OF ;left or right click
                    1 : BEGIN ;left click
                      ;print, 'left click'
                      Step2LeftClick, $
                        Event, $
                        XMinMax ;left click
                    END
                    4 : BEGIN ;right click
                      ;print, 'right click'
                      Step2RightClick, Event ;right click
                    END
                    ELSE:
                  ENDCASE
                END
                1 : BEGIN ;release click
                  ;print, 'entering release click'
                  Step2ReleaseClick, Event;button released
                END
                2 : BEGIN ;move click
                  ;print, '-> move click'
                  Step2MoveClick, $
                    Event, $
                    XMinMax ;mouse is moving
                END
                ELSE:
              ENDCASE
            ENDIF
          END
          ELSE: replot_main_plot, Event ;_Plot
        ENDCASE
      ENDIF ;end of if(getNbrOfFiles(Event))
    END
    
    ;------------------------------------------------------------------------------
    ;***** MAIN BASE GUI **********************************************************
    ;------------------------------------------------------------------------------
    
    ;Event of <RESET_FULL_SESSION> button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='reset_all_button'): BEGIN
      reset_all_button, Event ;_event
    END
    
    ;Event of <REFRESH PLOTS> button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='refresh_plot_button'): BEGIN
      steps_tab, Event, 1 ;_Tabs
    END
    
    ;Event of <OUTPUT FILE> button - create output file
    WIDGET_INFO(wWidget, FIND_BY_UNAME='print_button'): BEGIN
      if ((*global).working_with_ref_m_batch) then begin
        ProduceOutputFile_ref_m, event
      endif else begin
        ProduceOutputFile, Event ;_produce_output
      endelse
      ;this routine will check if we can enabled or not the preview buttons
      check_previews_button, event
    END
    
    ;email output
    widget_info(wWidget, find_by_uname='send_by_email_output'): begin
      if (getButtonValidated(event,'send_by_email_output') eq 0) then begin
        status = 1
      endif else begin
        status = 0
      endelse
      ActivateWidget, Event, 'email_configure', status
    end
    
    ;pop up configure email base
    widget_info(wWidget, find_by_uname='email_configure'): begin
      email_configure_base, Even=event
      ActivateWidget, Event, 'email_configure', 0
    end
    
    ;Event triggered by 'Reset X/Y'
    WIDGET_INFO(wWidget, FIND_BY_UNAME='ResetButton'): BEGIN
      ResetRescaleButton, Event ;_eventcb
    END
    
    ;Event trigerred by with or without error bars
    WIDGET_INFO(wWidget, FIND_BY_UNAME='show_error_bar_group'): BEGIN
      WithWithoutErrorBars, Event ;_eventcb
    END
    
    ;spin states button
    widget_info(wWidget, find_by_uname='off_off'): begin
      spin_index = get_index_of_this_spin_in_list_of_spins(event,'off_off')
      display_spin_index, event, spin_index
    end
    widget_info(wWidget, find_by_uname='off_on'): begin
      spin_index = get_index_of_this_spin_in_list_of_spins(event,'off_on')
      display_spin_index, event, spin_index
    end
    widget_info(wWidget, find_by_uname='on_off'): begin
      spin_index = get_index_of_this_spin_in_list_of_spins(event,'on_off')
      display_spin_index, event, spin_index
    end
    widget_info(wWidget, find_by_uname='on_on'): begin
      spin_index = get_index_of_this_spin_in_list_of_spins(event,'on_on')
      display_spin_index, event, spin_index
    end
    
    ;settings base button
    widget_info(wWidget, $
      find_by_uname='open_settings_base'): begin
      settings_base, Event=event
      ActivateWidget, Event, 'open_settings_base', 0
    end
    
    ;--------------------------------------------------------------------------
    ;***** STEP 1 - [LOAD FILES] **********************************************
    ;--------------------------------------------------------------------------
    ;Event of <Load File> button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='load_button'): BEGIN
      LoadFileButton, Event ;_Load
    END
    
    ;Event of 'List of Files:' droplist
    WIDGET_INFO(wWidget, FIND_BY_UNAME='list_of_files_droplist'): BEGIN
      display_info_about_file, Event ;_Gui
    END
    
    ;Event of <Clear File>
    WIDGET_INFO(wWidget, FIND_BY_UNAME='clear_button'): BEGIN
      clear_file, Event ;_Load
      ;plot all loaded files
      PlotLoadedFiles, Event ;_Plot
    END
    
    ;Get Full Preview of DR file
    WIDGET_INFO(wWidget, FIND_BY_UNAME='full_preview_button'): BEGIN
      DisplayFullPreviewOfButton, Event ;_eventcb
    END
    
    ;color slider
    widget_info(wWidget, find_by_uname='list_of_color_slider'): begin
      steps_tab, Event, 1 ;_Tabs
    end
    
    ;------------------------------------------------------------------------------
    ;****** STEP 1 / In the LOAD TOF base *****************************************
    ;------------------------------------------------------------------------------
    
    ;Event of <CANCEL> button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='cancel_load_button'): BEGIN
      CancelTOFLoadButton, Event ;_Load
    END
    
    ;Event of <OK> button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='ok_load_button'): BEGIN
      OkLoadButton, Event ;_Load
    END
    
    ;Event of the 'Distance Moderator-Detector (m):' widget_text
    WIDGET_INFO(wWidget, FIND_BY_UNAME= $
      'ModeratorDetectorDistanceTextField'): BEGIN
      CheckOpenButtonStatus, Event ;_Gui
    END
    
    ;Event of the 'Polar angle:' text_field
    WIDGET_INFO(wWidget, FIND_BY_UNAME='AngleTextField'): BEGIN
      CheckOpenButtonStatus, Event ;_Gui
    END
    
    ;------------------------------------------------------------------------------
    ;***** STEP 2 - [DEFINE CRITICAL EDGE FILE] ***********************************
    ;------------------------------------------------------------------------------
    
    ;Event triggered by <Automatic Fitting/Rescaling of CE>
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step2_button'): BEGIN
      run_full_step2, Event ;_Step2
    END
    
    ;Event triggered by <Manual Scaling of CE>
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step2_manual_scaling_button'): BEGIN
      manualCEscaling, Event ;_Step2
    END
    
    ;Event trigerred when editing the SF text field
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step2_sf_text_field'): BEGIN
      manual_sf_editing, Event ;_Step2
    END
    
    ;Event trigerred by Qmin cw_field
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step2_q1_text_field'): BEGIN
      ManualNewQ, Event ;_Step2
      Step2ReleaseClick, Event ;this reorder the Q1 and Q2
    END
    
    ;Event trigerred by Qmin cw_field
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step2_q2_text_field'): BEGIN
      ManualNewQ, Event ;_Step2
      Step2ReleaseClick, Event ;this reorder the Q1 and Q2
    END
    
    ;------------------------------------------------------------------------------
    ;***** STEP 3 - [RESCALE FILES] ***********************************************
    ;------------------------------------------------------------------------------
    
    ;Event triggered by widget_droplist
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step3_work_on_file_droplist'): BEGIN
      steps_tab, Event, 1   ;_Tab
    END
    
    ;Event triggered by [Automatic rescaling]
    WIDGET_INFO(wWidget, FIND_BY_UNAME= $
      'Step3_automatic_rescale_button'): BEGIN
      Step3AutomaticRescaling, Event ;_Step3
    END
    
    ;Event trigerred by the CW_FIELD SF rescaling
    WIDGET_INFO(wWidget, FIND_BY_UNAME='Step3SFTextField'): BEGIN
      step = FLOAT(getTextFieldValue(Event,'Step3SFTextField'))
      Step3RescaleFile, Event, 'manual'
      ;Step3RescaleFile2, Event, step ;_Step3
    END
    
    ;Event triggered by [+++]
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step3_3increase_button'): BEGIN
      Step3RescaleFile, Event, '+100%' ;_Step3
    END
    
    ;Event triggered by [++]
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step3_2increase_button'): BEGIN
      Step3RescaleFile, Event, '+10%' ;_Step3
    END
    
    ;Event triggered by [+]
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step3_1increase_button'): BEGIN
      Step3RescaleFile, Event, '+1%' ;_Step3
    END
    
    ;Event triggered by [---]
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step3_3decrease_button'): BEGIN
      Step3RescaleFile, Event, '-99%' ;_Step3
    END
    
    ;Event triggered by [--]
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step3_2decrease_button'): BEGIN
      Step3RescaleFile, Event, '-10%' ;_Step3
    END
    
    ;Event triggered by [-]
    WIDGET_INFO(wWidget, FIND_BY_UNAME='step3_1decrease_button'): BEGIN
      Step3RescaleFile, Event, '-1%' ;_Step3
    END
    
    ;--------------------------------------------------------------------------
    ;***** Output File ********************************************************
    ;--------------------------------------------------------------------------
    widget_info(wWidget, find_by_uname='scaled_data_file_preview_0'): begin
      preview_of_scaled_data_file, event, 0
    end
    widget_info(wWidget, find_by_uname='scaled_data_file_preview_1'): begin
      preview_of_scaled_data_file, event, 1
    end
    widget_info(wWidget, find_by_uname='scaled_data_file_preview_2'): begin
      preview_of_scaled_data_file, event, 2
    end
    widget_info(wWidget, find_by_uname='scaled_data_file_preview_3'): begin
      preview_of_scaled_data_file, event, 3
    end
    widget_info(wWidget, $
      find_by_uname='combined_scaled_data_file_preview_0'): begin
      preview_of_combined_scaled_data_file, event, 0
    end
    widget_info(wWidget, $
      find_by_uname='combined_scaled_data_file_preview_1'): begin
      preview_of_combined_scaled_data_file, event, 1
    end
    widget_info(wWidget, $
      find_by_uname='combined_scaled_data_file_preview_2'): begin
      preview_of_combined_scaled_data_file, event, 2
    end
    widget_info(wWidget, $
      find_by_uname='combined_scaled_data_file_preview_3'): begin
      preview_of_combined_scaled_data_file, event, 3
    end
    
    ;--------------------------------------------------------------------------
    ;***** BATCH TAB **********************************************************
    ;--------------------------------------------------------------------------
    ;Load Batch File Button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='load_batch_file_button'): BEGIN
      ref_scale_LoadBatchFile, Event ;_batch
    END
    
    ;Preview Batch File Button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='batch_preview_button'): BEGIN
      ref_scale_PreviewBatchFile, Event ;_batch
    END
    
    ;SAVE Batch File button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='ref_scale_refresh_batch_file'): BEGIN
      ref_scale_refresh_batch_file, Event ;_batch
    END
    
    ;SAVE AS Batch File button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='ref_scale_save_as_batch_file'): BEGIN
      ref_scale_save_as_batch_file, Event ;_batch
    END
    
    ;------------------------------------------------------------------------------
    ;***** LOG BOOK ***************************************************************
    ;------------------------------------------------------------------------------
    ;Send To Geek button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
      SendToGeek, Event ;_IDLsendToGeek__define
    END
    
    ELSE:
  ENDCASE
  
END

