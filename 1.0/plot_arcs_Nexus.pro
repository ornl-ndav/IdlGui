PRO RetrieveFullNexusFileName, Event ;_Nexus.pro
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

;indicate initialization with hourglass icon
widget_control,/hourglass

LogText = '> Looking for NeXus file:'
AppendLogBook, Event, LogText
;get Proposal Number (if any)
Proposal = getSelectedProposal(Event)
IF (Proposal EQ '') THEN BEGIN
    message_proposal = 'N/A'
ENDIF ELSE BEGIN
    message_proposal = proposal
ENDELSE
LogText = 'Proposal   : ' + message_proposal
AppendLogBook, Event, LogText
;get Run Number
RunNumber = getTextFieldValue(Event,'run_number_cw_field')
LogText = 'Run Number : ' + STRCOMPRESS(RunNumber,/REMOVE_ALL)
AppendLogBook, Event, LogText
;Archived or not
archivedFlag = isArchived(Event)
LogText = 'Archived   : '
IF (archivedFlag) THEN BEGIN
    LogText += 'YES'
ENDIF ELSE BEGIN
    LogText += 'NO'
ENDELSE
AppendLogBook, Event, LogText

;Build status message
status_message = 'Looking for '
IF (archivedFlag) THEN BEGIN
    status_message += 'Archived '
ENDIF ELSE BEGIN
    status_message += 'Full List of '
ENDELSE
status_message += 'NeXus '
IF (archivedFlag) THEN BEGIN
    status_message += 'file '
ENDIF ELSE BEGIN
    status_message += 'files '
ENDELSE
status_message += 'of Run Number ' + STRCOMPRESS(RunNumber,/REMOVE_ALL)
IF (Proposal EQ '') THEN BEGIN
    status_message += ' in All Proposals' 
ENDIF ELSE BEGIN
    status_message += ' in Proposal ' + Proposal
ENDELSE
status_message += ' ... ' + PROCESSING
putStatus, Event, status_message
AppendLogBook, Event, status_message

nexusInstance = OBJ_NEW('IDLnexusUtilities',$
                        RunNumber,$ 
                        PROPOSAL   = Proposal,$
                        instrument = 'ARCS')

IF(archivedFlag) THEN BEGIN
    NexusFileName = nexusInstance->getArchivedNexusPath()
ENDIF ELSE BEGIN
    NexusFileName = nexusInstance->getFullListNexusPath()
ENDELSE

IF (nexusInstance->isNexusExist()) THEN BEGIN
    putTextAtEndOfLogBook, Event, OK, PROCESSING
    putTextAtEndOfStatus,  Event, OK, PROCESSING
;Show the archived and list_all base
    ShowArchivedListAllBase, Event
    IF (archivedFlag) THEN BEGIN
        putArchivedNexusFileName, Event, NexusFileName
;Activate archived base and desactivate list_all base
        ActivateArchivedBase, Event
    ENDIF ELSE BEGIN
;check how many nexus we found
        sz = (size(NexusFileName))(1)
        message = 'Found ' + STRCOMPRESS(sz,/REMOVE_ALL)
        IF (sz GT 1) THEN BEGIN
            message += ' NeXus files'
            AppendLogBook, Event, message
            AppendLogBook, Event, NexusFileName
            putListAllDroplistValue, Event, NexusFileName
;Activate List_all and desactivate archived base
            ActivateListAllBase, Event
        ENDIF ELSE BEGIN
            message += ' NeXus file: ' + NexusFileName[0]
            AppendLogBook, Event, message
            putArchivedNexusFileName, Event, NexusFileName[0]
;Activate archived base and desactivate list_all base
            ActivateArchivedBase, Event
        ENDELSE
    ENDELSE
;Show the nxsummary base
    ActivatePreviewBase, Event, 1
ENDIF ELSE BEGIN
    putTextAtEndOfLogBook, Event, FAILED, PROCESSING
    putTextAtEndOfStatus,  Event, FAILED, PROCESSING
    NexusName = 'N/A'
;Hide the archived and list_all base
    HideArchivedListAllBase, Event
;Hide the nxsummary base
    ActivatePreviewBase, Event, 0
ENDELSE





;turn off hourglass
widget_control,hourglass=0
END
