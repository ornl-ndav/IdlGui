;This function run the command line and will output the plot and info text
PRO REFreductionEventcb_ProcessingCommandLine, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;first run the command line
RefReduction_RunCommandLine, Event

;if ((*global).DataReductionStatus EQ 'OK') then begin ;data reduction was successful
    
instrument      = (*global).instrument
IntermPlots     = (*global).IntermPlots
ExtOfAllPlots   = (*(*global).ExtOfAllPlots)
data_run_number = (*global).data_run_number
IsoTimeStamp    = (*global).IsoTimeStamp

;creates array of all files to plot
FilesToPlotList = $
  getListOfFilesToPlot(IntermPlots,$ ;[0,0,1,1,0,0,1]
                       ExtOfAllPlots,$ ;[.txt,.sdc,.....]
                       IsoTimeStamp,$ ;2007-08-31T09:24:45-04:00
                       instrument,$ ;REF_L
                       data_run_number) ;3454

(*(*global).FilesToPlotList) = FilesToPlotList

;REMOVE_ME
FilesToPlotList[0] = $
  '~/REF_L_3000_2007-08-31T12:08:05-04:00.txt' 
FilesToPlotList[1] = $
  '~/REF_L_3000_2007-08-31T12:08:05-04:00.rmd' 

;get metadata
NbrLine = (*global).PreviewFileNbrLine
RefReduction_SaveFileInfo, Event, FilesToPlotList, NbrLine
RefReduction_SaveXmlInfo, Event, FilesToPlotList[1]

;Display main data reduction metadata in Plots tab
;and XML file in Reduce tab
RefReduction_DisplayMainDataReductionMetadataFile, Event
REfReduction_DisplayXmlFile, Event

;Load main data reduction and all intermediate files (if any)
;get flt0, flt1 and flt2 and put them into array
    RefReduction_LoadMainOutputFile, Event, FilesToPlotList[0]
;    RefReduction_LoadXmlOutputFile, Event, FilesToPlotList[1]
;    RefReduction_LoadIntermediateFiles, Event, FilesToPlotList 
    
;;Plot main data reduction plot for the first time
    RefReduction_PlotMainDataReductionFileFirstTime, Event


;endif

END


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
    CASE (CurrTabSelect) OF
    1: begin ;if REDUCE tab is now selected
        REFreduction_CommandLineGenerator, Event
    END
    2: begin ;if PLOTS tab is now selected
        FilesToPlotList = (*(*global).FilesToPlotList)
        RefReduction_LoadMainOutputFile, Event, FilesToPlotList[0]
    END
    else:
    ENDCASE
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


