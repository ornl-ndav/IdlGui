PRO InputRunNumber, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;clear log_book and status message
putStatus, Event, ''
putLogBook, Event, ''

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

;get Run Number
RunNumber = getEventRunNumber(Event)

message = 'Looking for folder with run number ' + RunNumber + ' ... ' + PROCESSING
putLogBook, Event, message
putStatus, Event, message
runFullPath = ''
IF (getRunPath(Event, RunNumber, runFullPath)) THEN BEGIN
    putTextAtEndOfLogBook, Event, OK, PROCESSING
    putTextAtEndOfStatus, Event, OK, PROCESSING
    message = ' -> full path to prenexus file is: ' + runFullPath
    appendLogBook, Event, message
    event_file = '/ARCS_' + RunNumber + (*global).neutron_event_dat_ext
    full_event_file = runFullPath + event_file
    message    = ' -> Looking for event_file ' + $
      full_event_file + ' ... ' + PROCESSING
    appendLogBook, Event, message
    putStatus, Event, message
    IF (FILE_TEST(full_event_file)) THEN BEGIN
        putTextAtEndOfLogBook, Event, OK, PROCESSING
        putTextAtEndOfStatus, Event, OK, PROCESSING
;display name of event file name in event file widget_text
        putTextInTextField, Event, 'event_file', full_event_file
;determine full name of runinfo file name
        runinfoFileName = runFullPath + '/ARCS_' + RunNumber + '_runinfo.xml'
        (*global).runinfoFileName = runinfoFileName
    ENDIF ELSE BEGIN
        putTextAtEndOfLogBook, Event, FAILED, PROCESSING
        putTextAtEndOfStatus, Event, FAILED, PROCESSING
;display name of event file name in event file widget_text
        putTextInTextField, Event, 'event_file', ''
;reset name of runinfo file name
        (*global).runinfoFileName = ''
    ENDELSE
ENDIF ELSE BEGIN
    putTextAtEndOfLogBook, Event, FAILED, PROCESSING
    message = ' -> prenexus folder can not be located'
    appendLogBook, Event, message
    putTextAtEndOfStatus, Event, FAILED, PROCESSING
    putTextInTextField, Event, 'event_file', ''
;reset name of runinfo file name
    (*global).runinfoFileName = ''
ENDELSE

;clear histo_mapped text box
putTextInTextField, Event, 'histo_mapped_text_field', ''

END
