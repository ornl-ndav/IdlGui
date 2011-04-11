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

PRO  cleanup_array, data
  data = BYTSCL(data,/NAN)
END

;------------------------------------------------------------------------------
FUNCTION OpenEmptyCellNeXusFile, Event, $
    EmptyCellRunNumber, $
    full_nexus_name, $
    POLA_STATE=pola_state
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  PROCESSING = (*global).processing_message ;processing message
  instrument = (*global).instrument
  
  ;store full path to NeXus
  (*global).empty_cell_full_nexus_name = full_nexus_name
  
  ;display info about nexus file selected
  LogBookText = $
    '-> Displaying information about run number using nxsummary:'
    
  IDLsendLogBook_addLogBookText, Event, LogBookText ;log_book
  
  RefReduction_NXsummary, Event, $
    full_nexus_name, $
    'empty_cell_nx_summary',$
    POLA_STATE=pola_state
    
  ;check format of NeXus file
  IF (H5F_IS_HDF5(full_nexus_name)) THEN BEGIN
    (*global).isHDF5format = 1
    LogBookText = '-> Is format of NeXus hdf5 ? YES'
    IDLsendLogBook_addLogBookText, Event, LogBookText ;log_book
    
    ;dump binary data into local directory of user
    working_path = (*global).working_path
    status = REFReduction_DumpBinaryEmptyCell(Event,$ ;_dumpbinary.pro
      full_nexus_name, $
      working_path, $
      POLA_STATE=pola_state)
      
    IF ((*global).debugging_on_Mac EQ 'yes') THEN BEGIN
      status = REFReduction_DumpBinaryData(Event,$
        full_nexus_name, $
        working_path, $
        POLA_STATE=pola_state)
    ENDIF
    
    IF (status EQ 0) THEN RETURN, 0
    
  ENDIF ELSE BEGIN
  
    (*global).isHDF5format = 0
    LogBookText = '-> Is format of NeXus hdf5 ? NO'
    IDLsendLogBook_addLogBookText, Event, LogBookText ;log_book
    LogBookText = ' !!! REFreduction does not support this file format. '
    LogBookText += 'Please use rebinNeXus to create a hdf5 nexus file !!!'
    IDLsendLogBook_addLogBookText, Event, LogBookText ;log_book
    RETURN, 0
  ENDELSE
  
  RETURN, 1
END

