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

PRO BSSreduction_LogBook, Event
;get global structure
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;get list of files we want to send
RoiFileName = getReduceRoiFullFileName(Event)
IF (RoiFileName NE '') THEN BEGIN
    list_OF_files_to_tar = [RoiFileName]
    iLog = OBJ_NEW('IDLsendLogBook',Event, $
                   LIST_OF_FILES_TO_TAR=list_OF_files_to_tar)
ENDIF ELSE BEGIN
    iLog = OBJ_NEW('IDLsendLogBook', Event)
ENDELSE
OBJ_DESTROY, iLog


;;change permission of file first
;roi_error = 0
;;CATCH, roi_error
;IF (roi_error NE 0) THEN BEGIN
;    CATCH,/CANCEL
;    LogBookText = 'Change permission of ' + RoiFileName + ' to 755 ' + $
;      ' ... FAILED' 
;    AppendLogBookMessage, Event, LogBookText
;ENDIF ELSE BEGIN
;    spawn, chmod_cmd, listening, err_listening
;    IF (err_listening[0] NE '') THEN BEGIN
;        LogBookText = 'Change permission of ' + RoiFileName + $
;          ' to 755 ... FAILED' 
;    AppendLogBookMessage, Event, LogBookText
;    ENDIF ELSE BEGIN
;        LogBookText = 'Change permission of ' + RoiFileName + $
;          ' to 755 ... OK' 
;    AppendLogBookMessage, Event, LogBookText
;    ENDELSE
;ENDELSE

;;copy file into final folder
;;CATCH, roi_error
;IF (roi_error NE 0) THEN BEGIN
;    catch,/cancel
;    LogBookText = 'Copy of ' + RoiFileName + ' in ' + $
;      shared_path + ' ... FAILED' 
;    AppendLogBookMessage, Event, LogBookText
;ENDIF ELSE BEGIN
;    spawn, cp_cmd, listening, err_listening
;    IF (err_listening[0] NE '') THEN BEGIN
;        LogBookText = 'Copy of ' + RoiFileName + ' in ' + $
;          shared_path + ' ... FAILED' 
;        AppendLogBookMessage, Event, LogBookText
;    ENDIF ELSE BEGIN
;        LogBookText = 'Copy of ' + RoiFileName + ' in ' + $
;          shared_path + ' ... OK' 
;        AppendLogBookMessage, Event, LogBookText
;    ENDELSE
;ENDELSE

END

