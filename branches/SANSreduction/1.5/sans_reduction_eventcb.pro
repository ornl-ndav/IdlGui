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
;This function defines the instrument if the program is started from
;heater
PRO facility_selected, Event, scroll

  id = widget_info(Event.top,find_by_uname='facility_selection_cw_bgroup')
  widget_control, id, get_value=facility_selected
  
  ;descativate facility selection base and activate main base
  ISBaseID = widget_info(Event.top,find_by_uname='MAIN_BASE')
  widget_control, ISBaseId, map=0
  
  if (facility_selected EQ 0) then begin
    BuildGui, SCROLL=scroll, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, 'SNS'
  endif else begin
    BuildGui, SCROLL=scroll, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, 'LENS'
  endelse
  
END

;------------------------------------------------------------------------------
PRO retrieveNexus, Event, FullNexusName
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  
  DEVICE, DECOMPOSED=1
  
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
  IF (retrieveStatus EQ 0) THEN BEGIN
    (*global).data_nexus_file_name = ''
    IDLsendToGeek_addLogBookText, Event, '-> Plotting the NeXus file FAILED'
  ENDIF ELSE BEGIN
    (*global).data_nexus_file_name = FullNexusName
    sz_array = size(DataArray)
    Ntof     = (sz_array)(1)
    Y        = (sz_array)(2)
    X        = (sz_array)(3)
    
    IF ((*global).facility EQ 'LENS') THEN BEGIN ;LENS
      (*(*global).DataArray) = DataArray
    ENDIF ELSE BEGIN ;SNS
    
      progressBar = OBJ_NEW("SHOWPROGRESS", $
        XOFFSET = 100, $
        YOFFSET = 50, $
        XSIZE   = 200,$
        TITLE   = 'Plotting Data',$
        /CANCELBUTTON)
      progressBar->SetColor, FSC_COLOR('red')
      progressBar->Start
      
      IF (UpdateProgressBar(progressBar,100)) THEN BEGIN
        progressBarCancel = 1
        progressBar->Destroy
        OBJ_DESTROY, progressBar
        RETURN
      ENDIF
      
      CASE (is_front_back_or_both_plot(Event)) OF
        'front': BEGIN
          (*(*global).DataArray) = (*(*global).front_bank)
          DataArray = (*(*global).front_bank)
        END
        'back' : BEGIN
          (*(*global).DataArray) = (*(*global).back_bank)
          DataArray = (*(*global).back_bank)
        END
        'both': BEGIN
          (*(*global).DataArray) = (*(*global).both_banks)
          DataArray = (*(*global).both_banks)
        END
      ENDCASE
      
    ENDELSE
    
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
    
    progressBar->Destroy
    OBJ_DESTROY, progressBar
    
  ENDELSE
  
  DEVICE, DECOMPOSED=0
  
  ;turn off hourglass
  widget_control,hourglass=0
  
END

