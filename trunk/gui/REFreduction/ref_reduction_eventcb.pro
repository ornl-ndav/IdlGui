;This function get the nexus name from the data droplist and displays
;the nxsummary of that nexus file
PRO REFreductionEventcb_DisplayDataNxsummary, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

prevDataNexusIndex = (*global).PreviousDataNexusListSelected
currDataNexusIndex = getDropListSelectedIndex(Event,'data_list_nexus_droplist')

if (prevDataNexusIndex NE currDataNexusIndex) then begin

;reset value of previous index selected
    (*global).PreviousDataNexusListSelected = currDataNexusIndex

;get full name of index selected
    currFullDataNexusName = getDropListSelectedValue(Event, 'data_list_nexus_droplist')

;display NXsummary of that file
    RefReduction_NXsummary, $
      Event, $
      currFullDataNexusName, $
      'data_list_nexus_nxsummary_text_field'
endif 
END



;This function get the nexus name from the normalization droplist and displays
;the nxsummary of that nexus file
PRO REFreductionEventcb_DisplayNormNxsummary, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

prevNormNexusIndex = (*global).PreviousNormNexusListSelected
currNormNexusIndex = getDropListSelectedIndex(Event,'normalization_list_nexus_droplist')

if (prevNormNexusIndex NE currNormNexusIndex) then begin

;reset value of previous index selected
    (*global).PreviousNormNexusListSelected = currNormNexusIndex

;get full name of index selected
    currFullNormNexusName = getDropListSelectedValue(Event, 'normalization_list_nexus_droplist')

;display NXsummary of that file
    RefReduction_NXsummary, $
      Event, $
      currFullNormNexusName, $
      'normalization_list_nexus_nxsummary_text_field'
endif 
END



PRO REFreductionEventcb_CancelListOfDataNexus, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;map=0 the base
MapBase, Event, 'data_list_nexus_base', 0

;clear data run number entry
putTextFieldValue, event, 'load_data_run_number_text_field', '',0

;inform data log book and log book that process has been canceled
LogBookText = getLogBookText(Event)        
Message = 'CANCELED
putTextAtEndOfLogBookLastLine, $
  Event, $
  LogBookText, $
  Message, $
  (*global).processing_message

Message = ' ' + Message
DataLogBookText = getDataLogBookText(Event)
putTextAtEndOfDataLogBookLastLine,$
  Event,$
  DataLogBookText,$
  Message
END


PRO REFreductionEventcb_CancelListOfNormNexus, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;map=0 the base
MapBase, Event, 'norm_list_nexus_base', 0

;clear data run number entry
putTextFieldValue, event, 'load_normalization_run_number_text_field', '',0

;inform data log book and log book that process has been canceled
LogBookText = getLogBookText(Event)        
Message = 'CANCELED
putTextAtEndOfLogBookLastLine, $
  Event, $
  LogBookText, $
  Message, $
  (*global).processing_message

Message = ' ' + Message
NormLogBookText = getNormalizationLogBookText(Event)
putTextAtEndOfNormalizationLogBookLastLine,$
  Event,$
  NormLogBookText,$
  Message
END



PRO REFreductionEventcb_LoadListOfDataNexus, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;indicate reading data with hourglass icon
widget_control,/hourglass

;get full name of index selected
currFullDataNexusName = getDropListSelectedValue(Event, 'data_list_nexus_droplist')

;display message in data log book
InitialStrarr = getDataLogBookText(Event)
MessageToAdd = ' OK'
putTextAtEndOfDataLogBookLastLine, Event, InitialStrarr, MessageToAdd

DataLogBookMessage = 'Opening selected file ..... ' + (*global).processing_message
putDataLogBookMessage, Event, DataLogBookMessage, Append=1

;map=0 the base
MapBase, Event, 'data_list_nexus_base', 0

;get data run number
DataRunNumber = getTextFieldValue(Event,'load_data_run_number_text_field')

;Open That NeXus file
OpenDataNexusFile, Event, DataRunNumber, currFullDataNexusName

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

;display full path to NeXus in Norm log book
full_nexus_name = (*global).data_full_nexus_name
text = '(Nexus path: ' + strcompress(full_nexus_name,/remove_all) + ')'
putDataLogBookMessage, Event, text, Append=1

END




PRO REFreductionEventcb_LoadListOfNormNexus, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;indicate reading data with hourglass icon
widget_control,/hourglass

;get full name of index selected
currFullNormNexusName = getDropListSelectedValue(Event, 'normalization_list_nexus_droplist')

