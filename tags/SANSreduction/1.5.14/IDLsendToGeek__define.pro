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
    spawn, 'cp ' + list_OF_files[i] + ' ' + tmp_path, listening, err_listening
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
PRO create_tar_folder, Event, FullFileName, list_OF_files, FullTarFile
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
spawn, tar_cmd, listening

;remove tmp files
clean_tmp_files, [new_list_OF_files,FullFileName]

END

;------------------------------------------------------------------------------
;Procedure that will return all the global variables for this routine
FUNCTION IDLsendToGeek_getGlobalVariable, Event, var
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
CASE (var) OF
    'WorkingPath'     : RETURN, '~/'
    'LogBookPath'     : RETURN, './'
    'ApplicationName' : RETURN, (*global).application
    'LogBookUname'    : RETURN, 'log_book_text'
    'ucams'           : RETURN, (*global).ucams
    'version'         : RETURN, (*global).version
    ELSE:
ENDCASE
RETURN, 'NA'
END

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Change the format from Thu Aug 23 16:15:23 2007
;to 2007y_08m_23d_16h_15mn_23s
FUNCTION IDLsendToGeek_GenerateIsoTimeStamp
dateUnformated = systime()    
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
FUNCTION IDLsendToGeek_getLogBookText, Event
LogBookUname = IDLsendToGeek_getGlobalVariable(Event,'LogBookUname')
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;==============================================================================
FUNCTION IDLsendToGeek_getLogBookText_fromMainBase, MAIN_BASE, LogBookUname
id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
PRO IDLsendToGeek_putLogBookText, Event, text
LogBookUname = IDLsendToGeek_getGlobalVariable(Event,'LogBookUname')
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, SET_VALUE=text
END

;==============================================================================
PRO IDLsendToGeek_putLogBookText_fromMainBase, MAIN_BASE, LogBookUname, text
id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, SET_VALUE=text
END

;------------------------------------------------------------------------------
PRO IDLsendToGeek_addLogBookText, Event, text
LogBookUname = IDLsendToGeek_getGlobalVariable(Event,'LogBookUname')
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, SET_VALUE=text, /APPEND
END

;==============================================================================
PRO IDLsendToGeek_addLogBookText_fromMainBase, MAIN_BASE, LogBookUname, text
id = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, SET_VALUE=text, /APPEND
END

;------------------------------------------------------------------------------
;this function removes from the intial text the given TextToRemove and 
;returns the result.
FUNCTION removeStringFromText, initialText, TextToRemove
;find where the 'textToRemove' starts
step1 = strpos(initialText,TexttoRemove)
;keep the text from the start of the line to the step1 position
step2 = strmid(initialText,0,step1)
RETURN, step2
END

;------------------------------------------------------------------------------
PRO IDLsendToGeek_ReplaceLogBookText, Event, OLD_STRING, NEW_STRING

InitialStrarr = IDLsendToGeek_getLogBookText(Event)
ArrSize       = (SIZE(InitialStrarr))(1)
IF (N_ELEMENTS(OLD_STRING) EQ 0) THEN BEGIN 
;do not remove anything from last line
    IF (ArrSize GE 2) THEN BEGIN
        NewLastLine = InitialStrarr[ArrSize-1] + NEW_STRING
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    ENDIF ELSE BEGIN
        FinalStrarr = InitialStrarr + NEW_STRING
    ENDELSE
ENDIF ELSE BEGIN ;remove given string from last line
    IF (ArrSize GE 2) THEN BEGIN
        NewLastLine  = removeStringFromText(InitialStrarr[ArrSize-1], $
                                            OLD_STRING)
        NewLastLine += NEW_STRING
        FinalStrarr  = [InitialStrarr[0:ArrSize-2],NewLastLine]
    ENDIF ELSE BEGIN
        NewInitialStrarr = removeStringFromText(InitialStrarr,OLD_STRING)
        FinalStrarr      = NewInitialStrarr + NEW_STRING
    ENDELSE
ENDELSE
IDLsendToGeek_putLogBookText, Event, FinalStrarr
END

;==============================================================================
PRO IDLsendToGeek_ReplaceLogBookText_fromMainBase, MAIN_BASE, $
                                                   LogBookUname, $
                                                   OLD_STRING, $
                                                   NEW_STRING

InitialStrarr = IDLsendToGeek_getLogBookText_fromMainBase(MAIN_BASE, $
                                                          LogBookUname)
