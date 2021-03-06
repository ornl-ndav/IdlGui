;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

PRO DefineGeneralVariablePart1, Event, CNstruct

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

AppendMyLogBook, Event, '############ GENERAL VARIABLES #############'

;get RunNumber
RunNumber          = (*global).RunNumber
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



;##############################################################################
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
    AppendMyLogBook, Event, '-> Checking if staging folder (' + stagingArea + $
      ') exists:'
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
        AppendMyLogBook, Event, '--> Folder does not exist and needs to ' + $
          'be created'
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



;##############################################################################



FUNCTION RunmpFlags, Event, CNstruct, TRY_NBR=try_nbr

;retrieving parameters
instrument     = CNstruct.instrument
processing     = CNstruct.processing
failed         = CNstruct.failed
ok             = CNstruct.ok
stagingArea    = CNstruct.stagingArea
base_file_name = CNstruct.base_file_name
NbrSteps       = CNstruct.NbrSteps

;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global
error_status = 0

;name of event file
event_file = base_file_name + '_neutron_event.dat'

IF (N_ELEMENTS(TRY_NBR) EQ 0) THEN BEGIN
    message = '>(1/'+NbrSteps+') Creating Histo. ' + $
      'Mapped Files .............. ' + $
      processing
appendLogBook, Event, message
ENDIF
cmd = (*global).Event_to_Histo_Mapped 
cmd += ' -a ' + stagingArea + ' ' + event_file

;total number of pixels
TotalNbrPixel = getTotalNbrPixel(base_file_name)
cmd += ' -p ' + STRCOMPRESS(TotalNbrPixel,/REMOVE_ALL)

cmd += ' --combine_states'
cmd += ' --num_states ' + STRCOMPRESS((*global).NbrPolaStates,/REMOVE_ALL)

;BinningType
IF (getBinType(Event) EQ 0) THEN BEGIN ;linear
    cmd += ' -l ' 
ENDIF ELSE BEGIN
    cmd += ' -L '
ENDELSE
cmd += getBinWidth(Event)

;Binning offset
cmd += ' --time_offset ' + getBinOffset(Event)

;max time
cmd += ' --max_time_bin ' + getBinMax(Event)

IF (!VERSION.os EQ 'darwin') THEN BEGIN

    geometry_file             = (*global).mac.geometry_file
    CNstruct.geometry_file    = geometry_file
    translation_file          = (*global).mac.translation_file
    CNstruct.translation_file = translation_file
    mapping_file              = (*global).mac.mapping_file
    CNstruct.mapping_file     = mapping_file
    
    cmd += ' --mapping ' + mapping_file
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

    cmd += ' --mapping ' + mapping_file
    cmd_text = 'PHASE 1/' + Nbrsteps + ': CREATE HISTOGRAM'
    AppendMyLogBook, Event, cmd_text
    cmd_text = '> Creating Histo Mapped Files: '
    AppendMyLogBook, Event, cmd_text
    cmd_text = 'cmd: ' + cmd + ' ... ' + PROCESSING
    AppendMyLogBook, Event, cmd_text
    spawn, cmd, listening, err_listening
    IF (err_listening[0] NE '' OR $ ;failed
        listening[0] EQ '') THEN BEGIN
        putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
        AppendMyLogBook, Event, err_listening
;try the same thing but with only 1 pola state (just in case) for
;REF_M only
        IF (instrument EQ 'REF_M') THEN BEGIN
            IF (N_ELEMENTS(TRY_NBR) EQ 0) THEN BEGIN
                (*global).NbrPolaStates = 1
                error_status = RunmpFlags(Event, CNstruct, TRY_NBR=2)
                putTextAtEndOfLogBook, Event, FAILED, PROCESSING
            ENDIF ELSE BEGIN
                error_status =1
            ENDELSE
        ENDIF ELSE BEGIN
            error_status = 1
            putTextAtEndOfLogBook, Event, FAILED, PROCESSING
        ENDELSE
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, OK, PROCESSING
        putTextAtEndOfLogBook, Event, OK, PROCESSING
    ENDELSE
ENDELSE
RETURN, error_status
END

;##############################################################################

FUNCTION CopyPreNexus, Event,CNstruct

;retrieving parameters
processing    = CNstruct.processing
ok            = CNstruct.ok
failed        = CNstruct.failed
NbrSteps      = CNstruct.NbrSteps
stagingArea   = CNstruct.stagingArea
prenexus_path = CNstruct.prenexus_path

error_status = 0
message = '>(2/'+NbrSteps+') Importing staging files ................... ' + $
  processing
appendLogBook, Event, message
appendMyLogBook, Event, ''
AppendMyLogBook, Event, 'PHASE 2/' + NbrSteps + ': IMPORT FILES'
;importing beamtime and cvlist
cmd  = 'cp ' + prenexus_path + '/../*.xml '
cmd += prenexus_path + '/*_bmon*.dat ' + stagingArea
cmd_text = '> Importing beamtime, cvlist xml and monitor files: '
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

;##############################################################################

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

;##############################################################################

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

;##############################################################################

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

;##############################################################################

PRO DefineGeneralVariablePart2, Event, CNstruct