;display message in data log book
InitialStrarr = getNormalizationLogBookText(Event)
MessageToAdd = ' OK'
putTextAtEndOfNormalizationLogBookLastLine, Event, InitialStrarr, MessageToAdd

NormLogBookMessage = 'Opening selected file ..... ' + (*global).processing_message
putNormalizationLogBookMessage, Event, NormLogBookMessage, Append=1

;map=0 the base
MapBase, Event, 'norm_list_nexus_base', 0

;get data run number
NormRunNumber = getTextFieldValue(Event,'load_normalization_run_number_text_field')

;Open That NeXus file
OpenNormNexusFile, Event, NormRunNumber, currFullNormNexusName

REFreduction_Plot1D2DNormalizationFile, Event ;then plot data file (1D and 2D)

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

END





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


;This function is trigerred each time the user changes the NXsummary
;and zoom tab of the data tab
PRO REFreduction_DataNxsummaryZoomTab, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tab_id = widget_info(Event.top,find_by_uname='data_nxsummary_zoom_tab')
CurrTabSelect = widget_info(tab_id,/tab_current)
PrevTabSelect = (*global).PrevDataZoomTabSelect

if (PrevTabSelect NE CurrTabSelect) then begin
    CASE (CurrTabSelect) OF
    1: begin ;if Zoom tab selected
        putTextFieldValue,$
          Event,$
          'data_zoom_scale_cwfield',$
          (*global).DataZoomFactor,$
          0 ;do not append
        
        REFreduction_ZoomRescaleData, Event

    END
    else:
    ENDCASE
    (*global).PrevDataZoomTabSelect = CurrTabSelect
endif
END


;This function is trigerred each time the user changes the NXsummary
;and zoom tab of the normalization tab
PRO REFreduction_NormNxsummaryZoomTab, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tab_id = widget_info(Event.top,find_by_uname='normalization_nxsummary_zoom_tab')
CurrTabSelect = widget_info(tab_id,/tab_current)
PrevTabSelect = (*global).PrevNormZoomTabSelect

if (PrevTabSelect NE CurrTabSelect) then begin
    CASE (CurrTabSelect) OF
    1: begin ;if Zoom tab selected
        putTextFieldValue,$
          Event,$
          'normalization_zoom_scale_cwfield',$
          (*global).NormalizationZoomFactor,$
          0 ;do not append

        REFreduction_ZoomRescaleNormalization, Event

    END
    else:
    ENDCASE
    (*global).PrevNormZoomTabSelect = CurrTabSelect
endif
END



;this function is reached by the LOAD button for the DATA file
PRO REFreductionEventcb_LoadAndPlotDataFile, Event

REFreduction_LoadDataFile, Event, isNeXusFound, NbrNexus ;first Load the data file

if (isArchivedDataNexusDesired(Event)) then begin ;get full list of Nexus with this run number

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

endif else begin ;get full list of nexus file

    if (NbrNexus EQ 1) then begin

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

endelse

END


;this function is reached by the LOAD button for the NORMALIZATION file
PRO  REFreductionEventcb_LoadAndPlotNormalizationFile, Event

REFreduction_LoadNormalizationFile, Event, isNeXusFound, NbrNexus ;first Load the normalization file

if (isArchivedNormNexusDesired(Event)) then begin ;get full list of NeXus with this run number

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

endif else begin ;get full list of nexus file

    if (NbrNexus EQ 1) then begin

        REFreduction_Plot1D2DNormFile, Event ;the plot norm file (1D and 2D)

;get global structure
        id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
        widget_control,id,get_uvalue=global
        
;tell the user that the load and plot process is done
        InitialStrarr = getNormLogBookText(Event)
        putTextAtEndOfNormLogBookLastLine, $
          Event, $
          InitialStrarr, $
          ' Done', $
          (*global).processing_message
        
;display full path to NeXus in Norm log book
        full_nexus_name = (*global).norm_full_nexus_name
        text = '(Nexus path: ' + strcompress(full_nexus_name,/remove_all) + ')'
        putNormLogBookMessage, Event, text, Append=1

    endif

endelse


END


;start the xloadct window
PRO REFreductionEventcb_DataContrastEditor, Event
xloadct,/modal,group=id
RePlot1DDAtaFile, Event
REFreduction_DataBackgroundPeakSelection, Event
END


PRO REFreductionEventcb_DataResetContrastEditor, Event
loadct,5
RePlot1DDAtaFile, Event
REFreduction_DataBackgroundPeakSelection, Event
END






PRO blabla, Event
end

pro ref_reduction_eventcb
end


pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end


