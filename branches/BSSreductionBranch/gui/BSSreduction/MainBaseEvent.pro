PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end
	
;when going from tab to tab
    Widget_Info(wWidget, FIND_BY_UNAME='main_tab'): begin
        BSSreduction_TabRefresh, Event
    end

;when changing counts vs tof tab
    Widget_Info(wWidget, FIND_BY_UNAME='counts_vs_tof_tab'): begin
        BSSreduction_CountsVsTofTab, Event 
    end

;cw_field run number
    Widget_Info(wWidget, FIND_BY_UNAME='nexus_run_number'): begin
        bss_reduction_LoadNexus, Event
    end

;BROWSE button run number
    Widget_Info(wWidget, FIND_BY_UNAME='nexus_run_number_button'): begin
        bss_reduction_BrowseNexus, Event
    end
    
;Load ROI file
    Widget_Info(wWidget, FIND_BY_UNAME='load_roi_file_button'): begin
        BSSreduction_LoadRoiFile, Event
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
    Widget_Info(wWidget, FIND_BY_UNAME='full_counts_vs_tof_refresh_button'): begin
        BSSreduction_PlotFullCountsVsTof, Event
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
        if ((*global).NeXusFound) then begin ;only if there is a NeXus loaded
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
        if ((*global).NeXusFound) then begin ;only if there is a NeXus loaded
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

;output couts_vs_tof
;cw_field message to add
    Widget_Info(wWidget, FIND_BY_UNAME='output_counts_vs_tof_message_text'): begin
        BSSreduction_UpdatePreviewText, Event
    end

;create ASCII output file    
    Widget_Info(wWidget, FIND_BY_UNAME='output_counts_vs_tof_ok_button'): begin
        BSSreduction_CreateOutputCountsVsTofFile, Event
        activate_output_couts_vs_tof_base, Event, 0
        PlotIncludedPixels, Event
    end

;cancel button
    Widget_Info(wWidget, FIND_BY_UNAME='output_counts_vs_tof_cancel_button'): begin
        activate_output_couts_vs_tof_base, Event, 0
        PlotIncludedPixels, Event
    end

;get path button
    Widget_Info(wWidget, FIND_BY_UNAME='output_counts_vs_tof_path_button'): begin
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

    Widget_Info(wWidget, FIND_BY_UNAME='rsdf_nexus_cw_field'): begin
        BSSreduction_Reduce_rsdf_nexus_cw_field, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='rsdf_browse_nexus_button'): begin
        BSSreduction_ReduceBrowseNexus, Event, 'rsdf'
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='rsdf_list_of_runs_text'): begin
        BSSreduction_Reduce_rsdf_list_of_runs_text, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='bdf_run_number_cw_field'): begin
        BSSreduction_Reduce_bdf_run_number_cw_field, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='bdf_nexus_cw_field'): begin
        BSSreduction_Reduce_bdf_nexus_cw_field, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='bdf_browse_nexus_button'): begin
        BSSreduction_ReduceBrowseNexus, Event, 'bdf'
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='bdf_list_of_runs_text'): begin
        BSSreduction_Reduce_bdf_list_of_runs_text, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='ndf_run_number_cw_field'): begin
        BSSreduction_Reduce_ndf_run_number_cw_field, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='ndf_nexus_cw_field'): begin
        BSSreduction_Reduce_ndf_nexus_cw_field, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='ndf_browse_nexus_button'): begin
        BSSreduction_ReduceBrowseNexus, Event, 'ndf'
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='ndf_list_of_runs_text'): begin
        BSSreduction_Reduce_ndf_list_of_runs_text, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='ecdf_run_number_cw_field'): begin
        BSSreduction_Reduce_ecdf_run_number_cw_field, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='ecdf_nexus_cw_field'): begin
        BSSreduction_Reduce_ecdf_nexus_cw_field, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='ecdf_browse_nexus_button'): begin
        BSSreduction_ReduceBrowseNexus, Event, 'ecdf'
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='ecdf_list_of_runs_text'): begin
        BSSreduction_Reduce_ecdf_list_of_runs_text, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='dsb_run_number_cw_field'): begin
        BSSreduction_Reduce_dsb_run_number_cw_field, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='dsb_nexus_cw_field'): begin
        BSSreduction_Reduce_dsb_nexus_cw_field, Event
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='dsb_browse_nexus_button'): begin
        BSSreduction_ReduceBrowseNexus, Event, 'dsb'
        BSSreduction_CommandLineGenerator, Event
    end    

    Widget_Info(wWidget, FIND_BY_UNAME='dsb_list_of_runs_text'): begin
        BSSreduction_Reduce_ecdf_list_of_runs_text, Event
        BSSreduction_CommandLineGenerator, Event
    end    

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

;tab6
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

;tab7 (intermediate plots)
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
    
;Start Data Reduction
    Widget_Info(wWidget, FIND_BY_UNAME='submit_button'): begin
        BSSreduction_RunCommandLine, Event
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
ENDIF

END
