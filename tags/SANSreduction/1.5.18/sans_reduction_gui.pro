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

PRO activate_widget, Event, uname, activate_status
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, SENSITIVE=activate_status
END

;------------------------------------------------------------------------------
PRO activate_widget_from_base, base, uname, status
  id = WIDGET_INFO(base, FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, SENSITIVE=status
END

;------------------------------------------------------------------------------
PRO activate_widget_list, Event, uname_list, activate_status
  sz = N_ELEMENTS(uname_list)
  FOR i=0,(sz-1) DO BEGIN
    activate_widget, Event, uname_list[i], activate_status
  ENDFOR
  
END

;------------------------------------------------------------------------------
;This function map or not the given base
PRO map_base, Event, uname, map_status
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, MAP=map_status
END

;This function map or not the given base
PRO MapBase, Event, uname=uname, map_status
  map_base, Event, uname, map_status
END

PRO MapBase_from_base, BASE=base, uname=uname, status
  id = WIDGET_INFO(base, FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, MAP=status
END

;------------------------------------------------------------------------------
;This function activates or not the GO DATA REDUCTION button
PRO activate_go_data_reduction, Event, activate_status
  activate_widget, Event, 'go_data_reduction_button', activate_status
END

;------------------------------------------------------------------------------
;This function returns the select value of the CW_BGROUP
FUNCTION getCWBgroupValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
PRO setCWBgroupValue, Event, uname, value
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, SET_VALUE=value
END

;------------------------------------------------------------------------------
;This function put the full path of the file as the new button label
PRO putNewButtonValue, Event, uname, value
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, SET_VALUE=value
END

;------------------------------------------------------------------------------
;This function clear off the display of the main plot
PRO ClearMainPlot, Event
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  ERASE
END

;------------------------------------------------------------------------------
PRO ChangeTitle, Event, uname=uname, title
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, BASE_SET_TITLE=title
END

;------------------------------------------------------------------------------
PRO ActivateTabNbr, Event=event, base=base, uname, tab_nbr
  IF (N_ELEMENTS(event) NE 0) THEN BEGIN
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(BASE, FIND_BY_UNAME=uname)
  ENDELSE
  WIDGET_CONTROL, id, SET_TAB_CURRENT=tab_nbr
END

;------------------------------------------------------------------------------
PRO activate_min_max_counts_widgets, Event, status
  activate_widget, Event, 'min_max_counts_displayed', status
END


