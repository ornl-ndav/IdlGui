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

;This function output the log book in the IDL_LogBook folder of j35
PRO RefReduction_LogBookInterface, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;create full name of log Book file
LogBookPath = (*global).LogBookPath
TimeStamp   = RefReduction_GenerateIsoTimeStamp()
instrument  = (*global).instrument
FullFileName = LogBookPath + instrument + '_' 
FullFileName += TimeStamp + '.log'

;get full text of LogBook
LogBookText = getLogBookText(Event)

;add ucams 
ucamsText = 'Ucams: ' + (*global).ucams
LogBookText = [ucamsText,LogBookText]

;output file
openw, 1, FullFileName
sz = (size(LogBookText))(1)
for i=0,(sz-1) do begin
    text = LogBookText[i]
    printf, 1, text
endfor
close,1
free_lun,1

REFreduction_EmailLogBook, Event, FullFileName

END


;This function send by email a copy of the logBook
PRO REFreduction_EmailLogBook, Event, FullFileName

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;add ucams 
ucamsText = 'Ucams: ' + (*global).ucams

;hostname
spawn, 'hostname', hostname

;get message added by user
message = getTextFieldValue(Event, 'log_book_output_text_field')

;email logBook

text = "'Log Book of REFreduction "
IF ((*global).miniVersion EQ 0) THEN BEGIN
    text += "- low resolution version - "
ENDIF ELSE BEGIN
    text += "- high resolution version - "
ENDELSE
text += (*global).REFreductionVersion + " sent by " + (*global).ucams
text += " (" + (*global).instrument + ") from " + hostname + "."
text += " Log Book is: " + FullFileName 
text += ". Message is: "

if (message NE '') then begin
    text += message
endif else begin
    text += "No messages added."
endelse
text += "'"

cmd =  'echo ' + text + '| mail -s "REFreduction LogBook" j35@ornl.gov'
spawn, cmd

;copy ROI files into /SNS/<instrument>/shared folder
shared_path = '/SNS/' + (*global).instrument + '/shared/'
;get DATA and NORM ROI files name
data_roi_file_name = getTextFieldValue(Event, $
                                       'reduce_data_region_of_interest_file_name')
norm_roi_file_name = $
  getTextFieldValue(Event, $
                    'reduce_normalization_region_of_interest_file_name')
;copy roi files into share folder
chmod_cmd_data = 'chmod 755 ' + data_roi_file_name
cp_cmd_data    = 'cp ' + data_roi_file_name + ' ' + shared_path
chmod_cmd_norm = 'chmod 755 ' + norm_roi_file_name
cp_cmd_norm    = 'cp ' + norm_roi_file_name + ' ' + shared_path