;if there is more that 1 histo, rename first one
CNstruct.ShortNexusName = CNStruct.instrument + '_' + CNStruct.RunNumber
CNstruct.base_name = CNstruct.stagingArea + '/'+ CNstruct.ShortNexusName
CNstruct.base_nexus = CNstruct.base_name 
CNstruct.base_name += '_neutron_histo'
CNstruct.base_ext_name = CNstruct.base_name + '.dat'
CNstruct.base_histo_name = CNstruct.base_name + '_mapped.dat'
;CNstruct.p0_mapped_file_name = CNstruct.base_name + '_p0_mapped.dat'
;CNstruct.p0_file_name        = CNstruct.base_name + '_p0.dat'
AppendMyLogBook, Event, '-> base_name           : ' + CNstruct.base_name
AppendMyLogBook, Event, '-> base_ext_name       : ' + CNstruct.base_ext_name
AppendMyLogBook, Event, '-> base_histo_name     : ' + CNstruct.base_histo_name
;AppendMyLogBook, Event, '-> p0_file_name        : ' + CNstruct.p0_file_name
;AppendMyLogBook, Event, '-> p0_mapped_file_name : ' + $
;  CNstruct.p0_mapped_file_name
AppendMyLogBook, Event, '-> base_nexus          : ' + CNstruct.base_nexus
AppendMyLogBook, Event, '-> ShortNexusName      : ' + CNstruct.ShortNexusName
AppendMyLogBook, Event, ''
END

;##############################################################################

FUNCTION MultiPola_renamingHistoFile, Event, CNstruct
error_status = 0
message = '--> Rename file into generic histogram mapped file name (' 
IF (FILE_TEST(CNstruct.CurrentMappedPolaStateFileName)) THEN BEGIN
    message += CNstruct.CurrentMappedPolaStateFileName
    currentFile = CNStruct.CurrentMappedPolaStateFileName
ENDIF ELSE BEGIN
    message += CNstruct.CurrentPolaStateFileName
    currentFile = CNStruct.CurrentPolaStateFileName
ENDELSE
message += '):'
AppendMyLogBook, Event, message
cmd = 'mv ' + currentFile + ' ' + CNstruct.base_histo_name
cmd_text = 'cmd: ' + cmd
spawn, cmd, listening, err_listening
IF (err_listening[0] EQ '') THEN BEGIN
    message = cmd + ' ... OK'
ENDIF ELSE BEGIN
    message = cmd + ' ... FAILED'
    error_status = 1
ENDELSE
AppendMyLogBook, Event, message
AppendMyLogBook, Event, ''
RETURN, error_status
END

;##############################################################################

FUNCTION MultiPola_mergingFile, Event, CNstruct

AppendMyLogBook, Event, '--> Merging the xml files:'
cmd = 'TS_merge_preNeXus.sh ' + CNstruct.translation_file + ' ' $
  + CNstruct.geometry_file + ' ' + CNstruct.stagingArea
cmd_text = 'cmd: ' + cmd + ' ... ' + CNstruct.PROCESSING
AppendMyLogBook, Event, cmd_text
spawn, cmd, listening, merging_error
;.nxt file should be
nxt_file_name  = CNstruct.stagingArea + '/' + CNstruct.instrument
nxt_file_name += '_' + CNstruct.RunNumber + '.nxt'
IF (strmatch(merging_error[0],'*java.lang.Error*') OR $
    ~FILE_TEST(nxt_file_name)) THEN BEGIN 
;problem during merging
    putTextAtEndOfMyLogBook, Event, CNstruct.FAILED, CNstruct.PROCESSING
    AppendMyLogBook, Event, listening
    AppendMyLogBook, Event, merging_error
    error_status = 1
ENDIF ELSE BEGIN
    putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
    error_status = 0
ENDELSE
AppendMyLogBook, Event, ''
RETURN, error_status
END

;##############################################################################

FUNCTION MultiPola_translatingFile, Event, CNstruct

AppendMyLogBook, Event, '--> Translating the files:'
CNstruct.nxtTranslationFile = CNstruct.stagingArea + '/' + $
  CNstruct.instrument $
  + '_' + CNstruct.RunNumber + '.nxt'
AppendMyLogBook, Event, ' Translation file: ' + CNstruct.nxtTranslationFile
cmd = 'nxtranslate ' + CNstruct.nxtTranslationFile + ' --hdf5 '
cmd_text = 'cmd: ' + cmd + ' ... ' + CNstruct.PROCESSING
AppendMyLogBook, Event, cmd_text
;move to staging area
CD, CNstruct.stagingArea
spawn, cmd, listening, translation_error
IF (translation_error[0] NE '') THEN BEGIN 
;a problem in the translation occured
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

;##############################################################################

FUNCTION MultiPola_renamingFile, Event, CNstruct

AppendMyLogBook, Event, '--> Renaming Nexus file:'
CNstruct.pre_nexus_name  = CNstruct.base_nexus + '.nxs'
CNstruct.nexus_file_name = CNstruct.base_nexus + '_p' + $
  strcompress(CNstruct.PolaIndex,/remove_all) + '.nxs'
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
    *CNstruct.NexusToMove = [CNstruct.nexus_file_name]
    *CNstruct.ShortNexusToMove = [CNstruct.ShortNexusName + '_p0.nxs']
    *CNstruct.ShortNewNexus = ['']
ENDIF ELSE BEGIN
    *CNstruct.NexusToMove = [*CNstruct.NexusToMove,CNstruct.nexus_file_name]
    *CNstruct.ShortNexusToMove = [*CNstruct.ShortNexusToMove, $
                                  CNstruct.ShortNexusName + '_p' + $
                                  strcompress(CNstruct.polaIndex,/remove_all) $
                                  + '.nxs']
    *CNstruct.ShortNewNexus = [*CNstruct.ShortNewNexus,'']
