;This function is reached when the user launches a data reduction
;The program checks the contain of the data run numbers and replace
;them by the full nexus path (if this run number can be found)
PRO ReplaceDataRunNumbersByFullPath, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing_message
FAILED     = (*global).failed

;inform user of what is going on here
message = '-> Replacing Data Run Numbers by NeXus Full Path:'
putLogBookMessage, Event, message, Append=1

data_run_numbers = getTextFieldValue(Event, 'reduce_data_runs_text_field')

;parse first by ','
RunNumbersArray    = strsplit(data_run_numbers,',',/EXTRACT)
sz = (size(RunNumbersArray))(1)
NexusFullPathArray = strarr(sz)
FOR i=0,(sz-1) DO BEGIN
    ;check that this is not a full nexus path name already
    checkParse = strsplit(RunNumbersArray[i],'/',/EXTRACT,COUNT=nbr)
    IF (nbr EQ 1) THEN BEGIN
        message = '--> Run ' + strcompress(RunNumbersArray[i],/REMOVE_ALL)
        message += ' ==> ' + PROCESSING 
        putLogBookMessage, Event, message, Append=1

        isNexusExist = 0
        full_nexus_name = find_full_nexus_name(Event, $
                                               RunNumbersArray[i],$
                                               (*global).instrument,$
                                               isNexusExist)
        IF (isNexusExist) THEN BEGIN
            AppendReplaceLogBookMessage, Event, full_nexus_name, processing
            NexusFullPathArray[i]=full_nexus_name
        ENDIF ELSE BEGIN
            AppendReplaceLogBookMessage, Event, failed, processing
            NexusFullPathArray[i]=''
        ENDELSE
            
    ENDIF ELSE BEGIN
        NeXusFullPathArray[i]=RunNumbersArray[i]
    ENDELSE
ENDFOR

;replace list of runs by nexus that have been found
first_nexus_of_list = 1
nexus_list = ''
FOR j=0,(sz-1) DO BEGIN
    IF (NeXusFullPathArray[j] NE '') THEN BEGIN
        IF (first_nexus_of_list) THEN BEGIN
            nexus_list = NeXusFullPathArray[j]
            first_nexus_of_list = 0
        ENDIF ELSE BEGIN
            nexus_list += ' ' + NexusFullPathArray[j]
        ENDELSE
    ENDIF
ENDFOR
putTextFieldvalue, Event, 'reduce_data_runs_text_field', nexus_list, 0

END






;This function is reached when the user launches a data reduction
;The program checks the contain of the norm run numbers and replace
;them by the full nexus path (if this run number can be found)
PRO ReplaceNormRunNumbersByFullPath, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing_message
FAILED     = (*global).failed

;inform user of what is going on here
message = '-> Replacing Norm Run Numbers by NeXus Full Path:'
putLogBookMessage, Event, message, Append=1

norm_run_numbers = getTextFieldValue(Event, 'reduce_normalization_runs_text_field')

;parse first by ','
RunNumbersArray    = strsplit(norm_run_numbers,',',/EXTRACT)
sz = (size(RunNumbersArray))(1)
NexusFullPathArray = strarr(sz)
FOR i=0,(sz-1) DO BEGIN
    ;check that this is not a full nexus path name already
    checkParse = strsplit(RunNumbersArray[i],'/',/EXTRACT,COUNT=nbr)
    IF (nbr EQ 1) THEN BEGIN
        message = '--> Run ' + strcompress(RunNumbersArray[i],/REMOVE_ALL)
        message += ' ==> ' + PROCESSING
        putLogBookMessage, Event, message, Append=1

        isNexusExist = 0
        full_nexus_name = find_full_nexus_name(Event, $
                                               RunNumbersArray[i],$
                                               (*global).instrument,$
                                               isNexusExist)
        IF (isNexusExist) THEN BEGIN
            AppendReplaceLogBookMessage, Event, full_nexus_name, processing
            NexusFullPathArray[i]=full_nexus_name
        ENDIF ELSE BEGIN
            AppendReplaceLogBookMessage, Event, failed, processing
            NexusFullPathArray[i]=''
        ENDELSE
            
    ENDIF ELSE BEGIN
        NeXusFullPathArray[i]=RunNumbersArray[i]
    ENDELSE
ENDFOR

;replace list of runs by nexus that have been found
first_nexus_of_list = 1
nexus_list = ''
FOR j=0,(sz-1) DO BEGIN
    IF (NeXusFullPathArray[j] NE '') THEN BEGIN
        IF (first_nexus_of_list) THEN BEGIN
            nexus_list = NeXusFullPathArray[j]
            first_nexus_of_list = 0
        ENDIF ELSE BEGIN
            nexus_list += ',' + NexusFullPathArray[j]
        ENDELSE
    ENDIF
ENDFOR
putTextFieldvalue, Event, 'reduce_normalization_runs_text_field', nexus_list, 0

END
