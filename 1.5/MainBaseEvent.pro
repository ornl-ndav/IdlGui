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
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  wWidget =  Event.top            ;widget id
  
  CASE Event.id OF
  
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end
    
    ;when going from tab to tab
    Widget_Info(wWidget, FIND_BY_UNAME='main_tab'): begin
      BSSreduction_TabRefresh, Event
    end
    
    ;save configuration
    Widget_info(wWidget, find_by_uname='save_configuration'): begin
      save_configuration, event
    end
    
    ;Load configuration
    Widget_info(wWidget, find_by_uname='load_configuration'): begin
      load_configuration, event
    end
    
    ;lin plot
    widget_info(wWidget, find_by_uname='linear_main_plot'): begin
      value_lin = '* linear'
      value_log = '  logarithmic'
      putValue, event, 'linear_main_plot', value_lin
      putValue, event, 'log_main_plot', value_log
      (*global).plot_type = 'lin'
      IF ((*global).NeXusFound AND $
        (*global).NeXusFormatWrong EQ 0) THEN BEGIN
        bss_reduction_PlotBanks, Event
        PlotExcludedPixels, Event
      endif
    end
    
    ;log
    widget_info(wWidget, find_by_uname='log_main_plot'): begin
      value_lin = '  linear'
      value_log = '* logarithmic'
      putValue, event, 'linear_main_plot', value_lin
      putValue, event, 'log_main_plot', value_log
      (*global).plot_type = 'log'
      IF ((*global).NeXusFound AND $
        (*global).NeXusFormatWrong EQ 0) THEN BEGIN
        bss_reduction_PlotBanks, Event
        PlotExcludedPixels, Event
      endif
    end
    
    
    ;when changing counts vs tof tab
    Widget_Info(wWidget, FIND_BY_UNAME='counts_vs_tof_tab'): begin
      BSSreduction_CountsVsTofTab, Event
    end
    
    ;cw_field run number
    Widget_Info(wWidget, FIND_BY_UNAME='nexus_run_number'): begin
      bss_reduction_LoadNexus, Event
      BSSreduction_PlotCountsVsTofOfSelection_light, Event
      BSSreduction_DisplayLinLogFullCountsVsTof, Event
    end
    
    ;BROWSE button run number
    Widget_Info(wWidget, FIND_BY_UNAME='nexus_run_number_button'): begin
      bss_reduction_BrowseNexus, Event
      BSSreduction_PlotCountsVsTofOfSelection_light, Event
      BSSreduction_DisplayLinLogFullCountsVsTof, Event
    end
    
    ;LIVE DATA STREAMING button
    Widget_Info(wWidget, FIND_BY_UNAME='live_data_streaming_button'): begin
      IF ((*global).first_lds_used) THEN BEGIN
        logger, APPLICATION=(*global).application,$
          VERSION=(*global).version,$
          UCAMS=(*global).ucams
        (*global).first_lds_used = 0
      ENDIF
      load_live_data_streaming, Event ;_LDS
    end
    
    ;Load ROI file
    Widget_Info(wWidget, FIND_BY_UNAME='load_roi_file_button'): begin
      BSSreduction_LoadRoiFile, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='load_roi_file_text'): begin
      ;      LoadRoiFile, Event
      PlotIncludedPixels, Event
    end
    
    ;Determine Path for saving ROI file
    Widget_Info(wWidget, FIND_BY_UNAME='roi_path_button'): begin
      BSSreduction_SetRoiPath, Event
    end
    
    ;Save ROI file
    Widget_Info(wWidget, FIND_BY_UNAME='save_roi_file_button'): begin
      BSSreduction_SaveRoiFile, Event
    end
    
    ;Regenerate new name for ROI file
    Widget_Info(wWidget, FIND_BY_UNAME='roi_file_name_generator'): begin
      BSSreduction_CreateRoiFileName, Event
    end
    
    ;Full counts vs tof draw and refresh button
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'full_counts_vs_tof_refresh_button'): begin
      BSSreduction_PlotCountsVsTofOfSelection_light, Event
      BSSreduction_DisplayLinLogFullCountsVsTof, Event
    ;        BSSreduction_PlotFullCountsVsTof, Event
    end
    
    ;full counts vs tof log/lin of counts vs tof
    Widget_Info(wWidget, FIND_BY_UNAME='full_counts_scale_cwbgroup'): begin
      BSSreduction_LinLogFullCountsVsTof, Event
    end
    
    widget_info(wWidget, FIND_BY_UNAME='full_counts_vs_tof_draw'): begin
      if ((*global).NeXusFound) then begin ;only if there is a NeXus loaded
        if (Event.release EQ 1) then begin ;mouse released
          BSSreduction_ZoomInFullCountsVsTofReleased, Event
        endif
        if (Event.type EQ 0 ) then begin
          if (Event.press EQ 1) then $ ;mouse pressed
            BSSreduction_ZoomInFullCountsVsTofPressed, Event
          if (Event.press EQ 4) then $ ;right click
            BSSreduction_OuputCoutsVsTofInitialization, Event
        endif
      endif
    end
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='output_tof_button'): BEGIN
      BSSreduction_OuputCoutsVsTofInitialization, Event
    END
    
    ;counts vs tof draw
    widget_info(wWidget, FIND_BY_UNAME='counts_vs_tof_draw'): begin
      if ((*global).NeXusFound) then begin ;only if there is a NeXus loaded
        if (Event.release EQ 1) then begin ;mouse released
          BSSreduction_ZoomInCountsVsTofReleased, Event
        endif
        if (Event.press EQ 1) then begin ;mouse pressed
          if (Event.type EQ 0 ) then begin ;left click
            BSSreduction_ZoomInCountsVsTofPressed, Event
          endif
        endif
      endif
    end
    
    ;log/lin of counts vs tof
    Widget_Info(wWidget, FIND_BY_UNAME='counts_scale_cwbgroup'): begin
      BSSreduction_LinLogCountsVsTof, Event
    end
    
    ;X: Y: Bank: Row: Tube: and PixelID: cw_fields
    ;X
    Widget_Info(wWidget, FIND_BY_UNAME='x_value'): begin
      BSSreduction_UpdatePixelIDField, Event
      BSSreduction_UpdateRowTubefield, Event
      BSSreduction_DisplayCountsVsTof, Event
    end
    
    ;Tube
    Widget_Info(wWidget, FIND_BY_UNAME='tube_value'): begin
      BSSreduction_UpdateXYBankFromRowTubeFields, Event
      BSSreduction_UpdatePixelIDField, Event
      BSSreduction_DisplayCountsVsTof, Event
      BSSreduction_DisplaySelectedPixel, Event
    end
    
    ;Y
    Widget_Info(wWidget, FIND_BY_UNAME='y_value'): begin
      BSSreduction_UpdatePixelIDField, Event
      BSSreduction_UpdateRowTubefield, Event
      BSSreduction_DisplayCountsVsTof, Event
      BSSreduction_DisplaySelectedPixel, Event
    end
    
    ;Row
    Widget_Info(wWidget, FIND_BY_UNAME='row_value'): begin
      BSSreduction_UpdateXYBankFromRowTubeFields, Event
      BSSreduction_UpdatePixelIDField, Event
      BSSreduction_DisplayCountsVsTof, Event
      BSSreduction_DisplaySelectedPixel, Event
    end
    
    ;Bank
    Widget_Info(wWidget, FIND_BY_UNAME='bank_value'): begin
      BSSreduction_UpdatePixelIDField, Event
      BSSreduction_UpdateRowTubefield, Event
      BSSreduction_DisplayCountsVsTof, Event
      BSSreduction_DisplaySelectedPixel, Event
    end
    
    ;PixelID
    Widget_Info(wWidget, FIND_BY_UNAME='pixel_value'): begin
      BSSreduction_UpdateXYBankFields, Event
      BSSreduction_UpdateRowTubefield, Event
      BSSreduction_DisplayCountsVsTof, Event
      BSSreduction_DisplaySelectedPixel, Event
    end
    
    ;Pixelid Color Index
    Widget_Info(wWidget, FIND_BY_UNAME='pixel_color_index'): begin
      (*global).ColorSelectedPixel = getPixelidColorIndex(Event)
      BSSreduction_DisplaySelectedPixel, Event
    end
    
    ;bank1 widget_draw
    widget_info(wWidget, FIND_BY_UNAME='top_bank_draw'): begin
      if ((*global).NeXusFound AND $
        (*global).NeXusFormatWrong EQ 0) then begin
        ;only if there is a NeXus loaded
        BSSreduction_DisplayXYBankPixelInfo, Event, 'bank1'
        if( Event.type EQ 0 )then begin
          if (Event.press EQ 1) then $ ;left click
            BSSreduction_DisplayCountsVsTof, Event
          if (Event.press EQ 4) then $ ;right click
            BSSreduction_IncludeExcludePixel, Event
        endif
      endif
    end
    
    ;bank2 widget_draw
    widget_info(wWidget, FIND_BY_UNAME='bottom_bank_draw'): begin
      if ((*global).NeXusFound AND $
        (*global).NeXusFormatWrong EQ 0) then begin
        ;only if there is a NeXus loaded
        BSSreduction_DisplayXYBankPixelInfo, Event, 'bank2'
        if( Event.type EQ 0 )then begin
          if (Event.press EQ 1) then $ ;left click
            BSSreduction_DisplayCountsVsTof, Event
          if (Event.press EQ 4) then $ ;right click
            BSSreduction_IncludeExcludePixel, Event
        endif
      endif
    end
    
    ;check-in
    Widget_Info(wWidget, FIND_BY_UNAME='pixelid'): begin
      BSSreduction_IncludeExcludeCheckPixelField, Event
    end
    
    ;EXCLUDE pixelID
    Widget_Info(wWidget, FIND_BY_UNAME='exclude_pixelid'): begin
      BSSreduction_ExcludePixelid, Event
    end
    
    ;INCLUDE pixelID
    Widget_Info(wWidget, FIND_BY_UNAME='include_pixelid'): begin
      BSSreduction_IncludePixelid, Event
    end
    
    ;check-in
    Widget_Info(wWidget, FIND_BY_UNAME='pixel_row'): begin
      BSSreduction_IncludeExcludeCheckPixelRowField, Event
    end
    
    ;EXCLUDE row of pixels
    Widget_Info(wWidget, FIND_BY_UNAME='exclude_pixel_row'): begin
      BSSreduction_ExcludePixelRow, Event
    end
    
    ;INCLUDE row of pixels
    Widget_Info(wWidget, FIND_BY_UNAME='include_pixel_row'): begin
      BSSreduction_IncludePixelRow, Event
    end
    
    ;check-in
    Widget_Info(wWidget, FIND_BY_UNAME='tube'): begin
      BSSreduction_IncludeExcludeCheckTubeField, Event
    end
    
    ;EXCLUDE tubes
    Widget_Info(wWidget, FIND_BY_UNAME='exclude_tube'): begin
      BSSreduction_ExcludeTube, Event
    end
    
    ;INCLUDE tubes
    Widget_Info(wWidget, FIND_BY_UNAME='include_tube'): begin
      BSSreduction_IncludeTube, Event
    end
    
    ;Excluded pixel type
    Widget_Info(wWidget, FIND_BY_UNAME='excluded_pixel_type'): begin
      BSSreduction_ExcludedPixelType, Event
    end
    
    ;Full reset of Excluded pixels
    Widget_Info(wWidget, FIND_BY_UNAME='reset_button'): begin
      BSSreduction_FullResetButton, Event
    end
    
    ;select_everything_button
    Widget_Info(wWidget, FIND_BY_UNAME='select_everything_button'): begin
      BSSreduction_ExcludeEverything, Event
    end
    
    ;Color reduction droplist
    Widget_Info(wWidget, FIND_BY_UNAME='selection_droplist'): begin
      BSSreduction_ColorSelection, Event
    end
    
    ;color slider
    Widget_Info(wWidget, FIND_BY_UNAME='color_slider'): begin
      BSSreduction_ColorSlider, Event
    end
    
    ;color droplist
    Widget_Info(wWidget, FIND_BY_UNAME='loadct_droplist'): begin
      BSSreduction_ColorLoadctDropList, Event
    end
    
    ;ColorReset
    Widget_Info(wWidget, FIND_BY_UNAME='reset_color_button'): begin
      BSSreduction_ColorSliderReset, Event
    end
    
    ;FullColorReset
    Widget_Info(wWidget, FIND_BY_UNAME='full_reset_color_button'): begin
      BSSreduction_ColorSliderFullReset, Event
    end
    
    ;Excluded pixel that have value less or equal to X
    Widget_Info(wWidget, FIND_BY_UNAME='counts_exclusion'): begin
      BSSreduction_ExcludedPixelCounts, Event
    end
    
    ;Excluded pixel that have value more  or equal to X
    Widget_Info(wWidget, FIND_BY_UNAME='counts_exclusion_2'): begin
      BSSreduction_ExcludedPixelCounts, Event
    end
    
    ;output couts_vs_tof
    ;cw_field message to add
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'output_counts_vs_tof_message_text'): begin
      BSSreduction_UpdatePreviewText, Event
    end
    
    ;create ASCII output file
    Widget_Info(wWidget, FIND_BY_UNAME='output_counts_vs_tof_ok_button'): begin
      BSSreduction_CreateOutputCountsVsTofFile, Event
      activate_output_couts_vs_tof_base, Event, 0
      PlotIncludedPixels, Event
    end
    
    ;cancel button
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'output_counts_vs_tof_cancel_button'): begin
      activate_output_couts_vs_tof_base, Event, 0
      PlotIncludedPixels, Event
    end
    
    ;get path button
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'output_counts_vs_tof_path_button'): begin
      BSSreduction_GetNewPath, Event
    end
    
    ;*******
    ;REDUCE*
    ;*******
    ;tab1
    
    Widget_Info(wWidget, FIND_BY_UNAME='rsdf_run_number_cw_field'): begin
      BSSreduction_Reduce_rsdf_run_number_cw_field, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='rsdf_nexus_cw_field'): begin
    ;      BSSreduction_Reduce_rsdf_nexus_cw_field, Event
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='rsdf_browse_nexus_button'): begin
    ;      BSSreduction_ReduceBrowseNexus, Event, 'rsdf'
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='rsdf_list_of_runs_text'): begin
    ;      BSSreduction_Reduce_rsdf_list_of_runs_text, Event
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='bdf_run_number_cw_field'): begin
      ;      BSSreduction_Reduce_bdf_run_number_cw_field, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='bdf_nexus_cw_field'): begin
    ;      BSSreduction_Reduce_bdf_nexus_cw_field, Event
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='bdf_browse_nexus_button'): begin
    ;      BSSreduction_ReduceBrowseNexus, Event, 'bdf'
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='bdf_list_of_runs_text'): begin
    ;      BSSreduction_Reduce_bdf_list_of_runs_text, Event
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='ndf_run_number_cw_field'): begin
      ;      BSSreduction_Reduce_ndf_run_number_cw_field, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='ndf_nexus_cw_field'): begin
    ;      BSSreduction_Reduce_ndf_nexus_cw_field, Event
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='ndf_browse_nexus_button'): begin
    ;      BSSreduction_ReduceBrowseNexus, Event, 'ndf'
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='ndf_list_of_runs_text'): begin
    ;      BSSreduction_Reduce_ndf_list_of_runs_text, Event
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='ecdf_run_number_cw_field'): begin
      ;      BSSreduction_Reduce_ecdf_run_number_cw_field, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='ecdf_nexus_cw_field'): begin
    ;      BSSreduction_Reduce_ecdf_nexus_cw_field, Event
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='ecdf_browse_nexus_button'): begin
    ;      BSSreduction_ReduceBrowseNexus, Event, 'ecdf'
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='ecdf_list_of_runs_text'): begin
    ;      BSSreduction_Reduce_ecdf_list_of_runs_text, Event
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='dsb_run_number_cw_field'): begin
      ;      BSSreduction_Reduce_dsb_run_number_cw_field, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='dsb_nexus_cw_field'): begin
    ;      BSSreduction_Reduce_dsb_nexus_cw_field, Event
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='dsb_browse_nexus_button'): begin
    ;      BSSreduction_ReduceBrowseNexus, Event, 'dsb'
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    ;    Widget_Info(wWidget, FIND_BY_UNAME='dsb_list_of_runs_text'): begin
    ;      BSSreduction_Reduce_ecdf_list_of_runs_text, Event
    ;      BSSreduction_CommandLineGenerator, Event
    ;    end
    
    ;tab2
    Widget_Info(wWidget, FIND_BY_UNAME='proif_browse_nexus_button'): begin
      BSSreduction_ReduceBrowseRoi, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='proif_text'): begin
      BSSreduction_Reduce_proif_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='aig_browse_nexus_button'): begin
      BSSreduction_ReduceBrowseNexus, Event, 'aig'
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='aig_list_of_runs_text'): begin
      BSSreduction_Reduce_aig_list_of_runs_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;output folder button
    Widget_Info(wWidget, FIND_BY_UNAME='output_folder_name'): begin
      BSSreduction_output_folder_name, Event ;ReduceTab2
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='of_list_of_runs_text'): begin
      BSSreduction_Reduce_of_list_of_runs_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;tab3
    Widget_Info(wWidget, FIND_BY_UNAME='rmcnf_button'): begin
      BSSreduction_Reduce_rmcnf_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='verbose_button'): begin
      BSSreduction_Reduce_verbose_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='absm_button'): begin
      BSSreduction_Reduce_absm_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='nmn_button'): begin
      BSSreduction_Reduce_nmn_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='nmec_button'): begin
      BSSreduction_Reduce_nmec_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='niw_button'): begin
      BSSreduction_Reduce_niw_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='nisw_field'): begin
      BSSreduction_Reduce_nisw_field, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='niew_field'): begin
      BSSreduction_Reduce_niew_field, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='te_button'): begin
      BSSreduction_Reduce_te_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='te_low_field'): begin
      BSSreduction_Reduce_te_low_field, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='te_high_field'): begin
      BSSreduction_Reduce_te_high_field, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;tab4
    Widget_Info(wWidget, FIND_BY_UNAME='tib_tof_button'): begin
      BSSreduction_Reduce_tib_tof_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibtof_channel1_text'): begin
      BSSreduction_Reduce_tibtof_channel1_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibtof_channel2_text'): begin
      BSSreduction_Reduce_tibtof_channel2_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibtof_channel3_text'): begin
      BSSreduction_Reduce_tibtof_channel3_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibtof_channel4_text'): begin
      BSSreduction_Reduce_tibtof_channel4_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_sd_button'): begin
      BSSreduction_Reduce_tibc_for_sd_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_sd_value_text'): begin
      BSSreduction_Reduce_tibc_for_sd_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_sd_error_text'): begin
      BSSreduction_Reduce_tibc_for_sd_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_bd_button'): begin
      BSSreduction_Reduce_tibc_for_bd_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_bd_value_text'): begin
      BSSreduction_Reduce_tibc_for_bd_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_bd_error_text'): begin
      BSSreduction_Reduce_tibc_for_bd_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_nd_button'): begin
      BSSreduction_Reduce_tibc_for_nd_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_nd_value_text'): begin
      BSSreduction_Reduce_tibc_for_nd_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_nd_error_text'): begin
      BSSreduction_Reduce_tibc_for_nd_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_ecd_button'): begin
      BSSreduction_Reduce_tibc_for_ecd_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_ecd_value_text'): begin
      BSSreduction_Reduce_tibc_for_ecd_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_ecd_error_text'): begin
      BSSreduction_Reduce_tibc_for_ecd_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_scatd_button'): begin
      BSSreduction_Reduce_tibc_for_scatd_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_scatd_value_text'): begin
      BSSreduction_Reduce_tibc_for_scatd_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tibc_for_scatd_error_text'): begin
      BSSreduction_Reduce_tibc_for_scatd_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;tab5
    ;Use iteractive background subtraction ----------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME= $
      'use_iterative_background_subtraction_cw_bgroup'): begin
      BSSreduction_Reduce_use_iterative_back, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'scale_constant_lambda_dependent_back_uname'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'chopper_frequency_value'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'chopper_wavelength_value'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'tof_least_background_value'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;Positive transverse energy integration range ---------------------------------
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'pte_min_text'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'pte_max_text'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'pte_bin_text'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;other flags ------------------------------------------------------------------
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'detailed_balance_temperature_value'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'ratio_tolerance_value'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'number_of_iteration'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'min_wave_dependent_back'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'max_wave_dependent_back'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'small_wave_dependent_back'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME= $
      'amorphous_reduction_verbosity_cw_bgroup'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;tab6 =========================================================================
    Widget_Info(wWidget, FIND_BY_UNAME='csbss_button'): begin
      BSSreduction_Reduce_csbss_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='csbss_value_text'): begin
      BSSreduction_Reduce_csbss_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='csbss_error_text'): begin
      BSSreduction_Reduce_csbss_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    
    Widget_Info(wWidget, FIND_BY_UNAME='csn_button'): begin
      BSSreduction_Reduce_csn_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='csn_value_text'): begin
      BSSreduction_Reduce_csn_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='csn_error_text'): begin
      BSSreduction_Reduce_csn_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    
    Widget_Info(wWidget, FIND_BY_UNAME='bcs_button'): begin
      BSSreduction_Reduce_bcs_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='bcs_value_text'): begin
      BSSreduction_Reduce_bcs_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='bcs_error_text'): begin
      BSSreduction_Reduce_bcs_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    
    Widget_Info(wWidget, FIND_BY_UNAME='bcn_button'): begin
      BSSreduction_Reduce_bcn_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='bcn_value_text'): begin
      BSSreduction_Reduce_bcn_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='bcn_error_text'): begin
      BSSreduction_Reduce_bcn_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    
    Widget_Info(wWidget, FIND_BY_UNAME='cs_button'): begin
      BSSreduction_Reduce_cs_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='cs_value_text'): begin
      BSSreduction_Reduce_cs_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='cs_error_text'): begin
      BSSreduction_Reduce_cs_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    
    Widget_Info(wWidget, FIND_BY_UNAME='cn_button'): begin
      BSSreduction_Reduce_cn_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='cn_value_text'): begin
      BSSreduction_Reduce_cn_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='cn_error_text'): begin
      BSSreduction_Reduce_cn_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;-----------------------------------------------------------------------------
    ;tab7
    Widget_Info(wWidget, FIND_BY_UNAME='csfds_button'): begin
      BSSreduction_Reduce_csfds_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='csfds_value_text'): begin
      BSSreduction_Reduce_csfds_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tzsp_button'): begin
      BSSreduction_Reduce_tzsp_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tzsp_value_text'): begin
      BSSreduction_Reduce_tzsp_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tzsp_error_text'): begin
      BSSreduction_Reduce_tzsp_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tzop_button'): begin
      BSSreduction_Reduce_tzop_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tzop_value_text'): begin
      BSSreduction_Reduce_tzop_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tzop_error_text'): begin
      BSSreduction_Reduce_tzop_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='eha_button'): begin
      BSSreduction_Reduce_eha_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='eha_min_text'): begin
      BSSreduction_Reduce_eha_min_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='eha_max_text'): begin
      BSSreduction_Reduce_eha_max_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='eha_bin_text'): begin
      BSSreduction_Reduce_eha_bin_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='gifw_button'): begin
      BSSreduction_Reduce_gifw_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='gifw_value_text'): begin
      BSSreduction_Reduce_gifw_value_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='gifw_error_text'): begin
      BSSreduction_Reduce_gifw_error_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;Momentum Transfer Histogram Axis (1/Angstroms) and Negative Cosine Polar
    Widget_Info(wWidget, FIND_BY_UNAME='mtha_button'): begin
      BSSreduction_Reduce_mtha_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='mtha_min_text'): begin
      BSSreduction_Reduce_mtha_min_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='mtha_max_text'): begin
      BSSreduction_Reduce_mtha_max_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='mtha_bin_text'): begin
      BSSreduction_Reduce_mtha_bin_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;Time of flight range
    Widget_Info(wWidget, FIND_BY_UNAME='tof_cutting_button'): begin
      BSSreduction_Reduce_tof_cutting_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, $
      FIND_BY_UNAME='tof_cutting_min_text'): begin
      BSSreduction_Reduce_tof_cutting_min_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='tof_cutting_max_text'): begin
      BSSreduction_Reduce_tof_cutting_max_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    widget_info(wWidget, $
      FIND_BY_UNAME='scale_sqe_by_solid_angle_group_uname'): BEGIN
      BSSreduction_CommandLineGenerator, Event
    END
    
    ;------------------------------------------------------------------------------
    ;tab8 (intermediate plots)
    Widget_Info(wWidget, FIND_BY_UNAME='waio_button'): begin
      BSSreduction_Reduce_waio_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='woctib_button'): begin
      BSSreduction_Reduce_woctib_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='wopws_button'): begin
      BSSreduction_Reduce_wopws_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='womws_button'): begin
      BSSreduction_Reduce_womws_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='womes_button'): begin
      BSSreduction_Reduce_womes_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='worms_button'): begin
      BSSreduction_Reduce_worms_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='wocpsamn_button'): begin
      BSSreduction_Reduce_wocpsamn_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='wa_min_text'): begin
      BSSreduction_Reduce_wa_min_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='wa_max_text'): begin
      BSSreduction_Reduce_wa_max_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='wa_bin_width_text'): begin
      BSSreduction_Reduce_wa_bin_width_text, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='wopies_button'): begin
      BSSreduction_Reduce_wopies_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='wopets_button'): begin
      BSSreduction_Reduce_wopets_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='wolidsb_button'): begin
      BSSreduction_Reduce_wolidsb_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='wodwsm_button'): begin
      BSSreduction_Reduce_wodwsm_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;Pixel Wavelength Spectra After Vanadium Normalization
    Widget_Info(wWidget, FIND_BY_UNAME='pwsavn_button'): begin
      BSSreduction_Reduce_pwsavn_button, Event
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;Solid Angle Distribution from S(Q,E) Rebinning
    Widget_Info(wWidget, FIND_BY_UNAME='sad'): begin
      BSSreduction_CommandLineGenerator, Event
    end
    
    ;end of tab8 -------------------------------------------------------------
    
    ;Start Batch Data Reduction
    WIDGET_INFO(wWidget, FIND_BY_UNAME='submit_batch_button'): BEGIN
      BSSreduction_RunBatchCommandLine, Event
    END
    
    ;Start Data Reduction
    WIDGET_INFO(wWidget, FIND_BY_UNAME='submit_button'): BEGIN
      BSSreduction_RunCommandLine, Event
    END
    
    ;check status
    WIDGET_INFO(wWidget, FIND_BY_UNAME='check_status_of_jobs'): BEGIN
      WIDGET_CONTROL,/HOURGLASS
      firefox       = (*global).firefox
      srun_web_page = (*global).srun_web_page
      spawn, firefox + ' ' + srun_web_page + ' &'
      WIDGET_CONTROL,HOURGLASS=0
    END
    
    ;Create Command Line File -----------------------------------------------------
    ;path
    WIDGET_INFO(wWidget, FIND_BY_UNAME='command_line_path_button'): BEGIN
      command_line_path, Event ;_CreateCommandLineFile
    END
    
    ;create file
    WIDGET_INFO(wWidget, FIND_BY_UNAME='command_line_file_button'): BEGIN
      create_cl_file, Event ;_CreateCommandLineFile
    END
    
    ;______________________________________________________________________________
    ; JOBS STATUS TAB
    WIDGET_INFO(wWidget, FIND_BY_UNAME='refresh_list_of_jobs_button'): BEGIN
      refresh_job_status, Event ;_job_status
    END
    
    ;browse for list of jobs
    WIDGET_INFO(wWidget, FIND_BY_UNAME='job_status_browse_files'): BEGIN
      browse_list_OF_job, Event ;_job_status
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='job_status_output_path_button'): BEGIN
      job_status_folder_button, Event ;_job_status
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='job_status_create_plot_button'): BEGIN
      stitch_files, Event ;_job_status
    END
    
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='job_status_remove_folder'): BEGIN
      remove_job_status_folder, Event     ;_job_status
    END
    
    widget_info(wWidget, find_by_uname='preview_command_line'): begin
      preview_command_line_base, event
    end
    
    ;______________________________________________________________________________
    ;Output File Tab --------------------------------------------------------------
    Widget_Info(wWidget, FIND_BY_UNAME='output_file_name_droplist'): begin
      BSSreduction_DisplayOutputFiles, Event
    end
    
    ;Browse Button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='output_plot_browse_button'): begin
      BrowseOutputPlot, Event ;_intermediatePlots
    end
    
    ;Plot data (cow button)
    Widget_Info(wWidget, FIND_BY_UNAME='output_plot_data'): begin
      PlotOutputData, Event ;_IntermediatePlots
    end
    
    ;LOG_BOOK
    ;Send log book to geek button
    Widget_Info(wWidget, FIND_BY_UNAME='send_log_book'): begin
      BSSreduction_LogBook, Event
    end
    
    ELSE:
    
  ENDCASE
  
  IF ((*global).LoadingConfig EQ 0) THEN BEGIN
    BSSreduction_LoadingConfigurationFile, Event
    (*global).LoadingConfig = 1
    BSSreduction_CommandLineGenerator, Event
  ENDIF
  
  ;loop through all the jobs to find out which one the user clicked
  job_status_uname = (*(*global).job_status_uname)
  sz = N_ELEMENTS(job_status_uname)
  index = 0
  job_status_root_status = (*(*global).job_status_root_status)
  WHILE (index LT sz) DO BEGIN
    uname = job_status_uname[index]
    
    IF (Event.id EQ WIDGET_INFO(wWidget, FIND_BY_UNAME=uname)) THEN BEGIN
    
      label = 'REFRESHING LIST OF JOBS ... '
      putButtonValue, Event, 'refresh_list_of_jobs_button', label
      
      display_contain_OF_job_status, Event, index ;_Job_status
      (*global).igs_selected_index = index
      
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
      expanded_status = WIDGET_INFO(id, /TREE_EXPANDED)
      
      IF (job_status_root_status[index] NE expanded_status) THEN BEGIN
        job_status_root_status[index] = expanded_status
        IF (expanded_status EQ 1L) THEN BEGIN
          iRefresh = OBJ_NEW('IDLrefreshRoot', Event, index)
          OBJ_DESTROY, iRefresh
        ENDIF
      ENDIF
      ;put time stamp
      updateRefreshButtonLabel, Event ;_GUI
      cleanup_err_out_widget_text, Event ;_Job_status
      ;activate new refresh entry
      select_n_node, Event, index
      
      GOTO, TheEnd
    ENDIF
    index++
  ENDWHILE
  (*(*global).job_status_root_status) = job_status_root_status
  
  leaf_uname = (*(*global).leaf_uname_array)
  sz = N_ELEMENTS(leaf_uname)
  index = 0
  WHILE (index LT sz) DO BEGIN
    uname = leaf_uname[index]
    IF (Event.id EQ WIDGET_INFO(wWidget, FIND_BY_UNAME=uname)) THEN BEGIN
      absolute_leaf_index = (*(*global).absolute_leaf_index)
      WhichFolderIndex = WHERE(absolute_leaf_index GT index, nbr)
      display_contain_OF_job_status, Event, WhichFolderIndex[0]
      
      LeafAbsoluteIndex = WHERE(index GE absolute_leaf_index, nbr)
      IF (nbr GT 0) THEN BEGIN
        real_leaf_index = index - $
          absolute_leaf_index[LeafAbsoluteIndex[nbr-1]]
        index = real_leaf_index
      ENDIF
      getOutErrFile, Event, uname, index ;_job_status
      BREAK
    ENDIF
    index++
  ENDWHILE
  
  TheEnd:
  (*(*global).job_status_root_status) = job_status_root_status
  
END