ENDELSE
RETURN, error_status
END

;##############################################################################

PRO SinglePola_message, Event, CNstruct

CNstruct.multi_pola_state = 0            ;we are working in normal mode
;putTextAtEndOfMyLogBook, Event, 'NO', CNstruct.PROCESSING
;AppendMyLogBook, Event, ''

END

;##############################################################################

;change name of histo from <instr>_<run_number>_neutron_histo.dat to
;<instr>_<run_number>_neutron_histo_mapped.dat
;check that histo_mapped is not there already
FUNCTION SinglePola_renaimingHistoFile, Event,CNstruct
error_status = 0
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    AppendMyLogBook, Event, '-> Renaming main *_histo.dat file into' + $
      ' *_histo_mapped.dat'
    cmd = 'mv ' + CNstruct.base_ext_name + ' ' + CNstruct.base_histo_name
    cmd_text = 'cmd: ' + cmd + ' ... ' + CNstruct.PROCESSING
    AppendMyLogBook, Event, cmd_text
    putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
ENDIF ELSE BEGIN
    IF (~FILE_TEST(CNstruct.base_histo_name)) THEN BEGIN
        AppendMyLogBook, Event, '-> Renaming main *_histo.dat file ' + $
          'into *_histo_mapped.dat'
        cmd = 'mv ' + CNstruct.base_ext_name + ' ' + CNstruct.base_histo_name
        cmd_text = 'cmd: ' + cmd + ' ... ' + CNstruct.PROCESSING
        AppendMyLogBook, Event, cmd_text
        spawn, cmd, listening, renaming_error
        IF (renaming_error[0] NE '') THEN BEGIN $
;a problem in the renaming occured
            putTextAtEndOfMyLogBook, Event, CNstruct.FAILED, $
              CNstruct.PROCESSING
            AppendMyLogBook, Event, renaming_error
            error_status = 1
        ENDIF ELSE BEGIN
            putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
        ENDELSE
    ENDIF ELSE BEGIN
        AppendMyLogBook, Event, '-> final histo_mapped file name ' + $
          'is already there (*_histo_mapped.dat)'
    ENDELSE

ENDELSE
AppendMyLogBook, Event, ''
RETURN, error_status
END

;##############################################################################

FUNCTION SinglePola_mergingXmlFiles, Event, CNstruct
WIDGET_CONTROL,Event.top,GET_UVALUE=global
error_status = 0
AppendMyLogBook, Event, '-> Merging the xml files:'
cmd = (*global).tsmerge_link + ' ' + CNstruct.translation_file + ' ' + $
  CNstruct.geometry_file + ' ' $
  + CNstruct.stagingArea
cmd_text = 'cmd: ' + cmd + ' ... ' + CNstruct.PROCESSING
AppendMyLogBook, Event, cmd_text
;.nxt file should be
nxt_file_name  = CNstruct.stagingArea + '/' + CNstruct.instrument
nxt_file_name += '_' + CNstruct.RunNumber + '.nxt'
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
ENDIF ELSE BEGIN
    spawn, cmd, listening, merging_error
    IF (strmatch(merging_error[0],'*java.lang.Error*') OR $
        ~FILE_TEST(nxt_file_name)) THEN BEGIN 
;problem during merging
        putTextAtEndOfMyLogBook, Event, CNstruct.FAILED, CNstruct.PROCESSING
        AppendMyLogBook, Event, merging_error
        error_status = 1
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
    ENDELSE
ENDELSE
AppendMyLogBook, Event, ''
RETURN, error_status
END

;##############################################################################

FUNCTION SinglePola_translatingFiles, Event, CNstruct
error_status = 0
AppendMyLogBook, Event, '-> Translating the files:'
CNstruct.nxtTranslationFile = CNstruct.stagingArea + '/' + $
  CNstruct.instrument $
  + '_' + $
  CNstruct.RunNumber + '.nxt'
AppendMyLogBook, Event, ' Translation file: ' + CNstruct.nxtTranslationFile 
cmd = 'nxtranslate ' + CNstruct.nxtTranslationFile + ' --hdf5'
cmd_text = 'cmd: ' + cmd + ' ... ' + CNstruct.PROCESSING
AppendMyLogBook, Event, cmd_text

IF (!VERSION.os EQ 'darwin') THEN BEGIN
    putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
ENDIF ELSE BEGIN
;move to staging area
    CD, CNstruct.stagingArea
    spawn, cmd, listening, translation_error
    IF (translation_error[0] NE '') THEN BEGIN 
;a problem in the translation occured
        putTextAtEndOfMyLogBook, Event, CNstruct.FAILED, CNstruct.PROCESSING
        AppendMyLogBook, Event, translation_error
        error_status = 1
    ENDIF ELSE BEGIN
        putTextAtEndOfMyLogBook, Event, CNstruct.OK, CNstruct.PROCESSING
    ENDELSE
ENDELSE
AppendMyLogBook, Event, ''
RETURN, error_status
END

;##############################################################################

;move final nexus file(s) into predefined location(s)
PRO MovingNexusFileMessage, Event, CNStruct
message = '>(4/' + CNstruct.NbrSteps + ') Moving NeXus to Final' + $
  ' Location ............ ' + $
  CNstruct.processing
