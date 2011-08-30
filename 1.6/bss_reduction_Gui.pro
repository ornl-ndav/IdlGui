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

PRO activate_button, event, uname, activate_status
id = widget_info(event.top,find_by_uname=uname)
widget_control, id, sensitive=activate_status
END


PRO activate_base, event, uname, activate_status
id = widget_info(event.top,find_by_uname=uname)
widget_control, id, map=activate_status
END

;+
; :Description:
;    This will set or not a button
;
;
;
; :Keywords:
;    event
;    uname
;    value
;
; :Author: j35
;-
pro trigerButton, event=event, uname=uname, value=value
id = widget_info(event.top, find_by_uname=uname)
widget_control, id, set_button=value
end


PRO SetButton, event, uname, valueStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=valueStatus
END


PRO SetColorSliderValue, Event, index
id = widget_info(Event.top,find_by_uname='color_slider')
widget_control, id, set_value=index
END


PRO SetDropListIndex, Event, index
id = widget_info(Event.top,find_by_uname='loadct_droplist')
widget_control, id, set_droplist_select = index
END


PRO ActivateRefreshButton, event, activate_status
id = widget_info(event.top,find_by_uname='full_counts_vs_tof_refresh_button')
widget_control, id, sensitive=activate_status
END


PRO activate_output_couts_vs_tof_base, Event, activate_status
id = widget_info(event.top,find_by_uname='output_couts_vs_tof_base')
widget_control, id, map=activate_status
END

PRO SensitiveBase, Event, uname, status
activate_button, event, uname, status
END

;------------------------------------------------------------------------------
PRO putTableValue, Event, uname, table
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
WIDGET_CONTROL, id, SET_VALUE=table
END

;------------------------------------------------------------------------------
PRO select_first_node, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global
job_status_uname = (*(*global).job_status_uname)
wRoot = job_status_uname[0]
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=wRoot)
WIDGET_CONTROL, id, SET_TREE_SELECT=1
END

;------------------------------------------------------------------------------
PRO select_n_node, Event, n
WIDGET_CONTROL,Event.top,GET_UVALUE=global
job_status_uname = (*(*global).job_status_uname)
wRoot = job_status_uname[n]
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=wRoot)
WIDGET_CONTROL, id, SET_TREE_SELECT=1
END

;------------------------------------------------------------------------------
PRO updateJobStatusOutputBase, Event, status
SensitiveBase, Event, 'job_status_output_base', status
END

;------------------------------------------------------------------------------
PRO updateRefreshButtonLabel, Event
label_base = 'REFRESH LIST OF JOBS (last update: '
date_time  = GenerateTimeStamp()
label = label_base + date_time + ')'
putButtonValue, Event, 'refresh_list_of_jobs_button', label
END

