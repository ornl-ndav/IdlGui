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

;Procedure that will return all the global variables for this routine
FUNCTION idl_send_to_geek_getGlobalVariable, Event, var
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global
CASE (var) OF
    'LogBookPath'     : RETURN, '/SNS/users/LogBook/'
    'ApplicationName' : RETURN, 'plotROI'
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
FUNCTION idl_send_to_geek_GenerateIsoTimeStamp
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
FUNCTION idl_send_to_geek_getLogBookText, Event
LogBookUname = idl_send_to_geek_getGlobalVariable(Event,'LogBookUname')
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
PRO idl_send_to_geek_putLogBookText, Event, text
LogBookUname = idl_send_to_geek_getGlobalVariable(Event,'LogBookUname')
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, SET_VALUE=text
END

;------------------------------------------------------------------------------
PRO idl_send_to_geek_addLogBookText, Event, text
LogBookUname = idl_send_to_geek_getGlobalVariable(Event,'LogBookUname')
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, SET_VALUE=text, /APPEND
END

;------------------------------------------------------------------------------
PRO idl_send_to_geek_showLastLineLogBook, Event
LogBookUname = idl_send_to_geek_getGlobalVariable(Event,'LogBookUname')
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=LogBookUname)
WIDGET_CONTROL, id, GET_VALUE = text
sz = (SIZE(text))(1)
IF (sz GT 23) THEN BEGIN
    WIDGET_CONTROL, id, SET_TEXT_TOP_LINE=sz-22
ENDIF
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
PRO idl_send_to_geek_ReplaceLogBookText, Event, OLD_STRING, NEW_STRING

InitialStrarr = idl_send_to_geek_getLogBookText(Event)
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
idl_send_to_geek_putLogBookText, Event, FinalStrarr
END

;-------- SEND TO GEEK --------------------------------------------------------
;------------------------------------------------------------------------------
FUNCTION idl_send_to_geek_getMessage, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='sent_to_geek_text_field')
WIDGET_CONTROL, id, GET_VALUE=value
RETURN, value
END

;------------------------------------------------------------------------------
PRO SendToGeek, Event
;create full name of log Book file
LogBookPath   = idl_send_to_geek_getGlobalVariable(Event,'LogBookPath')
TimeStamp     = idl_send_to_geek_GenerateIsoTimeStamp()
application   = idl_send_to_geek_getGlobalVariable(Event,'ApplicationName')
FullFileName  = LogBookPath + application + '_' 
FullFileName += TimeStamp + '.log'

;get full text of LogBook
LogBookText   = idl_send_to_geek_getLogBookText(Event)

;add ucams 
ucams         = idl_send_to_geek_getGlobalVariable(Event,'ucams')
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
    idl_send_to_geek_putLogBookText, Event, LogBookText
ENDIF ELSE BEGIN
    OPENW, 1, FullFileName
    sz = (SIZE(LogBookText))(1)
    FOR i=0,(sz-1) DO BEGIN
        text = LogBookText[i]
        PRINTF, 1, text
    ENDFOR
    CLOSE,1
    FREE_LUN,1
    idl_send_to_geek_EmailLogBook, Event, FullFileName
ENDELSE
END


;This function send by email a copy of the logBook
PRO idl_send_to_geek_EmailLogBook, Event, FullFileName
Version   = idl_send_to_geek_getGlobalVariable(Event,'version')
ucams     = idl_send_to_geek_getGlobalVariable(Event,'ucams')
;add ucams 
ucamsText = 'Ucams: ' + ucams
;hostname
spawn, 'hostname', hostname
;get message added by user
message   = idl_send_to_geek_getMessage(Event)
;email logBook
text = "'Log Book of plotROI ("
text += Version + ") sent by " + ucams
text += " from " + hostname + "."
text += " Log Book is: " + FullFileName 
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
    idl_send_to_geek_putLogBookText, Event, LogBookText
ENDIF ELSE BEGIN
    application    = idl_send_to_geek_getGlobalVariable(Event, $
                                                        'ApplicationName')
    subject        = application + " LogBook"
    cmd  =  'echo ' + text + '| mail -s "' + subject + '" j35@ornl.gov'
    SPAWN, cmd
;tell the user that the email has been sent
    LogBookText = 'LogBook has been sent successfully !'
    idl_send_to_geek_addLogBookText, Event, LogBookText
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
                      SCR_YSIZE = 60,$
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
                   XSIZE,$
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

FUNCTION idl_send_to_geek::init, $
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

;Plot the frame and the add the title
MakeFrame, STGbase, $
  XSIZE, $
  FRAME, $
  TITLE

RETURN, 1
END

;******************************************************************************
;******  Class Define *********************************************************
;******************************************************************************
PRO idl_send_to_geek__define
STRUCT = { idl_send_to_geek,$
           var : ''}
END
;******************************************************************************
;******************************************************************************

PRO procedure_idl_send_to_geek
END
