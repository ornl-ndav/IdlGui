;this function will check if the prenexus can be found
PRO run_number, Event
;get run number
RunNumber = getRunNumber(Event)
IF (RunNumber EQ 0) THEN BEGIN
    message = 'Please Enter a Run Number'
    putLogBook, Event, message
ENDIF ELSE BEGIN

;get instrument
    Instrument = getInstrument(Event)
    IF (instrument NE '' ) THEN BEGIN    
        message = 'Checking if Run Number ' + strcompress(RunNumber,/remove_all)
        message += ' for ' + Instrument + ' exists ... ' 
        text = message + 'PROCESSING'
        putLogBook, Event, text
;check if runNumber exist
        result=isPreNexusExistOnDas(Event, RunNumber, Instrument)
        IF (result) THEN BEGIN  ;prenexus exist
            putLogBook, Event, message + 'OK'
        ENDIF ELSE BEGIN
            putLogBook, Event, message + 'FAILED'
;remove run number
            resetRunNumberField, Event
        ENDELSE
    ENDIF ELSE BEGIN
        message = 'Please Select an instrument'
        putLogBook, Event, message
    ENDELSE
ENDELSE
END




PRO output_path, Event ;in makenexus_eventcb.pro
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
title = 'Select the Main Output Directory'
path  = '~/'
OutputPath = DIALOG_PICKFILE(TITLE             = title,$
                             PATH              = path,$
                             /MUST_EXIST,$
                             /DIRECTORY)
IF (OutputPath NE '') THEN BEGIN
    putOutputPath, Event, OutputPath
    (*global).output_path_1 = OutputPath
ENDIF
END


PRO validateOrNotGoButton, Event
RunNumber  = getRunNumber(Event)
instrument = getInstrument(Event)
IF (RunNumber NE '' AND $
    RunNumber NE 0  AND $
    instrument NE '') THEN BEGIN
    validate_status = 1
ENDIF ELSE BEGIN
    validate_status = 0
ENDELSE
;validate go button
validateCreateNexusButton, Event, validate_status
validateSendToGeekButton, Event, validate_status
END


PRO CreateNexus, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).FAILED
NbrSteps   = strcompress(4,/remove_all)

putMyLogBook, Event, '############ GENERAL VARIABLES #############'

;get RunNumber
RunNumber = getRunNumber(Event)
AppendMyLogBook, Event, 'Run Number     : ' + RunNumber
;get instrument
instrument = getInstrument(Event)
(*global).instrument = instrument
AppendMyLogBook, Event, 'Instrument     : ' + Instrument
;get prenexus path
prenexus_path  = (*global).prenexus_path
AppendMyLogBook, Event, 'Prenexus_path  : ' + prenexus_path
;create base file name
base_file_name = prenexus_path + '/' + instrument + '_' + RunNumber
AppendMyLogBook, Event, 'Base file name : ' + base_file_name
;staging area
stagingArea = (*global).staging_folder
AppendMyLogBook, Event, 'Staging area   : ' + stagingArea
AppendMyLogBook, Event, '######### END OF GENERAL VARIABLE #########'
AppendMyLogBook, Event, ''

;make sure the staging area exist and is empty
AppendMyLogBook, Event, '-> Checking if staging folder (' + stagingArea + ') exists:'
IF (FILE_TEST(stagingArea,/DIRECTORY)) THEN BEGIN
    AppendMyLogBook, Event, '--> Folder exists and needs to be cleaned up'
    cmd = 'rm ' + stagingArea + '/*.* -f '
    cmd_text = '   cmd: ' + cmd
    AppendMyLogBook, Event, cmd_text + ' ... ' + PROCESSING
    spawn, cmd, listening_rm, error_rm
    IF (error_rm[0] NE '') THEN BEGIN
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        goto, error
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
        goto, error
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, OK, PROCESSING
    ENDELSE
ENDELSE
AppendMyLogBook, Event, ''

;####### run the runmp_flags tool first ######
message = '>(1/'+NbrSteps+') Creating Histo. Mapped Files .............. ' + processing
appendLogBook, Event, message
cmd = 'runmp_flags ' + base_file_name + ' -a ' + stagingArea
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
   goto, error
   putTextAtEndOfLogBook, Event, FAILED, PROCESSING
