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

;define progress bar object
progressBar = Obj_New("SHOWPROGRESS",Xoffset=50,Yoffset=50,/CancelButton)
progressBar->SetColor, 250
progressBar->SetLabel, 'Translation in progress ...'
progressBar->Start

nbrphase    = 17./100. ;that will change according to the number of files to process

;Create Main Structure
CNstruct = { processing       : (*global).processing,$
             ok               : (*global).ok,$
             failed           : (*global).failed,$
             NbrSteps         : strcompress(4,/remove_all),$
             RunNumber        : '',$
             instrument       : '',$
             prenexus_path    : (*global).prenexus_path,$
             base_file_name   : '',$
             stagingArea      : (*global).staging_folder,$
             mapping_file     : '',$
             geometry_file    : '',$
             translation_file : '',$
             phase            : 1,$
             NbrPhase         : 17./100,$
             base_name        : '',$
             base_ext_name    : '',$
             base_histo_name  : '',$
             p0_file_name     : '',$
             base_nexus       : '',$
             ShortNexusName   : '',$
             anotherState     : 0,$
             polaIndex        : 0,$
             NexusToMove      : ptr_new(),$
             ShortNexusToMove : ptr_new(),$
             multi_pola_state : 0,$
             NexusFile        : '',$
             output_path      : '',$
             InstrSharedFolder : '',$
             proposalNumber   : '',$
             proposalSharedFolder : '',$
             NexusFolder      : '',$
             preNeXus_folder  : ''}

;STEP1_global : will define and show the general variables that will be used
DefineGeneralVariablePart1, Event, CNstruct
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;STEP2_global : make sure the staging area exist and is empty
error_status = CreateStagingArea( Event, CNstruct)
IF (error_status) THEN GOTO, ERROR
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;STEP3_global : run runmp_flags - that will create the histos files
error_status = RunmpFlags(Event, CNstruct)
IF (error_status) THEN GOTO, ERROR
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;STEP4_global : copy the prenexus file into stagging area
error_status = CopyPreNexus(Event, CNstruct)
IF (error_status) THEN GOTO, ERROR
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;STEP5_global : importing other xml files
error_status = ImportXml(Event, CNstruct)
IF (error_status) THEN GOTO, ERROR
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;STEP6_global : get the geometry file from its location
GetGeoMapTranFile, Event, CNstruct
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;STEP7_global : copy the tranlation/mapping file to staging area
error_status = CopyTranMapFiles(Event, CNstruct)
IF (error_status) THEN GOTO, ERROR
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;STEP8_global : define the variables used in the second part
;####### Translation of files
message = '>(3/' + CNstruct.NbrSteps + ') Translating files '
AppendMyLogBook, Event, 'PHASE 3/' + CNstruct.NbrSteps + ': TRANSLATING FILES'
DefineGeneralVariablePart2, Event, CNstruct
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;STEP9_global ; define polarization state (single or multi)
text = '> Checking if p0 state file exist: ' + CNstruct.p0_file_name + ' ... ' + CNstruct.PROCESSING
AppendMyLogBook, Event, text
TranslationError = 0 ;by default, everything is going to run smoothly
IF (!VERSION.os NE 'darwin' AND $
    FILE_TEST(CNstruct.p0_file_name)) THEN BEGIN ;multi_polarization state
    
    CNStruct.multi_pola_state = 1 ;we are working with the multi_polarization state
    putTextAtEndOfMyLogBook, Event, 'YES', CNstruct.PROCESSING
    AppendMyLogBook, Event, '=> Entering the multi-polarization states mode'
    message += '(Multi-Polarization): ... ' + CNstruct.PROCESSING
    appendLogBook, Event, message
    
 ;work on first polarization state
    CNstruct.polaIndex    = 0
    CNstruct.anotherState = 1
    WHILE (CNstruct.anotherState) DO BEGIN
        message = '-> Polarization state file #' + $
          strcompress(CNstruct.polaIndex,/remove_all)
        CurrentPolaStateFileName = base_name + '_p' + $
          strcompress(CNstruct.PolaIndex,/remove_all) + '.dat'
        message += ' is: ' + CurrentPolaStateFileName
        AppendMyLogBook, Event, message
        
;renaming file into generic histogram mapped file
        error_status = MultiPola_renamingFile(Event,CNstruct)
        IF (error_status) THEN GOTO, ERROR

