;###############################################################################
FUNCTION CreateStagingArea, Event, CNstruct

;retrieve parameters
stagingArea = CNstruct.stagingArea
processing  = CNstruct.processing
failed      = CNstruct.failed
ok          = CNstruct.ok

error_status = 0
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    AppendMyLogBook, Event, '--> Folder does not exist and needs to be created'
    cmd = 'mkdir ' + stagingArea
    cmd_text = '   cmd: ' + cmd
    AppendMyLogBook, Event, cmd_text + ' ... ' + PROCESSING
    putTextAtEndOfMyLogBook, Event, OK, PROCESSING
ENDIF ELSE BEGIN    
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
ENDELSE
RETURN, error_status
END



;###############################################################################



FUNCTION RunmpFlags, Event, CNstruct

;retrieving parameters
instrument = CNstruct.instrument
processing = CNstruct.processing
failed     = CNstruct.failed
ok         = CNstruct.ok
stagingArea = CNstruct.stagingArea
base_file_name = CNstruct.base_file_name
NbrSteps   = CNstruct.NbrSteps

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
error_status = 0

message = '>(1/'+NbrSteps+') Creating Histo. Mapped Files .............. ' + processing
appendLogBook, Event, message
cmd = 'runmp_flags ' + base_file_name + ' -a ' + stagingArea
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    geometry_file             = (*global).mac.geometry_file
    CNstruct.geometry_file    = geometry_file
    translation_file          = (*global).mac.translation_file
    CNstruct.translation_file = translation_file
    mapping_file              = (*global).mac.mapping_file
    CNstruct.mapping_file     = mapping_file
    
    cmd += ' -m ' + mapping_file
    cmd_text = 'PHASE 1/' + Nbrsteps + ': CREATE HISTOGRAM'
    AppendMyLogBook, Event, cmd_text
    cmd_text = '> Creating Histo Mapped Files: '
    AppendMyLogBook, Event, cmd_text
    cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
    AppendMyLogBook, Event, cmd_text
    putTextAtEndOfMyLogBook, Event, OK, PROCESSING
    putTextAtEndOfLogBook, Event, OK, PROCESSING
ENDIF ELSE BEGIN
    file_array                = get_up_to_date_geo_tran_map_file(instrument)
    geometry_file             = file_array[0]
    CNstruct.geometry_file    = geometry_file
    translation_file          = file_array[1]
    CNstruct.translation_file = translation_file
    mapping_file              = file_array[2]
    CNstruct.mapping_file     = mapping_file

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
ENDELSE
RETURN, error_status
END

;###############################################################################

FUNCTION CopyPreNexus, Event,CNstruct

;retrieving parameters
processing    = CNstruct.processing
ok            = CNstruct.ok
failed        = CNstruct.failed
NbrSteps      = CNstruct.NbrSteps
stagingArea   = CNstruct.stagingArea
prenexus_path = CNstruct.prenexus_path

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
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    putTextAtEndOfMyLogBook, Event, OK, PROCESSING
ENDIF ELSE BEGIN
    spawn, cmd, listening,err_listening1
    err_listening1 = ''
    IF (err_listening1[0] NE '') THEN BEGIN
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        AppendMyLogBook, Event, err_listening
        error_status = 1
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, OK, PROCESSING
    ENDELSE
ENDELSE
AppendMyLogBook, Event, ''
RETURN, error_status
END

;###############################################################################

FUNCTION ImportXml, Event, CNstruct

;retrieving parameters
processing    = CNstruct.processing
ok            = CNstruct.ok
failed        = CNstruct.failed
prenexus_path = CNstruct.prenexus_path
stagingArea   = CNstruct.stagingArea

error_status = 0                       
cmd = 'cp ' + prenexus_path + '/*.xml ' + stagingArea
cmd_text = '> Importing cvinfo and runinfo xml files: '
AppendMyLogBook, Event, cmd_text
cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
AppendMyLogBook, Event, cmd_text
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    putTextAtEndOfMyLogBook, Event, OK, PROCESSING
ENDIF ELSE BEGIN
    spawn, cmd, listening,err_listening2
    IF (err_listening2[0] NE '') THEN BEGIN
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        AppendMyLogBook, Event, err_listening
        error_status = 1
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, OK, PROCESSING
    ENDELSE
ENDELSE
AppendMyLogBook, Event, ''

RETURN, error_status
END

;###############################################################################

PRO GetGeoMapTranFile, Event, CNstruct
                                 
text = '> Importing translation file: '
AppendMyLogBook, Event, text
text = '-> Get up to date geometry and translation files:'
AppendMyLogBook, Event, text
geometry_file    = CNstruct.geometry_file
translation_file = CNstruct.translation_file
mapping_file     = CNstruct.mapping_file

text = '--> geometry file is   : ' + geometry_file
AppendMyLogBook, Event, text

text = '--> translation file is: ' + translation_file
AppendMyLogBook, Event, text

text = '--> mapping file is    : ' + mapping_file
AppendMyLogBook, Event, text

END

;###############################################################################

FUNCTION CopyTranMapFiles, Event, CNstruct

;retrieving parameters
processing = CNstruct.processing
ok         = CNstruct.ok
failed     = CNstruct.failed
translation_file = CNStruct.translation_file
mapping_file     = CNstruct.mapping_file
stagingArea      = CNstruct.stagingArea

error_status = 0
text = '-> Copy translation and mapping file in staging area:'
AppendMyLogBook, Event, text
cmd = 'cp ' + translation_file + ' ' + mapping_file + ' ' + stagingArea
cmd_text = ' cmd: ' + cmd + ' ... ' + PROCESSING
AppendMyLogBook, Event, cmd_text
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    putTextAtEndOfMyLogBook, Event, OK, PROCESSING
ENDIF ELSE BEGIN
    spawn, cmd, listening, err_listening3
    err_listening3 = ''
    IF (err_listening3[0] NE '') THEN BEGIN
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        AppendMyLogBook, Event, err_listening
        error_status = 1
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, OK, PROCESSING
    ENDELSE
ENDELSE
AppendMyLogBook, Event, ''
putTextAtEndOfLogBook, Event, OK, PROCESSING
RETURN, error_status
END

;###############################################################################
