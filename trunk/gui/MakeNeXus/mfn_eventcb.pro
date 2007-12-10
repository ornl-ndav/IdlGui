;this function will check if the prenexus can be found
PRO run_number, Event
;get run number
RunNumber = getRunNumber(Event)
;get instrument
Instrument = getInstrument(Event)
IF (instrument NE '') THEN BEGIN    
    message = 'Checking if Run Number ' + strcompress(RunNumber,/remove_all)
    message += ' for ' + Instrument + ' exists ... ' 
    text = message + 'PROCESSING'
    putLogBook, Event, text
;check if runNumber exist
    result=isPreNexusExistOnDas(Event, RunNumber, Instrument)
    IF (result) THEN BEGIN      ;prenexus exist
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
END




PRO output_path, Event ;in mfn_eventcb.pro
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
RunNumber = getRunNumber(Event)
outputPath = getOutputPath(Event)
IF (RunNumber NE '' AND $
    RunNumber NE 0  AND $
    outputPath NE '') THEN BEGIN
    validate_status = 1
ENDIF ELSE BEGIN
    validate_status = 0
ENDELSE
;validate go button
validateCreateNexusButton, Event, validate_status
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
;####### run the runmp_flags tool first ######
message = '>(1/'+NbrSteps+') Creating Histo. Mapped Files ..... ' + processing
appendLogBook, Event, message
cmd = 'runmp_flags ' + base_file_name + ' -a ' + stagingArea
cmd_text = 'PHASE 1/' + Nbrsteps + ': CREATE HISTOGRAM'
AppendMyLogBook, Event, cmd_text
cmd_text = '> Creating Histo Mapped Files: '
AppendMyLogBook, Event, cmd_text
cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
AppendMyLogBook, Event, cmd_text
;spawn, cmd, listening, err_listening ;remove_me
err_listening = '' ;remove_me
IF (err_listening[0] NE '') THEN BEGIN
   putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
   AppendMyLogBook, Event, err_listening
   putTextAtEndOfLogBook, Event, FAILED, PROCESSING
ENDIF ELSE BEGIN
   putTextAtEndOfMyLogBook, Event, OK, PROCESSING
   putTextAtEndOfLogBook, Event, OK, PROCESSING
ENDELSE

;###### Copy the prenexus file into stagging area ######
message = '>(2/'+NbrSteps+') Importing staging files .......... ' + processing
appendLogBook, Event, message
appendMyLogBook, Event, ''
AppendMyLogBook, Event, 'PHASE 2/' + NbrSteps + ': IMPORT FILES'
;importing beamtime and cvlist
cmd = 'cp ' + prenexus_path + '/../*.xml ' + stagingArea
cmd_text = '> Importing beamtime and cvlist xml files: '
AppendMyLogBook, Event, cmd_text
cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
AppendMyLogBook, Event, cmd_text
;spawn, cmd, listening,err_listening1 ;remove_me
err_listening1 = ''
IF (err_listening1[0] NE '') THEN BEGIN
   putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
   AppendMyLogBook, Event, err_listening
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
;spawn, cmd, listening,err_listening2
err_listening2 = ''
IF (err_listening[0] NE '') THEN BEGIN
   putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
   AppendMyLogBook, Event, err_listening
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
ENDIF ELSE BEGIN
   file_array = get_up_to_date_geo_tran_file(instrument)
   geometry_file    = file_array[0]
   translation_file = file_array[1]
ENDELSE
text = '--> geometry file is   : ' + geometry_file
AppendMyLogBook, Event, text
text = '--> translation file is: ' + translation_file
AppendMyLogBook, Event, text
text = '-> Copy translation file in staging area:'
AppendMyLogBook, Event, text
cmd = 'cp ' + translation_file + ' ' + stagingArea
cmd_text = ' cmd: ' + cmd + ' ... ' + PROCESSING
AppendMyLogBook, Event, cmd_text
;spawn, cmd, listening, err_listening3
err_listening3 = ''
IF (err_listening3[0] NE '') THEN BEGIN
   putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
   AppendMyLogBook, Event, err_listening
ENDIF ELSE BEGIN
   putTextAtEndOfMyLogBook, Event, OK, PROCESSING
ENDELSE
AppendMyLogBook, Event, ''

IF (err_listening1[0] NE '' AND $
    err_listening2[0] NE '' AND $
    err_listening3[0] NE '') THEN BEGIN
    putTextAtEndOfLogBook, Event, FAILED, PROCESSING
ENDIF ELSE BEGIN
    putTextAtEndOfLogBook, Event, OK, PROCESSING
ENDELSE

;####### Translation of files
message = '>(3/'+NbrSteps+') Translating files '
AppendMyLogBook, Event, 'PHASE 3/' + NbrSteps + ': TRANSLATING FILES'

