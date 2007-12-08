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
    result=isPreNexusExist(Event, RunNumber, Instrument)
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




PRO output_path2, Event ;in mfn_eventcb.pro
title = 'Select a Second Directory where the NeXus will be copied'
Instrument = getInstrument(Event)
path  = '/SNS/' + Instrument + '/'
OutputPath2 = DIALOG_PICKFILE(TITLE             = title,$
                             PATH              = path,$
                             /MUST_EXIST,$
                             /DIRECTORY)
IF (OutputPath2 NE '') THEN BEGIN
    putOutputPath2, Event, OutputPath2
ENDIF
END



PRO validateOrNotGoButton, Event
RunNumber = getRunNumber(Event)
outputPath = getOutputPath(Event)
IF (RunNumber NE '' AND $
    RunNumber NE 0  AND $
    outputPath NE '') THEN BEGIN
    validate_status = 1
ENDIF else begin
    validate_status = 0
ENDELSE
;validate go button
validateCreateNexusButton, Event, validate_status
END



PRO validateOrNotSecondPath, Event
Instrument = getInstrument(Event)
IF (Instrument NE '') THEN BEGIN
    validate_status = 1
ENDIF else begin
    validate_status = 0
ENDELSE
;validate or notsecond path
validateOuputPath2, Event,validate_status
END



PRO CreateNexus, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).FAILED
NbrSteps   = strcompress(3,/remove_all)

putMyLogBook, Event, '############ GENERAL VARIABLE #############'

;get RunNumber
RunNumber = getRunNumber(Event)
AppendMyLogBook, Event, 'Run Number     : ' + RunNumber
;get instrument
instrument = getInstrument(Event)
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
message = '>(1/'+NbrSteps+') Creating Histo. Mapped Files ... ' + processing
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
message = '>(2/'+NbrSteps+') Importing staging files ........ ' + processing
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

   putTextAtEndOfMyLogBook, Event, 'YES', PROCESSING
   AppendMyLogBook, Event, '=> Entering the multi-polarization states mode'
   message += '(Multi-Polarization): ... ' + PROCESSING
   appendLogBook, Event, message

ENDIF ELSE BEGIN
 
   putTextAtEndOfMyLogBook, Event, 'NO', PROCESSING
   AppendMyLogBook, Event, ''
   AppendMyLogBook, Event, 'Working with the normal mode (no multi-polarization states)'
   message += '(Normal): .... ' + PROCESSING
   appendLogBook, Event, message

;change name of histo from <instr>_<run_number>_neutron_histo.dat to
;<instr>_<run_number>_neutron_histo_mapped.dat
   AppendMyLogBook, Event, '-> Renaming main *_histo.dat file into *_histo_mapped.dat'
   cmd = 'mv ' + base_ext_name + ' ' + base_histo_name
   cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
   AppendMyLogBook, Event, cmd_text
;   spawn, cmd, listening, renaming_error
   renaming_error = '' ;REMOVE_ME
   IF (renaming_error[0] NE '') THEN BEGIN ;a problem in the renaming occured
      putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
      AppendMyLogBook, Event, err_listening
      ;jump to end of full process and display error in LogBook
      ;?????????????????????????
   ENDIF ELSE BEGIN
      putTextAtEndOfMyLogBook, Event, OK, PROCESSING
   ENDELSE
   
;merging xml files
   AppendMyLogBook, Event, '-> Merging the xml files:'
   cmd = 'TS_merge_preNeXus.sh ' + translation_file + ' ' + geometry_file + ' ' + stagingArea
   cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
   AppendMyLogBook, Event, cmd_text
;spawn, cmd, listening, merging_error
   merging_error = ''                  ;REMOVE_ME
   IF (merging_error[0] NE '') THEN BEGIN ;a problem in the merging occured
      putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
      AppendMyLogBook, Event, err_listening
      ;jump to end of full process and display error in LogBook
      ;?????????????????????????
   ENDIF ELSE BEGIN
      putTextAtEndOfMyLogBook, Event, OK, PROCESSING
   ENDELSE

;translating the file
   AppendMyLogBook, Event, '-> Translating the files:'
   TranslationFile = stagingArea + '/' + instrument + '_' + RunNumber + '.nxt'
   AppendMyLogBook, Event, ' Translation file: ' + TranslationFile 
   cmd = 'nxtranslate ' + TranslationFile + ' --hdf5'
   cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
   AppendMyLogBook, Event, cmd_text
;spawn, cmd, listening, translation_error
   translation_error = ''                  ;REMOVE_ME
   IF (translation_error[0] NE '') THEN BEGIN ;a problem in the translation occured
      putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
      AppendMyLogBook, Event, err_listening
      ;jump to end of full process and display error in LogBook
      ;?????????????????????????
   ENDIF ELSE BEGIN
      putTextAtEndOfMyLogBook, Event, OK, PROCESSING
   ENDELSE
   
;move final nexus file into predefined location(s)
;moving the final nexus file created
   AppendMyLogBook, Event, '-> Moving the NeXus file:'
   NexusFile = stagingArea + '/' + instrument + '_' + RunNumber + '.nxs'
   AppendMyLogBook, Event, ' NeXus file: ' + NexusFile
;get destination folders

;; cmd = 'nxtranslate ' + TranslationFile + ' --hdf5'
;;    cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
;;    AppendMyLogBook, Event, cmd_text
;; ;spawn, cmd, listening, translation_error
;;    translation_error = ''                  ;REMOVE_ME
;;    IF (translation_error[0] NE '') THEN BEGIN ;a problem in the translation occured
;;       putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
;;       AppendMyLogBook, Event, err_listening
;;       ;jump to end of full process and display error in LogBook
;;       ;?????????????????????????
;;    ENDIF ELSE BEGIN
;;       putTextAtEndOfMyLogBook, Event, OK, PROCESSING
;;    ENDELSE
   
   
ENDELSE ;end of normal mode (no polarization)

IF (TranslationError EQ 1) THEN BEGIN
   putTextAtEndOfLogBook, Event, FAILED, PROCESSING
ENDIF ELSE BEGIN
   putTextAtEndOfLogBook, Event, OK, PROCESSING
ENDELSE
   
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

;; ENDELSE










;; END
















pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end

pro mfn_eventcb, event
end

