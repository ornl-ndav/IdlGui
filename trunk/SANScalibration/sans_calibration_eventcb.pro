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
PRO retrieveNexus, Event, FullNexusName

;get global structure
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global

;indicate initialization with hourglass icon
widget_control,/hourglass

;retrieve infos
PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

;display name of nexus file name
putTab1NexusFileName, Event, FullNexusName
message = '-> Full NeXus File Name: ' + FullNexusName
IDLsendToGeek_addLogBookText, Event, message
message = '-> Retrieving Data : ' + PROCESSING
IDLsendToGeek_addLogBookText, Event, message
;retrieving data from NeXus file
retrieveStatus = retrieveData(Event, FullNexusName, DataArray) ;_plot
;retrieve information about tof
tof_array = (*(*global).tof_array)
tof_min = tof_array[0]
(*global).tof_min = tof_min
s_tof_min = STRCOMPRESS(tof_min,/REMOVE_ALL)
tof_max = tof_array[N_ELEMENTS(tof_array)-1]
(*global).tof_max = tof_max
s_tof_max = STRCOMPRESS(tof_max,/REMOVE_ALL)
putTextFieldValue, Event, 'tof_range_min_cw_field', s_tof_min
putTextFieldValue, Event, 'tof_range_max_cw_field', s_tof_max

IF (retrieveStatus EQ 0) THEN BEGIN
    IDLsendToGeek_addLogBookText, Event, '-> Plotting the NeXus file FAILED'
ENDIF ELSE BEGIN
    sz_array = size(DataArray)
    Ntof     = (sz_array)(1)
    Y        = (sz_array)(2)
    X        = (sz_array)(3)
    (*(*global).DataArray) = DataArray
    (*global).X = X
    (*global).Y = Y
    IDLsendToGeek_addLogBookText, Event, '--> X    : ' + $
      STRCOMPRESS(X,/REMOVE_ALL)
    IDLsendToGeek_addLogBookText, Event, '--> Y    : ' + $
      STRCOMPRESS(Y,/REMOVE_ALL)
    IDLsendToGeek_addLogBookText, Event, '--> Ntof : ' + $
      STRCOMPRESS(Ntof,/REMOVE_ALL)
;plotting data
    message = '-> Plotting NeXus  : ' + PROCESSING
    IDLsendToGeek_addLogBookText, Event, message
    plotDataResult = plotData(Event, DataArray, X, Y) ;_plot
    IF (plotDataResult EQ 0) THEN BEGIN ;failed
        IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
    ENDIF ELSE BEGIN
        IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
    ENDELSE
ENDELSE

;turn off hourglass
widget_control,hourglass=0

END

;------------------------------------------------------------------------------
;This function browse a nexus file
PRO browse_nexus, Event

;get global structure
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global

;retrieve infos
PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed
extension  = (*global).nexus_extension
filter     = (*global).nexus_filter
title      = (*global).nexus_title
path       = (*global).nexus_path

IDLsendToGeek_addLogBookText, Event, '> Browsing and Plotting a NeXus file :'

FullNexusName = BrowseRunNumber(Event, $       ;IDLloadNexus__define
                                extension, $
                                filter, $
                                title,$
                                GET_PATH=new_path,$
                                path)

IF (FullNexusName NE '') THEN BEGIN
;change default path
    (*global).nexus_path = new_path
    retrieveNexus, Event, FullNexusName
;put full path of nexus in reduce tab1
        putTextFieldValue, Event, $
          'data_file_name_text_field', $
          FullNexusName

        IF ((*global).auto_output_file_name EQ 1) THEN BEGIN
;predefined default reduce output file name
            defaultReduceFileName = getDefaultReduceFileName(Event, $
                                                             FullFileName)
            putTextFieldValue, $
              Event, $
              'output_file_name', $
              defaultReduceFileName
        ENDIF

;predefined default roi file name
        defaultROIfileName = getDefaultROIFileName(Event, $
                                                   FullNexusName)
        length = 35
        folder = FILE_DIRNAME(defaultRoiFileName,/MARK_DIRECTORY)
        (*global).selection_path = folder
