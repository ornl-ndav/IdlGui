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
;this function load the given nexus file and get the binary data
PRO REFreduction_LoadDatafile, Event, isNeXusFound, NbrNexus

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

;indicate reading data with hourglass icon
WIDGET_CONTROL,/hourglass

IF (DataRunNumber NE '') THEN BEGIN ;data run number is not empty
   (*global).DataRunNumber = DataRunNumber

;check if user wants archived or all nexus runs +++++++++++++++++++++++++++++++
    IF (~isArchivedDataNexusDesired(Event)) THEN BEGIN ;get full list of Nexus
        LogBookText = '-> Retrieving full list of DATA Run Number: ' + $
          DataRunNumber
        text = getLogBookText(Event)
        if (text[0] EQ '') then begin
            putLogBookMessage, Event, LogBookText
        endif else begin
            putLogBookMessage, Event, LogBookText, Append=1
        endelse
        LogBookText += ' ..... ' + PROCESSING 
        putDataLogBookMessage, Event, LogBookText
        
;indicate reading data with hourglass icon
        widget_control,/hourglass
        
        LogBookText = $
          '----> Checking if at least one NeXus file can be found ' + $
          '..... '
        LogBookText += PROCESSING
        putLogBookMessage, Event, LogBookText, Append=1

;check if nexus exist and if it does, returns the full path
        
;get path to nexus run #
        instrument=(*global).instrument ;retrieve name of instrument
        full_list_of_nexus_name = find_list_nexus_name(Event,$
                                                       DataRunNumber,$
                                                       instrument,$
                                                       isNeXusFound)

        if (~isNexusFound) then begin ;no nexus found
            
;tells the user that the NeXus file has not been found
;get log book full text
            LogBookText = getLogBookText(Event)
            Message = 'FAILED - No NeXus can be found'
            putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, $
              PROCESSING
;get data log book full text
            DataLogBookText = getDataLogBookText(Event)
            putTextAtEndOfDataLogBookLastLine,$
              Event,$
              DataLogBookText,$
              'NeXus run number does not exist!',$
              PROCESSING
            
            NbrNexus = 0

;no needs to do anything more
            
        endif else begin        ;1 or more nexus have been bound
            
;display list of nexus found if list is GT 1 otherwise proceed as
;before
            sz = (size(full_list_of_nexus_name))(1)
            NbrNexus = sz
            if (sz GT 1) then begin

;display list in droplist and map=1 base
                putArrayInDropList, $
                  Event, $
                  full_list_of_nexus_name, $
                  'data_list_nexus_droplist'
                
;map base
                MapBase, Event, 'data_list_nexus_base', 1

;display info in log book
                LogBookText = getLogBookText(Event)        
                Message = 'OK'
                putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, $
                  PROCESSING
                LogText = '----> Found ' + strcompress(sz,/remove_all)
                LogText += ' NeXus files:'
                putLogBookMessage,Event, LogText,Append=1
                for i=0,(sz-1) do begin
                    text = '       ' + full_list_of_nexus_name[i]
                    putLogBookMessage, Event,text,Append=1
                endfor

;display nxsummary of first file in 'data_list_nexus_base'
                RefReduction_NXsummary, $
                  Event, $
                  full_list_of_nexus_name[0], $
                  'data_list_nexus_nxsummary_text_field'
                
;Inform user that program is waiting for his action
                LogText = $
                  '----> Selecting one NeXus file from the list ..... ' $
                  + PROCESSING
                putLogBookMessage,Event,LogText,Append=1

;display info in data log book
                DataLogBookText = getDataLogBookText(Event)
                putTextAtEndOfDataLogBookLastLine,$
                  Event,$
                  DataLogBookText,$
                  'OK',$
                  PROCESSING
                text = ' --> Please select one of the ' + $
                  strcompress(sz,/remove_all)
                text += ' NeXus file found .....'
                putDataLogBookMessage, Event, text, Append=1

            endif else begin    ;proceed as before
                
                OpenDataNexusFile, Event, DataRunNumber, $
                  full_list_of_nexus_name
                
            endelse             ;end of list is only 1 element long
            
        endelse                 ;end of nexus found
        
;we just want the archived one
    ENDIF ELSE BEGIN ;++++++++++++++++++++++++++++++++++++++++++++++++++++++++  

        LogBookText = '-> Openning Archived DATA Run Number: ' + DataRunNumber
        putLogBookMessage, Event, LogBookText, Append=1
        LogBookText += ' ... ' + PROCESSING 
        putDataLogBookMessage, Event, LogBookText
        LogBookText = '--> Checking if NeXus run number exists ... ' + $
          PROCESSING    
        putLogBookMessage, Event, LogBookText, Append=1  
        
;get path to nexus run #
        full_nexus_name = find_full_nexus_name(Event,$
                                               DataRunNumber,$
                                               instrument,$
                                               isNeXusFound)
           
        
        IF (~isNeXusFound) THEN BEGIN ;NeXus has not been found
           NbrNexus = 0
