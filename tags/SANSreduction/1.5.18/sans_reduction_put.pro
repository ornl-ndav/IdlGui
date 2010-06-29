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
PRO putTextFieldValue, Event, uname, text
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SET_VALUE=text
END

;==============================================================================
PRO putTextFieldValueMainBase, wBase, UNAME=uname, value
id = WIDGET_INFO(wBase, FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SET_VALUE=value
END

;==============================================================================
PRO putArrayTextFieldValue, Event, uname_array, text
sz = N_ELEMENTS(uname_array)
FOR i=0,(sz-1) DO BEGIN
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname_array[i])
    WIDGET_CONTROL, id, SET_VALUE=text
ENDFOR
END

;==============================================================================
;This function put the command line in the command line text box
PRO putCommandLine, Event, cmd
putTextFieldValue, Event, 'comamnd_line_preview', cmd
END

;==============================================================================
PRO putTab1NexusFileName, Event, FileName
putTextFieldValue, Event, 'data_nexus_file_name', FileName
END

;==============================================================================
PRO putMissingArguments, Event, text
IF ((SIZE(text))(1) GT 1 AND text[0] EQ '') THEN BEGIN
    text = text[1:*]
ENDIF
putTextFieldValue, Event, 'data_reduction_missing_arguments', text
END

;==============================================================================
;This function tells in the title of the missing arguments text_field
;the number of missing arguments
PRO putMissingArgNumber, Event, missing_argument_counter
text = STRCOMPRESS(missing_argument_counter,/REMOVE_ALL) + ' Missing'
IF (missing_argument_counter EQ 0) THEN BEGIN
    text = ''
ENDIF ELSE BEGIN
    IF (missing_argument_counter EQ 1) THEN BEGIN
        text += ' Argument'
    ENDIF ELSE BEGIN
        text += ' Arguments'
    ENDELSE
ENDELSE
putTextFieldValue, Event, 'missing_arguments_label', text
END

;------------------------------------------------------------------------------
;This function put the list of proposal in the proposal droplist
PRO putProposalList, Event, ProposalList
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='proposal_droplist')
WIDGET_CONTROL, id, SET_VALUE=ProposalList
END

;------------------------------------------------------------------------------
PRO putNewButtonValue, Event, uname, string
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SET_VALUE=string
END

;------------------------------------------------------------------------------
PRO putCountsValue, Event, x, y
WIDGET_CONTROL, Event.top, GET_UVALUE=global
img = (*(*global).img)
putTextFieldValue, Event, 'counts_value', STRCOMPRESS(LONG(img[x,y]), $
                                                      /REMOVE_ALL)
END

