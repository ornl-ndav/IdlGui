;this function load the given nexus file and dump the binary file
;in the tmp norm file
PRO REFreduction_LoadNormalizationfile, Event, isNexusFound, NbrNexus

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing_message ;processing message

;get Data Run Number from DataTextField
NormalizationRunNumber = getTextFieldValue(Event,'load_normalization_run_number_text_field')
NormalizationRunNumber = strcompress(NormalizationRunNumber)
isNeXusFound = 0                ;by default, NeXus not found

if (NormalizationRunNumber NE '') then begin ;normalization run number is not empty

;check if user wants archive dor all nexus runs
    if (~isArchivedNormNexusDesired(Event)) then begin ;get full list of Nexus

        LogBookText = '-> Retrieving full list of NORMALIZATION Run Number: ' +$
          NormalizationRunNumber
        text = getLogBookText(Event)
        if (text[0] EQ '') then begin
            putLogBookMessage, Event, LogBookText
        endif else begin
            putLogBookMessage, Event, LogBookText, Append=1
        endelse
        LogBookText += ' ..... ' + PROCESSING 
        putNormalizationLogBookMessage, Event, LogBookText

;indicate reading data with hourglass icon
        widget_control,/hourglass
        
        LogBookText = '----> Checking if at least one NeXus file can be found ..... '
        LogBookText += PROCESSING
        putLogBookMessage, Event, LogBookText, Append=1

;check if nexus exist and if it does, returns the full path

;get path to nexus run #
        instrument=(*global).instrument ;retrieve name of instrument
        full_list_of_nexus_name = find_list_nexus_name(Event,$
                                                       NormalizationRunNumber,$
                                                       instrument,$
                                                       isNeXusFound)
        
        if (~isNeXusFound) then begin ;no nexus found

;tells the user that the NeXus file has not been found
;get log book full text
            LogBookText = getLogBookText(Event)
            Message = 'FAILED - No NeXus can be found'
            putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING
;get data log book full text
            NormalizationLogBookText = getNormalizationLogBookText(Event)
            putTextAtEndOfNormalizationLogBookLastLine,$
              Event,$
              NormalizationLogBookText,$
              'NeXus run number does not exist!',$
              PROCESSING
            
            NbrNexus = 0
            
;no needs to do anything more

        endif else begin ;1 or more nexus have been found

;display list of nexus found if list is GT 1 otherwise proceed as
;before
            sz = (size(full_list_of_nexus_name))(1)
            NbrNexus = sz
            if (sz GT 1) then begin
;display list in droplist and map=1 base
                putArrayInDropList, $
                  Event, $
                  full_list_of_nexus_name, $
                  'normalization_list_nexus_droplist'
                
;map base
                MapBase, Event, 'norm_list_nexus_base', 1

;display info in log book
                LogBookText = getLogBookText(Event)        
                Message = 'OK'
                putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING
                LogText = '----> Found ' + strcompress(sz,/remove_all)
                LogText += ' NeXus files:'
                putLogBookMessage,Event, LogText,Append=1
                for i=0,(sz-1) do begin
                    text = '       ' + full_list_of_nexus_name[i]
                    putLogBookMessage, Event,text,Append=1
                endfor
                LogText = '----> Selecting one NeXus file from the list ..... ' $
                  + PROCESSING
                putLogBookMessage, Event, LogText, Append=1
                
;display info in normalization log book
                NormalizationLogBookText = getNormalizationLogBookText(Event)
                putTextAtEndOfNormalizationLogBookLastLine,$
                  Event,$
                  NormalizationLogBookText,$
                  'OK',$
                  PROCESSING
                text = ' --> Please select one of the ' + strcompress(sz,/remove_all)
                text += ' NeXus file found .....'
                putNormalizationLogBookMessage, Event, text, Append=1
                                
;display nxsummary of first file in 'data_list_nexus_base'
                RefReduction_NXsummary, $
                  Event, $
                  full_list_of_nexus_name[0], $
                  'normalization_list_nexus_nxsummary_text_field'


            endif else begin    ;proceed as before

                OpenNormNexusFile, Event, NormalizationRunNumber, full_list_of_nexus_name

            endelse             ;end of list is only 1 element long

        endelse                 ;end of nexus found

    endif else begin            ;we just want the archived one

        LogBookText = '-> Openning Archived NORMALIZATION Run Number: ' + NormalizationRunNumber
        text = getLogBookText(Event)
        if (text[0] EQ '') then begin
            putLogBookMessage, Event, LogBookText
        endif else begin
            putLogBookMessage, Event, LogBookText, Append=1
        endelse
        LogBookText += '..... ' + PROCESSING 
        putNormalizationLogBookMessage, Event, LogBookText