;if there is more that 1 histo, rename first one
base_name = stagingArea + '/'+ instrument + '_' + RunNumber
base_name += '_neutron_histo'
base_ext_name = base_name + '.dat'
base_histo_name = base_name + '_mapped.dat'
p0_file_name = base_name + '_p0.dat'
AppendMyLogBook, Event, '-> base_name       : ' + base_name
AppendMyLogBook, Event, '-> base_ext_name   : ' + base_ext_name
AppendMyLogBook, Event, '-> base_histo_name : ' + base_histo_name
AppendMyLogBook, Event, '-> p0_file_name    : ' + p0_file_name
AppendMyLogBook, Event, ''

text = '> Checking if p0 state file exist: ' + p0_file_name + ' ... ' + PROCESSING
AppendMyLogBook, Event, text
TranslationError = 0 ;by default, everything is going to run smoothly
IF (FILE_TEST(p0_file_name)) THEN BEGIN ;multi_polarization state
    
    multi_pola_state = 1 ;we are working with the multi_polarization state
    putTextAtEndOfMyLogBook, Event, 'YES', PROCESSING
    AppendMyLogBook, Event, '=> Entering the multi-polarization states mode'
    message += '(Multi-Polarization): ..... ' + PROCESSING
    appendLogBook, Event, message
    
ENDIF ELSE BEGIN
 
    multi_pola_state = 1 ;we are working with the multi_polarization state
    putTextAtEndOfMyLogBook, Event, 'NO', PROCESSING
    AppendMyLogBook, Event, ''
    AppendMyLogBook, Event, 'Working with the normal mode (no multi-polarization states)'
    message += '(Normal): ...... ' + PROCESSING
    appendLogBook, Event, message
    AppendMyLogBook, Event, ''

;change name of histo from <instr>_<run_number>_neutron_histo.dat to
;<instr>_<run_number>_neutron_histo_mapped.dat
    AppendMyLogBook, Event, '-> Renaming main *_histo.dat file into *_histo_mapped.dat'
    cmd = 'mv ' + base_ext_name + ' ' + base_histo_name
    cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
    AppendMyLogBook, Event, cmd_text
;   spawn, cmd, listening, renaming_error
    renaming_error = ''         ;REMOVE_ME
    IF (renaming_error[0] NE '') THEN BEGIN ;a problem in the renaming occured
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        AppendMyLogBook, Event, err_listening
                                ;jump to end of full process and display error in LogBook
                                ;?????????????????????????
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, OK, PROCESSING
    ENDELSE
    AppendMyLogBook, Event, ''
    
;merging xml files
    AppendMyLogBook, Event, '-> Merging the xml files:'
    cmd = 'TS_merge_preNeXus.sh ' + translation_file + ' ' + geometry_file + ' ' + stagingArea
    cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
    AppendMyLogBook, Event, cmd_text
;spawn, cmd, listening, merging_error
    merging_error = ''          ;REMOVE_ME
    IF (merging_error[0] NE '') THEN BEGIN ;a problem in the merging occured
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        AppendMyLogBook, Event, err_listening
                                ;jump to end of full process and display error in LogBook
                                ;?????????????????????????
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
;spawn, cmd, listening, translation_error
    translation_error = ''      ;REMOVE_ME
    IF (translation_error[0] NE '') THEN BEGIN ;a problem in the translation occured
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        AppendMyLogBook, Event, err_listening
                                ;jump to end of full process and display error in LogBook
                                ;?????????????????????????
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
message = '>(4/'+NbrSteps+') Moving NeXus to Final Location ... ' + processing
appendLogBook, Event, message
AppendMyLogBook, Event, 'PHASE 4/' + NbrSteps + ': MOVING FILES TO THEIR FINAL LOCATION'

if (multi_pola_state) then begin




endif else begin
    NexusFile = stagingArea + '/' + instrument + '_' + RunNumber + '.nxs'
    AppendMyLogBook, Event, ' NeXus file: ' + NexusFile
    AppendMyLogBook, Event, ''
endelse

;get destination folders
;Main output path
output_path = getTextFieldValue(Event, 'output_path_text')
IF (output_path NE '') THEN BEGIN
    message = '--> Check if there is a Main Output Path ... YES (' + output_path + ')'
    AppendMyLogBook, Event, message
    message = '---> Check if output path exists ........... ' + PROCESSING
    AppendMyLogBook, Event, message
    IF (FILE_TEST(output_path,/DIRECTORY)) THEN BEGIN
        putTextAtEndOfMyLogBook, Event, 'YES' , PROCESSING
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, 'NO', PROCESSING
        output_path = ''
    ENDELSE
ENDIF ELSE BEGIN
    message = '--> Check if there is a Main Output Path ... NO'
    AppendMyLogBook, Event, message
ENDELSE
AppendMyLogBook, Event, ''

