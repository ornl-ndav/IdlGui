FUNCTION BSSselection_GetNexusFullPath, Event, RunNumber, type, isNeXusExist
NexusFullPath = find_full_nexus_name(Event, RunNumber, isNeXusExist)
NeXusFullName = NexusFullPath[0]
RETURN, NeXusFullName
END



;This function is reached when the user enters a RunNumber and hits
;ENTER (REDUCE tab#1)
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



;This function is reached when the user updates the text field (remove
;a nexus full path for example) of REDUCE tab#1
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



;This function is reached when the user enters a Nexus filename (full
;path) and hits ENTER
;the program first checks if the file exist and if it does, add it to
;the list of runs.
PRO BSSselection_AddNexusFullPath, Event, type

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK = (*global).ok
FAILED = (*global).failed

uname = type + '_nexus_cw_field'
uname1 = type + '_list_of_runs_text'
NexusLoadedName = getTextFieldValue(Event, uname)

IF (NexusLoadedName NE '') THEN BEGIN

    uname_label = type + '_label'
    message1  = getLabelValue(event, uname_label)
    message = ' -> ' + message1 + ' :'
    AppendLogBookMessage, Event, message
    message = '    - Checking if following NeXus exists : ' + $
      strcompress(NexusLoadedName,/remove_all)
    AppendLogBookMessage, Event, message + ' ... ' + PROCESSING
        
    isNexusExist = CheckIfNexusExist(NexusLoadedName)

    IF (isNexusExist EQ 1) THEN BEGIN ;nexus exists

        putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;get current text in text_field
        CurrentText = getTextFieldValue(Event, uname1)
        IF (CurrentText EQ '') THEN BEGIN
            PutTextInTextField, Event, uname1, NexusLoadedName
        ENDIF ELSE BEGIN
            AppendTextInTextField, Event, uname1, ',' + NexusLoadedName
        ENDELSE

    ENDIF ELSE BEGIN ;nexus does not exist

        putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING

    ENDELSE

    newText = getTextFieldValue(Event, uname1)
    IF (newText EQ '') THEN BEGIN
        newText = 'N/A'
    ENDIF
    message = '    - List of files is : ' + newText
    AppendLogBookMessage, Event, message
    
ENDIF

;turn off hourglass
widget_control,hourglass=0

END





;This function is reached by the browse button of the first tab
PRO BSSselection_ReduceBrowseNexus, Event, type

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

uname = type + '_browse_nexus_button'
uname1 = type + '_list_of_runs_text'

CASE (type) OF
    'rsdf' : title1 = 'Raw Sample Data'
    'bdf'  : title1 = 'Background Data'
    'ndf'  : title1 = 'Normalization Data'
    'ecdf' : title1 = 'Empty Can Data'
    'aig'  : title1 = 'Alternate Instrument Geometry'
ENDCASE

;define ROI filter
nexus_ext = (*global).nexus_ext
filter = '*' + nexus_ext

;get default path
IF (type EQ 'aig') THEN BEGIN
    NeXusPath = (*global).nexus_geometry_path
ENDIF ELSE BEGIN
    NeXusPath = (*global).nexus_path
ENDELSE

title = 'Select a ' + title1 + ' NeXus File:'

;open Nexus file
NexusFullFileName = DIALOG_PICKFILE(PATH = NeXusPath,$
                                    TITLE = title,$
                                    FILTER = filter,$
                                    DEFAULT_EXTENSION = nexus_ext)

IF (NexusFullFileName NE '') THEN BEGIN

    uname_label = type + '_label'
    message1  = getLabelValue(event, uname_label)
    message = ' -> ' + message1 + ' :'
    AppendLogBookMessage, Event, message

;get current text in text_field
    CurrentText = getTextFieldValue(Event, uname1)
    IF (CurrentText EQ '') THEN BEGIN
        PutTextInTextField, Event, uname1, NexusFullFileName
    ENDIF ELSE BEGIN
        AppendTextInTextField, Event, uname1, ',' + NexusFullFileName
    ENDELSE
    
    newText = getTextFieldValue(Event, uname1)
    IF (newText EQ '') THEN BEGIN
        newText = 'N/A'
    ENDIF

    IF (type eq 'aig') THEN BEGIN
        message = '    - File is now : ' + newText
    ENDIF ELSE BEGIN
        message = '    - List of files is : ' + newText
    ENDELSE
    AppendLogBookMessage, Event, message

ENDIF ELSE BEGIN

ENDELSE

;turn off hourglass
widget_control,hourglass=0

END






;This function is reached by the browse button of the first tab
PRO BSSselection_ReduceBrowseRoi, Event

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

uname = 'proif_browse_nexus_button'
uname1 = 'proif_text'

;define ROI filter
roi_ext = (*global).roi_ext
filter = '*' + roi_ext
RoiPath = (*global).roi_path

title = 'Select a Region Of Interest File:'

;open ROI file
RoiFullFileName = DIALOG_PICKFILE(PATH = RoiPath,$
                                  TITLE = title,$
                                  FILTER = filter,$
                                  DEFAULT_EXTENSION = roi_ext)

IF (RoiFullFileName NE '') THEN BEGIN

    uname_label = 'proif_label'
    message1  = getLabelValue(event, uname_label)
    message = ' -> ' + message1 + ' :'
    AppendLogBookMessage, Event, message

;get current text in text_field
    CurrentText = getTextFieldValue(Event, uname1)
    IF (CurrentText EQ '') THEN BEGIN
        PutTextInTextField, Event, uname1, RoiFullFileName
    ENDIF ELSE BEGIN
        AppendTextInTextField, Event, uname1, ',' + RoiFullFileName
    ENDELSE
    
    newText = getTextFieldValue(Event, uname1)
    IF (newText EQ '') THEN BEGIN
        newText = 'N/A'
    ENDIF
    message = '    - File is now : ' + newText
    AppendLogBookMessage, Event, message

ENDIF ELSE BEGIN

ENDELSE

;turn off hourglass
widget_control,hourglass=0

END
