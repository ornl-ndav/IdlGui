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

putMyLogBook, Event, '#### DEBUGGING TOOL ####'

;get RunNumber
RunNumber = getRunNumber(Event)
AppendMyLogBook, Event, 'Run Number: ' + RunNumber
;get instrument
instrument = getInstrument(Event)
AppendMyLogBook, Event, 'Instrument: ' + Instrument
;get prenexus path
prenexus_path  = (*global).prenexus_path
AppendMyLogBook, Event, 'Prenexus_path : ' + prenexus_path
;create base file name
base_file_name = prenexus_path + '/' + instrument + '_' + RunNumber
;staging area
stagingArea = (*global).staging_folder

;####### run the runmp_flags tool first ######
message = '>Creating Histo. Mapped Files ... ' + processing
appendLogBook, Event, message
cmd = 'runmp_flags ' + base_file_name + ' -a ' + stagingArea
cmd_text = 'Creating Histo Mapped Files : ' + cmd
AppendMyLogBook, Event, cmd_text
;spawn, cmd, listening, err_listening       ;remove_me
err_listening = '' ;remove_me
IF (err_listening[0] NE '') THEN BEGIN
    AppendMyLogBook, Event, '-> ERROR'
    AppendMyLogBook, Event, err_listening
    putTextAtEndOfLogBook, Event, FAILED, PROCESSING
ENDIF ELSE BEGIN
    putTextAtEndOfLogBook, Event, OK, PROCESSING
    AppendMyLogBook, Event, '... DONE'
ENDELSE

;###### Copy the prenexus file into stagging area ######
message = '>Importing staging files ... ' + processing
appendLogBook, Event, message
;importing beamtime and cvlist
cmd = 'cp ' + prenexus_path + '/../*.xml ' + stagingArea
cmd_text = 'Importing beamtime and cvlist xml files: ' + cmd
AppendMyLogBook, Event, cmd_text
;spawn, cmd, listening,err_listening1 ;remove_me
err_listening1 = ''
IF (err_listening1[0] NE '') THEN BEGIN
    AppendMyLogBook, Event, '-> ERROR'
    AppendMyLogBook, Event, err_listening
ENDIF ELSE BEGIN
    AppendMyLogBook, Event, '... DONE'
ENDELSE

;importing other xml files
cmd = 'cp ' + prenexus_path + '/*.xml ' + stagingArea
cmd_text = 'Importing cvinfo and runinfo xml files: ' + cmd
AppendMyLogBook, Event, cmd_text
;spawn, cmd, listening,err_listening2
err_listening2 = ''
IF (err_listening[0] NE '') THEN BEGIN
    AppendMyLogBook, Event, '-> ERROR'
    AppendMyLogBook, Event, err_listening
ENDIF ELSE BEGIN
    AppendMyLogBook, Event, '... DONE'
ENDELSE

;##### get the geometry file from its location
text = 'Importing geometry and translation files: '
AppendMyLogBook, Event, text
text = '-> Get up to date geometry and translation files:'
AppendMyLogBook, Event, text
file_array = get_up_to_date_geo_tran_file(instrument)
geometry_file    = file_array[0]
translation_file = file_array[1]
text = '--> geometry file is: ' + geometry_file
AppendMyLogBook, Event, text
text = '--> translation file is: ' + translation_file
AppendMyLogBook, Event, text
text = '-> Copy geometry and translation files in staging area:'
AppendMyLogBook, Event, text
cmd = 'cp ' + geometry_file + ' ' + translation_file + ' ' + stagingArea
cmd_text = '> ' + cmd
AppendMyLogBook, Event, cmd_text
;spawn, cmd, listening, err_listening3
err_listening3 = ''
IF (err_listening3[0] NE '') THEN BEGIN
    AppendMyLogBook, Event, '-> ERROR'
    AppendMyLogBook, Event, err_listening
ENDIF ELSE BEGIN
    AppendMyLogBook, Event, '... DONE'
ENDELSE

