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

;------------------------------------------------------------------------------

PRO load_live_nexus, Event, full_nexus_file_name, RunNumber

;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

message = '-> Loading Run Number ' + strcompress(RunNumber,/remove_all) + ':'
InitialLogBookMessage = getLogBookText(Event)
AppendLogBookMessage, Event, message

text = 'Loading Run Number ' + STRCOMPRESS(RunNumber,/REMOVE_ALL)
text += ' ... ' + PROCESSING
putMessageBoxInfo, Event, text

;initialize pixeld_excluded
(*(*global).pixel_excluded) = (*(*global).default_pixel_excluded)

(*global).RunNumber = RunNumber
(*global).Configuration.Input.nexus_run_number = RunNumber
        
;putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;move on to step2 of loading nexus
load_live_nexus_step2, Event, full_nexus_file_name
(*global).NexusFullName = full_nexus_file_name

IF (N_ELEMENTS(config) EQ 0) THEN BEGIN
    
;put nexus file name in data text field (Reduce tab#1)
    putReduceRawSampleDatafile, Event, full_nexus_file_name
    
ENDIF

(*global).NeXusFound = 1

END

;------------------------------------------------------------------------------

PRO load_live_nexus_step2, Event, NexusFullName

;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

message = '  -> NeXus file location: ' + NexusFullName
AppendLogBookMessage, Event, message

;retrieve bank1 and bank2
message = '  -> Retrieving bank1 and bank2 data ... ' + PROCESSING
AppendLogBookMessage, Event, message

;check if file is hdf5
nexus_file_name = sTRCOMPRESS(NeXusFullName,/REMOVE_ALL)
IF (H5F_IS_HDF5(nexus_file_name)) THEN BEGIN
   
    retrieveBanksData, Event, strcompress(NexusFullName,/remove_all)
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
;plot bank1 and bank2
    message = '  -> Plot bank1 and bank2 ... ' + PROCESSING
    AppendLogBookMessage, Event, message
    success = 0
    bss_reduction_PlotBanks, Event, success
ENDIF ELSE BEGIN
    success = 0
ENDELSE

IF (success EQ 0) THEN BEGIN

    putTextAtEndOfLogBookLastLine, Event, FAILED + $
      ' --> Wrong NeXus Format!', PROCESSING
    (*global).NeXusFound = 0
    (*global).NexusFormatWrong = 1 ;wrong format
;desactivate button
    activate_status = 0

    text = 'Loading Run Number ' + STRCOMPRESS((*global).RunNumber,/REMOVE_ALL)
    text += ' ... FAILED'
    putMessageBoxInfo, Event, text

ENDIF ELSE BEGIN

    (*global).NexusFormatWrong = 0 ;right format
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;plot counts vs TOF of full selection
    message = '  -> Plot Counts vs TOF of full selection ... ' + PROCESSING
    AppendLogBookMessage, Event, message

    IF ((*global).true_full_x_min EQ 0.0000001) THEN BEGIN
        BSSreduction_PlotCountsVsTofOfSelection, Event
    ENDIF ELSE BEGIN
        BSSreduction_PlotCountsVsTofOfSelection_Light, Event
        BSSreduction_DisplayLinLogFullCountsVsTof, Event
    ENDELSE

    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;populate ROI file name
    BSSreduction_CreateRoiFileName, Event

;plot ROI
    PlotIncludedPixels, Event

;activate button
    activate_status = 1
    
    text = 'Loading Run Number ' + STRCOMPRESS((*global).RunNumber,/REMOVE_ALL)
    text += ' ... OK'
    putMessageBoxInfo, Event, text

ENDELSE

;activate or not 'save_roi_file_button', 'roi_path_button',
;'roi_file_name_generator', 'load_roi_file_button'
ActivateArray = (*(*global).WidgetsToActivate)
sz = (size(ActivateArray))(1)
FOR i=0,(sz-1) DO BEGIN
    activate_button, event, ActivateArray[i], activate_status
ENDFOR

END    
