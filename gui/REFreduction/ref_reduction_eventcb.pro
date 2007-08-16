;this function is reached by the LOAD button for the DATA file
PRO REFreductionEventcb_LoadAndPlotDataFile, Event
REFreduction_LoadDataFile, Event ;first Load the data file
REFreduction_Plot1D2DDataFile, Event ;then plot data file (1D and 2D)
END


;this function is reached by the LOAD button for the NORMALIZATION file
PRO  REFreductionEventcb_LoadAndPlotNormalizationFile, Event
REFreduction_LoadNormalizationFile, Event ;first Load the normalization file
REFreduction_Plot1D2DNormalizationFile, Event ; then plot data file (1D and 2D)
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