ENDIF ELSE BEGIN
   putTextAtEndOfMyLogBook, Event, OK, PROCESSING
   putTextAtEndOfLogBook, Event, OK, PROCESSING
ENDELSE

;###### Copy the prenexus file into stagging area ######
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
   goto, error
ENDIF ELSE BEGIN
   putTextAtEndOfMyLogBook, Event, OK, PROCESSING
ENDELSE
AppendMyLogBook, Event, ''

;importing other xml files
cmd = 'cp ' + prenexus_path + '/*.xml ' + stagingArea
cmd_text = '> Importing cvinfo and runinfo xml files: '
AppendMyLogBook, Event, cmd_text
cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
AppendMyLogBook, Event, cmd_text
spawn, cmd, listening,err_listening2
err_listening2 = ''
IF (err_listening[0] NE '') THEN BEGIN
   putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
   AppendMyLogBook, Event, err_listening
   goto, error
ENDIF ELSE BEGIN
   putTextAtEndOfMyLogBook, Event, OK, PROCESSING
ENDELSE
AppendMyLogBook, Event, ''

;##### get the geometry file from its location
text = '> Importing translation file: '
AppendMyLogBook, Event, text
text = '-> Get up to date geometry and translation files:'
AppendMyLogBook, Event, text
IF ((*global).hostname eq (*global).MacHostName) THEN BEGIN
   geometry_file    = (*global).debugGeomFileName 
   translation_file = (*global).debugTranFileName
   mapping_file     = (*global).debugMapFileName
ENDIF ELSE BEGIN
   file_array = get_up_to_date_geo_tran_map_file(instrument)
   geometry_file    = file_array[0]
   translation_file = file_array[1]
   mapping_file     = file_array[2]
ENDELSE
text = '--> geometry file is   : ' + geometry_file
AppendMyLogBook, Event, text
text = '--> translation file is: ' + translation_file
AppendMyLogBook, Event, text
text = '--> mapping file is    : ' + mapping_file
AppendMyLogBook, Event, text

text = '-> Copy translation and mapping file in staging area:'
AppendMyLogBook, Event, text
cmd = 'cp ' + translation_file + ' ' + mapping_file + ' ' + stagingArea
cmd_text = ' cmd: ' + cmd + ' ... ' + PROCESSING
AppendMyLogBook, Event, cmd_text
spawn, cmd, listening, err_listening3
err_listening3 = ''
IF (err_listening3[0] NE '') THEN BEGIN
   putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
   AppendMyLogBook, Event, err_listening
   goto, error
ENDIF ELSE BEGIN
   putTextAtEndOfMyLogBook, Event, OK, PROCESSING
ENDELSE
AppendMyLogBook, Event, ''

IF (err_listening1[0] NE '' AND $
    err_listening2[0] NE '' AND $
    err_listening3[0] NE '') THEN BEGIN
    putTextAtEndOfLogBook, Event, FAILED, PROCESSING
    goto, error
ENDIF ELSE BEGIN
    putTextAtEndOfLogBook, Event, OK, PROCESSING
ENDELSE

;####### Translation of files
message = '>(3/'+NbrSteps+') Translating files '
AppendMyLogBook, Event, 'PHASE 3/' + NbrSteps + ': TRANSLATING FILES'

;if there is more that 1 histo, rename first one
ShortNexusName = instrument + '_' + RunNumber
base_name = stagingArea + '/'+ ShortNexusName
base_nexus = base_name 
base_name += '_neutron_histo'
base_ext_name = base_name + '.dat'
base_histo_name = base_name + '_mapped.dat'
p0_file_name = base_name + '_p0.dat'
AppendMyLogBook, Event, '-> base_name       : ' + base_name
AppendMyLogBook, Event, '-> base_ext_name   : ' + base_ext_name
AppendMyLogBook, Event, '-> base_histo_name : ' + base_histo_name
AppendMyLogBook, Event, '-> p0_file_name    : ' + p0_file_name
AppendMyLogBook, Event, '-> base_nexus      : ' + base_nexus
AppendMyLogBook, Event, '-> ShortNexusName  : ' + ShortNexusName
AppendMyLogBook, Event, ''

