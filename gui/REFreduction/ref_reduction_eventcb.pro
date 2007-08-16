;this function is reached by the LOAD button for the DATA file
PRO REFreductionEventcb_LoadAndPlotDataFile, Event

;first Load the data file
REFreduction_LoadDataFile, Event

;then plot data file
REFreduction_Plot1D2DDataFile, Event

END


pro ref_reduction_eventcb
end


pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end