;tells the user that the NeXus file has not been found
;get log book full text
            LogBookText = getLogBookText(Event)
            Message = 'FAILED - NeXus file does not exist'
            putTextAtEndOfLogBookLastLine, Event, LogBookText, $
                                           Message, $
                                           PROCESSING
;get data log book full text
            DataLogBookText = getDataLogBookText(Event)
            putTextAtEndOfDataLogBookLastLine,$
               Event,$
               DataLogBookText,$
               'NeXus does not exist!',$
               PROCESSING
            
;no needs to do anything more
            
        ENDIF ELSE BEGIN        ;NeXus has been found
            
           IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, OK

           NbrNexus = 1
           (*global).data_nexus_full_path = full_nexus_name

;check how many polarization states the file has
           nbr_pola_state = $
              check_number_polarization_state(Event, $
                                              full_nexus_name,$
                                              list_pola_state)
           IF (nbr_pola_state EQ -1) THEN BEGIN ;missing function
;turn off hourglass
              WIDGET_CONTROL,HOURGLASS=0
              RETURN
           ENDIF
           
           IF (nbr_pola_state EQ 1) THEN BEGIN ;only 1 polarization state
;load browse nexus file
              OpenDataNexusFile, Event, DataRunNumber, nexus_file_name
           ENDIF ELSE BEGIN
;ask user to select the polarization state he wants to see
              (*global).pola_type = 'data_load'
              select_polarization_state, Event, $
                                         full_nexus_name, $
                                         list_pola_state
           ENDELSE

        ENDELSE
        
     ENDELSE
    
 ENDIF                          ;end of if(DataRunNumber Ne '')

;update GUI according to result of NeXus found or not
RefReduction_update_data_gui_if_NeXus_found, Event, isNeXusFound

END

;------------------------------------------------------------------------------
FUNCTION OpenDataNeXusFile, Event, $
                            DataRunNumber, $
                            full_nexus_name, $
                            POLA_STATE=pola_state

;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

PROCESSING = (*global).processing_message ;processing message
instrument = (*global).instrument

;store run number of data file
(*global).data_run_number = DataRunNumber

;store full path to NeXus
(*global).data_full_nexus_name = full_nexus_name

;display full nexus name in REDUCE tab
putTextFieldValue, $
  event, $
  'reduce_data_runs_text_field', $
  STRCOMPRESS(full_nexus_name,/REMOVE_ALL), $
  0                             ;do not append

;tells the user that the NeXus file has been found
;get log book full text
LogBookText = getLogBookText(Event)
Message = 'OK  ' + '( Full Path is: ' + strcompress(full_nexus_name) + ')'
putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING

;display info about nexus file selected
LogBookText = $
  '-> Displaying information about run number using nxsummary:'
putLogBookMessage, Event, LogBookText, Append=1
RefReduction_NXsummary, Event, $
                        full_nexus_name, $
                        'data_file_info_text', $
                        POLA_STATE=pola_state

;check format of NeXus file
IF (H5F_IS_HDF5(full_nexus_name)) THEN BEGIN
    (*global).isHDF5format = 1
    LogBookText = '-> Is format of NeXus hdf5 ? YES'
    putLogBookMessage, Event, LogBookText, Append=1

;dump binary data into local directory of user
    working_path = (*global).working_path
    status = REFReduction_DumpBinaryData(Event,$ ;_dumpbinary.pro
                                         full_nexus_name, $
                                         working_path, $
                                         POLA_STATE=pola_state)
    
    IF (status EQ 0) THEN RETURN, 0
    
    IF ((*global).isHDF5format) THEN BEGIN
;create name of BackgroundROIFiles and and put it in its box
       REFreduction_CreateDefaultDataBackgroundROIFileName, Event, $
          instrument, $
          working_path, $
          DataRunNumber
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
;Same as previous function but this one is reached by the batch run so
;without any log book messages
PRO OpenDataNeXusFile_batch, Event, DataRunNumber, full_nexus_name
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
instrument = (*global).instrument
;store run number of data file
(*global).data_run_number = DataRunNumber
;store full path to NeXus
(*global).data_full_nexus_name = full_nexus_name
RefReduction_NXsummaryBatch, Event, full_nexus_name, 'data_file_info_text'
;check format of NeXus file
IF (H5F_IS_HDF5(full_nexus_name)) THEN BEGIN
    (*global).isHDF5format = 1
;dump binary data into local directory of user
    working_path = (*global).working_path
    REFReduction_DumpBinaryData_batch, Event, full_nexus_name, working_path
    IF ((*global).isHDF5format) THEN BEGIN
;create name of BackgroundROIFile and put it in its box
        REFreduction_CreateDefaultDataBackgroundROIFileName, Event, $
          instrument, $
          working_path, $
          DataRunNumber
    ENDIF
ENDIF ELSE BEGIN
    (*global).isHDF5format = 0
    ;tells the data log book that the format is wrong
    InitialStrarr = getDataLogBookText(Event)
    putTextAtEndOfDataLogBookLastLine, $
      Event, $
      InitialStrarr, $
      (*global).failed, $
      PROCESSING
ENDELSE
END