ArrSize       = (SIZE(InitialStrarr))(1)
IF (N_ELEMENTS(OLD_STRING) EQ 0) THEN BEGIN $
;do not remove anything from last line
    IF (ArrSize GE 2) THEN BEGIN
        NewLastLine = InitialStrarr[ArrSize-1] + NEW_STRING
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    ENDIF ELSE BEGIN
        FinalStrarr = InitialStrarr + NEW_STRING
    ENDELSE
ENDIF ELSE BEGIN ;remove given string from last line
    IF (ArrSize GE 2) THEN BEGIN
        NewLastLine  = removeStringFromText(InitialStrarr[ArrSize-1], $
                                            OLD_STRING)
        NewLastLine += NEW_STRING
        FinalStrarr  = [InitialStrarr[0:ArrSize-2],NewLastLine]
    ENDIF ELSE BEGIN
        NewInitialStrarr = removeStringFromText(InitialStrarr,OLD_STRING)
        FinalStrarr      = NewInitialStrarr + NEW_STRING
    ENDELSE
ENDELSE
IDLsendToGeek_putLogBookText_fromMainBase, MAIN_BASE, LogBookUname, FinalStrarr
END

;-------- SEND TO GEEK --------------------------------------------------------
;------------------------------------------------------------------------------
FUNCTION IDLsendToGeek_getMessage, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='sent_to_geek_text_field')
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
PRO SendToGeek, Event
;create full name of log Book file
LogBookPath   = IDLsendToGeek_getGlobalVariable(Event,'LogBookPath')
WorkingPath   = IDLsendToGeek_getGlobalVariable(Event,'WorkingPath')
TimeStamp     = IDLsendToGeek_GenerateIsoTimeStamp()
application   = IDLsendToGeek_getGlobalVariable(Event,'ApplicationName')
FullFileName  = LogBookPath + application + '_' 
FullTarFile   = application + '_' + TimeStamp + '.tar'
FullFileName += TimeStamp + '.log'

CD, '~/', CURRENT=current_path

;get full text of LogBook
LogBookText   = IDLsendToGeek_getLogBookText(Event)

;add ucams 
ucams         = IDLsendToGeek_getGlobalVariable(Event,'ucams')
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
    IDLsendToGeek_AddLogBookText, Event, LogBookText
ENDIF ELSE BEGIN
    OPENW, 1, FullFileName
    sz = (SIZE(LogBookText))(1)
    FOR i=0,(sz-1) DO BEGIN
        text = LogBookText[i]
        PRINTF, 1, text
    ENDFOR
    CLOSE,1
    FREE_LUN,1
    IDLsendToGeek_EmailLogBook, Event, FullFileName, FullTarFile
ENDELSE

;go back to initial folder
CD, current_path

END