text = '> Checking if p0 state file exist: ' + p0_file_name + ' ... ' + PROCESSING
AppendMyLogBook, Event, text
TranslationError = 0 ;by default, everything is going to run smoothly
IF (FILE_TEST(p0_file_name)) THEN BEGIN ;multi_polarization state
    
    multi_pola_state = 1 ;we are working with the multi_polarization state
    putTextAtEndOfMyLogBook, Event, 'YES', PROCESSING
    AppendMyLogBook, Event, '=> Entering the multi-polarization states mode'
    message += '(Multi-Polarization): ... ' + PROCESSING
    appendLogBook, Event, message
    
    ;work on first polarization state
    polaIndex    = 0
    anotherState = 1
    WHILE (anotherState) DO BEGIN
        message = '-> Polarization state file #' + strcompress(polaIndex,/remove_all)
        CurrentPolaStateFileName = base_name + '_p' + strcompress(PolaIndex,/remove_all) + '.dat'
        message += ' is: ' + CurrentPolaStateFileName
        AppendMyLogBook, Event, message
        
        message = '--> Rename file into generic histogram mapped file name (' + base_histo_name
        message += '):'
        AppendMyLogBook, Event, message
        cmd = 'mv ' + CurrentPolaStateFileName + ' ' + base_histo_name
        cmd_text = 'cmd: ' + cmd
        spawn, cmd, listening, err_listening
        IF (err_listening[0] EQ '') THEN BEGIN
            message = cmd + ' ... OK'
        ENDIF ELSE BEGIN
            message = cmd + ' ... FAILED'
        ENDELSE
        AppendMyLogBook, Event, message
        AppendMyLogBook, Event, ''

;merging xml files
        AppendMyLogBook, Event, '--> Merging the xml files:'
        cmd = 'TS_merge_preNeXus.sh ' + translation_file + ' ' + geometry_file + ' ' + stagingArea
        cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
        AppendMyLogBook, Event, cmd_text
        spawn, cmd, listening, merging_error
        IF (strmatch(merging_error[0],'*java.lang.Error*')) THEN BEGIN ;problem during merging
            putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
            AppendMyLogBook, Event, err_listening
            goto, error
        ENDIF ELSE BEGIN
            putTextAtEndOfMyLogBook, Event, OK, PROCESSING
        ENDELSE
        AppendMyLogBook, Event, ''

;translating the file
        AppendMyLogBook, Event, '--> Translating the files:'
        TranslationFile = stagingArea + '/' + instrument + '_' + RunNumber + '.nxt'
        AppendMyLogBook, Event, ' Translation file: ' + TranslationFile 
        cmd = 'nxtranslate ' + TranslationFile + ' --hdf5 '
        cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
        AppendMyLogBook, Event, cmd_text
;move to staging area
        CD, stagingArea
        spawn, cmd, listening, translation_error
        IF (translation_error[0] NE '') THEN BEGIN ;a problem in the translation occured
            putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
            AppendMyLogBook, Event, err_listening
            goto, error
        ENDIF ELSE BEGIN
            putTextAtEndOfMyLogBook, Event, OK, PROCESSING
        ENDELSE
        AppendMyLogBook, Event, ''

