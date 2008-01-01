PRO DefineGeneralVariablePart1, Event, CNstruct

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

putMyLogBook, Event, '############ GENERAL VARIABLES #############'

;get RunNumber
RunNumber          = getRunNumber(Event)
CNstruct.RunNumber = strcompress(RunNumber,/remove_all)
AppendMyLogBook, Event, 'Run Number     : ' + RunNumber

;get instrument
instrument           = getInstrument(Event)
CNstruct.instrument  = instrument
(*global).instrument = instrument
AppendMyLogBook, Event, 'Instrument     : ' + Instrument

;get prenexus path
prenexus_path  = CNstruct.prenexus_path
AppendMyLogBook, Event, 'Prenexus_path  : ' + prenexus_path

;create base file name
base_file_name          = prenexus_path + '/' + instrument + '_' + RunNumber
CNstruct.base_file_name = base_file_name
AppendMyLogBook, Event, 'Base file name : ' + base_file_name

;staging area
stagingArea = CNstruct.stagingArea
AppendMyLogBook, Event, 'Staging area   : ' + stagingArea
AppendMyLogBook, Event, '######### END OF GENERAL VARIABLE #########'
AppendMyLogBook, Event, ''

END



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

PRO DefineGeneralVariablePart2, Event, CNstruct

;####### Translation of files
message = '>(3/' + CNstruct.NbrSteps + ') Translating files '
AppendMyLogBook, Event, 'PHASE 3/' + CNstruct.NbrSteps + ': TRANSLATING FILES'

;if there is more that 1 histo, rename first one
CNstruct.ShortNexusName = CNStruct.instrument + '_' + CNStruct.RunNumber
CNstruct.base_name = CNstruct.stagingArea + '/'+ CNstruct.ShortNexusName
CNstruct.base_nexus = CNstruct.base_name 
CNstruct.base_name += '_neutron_histo'
CNstruct.base_ext_name = CNstruct.base_name + '.dat'
CNstruct.base_histo_name = CNstruct.base_name + '_mapped.dat'
CNstruct.p0_file_name = CNstruct.base_name + '_p0.dat'
AppendMyLogBook, Event, '-> base_name       : ' + CNstruct.base_name
AppendMyLogBook, Event, '-> base_ext_name   : ' + CNstruct.base_ext_name
AppendMyLogBook, Event, '-> base_histo_name : ' + CNstruct.base_histo_name
AppendMyLogBook, Event, '-> p0_file_name    : ' + CNstruct.p0_file_name
AppendMyLogBook, Event, '-> base_nexus      : ' + CNstruct.base_nexus
AppendMyLogBook, Event, '-> ShortNexusName  : ' + CNstruct.ShortNexusName
AppendMyLogBook, Event, ''

END

;###############################################################################

FUNCTION MultiPola_renamingFile, Event, CNstruct

message = '--> Rename file into generic histogram mapped file name (' + CNstruct.base_histo_name
message += '):'
AppendMyLogBook, Event, message
cmd = 'mv ' + CurrentPolaStateFileName + ' ' + CNstruct.base_histo_name
cmd_text = 'cmd: ' + cmd
spawn, cmd, listening, err_listening
IF (err_listening[0] EQ '') THEN BEGIN
    message = cmd + ' ... OK'
    error_status = 0
ENDIF ELSE BEGIN
    message = cmd + ' ... FAILED'
    error_status = 1
ENDELSE
AppendMyLogBook, Event, message
AppendMyLogBook, Event, ''
RETURN, error_status
END

;###############################################################################

FUNCTION MultiPola_mergingFile, Event, CNstruct

AppendMyLogBook, Event, '--> Merging the xml files:'
cmd = 'TS_merge_preNeXus.sh ' + CNstruct.translation_file + ' ' $
  + CNstruct.geometry_file + ' ' + CNstruct.stagingArea
cmd_text = 'cmd: ' + cmd + ' ... ' + CNstruct.PROCESSING
AppendMyLogBook, Event, cmd_text
spawn, cmd, listening, merging_error
IF (strmatch(merging_error[0],'*java.lang.Error*')) THEN BEGIN ;problem during merging
    putTextAtEndOfMyLogBook, Event, CNstruct.FAILED, CNstruct.PROCESSING
    AppendMyLogBook, Event, err_listening
    error_status = 1
ENDIF ELSE BEGIN
    putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
    error_status = 0
ENDELSE
AppendMyLogBook, Event, ''
RETURN, error_status
END

;###############################################################################

FUNCTION MultiPola_translatingFile, Event, CNstruct

AppendMyLogBook, Event, '--> Translating the files:'
TranslationFile = stagingArea + '/' + CNstruct.instrument + '_' + $
  CNstruct.RunNumber + '.nxt'
AppendMyLogBook, Event, ' Translation file: ' + CNstruct.TranslationFile 
cmd = 'nxtranslate ' + CNstruct.TranslationFile + ' --hdf5 '
cmd_text = 'cmd: ' + cmd + ' ... ' + CNstruct.PROCESSING
AppendMyLogBook, Event, cmd_text
;move to staging area
CD, stagingArea
spawn, cmd, listening, translation_error
IF (translation_error[0] NE '') THEN BEGIN ;a problem in the translation occured
    putTextAtEndOfMyLogBook, Event, CNstruct.FAILED, CNstruct.PROCESSING
    AppendMyLogBook, Event, err_listening
    error_status = 1
ENDIF ELSE BEGIN
    putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
    error_status = 0
ENDELSE
AppendMyLogBook, Event, ''
RETURN, error_status
END

;###############################################################################

FUNCTION MultiPola_renamingFile, Event, CNstruct

AppendMyLogBook, Event, '--> Renaming Nexus file:'
pre_nexus_name = CNstruct.base_nexus + '.nxs'
nexus_file_name = CNstruct.base_nexus + '_p' + strcompress(CNstruct.PolaIndex,/remove_all) + '.nxs'
cmd = 'mv ' + CNstruct.pre_nexus_name + ' ' + CNstruct.nexus_file_name
cmd_text = 'cmd: ' + cmd + ' ... ' 
spawn, cmd, listening, err_listening
IF (err_listening[0] EQ '') THEN BEGIN
    message = cmd_text + CNstruct.OK
    error_status = 0
ENDIF ELSE BEGIN
    message = cmd_text + CNstruct.FAILED
    error_status = 1
ENDELSE
AppendMyLogBook, Event, message

if (CNstruct.PolaIndex EQ 0) THEN BEGIN
    CNstruct.NexusToMove = [CNstruct.nexus_file_name]
    CNstruct.ShortNexusToMove = [CNstruct.ShortNexusName + '_p0.nxs']
ENDIF ELSE BEGIN
    CNstruct.NexusToMove = [CNstruct.NexusToMove,CNstruct.nexus_file_name]
    CNstruct.ShortNexusToMove = [CNstruct.ShortNexusToMove, CNstruct.ShortNexusName + '_p' + $
                                 strcompress(CNstruct.polaIndex,/remove_all) + '.nxs']
ENDELSE

RETURN, error_status
END

;###############################################################################

PRO SinglePola_message, Event, CNstruct

CNstruct.multi_pola_state = 0            ;we are working in normal mode
putTextAtEndOfMyLogBook, Event, 'NO', CNstruct.PROCESSING
AppendMyLogBook, Event, ''
AppendMyLogBook, Event, 'Working with the normal mode (no multi-polarization states)'
message += '(Normal): ............... ' + CNstruct.PROCESSING
appendLogBook, Event, message
AppendMyLogBook, Event, ''

END
;###############################################################################
