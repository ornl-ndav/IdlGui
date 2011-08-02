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
PRO select_polarization_state, Event, file_name, list_pola_state
  ;update gui according to list of polarization state
  update_select_polarization_state_gui, Event, list_pola_state ;GUI
  MapBase, Event, 'polarization_state', 1
  short_file_name = FILE_BASENAME(file_name[0])
  putLabelValue, Event, 'pola_file_name_uname', '('+ short_file_name+')'
  text = '<USERS!> Waiting for input from users (selection of ' + $
    'the polarization state to plot)'
  putLogBookMessage, Event, Text, Append=1
END

;------------------------------------------------------------------------------
PRO ok_polarization_state, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  value_selected =  getPolarizationStateValueSelected(Event)
  MapBase, Event, 'polarization_state', 0
  text = '> User selected polarization state #' + $
    STRCOMPRESS(value_selected+1,/REMOVE_ALL)
  list_pola_state = (*(*global).list_pola_state)
  spin_state_array  = strsplit(list_pola_state[value_selected],'-',/extract)
  spin_state = spin_state_array[1]
  text += ' (' + strcompress(spin_state,/remove_all) + ')'
  putLogBookMessage, Event, Text, Append=1
  CASE ((*global).pola_type) OF
    'data_browse': BEGIN
      (*global).data_path = list_pola_state[value_selected]
      nexus_file_name = (*global).data_nexus_full_path
      load_data_browse_nexus, Event, nexus_file_name, POLA_STATE=value_selected
      populate_data_geometry_info, Event, nexus_file_name, spin_state=spin_state
      calculate_sangle, event
      populate_tof_range, event      
      (*global).data_pola_state = value_selected
    END
    'norm_browse': BEGIN
      (*global).norm_path = list_pola_state[value_selected]
      nexus_file_name = (*global).norm_nexus_full_path
      load_norm_browse_nexus, Event, nexus_file_name, POLA_STATE=value_selected
      (*global).norm_pola_state = value_selected
    END
    'data_load': BEGIN
      (*global).data_path = list_pola_state[value_selected]
      nexus_file_name = (*global).data_nexus_full_path
      load_data_browse_nexus, Event, nexus_file_name, POLA_STATE=value_selected
      populate_data_geometry_info, Event, nexus_file_name, spin_state=spin_state
      calculate_sangle, event
        populate_tof_range, event      
      (*global).data_pola_state = value_selected
    END
    'norm_load': BEGIN
      (*global).norm_path = list_pola_state[value_selected]
      nexus_file_name = (*global).norm_nexus_full_path
      load_norm_browse_nexus, Event, nexus_file_name, POLA_STATE=value_selected
      (*global).norm_pola_state = value_selected
    END
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO BrowseDataNexus, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  filter    = '*.nxs'
  extension = 'nxs'
  title     = 'Select a NeXus file ...'
  path      = (*global).browse_data_path
  text = '> Browsing for a Data NeXus file:'
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  putLogBookMessage, Event, Text, Append=1
  nexus_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
    FILTER            = filter,$
    TITLE             = title, $
    PATH              = path,$
    dialog_parent     = widget_id, $
    GET_PATH          = new_path,$
    /FIX_FILTER,$
    /READ)
    
  if (not(file_test(nexus_file_name))) then begin
    text = '-> Invalid NeXus file name!'
    putLogBookMessage, Event, Text, Append=1
    id = widget_info(event.top, find_by_uname='MAIN_BASE')
    message = ['    Invalid NeXus file name!    ']
    result = dialog_message(message,$
      title = 'Please select NeXus file!',$
      /error,$
      /center,$
      dialog_parent=id)
    return
  endif
  
  IF (nexus_file_name NE '') THEN BEGIN
    (*global).data_nexus_full_path = nexus_file_name
    (*global).browse_data_path = new_path
    text = '-> Nexus file name: ' + nexus_file_name
    putLogBookMessage, Event, Text, Append=1
    ;indicate initialization with hourglass icon
    WIDGET_CONTROL,/HOURGLASS
    ;check how many polarization states the file has
    nbr_pola_state = check_number_polarization_state(Event, $
      nexus_file_name,$
      list_pola_state)
    IF (nbr_pola_state EQ -1) THEN BEGIN ;missing function
      ;turn off hourglass
      WIDGET_CONTROL,HOURGLASS=0
      RETURN
    ENDIF
    
    IF (nbr_pola_state EQ 1) THEN BEGIN ;only 1 polarization state
      ;load browse nexus file
      load_data_browse_nexus, Event, nexus_file_name
    ENDIF ELSE BEGIN
      ;ask user to select the polarization state he wants to see
      (*global).pola_type = 'data_browse'
      select_polarization_state, Event, nexus_file_name, list_pola_state
    ENDELSE
    
    ;get run number
    iNexus = OBJ_NEW('IDLgetMetadata', nexus_file_name, $
    POLA_STATE_NAME='entry-Off_Off')
    DataRunNumber = iNexus->getRunNumber()
    OBJ_DESTROY, iNexus
    (*global).data_run_number = DataRunNumber
    putTextfieldvalue, event, 'load_data_run_number_text_field', $
      strcompress(DataRunNumber,/remove_all)
      
    populate_tof_range, event      
      
    ;turn off hourglass
    WIDGET_CONTROL,HOURGLASS=0
  ENDIF ELSE BEGIN
    text = '-> Operation canceled!'
    putLogBookMessage, Event, Text, Append=1
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO load_data_browse_nexus, Event, nexus_file_name, POLA_STATE=pola_state
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  WIDGET_CONTROL,/HOURGLASS
  
  PROCESSING = (*global).processing_message ;processing message
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  ;get run number
  IF (N_ELEMENTS(POLA_STATE)) THEN BEGIN
    list_pola_state = (*(*global).list_pola_state)
    iNexus = OBJ_NEW('IDLgetMetadata', $
      nexus_file_name, $
      POLA_STATE_NAME=list_pola_state[pola_state])
  ENDIF ELSE BEGIN
    iNexus = OBJ_NEW('IDLgetMetadata', nexus_file_name)
  ENDELSE
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    (*global).DataNeXusFound = 0
    IDLsendLogBook_ReplaceLogBookText, $
      Event, $
      ALT=1, $
      PROCESSING, $
      FAILED
    RETURN
  endif
  DataRunNumber = iNexus->getRunNumber()
  
  OBJ_DESTROY, iNexus
  DataRunNumber = STRCOMPRESS(DataRunNumber,/REMOVE_ALL)
  (*global).DataRunNumber = DataRunNumber
  (*global).data_run_number = DataRunNumber
  
  LogBookText = '> Opening DATA Run Number: ' + DataRunNumber
  IF (N_ELEMENTS(POLA_STATE)) THEN BEGIN
    LogBookText += ' (polarization state: ' + list_pola_state[POLA_STATE] + ')'
  ENDIF
  putLogBookMessage, Event, LogBookText, Append=1
  putDataLogBookMessage, Event, LogBookText + ' ... ' + PROCESSING
  
  NbrNexus = 1
  status = OpenDataNexusFile(Event, $ ;LoadDataFile.pro
    DataRunNumber, $
    nexus_file_name, $
    POLA_STATE = pola_state)
    
  IF (status EQ 0) THEN BEGIN
    (*global).DataNeXusFound = 0
    IDLsendLogBook_ReplaceLogBookText, $
      Event, $
      ALT=1, $
      PROCESSING, $
      FAILED
    RETURN
  ENDIF
  
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
  
  (*global).DataNeXusFound = 1
  
  ;update GUI according to result of NeXus found or not
  RefReduction_update_data_gui_if_NeXus_found, Event, 1
  
  IDLsendLogBook_ReplaceLogBookText, $
    Event, $
    ALT=1, $
    PROCESSING, $
    OK
    
  WIDGET_CONTROL,HOURGLASS=0
  
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