;renaming nexus file
        AppendMyLogBook, Event, '--> Renaming Nexus file:'
        pre_nexus_name = base_nexus + '.nxs'
        nexus_file_name = base_nexus + '_p' + strcompress(PolaIndex,/remove_all) + '.nxs'
        cmd = 'mv ' + pre_nexus_name + ' ' + nexus_file_name
        cmd_text = 'cmd: ' + cmd + ' ... ' 
        spawn, cmd, listening, err_listening
        IF (err_listening[0] EQ '') THEN BEGIN
            message = cmd_text + OK
        ENDIF ELSE BEGIN
            message = cmd_text + FAILED
            goto, error
        ENDELSE
        AppendMyLogBook, Event, message

        if (PolaIndex EQ 0) THEN BEGIN
            NexusToMove = [nexus_file_name]
            ShortNexusToMove = [ShortNexusName + '_p0.nxs']
        ENDIF ELSE BEGIN
            NexusToMove = [NexusToMove,nexus_file_name]
            ShortNexusToMove = [ShortNexusToMove, ShortNexusName + '_p' + $
                                strcompress(polaIndex,/remove_all) + '.nxs']
        ENDELSE

        ++polaIndex
        ;check if next file exist
        file_name = base_name + '_p' + strcompress(PolaIndex,/remove_all) + '.dat'
        IF (FILE_TEST(file_name)) THEN BEGIN
            anotherState = 1 ;YES, CONTINUE
        ENDIF ELSE BEGIN
            anotherState = 0 ;NO, STOP NOW
        ENDELSE
        AppendMyLogBook, Event, ''

    ENDWHILE

ENDIF ELSE BEGIN
 
    multi_pola_state = 0 ;we are working in normal mode
    putTextAtEndOfMyLogBook, Event, 'NO', PROCESSING
    AppendMyLogBook, Event, ''
    AppendMyLogBook, Event, 'Working with the normal mode (no multi-polarization states)'
    message += '(Normal): ............... ' + PROCESSING
    appendLogBook, Event, message
    AppendMyLogBook, Event, ''

;change name of histo from <instr>_<run_number>_neutron_histo.dat to
;<instr>_<run_number>_neutron_histo_mapped.dat
    AppendMyLogBook, Event, '-> Renaming main *_histo.dat file into *_histo_mapped.dat'
    cmd = 'mv ' + base_ext_name + ' ' + base_histo_name
    cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
    AppendMyLogBook, Event, cmd_text
    spawn, cmd, listening, renaming_error
    IF (renaming_error[0] NE '') THEN BEGIN ;a problem in the renaming occured
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        AppendMyLogBook, Event, err_listening
        goto, error
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, OK, PROCESSING
    ENDELSE
    AppendMyLogBook, Event, ''
    
;merging xml files
    AppendMyLogBook, Event, '-> Merging the xml files:'
    cmd = 'TS_merge_preNeXus.sh ' + translation_file + ' ' + geometry_file + ' ' + stagingArea
    cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
    AppendMyLogBook, Event, cmd_text
    spawn, cmd, listening, merging_error
    IF (strmatch(merging_error[0],'*java.lang.Error*')) THEN BEGIN ;problem during merging
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        AppendMyLogBook, Event, err_listening
        goto, error
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, OK, PROCESSING
    ENDELSE
    AppendMyLogBook, Event, ''
    
;translating the file
    AppendMyLogBook, Event, '-> Translating the files:'
    TranslationFile = stagingArea + '/' + instrument + '_' + RunNumber + '.nxt'
    AppendMyLogBook, Event, ' Translation file: ' + TranslationFile 
    cmd = 'nxtranslate ' + TranslationFile + ' --hdf5'
    cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
    AppendMyLogBook, Event, cmd_text
;move to staging area
    CD, stagingArea
    spawn, cmd, listening, translation_error
    IF (translation_error[0] NE '') THEN BEGIN ;a problem in the translation occured
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        AppendMyLogBook, Event, err_listening
        goto, error
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, OK, PROCESSING
    ENDELSE
    AppendMyLogBook, Event, ''
    
ENDELSE                         ;end of normal mode (no polarization)

IF (TranslationError EQ 1) THEN BEGIN
    putTextAtEndOfLogBook, Event, FAILED, PROCESSING
ENDIF ELSE BEGIN
    putTextAtEndOfLogBook, Event, OK, PROCESSING
ENDELSE

;move final nexus file(s) into predefined location(s)
;moving the final nexus file(s) created
message = '>(4/'+NbrSteps+') Moving NeXus to Final Location ............ ' + processing
appendLogBook, Event, message
AppendMyLogBook, Event, 'PHASE 4/' + NbrSteps + ': MOVING FILES TO THEIR FINAL LOCATION'

