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

FUNCTION OpenNormNeXusFile, Event, $
                            NormRunNumber, $
                            full_nexus_name, $
                            POLA_STATE=pola_state
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

PROCESSING = (*global).processing_message ;processing message
instrument = (*global).instrument

;store run number of data file
(*global).norm_run_number = NormRunNumber

;store full path to NeXus
(*global).norm_full_nexus_name = full_nexus_name

;display full nexus name in REDUCE tab
putTextFieldValue, $
  event, $
  'reduce_normalization_runs_text_field', $
  strcompress(full_nexus_name,/remove_all), $
  0   
                                ;do not append
;tells the user that the NeXus file has been found
;get log book full text
;LogBookText = getLogBookText(Event)
;Message = 'OK  ' + '( Full Path is: ' + strcompress(full_nexus_name) + ')'
;IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message

;display info about nexus file selected
LogBookText = $
  '-> Displaying information about run number using nxsummary:'
putLogBookMessage, Event, LogBookText, Append=1
RefReduction_NXsummary, Event, $
  full_nexus_name, $
  'normalization_file_info_text', $
  POLA_STATE=pola_state

;check format of NeXus file
IF (H5F_IS_HDF5(full_nexus_name)) THEN BEGIN
    (*global).isHDF5format = 1
    LogBookText = '--> Is format of NeXus hdf5 ? YES'
    putLogBookMessage, Event, LogBookText, Append=1
    
;dump binary data into local directory of user
    working_path = (*global).working_path
    status = REFReduction_DumpBinaryNormalization(Event,$
                                                  full_nexus_name, $
                                                  working_path, $
                                                  POLA_STATE=pola_state)
    IF (status EQ 0) THEN RETURN, 0
    
    IF ((*global).isHDF5format) THEN BEGIN
;create name of BackgroundROIFile and put it in its box
        REFreduction_CreateDefaultNormBackgroundROIFileName, Event, $
          instrument, $
          working_path, $
          NormRunNumber
    ENDIF ELSE BEGIN
        RETURN, 0
    ENDELSE
ENDIF ELSE BEGIN
    (*global).isHDF5format = 0
    LogBookText = '-> Is format of NeXus hdf5 ? NO'
    putLogBookMessage, Event, LogBookText, Append=1
    LogBookText = ' !!! REFreduction does not support this file format. '
    LogBookText += 'Please use rebinNeXus to create a hdf5 nexus file !!!'
    putLogBookMessage, Event, LogBookText, Append=1
    RETURN, 0
ENDELSE
RETURN, 1
END

;------------------------------------------------------------------------------
;this function load the given nexus file and dump the binary file
;in the tmp norm file
PRO REFreduction_LoadNormalizationfile, Event, isNexusFound, NbrNexus

;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global

PROCESSING = (*global).processing_message ;processing message
OK         = (*global).ok
FAILED     = (*global).failed
instrument = (*global).instrument ;retrieve name of instrument

;get Data Run Number from DataTextField
NormalizationRunNumber = $
   getTextFieldValue(Event, $
                     'load_normalization_run_number_text_field')
NormalizationRunNumber = STRCOMPRESS(NormalizationRunNumber, /REMOVE_ALL)
isNeXusFound = 0                ;by default, NeXus not found

WIDGET_CONTROL,/HOURGLASS

IF (NormalizationRunNumber NE '') THEN BEGIN 
;normalization run number is not empty

   (*global).NormRunNumber = NormalizationRunNumber

;check if user wants archive dor all nexus runs +++++++++++++++++++++++++++++++
    IF (~isArchivedNormNexusDesired(Event)) THEN BEGIN ;get full list of Nexus

        LogBookText = '-> Retrieving full list of ' + $
          'NORMALIZATION Run Number: ' +$
          NormalizationRunNumber
        IDLsendLogBook_addLogBookText, Event, LogBookText
        LogBookText += ' ... ' + PROCESSING 
        IDLsendLogBook_addLogBookText, Event, ALT=2, LogBookText

        LogBookText = '--> Checking if at least one NeXus file ' + $
          'can be found ... '
        LogBookText += PROCESSING
        IDLsendLogBook_addLogBookText, Event, LogBookText

;get path to nexus run #
        full_list_of_nexus_name = find_list_nexus_name(Event,$
                                                       NormalizationRunNumber,$
                                                       instrument,$
                                                       isNeXusFound)
        
        IF (~isNeXusFound) THEN BEGIN ;no nexus found

;tells the user that the NeXus file has not been found
            Message = 'FAILED - No NeXus can be found'
            IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message 

            IDLsendLogBook_ReplaceLogBookText, $
               Event, $
               ALT=2, $
               PROCESSING, $
               'NeXus run number does not exist!'
                        
            NbrNexus = 0
            
;no needs to do anything more

        ENDIF ELSE BEGIN ;1 or more nexus have been found

            WIDGET_CONTROL,HOURGLASS=0

;display list of nexus found if list is GT 1 otherwise proceed as
;before
            sz = (SIZE(full_list_of_nexus_name))(1)
            NbrNexus = sz
            IF (sz GT 1) THEN BEGIN ;more than 1 nexus file found

;display list in droplist and map=1 base
               putArrayInDropList, $
                  Event, $
                  full_list_of_nexus_name, $
                  'normalization_list_nexus_droplist'
               MapBase, Event, 'norm_list_nexus_base', 1

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
                   'normalization_list_nexus_nxsummary_text_field'
                
;Inform user that program is waiting for his action
                LogText = $
                   '<USERS!> Waiting for input from users. Please select ' + $
                   'one NeXus file from the list:'
                IDLsendLogBook_addLogBookText, Event, LogText

