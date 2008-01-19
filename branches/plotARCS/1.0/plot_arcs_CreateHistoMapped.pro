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
IF (FILE_TEST(staging_folder,/directory)) THEN BEGIN
;;yes 
    appendLogBook, Event, '--> Staging folder exists ? ... YES'
;;then clear contain
    cmd_clear = 'rm -rf *.dat ' + staging_folder
    appendLogBook, Event, '--> Clear contain :'
    cmd = '---> ' + cmd_clear + ' ... ' + PROCESSING
    appendLogBook, Event, cmd
    spawn, cmd, listening, err_listening
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
    apppendLogBook, Event, '--> Create staging folder'
    cmd_create = 'mkdir ' + staging_folder
    cmd = '---> ' + cmd_create + ' ... ' + PROCESSING
    appendLogBook, Event, cmd
    spawn, cmd_create, listening, err_listening
    IF (err_listening[0] EQ '') THEN BEGIN
        putTextAtEndOfLogBook, Event, OK, PROCESSING
    ENDIF ELSE BEGIN
        putTextAtEndOfLogBook, Event, FAILED, PROCESSIN
        ERROR = 1
    ENDELSE
ENDELSE ;endelse of if(file_test(staging_folder))

;start histogram command
cmd = ''

;name of histo mapped file
histo_mapped_file = getHistoMappedFileName(event_file_full_name)
appendLogBook, Event, '-> Output file:'
appendLogBook, Event, '--> histo_mapped_file : ' + histo_mapped_file
IF (ERROR EQ 0 AND $
    FILE_TEST(histo_mapped_file)) THEN BEGIN
    appendLogBook, Event, '---> Is histo_mapped_file located ... YES'
;display name of histo_mapped file in text_field
    putTextInTextField, Event, 'histo_mapped_text_field', histo_mapped_file
    appendLogBook, Event, '**** PLOT BUTTON HAS BEEN VALIDATED ****'
ENDIF ELSE BEGIN
    appendLogBook, Event, '---> Is histo_mapped_file located ... NO'
    putTextInTextField, Event, 'histo_mapped_text_field', ''
    appendLogBook, Event, '**** PLOT BUTTON CAN NOT BE VALIDATED ****'
ENDELSE

;enable or not PLOT BUTTON
ActivateOrNotPlotButton, Event

END