if (multi_pola_state) then begin

    sz = (size(NexusToMove))(1)
    FOR i=0,(sz-1) DO BEGIN
        message = 'Nexus File #' + strcompress(i,/remove_all) + ': ' + NexusToMove[i]
        AppendMyLogBook, Event, message
    ENDFOR

endif else begin

    NexusFile = stagingArea + '/' + instrument + '_' + RunNumber + '.nxs'
    AppendMyLogBook, Event, ' NeXus file: ' + NexusFile
    NexusToMove = [NexusFile]
    ShortNexusToMove = [ShortNexusName + '.nxs']

endelse
AppendMyLogBook, Event, ''

;get destination folders
;Main output path
output_path = getTextFieldValue(Event, 'output_path_text')
IF (output_path NE '') THEN BEGIN
    message = '-> Check if there is a Main Output Path ... YES (' + output_path + ')'
    AppendMyLogBook, Event, message
    message = '--> Check if output path exists ........... ' + PROCESSING
    AppendMyLogBook, Event, message
    IF (FILE_TEST(output_path,/DIRECTORY)) THEN BEGIN
        putTextAtEndOfMyLogBook, Event, 'YES' , PROCESSING
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, 'NO', PROCESSING
        output_path = ''
    ENDELSE
ENDIF ELSE BEGIN
    message = '-> Check if there is a Main Output Path ... NO'
    AppendMyLogBook, Event, message
ENDELSE
AppendMyLogBook, Event, ''

;Instrument Shared Folder
IF (isInstrSharedFolderSelected(Event)) THEN BEGIN
    InstrSharedFolder = '/SNS/' + instrument + '/shared/'
    message = '-> Check if Instrument Shared Folder is selected ... YES (' + $
      InstrSharedFolder + ')'
    AppendMyLogBook, Event, message
    IF (FILE_TEST(InstrSharedFolder,/DIRECTORY)) THEN BEGIN
        message = '--> Check if Instrument Shared Folder exists ....... YES'
        AppendMyLogBook, Event, message
    ENDIF ELSE BEGIN
        message = '--> Check if Instrument Shared Folder exists ....... NO'
        AppendMyLogBook, Event, message
        InstrSharedFolder = ''
    ENDELSE
ENDIF ELSE BEGIN
    message = '-> Check if Instrument Shared Folder is selected ... NO'
    AppendMyLogBook, Event, message
    InstrSharedFolder = ''
ENDELSE
AppendMyLogBook, Event, ''

;Proposal Shared Folder
IF (isProposalSharedFolderSelected(Event)) THEN BEGIN
    proposalNumber = getProposalNumber(Event, prenexus_path)
    ProposalSharedFolder = '/SNS/' + instrument + '/' + proposalNumber
    ProposalSharedFolder += '/shared/'
    message = '-> Check if Proposal Shared Folder is selected ..... YES (' +$
      ProposalSharedFolder + ')'
    AppendMyLogBook, Event, message
    IF (FILE_TEST(ProposalSharedFolder,/DIRECTORY)) THEN BEGIN
        message = '--> Check if Proposal Shared Folder exists ......... YES'
        AppendMyLogBook, Event, message
    ENDIF ELSE BEGIN
        message = '--> Check if Proposal Shared Folder exists ......... NO'
        AppendMyLogBook, Event, message
        ProposalSharedFolder = ''
    ENDELSE
ENDIF ELSE BEGIN
    message = '-> Check if Proposal Shared Folder is selected ..... NO'
    AppendMyLogBook, Event, message
    ProposalSharedFolder = ''
ENDELSE
AppendMyLogBook, Event, ''

;move only if at least one of the three path exists
IF (output_path NE '' OR $
    InstrSharedFolder NE '' OR $
    ProposalSharedFolder NE '') THEN BEGIN

    sz = (size(NexusToMove))(1)
    IF (sz EQ 1) THEN BEGIN ;only 1 nexus
        message = '-> Moving nexus file:'
        AppendMyLogBook, Event, message
    ENDIF ELSE BEGIN
        message = '-> Moving nexus files:'
        AppendMyLogBook, Event, message
    ENDELSE
    
    text = ['']
    text = [text,'#### NEXUS FILES CREATED ####']
    text = [text, '']

    FOR i=0,(sz-1) DO BEGIN
        
        cmd = 'cp ' + NeXusToMove[i] 
        IF (output_path NE '') THEN BEGIN
            IF (i EQ 0) THEN BEGIN

