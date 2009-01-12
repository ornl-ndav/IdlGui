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

PRO reduce_tab1_browse_button, Event

;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

path  = (*global).browsing_path
title = 'Select 1 or several NeXus file'
default_extenstion = '.nxs'

LogText = '> Browsing for NeXus file in Reduce/step1:'
IDLsendToGeek_addLogBookText, Event, LogText

nexus_file_list = DIALOG_PICKFILE(DEFAULT_EXTENSION = default_extension,$
                                  FILTER = ['*.nxs'],$
                                  GET_PATH = new_path,$
                                  /MULTIPLE_FILES,$
                                  /MUST_EXIST,$
                                  PATH = path,$
                                  TITLE = title)

IF (nexus_file_list[0] NE '') THEN BEGIN
    IF (new_path NE path) THEN BEGIN
        (*global).browsing_path = new_path
        LogText = '-> New browsing_path is: ' + new_path
    ENDIF
    IDLsendToGeek_addLogBookText, Event, LogText
    display_message_about_files_browsed, Event, nexus_file_list
    
ENDIF ELSE BEGIN
    LogText = '-> User canceled Browsing for NeXus file'
    IDLsendToGeek_addLogBookText, Event, LogText
ENDELSE

END

;------------------------------------------------------------------------------
PRO display_message_about_files_browsed, Event, nexus_file_list

nbr_files = N_ELEMENTS(nexus_file_list)
LogText = '-> Nbr Files Browsed: ' + STRCOMPRESS(nbr_files,/REMOVE_ALL)
IDLsendToGeek_addLogBookText, Event, LogText

LogText = '-> List of Files: '
IDLsendToGeek_addLogBookText, Event, LogText

index = 0
WHILE (index LT nbr_files) DO BEGIN
    LogText = '    ' + nexus_file_list[index]
    IDLsendToGeek_addLogBookText, Event, LogText
    ++index
ENDWHILE

END