;==============================================================================
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
      defaultReduceFileName = getDefaultReduceFileName(Event, FullNexusName)
      putTextFieldValue, $
        Event, $
        'output_file_name', $
        defaultReduceFileName
    ENDIF
    
    ;predefined default roi file name
    defaultROIfileName = getDefaultROIFileName(Event, FullNexusName)
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
    uname_list = ['clear_selection_button',$
      'selection_browse_button',$
      'selection_file_name_text_field',$
      'refresh_plot_button',$
      'z_axis_scale_base',$
      'clear_selection_button',$
      'exclusion_base']
    IF ((*global).facility EQ 'LENS') THEN BEGIN
      uname_list = [uname_list,$
        'selection_tool_button']
    ENDIF
    (*global).data_nexus_file_name = FullNexusName
    activate_widget_list, Event, uname_list, 1
  ENDIF ELSE BEGIN
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
      isNexusExist,$
      proposal_index,$
      proposal,$
      FACILITY = (*global).facility)
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
      ;put name in first tab
      putTextFieldValue, Event, $
        'data_nexus_file_name',$
        full_nexus_name[0]
      ;predefined default roi file name
      defaultROIfileName = getDefaultROIFileName(Event, full_nexus_name[0])
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
      
      IF ((*global).auto_output_file_name EQ 1) THEN BEGIN
        ;predefined default reduce output file name
        defaultReduceFileName = $
          getDefaultReduceFileName(Event, full_nexus_name[0])
        putTextFieldValue, $
          Event, $
          'output_file_name', $
          defaultReduceFileName
      ENDIF
      
      (*global).data_nexus_file_name = full_nexus_name
      ;activate selection buttons
      uname_list = ['clear_selection_button',$
        'selection_browse_button',$
        'selection_file_name_text_field',$
        'refresh_plot_button',$
        'z_axis_scale_base',$
        'clear_selection_button',$
        'exclusion_base']
      IF ((*global).facility EQ 'LENS') THEN BEGIN
        uname_list = [uname_list,$
          'selection_tool_button']
      ENDIF
      
      IF ((*global).data_nexus_file_name EQ '') THEN BEGIN
        status = 0
      ENDIF ELSE BEGIN
        status = 1
        (*global).data_nexus_file_name = Full_nexus_name
      ENDELSE
      activate_widget_list, Event, uname_list, status
      IF ((*global).facility EQ 'SNS') THEN BEGIN
        MapBase, Event, uname='transmission_launcher_base', status
        display_images, EVENT=event
      ENDIF
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
      (*global).data_nexus_file_name = ''
      activate_widget_list, Event, uname_list, status
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
  
  WIDGET_CONTROL, /HOURGLASS
  
  IF (PrevTabSelect NE CurrTabSelect) THEN BEGIN
    CASE (CurrTabSelect) OF
      0: BEGIN ;first tab
        IF ((*global).facility EQ 'LENS') THEN BEGIN
          refresh_plot, Event     ;_plot
          RefreshRoiExclusionPlot, Event   ;_selection
          refresh_scale, Event
        ENDIF ELSE BEGIN
          IF ((*global).data_nexus_file_name NE '') THEN BEGIN
            id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
            WIDGET_CONTROL, id, GET_VALUE = id_value
            WSET, id_value
            TV, (*(*global).background), true=3
            display_images, EVENT=event
            selection_shape_type = (*global).selection_shape_type
            display_circle_rectangle_buttons, EVENT=event, $
              TYPE=selection_shape_type
            IF (selection_shape_type EQ 'rectangle') THEN BEGIN
              display_selection_images, EVENT=event, $
                SELECTION=(*global).selection_type
            ENDIF
            replot_counts_vs_tof, Event
          ENDIF
        ENDELSE
      END
      1: BEGIN                    ;reduce tab
        display_reduction_interruptor, EVENT=event, $
          mode=(*global).sns_jk_switch
        IF ((*global).sns_jk_switch EQ 'sns') THEN BEGIN
          CheckCommandLine, Event         ;_command_line
        ENDIF ELSE BEGIN
          CheckCommandline_for_jk, Event
        ENDELSE
      END
      2: BEGIN                    ;plot tab
        rePlotAsciiData, Event
      END
      3: BEGIN  ;log book
      END
      ELSE:
    ENDCASE
    (*global).PrevTabSelect = CurrTabSelect
  ENDIF
  
  WIDGET_CONTROL, HOURGLASS=0
  
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
    sans_reduction_xroi,image3d, $
      Event, $
      DataArray                 ;launch sans_reduction_xroi
      
    ;disable exclusion region selection tool
    uname_list = ['exclusion_base']
    activate_widget_list, Event, uname_list, 0
    
  ENDIF
END

;HELP -------------------------------------------------------------------------
PRO start_help, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ONLINE_HELP, book=(*global).help
END

;------------------------------------------------------------------------------
PRO MAIN_REALIZE, wWidget
  tlb = get_tlb(wWidget)
  ;indicate initialization with hourglass icon
  widget_control,/hourglass
  ;turn off hourglass
  widget_control,hourglass=0
END

