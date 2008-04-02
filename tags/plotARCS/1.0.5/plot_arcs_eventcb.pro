;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO LaunchPlot, Event
tabSelected = getTabSelected(Event)
IF (tabSelected EQ 0) THEN BEGIN ;histogram input
;get name of histo_mapped_file
    histo_mapped_file = getTextFieldValue(Event, 'histo_mapped_text_field')
    PlotMainPlot, histo_mapped_file ;in plot_arcs_PlotMainPlot
ENDIF ELSE begin
    NexusFileName = getNexusFileName(Event)
    PlotMainPlotFromNexus, NexusFileName
ENDELSE
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO TabEventcb, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
tabSelected     = getTabSelected(Event)
prevTabSelected = (*global).HistoNexusTabSelected
IF (tabSelected NE prevTabSelected) THEN BEGIN
    (*global).HistoNexusTabSelected = tabSelected
    IF (tabSelected EQ 0) THEN BEGIN ;histogram input
        ActivateOrNotPlotButton, Event    
    ENDIF ELSE begin
        ActivateOrNotPlotButton_from_NexusTab, Event
    ENDELSE
ENDIF
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
END