;-----------------------------------------------------------------------------
;this function load the given nexus file and get the binary data
PRO REFreduction_LoadEmptyCell, Event, isNeXusFound, NbrNexus

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  PROCESSING = (*global).processing_message ;processing message
  OK         = (*global).ok
  FAILED     = (*global).failed
  instrument = (*global).instrument ;retrieve name of instrument
  
  ;get Data Run Number from DataTextField
  RunNumber = getTextFieldValue(Event,'empty_cell_nexus_run_number')
  RunNumber = STRCOMPRESS(RunNumber,/REMOVE_ALL)
  isNeXusFound = 0                ;by default, NeXus not found
  
  WIDGET_CONTROL,/HOURGLASS
  
  IF (RunNumber NE '') THEN BEGIN ;run number is not empty
  
    (*global).EmptyCellRunNumber = RunNumber
    
    ;check if user wants archived or all nexus runs +++++++++++++++++++++++++++++++
    
    ;get full list of Nexus
    IF (~isArchivedEmptyCellNexusDesired(Event)) THEN BEGIN
    
      LogBookText = '-> Retrieving full list of Empty Cell Run Number: ' + $
        RunNumber
      IDLsendLogBook_addLogBookText, Event, LogBookText
      LogBookText += ' ... ' + PROCESSING
      IDLsendLogBook_addLogBookText, Event, LogBookText, ALT=3
      LogBookText = $
        '--> Checking if at least one NeXus file can be found ' + $
        ' ... ' + PROCESSING
      IDLsendLogBook_addLogBookText, Event, LogBookText
      
      ;get path to nexus run #
      full_list_of_nexus_name = find_list_nexus_name(Event,$
        RunNumber,$
        instrument,$
        isNeXusFound)
        
      IF (~isNexusFound) THEN BEGIN ;no nexus found
      
        ;tells the user that the NeXus file has not been found
        Message = 'FAILED - No NeXus can be found'
        IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message
        
        IDLsendLogBook_ReplaceLogBookText, $
          Event, $
          ALT=3, $
          PROCESSING, $
          'NeXus run number does not exist!'
          
        NbrNexus = 0
        
        WIDGET_CONTROL,HOURGLASS=0
      ;no needs to do anything more
        
      ENDIF ELSE BEGIN        ;1 or more nexus have been bound
      
        ;display list of nexus found if list is GT 1 otherwise proceed as
        ;before
        sz = (SIZE(full_list_of_nexus_name))(1)
        NrefbrNexus = sz
        IF (sz GT 1) THEN BEGIN ;more than 1 nexus file found
        
          WIDGET_CONTROL,HOURGLASS=0
          
          ;display list in droplist and map=1 base
          putArrayInDropList, $
            Event, $
            full_list_of_nexus_name, $
            'empty_cell_nexus_droplist'
          MapBase, Event, 'empty_cell_list_nexus_base', 1
          
          IDLsendLogBook_ReplaceLogBookText, Event, $
            PROCESSING, $
            OK
          LogText = '--> Found ' + STRCOMPRESS(sz,/REMOVE_ALL)
          LogText += ' NeXus files:'
          IDLsendLogBook_addLogBookText, Event, Logtext
          
          FOR i=0,(sz-1) DO BEGIN
            text = '       ' + full_list_of_nexus_name[i]
            IDLsendLogBook_addLogBookText, Event, text
          ENDFOR
          
          ;display nxsummary of first file in 'empty_cell_list_nexus_base'
          RefReduction_NXsummary, $
            Event, $
            full_list_of_nexus_name[0], $
            'empty_cell_list_nexus_nxsummary_text_field'
            
          ;Inform user that program is waiting for his action
          LogText = $
            '<USERS!> Waiting for input from users. Please select ' + $
            'one NeXus file from the list ... ' + PROCESSING
          IDLsendLogBook_addLogBookText, Event, LogText
          
          ;display info in empty cell log book
          IDLsendLogBook_ReplaceLogBookText, Event, $
            ALT = 3, $
            PROCESSING, $
            OK
            
          text = '--> Please select one of the ' + $
            STRCOMPRESS(sz,/REMOVE_ALL)
          text += ' NeXus file found ... ' + PROCESSING
          IDLsendLogBook_addLogBookText, Event, ALT=3, text
          
        ENDIF ELSE BEGIN    ;only 1 found
        
          IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, OK
          
          full_nexus_name = full_list_of_nexus_name[0]
          NbrNexus = 1
          
          (*global).empty_cell_nexus_full_path = full_nexus_name
          
          ;check how many polarization states the file has
          nbr_pola_state = $
            check_number_polarization_state(Event, $
            full_nexus_name,$
            list_pola_state)
          IF (nbr_pola_state EQ -1) THEN BEGIN ;missing function
            RETURN
          ENDIF
          
          IF (nbr_pola_state EQ 1) THEN BEGIN ;only 1 polarization state
            ;load browse nexus file
          
            result = OpenEmptyCellNeXusFile(Event, $
              DataRunNumber, $
              full_nexus_name)
              
            isNexusFound = result
            
            ;plot data now
            result = REFreduction_PlotEmptyCellFile(Event)
            IF (result EQ 0) THEN BEGIN
              IDLsendLogBook_ReplaceLogBookText, $
                Event, $
                ALT=3, $
                PROCESSING, $
                FAILED
              RETURN
            ENDIF
            
            (*global).EmptyCellNeXusFound = result
            
            ;;update GUI according to result of NeXus found or not
            ;                    RefReduction_update_data_gui_if_NeXus_found, Event, result
            
            WIDGET_CONTROL,HOURGLASS=0
            
          ENDIF ELSE BEGIN
          
            WIDGET_CONTROL,HOURGLASS=0
            
            ;ask user to select the polarization state he wants to see
            (*global).pola_type = 'empty_cell_load'
            select_polarization_state, Event, $
              full_nexus_name, $
              list_pola_state
              
          ENDELSE         ;end of "IF (nbr_pola_state EQ 1)"
          
        ENDELSE             ;end of 1 or more nexus found
        
      ENDELSE
    ;we just want the archived one
    ENDIF ELSE BEGIN ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
      LogBookText = '-> Openning Archived Empty Cell Run Number: ' + $
        RunNumber
      putLogBookMessage, Event, LogBookText, Append=1
      LogBookText += ' ... ' + PROCESSING
      IDLsendLogBook_ReplaceLogBookText, $
        Event, $
        ALT=3, $
        PROCESSING, $
        LogBookText
      LogBookText = '--> Checking if NeXus run number exists ... ' + $
        PROCESSING
      IDLsendLogBook_addLogBookText, Event, LogBookText
      
      ;get path to nexus run #
      full_nexus_name = find_full_nexus_name(Event,$
        RunNumber,$
        instrument,$
        isNeXusFound,$
        SOURCE_FILE='empty_cell')
        
      IF (~isNeXusFound) THEN BEGIN ;NeXus has not been found
        NbrNexus = 0
        ;tells the user that the NeXus file has not been found
        ;get log book full text
        Message = 'FAILED - NeXus file does not exist'
        IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message
        
        ;get data log book full text
        IDLsendLogBook_ReplaceLogBookText, $
          Event, $
          ALT=3,$
          PROCESSING,$
          'NeXus does not exist!'
          
      ;no needs to do anything more
          
      ENDIF ELSE BEGIN        ;NeXus has been found
      
        LogBookText = getLogBookText(Event)
        Message = 'OK  ' + '(Full Path is: ' + $
          strcompress(full_nexus_name) + ')'
        IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message
        
        NbrNexus = 1
        (*global).empty_cell_nexus_full_path = full_nexus_name
        
        ;check how many polarization states the file has
        nbr_pola_state = $
          check_number_polarization_state(Event, $
          full_nexus_name,$
          list_pola_state)
        IF (nbr_pola_state EQ -1) THEN BEGIN ;missing function
          RETURN
        ENDIF
        
        IF (nbr_pola_state EQ 1) THEN BEGIN ;only 1 polarization state
          ;load browse nexus file
          result = OpenEmptyCellNeXusFile(Event, $
            RunNumber, $
            full_nexus_name)
            
          IF (result EQ 0) THEN BEGIN
            IDLsendLogBook_ReplaceLogBookText, $
              Event, $
              ALT=3, $
              PROCESSING, $
              FAILED
            RETURN
          ENDIF
          isNeXusFound = result
          
          ;plot data now
          
          result = REFreduction_PlotEmptyCellFile(Event)
          IF (result EQ 0) THEN BEGIN
            (*global).EmptyCellNeXusFound = 0
            IDLsendLogBook_ReplaceLogBookText, $
              Event, $
              ALT=3, $
              PROCESSING, $
              FAILED
            RETURN
          ENDIF
          
          (*global).EmptyCellNeXusFound = 1
          
          IF (result) THEN BEGIN
            IDLsendLogBook_ReplaceLogBookText, $
              Event, $
              ALT=3, $
              PROCESSING, $
              OK
          ENDIF ELSE BEGIN
            IDLsendLogBook_ReplaceLogBookText, $
              Event, $
              ALT=3, $
              PROCESSING, $
              FAILED
          ENDELSE
          
        ;;update GUI according to result of NeXus found or not
        ;                RefReduction_update_data_gui_if_NeXus_found, Event, result
          
        ENDIF ELSE BEGIN
          ;ask user to select the polarization state he wants to see
          (*global).pola_type = 'empty_cell_load'
          select_polarization_state, Event, $
            full_nexus_name, $
            list_pola_state
        ENDELSE
        
      ENDELSE
      
      WIDGET_CONTROL,HOURGLASS=0
      
    ENDELSE
    
  ENDIF                           ;end of if(EmptyCellRunNumber Ne '')
  
