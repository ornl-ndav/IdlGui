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

PRO launch_transmission_auto_manual_base_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  CASE Event.id OF
  
    ;auto button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='auto_mode_button'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_auto_base_launcher_images, Event=event, mode='auto_on'
        ENDIF
        ENDIF ELSE BEGIN ;endif of catch statement
        IF (event.enter EQ 1) THEN BEGIN
          display_auto_base_launcher_images, Event=event, mode='auto_over'
          id = WIDGET_INFO(Event.top,$
            find_by_uname='auto_mode_button')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF ELSE BEGIN ;leave
          display_auto_base_launcher_images, Event=event, mode='off'
        ENDELSE
      ENDELSE ;enf of catch statement
    END
    
    ;manual button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='manual_mode_button'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_auto_base_launcher_images, Event=event, mode='manual_on'
          main_event = (*global).main_event
          wait, 1
          id = WIDGET_INFO(Event.top, $
            FIND_BY_UNAME='transmission_mode_launcher_base')
          WIDGET_CONTROL, id, /DESTROY
          launch_transmission_manual_mode_base, main_event
        ENDIF
      ENDIF ELSE BEGIN ;endif of catch statement
        IF (event.enter EQ 1) THEN BEGIN
          display_auto_base_launcher_images, Event=event, mode='manual_over'
          id = WIDGET_INFO(Event.top,$
            find_by_uname='manual_mode_button')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF ELSE BEGIN ;leave
          display_auto_base_launcher_images, Event=event, mode='off'
        ENDELSE
      ENDELSE ;enf of catch statement
    END
    
    ;CANCEL button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='cancel_auto_manual_mode_base'): BEGIN
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='transmission_mode_launcher_base')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------

PRO display_auto_base_launcher_images, main_base=main_base, Event=event, $
    mode=mode
    
  IF (N_ELEMENTS(mode) EQ 0) THEN mode='off'
  
  path = 'SANSreduction_images/'
  auto_png = path + ['automatic_shift_on',$
    'automatic_shift_mouse_over',$
    'automatic_shift_mouse_off'] + '.png'
  manual_png = path + ['manual_shift_on',$
    'manual_shift_mouse_over',$
    'manual_shift_mouse_off'] + '.png'
    
  CASE (mode) OF
    'auto_on': BEGIN
      auto = auto_png[0]
      manual = manual_png[2]
    END
    'auto_over': BEGIN
      auto = auto_png[1]
      manual = manual_png[2]
    END
    'auto_off': BEGIN
      auto = auto_png[2]
      manual = manual_png[2]
    END
    'manual_on': BEGIN
      auto = auto_png[2]
      manual = manual_png[0]
    END
    'manual_off': BEGIN
      auto = auto_png[2]
      manual = manual_png[2]
    END
    'manual_over': BEGIN
      auto = auto_png[2]
      manual = manual_png[1]
    END
    'off': BEGIN
      auto = auto_png[2]
      manual = manual_png[2]
    END
  ENDCASE
  auto_button = READ_PNG(auto)
  manual_button = READ_PNG(manual)
  
  auto_uname = 'auto_mode_button'
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, $
      FIND_BY_UNAME=auto_uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME=auto_uname)
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, auto_button, 0, 0,/true
  
  manual_uname = 'manual_mode_button'
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, $
      FIND_BY_UNAME=manual_uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME=manual_uname)
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, manual_button, 0, 0,/true
  
END

;------------------------------------------------------------------------------
PRO transmission_launcher_base_gui, wBase, main_base_geometry

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xoffset = main_base_xoffset + main_base_xsize/2-300
  yoffset = main_base_yoffset + main_base_ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Transmission Calculation Mode',$
    UNAME        = 'transmission_mode_launcher_base',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    /BASE_ALIGN_CENTER,$
    /MODAL,$
    GROUP_LEADER = ourGroup,$
    /COLUMN)
    
  ;row1
  row1 = WIDGET_BASE(wBase,$
    /ROW)
    
  ;auto mode
  auto = WIDGET_DRAW(row1,$
    UNAME = 'auto_mode_button',$
    SCR_XSIZE = 300,$
    SCR_YSIZE = 254,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    TOOLTIP='The TRANSMISSION signal will be calculated automatically')
    
  ;manual mode
  message = 'The program is going to quide you step by step to calculate'
  message += ' the TRANSMISSION signal'
  manual = WIDGET_DRAW(row1,$
    UNAME = 'manual_mode_button',$
    SCR_XSIZE = 300,$
    SCR_YSIZE = 254,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS, $
    TOOLTIP = message)
    
  ;row2
  cancel = WIDGET_BUTTON(wBase,$
    VALUE = 'CANCEL',$
    UNAME = 'cancel_auto_manual_mode_base',$
    SCR_XSIZE = 500)
    
  WIDGET_CONTROL, wBase, /REALIZE
  
END

;------------------------------------------------------------------------------

PRO  launch_transmission_auto_manual_base, main_event

  id = WIDGET_INFO(main_event.top, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,main_event.top,GET_UVALUE=global
  
  ;build gui
  wBase = ''
  transmission_launcher_base_gui, wBase, $
    main_base_geometry
    
  global_mask = PTR_NEW({ wbase: wbase,$
    global: global,$
    main_event: main_event})
    
  display_auto_base_launcher_images, main_base=wBase, mode='off'
  
  WIDGET_CONTROL, wBase, SET_UVALUE = global_mask
  XMANAGER, "launch_transmission_auto_manual_base", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END


