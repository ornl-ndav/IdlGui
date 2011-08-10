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

FUNCTION BSSreduction_GetNexusFullPath, Event, RunNumber, type, isNeXusExist
NexusFullPath = find_full_nexus_name(Event, RunNumber, isNeXusExist)
NeXusFullName = NexusFullPath[0]
RETURN, NeXusFullName
END

;------------------------------------------------------------------------------
;This function is reached when the user enters a RunNumber and hits
;ENTER (REDUCE tab#1)
PRO BSSreduction_NexusFullPath, Event, type

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK = (*global).ok
FAILED = (*global).failed

;run number we want
RunNumber = strcompress(getReduceRunNumber(Event, type),/remove_all)

list_run_numbers = parse_run_numbers(event, RunNumber)
sz = n_elements(list_run_numbers)

    CASE (type) OF
        'rsdf': begin
        uname = 'rsdf_list_of_runs_text'
        label = 'Raw sample data file'
        end
        'bdf' : begin
        uname = 'bdf_list_of_runs_text'
        label = 'Background data file'
        end
        'ndf' : begin
        uname = 'ndf_list_of_runs_text'
        label = 'Normalization data file'
        end
        'ecdf': begin
        uname = 'ecdf_list_of_runs_text'
        label = 'Empty can Data file'
        end
        'dsb' : begin
        uname = 'dsb_list_of_runs_text'
        label = 'Direct scattering background file'
        end
    ENDCASE

    message = '  -> Input field: ' + label
    AppendLogBookMessage, event, message
    message = '  -> Run number input string: ' + RunNumber
    AppendLogBookMessage, Event, message
    message = '  -> List of runs: ' + strjoin(list_run_numbers,',')
    AppendLogBookMessage, event, message

;    message = '  -> Checking if run number exists ... ' + PROCESSING
;    AppendLogBookMessage, Event, message

index=0
while (index lt sz) do begin
  RunNumber = list_run_numbers[index]
    
    message = '  -> Looking for run number: ' + $
    strcompress(RunNumber,/remove_all) + ' ... ' + PROCESSING
    AppendLogBookMessage, event, message
    
;searching for nexus file
    isNeXusExist = 0            ;by default, nexus file does not exist
    NeXusFullName = BSSreduction_GetNexusFullPath(Event, $
                                                  RunNumber, $
                                                  type, $
                                                  isNeXusExist)
    
    IF (isNeXusExist EQ 1) THEN BEGIN
        
        putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING
        
;keep record of run number only if it's not the first run.
        IF (type EQ 'rsdf') THEN BEGIN ;define default output file name
            txt = getTextFieldValue(Event, 'rsdf_list_of_runs_text')
            IF (txt EQ '') THEN BEGIN
;display run number in cw_field
                iNexus = OBJ_NEW('IDLgetMetadata', NexusFullName)
                RunNumber = iNexus->getRunNumber()
                OBJ_DESTROY, iNexus
                (*global).RunNumber = RunNumber
                define_default_output_file_name, Event, $
                  TYPE='archive' ;_eventcb
            ENDIF
        ENDIF
    
;get current text in text_field
        CurrentText = getTextFieldValue(Event, uname)
        IF (CurrentText EQ '') THEN BEGIN
            PutTextInTextField, Event, uname, NeXusFullName
        ENDIF ELSE BEGIN
            AppendTextInTextField, Event, uname, ',' + NeXusFullName
        ENDELSE
        
    ENDIF ELSE BEGIN
        
        putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
        
    ENDELSE
    
    newText = getTextFieldValue(Event, uname)
    IF (newText EQ '') THEN BEGIN
        newText = 'N/A'
    ENDIF
    message = '    - List of files is : ' + newText
    AppendLogBookMessage, Event, message

index++
endwhile
    
;turn off hourglass
widget_control,hourglass=0
END

;------------------------------------------------------------------------------
;This function is reached when the user updates the text field (remove
;a nexus full path for example) of REDUCE tab#1
PRO BSSreduction_UpdateListOfNexus, Event, type

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

CASE (type) OF
    'rsdf': uname = 'rsdf_list_of_runs_text'
    'bdf' : uname = 'bdf_list_of_runs_text'
    'ndf' : uname = 'ndf_list_of_runs_text'
    'ecdf': uname = 'ecdf_list_of_runs_text'
    'dsb' : uname = 'dsb_list_of_runs_text'
ENDCASE

ListOfNexus = getTextFieldValue(Event, uname)

;name of file from Reduce Gui Tab
uname_label = type + '_label'
message1  = getLabelValue(event, uname_label)
message = ' -> ' + message1 + ' :'
AppendLogBookMessage, Event, message

message = '    - List of files has been updated'
AppendLogBookMessage, Event, message

IF (ListOfNexus EQ '') THEN BEGIN
    ListOFNexus = 'N/A'
ENDIF
message = '    - List of files is now : ' + ListOfNexus
AppendLogBookMessage, Event, message

;turn off hourglass
widget_control,hourglass=0
END

;------------------------------------------------------------------------------
;This function is reached when the user enters a Nexus filename (full
;path) and hits ENTER
;the program first checks if the file exist and if it does, add it to
;the list of runs.
PRO BSSreduction_AddNexusFullPath, Event, type

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK = (*global).ok
FAILED = (*global).failed

uname = type + '_nexus_cw_field'
uname1 = type + '_list_of_runs_text'
NexusLoadedName = getTextFieldValue(Event, uname)

IF (NexusLoadedName NE '') THEN BEGIN

    uname_label = type + '_label'
    message1  = getLabelValue(event, uname_label)
    message = ' -> ' + message1 + ' :'
    AppendLogBookMessage, Event, message
    message = '    - Checking if following NeXus exists : ' + $
      strcompress(NexusLoadedName,/remove_all)
    AppendLogBookMessage, Event, message + ' ... ' + PROCESSING
        
    isNexusExist = CheckIfNexusExist(NexusLoadedName)

    IF (isNexusExist EQ 1) THEN BEGIN ;nexus exists

;keep record of run number only if it's not the first run.
        IF (type EQ 'rsdf') THEN BEGIN ;define default output file name
            txt = getTextFieldValue(Event, 'rsdf_list_of_runs_text')
            IF (txt EQ '') THEN BEGIN
;display run number in cw_field
            iNexus = OBJ_NEW('IDLgetMetadata', NexusLoadedName)
            RunNumber = iNexus->getRunNumber()
            OBJ_DESTROY, iNexus
            (*global).RunNumber = RunNumber
            define_default_output_file_name, Event, TYPE='archive' ;_eventcb
        ENDIF

        putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;get current text in text_field
        CurrentText = getTextFieldValue(Event, uname1)
        IF (CurrentText EQ '') THEN BEGIN
            PutTextInTextField, Event, uname1, NexusLoadedName
        ENDIF ELSE BEGIN
            AppendTextInTextField, Event, uname1, ',' + NexusLoadedName
        ENDELSE
        
    ENDIF


    ENDIF ELSE BEGIN ;nexus does not exist

        putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING

    ENDELSE

    newText = getTextFieldValue(Event, uname1)
    IF (newText EQ '') THEN BEGIN
        newText = 'N/A'
    ENDIF
    message = '    - List of files is : ' + newText
    AppendLogBookMessage, Event, message
    
ENDIF

;turn off hourglass
widget_control,hourglass=0

END

;------------------------------------------------------------------------------
;This function is reached by the browse button of the first tab
PRO BSSreduction_ReduceBrowseNexus, Event, type

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

uname    = type + '_browse_nexus_button'
uname1   = type + '_list_of_runs_text'
;uname_rn = type + '_run_number_cw_field'

CASE (type) OF
    'rsdf' : title1 = 'Raw Sample Data'
    'bdf'  : title1 = 'Background Data'
    'ndf'  : title1 = 'Normalization Data'
    'ecdf' : title1 = 'Empty Can Data'
    'aig'  : title1 = 'Alternate Instrument Geometry'
    'dsb'  : title1 = 'Direct Scattering Background'
ENDCASE

;define ROI filter
nexus_ext = (*global).nexus_ext
filter = '*' + nexus_ext

;get default path
IF (type EQ 'aig') THEN BEGIN
    NeXusPath = (*global).nexus_geometry_path
ENDIF ELSE BEGIN
    NeXusPath = (*global).nexus_path
ENDELSE

title = 'Select a ' + title1 + ' NeXus File:'

;open Nexus file
NexusFullFileName = DIALOG_PICKFILE(PATH = NeXusPath,$
                                    TITLE = title,$
                                    FILTER = filter,$
                                    DEFAULT_EXTENSION = nexus_ext)

IF (NexusFullFileName NE '') THEN BEGIN

;keep record of run number only if it's not the first run.
    IF (type EQ 'rsdf') THEN BEGIN ;define default output file name
        txt = getTextFieldValue(Event, 'rsdf_list_of_runs_text')
        IF (txt EQ '') THEN BEGIN
;display run number in cw_field
            iNexus = OBJ_NEW('IDLgetMetadata', NexusFullFileName)
            RunNumber = iNexus->getRunNumber()
            OBJ_DESTROY, iNexus
            (*global).RunNumber = RunNumber
            define_default_output_file_name, Event, TYPE='archive' ;_eventcb
        ENDIF
    ENDIF

;    uname_label = type + '_label'
;    message1  = getLabelValue(event, uname_label)
;    message = ' -> ' + message1 + ' :'
;    AppendLogBookMessage, Event, message

;get current text in text_field
    CurrentText = getTextFieldValue(Event, uname1)
    IF (CurrentText EQ '') THEN BEGIN
        PutTextInTextField, Event, uname1, NexusFullFileName
    ENDIF ELSE BEGIN
        AppendTextInTextField, Event, uname1, ',' + NexusFullFileName
    ENDELSE
    
    newText = getTextFieldValue(Event, uname1)
    IF (newText EQ '') THEN BEGIN
        newText = 'N/A'
    ENDIF

    IF (type eq 'aig') THEN BEGIN
        message = '    - File is now : ' + newText
    ENDIF ELSE BEGIN
        message = '    - List of files is : ' + newText
    ENDELSE
    AppendLogBookMessage, Event, message

ENDIF ELSE BEGIN

ENDELSE

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0
END

;------------------------------------------------------------------------------
;This function is reached by the browse button of the first tab
PRO BSSreduction_ReduceBrowseRoi, Event

;indicate initialization with hourglass icon
widget_control,/hourglass

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

uname = 'proif_browse_nexus_button'
uname1 = 'proif_text'

;define ROI filter
roi_ext = (*global).roi_ext
filter = '*' + roi_ext
RoiPath = (*global).roi_path

title = 'Select a Region Of Interest File:'

;open ROI file
RoiFullFileName = DIALOG_PICKFILE(PATH = RoiPath,$
                                  TITLE = title,$
                                  FILTER = filter,$
                                  DEFAULT_EXTENSION = roi_ext)

IF (RoiFullFileName NE '') THEN BEGIN

    uname_label = 'proif_label'
    message1  = getLabelValue(event, uname_label)
    message = ' -> ' + message1 + ' :'
    AppendLogBookMessage, Event, message

    PutTextInTextField, Event, uname1, RoiFullFileName
    
    newText = getTextFieldValue(Event, uname1)
    IF (newText EQ '') THEN BEGIN
        newText = 'N/A'
    ENDIF
    message = '    - File is now : ' + newText
    AppendLogBookMessage, Event, message

ENDIF ELSE BEGIN

ENDELSE

;turn off hourglass
widget_control,hourglass=0

END
