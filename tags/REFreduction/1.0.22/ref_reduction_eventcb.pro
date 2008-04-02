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
currNormNexusIndex = getDropListSelectedIndex(Event, $
                                              'normalization_list_nexus_droplist')

if (prevNormNexusIndex NE currNormNexusIndex) then begin

;reset value of previous index selected
    (*global).PreviousNormNexusListSelected = currNormNexusIndex

;get full name of index selected
    currFullNormNexusName = $
      getDropListSelectedValue(Event, $
                               'normalization_list_nexus_droplist')

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
Message = 'CANCELED'
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
Message = 'CANCELED'
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
    
IF ((*global).isHDF5format) THEN BEGIN
        
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
        
    ENDIF

;to see the last line of the data log book
showLastDataLogBookLine, Event
END


;This procedure is reached by the IDLupdateGui class
PRO REFreduction_OpenPlotDataNexus, Event, DataRunNumber, currFullDataNexusName
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;Open That NeXus file
OpenDataNexusFile_batch, Event, DataRunNumber, currFullDataNexusName
(*global).DataNexusFound  = 1
REFreduction_Plot1D2DDataFile_batch, Event ;then plot data file (1D and 2D)
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
;to see the last line of the data log book
showLastDataLogBookLine, Event
END




PRO REFreductionEventcb_LoadListOfNormNexus, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;indicate reading data with hourglass icon
widget_control,/hourglass

;get full name of index selected
currFullNormNexusName = getDropListSelectedValue(Event, $
                                                 'normalization_list_nexus_droplist')

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

IF ((*global).isHDF5format) THEN BEGIN

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
    
ENDIF

;to see the last line of the norm log book
showLastNormLogBookLine, Event

END


;This procedure is reached by the IDLupdateGui class
PRO REFreduction_OpenPlotNormNexus, Event, $
                                    NormRunNumber, $
                                    currFullNormNexusName
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
OpenNormNexusFile_batch, Event, NormRunNumber, currFullNormNexusName
(*global).NormNexusFound = 1
;then plot data file (1D and 2D)
REFreduction_Plot1D2DNormalizationFile_batch, Event 
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
;to see the last line of the norm log book
showLastNormLogBookLine, Event
END




;This function run the command line and will output the plot and info text
PRO REFreductionEventcb_ProcessingCommandLine, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;first run the command line
RefReduction_RunCommandLine, Event

IF ((*global).DataReductionStatus EQ 'OK') then begin ;data reduction was successful
    
    instrument      = (*global).instrument
    IntermPlots     = (*global).IntermPlots
    ExtOfAllPlots   = (*(*global).ExtOfAllPlots)
    data_run_number = (*global).data_run_number
    IsoTimeStamp    = (*global).IsoTimeStamp

;creates array of all files to plot
    FilesToPlotList = $
      getListOfFilesToPlot(Event,$
                           IntermPlots,$ ;[0,0,1,1,0,0,1]
                           ExtOfAllPlots,$ ;[.txt,.sdc,.....]
                           IsoTimeStamp,$ ;2007-08-31T09:24:45-04:00
                           instrument,$ ;REF_L
                           data_run_number) ;3454
    
    (*(*global).FilesToPlotList) = FilesToPlotList

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
    
    RefReduction_UpdatePlotsGui, Event

;;Plot main data reduction plot for the first time
    RefReduction_PlotMainDataReductionFileFirstTime, Event
    
ENDIF
        
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

IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
    CASE (CurrTabSelect) OF
    1: BEGIN ;if REDUCE tab is now selected
        REFreduction_CommandLineGenerator, Event
    END
    2: BEGIN ;if PLOTS tab is now selected
        IF ((*global).DataReductionStatus EQ 'OK') THEN BEGIN 
;data reduction was successful
            RefReduction_PlotMainIntermediateFiles, Event
        ENDIF
    END
    3: BEGIN ;if BATCH tab is now selected
;retrieve info for batch mode
        IF ((*global).debugger) THEN BEGIN
            UpdateBatchTable, Event ;in ref_reduction_BatchTab.pro
        ENDIF
    END
    ELSE:
    ENDCASE
    (*global).PrevTabSelect = CurrTabSelect
ENDIF
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

;get global structure
widget_control,Event.top,get_uvalue=global

IF (isArchivedDataNexusDesired(Event)) THEN BEGIN 
;get full list of Nexus with this run number
    
    IF (isNeXusFound) THEN BEGIN
        
        IF ((*global).isHDF5format) THEN BEGIN ;continue only if it's a HDF5 file
            
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
            
        ENDIF
    ENDIF
    
ENDIF ELSE BEGIN                ;get full list of nexus file
    
    IF (NbrNexus EQ 1) THEN BEGIN

        IF ((*global).isHDF5format) THEN BEGIN ;continue only if it's a HDF5 file  

;check also format of file loaded in the list            
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
            
        ENDIF

    ENDIF
    
ENDELSE

END


;this function is reached by the LOAD button for the NORMALIZATION file
PRO  REFreductionEventcb_LoadAndPlotNormFile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;first Load the normalization file
REFreduction_LoadNormalizationFile, Event, isNeXusFound, NbrNexus 

;get full list of NeXus with this run number
if (isArchivedNormNexusDesired(Event)) then begin 
    if (isNeXusFound) then begin 
        
        IF ((*global).isHDF5format) THEN BEGIN ;continue only if it's a HDF5 file
            
