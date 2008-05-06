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




PRO bss_reduction_LoadNexus, Event, config

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
RunNumber           = getRunNumber(Event)
(*global).RunNumber = RunNumber

IF (RunNumber NE '') THEN BEGIN ;continue only if there is a run number

    message = 'Loading Run Number ' + strcompress(RunNumber,/remove_all) + ':'
    InitialLogBookMessage = getLogBookText(Event)
    IF (InitialLogBookMessage[0] EQ '') THEN BEGIN
        PutLogBookMessage, Event, message
    ENDIF ELSE BEGIN
        AppendLogBookMessage, Event, message
    ENDELSE

    text = 'Loading Run Number ' + STRCOMPRESS(RunNumber,/REMOVE_ALL)
    text += ' ... (' + PROCESSING + ')'
    putMessageBoxInfo, Event, text

    message = '  -> Checking if run number exists ... ' + PROCESSING
    AppendLogBookMessage, Event, message
    
    if (!VERSION.os EQ 'darwin') then begin
        NexusFullPath = (*global).nexus_full_path
        isNeXusExist = 1
    endif else begin
        NexusFullPath = find_full_nexus_name(Event, RunNumber, isNeXusExist)
    endelse

    IF (isNexusExist) THEN BEGIN
        
;initialize pixeld_excluded
        (*(*global).pixel_excluded) = (*(*global).default_pixel_excluded)

        (*global).RunNumber = RunNumber
        (*global).Configuration.Input.nexus_run_number = RunNumber
        
        putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;move on to step2 of loading nexus
        BSSreduction_LoadNexus_step2, Event, NexusFullPath[0]

        NexusFullName = strcompress(NexusFullPath[0],/remove_all)
        (*global).NexusFullName = NexusFullName

        IF (N_ELEMENTS(config) EQ 0) THEN BEGIN

;put nexus file name in data text field (Reduce tab#1)
            putReduceRawSampleDatafile, Event, NexusFullName

        ENDIF

    ENDIF ELSE BEGIN         ;tells that we didn't find the nexus file
        
;display full name of nexus in his label
        PutNexusNameInLabel, Event, 'N/A'
        putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
        
        text = 'Loading Run Number ' + STRCOMPRESS(RunNumber,/REMOVE_ALL)
        text += ' ... FAILED'
        putMessageBoxInfo, Event, text

    ENDELSE
    
ENDIF

(*global).NeXusFound = isNexusExist

;turn off hourglass
widget_control,hourglass=0

END
