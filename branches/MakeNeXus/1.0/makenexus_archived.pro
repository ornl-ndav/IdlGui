;===============================================================================
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
;===============================================================================

FUNCTION ReformatStagingFolder, StagingFolder, ucams
IF (STRMATCH(StagingFolder,'*~*')) THEN BEGIN
    StrArray = STRSPLIT(StagingFolder,'~',/EXTRACT, COUNT=length)
    IF (length GT 1) THEN BEGIN
        StagingFolder = StrArray[0] + '~' + ucams + StrArray[1]
    ENDIF ELSE BEGIN
        StagingFolder = '~' + ucams + StrArray[0]
    ENDELSE
ENDIF
RETURN, StagingFolder
END
  
;------------------------------------------------------------------------------
PRO archived_nexus, Event

id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global

;retrieve parameters
CommandToRun        = (*global).ArchivedCommand
Ucams               = (*global).ucams
StagingFolderBefore = getOutputPath(Event)
Runs                = (*(*global).RunsToArchived)
sz                  = (size(Runs))(1)
;general parameters
OK         = (*global).ok
FAILED     = (*global).failed
PROCESSING = (*global).processing

;if ~ is part of the StagingFolder, replace it by ~<ucams>
StagingFolderAfter  = ReformatStagingFolder(StagingFolderBefore, ucams)

message = ''
AppendMyLogBook, Event, message
message = '-*-*-*-*-*-*-*-*-*- Archiving NeXus file(s) -*-*-*-*-*-*-*-*-*-'
AppendMyLogBook, Event, message
message = '> General Parameters:'
AppendMyLogBook, Event, message
text    = '-> Ucams: ' + Ucams
AppendMyLogBook, Event, text
text    = '-> General Command to Run (CommandToRun): ' + CommandToRun
AppendMyLogBook, Event, text
text    = '-> Staging Folder (StagingFolder):'
AppendMyLogBook, Event, text
text    = '--> Before reformatting: ' + StagingFolderBefore
AppendMyLogBook, Event, text
text    = '--> After reformatting : ' + StagingFolderAfter
AppendMyLogBook, Event, text
message = ''
AppendLogBook, Event, message
message = '#### ARCHIVING RUNS ####'
AppendLogBook, Event, message
text    = '-> Please Enter your ucams password in the shell' + $
  ' window just after PASSWORD: and then press ENTER: ... '
appendLogBook, Event, text

FOR i=0,(sz-1) DO BEGIN
    IF (Runs[i] NE 0) THEN BEGIN
        message = ''
        AppendMyLogBook, Event, message
        text = '-> Archiving Runs         : ' + STRCOMPRESS(Runs[i], $
                                                               /REMOVE_ALL)
        AppendMyLogBook, Event, text
        archived_cmd = CommandToRun + ' ' + StagingFolderAfter + $
          STRCOMPRESS(Runs[i],/REMOVE_ALL)
        text = '-> Command to Archived Run: ' + archived_cmd + ' ... ' + $
          PROCESSING
        AppendMyLogBook, Event, text
;Running command
        spawn, 'xterm -e ' + archived_cmd, listening, err_listening
        text = '-> Archiving Run ' + STRCOMPRESS(Runs[i]) + ' ... ' + $
          (*global).processing
        AppendLogBook, Event, text
        IF (err_listening[0] NE '' AND $
            listening NE '') THEN BEGIN
            putTextAtEndOfMyLogBook, Event, FAILED, PROCESSING
            message = '-->ERROR message (listening) is:'
            AppendMyLogBook, Event, message
            AppendMyLogBook, Event, listening
            message = '--> ERROR message (err_listening) is:'
            AppendMyLogBook, Event, message
            AppendMyLogBook, Event, err_listening
            putTextAtEndOfLogBook, Event, FAILED, PROCESSING
        ENDIF ELSE BEGIN
            putTextAtEndOfMyLogBook, Event, OK, PROCESSING
            putTextAtEndOfLogBook, Event, OK, PROCESSING
        ENDELSE
    ENDIF
    message = '-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-'
    AppendMyLogBook, Event, message
ENDFOR
showLastUserLogBookLine, Event
END
    