;indicate reading data with hourglass icon
        widget_control,/hourglass
        
        LogBookText = '----> Checking if NeXus run number exist ..... ' + PROCESSING
        putLogBookMessage, Event, LogBookText, Append=1
        
;check if nexus exist and if it does, returns the full path

;get path to nexus run #
        instrument=(*global).instrument ;retrieve name of instrument
        isNeXusFound = 0        ;by default, NeXus not found

        if (!VERSION.os EQ 'darwin') then begin
           full_nexus_name = (*global).MacNexusFile
           isNexusFound = 1
        endif else begin
           full_nexus_name = find_full_nexus_name(Event,$
                                                  NormalizationRunNumber,$
                                                  instrument,$
                                                  isNeXusFound)
        endelse

        if (~isNeXusFound) then begin ;NeXus has not been found
        
            NbrNexus = 0
;tells the user that the NeXus file has not been found
;get log book full text
            LogBookText = getLogBookText(Event)
            Message = 'FAILED - NeXus file does not exist'
            putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING

;get norm log book full text
            NormalizationLogBookText = getNormalizationLogBookText(Event)
            putTextAtEndOfNormalizationLogBookLastLine,$
              Event,$
              NormalizationLogBookText,$
              'NeXus does not exist!',$
              PROCESSING
            
;no needs to do anything more
            
        endif else begin        ;NeXus has been found
            
            NbrNexus = 1
            OpenNormNexusFile, Event, NormalizationRunNumber, full_nexus_name
            
        endelse
        
    endelse
    
endif                            ;end of if(NormalizationRunNumber Ne '')

(*global).NormNeXusFound = isNeXusFound
;update GUI according to result of NeXus found or not
RefReduction_update_normalization_gui_if_NeXus_found, Event, isNeXusFound

END



PRO OpenNormNeXusFile, Event, NormRunNumber, full_nexus_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

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
  0                             ;do not append

;tells the user that the NeXus file has been found
;get log book full text
LogBookText = getLogBookText(Event)
Message = 'OK  ' + '( Full Path is: ' + strcompress(full_nexus_name) + ')'
putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING

                                ;display info about nexus file selected
LogBookText = $
  '----> Displaying information about run number using nxsummary ..... ' + PROCESSING
putLogBookMessage, Event, LogBookText, Append=1
RefReduction_NXsummary, Event, full_nexus_name, 'normalization_file_info_text'
LogBookText = getLogBookText(Event)        
Message = 'OK'
putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING

IF (H5F_IS_HDF5(full_nexus_name)) THEN BEGIN

    (*global).isHDF5format = 1
    LogBookText = '----> Is format of NeXus hdf5 ? YES'
    putLogBookMessage, Event, LogBookText, Append=1
    
;dump binary data into local directory of user
    working_path = (*global).working_path
    LogBookText = '----> Dump binary data at this location: ' + working_path
    putLogBookMessage, Event, LogBookText, Append=1
    REFReduction_DumpBinaryNormalization, Event, full_nexus_name, working_path

    IF ((*global).isHDF5format) THEN BEGIN
;create name of BackgroundROIFile and put it in its box
    REFreduction_CreateDefaultNormBackgroundROIFileName, Event, $
      instrument, $
      working_path, $
      NormRunNumber
    ENDIF
ENDIF ELSE BEGIN

    (*global).isHDF5format = 0
    LogBookText = '---- Is format of NeXus hdf5 ? NO'
    putLogBookMessage, Event, LogBookText, Append=1
    LogBookText = ' !!! REFreduction does not support this file format. '
    LogBookText += 'Please use rebinNeXus to create a hdf5 nexus file !!!'
    putLogBookMessage, Event, LogBookText, Append=1

    ;tells the norm log book that the format is wrong
    InitialStrarr = getNormalizationLogBookText(Event)
    putTextAtEndOfNormalizationLogBookLastLine, $
      Event, $
      InitialStrarr, $
      (*global).failed, $
      PROCESSING

ENDELSE

END
