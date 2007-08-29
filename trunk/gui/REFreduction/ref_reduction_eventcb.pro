;This function defines the instrument if the program is started from 
;heater
PRO REFreductionEventcb_InstrumentSelected, Event

id = widget_info(Event.top,find_by_uname='instrument_selection_cw_bgroup')
widget_control, id, get_value=instrument_selected

;descativate instrument selection base and activate main base
ISBaseID = widget_info(Event.top,find_by_uname='MAIN_BASE')
widget_control, ISBaseId, map=0

if (instrument_selected EQ 0) then begin
   BuildGui, 'REF_L', GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
endif else begin
   BuildGui, 'REF_M', GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
endelse

END


;this function is trigerred each time the user changes tab
PRO tab_event, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tab_id = widget_info(Event.top,find_by_uname='main_tab')
CurrTabSelect = widget_info(tab_id,/tab_current)
PrevTabSelect = (*global).PrevTabSelect

if (PrevTabSelect NE CurrTabSelect) then begin
    if (CurrTabSelect EQ 1) then begin ;if REDUCE tab is now selected
        REFreduction_CommandLineGenerator, Event
    endif
    (*global).PrevTabSelect = CurrTabSelect
endif


END


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

;display full path to NeXus in Data log book
    full_nexus_name = (*global).data_full_nexus_name
    text = '(Nexus path: ' + strcompress(full_nexus_name,/remove_all) + ')'
    putDataLogBookMessage, Event, text, Append=1
    
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

;display full path to NeXus in Norm log book
    full_nexus_name = (*global).norm_full_nexus_name
    text = '(Nexus path: ' + strcompress(full_nexus_name,/remove_all) + ')'
    putNormalizationLogBookMessage, Event, text, Append=1

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