;merging xml files
        error_status = MultiPola_mergingFile(Event,CNstruct)
        IF (error_status) THEN GOTO, ERROR
        
;translating the file
        error_status = MultiPola_translatingFile(Event,CNstruct)
        IF (error_status) THEN GOTO, ERROR

;renaming nexus file
        error_status = MultiPola(Event,CNstruct)
        IF (error_status) THEN GOTO, ERROR

;checking if there is another pola. (check if nexus exist)
        ++CNstruct.polaIndex
        file_name = CNstruct.base_name + '_p' + strcompress(CNstruct.PolaIndex,/remove_all) + '.dat'
        IF (FILE_TEST(file_name)) THEN BEGIN
            anotherState = 1    ;YES, CONTINUE
        ENDIF ELSE BEGIN
            anotherState = 0    ;NO, STOP NOW
        ENDELSE
        AppendMyLogBook, Event, ''
        
    ENDWHILE
    
ENDIF ELSE BEGIN
    
    SinglePola_message, Event, CNstruct
    message += '(Normal): ............... ' + CNstruct.PROCESSING
    appendLogBook, Event, message
    IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1
   



;change name of histo from <instr>_<run_number>_neutron_histo.dat to
;<instr>_<run_number>_neutron_histo_mapped.dat
;check that histo_mapped is not there already
    IF (!VERSION.os EQ 'darwin') THEN BEGIN
        AppendMyLogBook, Event, '-> Renaming main *_histo.dat file into *_histo_mapped.dat'
        cmd = 'mv ' + CNstruct.base_ext_name + ' ' + CNstruct.base_histo_name
        cmd_text = 'cmd: ' + cmd + ' ... ' + CNstruct.PROCESSING
        AppendMyLogBook, Event, cmd_text
        putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
    ENDIF ELSE BEGIN
        IF (~FILE_TEST(CNstruct.base_histo_name)) THEN BEGIN
            AppendMyLogBook, Event, '-> Renaming main *_histo.dat file into *_histo_mapped.dat'
            cmd = 'mv ' + CNstruct.base_ext_name + ' ' + CNstruct.base_histo_name
            cmd_text = 'cmd: ' + cmd + ' ... ' + CNstruct.PROCESSING
            AppendMyLogBook, Event, cmd_text
            spawn, cmd, listening, renaming_error
            IF (renaming_error[0] NE '') THEN BEGIN ;a problem in the renaming occured
                putTextAtEndOfMyLogBook, Event, CNstruct.FAILED, CNstruct.PROCESSING
                AppendMyLogBook, Event, err_listening
                goto, error
            ENDIF ELSE BEGIN
                putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
            ENDELSE
        ENDIF ELSE BEGIN
            AppendMyLogBook, Event, '-> final histo_mapped file name is already there (*_histo_mapped.dat)'
        ENDELSE
    ENDELSE
    AppendMyLogBook, Event, ''
    
;END OF PHASE 10
    CNstruct.phase       += 1.
    percentDone = CNstruct.phase/nbrPhase
    cancelled = progressBar->CheckCancel()
    IF cancelled THEN BEGIN
        ok = Dialog_Message('User cancelled operation.')
        progressBar->Destroy
        goto, ERROR1
    ENDIF
    progressBar->Update,percentDone    
    
;merging xml fIles
    AppendMyLogBook, Event, '-> Merging the xml files:'
    cmd = 'TS_merge_preNeXus.sh ' + CNstruct.translation_file + ' ' + $
      CNstruct.geometry_file + ' ' $
      + CNstruct.stagingArea
    cmd_text = 'cmd: ' + cmd + ' ... ' + CNstruct.PROCESSING
    AppendMyLogBook, Event, cmd_text
    IF (!VERSION.os EQ 'darwin') THEN BEGIN
        putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
    ENDIF ELSE BEGIN
        spawn, cmd, listening, merging_error
        IF (strmatch(merging_error[0],'*java.lang.Error*')) THEN BEGIN ;problem during merging
            putTextAtEndOfMyLogBook, Event, CNstruct.FAILED, CNstruct.PROCESSING
            AppendMyLogBook, Event, err_listening
            goto, error
        ENDIF ELSE BEGIN
            putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
        ENDELSE
    ENDELSE
    AppendMyLogBook, Event, ''
    
