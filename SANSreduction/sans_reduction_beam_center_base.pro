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

PRO launch_beam_center_base_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  CASE Event.id OF
  
    ;button1 (calibration region)
    WIDGET_INFO(Event.top, FIND_BY_UNAME='beam_center_button1'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_beam_stop_images, Event=event, mode='button1_on'
          show_beam_stop_tab, Event, tab='button1'
        ENDIF
      ENDIF ELSE BEGIN ;endif of catch statement
        id = WIDGET_INFO(Event.top,$
          find_by_uname='beam_center_button1')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        WSET, id_value
        IF (event.enter EQ 1) THEN BEGIN
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF ELSE BEGIN ;leave
          standard = 31
        ENDELSE
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE ;enf of catch statement
    END
    
    ;button2 (beam stop region)
    WIDGET_INFO(Event.top, FIND_BY_UNAME='beam_center_button2'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_beam_stop_images, Event=event, mode='button2_on'
          show_beam_stop_tab, Event, tab='button2'
        ENDIF
      ENDIF ELSE BEGIN ;endif of catch statement
        id = WIDGET_INFO(Event.top,$
          find_by_uname='beam_center_button2')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        WSET, id_value
        IF (event.enter EQ 1) THEN BEGIN
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF ELSE BEGIN ;leave
          standard = 31
        ENDELSE
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE ;enf of catch statement
    END
    
    ;button3 (2d plots)
    WIDGET_INFO(Event.top, FIND_BY_UNAME='beam_center_button3'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_beam_stop_images, Event=event, mode='button3_on'
          show_beam_stop_tab, Event, tab='button3'
        ENDIF
      ENDIF ELSE BEGIN ;endif of catch statement
        id = WIDGET_INFO(Event.top,$
          find_by_uname='beam_center_button3')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        WSET, id_value
        IF (event.enter EQ 1) THEN BEGIN
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF ELSE BEGIN ;leave
          standard = 31
        ENDELSE
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE ;enf of catch statement
    END
    
    
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO launch_beam_center_base, main_event

  id = WIDGET_INFO(main_event.top, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,main_event.top,GET_UVALUE=global
  
  ;build gui
  wBase1 = ''
  beam_center_base_gui, wBase1, $
    main_base_geometry
    
  WIDGET_CONTROL, wBase1, /REALIZE
  
  global_mask = PTR_NEW({ wbase: wbase1,$
    global: global,$
    main_event: main_event})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_mask
  
  display_beam_stop_images, main_base=wBase1, mode='button1_on'
  
  XMANAGER, "launch_beam_center_base", wBase1, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END