;This function send by email a copy of the logBook
PRO IDLsendToGeek_EmailLogBook, Event, FullFileName, FullTarFile
WIDGET_CONTROL, Event.top, GET_UVALUE=global
version   = IDLsendToGeek_getGlobalVariable(Event,'version')
ucams     = IDLsendToGeek_getGlobalVariable(Event,'ucams')
;add ucams 
ucamsText = 'Ucams: ' + ucams
;hostname
spawn, 'hostname', hostname
;get message added by user
message   = IDLsendToGeek_getMessage(Event)
;email logBook
text = "'Log Book of SANSreduction "
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
If (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
;tell the user that the email has not been sent
    LogBookText = 'An error occured while contacting the GEEK. ' + $
      'Please email j35@ornl.gov!'
    IDLsendToGeek_putLogBookText, Event, LogBookText
ENDIF ELSE BEGIN
    application    = IDLsendToGeek_getGlobalVariable(Event,'ApplicationName')
    list_OF_files = (*(*global).list_OF_files_to_send)
    create_tar_folder, Event, FullFileName, list_OF_files, FullTarFile

    subject        = application + " LogBook"
    cmd  =  'echo ' + text + '| mutt -s "' + subject + '" -a ' + $
      FullTarFile
;    cmd += ' j35@ornl.gov'
  cmd += ' scsupport@ornl.gov'
    SPAWN, cmd
;tell the user that the email has been sent
    LogBookText = 'LogBook has been sent successfully !'
    IDLsendToGeek_addLogBookText, Event, LogBookText
;remove tar file
    spawn, 'rm ' + FullTarFile
ENDELSE
END

;==============================================================================
;==============================================================================
;This method defines the send_to_geek_base
FUNCTION MakeBase, MainBase,$ 
                   XOFFSET, $
                   YOFFSET, $
                   XSIZE

STGbase = WIDGET_BASE(MainBase,$
                      XOFFSET   = XOFFSET-5,$
                      YOFFSET   = YOFFSET-10,$
                      SCR_XSIZE = XSIZE+10,$
                      SCR_YSIZE = 80,$
                      UNAME     = 'send_to_geek_base',$
                      SENSITIVE = 1)
RETURN, STGbase
END



;------------------------------------------------------------------------------
;This method plots the Frame and adds the title 
PRO MakeFrame, STGbase, $
               XSIZE, $
               FRAME,$
               TITLE

;Define structures
sFrame = { size : [5,$
                   10,$
                   XSIZE-8,$
                   45],$
           frame : FRAME}

sTitle = { size : [20,$
                   sFrame.size[1]-8],$
           value : TITLE}
                  
;Define GUI
wTitle = WIDGET_LABEL(STGbase,$
                      XOFFSET = sTitle.size[0],$
                      YOFFSET = sTitle.size[1],$
                      VALUE   = sTitle.value)

wFrame = WIDGET_LABEL(STGbase,$
                      XOFFSET   = sFrame.size[0],$
                      YOFFSET   = sFrame.size[1],$
                      SCR_XSIZE = sFrame.size[2],$
                      SCR_YSIZE = sFrame.size[3],$
                      VALUE     = '',$
                      FRAME     = sFrame.frame)
END

;------------------------------------------------------------------------------
;This method adds the label, text_fiels and button
PRO MakeContain, STGbase, Xsize

;**Define Structure**
sLabel = { size  : [20,25],$
           value : 'Message:'}

XYoff  = [55,-5]
sTextField = { size : [sLabel.size[0]+XYoff[0],$
                       sLabel.size[1]+XYoff[1],$
                       Xsize - 180,$
                       34],$
               uname : 'sent_to_geek_text_field'}

XYoff = [0,0]
sButton = { size : [sTextField.size[0]+sTextField.size[2]+XYoff[0],$
                    sTextField.size[1]+XYoff[1],$
                    100,35],$
            value : 'SEND TO GEEK',$
            uname : 'send_to_geek_button'}

;**Define GUI**
wLabel = WIDGET_LABEL(STGbase,$
                      XOFFSET = sLabel.size[0],$
                      YOFFSET = sLabel.size[1],$
                      VALUE   = sLabel.value)

wTextField = WIDGET_TEXT(STGbase,$
                         XOFFSET   = sTextField.size[0],$
                         YOFFSET   = sTextField.size[1],$
                         SCR_XSIZE = sTextField.size[2],$
                         SCR_YSIZE = sTextField.size[3],$
                         UNAME     = sTextField.uname,$
                         /EDITABLE)

wButton = WIDGET_BUTTON(STGbase,$
                        XOFFSET   = sButton.size[0],$
                        YOFFSET   = sButton.size[1],$
                        SCR_XSIZE = sButton.size[2],$
                        SCR_YSIZE = sButton.size[3],$
                        UNAME     = sButton.uname,$
                        VALUE     = sButton.value)
                       
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------

FUNCTION IDLsendToGeek::init, $
                      XOFFSET   = XOFFSET,$
                      YOFFSET   = YOFFSET,$
                      XSIZE     = XSIZE,$
                      TITLE     = TITLE,$
                      FRAME     = FRAME,$
                      MAIN_BASE = MAIN_BASE

IF (n_elements(XOFFSET) EQ 0) THEN XOFFSET = 0
IF (n_elements(YOFFSET) EQ 0) THEN YOFFSET = 0
IF (n_elements(TITLE)   EQ 0) THEN TITLE   = 'SEND TO GEEK'
IF (n_elements(FRAME)   EQ 0) THEN FRAME   = 3

;Make the Send_to_geek Base
STGbase = MakeBase (MAIN_BASE, $
                    XOFFSET, $
                    YOFFSET, $
                    XSIZE)

;Plot contain (message label, widget_text and button)
MakeContain, STGbase, Xsize

;Plot the frame and add the title
MakeFrame, STGbase, $
  XSIZE, $
  FRAME, $
  TITLE

RETURN, 1
END

;******************************************************************************
;******  Class Define *********************************************************
;******************************************************************************
PRO IDLsendToGeek__define
STRUCT = { IDLsendToGeek,$
           var : ''}
END
;******************************************************************************
;******************************************************************************