;END OF PHASE 11
    CNstruct.phase       += 1.
    percentDone = CNstruct.phase/nbrPhase
    cancelled = progressBar->CheckCancel()
    IF cancelled THEN BEGIN
        ok = Dialog_Message('User cancelled operation.')
        progressBar->Destroy
        goto, ERROR1
    ENDIF
    progressBar->Update,percentDone    
    
;translating the file
    AppendMyLogBook, Event, '-> Translating the files:'
    TranslationFile = CNstruct.stagingArea + '/' + CNstruct.instrument + '_' + $
      CNstruct.RunNumber + '.nxt'
    AppendMyLogBook, Event, ' Translation file: ' + CNstruct.Translation_file 
    cmd = 'nxtranslate ' + CNstruct.Translation_file + ' --hdf5'
    cmd_text = 'cmd: ' + cmd + ' ... ' + CNstruct.PROCESSING
    AppendMyLogBook, Event, cmd_text

    IF (!VERSION.os EQ 'darwin') THEN BEGIN
        putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
    ENDIF ELSE BEGIN
;move to staging area
        CD, stagingArea
        spawn, cmd, listening, translation_error
        IF (translation_error[0] NE '') THEN BEGIN ;a problem in the translation occured
            putTextAtEndOfMyLogBook, Event, CNstruct.FAILED, CNstruct.PROCESSING
            AppendMyLogBook, Event, err_listening
            goto, error
        ENDIF ELSE BEGIN
            putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
        ENDELSE
    ENDELSE
    AppendMyLogBook, Event, ''
    
ENDELSE                         ;end of normal mode (no polarization)

IF (!VERSION.os EQ 'darwin') THEN BEGIN
    putTextAtEndOfLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
ENDIF ELSE BEGIN
    IF (TranslationError EQ 1) THEN BEGIN
        putTextAtEndOfLogBook, Event, CNstruct.FAILED, CNstruct.PROCESSING
    ENDIF ELSE BEGIN
        putTextAtEndOfLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
    ENDELSE
ENDELSE

;END OF PHASE 12
CNstruct.phase       += 1.
percentDone = CNstruct.phase/nbrPhase
cancelled = progressBar->CheckCancel()
IF cancelled THEN BEGIN
    ok = Dialog_Message('User cancelled operation.')
    progressBar->Destroy
    goto, ERROR1
ENDIF
progressBar->Update,percentDone    

;move final nexus file(s) into predefined location(s)
;moving the final nexus file(s) created
message = '>(4/' + CNstruct.NbrSteps + ') Moving NeXus to Final Location ............ ' + CNstruct.processing
appendLogBook, Event, message
AppendMyLogBook, Event, 'PHASE 4/' + CNstruct.NbrSteps + ': MOVING FILES TO THEIR FINAL LOCATION'

IF (CNstruct.multi_pola_state) THEN BEGIN
    sz = (size(CNstruct.NexusToMove))(1)
    FOR i=0,(sz-1) DO BEGIN
        message = 'Nexus File #' + strcompress(i,/remove_all) + ': ' + CNstruct.NexusToMove[i]
        AppendMyLogBook, Event, message
    ENDFOR
ENDIF ELSE BEGIN
    CNstruct.NexusFile = CNStruct.stagingArea + '/' + $
      CNstruct.instrument + '_' + CNstruct.RunNumber + '.nxs'
    AppendMyLogBook, Event, ' NeXus file: ' + CNstruct.NexusFile
    CNstruct.NexusToMove = [CNstruct.NexusFile]
    CNstruct.ShortNexusToMove = [CNstruct.ShortNexusName + '.nxs']
ENDELSE
AppendMyLogBook, Event, ''

;END OF PHASE 13
CNstruct.phase       += 1.
percentDone = CNstruct.phase/nbrPhase
cancelled = progressBar->CheckCancel()
IF cancelled THEN BEGIN
    ok = Dialog_Message('User cancelled operation.')
    progressBar->Destroy
    goto, ERROR1
ENDIF
progressBar->Update,percentDone    

