;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

;------------------------------------------------------------------------------
;this function is reached by the LOAD button for the DATA file
PRO REFreductionEventcb_LoadAndPlotDataFile, Event
REFreduction_LoadDataFile, Event, $ ;LoadDataFile
  isNeXusFound, $
  NbrNexus 
END

;------------------------------------------------------------------------------
;this function is reached by the LOAD button for the NORMALIZATION file
PRO  REFreductionEventcb_LoadAndPlotNormFile, Event
REFreduction_LoadNormalizationFile, Event, $ ;LoadNormalizationFile
  isNeXusFound, $
  NbrNexus 
END

;------------------------------------------------------------------------------
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
    currFullDataNexusName = $
      getDropListSelectedValue(Event, $
                               'data_list_nexus_droplist')

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
currNormNexusIndex = $
  getDropListSelectedIndex(Event, $
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
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;indicate reading data with hourglass icon
WIDGET_CONTROL,/HOURGLASS

;get full name of index selected
currFullDataNexusName = $
  getDropListSelectedValue(Event, 'data_list_nexus_droplist')
full_nexus_name = currFullDataNexusName
(*global).data_nexus_full_path = full_nexus_name

;display message in data log book
InitialStrarr = getDataLogBookText(Event)
MessageToAdd = ' OK'
putTextAtEndOfDataLogBookLastLine, Event, InitialStrarr, MessageToAdd

DataLogBookMessage = 'Opening selected file:'
IDLsendLogBook_addLogBookText, Event, DataLogBookMessage

;map=0 the base
MapBase, Event, 'data_list_nexus_base', 0

;get data run number
DataRunNumber = getTextFieldValue(Event,'load_data_run_number_text_field')
    
;check how many polarization states the file has
nbr_pola_state = $
  check_number_polarization_state(Event, $
                                  full_nexus_name, $
                                  list_pola_state)
IF (nbr_pola_state EQ -1) THEN BEGIN ;missing function
    RETURN
ENDIF

IF (nbr_pola_state EQ 1) THEN BEGIN ;only 1 polarization state

;load browse nexus file
    result = OpenDataNexusFile(Event, DataRunNumber, full_nexus_name)
    
;plot data now
    result = REFreduction_Plot1D2DDataFile(Event) 
    IF (result EQ 0) THEN BEGIN
        (*global).DataNeXusFound = 0
        IDLsendLogBook_ReplaceLogBookText, $
          Event, $
          ALT=1, $
          PROCESSING, $
          FAILED
        RETURN
    ENDIF
    
;update GUI according to result of NeXus found or not
    RefReduction_update_data_gui_if_NeXus_found, $
      Event, $
      result
    
    (*global).DataNeXusFound = 1

    WIDGET_CONTROL,HOURGLASS=0
    
ENDIF ELSE BEGIN
    
    WIDGET_CONTROL,HOURGLASS=0
    
;ask user to select the polarization state he wants to see
    (*global).pola_type = 'data_load'
    select_polarization_state, Event, $
      full_nexus_name, $
      list_pola_state

ENDELSE                         ;end of "IF (nbr_pola_state EQ 1)"
END

;------------------------------------------------------------------------------
;This procedure is reached by the IDLupdateGui class
PRO REFreduction_OpenPlotDataNexus, Event, DataRunNumber, currFullDataNexusName
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;Open That NeXus file
IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Just before OpenDataNexusFile_batch'
ENDIF
OpenDataNexusFile_batch, Event, DataRunNumber, currFullDataNexusName
IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Just after OpenDataNexusFile_batch'
ENDIF

(*global).DataNexusFound  = 1

IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Just before REFreduction_Plot1D2DDataFile_batch'
ENDIF
;then plot data file (1D and 2D)
result = REFreduction_Plot1D2DDataFile_batch(Event) 
IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Just after REFreduction_Plot1D2DDataFile_batch'
ENDIF

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

;------------------------------------------------------------------------------
PRO REFreductionEventcb_LoadListOfNormNexus, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Entering REFreductionEventcb_LoadListOfNormNexus'
ENDIF

;indicate reading data with hourglass icon
WIDGET_CONTROL,/HOURGLASS

PROCESSING = (*global).processing_message ;processing message
OK         = (*global).ok
FAILED     = (*global).failed

;get full name of index selected
currFullNormNexusName = $
  getDropListSelectedValue(Event, $
                           'normalization_list_nexus_droplist')
full_nexus_name = currFullNormNexusName
(*global).norm_nexus_full_path = full_nexus_name

;display message in data log book
InitialStrarr = getNormalizationLogBookText(Event)
MessageToAdd = ' OK'
putTextAtEndOfNormalizationLogBookLastLine, Event, InitialStrarr, MessageToAdd

NormLogBookMessage = 'Opening selected file:'
putNormalizationLogBookMessage, Event, NormLogBookMessage, Append=1

;map=0 the base
MapBase, Event, 'norm_list_nexus_base', 0

;get data run number
NormRunNumber = getTextFieldValue(Event, $
                                  'load_normalization_run_number_text_field')

;check how many polarization states the file has
nbr_pola_state = $
  check_number_polarization_state(Event, $
                                  full_nexus_name, $
                                  list_pola_state)
IF (nbr_pola_state EQ -1) THEN BEGIN ;missing function
    RETURN
ENDIF

IF (nbr_pola_state EQ 1) THEN BEGIN ;only 1 polarization state

    result = OpenNormNexusFile(Event, NormRunNumber, full_nexus_name)
    isNexusFound = result
    
;plot normalization data now
    result = REFreduction_Plot1D2DNormalizationFile(Event) 
    IF (result EQ 0) THEN BEGIN
        IDLsendLogBook_ReplaceLogBookText, $
          Event, $
          ALT=2, $
          PROCESSING, $
          FAILED
        RETURN
    ENDIF
    
    (*global).NormNeXusFound = 1

;update GUI according to result of NeXus found or not
    RefReduction_update_normalization_gui_if_NeXus_found, $
      Event, 1
    
    LogBookText = getNormalizationLogBookText(Event)
    putTextAtEndOfNormalizationLogBookLastLine,$
      Event,$
      LogBookText,$
      OK,$
      PROCESSING
    
    WIDGET_CONTROL,HOURGLASS=0
    
ENDIF ELSE BEGIN
    
    WIDGET_CONTROL,HOURGLASS=0
    
;ask user to select the polarization state he wants to see
    (*global).pola_type = 'norm_load'
    select_polarization_state, Event, $
      full_nexus_name, $
      list_pola_state
    
ENDELSE                         ;end of "IF (nbr_pola_state EQ 1)"

IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Leaving REFreductionEventcb_LoadListOfNormNexus'
ENDIF

END

;------------------------------------------------------------------------------
;This procedure is reached by the IDLupdateGui class
PRO REFreduction_OpenPlotNormNexus, Event, $
                                    NormRunNumber, $
                                    currFullNormNexusName
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Entering REFreduction_OpenPlotNormNexus'
    print, 'Just before OpenNormNexusFile_Batch'
ENDIF
OpenNormNexusFile_batch, Event, NormRunNumber, currFullNormNexusName
IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Just after OpenNormNexusFile_Batch'
ENDIF

(*global).NormNexusFound = 1
;then plot data file (1D and 2D)

IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Just before REFreduction_Plot1D2DNormalizationFile_batch'
ENDIF
result = REFreduction_Plot1D2DNormalizationFile_batch(Event) 
IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Just after REFreduction_Plot1D2DNormalizationFile_batch'
ENDIF

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

IF ((*global).DataReductionStatus EQ 'OK') then begin 
;data reduction was successful
    
;get name of .txt file
    output_file_path   = getOutputPathFromButton(Event)
    output_file_name   = getOutputFileName(Event)
    FullOutputFileName = output_file_path + output_file_name
    FullXmlFileName    = getXmlFileName(FullOutputFileName)

;get metadata
    RefReduction_SaveXmlInfo, Event,  FullXmlFileName
    
;Display XML file in Reduce tab
    REfReduction_DisplayXmlFile, Event
    
;Load main data reduction File and 
;get flt0, flt1 and flt2 and put them into array
    RefReduction_LoadMainOutputFile, Event, FullOutputFileName
    
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

;==============================================================================
;this function is trigerred each time the user changes tab (main tabs)
PRO tab_event, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tab_id = widget_info(Event.top,find_by_uname='main_tab')
CurrTabSelect = widget_info(tab_id,/tab_current)
PrevTabSelect = (*global).PrevTabSelect

IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
    CASE (CurrTabSelect) OF
        1: BEGIN                ;if REDUCE tab is now selected
            REFreduction_CommandLineGenerator, Event
        END
        2: BEGIN                ;if PLOTS tab is now selected
            IF ((*global).DataReductionStatus EQ 'OK') THEN BEGIN 
;data reduction was successful
                RefReduction_PlotMainDataReductionFileFirstTime, Event
            ENDIF
        END
        3: BEGIN                ;if BATCH tab is now selected
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
;==============================================================================

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

tab_id = widget_info(Event.top, $
                     find_by_uname='normalization_nxsummary_zoom_tab')
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


pro tmp

;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

IF (isArchivedDataNexusDesired(Event)) THEN BEGIN 
;get full list of Nexus with this run number
    
    IF (isNeXusFound) THEN BEGIN
        
        IF ((*global).isHDF5format) THEN BEGIN 
;continue only if it's a HDF5 file
       
            (*global).DataNeXusFound = isNeXusFound
     
            REFreduction_Plot1D2DDataFile, Event 
;then plot data file (1D and 2D)
            
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
            text = '(Nexus path: ' + $
              strcompress(full_nexus_name,/remove_all) + ')'
            putDataLogBookMessage, Event, text, Append=1

;replot the background and peak exclusion regions
            REFreduction_DataBackgroundPeakSelection, Event, '' 
;in _databackgroundpeakselection

            (*global).DataNeXusFound = isNeXusFound

        ENDIF
    ENDIF
    
ENDIF ELSE BEGIN                ;get full list of nexus file
    
    IF (NbrNexus EQ 1) THEN BEGIN

        IF ((*global).isHDF5format) THEN BEGIN 
;continue only if it's a HDF5 file  

;check also format of file loaded in the list            
            REFreduction_Plot1D2DDataFile, Event 
;then plot data file (1D and 2D)
            
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
            text = '(Nexus path: ' + $
              strcompress(full_nexus_name,/remove_all) + ')'
            putDataLogBookMessage, Event, text, Append=1

;replot the background and peak exclusion regions
            REFreduction_DataBackgroundPeakSelection, Event, ''
            
            (*global).DataNeXusFound = isNeXusFound

        ENDIF

    ENDIF
    
ENDELSE

END





pro tmp_2
;get full list of NeXus with this run number
if (isArchivedNormNexusDesired(Event)) then begin 
    if (isNeXusFound) then begin 
        
        IF ((*global).isHDF5format) THEN BEGIN 
;continue only if it's a HDF5 file
            
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
            text = '(Nexus path: ' + $
              strcompress(full_nexus_name,/remove_all) + ')'
            putNormalizationLogBookMessage, Event, text, Append=1

;display back and peak exclusion regions
            REFreduction_NormBackgroundPeakSelection, Event, ''

            (*global).NormNeXusFound = isNexusFound

        ENDIF

    ENDIF 
    
ENDIF ELSE BEGIN                ;get full list of nexus file

    IF (NbrNexus EQ 1) THEN BEGIN

        IF ((*global).isHDF5format) THEN BEGIN 
;continue only if it's a HDF5 file

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
            text = '(Nexus path: ' + $
              strcompress(full_nexus_name,/remove_all) + ')'
            putNormalizationLogBookMessage, Event, text, Append=1

;display back and peak exclusion regions
            REFreduction_NormBackgroundPeakSelection, Event, ''

            (*global).NormNeXusFound = isNexusFound

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
REFReduction_RescaleDataPlot, Event
END


;######## CONTRAST NORMALIZATION #######
;start the xloadct window
PRO REFreductionEventcb_NORMContrastEditor, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

if ((*global).NormNexusFound) then begin

    prevIndex = (*global).PreviousNormContrastDroplistIndex
    currIndex = getDropListSelectedIndex(Event, $
                                         'normalization_contrast_droplist')

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

;------------------------------------------------------------------------------
PRO REFreduction_refreshNormPlot, Event
REFReduction_RescaleNormalizationPlot,Event
END

;------------------------------------------------------------------------------
;This procedure is reached each time the user changed a tab of the
;plot in the data tab
PRO data_plots_tab_event, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

info_base_status = 0

IF ((*global).DataNexusFound) THEN BEGIN

    tab_id = widget_info(Event.top,find_by_uname='load_data_d_dd_tab')
    CurrTabSelect = widget_info(tab_id,/tab_current)
    PrevTabSelect = (*global).PrevDataTabSelect
    
    CASE (CurrTabSelect) OF
        0: info_base_status = 1
        ELSE:
    ENDCASE

    IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
        CASE (CurrTabSelect) OF
            2: BEGIN            ;Y vs X (2D)
                IF ((*global).data_loadct_contrast_changed) THEN BEGIN
                    refreshPlot2DDataFile, Event
                    (*global).data_loadct_contrast_changed = 0
                ENDIF
            END
            ELSE:
        ENDCASE
        (*global).PrevDataTabSelect = CurrTabSelect
    ENDIF

ENDIF

MapBase, Event, 'info_data_base', info_base_status

END

;------------------------------------------------------------------------------
;This procedure is reached each time the user changed a tab of the
;plot in the normalization tab
PRO norm_plots_tab_event, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

info_base_status = 0

IF ((*global).NormNexusFound EQ 1) THEN BEGIN
    
    tab_id = widget_info(Event.top,find_by_uname='load_normalization_d_dd_tab')
    CurrTabSelect = widget_info(tab_id,/tab_current)
    PrevTabSelect = (*global).PrevNormTabSelect
    
    CASE (CurrTabSelect) OF
        0: info_base_status = 1
        ELSE:
    ENDCASE

    IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
        CASE (CurrTabSelect) OF
            2: BEGIN            ;Y vs X (2D)
                IF ((*global).norm_loadct_contrast_changed) THEN BEGIN
                    refresh_Plot2DNormalizationFile, Event
                    (*global).norm_loadct_contrast_changed = 0
                ENDIF
            END
            ELSE:
        ENDCASE
        (*global).PrevNormTabSelect = CurrTabSelect
    ENDIF

ENDIF

MapBase, Event, 'info_norm_base', info_base_status

END


;HELP -------------------------------------------------------------------------
PRO start_help 
ONLINE_HELP, book='/SNS/software/idltools/help/REFreduction/ref_reduction.adp'
END

;MY HELP ----------------------------------------------------------------------
PRO start_my_help, event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
BRANCH = (*global).branch
ONLINE_HELP, book='/SNS/users/j35/SVN/IdlGui/branches/REFreduction/' + $
  BRANCH + '/REFreductionHELP/ref_reduction.adp'
END

;------------------------------------------------------------------------------
pro ref_reduction_eventcb
end

;------------------------------------------------------------------------------
pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end


