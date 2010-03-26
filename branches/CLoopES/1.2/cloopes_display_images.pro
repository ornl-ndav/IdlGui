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

PRO display_tab1_error, MAIN_BASE=main_base, Event=event, STATUS=status

  ;first, map the base
  uname = 'tab1_error_base'
  MapBase, EVENT=Event, BASE=main_base, UNAME=uname, STATUS=status
  
  table_status = 0
  IF (status EQ 0) THEN table_status = 1
  uname = 'runs_table'
  ActivateWidget, EVENT=event, BASE=main_base, UNAME=uname, STATUS=table_status
  ActivateWidget, EVENT=event, BASE=main_base, UNAME='runs_table_label',$
  STATUS=table_status
  
  IF (status EQ 0) THEN RETURN
  
  image = READ_PNG('CLoopES_images/format_error.png')
  uname = 'error_draw'
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, $
      FIND_BY_UNAME=uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME=uname)
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, image, 0, 0,/true
  
  wait, 3
  uname = 'tab1_error_base'
  MapBase, EVENT=Event, BASE=main_base, UNAME=uname, STATUS=0
  
  
END