;display only the last part of path
        sz = STRLEN(folder)
        IF (sz GT length) THEN BEGIN
            folder = '... ' + STRMID(folder,sz-length,length)
        ENDIF
        putNewButtonValue, Event, 'save_roi_folder_button',folder
        file   = FILE_BASENAME(defaultRoiFileName)
        putTextFieldValue, Event, 'save_roi_text_field', file
;activate selection buttons 
        update_tab1_gui, Event, STATUS=1 ;_gui
        (*global).data_nexus_file_name = FullNexusName
ENDIF ELSE BEGIN
;display name of nexus file name
;    putTab1NexusFileName, Event, ''
    message = '-> No NeXus File Loaded'
    IDLsendToGeek_addLogBookText, Event, message
ENDELSE    
END

;==============================================================================
PRO load_run_number, Event    
;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL, id, GET_UVALUE=global

;retrieve infos
PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed
extension  = (*global).nexus_extension
filter     = (*global).nexus_filter
title      = (*global).nexus_title
path       = (*global).nexus_path
proposal   = getProposalSelected(Event, proposal_index)
RunNumber  = getRunNumber(Event)

IF (RunNumber NE 0) THEN BEGIN
    IDLsendToGeek_addLogBookText, Event, '> Looking for Run Number ' + $
    STRCOMPRESS(RunNumber,/REMOVE_ALL) + ' :'
    
    isNexusExist = 0
    full_nexus_name = find_full_nexus_name(Event,$
                                           RunNumber,$
                                           'SANS',$
                                           isNexusExist,$
                                           proposal_index,$
                                           proposal)
    IF (isNexusExist EQ 1 AND $ 
        full_nexus_name[0] NE '') THEN BEGIN ;success
        message = '-> NeXus File Name : ' + full_nexus_name[0]
        IDLsendToGeek_addLogBookText, Event, message
;retrieve data
        retrieveNeXus, Event, full_nexus_name[0]
;put full path of nexus in reduce tab1
        putTextFieldValue, Event, $
          'data_file_name_text_field', $
          full_nexus_name

        IF ((*global).auto_output_file_name EQ 1) THEN BEGIN
;predefined default reduce output file name
            defaultReduceFileName = $
              getDefaultReduceFileName(Event, $
                                       full_nexus_name[0],$
                                       RUNNUMBER = RunNumber)
            putTextFieldValue, $
              Event, $
              'output_file_name', $
              defaultReuceFileName
        ENDIF

        (*global).data_nexus_file_name = full_nexus_name
;activate selection buttons 
        update_tab1_gui, Event, STATUS=1 ;_gui
    ENDIF ELSE BEGIN            ;failed
        message = '-> NeXus has not been found'
        IDLsendToGeek_addLogBookText, Event, message
        putTab1NexusFileName, Event, 'Nexus has not been found'
;put full path of nexus in reduce tab1
        putTextFieldValue, Event, $
          'data_file_name_text_field', $
          ''
;clear display
        ClearMainPlot, Event ;_gui
    ENDELSE
ENDIF
;turn off hourglass
widget_control,hourglass=0
END

;------------------------------------------------------------------------------
;this function is trigerred each time the user changes tab
PRO tab_event, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tab_id = widget_info(Event.top,FIND_BY_UNAME='main_tab')
CurrTabSelect = widget_info(tab_id,/TAB_CURRENT)
PrevTabSelect = (*global).PrevTabSelect

IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
    CASE (CurrTabSelect) OF
    0: BEGIN ;first tab
        refresh_plot, Event ;_plot
        RefreshRoiExclusionPlot, Event   ;_selection
    END
    1: BEGIN ;reduce tab
        CheckCommandLine, Event ;_command_line
    END
    2: BEGIN ;fitting
       ManualFitting, Event
    END
    3: BEGIN                    ;log book

    END
    ELSE:
    ENDCASE
    (*global).PrevTabSelect = CurrTabSelect
ENDIF
END

;------------------------------------------------------------------------------
PRO selection_tool, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

DataArray = (*(*global).DataArray)