;output_path/RunNumber/NeXus/nexus/file
;output_path/RunNumber/preNeXus/*.xml
;output_path/RunNumber/preNeXus/*.dat
;output_path/RunNumber/preNeXus/*.nxt
;create NeXus and preNeXus folders
                AppendMyLogBook, Event, 'Iteration #0:'
                NeXus_folder    = output_path + RunNumber + '/NeXus/'
                preNeXus_folder = output_path + RunNumber + '/preNeXus/'

                AppendMyLogBook, Event, 'Checking if NeXus Folder (' + NeXus_folder + $
                  ') exists ... ' + PROCESSING
                IF (FILE_TEST(NeXus_folder,/DIRECTORY)) THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, 'YES', PROCESSING
                    AppendMyLogBook, Event, '-> Remove Content of NeXus folder:'
                    cmd_rm = 'rm -f ' + NeXus_folder + '*.nxs'
                    cmd_rm_text = 'cmd: ' + cmd_rm + ' ... ' + PROCESSING
                    AppendMyLogBook, Event, cmd_rm_text
                    spawn, cmd_rm, listening
                    IF (listening[0] EQ '') THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, OK , PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
                    ENDELSE
                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, 'NO', PROCESSING
                    cmd_spawn = 'mkdir -p ' + Nexus_folder 
                    AppendMyLogBook, Event, 'Create NeXus folder:'
                    cmd_spawn_text = 'cmd: ' + cmd_spawn + ' ... ' + PROCESSING
                    AppendMyLogBook, Event, cmd_spawn_text
                    spawn, cmd_spawn, listening
                    IF (listening[0] EQ '') THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, OK , PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
                    ENDELSE
                    AppendMyLogBook, Event, ''
                ENDELSE
                
                AppendMyLogBook, Event, 'Checking if preNeXus Folder (' + preNeXus_folder + $
                  ') exists ... ' + PROCESSING
                IF (FILE_TEST(preNeXus_folder,/DIRECTORY)) THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, 'YES', PROCESSING
                    AppendMyLogBook, Event, '-> Remove Content of preNeXus folder:'
                    cmd_rm = 'rm -f ' + preNeXus_folder + '*.*'
                    cmd_rm_text = 'cmd: ' + cmd_rm + ' ... ' + PROCESSING
                    AppendMyLogBook, Event, cmd_rm_text
                    spawn, cmd_rm, listening
                    IF (listening[0] EQ '') THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, OK , PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
                    ENDELSE
                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, 'NO', PROCESSING
                    cmd_spawn = 'mkdir -p ' + preNexus_folder 
                    AppendMyLogBook, Event, 'Create preNeXus folder:'
                    cmd_spawn_text = 'cmd: ' + cmd_spawn + ' ... ' + PROCESSING
                    AppendMyLogBook, Event, cmd_spawn_text
                    spawn, cmd_spawn, listening
                    IF (listening[0] EQ '') THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, OK , PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
                    ENDELSE
                    AppendMyLogBook, Event, ''
                ENDELSE
                
;copy *.xml files from prenexus path
                AppendMyLogBook, Event, $
                  'Copy runinfo.xml, cvinfo.xml ... files from DAS/preNeXus folder:'
                cmd_xml = 'cp ' + prenexus_path + '/*.xml' + ' ' + preNeXus_folder
                cmd_xml_text = 'cmd: ' + cmd_xml + ' ... ' + PROCESSING
                AppendMyLogBook, Event, cmd_xml_text
                spawn, cmd_xml, listening
                IF (listening[0] EQ '') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, OK , PROCESSING
                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
                ENDELSE
                AppendMyLogBook, Event, ''
                
                AppendMyLogBook, Event, $
                  'Copy beamtimeinfo.xml and cvlist.xml files from DAS/preNeXus folder:'
                cmd_xml = 'cp ' + prenexus_path + '/../*.xml' + ' ' + preNeXus_folder
                cmd_xml_text = 'cmd: ' + cmd_xml + ' ... ' + PROCESSING
                AppendMyLogBook, Event, cmd_xml_text
                spawn, cmd_xml, listening
                IF (listening[0] EQ '') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, OK , PROCESSING
                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
                ENDELSE
                AppendMyLogBook, Event, ''
                
;copy .nxt file from stagingArea
                AppendMyLogBook, Event, $
                  'Copy translation file from Staging Area:'
                cmd_nxt = 'cp ' + StagingArea + '/*.nxt' + ' ' + preNeXus_folder
                cmd_nxt_text = 'cmd: ' + cmd_nxt + ' ... ' + PROCESSING
                AppendMyLogBook, Event, cmd_nxt_text
                spawn, cmd_nxt, listening
                IF (listening[0] EQ '') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, OK , PROCESSING
                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
                ENDELSE
                AppendMyLogBook, Event, ''
                
;copy *.dat file from prenexus path
                AppendMyLogBook, Event, $
                  'Copy *.dat files from DAS/preNeXus folder:'
                cmd_dat = 'cp ' + prenexus_path + '/*.dat' + ' ' + preNeXus_folder
                cmd_dat_text = 'cmd: ' + cmd_dat + ' ... ' + PROCESSING
                AppendMyLogBook, Event, cmd_dat_text
                spawn, cmd_dat, listening
                IF (listening[0] EQ '') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, OK , PROCESSING
                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
                ENDELSE
                AppendMyLogBook, Event, ''
            ENDIF
            
            cmd1 = cmd + ' ' + NeXus_folder
            cmd1_text = 'cmd: ' + cmd1 + ' ... ' + PROCESSING
            AppendMyLogBook, Event, cmd1_text
            spawn, cmd1, listening
            IF (listening[0] EQ '') THEN BEGIN
                putTextAtEndOfMyLogBook, Event, OK , PROCESSING
                msg = '> ' + NeXus_folder + ShortNexusToMove[i] + $
                  ' (For Archive)'
                text = [text, msg]
            ENDIF ELSE BEGIN
                putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
            ENDELSE
        ENDIF
        
        IF (InstrSharedFolder NE '') THEN BEGIN
            cmd2 = cmd + ' ' + InstrSharedFolder
            cmd2_text = 'cmd: ' + cmd2 + ' ... ' + PROCESSING
            AppendMyLogBook, Event, cmd2_text
            spawn, cmd2, listening
            IF (listening[0] EQ '') THEN BEGIN
                putTextAtEndOfMyLogBook, Event, OK , PROCESSING
                text = [text,'> ' + InstrSharedFolder + ShortNexusToMove[i]]
            ENDIF ELSE BEGIN
                putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
            ENDELSE
        ENDIF

        IF (ProposalSharedFolder NE '') THEN BEGIN
            cmd3 = cmd +' ' + ProposalSharedFolder
            cmd3_text = 'cmd: ' + cmd3 + ' ... ' + PROCESSING
            AppendMyLogBook, Event, cmd3_text
            spawn, cmd3, listening
            IF (listening[0] EQ '') THEN BEGIN ;it worked
                putTextAtEndOfMyLogBook, Event, OK , PROCESSING
                text = [text,'> ' + ProposalSharedFolder+ ShortNexusToMove[i]]
            ENDIF ELSE BEGIN
                putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
            ENDELSE
        ENDIF
        AppendMyLogBook, Event, ''
        
    ENDFOR
    
    putTextAtEndOfLogBook, Event, OK, PROCESSING ;moving files worked
    AppendLogBook, Event, text

ENDIF ELSE BEGIN
    
error: 

    putTextAtEndOfLogBook, Event, FAILED, PROCESSING ;0 output folder defined
    validateCreateNexusButton, Event, 0
    
ENDELSE

END


pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end

pro makenexus_eventcb, event
end