PRO BrowseNormNexus, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  filter    = '*.nxs'
  extension = 'nxs'
  title     = 'Select a NeXus file ...'
  path      = (*global).browse_data_path
  text = '> Browsing for a Normalization NeXus file:'
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
  putLogBookMessage, Event, Text, Append=1
  nexus_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
    FILTER            = filter,$
    TITLE             = title, $
    dialog_parent     = widget_id,$
    GET_PATH          = new_path,$
    path = path, $
    /FIX_FILTER,$
    /READ)
    
  if (not(file_test(nexus_file_name))) then begin
    text = '-> Invalid NeXus file name!'
    putLogBookMessage, Event, Text, Append=1
    id = widget_info(event.top, find_by_uname='MAIN_BASE')
    message = ['    Invalid NeXus file name!    ']
    result = dialog_message(message,$
      title = 'Please select NeXus file!',$
      /error,$
      /center,$
      dialog_parent=id)
    return
  endif
  
  IF (nexus_file_name NE '') THEN BEGIN
    (*global).browse_data_path = new_path
    (*global).norm_nexus_full_path = nexus_file_name
    text = '-> Nexus file name: ' + nexus_file_name
    putLogBookMessage, Event, Text, Append=1
    ;indicate initialization with hourglass icon
    WIDGET_CONTROL,/HOURGLASS
    ;check how many polarization states the file has
    nbr_pola_state = check_number_polarization_state(Event, $
      nexus_file_name,$
      list_pola_state)
    IF (nbr_pola_state EQ -1) THEN BEGIN ;missing function
      ;turn off hourglass
      WIDGET_CONTROL,HOURGLASS=0
      RETURN
    ENDIF
    
    IF (nbr_pola_state EQ 1) THEN BEGIN ;only 1 polarization state
      ;load browse nexus file
      load_norm_browse_nexus, Event, nexus_file_name
    ENDIF ELSE BEGIN
      (*global).pola_type = 'norm_browse'
      ;ask user to select the polarization state he wants to see
      select_polarization_state, Event, nexus_file_name, list_pola_state
    ENDELSE
    
    ;get run number
    iNexus = OBJ_NEW('IDLgetMetadata', nexus_file_name, POLA_STATE_NAME='entry-Off_Off')
    NormRunNumber = iNexus->getRunNumber()
    OBJ_DESTROY, iNexus
    (*global).NormRunNumber = NormRunNumber
    putTextfieldvalue, event, 'load_normalization_run_number_text_field', $
      strcompress(NormRunNumber,/remove_all)
      
    ;turn off hourglass
    WIDGET_CONTROL,HOURGLASS=0
  ENDIF ELSE BEGIN
    text = '-> Operation canceled!'
    putLogBookMessage, Event, Text, Append=1
  ENDELSE