IF (SIZE(DataArray,/N_DIMENSIONS) NE 0) THEN BEGIN
    
    ;if there is already a selection, removed it
    IF ((*global).there_is_a_selection) THEN BEGIN
        (*global).there_is_a_selection = 0
        refresh_plot, Event     ;_plot
    ENDIF        
    
    DataXY    = TOTAL(DataArray,1)
    tDataXY   = TRANSPOSE(dataXY)
    X         = (size(tDataXY))(1)
    Y         = X
    IF (X EQ 80) THEN BEGIN
        xysize = 8
    ENDIF ELSE BEGIN
        xysize = 2
    ENDELSE
    rtDataXY = REBIN(tDataXY, xysize*X, xysize*Y, /SAMPLE)
    
;change format to png file
    thisDevice = !D.NAME
    SET_PLOT, 'Z'
    LOADCT, 5
    TVLCT, red, green, blue, /GET
    set_plot, thisDevice
    ThisImage = BYTSCL(rtDataXY)
    s = size(ThisImage)
    image3d = BYTARR(3,s(1),s(2))
    image3d(0,*,*) = red(ThisImage)
    image3d(1,*,*) = green(ThisImage)
    image3d(2,*,*) = blue(ThisImage)
    
;hide the Selection Tool Button
    id = widget_info(Event.top,find_by_uname='selection_tool_button')
    widget_control, id, sensitive=0
    
;Start the selection tool
    sans_reduction_xroi, image3d, Event, DataArray

;disable exclusion region selection tool
    uname_list = ['exclusion_base']
    activate_widget_list, Event, uname_list, 0

ENDIF
END

;------------------------------------------------------------------------------
PRO play_tof, Event
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

activate_widget, Event, 'tof_play_button', 0

;get time/frame
time_per_frame = getTextFieldValue(Event,'tof_time_per_frame_value')
time_per_frame = FLOAT(time_per_frame)
;get bin/frame
bin_per_frame  = getTextFieldValue(Event,'tof_bin_per_frame_value')
bin_per_frame  = FIX(bin_per_frame)

;Integrate over TOF or get specified range of tof
value = getCWBgroupValue(Event, 'tof_range_cwbgroup')
IF (value EQ 1) THEN BEGIN      ;user wants user_defined range of tof
;get bin min
    tof_min = FLOAT(getTextFieldValue(Event,'tof_range_min_cw_field'))
ENDIF ELSE BEGIN
    tof_min = 0.
ENDELSE

;get bin max
tof_max            = FLOAT(getTextFieldValue(Event,'tof_range_max_cw_field'))
tof_array          = (*(*global).tof_array)
stop_tof_max_index = getIndexOfTof(tof_array, tof_max)
tof_min_index      = getIndexOfTof(tof_array, tof_min)
tof_max_index      = tof_min_index + bin_per_frame

WHILE (tof_max_index LE stop_tof_max_index) DO BEGIN
    
    bins_range  = STRCOMPRESS(tof_min_index,/REMOVE_ALL)
    bins_range += '-' + STRCOMPRESS(tof_max_index,/REMOVE_ALL)
    putTextFieldValue, Event, 'bin_range_value', bins_range

    tof_range  = STRCOMPRESS(tof_array[tof_min_index],/REMOVE_ALL)
    tof_range += '-' + STRCOMPRESS(tof_array[tof_max_index],/REMOVE_ALL) 
    putTextFieldValue, Event, 'tof_range_value', tof_range

    result = plot_range_OF_data(Event, tof_min_index, tof_max_index)
    IF (result EQ 0) THEN BEGIN
        BREAK
    ENDIF

    IF (tof_max_index EQ stop_tof_max_index) THEN BEGIN
        BREAK
    ENDIF
    tof_min_index = tof_max_index
    tof_max_index += bin_per_frame
    IF (tof_max_index GT stop_tof_max_index) THEN BEGIN
        tof_max_index = stop_tof_max_index
    ENDIF

    WAIT, time_per_frame

ENDWHILE

activate_widget, Event, 'tof_play_button', 1

END

;==============================================================================
PRO MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
END

;==============================================================================
PRO sans_calibration_eventcb, event
END

;==============================================================================
