FUNCTION CreateStagingArea, Event, $
                            stagingArea, $
                            PROCESSING,$
                            FAILED,$
                            OK

error_status = 0
AppendMyLogBook, Event, '-> Checking if staging folder (' + stagingArea + ') exists:'
IF (FILE_TEST(stagingArea,/DIRECTORY)) THEN BEGIN
    AppendMyLogBook, Event, '--> Folder exists and needs to be cleaned up'
    cmd = 'rm ' + stagingArea + '/*.* -f '
    cmd_text = '   cmd: ' + cmd
    AppendMyLogBook, Event, cmd_text + ' ... ' + PROCESSING
    spawn, cmd, listening_rm, error_rm
    IF (error_rm[0] NE '') THEN BEGIN
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        error_status = 1
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, OK, PROCESSING
    ENDELSE
ENDIF ELSE BEGIN
    AppendMyLogBook, Event, '--> Folder does not exist and needs to be created'
    cmd = 'mkdir ' + stagingArea
    cmd_text = '   cmd: ' + cmd
    AppendMyLogBook, Event, cmd_text + ' ... ' + PROCESSING
    spawn, cmd, listening_rm, error_mk
    IF (error_mk[0] NE '') THEN BEGIN
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        error_status = 1
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, OK, PROCESSING
    ENDELSE
ENDELSE
AppendMyLogBook, Event, ''

RETURN, error_status
END




FUNCTION RunmpFlags, Event, $
                     instrument, $
                     processing,$
                     failed,$
                     ok,$
                     stagingArea,$
                     base_file_name,$
                     Nbrsteps,$
                     mapping_file,$
                     file_array

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
error_status = 0

message = '>(1/'+NbrSteps+') Creating Histo. Mapped Files .............. ' + processing
appendLogBook, Event, message
cmd = 'runmp_flags ' + base_file_name + ' -a ' + stagingArea
;get mapping file
IF ((*global).hostname eq (*global).MacHostName) THEN BEGIN
   mapping_file     = (*global).debugMapFileName
ENDIF ELSE BEGIN
   file_array = get_up_to_date_geo_tran_map_file(instrument)
   mapping_file     = file_array[2]
ENDELSE
cmd += ' -m ' + mapping_file
cmd_text = 'PHASE 1/' + Nbrsteps + ': CREATE HISTOGRAM'
AppendMyLogBook, Event, cmd_text
cmd_text = '> Creating Histo Mapped Files: '
AppendMyLogBook, Event, cmd_text
cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
AppendMyLogBook, Event, cmd_text
spawn, cmd, listening, err_listening
IF (err_listening[0] NE '') THEN BEGIN
   putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
   AppendMyLogBook, Event, err_listening
   error_status = 1
   putTextAtEndOfLogBook, Event, FAILED, PROCESSING
ENDIF ELSE BEGIN
   putTextAtEndOfMyLogBook, Event, OK, PROCESSING
   putTextAtEndOfLogBook, Event, OK, PROCESSING
ENDELSE

RETURN, error_status
END



FUNCTION CopyPreNexus, Event,$
                       processing, $
                       ok,$
                       failed,$
                       NbrSteps,$
                       stagingArea,$
                       prenexus_path

error_status = 0
message = '>(2/'+NbrSteps+') Importing staging files ................... ' + processing
appendLogBook, Event, message
appendMyLogBook, Event, ''
AppendMyLogBook, Event, 'PHASE 2/' + NbrSteps + ': IMPORT FILES'
;importing beamtime and cvlist
cmd = 'cp ' + prenexus_path + '/../*.xml ' + stagingArea
cmd_text = '> Importing beamtime and cvlist xml files: '
AppendMyLogBook, Event, cmd_text
cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
AppendMyLogBook, Event, cmd_text
spawn, cmd, listening,err_listening1
err_listening1 = ''
IF (err_listening1[0] NE '') THEN BEGIN
   putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
   AppendMyLogBook, Event, err_listening
   error_status = 1
ENDIF ELSE BEGIN
   putTextAtEndOfMyLogBook, Event, OK, PROCESSING
ENDELSE
AppendMyLogBook, Event, ''

RETURN, error_status
END
