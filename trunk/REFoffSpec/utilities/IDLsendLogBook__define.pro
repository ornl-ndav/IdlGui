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

;Procedure that will return all the global variables for this routine
FUNCTION IDLsendLogBook_getGlobalVariable, Event, var
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
CASE (var) OF
    'WorkingPath'     : RETURN, (*global).browsing_path
    'LogBookPath'     : RETURN, './'
    'ApplicationName' : RETURN, (*global).application
    'LogBookUname'    : RETURN, 'log_book_text'
    'LogBookMessageId': RETURN, 'sent_to_geek_text_field'
    'ucams'           : RETURN, (*global).ucams
    'version'         : RETURN, (*global).version
    ELSE:
ENDCASE
RETURN, 'NA'
END

;==============================================================================
;==============================================================================

PRO IDLsendLogBook_addLogBookText, Event, text
LogBookUname = IDLsendLogBook_getGlobalVariable(Event,'LogBookUname')
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, SET_VALUE=text, /APPEND
END

;------------------------------------------------------------------------------
FUNCTION IDLsendLogBook_getLogBookText, Event
LogBookUname = IDLsendLogBook_getGlobalVariable(Event,'LogBookUname')
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION IDLsendLogBook_getMessage, Event
MessageUname = IDLsendLogBook_getGlobalVariable(Event,'LogBookMessageId')
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=MessageUname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
PRO IDLsendLogBook_putLogBookText, Event, text
LogBookUname = IDLsendLogBook_getGlobalVariable(Event,'LogBookUname')
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, SET_VALUE=text
END

;**********************************************************************
;GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL - GLOBAL
;**********************************************************************
FUNCTION cp_to_relative_folder, list_OF_files
tmp_path = './'
new_list_OF_files = list_OF_files
sz = N_ELEMENTS(list_OF_files)
i = 0
WHILE (i LT sz) DO BEGIN
    base_name = FILE_BASENAME(list_OF_files[i])
    new_list_OF_files[i] = tmp_path + base_name
;copy file
    spawn, 'cp ' + list_OF_files[i] + ' ' + tmp_path, listening, err_listening
;change permission of file
    spawn, 'chmod 755 ' + list_OF_files[i], listening, err_listening
    ++i
ENDWHILE
RETURN, new_list_OF_files
END

;------------------------------------------------------------------------------
PRO clean_tmp_files, new_list_OF_files
new_list = STRJOIN(new_list_OF_files, ' ')
SPAWN, 'rm ' + new_list, listening
END

;------------------------------------------------------------------------------
PRO create_tar_folder, Event, $
                       FullFileName, $
                       list_OF_files, $
                       FullTarFile

index = WHERE(list_OF_files NE '', nbr)

;copy all the files in ./ directory to be sure we are working with
;relative path
sz = N_ELEMENTS(list_OF_files)
IF (sz GT 0 AND $
    list_OF_files[0] NE '') THEN BEGIN
    new_list_OF_files = cp_to_relative_folder(list_OF_files)
ENDIF ELSE BEGIN
    new_list_OF_files = ['']
ENDELSE

IF (nbr GT 0) THEN BEGIN
    final_list1 = new_list_OF_files(index)
    final_list = [FullFileName,final_list1]
ENDIF ELSE BEGIN
    final_list = [FullFileName]
ENDELSE

tar_cmd = 'tar cvf ' + FullTarFile
nbr_files = N_ELEMENTS(final_list)
i=0

WHILE (i LT nbr_files) DO BEGIN
    tar_cmd += ' ' + final_list[i]
    ++i
ENDWHILE
SPAWN, tar_cmd, listening

;remove tmp files
clean_tmp_files, [new_list_OF_files,FullFileName]

END

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Change the format from Thu Aug 23 16:15:23 2007
;to 2007y_08m_23d_16h_15mn_23s
FUNCTION IDLsendLogBook_GenerateIsoTimeStamp
dateUnformated = SYSTIME()    
DateArray      = STRSPLIT(dateUnformated,' ',/EXTRACT) 
DateIso        = STRCOMPRESS(DateArray[4]) + 'y_'
month = 0
CASE (DateArray[1]) OF
    'Jan':month='01m'
    'Feb':month='02m'
    'Mar':month='03m'
    'Apr':month='04m'
    'May':month='05m'
    'Jun':month='06m'
    'Jul':month='07m'
    'Aug':month='08m'
    'Sep':month='09m'
    'Oct':month='10m'
    'Nov':month='11m'
    'Dec':month='12m'
ENDCASE
DateIso += STRCOMPRESS(month,/REMOVE_ALL) + '_'
DateIso += STRCOMPRESS(DateArray[2],/REMOVE_ALL) + 'd_'
;change format of time
time     = STRSPLIT(DateArray[3],':',/EXTRACT)
DateIso += STRCOMPRESS(time[0],/REMOVE_ALL) + 'h_'
DateIso += STRCOMPRESS(time[1],/REMOVE_ALL) + 'mn_'
DateIso += STRCOMPRESS(time[2],/REMOVE_ALL) + 's'
RETURN, DateIso
END