END

;------------------------------------------------------------------------------
PRO BrowseEmptyCellNexus, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  filter    = '*.nxs'
  extension = 'nxs'
  title     = 'Select a NeXus file ...'
  IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    path      = (*(*global).debugging_structure).working_path
  ENDIF ELSE BEGIN
    path      = (*global).browse_data_path
  ENDELSE
  text      = '> Browsing for an Empty Cell NeXus file:'
  putLogBookMessage, Event, Text, Append=1
  
  nexus_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
    FILTER            = filter,$
    TITLE             = title, $
    PATH              = path,$
    GET_PATH          = new_path,$
    /FIX_FILTER,$
    /READ)
    
  IF (nexus_file_name NE '') THEN BEGIN
  
    (*global).empty_cell_nexus_full_path = nexus_file_name
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
      putLogBookMessage, Event, $
        'ERROR retrieving the number of' + $
        ' polarization states!', $
        APPEND=1
        
      ;turn off hourglass
      WIDGET_CONTROL,HOURGLASS=0
      RETURN
    ENDIF
    
    IF (nbr_pola_state EQ 1) THEN BEGIN ;only 1 polarization state
      ;load browse nexus file
      load_empty_cell_browse_nexus, Event, nexus_file_name
    ENDIF ELSE BEGIN
      ;ask user to select the polarization state he wants to see
      (*global).pola_type = 'empty_cell_browse'
      select_polarization_state, Event, nexus_file_name, list_pola_state
    ENDELSE
    
    ;turn off hourglass
    WIDGET_CONTROL,HOURGLASS=0
    
  ENDIF ELSE BEGIN
  
    text = '-> Operation canceled!'
    putLogBookMessage, Event, Text, Append=1
    
  ENDELSE