; then plot data file (1D and 2D)
            REFreduction_Plot1D2DNormalizationFile, Event 
            
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

        ENDIF

    ENDIF 
    
ENDIF ELSE BEGIN                ;get full list of nexus file

    IF (NbrNexus EQ 1) THEN BEGIN

        IF ((*global).isHDF5format) THEN BEGIN ;continue only if it's a HDF5 file

;the plot norm file (1D and 2D)
            REFreduction_Plot1D2DNormalizationFile, Event 
            
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

        ENDIF

    ENDIF

ENDELSE

END


;######## CONTRAST DATA #######
;start the xloadct window
PRO REFreductionEventcb_DataContrastEditor, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).DataNexusFound) then begin

    prevIndex = (*global).PreviousDataContrastDroplistIndex
    currIndex = getDropListSelectedIndex(Event,'data_contrast_droplist')
    
    if (prevIndex Ne currIndex) then begin
        REFreduction_refreshDataPlot, Event
        (*global).PreviousDataContrastDroplistIndex = currIndex
    endif

endif
END


PRO REFreductionEventcb_DataResetContrastEditor, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;reset droplist and sliders
setDropListValue, Event, 'data_contrast_droplist', $
  (*global).InitialDataContrastDropList
setSliderValue, Event, 'data_contrast_bottom_slider', 0
setSliderValue, Event, 'data_contrast_number_slider', 255

if ((*global).DataNexusFound) then begin
    REFreduction_refreshDataPlot, Event
endif
END



;Data Contrast Bottom Slider
PRO  REFreductionEventcb_DataContrastBottomSlider, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).DataNexusFound) then begin

    prevIndex = (*global).PreviousDataContrastBottomSliderIndex
    currIndex = getSliderValue(Event,'data_contrast_bottom_slider')
    
    if (prevIndex NE currIndex) then begin
        REFreduction_refreshDataPlot, Event
        (*global).PreviousDataContrastBottomSliderIndex = currIndex
    endif

endif

END


;Data Contrast Number Slider
PRO REFreductionEventcb_DataContrastNumberSlider, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).DataNexusFound) then begin

    prevIndex = (*global).PreviousDataContrastNumberSliderIndex
    currIndex = getSliderValue(Event,'data_contrast_number_slider')
    
    if (prevIndex NE currIndex) then begin
        REFreduction_refreshDataPlot, Event
        (*global).PreviousDataContrastNumberSliderIndex = currIndex
    endif

endif

END


PRO REFreduction_refreshDataPlot, Event
;get droplist index
LoadctIndex = getDropListSelectedIndex(Event,'data_contrast_droplist')
;get bottom value of color
BottomColorValue = getSliderValue(Event,'data_contrast_bottom_slider')
;get number of color
NumberColorValue = getSliderValue(Event,'data_contrast_number_slider')

loadct,loadctIndex, Bottom=BottomColorValue,NColors=NumberColorValue
RePlot1DDAtaFile, Event
REFreduction_DataBackgroundPeakSelection, Event
END


;######## CONTRAST NORMALIZATION #######
;start the xloadct window
PRO REFreductionEventcb_NORMContrastEditor, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).NormNexusFound) then begin

    prevIndex = (*global).PreviousNormContrastDroplistIndex
    currIndex = getDropListSelectedIndex(Event,'normalization_contrast_droplist')

    if (prevIndex Ne currIndex) then begin
        REFreduction_refreshNormPlot, Event
        (*global).PreviousNormContrastDroplistIndex = currIndex
    endif

endif
END


PRO REFreductionEventcb_NormResetContrastEditor, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;reset droplist and sliders
setDropListValue, Event, 'normalization_contrast_droplist', $
  (*global).InitialNormContrastDropList
setSliderValue, Event, 'normalization_contrast_bottom_slider', 0
setSliderValue, Event, 'normalization_contrast_number_slider', 255

if ((*global).NormNexusFound) then begin
    REFreduction_refreshNormPlot, Event
endif
END



;Data Contrast Bottom Slider
PRO  REFreductionEventcb_NormContrastBottomSlider, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).NormNexusFound) then begin

    prevIndex = (*global).PreviousNormContrastBottomSliderIndex
    currIndex = getSliderValue(Event,'normalization_contrast_bottom_slider')
    
    if (prevIndex NE currIndex) then begin
        REFreduction_refreshNormPlot, Event
        (*global).PreviousNormContrastBottomSliderIndex = currIndex
    endif

endif

END


;Data Contrast Number Slider
PRO REFreductionEventcb_NormContrastNumberSlider, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).NormNexusFound) then begin

    prevIndex = (*global).PreviousNormContrastNumberSliderIndex
    currIndex = getSliderValue(Event,'normalization_contrast_number_slider')
    
    if (prevIndex NE currIndex) then begin
        REFreduction_refreshNormPlot, Event
        (*global).PreviousNormContrastNumberSliderIndex = currIndex
    endif

endif

END



PRO REFreduction_refreshNormPlot, Event
;get droplist index
LoadctIndex = getDropListSelectedIndex(Event,'normalization_contrast_droplist')
;get bottom value of color
BottomColorValue = getSliderValue(Event,'normalization_contrast_bottom_slider')
;get number of color
NumberColorValue = getSliderValue(Event,'normalization_contrast_number_slider')

loadct,loadctIndex, Bottom=BottomColorValue,NColors=NumberColorValue
RePlot1DNormFile, Event
REFreduction_NormBackgroundPeakSelection, Event
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