END

;------------------------------------------------------------------------------
PRO load_norm_browse_nexus, Event, nexus_file_name, POLA_STATE=pola_state

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  WIDGET_CONTROL,/HOURGLASS
  
  PROCESSING = (*global).processing_message ;processing message
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  ;get run number
  IF (N_ELEMENTS(POLA_STATE)) THEN BEGIN
    list_pola_state = (*(*global).list_pola_state)
    iNexus = OBJ_NEW('IDLgetMetadata', $
      nexus_file_name, $
      POLA_STATE_NAME=list_pola_state[pola_state])
  ENDIF ELSE BEGIN
    iNexus = OBJ_NEW('IDLgetMetadata', nexus_file_name)
  ENDELSE
  NormRunNumber = iNexus->getRunNumber()
  OBJ_DESTROY, iNexus
  NormRunNumber = STRCOMPRESS(NormRunNumber,/REMOVE_ALL)
  (*global).NormRunNumber = NormRunNumber
  
  LogBookText = '> Opening NORMALIZATION Run Number: ' + NormRunNumber
  IF (N_ELEMENTS(POLA_STATE)) THEN BEGIN
    LogBookText += ' (polarization state: ' + list_pola_state[POLA_STATE] + ')'
  ENDIF
  IDLsendLogBook_addLogBookText, Event, LogBookText
  IDLsendLogBook_addLogBookText, Event, ALT=2,  LogBookText + ' ... ' + $
    PROCESSING
    
  NbrNexus = 1
  status = OpenNormNexusFile(Event, $
    NormRunNumber, $
    nexus_file_name, $
    POLA_STATE = pola_state)
  IF (status EQ 0) THEN BEGIN
    (*global).NormNeXusFound = 0
    IDLsendLogBook_ReplaceLogBookText, $
      Event, $
      ALT=2, $
      PROCESSING, $
      FAILED
    RETURN
  ENDIF
  
  ;plot normalization data now
  status = REFreduction_Plot1D2DNormalizationFile(Event)
  IF (status EQ 0) THEN BEGIN
    (*global).NormNeXusFound = 0
    IDLsendLogBook_ReplaceLogBookText, $
      Event, $
      ALT=2, $
      PROCESSING, $
      FAILED
    RETURN
  ENDIF
  
  (*global).NormNeXusFound = 1
  
  ;update GUI according to result of NeXus found or not
  RefReduction_update_normalization_gui_if_NeXus_found, Event, 1
  
  IDLsendLogBook_ReplaceLogBookText, $
    Event, $
    ALT=2, $
    PROCESSING, $
    OK
    
  WIDGET_CONTROL,HOURGLASS=0
  
END