END

;------------------------------------------------------------------------------
PRO BrowseEmptyCellNexus_onMac, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  filter    = '*.nxs'
  extension = 'nxs'
  title     = '(On Mac only!) Select a NeXus file ...'
  path      = (*(*global).debugging_structure).working_path_onMac
  text      = '(On Mac Only!) > Browsing for an Empty Cell NeXus file:'
  putLogBookMessage, Event, Text, Append=1
  
  nexus_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = extension,$
    FILTER            = filter,$
    TITLE             = title, $
    PATH              = path,$
    GET_PATH          = new_path,$
    /FIX_FILTER,$
    /READ)
    
  IF (nexus_file_name NE '') THEN BEGIN
  
    (*global).empty_cell_nexus_full_path = nexus_file_name
    (*global).browse_data_path = new_path
    
    text = '(On Mac Only!) -> Nexus file name: ' + nexus_file_name
    putLogBookMessage, Event, Text, Append=1
    
    ;indicate initialization with hourglass icon
    WIDGET_CONTROL,/HOURGLASS
    
    ;;check how many polarization states the file has
    ;    nbr_pola_state = check_number_polarization_state(Event, $
    ;                                                     nexus_file_name,$
    ;                                                     list_pola_state)
    ;
    ;
    ;    IF (nbr_pola_state EQ -1) THEN BEGIN ;missing function
    ;       putLogBookMessage, Event, $
    ;                          'ERROR retrieving the number of' + $
    ;                          ' polarization states!', $
    ;                          APPEND=1
    ;
    ;;turn off hourglass
    ;       WIDGET_CONTROL,HOURGLASS=0
    ;       RETURN
    ;    ENDIF
    ;
    
    ;load browse nexus file
    load_empty_cell_browse_nexus, Event, nexus_file_name
    
    ;turn off hourglass
    WIDGET_CONTROL,HOURGLASS=0
    
  ENDIF ELSE BEGIN
  
    text = '-> Operation canceled!'
    putLogBookMessage, Event, Text, Append=1
    
  ENDELSE
END