;change permission of file first
roi_data_error = 0
CATCH, roi_data_error
IF (roi_data_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    LogBookText = 'Change permission of ' + data_roi_file_name + ' to 755 ' + $
      ' ... FAILED' 
    putLogBookMessage, Event, LogBookText, Append=1
ENDIF ELSE BEGIN
    spawn, chmod_cmd_data, listening, err_listening
    IF (err_listening[0] NE '') THEN BEGIN
        LogBookText = 'Change permission of ' + data_roi_file_name + $
          ' to 755 ... FAILED' 
        putLogBookMessage, Event, LogBookText, Append=1
    ENDIF ELSE BEGIN
        LogBookText = 'Change permission of ' + data_roi_file_name + $
          ' to 755 ... OK' 
        putLogBookMessage, Event, LogBookText, Append=1
    ENDELSE
ENDELSE

;copy file into final folder
CATCH, roi_data_error
IF (roi_data_error NE 0) THEN BEGIN
    catch,/cancel
    LogBookText = 'Copy of ' + data_roi_file_name + ' in ' + $
      shared_path + ' ... FAILED' 
    putLogBookMessage, Event, LogBookText, Append=1
ENDIF ELSE BEGIN
    spawn, cp_cmd_data, listening, err_listening
    IF (err_listening[0] NE '') THEN BEGIN
        LogBookText = 'Copy of ' + data_roi_file_name + ' in ' + $
          shared_path + ' ... FAILED' 
        putLogBookMessage, Event, LogBookText, Append=1
    ENDIF ELSE BEGIN
        LogBookText = 'Copy of ' + data_roi_file_name + ' in ' + $
          shared_path + ' ... OK' 
        putLogBookMessage, Event, LogBookText, Append=1
    ENDELSE
ENDELSE

IF (norm_roi_file_name NE '') THEN BEGIN
;change permission of file
    roi_norm_error = 0
    CATCH, roi_norm_error
    IF (roi_norm_error NE 0) THEN BEGIN
        catch,/cancel
        LogBookText = 'Change permission of ' + norm_roi_file_name + ' to 755 ' $
          + ' ... FAILED' 
        putLogBookMessage, Event, LogBookText, Append=1
    ENDIF ELSE BEGIN
        spawn, chmod_cmd_norm, listening, err_listening
        IF (err_listening[0] NE '') THEN BEGIN
            LogBookText = 'Change permission of ' + norm_roi_file_name + $
              ' to 755 ... FAILED' 
            putLogBookMessage, Event, LogBookText, Append=1
        ENDIF ELSE BEGIN
            LogBookText = 'Change permission of ' + norm_roi_file_name + $
              ' to 755 ... OK' 
            putLogBookMessage, Event, LogBookText, Append=1
        ENDELSE
    ENDELSE

;copy file
    roi_norm_error = 0
    CATCH, roi_norm_error
    IF (roi_norm_error NE 0) THEN BEGIN
        catch,/cancel
        LogBookText = 'Copy of ' + norm_roi_file_name + ' in ' + $
          shared_path + ' ... FAILED' 
        putLogBookMessage, Event, LogBookText, Append=1
    ENDIF ELSE BEGIN
        spawn, cp_cmd_norm, listening, err_listening
        IF (err_listening[0] NE '') THEN BEGIN
            LogBookText = 'Copy of ' + norm_roi_file_name + ' in ' + $
              shared_path + ' ... FAILED' 
            putLogBookMessage, Event, LogBookText, Append=1
        ENDIF ELSE BEGIN
            LogBookText = 'Copy of ' + norm_roi_file_name + ' in ' + $
              shared_path + ' ... OK' 
            putLogBookMessage, Event, LogBookText, Append=1
        ENDELSE
    ENDELSE
ENDIF

;copy Batch File Name if any
IF ((*global).BatchFileName NE '') THEN BEGIN
;change permission of file
    BatchFileName = (*global).BatchFileName
    chmod_cmd_batch = 'chmod 755 ' + BatchFileName
    batch_error = 0
    CATCH, batch_error
    IF (batch_error NE 0) THEN BEGIN
        CATCH,/CANCEL
        LogBookText = 'Change permission of ' + BatchFileName + ' to 755 ' $
          + ' ... FAILED'
        putLogBookMessage, Event, LogBookText, Append=1
    ENDIF ELSE Begin
        spawn, chmod_cmd_batch, listening, err_listening
        IF (err_listening[0] NE '') THEN BEGIN
            LogBookText = 'Change permission of ' + BatchFileName + ' to 755 ' $
              + ' ... FAILED'
            putLogBookMessage, Event, LogBookText, Append=1
        ENDIF ELSE BEGIN
            LogBookText = 'Change permission of ' + BatchFileName + ' to 755 ' $
              + ' ... OK'
            putLogBookMessage, Event, LogBookText, Append=1
        ENDELSE
    ENDELSE

;copy of file
    cp_cmd_batch = 'cp ' + (*global).BatchFileName + '  ' + shared_path
    batch_error = 0
    CATCH, batch_error
    IF (batch_error NE 0) THEN BEGIN
        CATCH,/CANCEL
        LogBookText = 'Copy of ' + (*global).BatchFileName + ' in ' + $
          shared_path + ' ... FAILED'
        putLogBookMessage, Event, LogBookText, Append=1
    ENDIF ELSE Begin
        spawn, cp_cmd_batch, listening, err_listening
        IF (err_listening[0] NE '') THEN BEGIN
            LogBookText = 'Copy of ' + (*global).BatchFileName + ' in ' + $
              shared_path + ' ... FAILED'
            putLogBookMessage, Event, LogBookText, Append=1
        ENDIF ELSE BEGIN
            LogBookText = 'Copy of ' + (*global).BatchFileName + ' in ' + $
              shared_path + ' ... OK'
            putLogBookMessage, Event, LogBookText, Append=1
        ENDELSE
     ENDELSE
ENDIF

;tell the user that the email has been sent
LogBookText = 'LogBook has been sent successfully !'
putLogBookMessage, Event, LogBookText, Append=1

END