;get destination folders
;Main output path
CNstruct.output_path = getTextFieldValue(Event, 'output_path_text')
IF (CNstruct.output_path NE '') THEN BEGIN
    message = '-> Check if there is a Main Output Path ... YES (' + CNstruct.output_path + ')'
    AppendMyLogBook, Event, message
    message = '--> Check if output path exists ........... ' + CNstruct.PROCESSING
    AppendMyLogBook, Event, message
    IF (!VERSION.os EQ 'darwin') THEN BEGIN
        putTextAtEndOfMyLogBook, Event, 'YES' , CNstruct.PROCESSING
    ENDIF ELSE BEGIN
        IF (FILE_TEST(output_path,/DIRECTORY)) THEN BEGIN
            putTextAtEndOfMyLogBook, Event, 'YES' , CNstruct.PROCESSING
        ENDIF ELSE BEGIN
            putTextAtEndOfMyLogBook, Event, 'NO', CNstruct.PROCESSING
            CNstruct.output_path = ''
        ENDELSE
    ENDELSE
ENDIF ELSE BEGIN
    message = '-> Check if there is a Main Output Path ... NO'
    AppendMyLogBook, Event, message
ENDELSE
AppendMyLogBook, Event, ''

;END OF PHASE 14
CNstruct.phase       += 1.
percentDone = CNstruct.phase/nbrPhase
cancelled = progressBar->CheckCancel()
IF cancelled THEN BEGIN
    ok = Dialog_Message('User cancelled operation.')
    progressBar->Destroy
    goto, ERROR1
ENDIF
progressBar->Update,percentDone    

;Instrument Shared Folder
IF (isInstrSharedFolderSelected(Event)) THEN BEGIN
    CNstruct.InstrSharedFolder = '/SNS/' + CNstruct.instrument + '/shared/'
    message = '-> Check if Instrument Shared Folder is selected ... YES (' + $
      CNstruct.InstrSharedFolder + ')'
    AppendMyLogBook, Event, message
    IF (!VERSION.os EQ 'darwin') THEN BEGIN
        message = '--> Check if Instrument Shared Folder exists ....... YES'
        AppendMyLogBook, Event, message
    ENDIF ELSE BEGIN
        IF (FILE_TEST(CNstruct.InstrSharedFolder,/DIRECTORY)) THEN BEGIN
            message = '--> Check if Instrument Shared Folder exists ....... YES'
            AppendMyLogBook, Event, message
        ENDIF ELSE BEGIN
            message = '--> Check if Instrument Shared Folder exists ....... NO'
            AppendMyLogBook, Event, message
            CNstruct.InstrSharedFolder = ''
        ENDELSE
    ENDELSE
ENDIF ELSE BEGIN
    message = '-> Check if Instrument Shared Folder is selected ... NO'
    AppendMyLogBook, Event, message
    CNstruct.InstrSharedFolder = ''
ENDELSE
AppendMyLogBook, Event, ''

;END OF PHASE 15
CNstruct.phase       += 1.
percentDone = CNstruct.phase/nbrPhase
cancelled = progressBar->CheckCancel()
IF cancelled THEN BEGIN
    ok = Dialog_Message('User cancelled operation.')
    progressBar->Destroy
    goto, ERROR1
ENDIF
progressBar->Update,percentDone    

;Proposal Shared Folder
IF (isProposalSharedFolderSelected(Event)) THEN BEGIN
    CNstruct.proposalNumber = getProposalNumber(Event, CNstruct.prenexus_path)
    CNstruct.ProposalSharedFolder = '/SNS/' + CNstruct.instrument + '/' + CNstruct.proposalNumber
    CNstruct.ProposalSharedFolder += '/shared/'
    message = '-> Check if Proposal Shared Folder is selected ..... YES (' +$
      CNstruct.ProposalSharedFolder + ')'
    AppendMyLogBook, Event, message
    IF (!VERSION.os EQ 'darwin') THEN BEGIN
            message = '--> Check if Proposal Shared Folder exists ......... YES'
            AppendMyLogBook, Event, message        
    ENDIF ELSE BEGIN
        IF (FILE_TEST(CNstruct.ProposalSharedFolder,/DIRECTORY)) THEN BEGIN
            message = '--> Check if Proposal Shared Folder exists ......... YES'
            AppendMyLogBook, Event, message
        ENDIF ELSE BEGIN
            message = '--> Check if Proposal Shared Folder exists ......... NO'
            AppendMyLogBook, Event, message
            CNstruct.ProposalSharedFolder = ''
        ENDELSE
    ENDELSE
