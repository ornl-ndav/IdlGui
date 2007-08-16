;this function load the given nexus file and dump the binary file
;in the tmp norm file
PRO REFreduction_LoadNormalizationfile, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing_message ;processing message

;get Data Run Number from DataTextField
NormalizationRunNumber = getTextFieldValue(Event,'load_normalization_run_number_text_field')
LogBookText = '-> Openning NORMALIZATION Run Number: ' + NormalizationRunNumber
putLogBookMessage, Event, LogBookText
LogBookText += '.....' + PROCESSING
putNormalizationLogBookMessage, Event, LogBookText

if (NormalizationRunNumber EQ '') then begin ;Run number field is empty

;this should never be reached because the program will only enable the
;switch if a valid number is in the Text Field

endif else begin

;indicate reading data with hourglass icon
    widget_control,/hourglass

    LogBookText = '----> Checking if NeXus run number exist........'
    putLogBookMessage, Event, LogBookText, Append=1

;check if nexus exist and if it does, returns the full path
        
;get path to nexus run #
    instrument=(*global).instrument ;retrieve name of instrument
    isNeXusFound = 0 ;by default, NeXus not found
    full_nexus_name = find_full_nexus_name(Event,$
                                           NormalizationRunNumber,$
                                           instrument,$
                                           isNeXusFound)
    
    if (~isNeXusFound) then begin ;NeXus has not been found

;tells the user that the NeXus file has not been found
;get log book full text
        LogBookText = getLogBookText(Event)
        Message = 'FAILED - NeXus file does not exist'
        putTextAtEndOfLogBookLastLine, Event, LogBookText, Message
;get data log book full text
        NormalizationLogBookText = getNormalizationLogBookText(Event)
        putTextAtEndOfNormalizationLogBookLastLine,$
          Event,$
          NormalizationLogBookText,$
          'NeXus does not exist!',$
          PROCESSING
        
;no needs to do anything more
        
    endif else begin            ;NeXus has been found

;store run number of normalization file
        (*global).norm_run_number = NormalizationRunNumber
        
;tells the user that the NeXus file has been found
;get log book full text
        LogBookText = getLogBookText(Event)
        Message = 'OK  ' + '( Full Path is: ' + strcompress(full_nexus_name) + ')'
        putTextAtEndOfLogBookLastLine, Event, LogBookText, Message

;continue here by displaying the info required by the instrument
;proton charge and distances
;;;;populate_distance_labels, event, full_nexus_name
;;;;populate_proton_charge, event, full_nexus_name
        
;dump binary data into local directory of user
        working_path = (*global).working_path
        LogBookText = '----> Dump binary data at this location: ' + working_path
        putLogBookMessage, Event, LogBookText, Append=1
        RefReduction_DumpBinaryNormalization, Event, full_nexus_name, working_path
        
      endelse                     ;end of ~isNeXusFound

    
endelse                         ;end of DataRunNumber NE ''



END
