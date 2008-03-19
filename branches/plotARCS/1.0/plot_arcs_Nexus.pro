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
LogText = 'Proposal   : ' + Proposal
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

ENDIF ELSE BEGIN

ENDELSE

IF (nexusInstance->isNexusExist()) THEN BEGIN
    IF (archivedFlag) THEN BEGIN
        NexusFileName = nexusInstance->getArchivedNexusPath()
        putTextAtEndOfLogBook, Event, OK, PROCESSING
        putTextAtEndOfStatus, Event, OK, PROCESSING
        putArchivedNexusFileName, Event, NexusFileName
    ENDIF ELSE BEGIN
        NexusFileName = nexusInstance->getFullListNexusPath()
    ENDELSE
ENDIF ELSE BEGIN
    putTextAtEndOfLogBook, Event, FAILED, PROCESSING
    putTextAtEndOfStatus, Event, FAILED, PROCESSING
    NexusName = 'N/A'
ENDELSE





;turn off hourglass
widget_control,hourglass=0
END