;Instrument Shared Folder
IF (isInstrSharedFolderSelected(Event)) THEN BEGIN
    InstrSharedFolder = '/SNS/' + instrument + '/shared/'
    message = '--> Check if Instrument Shared Folder is selected ... YES (' + $
      InstrSharedFolder + ')'
    AppendMyLogBook, Event, message
    IF (FILE_TEST(InstrSharedFolder,/DIRECTORY)) THEN BEGIN
        message = '--> Check if Instrument Shared Folder exists ........ YES'
        AppendMyLogBook, Event, message
    ENDIF ELSE BEGIN
        message = '--> Check if Instrument Shared Folder exists ........ NO'
        AppendMyLogBook, Event, message
        InstrSharedFolder = ''
    ENDELSE
ENDIF ELSE BEGIN
    message = '---> Check if Instrument Shared Folder is selected ... NO'
    AppendMyLogBook, Event, message
    InstrSharedFolder = ''
ENDELSE
AppendMyLogBook, Event, ''

;Proposal Shared Folder
IF (isProposalSharedFolderSelected(Event)) THEN BEGIN
    proposalNumber = getProposalNumber(Event, prenexus_path)
    ProposalSharedFolder = '/SNS/' + instrument + '/' + proposalNumber
    ProposalSharedFolder += '/shared/'
    message = '--> Check if Proposal Shared Folder is selected ..... YES (' +$
      ProposalSharedFolder + ')'
    AppendMyLogBook, Event, message
    IF (FILE_TEST(ProposalSharedFolder,/DIRECTORY)) THEN BEGIN
        message = '--> Check if Proposal Shared Folder exists .......... YES'
        AppendMyLogBook, Event, message
    ENDIF ELSE BEGIN
        message = '--> Check if Proposal Shared Folder exists .......... NO'
        AppendMyLogBook, Event, message
        ProposalSharedFolder = ''
    ENDELSE
ENDIF ELSE BEGIN
    message = '---> Check if Proposal Shared Folder is selected ..... NO'
    AppendMyLogBook, Event, message
    ProposalSharedFolder = ''
ENDELSE
AppendMyLogBook, Event, ''



















   
END


;;     another_state = 1
;;     state_index   = 0
;;     p_file_name   = p0_file_name
;;     WHILE (another_state) DO BEGIN
        
;;             cmd = 'TS_merge_preNeXus.sh ' + translation_file + ' ' + stagingArea
;;             text = '-> Merging xml files: ' + cmd + ' ... ' + PROCESSING
;;             AppendMyLogBook, Event, text
;;             spawn, cmd, listening, err_listening01
;;             IF (err_listening01[0] NE '') THEN BEGIN
;;                 putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
;;                 AppendMyLogBook, Event, '-> ERROR'
;;                 AppendMyLogBook, Event, err_listening01
;;             ENDIF ELSE BEGIN
;;                 putTextAtEndOfMyLogBook, Event, OK, PROCESSING

;;                 cmd = 'nxtranslate ' + instrument + '_' + RunNumber + '.nxt'
;;                 text = '-> Translate file: ' + cmd + ' ... ' + PROCESSING
;;                 AppendMyLogBook, Event, text
;;                 spawn, cmd, listening, err_listening02
;;                 IF (err_listening02[0] NE '') THEN BEGIN
;;                     putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
;;                     AppendMyLogBook, Event, '-> ERROR'
;;                     AppendMyLogBook, Event, err_listening02
;;                 ENDIF ELSE BEGIN
;;                     putTextAtEndOfMyLogBook, Event, OK, PROCESSING
;;                 ENDELSE
;;             ENDELSE
;;         ENDELSE
            
;; ;removing *histo_mapped.dat file
;;         cmd = 'rm ' + base_histo_name
;;         text = '-> Removing base file: ' + cmd + ' ... ' + PROCESSING
;;         AppendMyLogBook, Event, text
;;         spawn, cmd, listening, err_listening02
;;         IF (err_listening02[0] NE '') THEN BEGIN
;;             putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
;;             AppendMyLogBook, Event, '-> ERROR'
;;             AppendMyLogBook, Event, err_listening
;;         ENDIF ELSE BEGIN
;;             putTextAtEndOfMyLogBook, Event, OK, PROCESSING
;;         ENDELSE
        
;;         p_file_name = base_name + '_p' + strcompress(state_index,/remove_all) + '.dat'
;;         IF (FILE_TEST(p_file_name)) THEN BEGIN ;there is another state
;;             ++state_index 
;;         ENDIF ELSE BEGIN
;;             another_state=0
;;         ENDELSE

;;     ENDWHILE
        
;; ENDIF ELSE BEGIN
;;     putTextAtEndOfMyLogBook, Event, 'NO', PROCESSING
;;     message = '> Merging and Translation ........ ' + PROCESSING
;;     AppendLogBook, Event, message


pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end

pro mfn_eventcb, event
end