;------------------------------------------------------------------------------
PRO load_empty_cell_browse_nexus, Event, $
    nexus_file_name, $
    POLA_STATE=pola_state
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
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
  
  EmptyCellRunNumber = iNexus->getRunNumber()
  OBJ_DESTROY, iNexus
  EmptyCellRunNumber = STRCOMPRESS(EmptyCellRunNumber,/REMOVE_ALL)
  (*global).EmptyCellRunNumber = EmptyCellRunNumber
  
  putTextFieldvalue, Event, 'empty_cell_nexus_run_number', EmptyCellRunNumber, 0
  
  LogBookText = '> Openning Empty Cell Run Number: ' + EmptyCellRunNumber
  IF (N_ELEMENTS(POLA_STATE)) THEN BEGIN
    LogBookText += ' (polarization state: ' + list_pola_state[POLA_STATE] + ')'
  ENDIF
  
  IDLsendLogBook_addLogBookText, Event, LogBookText
  IDLsendLogBook_addLogBookText, Event, LogBookText + ' ... ' + PROCESSING, ALT=3
  
  NbrNexus = 1
  
  status = OpenEmptyCellNexusFile(Event, $
    EmptyCellRunNumber, $
    nexus_file_name, $
    POLA_STATE = pola_state)
    
  IF (status EQ 0) THEN BEGIN
    (*global).EmptyCellNeXusFound = 0
    IDLsendLogBook_ReplaceLogBookText, $
      Event, $
      ALT=3, $
      PROCESSING, $
      FAILED
    RETURN
  ENDIF
  
  ;plot now
  result = REFreduction_PlotEmptyCellFile(Event)
  IF (result EQ 0) THEN BEGIN
    (*global).EmptyCellNeXusFound = 0
    IDLsendLogBook_ReplaceLogBookText, $
      Event, $
      ALT=3, $
      PROCESSING, $
      FAILED
    RETURN
  ENDIF
  
  (*global).EmptyCellNeXusFound = 1
  
  ;update GUI according to result of NeXus found or not
  ;RefReduction_update_empty_cell_gui_if_NeXus_found, Event, 1
  
  IDLsendLogBook_ReplaceLogBookText, $
    Event, $
    ALT=3, $
    PROCESSING, $
    OK
    
  WIDGET_CONTROL,HOURGLASS=0
  
END

;------------------------------------------------------------------------------
;This function get the nexus name from the data droplist and displays
;the nxsummary of that nexus file
PRO DisplayEmptyCellNxsummary, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  prevECNexusIndex = (*global).PreviousECNexusListSelected
  currECNexusIndex = getDropListSelectedIndex(Event, $
    'empty_cell_nexus_droplist')
    
  if (prevECNexusIndex NE currECNexusIndex) then begin
  
    ;reset value of previous index selected
    (*global).PreviousECNexusListSelected = currECNexusIndex
    
    ;get full name of index selected
    currFullECNexusName = $
      getDropListSelectedValue(Event, $
      'empty_cell_nexus_droplist')
      
    ;display NXsummary of that file
    RefReduction_NXsummary, $
      Event, $
      currFullECNexusName, $
      'empty_cell_list_nexus_nxsummary_text_field'
  endif
END

;------------------------------------------------------------------------------
PRO LoadListOfEmptyCellNexus, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  PROCESSING = (*global).processing_message ;processing message
  OK         = (*global).ok
  
  ;indicate reading data with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  
  ;get full name of index selected
  currFullEmptyCellNexusName = $
    getDropListSelectedValue(Event, 'empty_cell_nexus_droplist')
  full_nexus_name = currFullEmptyCellNexusName
  (*global).empty_cell_nexus_full_path = full_nexus_name
  
  ;display message in data log book
  InitialStrarr = getDataLogBookText(Event)
  MessageToAdd = ' OK'
  putTextAtEndOfDataLogBookLastLine, Event, InitialStrarr, MessageToAdd
  
  IDLsendLogBook_ReplaceLogBookText, $
    Event, $
    ALT=3, $
    PROCESSING, $
    'OK'
    
  IDLsendLogBook_AddLogBookText, $
    Event, $
    ALT=3, $
    'Opening selected file ... ' + PROCESSING
    
  ;map=0 the base
  MapBase, Event, 'empty_cell_list_nexus_base', 0
  
  ;get run number
  RunNumber = getTextFieldValue(Event,'empty_cell_nexus_run_number')
  
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
    result = OpenEmptyCellNeXusFile(Event, $
      RunNumber, $
      full_nexus_name)
      
    ;plot now
    result = REFreduction_PlotEmptyCellFile(Event)
    IF (result EQ 0) THEN BEGIN
      (*global).EmptyCellNeXusFound = 0
      IDLsendLogBook_ReplaceLogBookText, $
        Event, $
        ALT=3, $
        PROCESSING, $
        FAILED
      RETURN
    ENDIF
    
    ;update GUI according to result of NeXus found or not
    ;    RefReduction_update_data_gui_if_NeXus_found, $
    ;      Event, $
    ;      result
    
    IDLsendLogBook_ReplaceLogBookText, $
      Event, $
      ALT=3, $
      PROCESSING, $
      OK
      
    (*global).EmptyCellNeXusFound = 1
    
    WIDGET_CONTROL,HOURGLASS=0
    
  ENDIF ELSE BEGIN
  
    WIDGET_CONTROL,HOURGLASS=0
    
    ;ask user to select the polarization state he wants to see
    (*global).pola_type = 'empty_cell_load'
    select_polarization_state, Event, $
      full_nexus_name, $
      list_pola_state
      
  ENDELSE                         ;end of "IF (nbr_pola_state EQ 1)"
