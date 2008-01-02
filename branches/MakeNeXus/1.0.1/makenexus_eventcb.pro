PRO checkNumberSteps, Event, prenexus_full_path, RunNumber, Instrument
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
runinfoFullPath             = prenexus_full_path + '/' + Instrument
runinfoFullPath            += '_' + strcompress(RunNumber,/remove_all)
runinfoFullPath            += (*global).runinfo_ext
NbrPolaStates = getNbrPolaState(Event, runinfoFullPath)
IF (NbrPolaStates EQ 0) THEN BEGIN
    (*global).NbrPhase = 4
ENDIF ELSE BEGIN
    (*global).NbrPhase = NbrPolaStates * 5
ENDELSE
END

;this function will check if the prenexus can be found
PRO run_number, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
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
            ;check the number of steps it will have
            checkNumberSteps, Event, (*global).prenexus_path, RunNumber, Instrument
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



FUNCTION CreateNexus, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;define progress bar object
progressBar = Obj_New("SHOWPROGRESS", $
                      Xoffset=(*global).MainBaseXoffset+ 200, $
                      Yoffset=(*global).MainBaseYoffset + 50, $
                      /CancelButton)
progressBar->SetColor, 250
progressBar->SetLabel, 'Translation in progress ...'
progressBar->Start

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
             nxtTranslationFile : '',$
             phase            : 1,$
             NbrPhase         : 0.0,$
             base_name        : '',$
             base_ext_name    : '',$
             base_histo_name  : '',$
             p0_file_name     : '',$
             p0_mapped_file_name : '',$
             pre_nexus_name   : '',$ ;REF_M_2967.nxs
             nexus_file_name  : '',$ ;REF_M_2967_p#.nxs
             base_nexus       : '',$
             ShortNexusName   : '',$
             anotherState     : 0,$
             polaIndex        : 0,$
             NexusToMove      : ptr_new(0L),$
             ShortNexusToMove : ptr_new(0L),$
             multi_pola_state : 0,$
             NexusFile        : '',$
             output_path      : '',$
             InstrSharedFolder : '',$
             proposalNumber    : '',$
             proposalSharedFolder : '',$
             nexus_folder     : '',$
             preNeXus_folder  : '',$
             currentPolaStateFileName       : '',$
             currentMappedPolaStateFileName : '' }

CNstruct.NbrPhase = (9. + 6. + float((*global).NbrPhase))/100

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
text = '> Checking if p0 state file exist: ' + CNstruct.p0_mapped_file_name $
  + ' or ' + CNstruct.p0_file_name + ' ... ' + CNstruct.PROCESSING
AppendMyLogBook, Event, text
TranslationError = 0 ;by default, everything is going to run smoothly
IF (!VERSION.os NE 'darwin' AND $
    (FILE_TEST(CNstruct.p0_mapped_file_name) OR $
     FILE_TEST(CNstruct.p0_file_name))) THEN BEGIN ;multi_polarization state
    
    CNStruct.multi_pola_state = 1 ;we are working with the multi_polarization state
    putTextAtEndOfMyLogBook, Event, 'YES', CNstruct.PROCESSING
    AppendMyLogBook, Event, '=> Entering the multi-polarization state mode'
    AppendMyLogBook, Event, ''
    message += '(Multi-Polarization): ... ' + CNstruct.PROCESSING
    appendLogBook, Event, message
    
 ;work on first polarization state
    CNstruct.polaIndex    = 0
    CNstruct.anotherState = 1
    WHILE (CNstruct.anotherState) DO BEGIN
        message = '-> Polarization state file #' + $
          strcompress(CNstruct.polaIndex,/remove_all)
        CNstruct.CurrentPolaStateFileName = CNstruct.base_name + '_p' + $
          strcompress(CNstruct.PolaIndex,/remove_all) + '.dat'
        CNstruct.CurrentMappedPolaStateFileName = CNstruct.base_name + '_p' + $
          strcompress(CNstruct.PolaIndex,/remove_all) + '_mapped.dat'
        message += ' is: ' + CNstruct.CurrentMappedPolaStateFileName
        message += ' or ' + CNstruct.CurrentPolaStateFileName
        AppendMyLogBook, Event, message
        
