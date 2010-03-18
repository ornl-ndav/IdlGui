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

PRO activate_widget, Event, uname, status
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, SENSITIVE=status
END

;------------------------------------------------------------------------------
PRO ActivateWidget, EVENT=event, BASE=base, UNAME=uname, STATUS=status
  IF (N_ELEMENTS(event) NE 0) THEN BEGIN
    id = WIDGET_INFO(event.top, FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(base,FIND_BY_UNAME=uname)
  ENDELSE
  WIDGET_CONTROL, id, SENSITIVE=status
END

;------------------------------------------------------------------------------
PRO MapBase, EVENT=Event, BASE=base, UNAME=uname, STATUS=status
  IF (N_ELEMENTS(event) NE 0) THEN BEGIN
    id = WIDGET_INFO(event.top, FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(base,FIND_BY_UNAME=uname)
  ENDELSE
  WIDGET_CONTROL, id, MAP=status
END