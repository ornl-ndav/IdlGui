PRO BSSreduction_LoadNexus_step2, Event, NexusFullName

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK = (*global).ok
FAILED = (*global).failed

;display full name of nexus in his label
PutNexusNameInLabel, Event, NexusFullName

message = '  -> NeXus file location: ' + NexusFullName
AppendLogBookMessage, Event, message

;retrieve bank1 and bank2
message = '  -> Retrieving bank1 and bank2 data ... ' + PROCESSING
AppendLogBookMessage, Event, message

;check if file is hdf5
nexus_file_name = strcompress(NeXusFullName,/remove_all)
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