;renaming file into generic histogram mapped file
        error_status = MultiPola_renamingHistoFile(Event,CNstruct)
        IF (error_status) THEN GOTO, ERROR
        IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1 ;phase

;merging xml files
        error_status = MultiPola_mergingFile(Event,CNstruct)
        IF (error_status) THEN GOTO, ERROR
        IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1 ;phase
        
;translating the file
        error_status = MultiPola_translatingFile(Event,CNstruct)
        IF (error_status) THEN GOTO, ERROR
        IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1 ;phase

;renaming nexus file
        error_status = MultiPola_renamingFile(Event,CNstruct)
        IF (error_status) THEN GOTO, ERROR
        IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1 ;phase

;checking if there is another pola. (check if nexus exist)
        ++CNstruct.polaIndex
        file_name = CNstruct.base_name + '_p' + $
          strcompress(CNstruct.PolaIndex,/remove_all) + '.dat'
        file_name_mapped = CNstruct.base_name + $
          '_p' + strcompress(CNstruct.PolaIndex,/remove_all) + '_mapped.dat'
        IF (FILE_TEST(file_name) OR FILE_TEST(file_name_mapped)) THEN BEGIN
            CNstruct.anotherState = 1    ;YES, CONTINUE
        ENDIF ELSE BEGIN
            CNstruct.anotherState = 0    ;NO, STOP NOW
        ENDELSE
        AppendMyLogBook, Event, ''

        IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1 ;phase

    ENDWHILE
    
ENDIF ELSE BEGIN
    
    SinglePola_message, Event, CNstruct
    message += '(Normal): ............... ' + CNstruct.PROCESSING
    appendLogBook, Event, message
    IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1
    
;renaming histo.dat file
    error_status = SinglePola_renaimingHistoFile(Event,CNstruct)
    IF (error_status) THEN GOTO, ERROR
    IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1
    
;merging xml fIles
    error_status = SinglePola_mergingXmlFiles(Event,CNstruct)
    IF (error_status) THEN GOTO, ERROR
    IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1
    
;translating the file
    error_status = SinglePola_translatingFiles(Event,CNstruct)
    IF (error_status) THEN GOTO, ERROR
    IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1
    
ENDELSE                         ;end of normal mode (no polarization)

;display translation status in log book (ok if we reach that point)
putTextAtEndOfLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;move nexus to final location
MovingNexusFileMessage, Event, CNstruct
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;get destination folders
GetDestinationFolder, Event, CNstruct
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;get instrument Shared Folder
getInstrumentSharedFolder, Event, CNstruct
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;Proposal Shared Folder
getProposalSharedFolder, Event, CNstruct
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

;Move files
text = ['']
error_status = MovingFiles(Event,CNstruct,text)
IF (error_status) THEN GOTO, ERROR
putTextAtEndOfLogBook, Event, CNstruct.OK, CNstruct.PROCESSING ;moving files worked
AppendLogBook, Event, text
IF (UpdateProgressBar(CNstruct,progressBar)) THEN GOTO, ERROR1

progressBar->Destroy
Obj_Destroy, progressBar

return, 1

;GOTO

error: BEGIN
    putTextAtEndOfLogBook, Event, CNstruct.FAILED, CNstruct.PROCESSING 
    validateCreateNexusButton, Event, 0
    progressBar->Destroy
    Obj_Destroy, progressBar
    return, 0
END

error1: BEGIN
    AppendMyLogBook, Event, ''
    AppendMyLogBook, Event, '*** TRANSLATION PROCESS HAS BEEN INTERRUPTED BY USER ***'
    appendLogBook, Event, ''
    appendLogBook, Event, '*** TRANSLATION PROCESS HAS BEEN INTERRUPTED BY USER ***'
    validateCreateNexusButton, Event, 1
    progressBar->Destroy
    Obj_Destroy, progressBar
    return, 0
END

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

