PRO CreateHistoMapped, Event
ERROR = 0 ;by default, everything works
appendLogBook, Event, '> Create Histo Mapped file:
appendLogBook, Event, '-> Files used:'
;retrieve event file full name
event_file_full_name = getEventFile(Event)
appendLogBook, Event, '--> event_file_full_name  : ' + event_file_full_name
;retrieve mapping file full name
mapping_file_full_name = getMappingFile(Event)
appendLogBook, Event, '--> mapping_file_full_name: ' + mapping_file_full_name
;retrieve histo parameters
appendLogBook, Event, '-> Histogram parameters:'
;;min time bin (if any)
min_time_bin = getTextFieldValue(Event,'min_time_bin')
appendLogBook, Event, '--> min_time_bin : ' + min_time_bin
;;max time bin
max_time_bin = getTextFieldValue(Event,'max_time_bin')
appendLogBook, Event, '--> max_time_bin : ' + max_time_bin
;;bin width
bin_width    = getTextFieldValue(Event,'bin_width')
appendLogBook, Event, '--> bin_width    : ' + bin_width
;;bin type
IF (getHistogramType(Event) EQ 0) THEN BEGIN
    bin_type = 'linear'
ENDIF ELSE BEGIN
    bin_type = 'log'
ENDELSE
appendLogBook, Event, '--> bin_type    : ' + bin_type
;get staging folder 
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

staging_folder = (*global).staging_folder
appendLogBook, Event, '-> Staging folder : ' + staging_folder
;check if staging folder exists
IF (FILE_TEST(staging_fodler,/directory)) THEN BEGIN
;;yes 
    appendLogBook, Event, '--> Staging folder exists ? ... YES'
;;then clear contain
    cmd_clear = 'rm -rf *.dat ' + staging_folder
    apppendLogBook, Event, '--> Clear contain :'
    cmd = '> ' + cmd_clear + ' ... ' + PROCESSING
    spawn, cmd, listening, err_listening
    appendLogBook, Event, cmd
    IF (err_listening[0] EQ '') THEN BEGIN
        putTextAtEndOfLogBook, Event, OK, PROCESSING
    ENDIF ELSE BEGIN
        putTextAtEndOfLogBook, Event, FAILED, PROCESSIN
        ERROR = 1
    ENDELSE
ENDIF ELSE BEGIN
;;no 
    appendLogBook, Event, '--> Staging folder exists ? ... NO'
;;create it
ENDELSE
END
