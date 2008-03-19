PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END

;'Run #' cw_field in INPUT base
    widget_info(wWidget, FIND_BY_UNAME='run_number'): begin
        InputRunNumber, Event   ;in plot_arcs_Input.pro
        ActivateHistoMappingBasesStatus, Event ;in plot_arcs_GUIupdate.pro
        GetHistogramInfo, Event ;in plot_arcs_CollectHistoInfo.pro
        ActivateOrNotCreateHistogramMapped, Event ;in plot_arcs_GUIupdate.pro
        ActivateOrNotPlotButton, Event ;in plot_arcs_GUIupdate.pro
    end
    
;'BROWSE EVENT FILE' button in INPUT base
    widget_info(wWidget, FIND_BY_UNAME='browse_event_file_button'): begin
        BrowseEventRunNumber, Event ;in plot_arcs_Browse.pro
        ActivateHistoMappingBasesStatus, Event ;in plot_arcs_GUIupdate.pro
        GetHistogramInfo, Event ;in plot_arcs_CollectHistoInfo.pro
        ActivateOrNotCreateHistogramMapped, Event ;in plot_arcs_GUIupdate.pro
    end

;preview runinfo file
    widget_info(wWidget, FIND_BY_UNAME='preview_runinfo_file'): begin
        PreviewRuninfoFile, Event ;in plot_arcs_PreviewRuninfoFile.pro
    end

;'Event File' widget_text in INPUT base
    widget_info(wWidget, FIND_BY_UNAME='event_file'): begin
        putTextInTextField, Event, 'histo_mapped_text_field', ''
        ActivateOrNotPlotButton, Event ;in plot_arcs_GUIupdate.pro
        ActivateHistoMappingBaseFromWidgetText, Event ;in plot_arcs_GUIupdate.pro
        ActivateOrNotCreateHistogramMapped, Event ;in plot_arcs_GUIupdate.pro
        GetHistogramInfo, Event ;in plot_arcs_CollectHistoInfo.pro
    end

;'max_time_bin' 
    widget_info(wWidget, FIND_BY_UNAME='max_time_bin'): begin
        ActivateOrNotCreateHistogramMapped, Event ;in plot_arcs_GUIupdate.pro
    end

;'bin_width' 
    widget_info(wWidget, FIND_BY_UNAME='bin_width'): begin
        ActivateOrNotCreateHistogramMapped, Event ;in plot_arcs_GUIupdate.pro
    end

;create_histo_mapped_button
    widget_info(wWidget, FIND_BY_UNAME='create_histo_mapped_button'): begin
        CreateHistoMapped, Event ;in plot_arcs_CreateHistoMapped.pro
    end

;'BROWSE HISTO FILE' button
    widget_info(wWidget, FIND_BY_UNAME='browse_histo_mapped_button'): begin
        BrowseHistoFile, Event ;in plot_arcs_Browse.pro
        ActivateOrNotPlotButton, Event ;in plot_arcs_GUIupdate.pro
    end

;'histo_mapped text_field'
    widget_info(wWidget, FIND_BY_UNAME='histo_mapped_text_field'): begin
        ActivateOrNotPlotButton, Event ;in plot_arcs_GUIupdate.pro
    end

;SAVE AS button
    widget_info(wWidget, FIND_BY_UNAME='save_as_histo_mapped_button'): begin
        SaveAsHistoMappedFile, Event ;in plot_arcs_SaveAsHistoMapped.pro
    end

;send to geek button
    widget_info(wWidget, FIND_BY_UNAME='send_to_geek_button'): begin
        LogBook, Event ;in plot_arcs_SendToGeek.pro
    end

;-------------------------------------------------------------------------------
;***** NeXus Tab ***************************************************************
;-------------------------------------------------------------------------------
;Run Number CW_FIELD
    widget_info(wWidget, FIND_BY_UNAME='run_number_cw_field'): begin
        RetrieveFullNexusFileName, Event ;_Nexus
    end

;Archived or ListAll
    widget_info(wWidget, FIND_BY_UNAME='archived_or_list_all'): begin
        ArchivedOrListAll, Event ;_Nexus
    end

;Browse Nexus
    widget_info(wWidget, FIND_BY_UNAME='browse_nexus_button'): begin
        BrowseNexus, Event ;_Nexus
    end

;-------------------------------------------------------------------------------
;***** PLOT BUTTON *************************************************************
;-------------------------------------------------------------------------------
    widget_info(wWidget, FIND_BY_UNAME='plot_button'): begin
        LaunchPlot, Event     ;_eventcb
    end

    ELSE:
    
ENDCASE

END