appendLogBook, Event, message
AppendMyLogBook, Event, 'PHASE 4/' + CNstruct.NbrSteps + $
  ': MOVING FILES TO THEIR FINAL LOCATION'
IF (CNstruct.multi_pola_state) THEN BEGIN
    sz = (size(*CNstruct.NexusToMove))(1)
    FOR i=0,(sz-1) DO BEGIN
        message = 'Nexus File #' + strcompress(i,/remove_all) + ': ' $
          + (*CNstruct.NexusToMove)[i]
        AppendMyLogBook, Event, message
    ENDFOR
ENDIF ELSE BEGIN
    CNstruct.NexusFile = CNStruct.stagingArea + '/' + $
      CNstruct.instrument + '_' + CNstruct.RunNumber + '.nxs'
    AppendMyLogBook, Event, ' NeXus file: ' + CNstruct.NexusFile
    *CNstruct.NexusToMove = [CNstruct.NexusFile]
    *CNstruct.ShortNexusToMove = [CNstruct.ShortNexusName + '.nxs']
ENDELSE
AppendMyLogBook, Event, ''
END

;##############################################################################

FUNCTION GetDestinationFolder, Event, CNstruct
;Main output path
CNstruct.output_path = getTextFieldValue(Event, 'output_path_text')
status = 1
IF (CNstruct.output_path NE '') THEN BEGIN
    message = '-> Check if there is a Main Output Path ... YES (' + $
      CNstruct.output_path + ')'
    AppendMyLogBook, Event, message
    message = '--> Check if output path exists ........... ' + $
      CNstruct.PROCESSING
    AppendMyLogBook, Event, message
    IF (!VERSION.os EQ 'darwin') THEN BEGIN
        putTextAtEndOfMyLogBook, Event, 'YES' , CNstruct.PROCESSING
    ENDIF ELSE BEGIN
        IF (FILE_TEST(CNstruct.output_path,/DIRECTORY)) THEN BEGIN
            putTextAtEndOfMyLogBook, Event, 'YES' , CNstruct.PROCESSING
        ENDIF ELSE BEGIN
            putTextAtEndOfMyLogBook, Event, 'NO', CNstruct.PROCESSING
            CNstruct.output_path = ''
            status = 0
        ENDELSE
    ENDELSE
ENDIF ELSE BEGIN
    message = '-> Check if there is a Main Output Path ... NO'
    AppendMyLogBook, Event, message
    status = 0
ENDELSE
AppendMyLogBook, Event, ''
RETURN, status
END

;##############################################################################

FUNCTION CheckDestinationFolder, Event
;Main output path
output_path = getTextFieldValue(Event, 'output_path_text')
status = 1
IF (output_path NE '') THEN BEGIN
    IF (!VERSION.os EQ 'darwin') THEN BEGIN
    ENDIF ELSE BEGIN
        IF (FILE_TEST(output_path,/DIRECTORY)) THEN BEGIN
        ENDIF ELSE BEGIN
            status = 0
        ENDELSE
    ENDELSE
ENDIF ELSE BEGIN
    status = 0
ENDELSE
RETURN, status
END

;##############################################################################

;get instrument Shared Folder
FUNCTION getInstrumentSharedFolder, Event, CNstruct
status = 1
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
            message = '--> Check if Instrument Shared Folder exists ' + $
              '....... YES'
            AppendMyLogBook, Event, message
        ENDIF ELSE BEGIN
            message = '--> Check if Instrument Shared Folder exists ....... NO'
            AppendMyLogBook, Event, message
            CNstruct.InstrSharedFolder = ''
            status = 0
        ENDELSE
    ENDELSE
ENDIF ELSE BEGIN
    message = '-> Check if Instrument Shared Folder is selected ... NO'
    AppendMyLogBook, Event, message
    CNstruct.InstrSharedFolder = ''
    status = 0
ENDELSE
AppendMyLogBook, Event, ''
RETURN, status
END

;##############################################################################

FUNCTION getProposalSharedFolder, Event, CNstruct
status = 1
IF (isProposalSharedFolderSelected(Event)) THEN BEGIN
    CNstruct.proposalNumber = getProposalNumber(Event, CNstruct.prenexus_path)
    CNstruct.ProposalSharedFolder = '/SNS/' + CNstruct.instrument + '/' + $
      CNstruct.proposalNumber
    CNstruct.ProposalSharedFolder += '/shared/'
    message = '-> Check if Proposal Shared Folder is selected ..... YES (' +$
      CNstruct.ProposalSharedFolder + ')'
    AppendMyLogBook, Event, message
    IF (!VERSION.os EQ 'darwin') THEN BEGIN
        message = '--> Check if Proposal Shared Folder exists ' + $
          '......... YES'
            AppendMyLogBook, Event, message        
    ENDIF ELSE BEGIN
        IF (FILE_TEST(CNstruct.ProposalSharedFolder,/DIRECTORY)) THEN BEGIN
            message = '--> Check if Proposal Shared Folder exists ' + $
              '......... YES'
            AppendMyLogBook, Event, message
        ENDIF ELSE BEGIN
            message = '--> Check if Proposal Shared Folder exists ......... NO'
            AppendMyLogBook, Event, message
            CNstruct.ProposalSharedFolder = ''
            status = 0
        ENDELSE
    ENDELSE
