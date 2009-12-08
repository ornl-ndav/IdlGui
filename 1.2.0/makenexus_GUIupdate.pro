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

PRO validateButton, Event, Uname, status
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SENSITIVE=status
END

;------------------------------------------------------------------------------
PRO validateCreateNexusButton, Event, validate_status
id = widget_info(event.top,find_by_uname='create_nexus_button')
widget_control, id, sensitive=validate_status
END

;------------------------------------------------------------------------------
PRO validateSendToGeek, Event, validate_status
uname_array = ['send_to_geek_button',$
               'send_to_geek_label',$
               'send_to_geek_text']
sz = (size(uname_array))(1)
FOR i=0,(sz-1) DO BEGIN
    id = widget_info(event.top,find_by_uname=uname_array[i])
    widget_control, id, sensitive=validate_status
ENDFOR
END

;------------------------------------------------------------------------------
PRO resetRunNumberField, Event
id = widget_info(event.top,find_by_uname='run_number_cw_field')
widget_control, id, set_value=''
END

;------------------------------------------------------------------------------
PRO setHistogrammingTypeValue, Event, index
id = widget_info(Event.top,find_by_uname='bin_type_droplist')
widget_control, id, set_droplist_select=index
END

;------------------------------------------------------------------------------
PRO ValidateArchivedButton, Event, status
validateButton, Event, 'archived_button', status
END

;------------------------------------------------------------------------------
;This procedure allows the debugger to see the bottom of my log book
PRO showLastLogBookLine, Event
LogBook = getMyLogBookText(Event)
sz      = (SIZE(LogBook))(1)
id      = WIDGET_INFO(Event.top,FIND_BY_UNAME='my_log_book')
WIDGET_CONTROL, id, SET_TEXT_TOP_LINE=(sz-10)
END

;------------------------------------------------------------------------------
;This procedure allows the debugger to see the bottom of the log book
PRO showLastUserLogBookLine, Event
LogBook = getLogBookText(Event)
sz      = (SIZE(LogBook))(1)
id      = WIDGET_INFO(Event.top,FIND_BY_UNAME='log_book')
WIDGET_CONTROL, id, SET_TEXT_TOP_LINE=(sz-5)
END

;------------------------------------------------------------------------------
;This function set the index of the droplist
PRO setProposalDroplistIndex, Event, index
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='proposal_droplist')
WIDGET_CONTROL, id, SET_DROPLIST_SELECT=index
END

;------------------------------------------------------------------------------
;This function validate the histogramming base
PRO validateHistoBase, Event, status
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='binning_base')
WIDGET_CONTROL, id, SENSITIVE=status
END

;------------------------------------------------------------------------------
PRO UpdateRunInfoDroplist, Event, prenexus_path_array
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='preview_droplist')
WIDGET_CONTROL, id, SET_VALUE=prenexus_path_array
END

;------------------------------------------------------------------------------
PRO populateRunInfoDroplist, Event
id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
WIDGET_CONTROL,id,GET_UVALUE=global
;_runinfo.xml
runinfo_ext    = (*global).runinfo_ext
;3890                   
run_number     = (*(*global).RunNumber_array)
sz             = (size(run_number))(1)
;instrument
instrument     = getInstrument(Event)

prenexus_path = STRARR(sz)
prenexus_path += instrument
prenexus_path += '_'
prenexus_path += run_number
prenexus_path += runinfo_ext

;determine which string is longer
max = 0
FOR i=0,(sz-1) DO BEGIN
    IF (strlen(prenexus_path[i]) GE max) THEN BEGIN
        max = strlen(prenexus_path[i])
    ENDIF
ENDFOR

spc_size = 33
IF (max LT spc_size) THEN BEGIN
    spc = ''
    FOR i=0,(spc_size-max) DO BEGIN
        spc += ' '
    ENDFOR
    prenexus_path += spc
ENDIF

UpdateRunInfoDroplist, Event, prenexus_path
END
