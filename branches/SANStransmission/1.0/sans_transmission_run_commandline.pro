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

PRO RunCommandLine, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
;retrieve infos
PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

status_text = 'Data Reduction ... ' + PROCESSING
putTextFieldValue, Event, 'data_reduction_status_frame', status_text

;get command line to generate
cmd = getTextFieldValue(Event,'comamnd_line_preview')

;display command line in log-book
cmd_text = '> Command Line:'
IDLsendToGeek_addLogBookText, Event, cmd_text
cmd_text = '-> ' + cmd
IDLsendToGeek_addLogBookText, Event, cmd_text
cmd_text = '-> Running Command Line ... ' + PROCESSING
IDLsendToGeek_addLogBookText, Event, cmd_text

;indicate initialization with hourglass icon
widget_control,/hourglass
;running command

IF ((*global).TESTING EQ 'yes') THEN BEGIN
    cmd = '~/bin/runenv ' + cmd
ENDIF
spawn, cmd, listening, err_listening 
IF (err_listening[0] NE '') THEN BEGIN
;in log book
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED    
    IDLsendToGeek_addLogBookText, Event, err_listening
;in status dr frame
    status_text = 'Data Reduction ... FAILED (check log book)!'
    putTextFieldValue, Event, 'data_reduction_status_frame', status_text
ENDIF ELSE BEGIN
;in log book
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
;in status dr frame
    status_text = 'Data Reduction ... DONE WITH SUCCESS!'
    putTextFieldValue, Event, 'data_reduction_status_frame', status_text
    logbook_text = 'Information from Verbose Mode:'
    IDLsendToGeek_addLogBookText, Event, logbook_text
    IDLsendToGeek_addLogBookText, Event, listening
;make sure the output file exist and put its full name in the fitting
;tab
    output_folder = getButtonValue(Event,'output_folder')
    output_file = getTextfieldValue(Event, 'output_file_name')
    full_output_file_name = output_folder + output_file
    IF (FILE_TEST(full_output_file_name,/READ) THEN BEGIN
        putTextFieldValue, Event, 'input_file_text_field'
;move to fitting tab

    ENDIF ELSE BEGIN
        message = ['OUTPUT FILE NAME DOES NOT EXIST !',$
                   'FILE NAME : ' + full_output_file_name]
;turn off hourglass
        widget_control,hourglass=0
        status = DIALOG_MESSAGE(message, $
                                /ERROR,$
                                DIALOG_PARENT = id)
        id = WIDGET_INFO(Event.top,FIND_BY_UNAME='main_tab')
        WIDGET_CONTROL, id, SET_TAB_CURRENT=2
;LoadAsciiFile (to get the Plot)
        LoadAsciiFile, Event
    ENDELSE
ENDELSE
;turn off hourglass
widget_control,hourglass=0
END

