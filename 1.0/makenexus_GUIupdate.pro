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

PRO validateButton, Event, Uname, status
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SENSITIVE=status
END

;-------------------------------------------------------------------------------
PRO validateCreateNexusButton, Event, validate_status
id = widget_info(event.top,find_by_uname='create_nexus_button')
widget_control, id, sensitive=validate_status
END

;-------------------------------------------------------------------------------
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

;-------------------------------------------------------------------------------
PRO resetRunNumberField, Event
id = widget_info(event.top,find_by_uname='run_number_cw_field')
widget_control, id, set_value=''
END

;-------------------------------------------------------------------------------
PRO setHistogrammingTypeValue, Event, index
id = widget_info(Event.top,find_by_uname='bin_type_droplist')
widget_control, id, set_droplist_select=index
END

;-------------------------------------------------------------------------------
PRO ValidateArchivedButton, Event, status
validateButton, Event, 'archived_button', status
END


