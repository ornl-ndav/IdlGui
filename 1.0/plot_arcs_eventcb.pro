;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO LaunchPlot, Event
tabSelected = getTabSelected(Event)
IF (tabSelected EQ 0) THEN BEGIN ;histogram input
;get name of histo_mapped_file
    histo_mapped_file = getTextFieldValue(Event, 'histo_mapped_text_field')
    PlotMainPlot, histo_mapped_file ;in plot_arcs_PlotMainPlot
ENDIF ELSE begin
    NexusFileName = getNexusFileName(Event)
    print, NexusFileName
    PlotMainPlotFromNexus, NexusFileName
ENDELSE
END

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
END


