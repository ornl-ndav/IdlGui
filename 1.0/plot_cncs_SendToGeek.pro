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

PRO LogBook, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;create full name of log Book file
LogBookPath = (*global).LogBookPath
TimeStamp   = GenerateIsoTimeStamp()
application  = 'plotCNCS'
FullFileName = LogBookPath + application + '_' 
FullFileName += TimeStamp + '.log'

;get full text of LogBook
LogBookText = getLogBookText(Event)

;add ucams 
ucamsText = 'Ucams: ' + (*global).ucams
LogBookText = [ucamsText,LogBookText]

;output file
no_error = 0
CATCH, no_error
If (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
;tell the user that the email has not been sent
    LogBookText = 'An error occured while contacting the GEEK. Please email j35@ornl.gov!'
    putStatus, Event, LogBookText
ENDIF ELSE BEGIN
    openw, 1, FullFileName
    sz = (size(LogBookText))(1)
    for i=0,(sz-1) do begin
        text = LogBookText[i]
        printf, 1, text
    endfor
    close,1
    free_lun,1
    EmailLogBook, Event, FullFileName
ENDELSE
END


;This function send by email a copy of the logBook
PRO EmailLogBook, Event, FullFileName

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;add ucams 
ucamsText = 'Ucams: ' + (*global).ucams

;hostname
spawn, 'hostname', hostname

;get message added by user
message = getStatusTextFieldValue(Event)

;email logBook
text = "'Log Book of plotCNCS "
text += (*global).Version + " sent by " + (*global).ucams
text += " from " + hostname + "."
text += " Log Book is: " + FullFileName 
text += ". Message is: "

if (message NE '') then begin
    text += message
endif else begin
    text += "No messages added."
endelse
text += "'"

no_error = 0
CATCH, no_error
If (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
;tell the user that the email has not been sent
    LogBookText = 'An error occured while contacting the GEEK. Please email j35@ornl.gov!'
    putStatus, Event, LogBookText
ENDIF ELSE BEGIN
    cmd =  'echo ' + text + '| mail -s "plotCNCS LogBook" j35@ornl.gov'
    spawn, cmd
;tell the user that the email has been sent
    LogBookText = 'LogBook has been sent successfully !'
    putStatus, Event, LogBookText
ENDELSE
END