END

;------------------------------------------------------------------------------
PRO CancelListOfEmptyCellNexus, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  PROCESSING = (*global).processing_message
  CANCEL     = 'CANCELED'
  
  ;map=0 the base
  MapBase, Event, 'empty_cell_list_nexus_base', 0
  
  ;clear data run number entry
  putTextFieldValue, event, 'empty_cell_nexus_run_number', '',0
  
  ;inform data log book and log book that process has been canceled
  IDLsendLogBook_ReplaceLogBookText, Event, $
    PROCESSING, $
    CANCEL
    
  IDLsendLogBook_ReplaceLogBookText, Event, $
    ALT = 3, $
    PROCESSING, $
    CANCEL
    
END

;------------------------------------------------------------------------------
PRO activate_OR_NOT_substrate_base, Event
  value          = getCWBgroupValue(Event,'empty_cell_substrate_group')
  ActivateStatus = 0^value
  ActivateWidget, Event, 'empty_cell_substrate_base', ActivateStatus
END

;------------------------------------------------------------------------------
PRO substrate_type_droplist_event, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ;get index selected
  index_selected = getDropListSelectedIndex(Event,'empty_cell_substrate_list')
  substrate_type = (*(*global).substrate_type)
  A  = substrate_type[index_selected].A
  sA = STRCOMPRESS(A,/REMOVE_ALL)
  B  = substrate_type[index_selected].B
  sB = STRCOMPRESS(B,/REMOVE_ALL)
  putTextFieldValue, event, 'empty_cell_substrate_a', sA, 0
  putTextFieldValue, event, 'empty_cell_substrate_b', sB, 0
END

;------------------------------------------------------------------------------
PRO update_substrate_equation, Event
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  errorA = 0
  errorB = 0
  errorD = 0
  errorC = 0 ;scaling factor
  
  ;get A, B, D  and C parameters
  A = getTextFieldValue(Event, 'empty_cell_substrate_a')
  B = getTextFieldValue(Event, 'empty_cell_substrate_b')
  D = getTextFieldValue(Event, 'empty_cell_diameter')
  C = getTextFieldValue(Event, 'empty_cell_scaling_factor')
  
  A = STRCOMPRESS(A,/REMOVE_ALL)
  B = STRCOMPRESS(B,/REMOVE_ALL)
  D = STRCOMPRESS(D,/REMOVE_ALL)
  C = STRCOMPRESS(C,/REMOVE_ALL)
  
  ;;check value of A, B, D and C
  IF (A EQ '')  THEN BEGIN
    errorA = 1
    A = 'N/A'
  ENDIF
  IF (B EQ '')  THEN BEGIN
    errorB = 1
    B = 'N/A'
  ENDIF
  IF (D EQ '')  THEN BEGIN
    errorD = 1
    D = 'N/A'
  ENDIF
  
  IF (C EQ '0') THEN BEGIN
    errorC = 1
    C = 'N/A'
  ENDIF
  
  ;check that A, B, D and C are real numbers
  format_error_status = 1
  ON_IOERROR, format_error
  
  ;change from cm -> m
  IF (errorA NE 1) THEN BEGIN
    A = FLOAT(A) * 100
  ENDIF
  
  IF (errorB NE 1) THEN BEGIN
    B = FLOAT(B) * 10000
  ENDIF
  
  IF (errorD NE 1) THEN BEGIN
    D = FLOAT(D) * 0.01
  ENDIF
  
  format_error_status = 0
  
  ;final equation
  Equation  = 'T = '
  IF (STRCOMPRESS(C,/REMOVE_ALL) NE '1') THEN BEGIN
    Equation += STRCOMPRESS(C,/REMOVE_ALL) + ' * '
  ENDIF
  Equation += 'exp[-(' + STRCOMPRESS(A,/REMOVE_ALL)
  Equation += ' + ' + STRCOMPRESS(B,/REMOVE_ALL)
  Equation += ' * Lambda) * ' + STRCOMPRESS(D,/REMOVE_ALL)
  Equation += ']'
  
  IF (errorA + errorB + errorD + errorC GT 0) THEN BEGIN
    IF ((*global).miniVersion) THEN BEGIN
      Equation = 'ERROR>> ' + Equation
    ENDIF ELSE BEGIN
      Equation = ' E R R O R >>  ' + Equation + '  << E R R O R '
    ENDELSE
  ENDIF
  
  ;update equation
  putTextFieldValue, Event, 'empty_cell_substrate_equation', Equation[0], 0
  
  format_error:
  IF (format_error_status EQ 1) THEN BEGIN
    widget_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='empty_cell_scaling_factor_button')
      
    result = DIALOG_MESSAGE('Format of one of the parameter is wrong!',$
      /ERROR,$
      TITLE = 'FORMAT ERROR',$
      DIALOG_PARENT = widget_id)
  ENDIF
  
