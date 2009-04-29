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

PRO activate_widget, Event, uname, activate_status
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, SENSITIVE=activate_status
END

;------------------------------------------------------------------------------
PRO activate_widget_list, Event, uname_list, activate_status
  sz = N_ELEMENTS(uname_list)
  FOR i=0,(sz-1) DO BEGIN
    activate_widget, Event, uname_list[i], activate_status
  ENDFOR
END

;------------------------------------------------------------------------------
;This function map or not the given base
PRO map_base, Event, uname, map_status
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, MAP=map_status
END

;------------------------------------------------------------------------------
;This function map or not the given base
PRO map_base_list, Event, uname_list, map_status
  sz = N_ELEMENTS(uname_list)
  FOR i=0,(sz-1) DO BEGIN
    map_base, Event, uname_list[i], map_status
  ENDFOR
END

;------------------------------------------------------------------------------
;This function activates or not the GO DATA REDUCTION button
PRO activate_go_data_reduction, Event, activate_status
  activate_widget, Event, 'go_data_reduction_button', activate_status
END

;------------------------------------------------------------------------------
;This function put the full path of the file as the new button label
PRO putNewButtonValue, Event, uname, value
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, SET_VALUE=value
END

;------------------------------------------------------------------------------
;This function clear off the display of the main plot
PRO ClearMainPlot, Event
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  ERASE
END

;------------------------------------------------------------------------------
;This procedure updates the GUI according to the mode selected:
;transmission or background
PRO ModeGuiUpdate, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  VERSION       = (*global).version
  MainBaseTitle = (*global).MainBaseTitle
  
  ModeIndex = getCWBgroupValue(Event, 'mode_group_uname')
  
  IF (ModeIndex EQ 0) THEN BEGIN ;transmission
    Title = MainBaseTitle + ' ( Mode: Transmission ) ' + ' - ' + VERSION
    monitor_efficiency_flag = 1
    acc_down_time_flag      = 0
    intermediate_files_flag = 1
    transm_back_flag        = 1
    beam_monitor_flag       = 1
    run_button              = '> >> >>> RUN TRANSMISSION <<< << <'
    help_label = '(Specify the time zero offset in microseconds of both ' + $
    'the Detector and the Monitor)'
  ENDIF ELSE BEGIN ;background
    Title = MainBaseTitle + ' ( Mode: Background ) ' + ' - ' + VERSION
    monitor_efficiency_flag = 0
    acc_down_time_flag      = 1
    intermediate_files_flag = 0
    transm_back_flag        = 0
    beam_monitor_flag            = 0
    run_button              = '> >> >>> RUN BACKGROUND <<< << <'
    help_label = '(Specify the time zero offset in microseconds of ' + $
    'the Detector)'
  ENDELSE
  WIDGET_CONTROL, Event.top, BASE_SET_TITLE=title
  uname_list = ['monitor_efficiency_title',$
    'monitor_efficiency_base',$
    'detector_efficiency_base',$
    'detector_efficiency_title']
  activate_widget_list, Event, uname_list, monitor_efficiency_flag
  uname_list = ['accelerator_down_time_title',$
    'accelerator_down_time_base']
  activate_widget_list, Event, uname_list, acc_down_time_flag
  uname_list = ['reduce_tab3_base']
  activate_widget_list, Event, uname_list, intermediate_files_flag
  uname_list = ['transm_back_base_uname']
  activate_widget_list, Event, uname_list, transm_back_flag
  uname_list = ['time_zero_offset_beam_monitor_uname',$
    'time_zero_beam_monitor_label']
  activate_widget_list, Event, uname_list, beam_monitor_flag
  putNewButtonValue, Event, 'go_data_reduction_button', run_button
  putTextFieldValue, Event, 'time_zero_offset_help', help_label
END

;------------------------------------------------------------------------------
;This function reset the output file name
PRO RenewOutputFileName, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  IF ((*global).auto_output_file_name EQ 1) THEN BEGIN
    FullFileName = getTextFieldValue(Event,'data_nexus_file_name')
    defaultReduceFileName = getDefaultReduceFileName(Event, $
      FullFileName)
    putTextFieldValue, Event, 'output_file_name', defaultReduceFileName
  ENDIF
END

;------------------------------------------------------------------------------
PRO update_tab1_gui, Event, STATUS=status
  uname_list = ['clear_selection_button',$
    'selection_tool_button',$
    'selection_browse_button',$
    'selection_file_name_text_field',$
    'z_axis_scale_base',$
    'tof_range_base',$
    'exclusion_base']
  activate_widget_list, Event, uname_list, status
  
  ;tof buttons
  uname_list = ['counts_vs_tof_full_detector_button',$
    'counts_vs_tof_monitor_button']
    
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  package_required_base = (*(*global).package_required_base)
  IF (package_required_base[3].found EQ 1 AND $
    status EQ 1) THEN BEGIN
    tof_status = 1
  ENDIF ELSE BEGIN
    tof_status = 0
  ENDELSE
  activate_widget_list, Event, uname_list, tof_status
tof_status = 1
activate_widget_list, Event, uname_list, tof_status
  
END

;------------------------------------------------------------------------------
;activate button only if file and ROI are there
PRO update_tof_counts_selection_button, Event
  uname_list = ['counts_vs_tof_selection_button']
  ;IF (getROIfileName(Event) NE '') THEN BEGIN
  tof_selection_status = 1
  ;ENDIF ELSE BEGIN
  ;    tof_selection_status = 0
  ;ENDELSE
  activate_widget_list, Event, uname_list, tof_selection_status
END

;------------------------------------------------------------------------------
PRO checkTofRange, Event

END