ENDIF ELSE BEGIN
    message = '-> Check if Proposal Shared Folder is selected ..... NO'
    AppendMyLogBook, Event, message
    CNstruct.ProposalSharedFolder = ''
    status = 0
ENDELSE
AppendMyLogBook, Event, ''
RETURN, status
END

;##############################################################################

FUNCTION MovingFiles, Event, CNstruct, text
error_status = 0
;move only if at least one of the three path exists
IF (CNstruct.output_path NE '' OR $
    CNstruct.InstrSharedFolder NE '' OR $
    CNstruct.ProposalSharedFolder NE '') THEN BEGIN

    sz = (size(*CNStruct.NexusToMove))(1)
    IF (sz EQ 1) THEN BEGIN     ;only 1 nexus
        message = '-> Moving nexus file:'
        AppendMyLogBook, Event, message
    ENDIF ELSE BEGIN
        message = '-> Moving nexus files:'
        AppendMyLogBook, Event, message
    ENDELSE
    
    text = [text,'#### NEXUS FILES CREATED ####']
    cmd_chmod = 'chmod 666 '
    cmd_chgrp = 'chgrp '
    
    FOR i=0,(sz-1) DO BEGIN
        
        cmd = 'cp ' + (*CNstruct.NeXusToMove)[i] 
        IF (CNstruct.output_path NE '') THEN BEGIN
            
            IF (i EQ 0) THEN BEGIN
                
