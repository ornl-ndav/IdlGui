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

;This function is reached when the user launches a data reduction
;The program checks the contain of the data run numbers and replace
;them by the full nexus path (if this run number can be found)
PRO ReplaceDataRunNumbersByFullPath, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing_message
FAILED     = (*global).failed

;inform user of what is going on here
message = '-> Replacing Data Run Numbers by NeXus Full Path:'
putLogBookMessage, Event, message, Append=1

data_run_numbers = getTextFieldValue(Event, 'reduce_data_runs_text_field')

;parse first by ','
RunNumbersArray    = strsplit(data_run_numbers,',',/EXTRACT)
sz = (size(RunNumbersArray))(1)
NexusFullPathArray = strarr(sz)
FOR i=0,(sz-1) DO BEGIN
    ;check that this is not a full nexus path name already
    checkParse = strsplit(RunNumbersArray[i],'/',/EXTRACT,COUNT=nbr)
    IF (nbr EQ 1) THEN BEGIN
        message = '--> Run ' + strcompress(RunNumbersArray[i],/REMOVE_ALL)
        message += ' ==> ' + PROCESSING 
        putLogBookMessage, Event, message, Append=1

        isNexusExist = 0
        full_nexus_name = find_full_nexus_name(Event, $
                                               RunNumbersArray[i],$
                                               (*global).instrument,$
                                               isNexusExist)
        IF (isNexusExist) THEN BEGIN
            AppendReplaceLogBookMessage, Event, full_nexus_name, processing
            NexusFullPathArray[i]=full_nexus_name
        ENDIF ELSE BEGIN
            AppendReplaceLogBookMessage, Event, failed, processing
            NexusFullPathArray[i]=''
        ENDELSE
            
    ENDIF ELSE BEGIN
        NeXusFullPathArray[i]=RunNumbersArray[i]
    ENDELSE
ENDFOR

;replace list of runs by nexus that have been found
first_nexus_of_list = 1
nexus_list = ''
FOR j=0,(sz-1) DO BEGIN
    IF (NeXusFullPathArray[j] NE '') THEN BEGIN
        IF (first_nexus_of_list) THEN BEGIN
            nexus_list = NeXusFullPathArray[j]
            first_nexus_of_list = 0
        ENDIF ELSE BEGIN
            nexus_list += ' ' + NexusFullPathArray[j]
        ENDELSE
    ENDIF
ENDFOR
putTextFieldvalue, Event, 'reduce_data_runs_text_field', nexus_list, 0

END






;This function is reached when the user launches a data reduction
;The program checks the contain of the norm run numbers and replace
;them by the full nexus path (if this run number can be found)
PRO ReplaceNormRunNumbersByFullPath, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing_message
FAILED     = (*global).failed

;inform user of what is going on here
message = '-> Replacing Norm Run Numbers by NeXus Full Path:'
putLogBookMessage, Event, message, Append=1

norm_run_numbers = getTextFieldValue(Event, 'reduce_normalization_runs_text_field')

;parse first by ','
RunNumbersArray    = strsplit(norm_run_numbers,',',/EXTRACT)
sz = (size(RunNumbersArray))(1)
NexusFullPathArray = strarr(sz)
FOR i=0,(sz-1) DO BEGIN
    ;check that this is not a full nexus path name already
    checkParse = strsplit(RunNumbersArray[i],'/',/EXTRACT,COUNT=nbr)
    IF (nbr EQ 1) THEN BEGIN
        message = '--> Run ' + strcompress(RunNumbersArray[i],/REMOVE_ALL)
        message += ' ==> ' + PROCESSING
        putLogBookMessage, Event, message, Append=1

        isNexusExist = 0
        full_nexus_name = find_full_nexus_name(Event, $
                                               RunNumbersArray[i],$
                                               (*global).instrument,$
                                               isNexusExist)
        IF (isNexusExist) THEN BEGIN
            AppendReplaceLogBookMessage, Event, full_nexus_name, processing
            NexusFullPathArray[i]=full_nexus_name
        ENDIF ELSE BEGIN
            AppendReplaceLogBookMessage, Event, failed, processing
            NexusFullPathArray[i]=''
        ENDELSE
            
    ENDIF ELSE BEGIN
        NeXusFullPathArray[i]=RunNumbersArray[i]
    ENDELSE
ENDFOR

;replace list of runs by nexus that have been found
first_nexus_of_list = 1
nexus_list = ''
FOR j=0,(sz-1) DO BEGIN
    IF (NeXusFullPathArray[j] NE '') THEN BEGIN
        IF (first_nexus_of_list) THEN BEGIN
            nexus_list = NeXusFullPathArray[j]
            first_nexus_of_list = 0
        ENDIF ELSE BEGIN
            nexus_list += ',' + NexusFullPathArray[j]
        ENDELSE
    ENDIF
ENDFOR
putTextFieldvalue, Event, 'reduce_normalization_runs_text_field', nexus_list, 0

END
