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

;HELPER FUNCTIONS
;this function removes from the intial text the given TextToRemove and 
;returns the result.
FUNCTION removeStringFromText, initialText, TextToRemove
;find where the 'textToRemove' starts
step1 = STRPOS(initialText,TexttoRemove)
;keep the text from the start of the line to the step1 position
step2 = STRMID(initialText,0,step1)
RETURN, step2
END

;-------------------------------------------------------------------------------

PRO putTextField, Event, uname, text
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SET_VALUE=text
END

;-------------------------------------------------------------------------------

;MAIN FUNCTIONS
PRO putLogBook, Event, text
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='log_book')
WIDGET_CONTROL, id, SET_VALUE = text
END

;-------------------------------------------------------------------------------

PRO putMyLogBook, Event, text
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='my_log_book')
WIDGET_CONTROL, id, SET_VALUE = text
END

;-------------------------------------------------------------------------------

PRO appendLogBook, Event, text
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='log_book')
WIDGET_CONTROL, id, SET_VALUE = text, /APPEND
END

;-------------------------------------------------------------------------------

PRO appendMyLogBook, Event, text
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='my_log_book')
WIDGET_CONTROL, id, SET_VALUE = text, /APPEND
END

;-------------------------------------------------------------------------------

PRO putOutputPath, Event, OutputPath
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='output_path_text')
WIDGET_CONTROL, id, SET_VALUE=STRCOMPRESS(OutputPath,/REMOVE_ALL)
END

;-------------------------------------------------------------------------------

PRO putOutputPath2, Event, OutputPath
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='output_path_text2')
WIDGET_CONTROL, id, SET_VALUE=STRCOMPRESS(OutputPath,/REMOVE_ALL)
END

;-------------------------------------------------------------------------------

;Add the given message at the end of the last string array element and
;put it back in the LogBook text field given
;If the optional RemoveString is present, the given String will be
;removed before adding the new MessageToAdd
PRO putTextAtEndOfLogBook, Event, MessageToAdd, MessageToRemove
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='log_book')
WIDGET_CONTROL, id, GET_VALUE=InitialStrarr
;get size of InitialStrarr
ArrSize = (SIZE(InitialStrarr))(1)
IF (N_ELEMENTS(MessageToRemove) EQ 0) THEN BEGIN $
;do not remove anything from last line
    IF (ArrSize GE 2) THEN BEGIN
        NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    ENDIF ELSE BEGIN
        FinalStrarr = InitialStrarr + MessageToAdd
    ENDELSE
ENDIF ELSE BEGIN                ;remove given string from last line
    IF (ArrSize GE 2) THEN BEGIN
        NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1], $
                                           MessageToRemove)
        NewLastLine += MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    ENDIF ELSE BEGIN
        NewInitialStrarr = removeStringFromText(InitialStrarr,MessageToRemove)
        FinalStrarr = NewInitialStrarr + MessageToAdd
    ENDELSE
ENDELSE
putLogBook, Event, FinalStrarr
END

;-------------------------------------------------------------------------------

;Add the given message at the end of the last string array element and
;put it back in the LogBook text field given
;If the optional RemoveString is present, the given String will be
;removed before adding the new MessageToAdd
PRO putTextAtEndOfMyLogBook, Event, MessageToAdd, MessageToRemove
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='my_log_book')
WIDGET_CONTROL, id, GET_VALUE=InitialStrarr
;get size of InitialStrarr
ArrSize = (SIZE(InitialStrarr))(1)
IF (N_ELEMENTS(MessageToRemove) EQ 0) THEN BEGIN $
;do not remove anything from last line
    IF (ArrSize GE 2) THEN BEGIN
        NewLastLine = InitialStrarr[ArrSize-1] + MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    ENDIF ELSE BEGIN
        FinalStrarr = InitialStrarr + MessageToAdd
    ENDELSE
ENDIF ELSE BEGIN                ;remove given string from last line
    IF (ArrSize GE 2) THEN BEGIN
        NewLastLine = removeStringFromText(InitialStrarr[ArrSize-1], $
                                           MessageToRemove)
        NewLastLine += MessageToAdd
        FinalStrarr = [InitialStrarr[0:ArrSize-2],NewLastLine]
    ENDIF ELSE BEGIN
        NewInitialStrarr = removeStringFromText(InitialStrarr,MessageToRemove)
        FinalStrarr = NewInitialStrarr + MessageToAdd
    ENDELSE
ENDELSE
putMyLogBook, Event, FinalStrarr
END

;-------------------------------------------------------------------------------

PRO putListOfProposal, Event, List
id = WIDGET_INFO(Event.top, FIND_BY_UNAME='proposal_droplist')
WIDGET_CONTROL, id, SET_VALUE=List
END

;-------------------------------------------------------------------------------