IF (err_listening1[0] NE '' AND $
    err_listening2[0] NE '' AND $
    err_listening3[0] NE '') THEN BEGIN
    putTextAtEndOfLogBook, Event, FAILED, PROCESSING
ENDIF ELSE BEGIN
    putTextAtEndOfLogBook, Event, OK, PROCESSING
ENDELSE

;if there is more that 1 histo, rename first one
base_name = stagingArea + '/'+ instrument + '_' + RunNumber
base_name += '_neutron_histo'
base_histo_name = base_name + '_mapped.dat'
p0_file_name = base_name + '_p0.dat'
text = 'Checking if p0 state file exist: ' + p0_file_name + ' ... ' + PROCESSING
AppendMyLogBook, Event, text
IF (FILE_TEST(p0_file_name)) THEN BEGIN ;multi_polarization state
    putTextAtEndOfMyLogBook, Event, 'YES', PROCESSING
    message = '>Working on Multi Polarization States Files:'
    AppendLogBook, Event, message

    another_state = 1
    state_index   = 0
    p_file_name   = p0_file_name
    WHILE (another_state) DO BEGIN
        
        cmd = 'mv ' + p_file_name + ' ' + base_histo_name
        cmd_text = '--> ' + cmd_text
        text = '->Renaming p' + strcompress(state_index,/remove_all)
        text += ' state : ' + cmd_text + ' ... ' + PROCESSING
        AppendMyLogBook, Event, text    
        spawn, cmd, listening, err_listening0
        IF (err_listening0[0] NE '') THEN BEGIN
            putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
        ENDIF ELSE BEGIN
            putTextAtEndOfMyLogBook, Event, OK, PROCESSING

            cmd = 'TS_merge_preNeXus.sh ' + translation_file + ' ' + stagingArea
            text = '->Merging xml files: ' + cmd + ' ... ' + PROCESSING
            AppendMyLogBook, Event, text
            spawn, cmd, listening, err_listening01
            IF (err_listening01[0] NE '') THEN BEGIN
                putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
                AppendMyLogBook, Event, '-> ERROR'
                AppendMyLogBook, Event, err_listening01
            ENDIF ELSE BEGIN
                putTextAtEndOfMyLogBook, Event, OK, PROCESSING

                cmd = 'nxtranslate ' + instrument + '_' + RunNumber + '.nxt'
                text = '->Translate file: ' + cmd + ' ... ' + PROCESSING
                AppendMyLogBook, Event, text
                spawn, cmd, listening, err_listening02
                IF (err_listening02[0] NE '') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
                    AppendMyLogBook, Event, '-> ERROR'
                    AppendMyLogBook, Event, err_listening02
                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, OK, PROCESSING
                ENDELSE
            ENDELSE
        ENDELSE
            
;removing *histo_mapped.dat file
        cmd = 'rm ' + base_histo_name
        text = '->Removing base file: ' + cmd + ' ... ' + PROCESSING
        AppendMyLogBook, Event, text
        spawn, cmd, listening, err_listening02
        IF (err_listening02[0] NE '') THEN BEGIN
            putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
            AppendMyLogBook, Event, '-> ERROR'
            AppendMyLogBook, Event, err_listening
        ENDIF ELSE BEGIN
            putTextAtEndOfMyLogBook, Event, OK, PROCESSING
        ENDELSE
        
        p_file_name = base_name + '_p' + strcompress(state_index,/remove_all) + '.dat'
        IF (FILE_TEST(p_file_name)) THEN BEGIN ;there is another state
            ++state_index 
        ENDIF ELSE BEGIN
            another_state=0
        ENDELSE

    ENDWHILE
        
ENDIF ELSE BEGIN
    putTextAtEndOfMyLogBook, Event, 'NO', PROCESSING
    message = '>Merging and Translation ... ' + PROCESSING
    AppendLogBook, Event, message

ENDELSE










END
















pro MAIN_REALIZE, wWidget
tlb = get_tlb(wWidget)
;indicate initialization with hourglass icon
widget_control,/hourglass
;turn off hourglass
widget_control,hourglass=0
end

pro mfn_eventcb, event
end

