;this function is going to retrive the data from bank1 and bank2
;and save them in (*(*global).bank1) and (*(*global).bank2)
PRO retrieveBanksData, Event, FullNexusName

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

fileID  = h5f_open(FullNexusName)
;get bank1 data
fieldID = h5d_open(fileID,(*global).nexus_bank1_path)
(*(*global).bank1) = h5d_read(fieldID)


;get bank2 data
fieldID = h5d_open(fileID,(*global).nexus_bank2_path)
(*(*global).bank2) = h5d_read(fieldID)

END




PRO bss_selection_LoadNexus, Event

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK = (*global).ok
FAILED = (*global).failed

isNeXusExist = 0 ;by default, NeXus does not exist

;get run number
RunNumber = getRunNumber(Event)

IF (RunNumber NE '') THEN BEGIN ;continue only if there is a run number

    message = 'Loading run number ' + strcompress(RunNumber,/remove_all) + ':'
    PutLogBookMessage, Event, message
    message = '  -> Checking if run number exists ... ' + PROCESSING
    AppendLogBookMessage, Event, message
    
    NexusFullPath = find_full_nexus_name(Event, RunNumber, isNeXusExist)
    
    IF (isNexusExist) THEN BEGIN

        putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
;move on to step2 of loading nexus
        BSSselection_LoadNexus_step2, Event, NexusFullPath[0]
        
    ENDIF ELSE BEGIN         ;tells that we didn't find the nexus file
        
;display full name of nexus in his label
        PutNexusNameInLabel, Event, 'N/A'
        putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
        
    ENDELSE
    
ENDIF

(*global).NeXusFound = isNexusExist

;turn off hourglass
widget_control,hourglass=0

END