END

;______________________________________________________________________________
;This function is reached each time the user wants to calculate the SF
PRO RefreshEquationDraw, Event
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  draw1 = WIDGET_INFO(Event.top,FIND_BY_UNAME='scaling_factor_equation_draw')
  WIDGET_CONTROL, draw1, GET_VALUE=id
  WSET, id
  image = READ_PNG((*global).sf_equation_file)
  tv, image, 0,0,/true
END

;------------------------------------------------------------------------------
FUNCTION OpenEmptyCellNeXusFile_from_repopulate, Event, $
    EmptyCellRunNumber, $
    full_nexus_name, $
    POLA_STATE=pola_state
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  instrument = (*global).instrument
  
  ;store full path to NeXus
  (*global).empty_cell_full_nexus_name = full_nexus_name
  
  RefReduction_NXsummaryBatch, Event, $
    full_nexus_name, $
    'empty_cell_nx_summary'
    
  ;check format of NeXus file
  IF (H5F_IS_HDF5(full_nexus_name)) THEN BEGIN
    (*global).isHDF5format = 1
    
    working_path = (*global).working_path
    
    status = RefReduction_DumpBinaryEmptyCell_batch(Event,$ ;_dumpbinary.pro
      full_nexus_name, $
      working_path,$
      POLA_STATE=pola_state)
      
    IF ((*global).debugging_on_Mac EQ 'yes') THEN BEGIN
      status = REFReduction_DumpBinaryData(Event,$
        full_nexus_name, $
        working_path, $
        POLA_STATE=pola_state)
    ENDIF
    
    IF (status EQ 0) THEN RETURN, 0
    
  ENDIF ELSE BEGIN
  
    (*global).isHDF5format = 0
    RETURN, 0
  ENDELSE
  
  RETURN, 1
END

;------------------------------------------------------------------------------
PRO load_empty_cell_browse_nexus_from_repopulate, Event, $
    nexus_file_name, $
    POLA_STATE=pola_state
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;get run number
  IF (N_ELEMENTS(POLA_STATE)) THEN BEGIN
    list_pola_state = (*(*global).list_pola_state)
    iNexus = OBJ_NEW('IDLgetMetadata', $
      nexus_file_name, $
      POLA_STATE_NAME=list_pola_state[pola_state])
  ENDIF ELSE BEGIN
    iNexus = OBJ_NEW('IDLgetMetadata', nexus_file_name)
  ENDELSE
  
  EmptyCellRunNumber = iNexus->getRunNumber()
  OBJ_DESTROY, iNexus
  EmptyCellRunNumber = STRCOMPRESS(EmptyCellRunNumber,/REMOVE_ALL)
  (*global).EmptyCellRunNumber = EmptyCellRunNumber
  
  NbrNexus = 1
  
  status = OpenEmptyCellNexusFile_from_repopulate(Event, $
    EmptyCellRunNumber, $
    nexus_file_name, $
    POLA_STATE = pola_state)
    
  IF (status EQ 0) THEN BEGIN
    (*global).EmptyCellNeXusFound = 0
    RETURN
  ENDIF
  
  ;plot now
  result = REFreduction_PlotEmptyCellFile_from_repopulate(Event)
  IF (result EQ 0) THEN BEGIN
    (*global).EmptyCellNeXusFound = 0
    RETURN
  ENDIF
  
  (*global).EmptyCellNeXusFound = 1
  