ENDIF ELSE BEGIN
    message = '-> Check if Proposal Shared Folder is selected ..... NO'
    AppendMyLogBook, Event, message
    CNstruct.ProposalSharedFolder = ''
ENDELSE
AppendMyLogBook, Event, ''

;END OF PHASE 16
CNstruct.phase       += 1.
percentDone = CNstruct.phase/nbrPhase
cancelled = progressBar->CheckCancel()
IF cancelled THEN BEGIN
    ok = Dialog_Message('User cancelled operation.')
    progressBar->Destroy
    goto, ERROR1
ENDIF
progressBar->Update,percentDone    

;move only if at least one of the three path exists
IF (CNstruct.output_path NE '' OR $
    CNstruct.InstrSharedFolder NE '' OR $
    CNstruct.ProposalSharedFolder NE '') THEN BEGIN

    sz = (size(CNStruct.NexusToMove))(1)
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
        
        cmd = 'cp ' + CNstruct.NeXusToMove[i] 
        IF (CNstruct.output_path NE '') THEN BEGIN
            IF (i EQ 0) THEN BEGIN

;output_path/RunNumber/NeXus/nexus/file
;output_path/RunNumber/preNeXus/*.xml
;output_path/RunNumber/preNeXus/*.dat
;output_path/RunNumber/preNeXus/*.nxt
;create NeXus and preNeXus folders
                AppendMyLogBook, Event, 'Iteration #0:'
                CNstruct.NeXus_folder    = CNstruct.output_path + CNstruct.RunNumber + '/NeXus/'
                CNstruct.preNeXus_folder = CNstruct.output_path + CNstruct.RunNumber + '/preNeXus/'

                AppendMyLogBook, Event, 'Checking if NeXus Folder (' + NeXus_folder + $
                  ') exists ... ' + CNstruct.PROCESSING
                IF (!VERSION.os EQ 'darwin') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, 'YES', CNstruct.PROCESSING
                    AppendMyLogBook, Event, '-> Remove Content of NeXus folder:'
                    cmd_rm = 'rm -f ' + CNstruct.NeXus_folder + '*.nxs'
                    cmd_rm_text = 'cmd: ' + cmd_rm + ' ... ' + CNstruct.PROCESSING
                    AppendMyLogBook, Event, cmd_rm_text
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                ENDIF ELSE BEGIN
                    IF (FILE_TEST(CNstruct.NeXus_folder,/DIRECTORY)) THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, 'YES', CNstruct.PROCESSING
                        AppendMyLogBook, Event, '-> Remove Content of NeXus folder:'
                        cmd_rm = 'rm -f ' + CNstruct.NeXus_folder + '*.nxs'
                        cmd_rm_text = 'cmd: ' + cmd_rm + ' ... ' + CNstruct.PROCESSING
                        AppendMyLogBook, Event, cmd_rm_text
                        spawn, cmd_rm, listening
                        IF (listening[0] EQ '') THEN BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                        ENDIF ELSE BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , CNstruct.PROCESSING
                        ENDELSE
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, 'NO', CNstruct.PROCESSING
                        cmd_spawn = 'mkdir -p ' + CNstruct.Nexus_folder 
                        AppendMyLogBook, Event, 'Create NeXus folder:'
                        cmd_spawn_text = 'cmd: ' + cmd_spawn + ' ... ' + CNstruct.PROCESSING
                        AppendMyLogBook, Event, cmd_spawn_text
                        spawn, cmd_spawn, listening
                        IF (listening[0] EQ '') THEN BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                        ENDIF ELSE BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , CNstruct.PROCESSING
                        ENDELSE
                    ENDELSE
                    AppendMyLogBook, Event, ''
                ENDELSE
                
                AppendMyLogBook, Event, 'Checking if preNeXus Folder (' + $
                  CNstruct.preNeXus_folder + $
                  ') exists ... ' + CNstruct.PROCESSING
                IF (!VERSION.os EQ 'darwin') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, 'YES', CNstruct.PROCESSING
                    AppendMyLogBook, Event, '-> Remove Content of preNeXus folder:'
                    cmd_rm = 'rm -f ' + CNstruct.preNeXus_folder + '*.*'
                    cmd_rm_text = 'cmd: ' + cmd_rm + ' ... ' + CNstruct.PROCESSING
                    AppendMyLogBook, Event, cmd_rm_text
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                ENDIF ELSE BEGIN
                    IF (FILE_TEST(CNstruct.preNeXus_folder,/DIRECTORY)) THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, 'YES', CNstruct.PROCESSING
                        AppendMyLogBook, Event, '-> Remove Content of preNeXus folder:'
                        cmd_rm = 'rm -f ' + CNstruct.preNeXus_folder + '*.*'
                        cmd_rm_text = 'cmd: ' + cmd_rm + ' ... ' + CNstruct.PROCESSING
                        AppendMyLogBook, Event, cmd_rm_text
                        spawn, cmd_rm, listening
                        IF (listening[0] EQ '') THEN BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                        ENDIF ELSE BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , CNstruct.PROCESSING
                        ENDELSE
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, 'NO', CNstruct.PROCESSING
                        cmd_spawn = 'mkdir -p ' + CNstruct.preNexus_folder 
                        AppendMyLogBook, Event, 'Create preNeXus folder:'
                        cmd_spawn_text = 'cmd: ' + cmd_spawn + ' ... ' + CNstruct.PROCESSING
                        AppendMyLogBook, Event, cmd_spawn_text
                        spawn, cmd_spawn, listening
                        IF (listening[0] EQ '') THEN BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                        ENDIF ELSE BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , CNstruct.PROCESSING
                        ENDELSE
                    ENDELSE
                    AppendMyLogBook, Event, ''
                ENDELSE
                
;copy *.xml files from prenexus path
                AppendMyLogBook, Event, $
                  'Copy runinfo.xml, cvinfo.xml ... files from DAS/preNeXus folder:'
                cmd_xml = 'cp ' + CNstruct.prenexus_path + '/*.xml' $
                  + ' ' + CNstruct.preNeXus_folder
                cmd_xml_text = 'cmd: ' + cmd_xml + ' ... ' + CNstruct.PROCESSING
                AppendMyLogBook, Event, cmd_xml_text
                IF (!VERSION.os EQ 'darwin') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                ENDIF ELSE BEGIN
                    spawn, cmd_xml, listening
                    IF (listening[0] EQ '') THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , CNstruct.PROCESSING
                    ENDELSE
                ENDELSE
                AppendMyLogBook, Event, ''
                
                AppendMyLogBook, Event, $
                  'Copy beamtimeinfo.xml and cvlist.xml files from DAS/preNeXus folder:'
                cmd_xml = 'cp ' + CNStruct.prenexus_path + '/../*.xml' $
                  + ' ' + CNstruct.preNeXus_folder
                cmd_xml_text = 'cmd: ' + cmd_xml + ' ... ' + CNstruct.PROCESSING
                AppendMyLogBook, Event, cmd_xml_text
                IF (!VERSION.os EQ 'darwin') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                ENDIF ELSE BEGIN
                    spawn, cmd_xml, listening
                    IF (listening[0] EQ '') THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , CNstruct.PROCESSING
                    ENDELSE
                ENDELSE
                AppendMyLogBook, Event, ''
                
;copy .nxt file from stagingArea
                AppendMyLogBook, Event, $
                  'Copy translation file from Staging Area:'
                cmd_nxt = 'cp ' + CNstruct.StagingArea + '/*.nxt' + ' ' + CNstruct.preNeXus_folder
                cmd_nxt_text = 'cmd: ' + cmd_nxt + ' ... ' + CNstruct.PROCESSING
                AppendMyLogBook, Event, cmd_nxt_text
                IF (!VERSION.os EQ 'darwin') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                ENDIF ELSE BEGIN
                    spawn, cmd_nxt, listening
                    IF (listening[0] EQ '') THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
                    ENDELSE
                ENDELSE
                AppendMyLogBook, Event, ''
                
;copy *.dat file from prenexus path
                AppendMyLogBook, Event, $
                  'Copy *.dat files from DAS/preNeXus folder:'
                cmd_dat = 'cp ' + CNstruct.prenexus_path + '/*.dat' + ' ' + CNstruct.preNeXus_folder
                cmd_dat_text = 'cmd: ' + cmd_dat + ' ... ' + CNstruct.PROCESSING
                AppendMyLogBook, Event, cmd_dat_text
                IF (!VERSION.os EQ 'darwin') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                ENDIF ELSE BEGIN
                    spawn, cmd_dat, listening
                    IF (listening[0] EQ '') THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , CNstruct.PROCESSING
                    ENDELSE
                ENDELSE
                AppendMyLogBook, Event, ''
            ENDIF
            
            cmd1 = cmd + ' ' + CNstruct.NeXus_folder
            cmd1_text = 'cmd: ' + cmd1 + ' ... ' + CNstruct.PROCESSING
            AppendMyLogBook, Event, cmd1_text
            IF (!VERSION.os EQ 'darwin') THEN BEGIN
                putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                msg = '> ' + CNstruct.NeXus_folder + CNstruct.ShortNexusToMove[i] + $
                  ' (For Archive)'
                text = [text, msg]
            ENDIF ELSE BEGIN
                spawn, cmd1, listening
                IF (listening[0] EQ '') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                    msg = '> ' + CNstruct.NeXus_folder + CNstruct.ShortNexusToMove[i] + $
                      ' (For Archive)'
                    text = [text, msg]
                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , CNstruct.PROCESSING
                ENDELSE
            ENDELSE
        ENDIF
        
        IF (CNstruct.InstrSharedFolder NE '') THEN BEGIN
            cmd2 = cmd + ' ' + CNstruct.InstrSharedFolder
            cmd2_text = 'cmd: ' + cmd2 + ' ... ' + CNstruct.PROCESSING
            AppendMyLogBook, Event, cmd2_text
            IF (!VERSION.os EQ 'darwin') THEN BEGIN
                putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                text = [text,'> ' + CNstruct.InstrSharedFolder + CNstruct.ShortNexusToMove[i]]
            ENDIF ELSE BEGIN
                spawn, cmd2, listening
                IF (listening[0] EQ '') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                    text = [text,'> ' + CNstruct.InstrSharedFolder + CNstruct.ShortNexusToMove[i]]
                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , CNstruct.PROCESSING
                ENDELSE
            ENDELSE
        ENDIF

        IF (CNstruct.ProposalSharedFolder NE '') THEN BEGIN
            cmd3 = cmd +' ' + CNstruct.ProposalSharedFolder
            cmd3_text = 'cmd: ' + cmd3 + ' ... ' + CNstruct.PROCESSING
            AppendMyLogBook, Event, cmd3_text
            IF (!VERSION.os EQ 'darwin') THEN BEGIN
                putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                text = [text,'> ' + ProposalSharedFolder+ ShortNexusToMove[i]]
            ENDIF ELSE BEGIN
                spawn, cmd3, listening
                IF (listening[0] EQ '') THEN BEGIN ;it worked
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , CNstruct.PROCESSING
                    text = [text,'> ' + CNstruct.ProposalSharedFolder+ CNstruct.ShortNexusToMove[i]]
                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , CNstruct.PROCESSING
                ENDELSE
            ENDELSE
        ENDIF
        AppendMyLogBook, Event, ''
        
    ENDFOR

;END OF PHASE 17
    CNstruct.phase       += 1.
    percentDone = CNstruct.phase/nbrPhase
    cancelled = progressBar->CheckCancel()
    IF cancelled THEN BEGIN
        ok = Dialog_Message('User cancelled operation.')
        progressBar->Destroy
        goto, ERROR1
    ENDIF
    progressBar->Update,percentDone    
    
    putTextAtEndOfLogBook, Event, CNstruct.OK, CNstruct.PROCESSING ;moving files worked
    AppendLogBook, Event, text

ENDIF ELSE BEGIN
    
error: 
    putTextAtEndOfLogBook, Event, CNstruct.FAILED, CNstruct.PROCESSING ;0 output folder defined
    validateCreateNexusButton, Event, 0
    
error1:
    AppendMyLogBook, Event, ''
    AppendMyLogBook, Event, '*** TRANSLATION PROCESS HAS BEEN INTERRUPTED BY USER ***'
    appendLogBook, Event, ''
    appendLogBook, Event, '*** TRANSLATION PROCESS HAS BEEN INTERRUPTED BY USER ***'
    validateCreateNexusButton, Event, 1
ENDELSE

progressBar->Destroy
Obj_Destroy, progressBar

END


pro MAIN_REALIZE, wWidget
;Device, Decomposed=0
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end

pro makenexus_eventcb, event
end

