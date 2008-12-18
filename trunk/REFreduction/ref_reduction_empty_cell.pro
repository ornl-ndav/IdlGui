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
PRO REFreduction_LoadDatafile2, Event, isNeXusFound, NbrNexus

;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

PROCESSING = (*global).processing_message ;processing message
OK         = (*global).ok
FAILED     = (*global).failed
instrument = (*global).instrument ;retrieve name of instrument

;get Data Run Number from DataTextField
DataRunNumber = getTextFieldValue(Event,'load_data_run_number_text_field')
DataRunNumber = STRCOMPRESS(DataRunNumber,/REMOVE_ALL)
isNeXusFound = 0                ;by default, NeXus not found

WIDGET_CONTROL,/HOURGLASS

IF (DataRunNumber NE '') THEN BEGIN ;data run number is not empty
    
    (*global).DataRunNumber = DataRunNumber
    
;check if user wants archived or all nexus runs +++++++++++++++++++++++++++++++
    IF (~isArchivedDataNexusDesired(Event)) THEN BEGIN ;get full list of Nexus
        
        LogBookText = '-> Retrieving full list of DATA Run Number: ' + $
          DataRunNumber
        IDLsendLogBook_addLogBookText, Event, LogBookText
        LogBookText += ' ... ' + PROCESSING 
        putDataLogBookMessage, Event, LogBookText
        
        LogBookText = $
          '--> Checking if at least one NeXus file can be found ' + $
          ' ... ' + PROCESSING
        IDLsendLogBook_addLogBookText, Event, LogBookText

;get path to nexus run #
            full_list_of_nexus_name = find_list_nexus_name(Event,$
                                                           DataRunNumber,$
                                                           instrument,$
                                                           isNeXusFound)

        IF (~isNexusFound) THEN BEGIN ;no nexus found
            
;tells the user that the NeXus file has not been found
            Message = 'FAILED - No NeXus can be found'
            IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message
            
            IDLsendLogBook_ReplaceLogBookText, $
              Event, $
              ALT=1, $
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
                  'data_list_nexus_droplist'
                MapBase, Event, 'data_list_nexus_base', 1
                
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
                
;display nxsummary of first file in 'data_list_nexus_base'
                RefReduction_NXsummary, $
                  Event, $
                  full_list_of_nexus_name[0], $
                  'data_list_nexus_nxsummary_text_field'
                
;Inform user that program is waiting for his action
                LogText = $
                  '<USERS!> Waiting for input from users. Please select ' + $
                  'one NeXus file from the list:'
                IDLsendLogBook_addLogBookText, Event, LogText
                
;display info in data log book
                IDLsendLogBook_ReplaceLogBookText, Event, $
                  ALT = 1, $
                  PROCESSING, $
                  OK
                text = ' -> Please select one of the ' + $
                  STRCOMPRESS(sz,/REMOVE_ALL)
                text += ' NeXus file found .....'
                IDLsendLogBook_addLogBookText, Event, ALT=1, text
                
            ENDIF ELSE BEGIN    ;only 1 found
                
                IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, OK
                
                full_nexus_name = full_list_of_nexus_name[0]
                NbrNexus = 1
                (*global).data_nexus_full_path = full_nexus_name
                
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
                    result = OpenDataNexusFile(Event, $
                                               DataRunNumber, $
                                               full_nexus_name)

                    isNexusFound = result
                    
;plot data now
                    result = REFreduction_Plot1D2DDataFile(Event) 
                    IF (result EQ 0) THEN BEGIN
                        IDLsendLogBook_ReplaceLogBookText, $
                          Event, $
                          ALT=1, $
                          PROCESSING, $
                          FAILED
                        RETURN
                    ENDIF
                    
                    (*global).DataNeXusFound = result
                    
;update GUI according to result of NeXus found or not
                    RefReduction_update_data_gui_if_NeXus_found, Event, result
                    
                    WIDGET_CONTROL,HOURGLASS=0
                    
                ENDIF ELSE BEGIN
                    
                    WIDGET_CONTROL,HOURGLASS=0
                    
;ask user to select the polarization state he wants to see
                    (*global).pola_type = 'data_load'
                    select_polarization_state, Event, $
                      full_nexus_name, $
                      list_pola_state
;               OpenDataNexusFile, Event, $
;                                  DataRunNumber, $
;                                  full_list_of_nexus_name
                    
                ENDELSE         ;end of "IF (nbr_pola_state EQ 1)"
                
            ENDELSE             ;end of 1 or more nexus found
            
        ENDELSE
;we just want the archived one
    ENDIF ELSE BEGIN ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++  
        
        LogBookText = '-> Openning Archived DATA Run Number: ' + DataRunNumber
        putLogBookMessage, Event, LogBookText, Append=1
        LogBookText += ' ... ' + PROCESSING 
        putDataLogBookMessage, Event, LogBookText
        LogBookText = '--> Checking if NeXus run number exists ... ' + $
          PROCESSING    
        IDLsendLogBook_addLogBookText, Event, LogBookText
        
;get path to nexus run #
        full_nexus_name = find_full_nexus_name(Event,$
                                               DataRunNumber,$
                                               instrument,$
                                               isNeXusFound)
        
        IF (~isNeXusFound) THEN BEGIN ;NeXus has not been found
            NbrNexus = 0
;tells the user that the NeXus file has not been found
;get log book full text
            Message = 'FAILED - NeXus file does not exist'
            IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message
            
;get data log book full text
            DataLogBookText = getDataLogBookText(Event)
            putTextAtEndOfDataLogBookLastLine,$
              Event,$
              DataLogBookText,$
              'NeXus does not exist!',$
              PROCESSING
            
;no needs to do anything more
            
        ENDIF ELSE BEGIN        ;NeXus has been found
            
            LogBookText = getLogBookText(Event)
            Message = 'OK  ' + '(Full Path is: ' + $
              strcompress(full_nexus_name) + ')'
            IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message
            
            NbrNexus = 1
            (*global).data_nexus_full_path = full_nexus_name
            
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
                result = OpenDataNexusFile(Event, $
                                           DataRunNumber, $
                                           full_nexus_name)
                
                IF (result EQ 0) THEN BEGIN
                    IDLsendLogBook_ReplaceLogBookText, $
                      Event, $
                      ALT=1, $
                      PROCESSING, $
                      FAILED
                    RETURN
                ENDIF
                isNeXusFound = result

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
                                
                IF (result) THEN BEGIN
                    IDLsendLogBook_ReplaceLogBookText, $
                      Event, $
                      ALT=1, $
                      PROCESSING, $
                      OK
                ENDIF ELSE BEGIN
                    IDLsendLogBook_ReplaceLogBookText, $
                      Event, $
                      ALT=1, $
                      PROCESSING, $
                      FAILED
                ENDELSE                    
                
;update GUI according to result of NeXus found or not
                RefReduction_update_data_gui_if_NeXus_found, Event, result

            ENDIF ELSE BEGIN
;ask user to select the polarization state he wants to see
                (*global).pola_type = 'data_load'
                select_polarization_state, Event, $
                  full_nexus_name, $
                  list_pola_state
            ENDELSE
            
        ENDELSE

        WIDGET_CONTROL,HOURGLASS=0
        
    ENDELSE
    
ENDIF                           ;end of if(DataRunNumber Ne '')

END

;------------------------------------------------------------------------------
PRO BrowseEmptyCellNexus, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

filter    = '*.nxs'
extension = 'nxs'
title     = 'Select a NeXus file ...'
path      = (*global).browse_data_path
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