;------------------------------------------------------------------------------
PRO IDLsendLogBook_SendToGeek, Event, $
                               LIST_OF_FILES_TO_TAR=list_OF_files_to_tar

;create full name of log Book file
LogBookPath   = IDLsendLogBook_getGlobalVariable(Event,'LogBookPath')
WorkingPath   = IDLsendLogBook_getGlobalVariable(Event,'WorkingPath')
TimeStamp     = IDLsendLogBook_GenerateIsoTimeStamp()
application   = IDLsendLogBook_getGlobalVariable(Event,'ApplicationName')
FullFileName  = LogBookPath + application + '_' 
FullTarFile   = application + '_' + TimeStamp + '.tar'
FullFileName += TimeStamp + '.log'

CD, '~/', CURRENT=current_path

;get full text of LogBook
LogBookText   = IDLsendLogBook_getLogBookText(Event)

;add ucams 
ucams         = IDLsendLogBook_getGlobalVariable(Event,'ucams')
ucamsText     = 'Ucams: ' + ucams
LogBookText   = [ucamsText,LogBookText]

;output file
no_error = 0
CATCH, no_error
If (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
;tell the user that the email has not been sent
    LogBookText = 'An error occured while contacting the GEEK. ' + $
      'Please email j35@ornl.gov!'
    IDLsendLogBook_AddLogBookText, Event, LogBookText
ENDIF ELSE BEGIN
    OPENW, 1, FullFileName
    sz = (SIZE(LogBookText))(1)
    FOR i=0,(sz-1) DO BEGIN
        text = LogBookText[i]
        PRINTF, 1, text
    ENDFOR
    CLOSE,1
    FREE_LUN,1
    IDLsendLogBook_EmailLogBook, Event, $
      FullFileName, $
      FullTarFile, $
      LIST_OF_FILES_TO_TAR=list_OF_files_to_tar
ENDELSE

;go back to initial folder
CD, current_path

END

;------------------------------------------------------------------------------
;This function send by email a copy of the logBook
PRO IDLsendLogBook_EmailLogBook, Event, $
                                 FullFileName, $
                                 FullTarFile, $
                                 LIST_OF_FILES_TO_TAR=list_OF_files_to_tar

WIDGET_CONTROL, Event.top, GET_UVALUE=global
version     = IDLsendLogBook_getGlobalVariable(Event,'version')
ucams       = IDLsendLogBook_getGlobalVariable(Event,'ucams')
application = IDLsendLogBook_getGlobalVariable(Event,'ApplicationName')
;add ucams 
ucamsText = 'Ucams: ' + ucams
;hostname
spawn, 'hostname', hostname
;get message added by user
message   = IDLsendLogBook_getMessage(Event)
;email logBook
text = "'Log Book of " + application
text += version + " sent by " + ucams
text += " from " + hostname + "."
text += ". Message is: "

IF (message NE '') THEN BEGIN
    text += message
ENDIF ELSE BEGIN
    text += "No messages added."
ENDELSE
text += "'"

no_error = 0
CATCH, no_error
IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
;tell the user that the email has not been sent
    LogBookText = 'An error occured while contacting the GEEK. ' + $
      'Please email j35@ornl.gov!'
    IDLsendLogBook_putLogBookText, Event, LogBookText
ENDIF ELSE BEGIN
    application    = IDLsendLogBook_getGlobalVariable(Event,'ApplicationName')
    list_OF_files  = list_OF_files_to_tar
;create tar files only if list_of_files has more than 1 file
    IF (N_ELEMENTS(list_OF_files_to_tar) NE 0) THEN BEGIN
        create_tar_folder, Event, FullFileName, list_OF_files, FullTarFile
        subject        = application + " LogBook"
        cmd  =  'echo ' + text + '| mutt -s "' + subject + '" -a ' + $
          FullTarFile
        cmd += ' j35@ornl.gov'
    ENDIF ELSE BEGIN
        subject        = application + " LogBook"
        cmd  =  'echo ' + text + '| mutt -s "' + subject 
        cmd += ' j35@ornl.gov'
    ENDELSE
    SPAWN, cmd

;tell the user that the email has been sent
    LogBookText = 'LogBook has been sent successfully !'
    IDLsendLogBook_addLogBookText, Event, LogBookText

;remove tar file
    IF (N_ELEMENTS(list_OF_files_to_tar) NE 0) THEN BEGIN
        SPAWN, 'rm ' + FullTarFile
    ENDIF
ENDELSE
END

;==============================================================================
FUNCTION IDLsendLogBook::init, Event, $
                       LIST_OF_FILES_TO_TAR=list_OF_files_to_tar
IDLsendLogBook_SendToGeek, Event, $
  LIST_OF_FILES_TO_TAR=list_OF_files_to_tar
RETURN, 1
END

;******************************************************************************
;******  Class Define *********************************************************
;******************************************************************************
PRO IDLsendLogBook__define
STRUCT = { IDLsendLogBook,$
           var : ''}
END
;******************************************************************************
;******************************************************************************