;output_path/RunNumber/NeXus/nexus/file
;output_path/RunNumber/preNeXus/*.xml
;output_path/RunNumber/preNeXus/*.dat
;output_path/RunNumber/preNeXus/*.nxt
;create NeXus and preNeXus folders
                AppendMyLogBook, Event, 'Iteration #0:'
                CNstruct.NeXus_folder    = CNstruct.output_path + $
                  CNstruct.RunNumber + '/NeXus/'
                CNstruct.preNeXus_folder = CNstruct.output_path + $
                  CNstruct.RunNumber + '/preNeXus/'
                
                AppendMyLogBook, Event, 'Checking if NeXus Folder (' + $
                  CNstruct.NeXus_folder + $
                  ') exists ... ' + CNstruct.PROCESSING
                IF (!VERSION.os EQ 'darwin') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, 'YES', CNstruct.PROCESSING
                    AppendMyLogBook, Event, '-> Remove Content of ' + $
                      'NeXus folder:'
                    cmd_rm = 'rm -f ' + CNstruct.NeXus_folder + '*.nxs'
                    cmd_rm_text = 'cmd: ' + cmd_rm + ' ... ' + $
                      CNstruct.PROCESSING
                    AppendMyLogBook, Event, cmd_rm_text
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                      CNstruct.PROCESSING
                ENDIF ELSE BEGIN
                    IF (FILE_TEST(CNstruct.NeXus_folder,/DIRECTORY)) THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, 'YES', $
                          CNstruct.PROCESSING
                        AppendMyLogBook, Event, '-> Remove Content of ' + $
                          'NeXus folder:'
                        cmd_rm = 'rm -f ' + CNstruct.neXus_folder + '*.nxs'
                        cmd_rm_text = 'cmd: ' + cmd_rm + ' ... ' + $
                          CNstruct.PROCESSING
                        AppendMyLogBook, Event, cmd_rm_text
                        spawn, cmd_rm, listening
                        IF (listening[0] EQ '') THEN BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                              CNstruct.PROCESSING
                        ENDIF ELSE BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
                              CNstruct.PROCESSING
                        ENDELSE
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, 'NO', $
                          CNstruct.PROCESSING
                        cmd_spawn = 'mkdir -p ' + CNstruct.Nexus_folder 
                        AppendMyLogBook, Event, 'Create NeXus folder:'
                        cmd_spawn_text = 'cmd: ' + cmd_spawn + ' ... ' + $
                          CNstruct.PROCESSING
                        AppendMyLogBook, Event, cmd_spawn_text
                        spawn, cmd_spawn, listening
                        IF (listening[0] EQ '') THEN BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                              CNstruct.PROCESSING
                        ENDIF ELSE BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
                              CNstruct.PROCESSING
                        ENDELSE
                    ENDELSE
                    AppendMyLogBook, Event, ''
                ENDELSE
                
                AppendMyLogBook, Event, 'Checking if preNeXus Folder (' + $
                  CNstruct.preNeXus_folder + $
                  ') exists ... ' + CNstruct.PROCESSING
                IF (!VERSION.os EQ 'darwin') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, 'YES', CNstruct.PROCESSING
                    AppendMyLogBook, Event, '-> Remove Content of ' + $
                      'preNeXus folder:'
                    cmd_rm = 'rm -f ' + CNstruct.preNeXus_folder + '*.*'
                    cmd_rm_text = 'cmd: ' + cmd_rm + ' ... ' + $
                      CNstruct.PROCESSING
                    AppendMyLogBook, Event, cmd_rm_text
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                      CNstruct.PROCESSING
                ENDIF ELSE BEGIN
                    IF (FILE_TEST(CNstruct.preNeXus_folder,/DIRECTORY)) THEN $
                      BEGIN
                        putTextAtEndOfMyLogBook, Event, 'YES', $
                          CNstruct.PROCESSING
                        AppendMyLogBook, Event, '-> Remove Content of ' + $
                          'preNeXus folder:'
                        cmd_rm = 'rm -f ' + CNstruct.preNeXus_folder + '*.*'
                        cmd_rm_text = 'cmd: ' + cmd_rm + ' ... ' + $
                          CNstruct.PROCESSING
                        AppendMyLogBook, Event, cmd_rm_text
                        spawn, cmd_rm, listening
                        IF (listening[0] EQ '') THEN BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                              CNstruct.PROCESSING
                        ENDIF ELSE BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
                              CNstruct.PROCESSING
                        ENDELSE
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, 'NO', $
                          CNstruct.PROCESSING
                        cmd_spawn = 'mkdir -p ' + CNstruct.preNexus_folder 
                        AppendMyLogBook, Event, 'Create preNeXus folder:'
                        cmd_spawn_text = 'cmd: ' + cmd_spawn + ' ... ' + $
                          CNstruct.PROCESSING
                        AppendMyLogBook, Event, cmd_spawn_text
                        spawn, cmd_spawn, listening
                        IF (listening[0] EQ '') THEN BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                              CNstruct.PROCESSING
                        ENDIF ELSE BEGIN
                            putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
                              CNstruct.PROCESSING
                        ENDELSE
                    ENDELSE
                    AppendMyLogBook, Event, ''
                ENDELSE
                
;copy *.xml files from prenexus path
                AppendMyLogBook, Event, $
                  'Copy runinfo.xml, cvinfo.xml ... files from ' + $
                  'DAS/preNeXus folder:'
                cmd_xml = 'cp ' + CNstruct.prenexus_path + '/*.xml' $
                  + ' ' + CNstruct.preNeXus_folder
                cmd_xml_text = 'cmd: ' + cmd_xml + ' ... ' + $
                  CNstruct.PROCESSING
                AppendMyLogBook, Event, cmd_xml_text
                IF (!VERSION.os EQ 'darwin') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                      CNstruct.PROCESSING
                ENDIF ELSE BEGIN
                    spawn, cmd_xml, listening
                    IF (listening[0] EQ '') THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                          CNstruct.PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
                          CNstruct.PROCESSING
                    ENDELSE
                ENDELSE
                AppendMyLogBook, Event, ''
                
                AppendMyLogBook, Event, $
                  'Copy beamtimeinfo.xml and cvlist.xml files from ' + $
                  'DAS/preNeXus folder:'
                cmd_xml = 'cp ' + CNStruct.prenexus_path + '/../*.xml' $
                  + ' ' + CNstruct.preNeXus_folder
                cmd_xml_text = 'cmd: ' + cmd_xml + ' ... ' + $
                  CNstruct.PROCESSING
                AppendMyLogBook, Event, cmd_xml_text
                IF (!VERSION.os EQ 'darwin') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                      CNstruct.PROCESSING
                ENDIF ELSE BEGIN
                    spawn, cmd_xml, listening
                    IF (listening[0] EQ '') THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                          CNstruct.PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
                          CNstruct.PROCESSING
                    ENDELSE
                ENDELSE
                AppendMyLogBook, Event, ''
                
;copy .nxt file from stagingArea
                AppendMyLogBook, Event, $
                  'Copy translation file from Staging Area:'
                cmd_nxt = 'cp ' + CNstruct.StagingArea + '/*.nxt' + ' ' + $
                  CNstruct.preNeXus_folder
                cmd_nxt_text = 'cmd: ' + cmd_nxt + ' ... ' + $
                  CNstruct.PROCESSING
                AppendMyLogBook, Event, cmd_nxt_text
                IF (!VERSION.os EQ 'darwin') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                      CNstruct.PROCESSING
                ENDIF ELSE BEGIN
                    spawn, cmd_nxt, listening
                    IF (listening[0] EQ '') THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                          CNstruct.PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, FAILED , PROCESSING
                    ENDELSE
                ENDELSE
                AppendMyLogBook, Event, ''
                
;copy *.dat file from prenexus path
                AppendMyLogBook, Event, $
                  'Copy *.dat files from DAS/preNeXus folder:'
                cmd_dat = 'cp ' + CNstruct.prenexus_path + '/*.dat' + ' ' + $
                  CNstruct.preNeXus_folder
                cmd_dat_text = 'cmd: ' + cmd_dat + ' ... ' + $
                  CNstruct.PROCESSING
                AppendMyLogBook, Event, cmd_dat_text
                IF (!VERSION.os EQ 'darwin') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                      CNstruct.PROCESSING
                ENDIF ELSE BEGIN
                    spawn, cmd_dat, listening
                    IF (listening[0] EQ '') THEN BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                          CNstruct.PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
                          CNstruct.PROCESSING
                    ENDELSE
                ENDELSE
                AppendMyLogBook, Event, ''
            ENDIF
            
;copy Nexus file in local folder
            cmd1 = cmd + ' ' + CNstruct.NeXus_folder
            cmd1_text = 'cmd: ' + cmd1 + ' ... ' + CNstruct.PROCESSING
            AppendMyLogBook, Event, cmd1_text
            IF (!VERSION.os EQ 'darwin') THEN BEGIN
                putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                  CNstruct.PROCESSING
                msg = '> ' + CNstruct.NeXus_folder + $
                  (*CNstruct.ShortNexusToMove)[i] + $
                  ' (For Archive)'
                text = [text, msg]
            ENDIF ELSE BEGIN
                spawn, cmd1, listening
                IF (listening[0] EQ '') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                      CNstruct.PROCESSING
                    msg = '> ' + CNstruct.NeXus_folder + $
                      (*CNstruct.ShortNexusToMove)[i] + $
                      ' (For Archive)'
                    text = [text, msg]
                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
                      CNstruct.PROCESSING
                ENDELSE
            ENDELSE
        ENDIF
        
;copy Nexus file in instrument shared folder
        IF (CNstruct.InstrSharedFolder NE '') THEN BEGIN
;first check if the file already exist in the final location
            AppendMyLogBook, Event, $
              '> User wants to copy file in InstrSharedFolder'
            AppendMyLogBook, Event, '-> InstrSharedFolder: ' + $
              CNstruct.InstrSharedFolder

            file_name_to_copy = CNstruct.InstrSharedFolder + $
              (*CNstruct.ShortNexusToMove)[i]
            IF (FILE_TEST(file_name_to_copy)) THEN BEGIN

;file exist and we need to change its name
                text1 = '-> Does file (' + file_name_to_copy + ') already' + $
                  ' exist ... YES'
                AppendMyLogBook, Event, text1
                text1 = '--> Changing NeXus file name:'
                AppendMyLogBook, Event, text1
                text1 = '---> Was: ' + (*CNstruct.shortNeXusToMove)[i] 
                AppendMyLogBook, Event, text1
                file_split = STRSPLIT((*CNstruct.shortNeXusToMove)[i], $
                                      '.nxs', $
                                      /REGEX,$
                                      /EXTRACT)
                old_full_nexus_name = (*CNstruct.NeXusToMove)[i]
                file_split_2 = STRSPLIT((*CNstruct.NeXusToMove)[i],$
                                        '.nxs',$
                                        /REGEX,$
                                        /EXTRACT)
                time_stamp_ext = GenerateIsoTimeStamp() + '.nxs'

;new file name (short and long)
                short_new_file = file_split[0] + '_' + time_stamp_ext
                long_new_file  = file_split_2[0] + '_' + time_stamp_ext

;change file in .tmp folder
                (*CNstruct.shortNewNexus)[i]  = file_split[0] + '_' + $
                  time_stamp_ext
                cmd_mv = 'mv ' + old_full_nexus_name + ' ' + long_new_file
                spawn, cmd_mv, listening, err_listening
                AppendMyLogBook, Event, '(----> cmd: ' + cmd_mv + ')'
                text1 = '---> New: ' + short_new_file
                AppendMyLogBook, Event, text1
                cmd = 'cp ' + long_new_file
            ENDIF ELSE BEGIN
                text1 = '-> Does file (' + file_name_to_copy + ') already' + $
                  ' exist ... NO'
                AppendMyLogBook, Event, text1
                long_new_file = CNstruct.ProposalSharedFolder + $
                  (*CNstruct.ShortNeXusToMove)[i]   
                short_new_file = (*CNstruct.ShortNeXusToMove)[i]
            ENDELSE

;; change group of file
;             ProposalFolder       = getProposalSelected(Event)
;             cmd_chgrp_2 = cmd_chgrp +  ProposalFolder + $
;               ' ' + long_new_file
;             cmd_chgrp_2_text = 'cmd: ' + cmd_chgrp_2 + ' ... ' + $
;               CNstruct.PROCESSING
;             AppendMyLogBook, Event, cmd_chgrp_2_text
;             spawn, cmd_chgrp_2, listening, err_listening
;             IF (err_listening[0] EQ '') THEN BEGIN it worked
;                 putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
;                   CNstruct.PROCESSING
;             ENDIF ELSE BEGIN
;                 putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
;                   CNstruct.PROCESSING
;                 AppendMyLogBook, Event, err_listening
;             ENDELSE
            
            cmd2 = cmd + ' ' + CNstruct.InstrSharedFolder
            cmd2_text = 'cmd: ' + cmd2 + ' ... ' + CNstruct.PROCESSING
            AppendMyLogBook, Event, cmd2_text
            IF (!VERSION.os EQ 'darwin') THEN BEGIN
                putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                  CNstruct.PROCESSING
                text = [text,'> ' + $
                        CNstruct.InstrSharedFolder + $
                        (*CNstruct.ShortNexusToMove)[i]]
            ENDIF ELSE BEGIN
                spawn, cmd2, listening, err_listening
                IF (err_listening[0] EQ '') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                      CNstruct.PROCESSING
                    text = [text,'> ' + CNstruct.InstrSharedFolder + $
                            short_new_file]

;change permission of file
                    cmd_chmod_2 = cmd_chmod + CNstruct.InstrSharedFolder + $
                      short_new_file
                    cmd_chmod_2_text = 'cmd: ' + cmd_chmod_2 + ' ... ' + $
                      CNstruct.PROCESSING
                    AppendMyLogBook, Event, cmd_chmod_2_text
                    spawn, cmd_chmod_2, listening, err_listening
                    IF (err_listening[0] EQ '') THEN BEGIN ;it worked
                        putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                          CNstruct.PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
                          CNstruct.PROCESSING
                        AppendMyLogBook, Event, err_listening
                    ENDELSE

                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
                      CNstruct.PROCESSING
                    AppendMyLogBook, Event, err_listening
                    text = [text,'> ' + CNstruct.InstrSharedFolder + $
                            short_new_file + ' FAILED']
                ENDELSE
            ENDELSE

        ENDIF

;copy Nexus file in proposal shared folder
        IF (CNstruct.ProposalSharedFolder NE '') THEN BEGIN
;first check if the file already exist in the final location
            AppendMyLogBook, Event, $
              '> User wants to copy file in ProposalSharedFolder'
            AppendMyLogBook, Event, '-> ProposalSharedFolder: ' + $
              CNstruct.ProposalSharedFolder

            file_name_to_copy = CNstruct.ProposalSharedFolder + $
              (*CNstruct.ShortNexusToMove)[i]
            IF (FILE_TEST(file_name_to_copy)) THEN BEGIN

;file exist and we need to change its name
                text1 = '-> Does file (' + file_name_to_copy + ') already' + $
                  ' exist ... YES'
                AppendMyLogBook, Event, text1
                text1 = '--> Changing NeXus file name:'
                AppendMyLogBook, Event, text1
                text1 = '---> Was: ' + (*CNstruct.shortNeXusToMove)[i] 
                AppendMyLogBook, Event, text1
                file_split = STRSPLIT((*CNstruct.shortNeXusToMove)[i], $
                                      '.nxs', $
                                      /REGEX,$
                                      /EXTRACT)
                old_full_nexus_name = (*CNstruct.NeXusToMove)[i]
                file_split_2 = STRSPLIT((*CNstruct.NeXusToMove)[i],$
                                        '.nxs',$
                                        /REGEX,$
                                        /EXTRACT)
                time_stamp_ext = GenerateIsoTimeStamp() + '.nxs'

;new file name (short and long)
                short_new_file = file_split[0] + '_' + time_stamp_ext
                long_new_file  = file_split_2[0] + '_' + time_stamp_ext

;change file in .tmp folder
                (*CNstruct.shortNewNexus)[i]  = file_split[0] + '_' + $
                  time_stamp_ext
                cmd_mv = 'mv ' + old_full_nexus_name + ' ' + long_new_file
                spawn, cmd_mv, listening, err_listening
                AppendMyLogBook, Event, '(----> cmd: ' + cmd_mv + ')'
                text1 = '---> New: ' + short_new_file
                AppendMyLogBook, Event, text1
                cmd = 'cp ' + long_new_file
            ENDIF ELSE BEGIN
                text1 = '-> Does file (' + file_name_to_copy + ') already' + $
                  ' exist ... NO'
                AppendMyLogBook, Event, text1
                long_new_file = CNstruct.ProposalSharedFolder + $
                  (*CNstruct.ShortNeXusToMove)[i]   
                short_new_file = (*CNstruct.ShortNeXusToMove)[i]
            ENDELSE

;; change group of file
;             ProposalFolder       = getProposalSelected(Event)
;             cmd_chgrp_2 = cmd_chgrp +  ProposalFolder + $
;               ' ' + long_new_file
;             cmd_chgrp_2_text = 'cmd: ' + cmd_chgrp_2 + ' ... ' + $
;               CNstruct.PROCESSING
;             AppendMyLogBook, Event, cmd_chgrp_2_text
;             spawn, cmd_chgrp_2, listening, err_listening
;             IF (err_listening[0] EQ '') THEN BEGIN it worked
;                 putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
;                   CNstruct.PROCESSING
;             ENDIF ELSE BEGIN
;                 putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
;                   CNstruct.PROCESSING
;                 AppendMyLogBook, Event, err_listening
;             ENDELSE
            
            cmd2 = cmd + ' ' + CNstruct.ProposalSharedFolder
            cmd2_text = 'cmd: ' + cmd2 + ' ... ' + CNstruct.PROCESSING
            AppendMyLogBook, Event, cmd2_text
            IF (!VERSION.os EQ 'darwin') THEN BEGIN
                putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                  CNstruct.PROCESSING
                text = [text,'> ' + $
                        CNstruct.ProposalSharedFolder + $
                        (*CNstruct.ShortNexusToMove)[i]]
            ENDIF ELSE BEGIN
                spawn, cmd2, listening, err_listening
                IF (err_listening[0] EQ '') THEN BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                      CNstruct.PROCESSING
                    text = [text,'> ' + CNstruct.ProposalSharedFolder + $
                            short_new_file]

;change permission of file
                    cmd_chmod_2 = cmd_chmod + CNstruct.ProposalSharedFolder + $
                      short_new_file
                    cmd_chmod_2_text = 'cmd: ' + cmd_chmod_2 + ' ... ' + $
                      CNstruct.PROCESSING
                    AppendMyLogBook, Event, cmd_chmod_2_text
                    spawn, cmd_chmod_2, listening, err_listening
                    IF (err_listening[0] EQ '') THEN BEGIN ;it worked
                        putTextAtEndOfMyLogBook, Event, CNstruct.OK , $
                          CNstruct.PROCESSING
                    ENDIF ELSE BEGIN
                        putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
                          CNstruct.PROCESSING
                        AppendMyLogBook, Event, err_listening
                    ENDELSE

                ENDIF ELSE BEGIN
                    putTextAtEndOfMyLogBook, Event, CNstruct.FAILED , $
                      CNstruct.PROCESSING
                    AppendMyLogBook, Event, err_listening
                    text = [text,'> ' + CNstruct.ProposalSharedFolder + $
                            short_new_file + ' FAILED']
                ENDELSE
            ENDELSE

        ENDIF

        AppendMyLogBook, Event, ''
        
    ENDFOR

ENDIF
RETURN, error_status
END
;##############################################################################

