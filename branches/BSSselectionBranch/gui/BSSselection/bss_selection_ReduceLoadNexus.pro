FUNCTION BSSselection_GetNexusFullPath, Event, RunNumber, type, isNeXusExist

NexusFullPath = find_full_nexus_name(Event, RunNumber, isNeXusExist)
NeXusFullName = NexusFullPath[0]

RETURN, NeXusFullName
END


PRO BSSselection_NexusFullPath, Event, type

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK = (*global).ok
FAILED = (*global).failed

;run number we want
RunNumber = strcompress(getReduceRunNumber(Event, type),/remove_all)

IF (RunNumber NE '') THEN BEGIN
    
    CASE (type) OF
        'rsdf': uname = 'rsdf_list_of_runs_text'
        'bdf' : uname = 'bdf_list_of_runs_text'
        'ndf' : uname = 'ndf_list_of_runs_text'
        'ecdf': uname = 'ecdf_list_of_runs_text'
    ENDCASE
    
;name of file from Reduce Gui Tab
    uname_label = type + '_label'
    message1  = getLabelValue(event, uname_label)
    message = ' -> ' + message1 + ' :'
    AppendLogBookMessage, Event, message
    message = '    - Searching for run number : ' + RunNumber + ' ... ' + PROCESSING
    AppendLogBookMessage, Event, message
    
;searching for nexus file
    isNeXusExist = 0            ;by default, nexus file does not exist
    NeXusFullName = BSSselection_GetNexusFullPath(Event, RunNumber, type, isNeXusExist)
    
    IF (isNeXusExist EQ 1) THEN BEGIN
        
        putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
        
;get current text in text_field
        CurrentText = getTextFieldValue(Event, uname)
        IF (CurrentText EQ '') THEN BEGIN
            PutTextInTextField, Event, uname, NeXusFullName
        ENDIF ELSE BEGIN
            AppendTextInTextField, Event, uname, ',' + NeXusFullName
        ENDELSE
        
    ENDIF ELSE BEGIN
        
        putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
        
    ENDELSE
    
    newText = getTextFieldValue(Event, uname)
    IF (newText EQ '') THEN BEGIN
        newText = 'N/A'
    ENDIF
    message = '    - List of files is : ' + newText
    AppendLogBookMessage, Event, message

ENDIF  ;end of if(RunNumbr NE '')
    
;turn off hourglass
widget_control,hourglass=0

END




PRO BSSselection_UpdateListOfNexus, Event, type

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

CASE (type) OF
    'rsdf': uname = 'rsdf_list_of_runs_text'
    'bdf' : uname = 'bdf_list_of_runs_text'
    'ndf' : uname = 'ndf_list_of_runs_text'
    'ecdf': uname = 'ecdf_list_of_runs_text'
ENDCASE

ListOfNexus = getTextFieldValue(Event, uname)

;name of file from Reduce Gui Tab
uname_label = type + '_label'
message1  = getLabelValue(event, uname_label)
message = ' -> ' + message1 + ' :'
AppendLogBookMessage, Event, message

message = '    - List of files has been updated'
AppendLogBookMessage, Event, message

IF (ListOfNexus EQ '') THEN BEGIN
    ListOFNexus = 'N/A'
ENDIF
message = '    - List of files is now : ' + ListOfNexus
AppendLogBookMessage, Event, message

;turn off hourglass
widget_control,hourglass=0

END
