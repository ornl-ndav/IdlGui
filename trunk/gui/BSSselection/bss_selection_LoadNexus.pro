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

    IF (isNeXusExist) THEN BEGIN ;continue only if the nexus file has been found

;display full name of nexus in his label
        PutNexusNameInLabel, Event, NexusFullPath[0]

        putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
        message = '  -> NeXus file location: ' + NexusFullPath
        AppendLogBookMessage, Event, message

;retrieve bank1 and bank2
        message = '  -> Retrieving bank1 and bank2 data ... ' + PROCESSING
        AppendLogBookMessage, Event, message
        retrieveBanksData, Event, strcompress(NexusFullPath[0],/remove_all)
        putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;plot bank1 and bank2
        message = '  -> Plot bank1 and bank2 ... ' + PROCESSING
        AppendLogBookMessage, Event, message

        success = 0
        bss_selection_PlotBanks, Event, success

        if (success EQ 0) then begin
            putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
        endif else begin
            putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
        endelse

    ENDIF ELSE BEGIN ;tells that we didn't find the nexus file

;display full name of nexus in his label
        PutNexusNameInLabel, Event, 'N/A'

        putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING

    ENDELSE

ENDIF

;turn off hourglass
widget_control,hourglass=0

END