;update GUI according to result of NeXus found or not
;RefReduction_update_empty_cell_gui_if_NeXus_found, Event, 1
  
END

;------------------------------------------------------------------------------
;this is reached by the repopulating gui
;the run number and the full file name (path) is known
PRO OpenPlotEmptyCell, Event, run_number, nexus_file_name

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  (*global).empty_cell_nexus_full_path = nexus_file_name
  
  ;indicate initialization with hourglass icon
  ;    WIDGET_CONTROL,/HOURGLASS
  ;
  ;    ;check how many polarization states the file has
  ;    nbr_pola_state = check_number_polarization_state(Event, $
  ;      nexus_file_name,$
  ;      list_pola_state)
  ;
  ;    IF (nbr_pola_state EQ -1) THEN BEGIN ;missing function
  ;      putLogBookMessage, Event, $
  ;        'ERROR retrieving the number of' + $
  ;        ' polarization states!', $
  ;        APPEND=1
  ;
  ;      ;turn off hourglass
  ; ;     WIDGET_CONTROL,HOURGLASS=0
  ;      RETURN
  ;    ENDIF
  ;
  ;    IF (nbr_pola_state EQ 1) THEN BEGIN ;only 1 polarization state
  ;      ;load browse nexus file
  load_empty_cell_browse_nexus_from_repopulate, Event, nexus_file_name
;    ENDIF ELSE BEGIN
;      ;ask user to select the polarization state he wants to see
;      (*global).pola_type = 'empty_cell_browse'
;      select_polarization_state, Event, nexus_file_name, list_pola_state
;    ENDELSE
;
;    ;turn off hourglass
;    WIDGET_CONTROL,HOURGLASS=0
;
;  ENDIF ELSE BEGIN
;
;    text = '-> Operation canceled!'
;    putLogBookMessage, Event, Text, Append=1
;
;  ENDELSE
END

;-----------------------------------------------------------------------------
PRO empty_cell_lin_log, Event
  value = Event.value ;0:linear, 1:log
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  DEVICE, DECOMPOSED = 0
  LOADCT, 13, /SILENT
  
  lin_log_value = getCWBgroupValue(Event, 'empty_cell_sf_z_axis')
  
  ;data
  data = (*(*global).DATA_D_TOTAL_ptr)
  IF (lin_log_value EQ 1) THEN BEGIN
    zero_index = WHERE(data EQ 0., nbr)
    IF (nbr GT 0) THEN BEGIN
      data[zero_index] = !VALUES.D_NAN
    ENDIF
    data = ALOG10(data)
    cleanup_array, data
  ENDIF
  (*(*global).in_empty_cell_data_ptr) = data
  
  id_draw = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='empty_cell_scaling_factor_base_data_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  TVSCL, data, /DEVICE
  
  ;replot selection if there is one
  x0 = (*global).sf_x0
  y0 = (*global).sf_y0
  x1 = (*global).sf_x1
  y1 = (*global).sf_y1
  
  color = 150
  
  PLOTS, [x0, x0, x1, x1, x0],$
    [y0,y1, y1, y0, y0],$
    /DEVICE,$
    COLOR =color
    
  ;empty cell
  data = (*(*global).EMPTY_CELL_D_TOTAL_ptr)
  IF (lin_log_value EQ 1) THEN BEGIN
    zero_index = WHERE(data EQ 0., nbr)
    IF (nbr GT 0) THEN BEGIN
      data[zero_index] = !VALUES.D_NAN
    ENDIF
    data = ALOG10(data)
    cleanup_array, data
  ENDIF
  (*(*global).in_empty_cell_empty_cell_ptr) = data
  
  id_draw = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='empty_cell_scaling_factor_base_empty_cell_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  TVSCL, data, /DEVICE
  
END