;display info in normalization log book
                IDLsendLogBook_ReplaceLogBookText, Event, $
                                                   ALT = 2, $
                                                   PROCESSING, $
                                                   OK
                text = ' -> Please select one of the ' + $
                  STRCOMPRESS(sz,/REMOVE_ALL)
                text += ' NeXus file found .....'
                IDLsendLogBook_addLogBookText, Event, ALT=2, text
                
             ENDIF ELSE BEGIN   ;only 1 found
                
                IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, OK
                
                full_nexus_name = full_list_OF_nexus_name[0]
                NbrNexus = 1
                (*global).norm_nexus_full_path = full_nexus_name
                
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
                    result = OpenNormNexusFile(Event, $
                                               NormalizationRunNumber, $
                                               full_nexus_name)
                   
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

                ENDIF ELSE BEGIN
;ask user to select the polarization state he wants to see
                   (*global).pola_type = 'norm_load'
                   select_polarization_state, Event, $
                                              full_nexus_name, $
                                              list_pola_state
                ENDELSE
                
             ENDELSE            ;end of list is only 1 element long
             
          ENDELSE               ;end of nexus found
        
;we just want the archived one
     ENDIF ELSE BEGIN ;++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        LogBookText = '-> Openning Archived NORMALIZATION Run Number: ' + $
                      NormalizationRunNumber
        putLogBookMessage, Event, LogBookText, Append=1
        LogBookText += ' ... ' + PROCESSING 
        putNormalizationLogBookMessage, Event, LogBookText
        LogBookText = '--> Checking if NeXus run number exist ... ' + $
                      PROCESSING
        IDLsendLogBook_addLogBookText, Event, LogBookText
        
;get path to nexus run #
        full_nexus_name = find_full_nexus_name(Event,$
                                               NormalizationRunNumber,$
                                               instrument,$
                                               isNeXusFound,$
                                               SOURCE_FILE='norm')

        IF (~isNeXusFound) THEN BEGIN ;NeXus has not been found
           NbrNexus = 0
;tells the user that the NeXus file has not been found
;get log book full text
            Message = 'FAILED - NeXus file does not exist'
            IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message

;get norm log book full text
            NormalizationLogBookText = getNormalizationLogBookText(Event)
            putTextAtEndOfNormalizationLogBookLastLine,$
               Event,$
               NormalizationLogBookText,$
               'NeXus does not exist!',$
               PROCESSING
            
;no needs to do anything more
            
        ENDIF ELSE BEGIN        ;NeXus has been found

            LogBookText = getLogBookText(Event)
           Message = 'OK  ' + '(Full Path is: ' + $
             strcompress(full_nexus_name) + ')'
           IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message

            NbrNexus = 1
            (*global).norm_nexus_full_path = full_nexus_name

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
                result = OpenNormNexusFile(Event, $
                                           NormalizationRunNumber, $
                                           full_nexus_name)
                
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
                
            ENDIF ELSE BEGIN
;ask user to select the polarization state he wants to see
               (*global).pola_type = 'norm_load'
               select_polarization_state, Event, $
                                          full_nexus_name, $
                                          list_pola_state
            ENDELSE

        ENDELSE
        
    ENDELSE
    
ENDIF                            ;end of if(NormalizationRunNumber Ne '')

END

;------------------------------------------------------------------------------
;Reached by the batch mode only
PRO OpenNormNeXusFile_batch, Event, NormRunNumber, full_nexus_name
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Entering OpenNormNexusFile_batch'
ENDIF

instrument = (*global).instrument

;store run number of data file
(*global).norm_run_number = NormRunNumber

;store full path to NeXus
(*global).norm_full_nexus_name = full_nexus_name

IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Before NXsummaryBatch'
ENDIF
RefReduction_NXsummaryBatch, Event, full_nexus_name, $
  'normalization_file_info_text'
IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'After NXsummaryBatch'
ENDIF

IF (H5F_IS_HDF5(full_nexus_name)) THEN BEGIN
    IF ((*global).debugging_version EQ 'yes') THEN BEGIN
        print, '-> file is HDF5'
    ENDIF

    (*global).isHDF5format = 1
;dump binary data into local directory of user
    working_path = (*global).working_path

    IF ((*global).debugging_version EQ 'yes') THEN BEGIN
        print, '-> About to enter REFreduction_DumpBinaryData_batch'
    ENDIF
    REFReduction_DumpBinaryNormalization_batch, Event, full_nexus_name, $
      working_path
    IF ((*global).debugging_version EQ 'yes') THEN BEGIN
        print, '-> About to leave REFreduction_DumpBinaryData_batch'
    ENDIF

    IF ((*global).isHDF5format) THEN BEGIN
;create name of BackgroundROIFile and put it in its box
    REFreduction_CreateDefaultNormBackgroundROIFileName, Event, $
      instrument, $
      working_path, $
      NormRunNumber
    ENDIF
ENDIF ELSE BEGIN

    IF ((*global).debugging_version EQ 'yes') THEN BEGIN
        print, '-> file is not HDF5'
    ENDIF

    (*global).isHDF5format = 0
    ;tells the norm log book that the format is wrong
    InitialStrarr = getNormalizationLogBookText(Event)
    putTextAtEndOfNormalizationLogBookLastLine, $
      Event, $
      InitialStrarr, $
      (*global).failed, $
      PROCESSING
ENDELSE

IF ((*global).debugging_version EQ 'yes') THEN BEGIN
    print, 'Leaving OpenNormNexusFile_batch'
ENDIF

END
