;this function is reached by the LOAD button for the DATA file
PRO REFreductionEventcb_LoadAndPlotDataFile, Event
REFreduction_LoadDataFile, Event, isNeXusFound ;first Load the data file
if (isNeXusFound) then begin
    REFreduction_Plot1D2DDataFile, Event ;then plot data file (1D and 2D)

;get global structure
    id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
    widget_control,id,get_uvalue=global

;tell the user that the load and plot process is done
    InitialStrarr = getDataLogBookText(Event)
    putTextAtEndOfDataLogBookLastLine, $
      Event, $
      InitialStrarr, $
      ' Done', $
      (*global).processing_message
endif
END


;this function is reached by the LOAD button for the NORMALIZATION file
PRO  REFreductionEventcb_LoadAndPlotNormalizationFile, Event
REFreduction_LoadNormalizationFile, Event, isNeXusFound ;first Load the normalization file
if (isNeXusFound) then begin 
    REFreduction_Plot1D2DNormalizationFile, Event ; then plot data file (1D and 2D)

;get global structure
    id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
    widget_control,id,get_uvalue=global

;tell the user that the load and plot process is done
    InitialStrarr = getNormalizationLogBookText(Event)
    putTextAtEndOfNormalizationLogBookLastLine, $
      Event, $
      InitialStrarr, $
      ' Done', $
      (*global).processing_message
endif
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