;------------------------------------------------------------------------------
PRO get_and_plot_tof_array, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN
  ENDIF
  
  tof_array = getTOFarray(Event, (*global).data_nexus_file_name)
  (*(*global).tof_array) = tof_array
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'counts_vs_tof_preview_plot')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  
  CASE (is_front_back_or_both_plot(Event)) OF
    'front': BEGIN
      DataArray = (*(*global).front_bank)
    END
    'back' : BEGIN
      DataArray = (*(*global).back_bank)
    END
    'both': BEGIN
      DataArray = (*(*global).both_banks)
    END
  ENDCASE
  
  counts = TOTAL(DataArray,2)
  Counts = TOTAL(counts,2)
  
  (*(*global).tof_counts) = counts
  
  sz = N_ELEMENTS(tof_array)-1
  tof = tof_array[0:sz-1]
  
  (*(*global).tof_tof) = tof
  (*(*global).array_of_tof_bins) = tof_array[0:sz]
  
  PLOT, tof, $
    counts, $
    XTITLE='TOF (micro seconds)', $
    YTITLE = 'Counts',$
    YSTYLE = 1, $
    XSTYLE = 1, $
    POSITION = [0.15, 0.17, 0.95, 0.85]
    
  bin_array = DBLARR(sz)
  AXIS, XRANGE=[0,sz-1],$
    xaxis=1, $
    xtitle='Bins #',$
    /NOERASE
    
  DEVICE, DECOMPOSED=1
  
  ;plot line at beginning and at end (to show full range of tof selected)
  plot_range_of_tof_displayed, Event, FIRST_TIME=1b
  
  activate_widget, Event, 'tof_tools', 1
  
END

;------------------------------------------------------------------------------
PRO replot_counts_vs_tof, Event, RESET=reset

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  tof_array = (*(*global).tof_array)
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'counts_vs_tof_preview_plot')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  
  CASE (is_front_back_or_both_plot(Event)) OF
    'front': BEGIN
      DataArray = (*(*global).front_bank)
    END
    'back' : BEGIN
      DataArray = (*(*global).back_bank)
    END
    'both': BEGIN
      DataArray = (*(*global).both_banks)
    END
  ENDCASE
  
  counts = TOTAL(DataArray,2)
  Counts = TOTAL(counts,2)
  
  sz = N_ELEMENTS(tof_array)-1
  
  tof = tof_array[0:sz-1]
  
  PLOT, tof, $
    counts, $
    XTITLE='TOF (micro seconds)', $
    YTITLE = 'Counts',$
    YSTYLE = 1, $
    XSTYLE = 1, $
    POSITION = [0.15, 0.17, 0.95, 0.85]
    
  bin_array = DBLARR(sz)
  AXIS, XRANGE=[0,sz-1],$
    xaxis=1, $
    xtitle='Bins #',$
    /NOERASE
    
  plot_range_of_tof_displayed, Event, RESET=reset
  
END

;------------------------------------------------------------------------------
PRO plot_range_of_tof_displayed, Event, FIRST_TIME=first_time, RESET=reset

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF (N_ELEMENTS(reset)) THEN RETURN
  
  id = (*global).tof_tools_base
  IF (WIDGET_INFO(id, /VALID_ID) EQ 0) THEN RETURN
  
  counts = (*(*global).tof_counts)
  max_counts = MAX(counts,MIN=min_counts)
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'counts_vs_tof_preview_plot')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  
  IF (N_ELEMENTS(first_time) NE 0) THEN BEGIN
    tof = (*(*global).tof_tof)
    sz = N_ELEMENTS(tof)
    xmin = tof[0]
    xmax = tof[sz-1]
    (*global).tof_range.min = tof[0]
    (*global).tof_range.max = tof[sz-1]
  ENDIF ELSE BEGIN
    tof_range = (*global).tof_range
    xmin = tof_range.min
    xmax = tof_range.max
  ENDELSE
  
  PLOTS, xmin, min_counts, /DATA
  PLOTS, xmin, max_counts, /DATA, /CONTINUE, COLOR=FSC_COLOR('red'), $
    THICK= 2
    
  PLOTS, xmax, min_counts, /DATA
  PLOTS, xmax, max_counts, /DATA, /CONTINUE, COLOR=FSC_COLOR('red'), $
    THICK= 2
    
  DEVICE, DECOMPOSED=0
  
END

