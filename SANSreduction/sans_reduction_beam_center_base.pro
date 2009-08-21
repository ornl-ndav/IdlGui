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
  
    ;Main plot
    WIDGET_INFO(Event.top, FIND_BY_UNAME='beam_center_main_draw'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        
        IF (event.press EQ 1) THEN BEGIN ;pressed button
        ENDIF
        
        IF (event.press EQ 4) THEN BEGIN ;right click
          switch_cursor_shape, Event
        ENDIF
        
        
      ENDIF ELSE BEGIN ;endif of catch statement
        id = WIDGET_INFO(Event.top,$
          find_by_uname='beam_center_main_draw')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        WSET, id_value
        
        IF (event.enter EQ 1) THEN BEGIN
          ;check activated button
          curr_tab_selected = getCurrentTabSelect(Event,'beam_center_tab')
          CASE (curr_tab_selected) OF
            0: standard = (*global).current_cursor_status
            1: standard = (*global).current_cursor_status
            2: standard = (*global).cursor_selection
          ENDCASE
          DEVICE, CURSOR_STANDARD=standard
        ENDIF ELSE BEGIN ;leave main plot
          standard = (*global).cursor_selection
        ENDELSE
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE ;enf of catch statement
      
    END
    
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
    
    ;range calculation, beam stop region....etc TAB
    WIDGET_INFO(Event.top, FIND_BY_UNAME='beam_center_tab'): BEGIN
      prev_tab_selected = (*global).prev_tab_selected
      curr_tab_selected = getCurrentTabSelect(Event,'beam_center_tab')
      IF (curr_tab_selected NE prev_tab_selected) THEN BEGIN
        (*global).prev_tab_selected = curr_tab_selected
        CASE (curr_tab_selected) OF
          0: mode='button1_on'
          1: mode='button2_on'
          2: mode='button3_on'
        ENDCASE
        display_beam_stop_images, EVENT=event, MODE=mode
      ENDIF
    END
    
    ;CANCEL button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='beam_stop_cancel_button'): BEGIN
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='transmission_mode_launcher_base')
      WIDGET_CONTROL, id, /DESTROY
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
  
  global_bc = PTR_NEW({ wbase: wbase1,$
    main_global: global, $
    main_event: main_event, $
    
    current_cursor_status: 31,$ ;31(cross) or 52(move selection)
    cursor_selection: 31, $
    cursor_moving: 52, $
    
    min_pixel_plotted: 60,$
    max_pixel_plotted: 199, $
    min_tube_plotted: 40,$
    max_tube_plotted:159,$
    
    main_draw_xsize: 400,$
    main_draw_ysize: 350,$
    
    calibration_range_default_selection: {tube_min: 60, $
    tube_max: 135, $
    pixel_min: 100, $
    pixel_max: 160, $
    color: [255,0,0],$ ;red
    thick: 3}, $
    
    beam_stop_default_selection: {tube_min: 90, $
    tube_max: 101, $
    pixel_min: 121, $
    pixel_max: 134, $
    color: [0,255,0], $ ;blue but I want GREEN
    thick: 2}, $
    
    twoD_default_selection: {tube: 110, $
    pixel: 130, $
    color: [255,255,255],$
    linestyle: 2, $
    thick: 1}, $
    
    tt_zoom_data: PTR_NEW(0L), $
    rtt_zoom_data: PTR_NEW(0L), $
    background: PTR_NEW(0L), $
    
    prev_tab_selected: 0})
    
  WIDGET_CONTROL, wBase1, SET_UVALUE = global_bc
  
  display_beam_stop_images, main_base=wBase1, mode='button1_on'
  
  plot_data_for_beam_center_base, $
    BASE=wBase1, $
    MAIN_GLOBAL=global, $
    GLOBAL_BC = global_bc
    
  populate_defaults_wigets_values, wBase1, global_bc
  plot_default_beam_center_selections, base=wBase1, global=global_bc
  plot_beam_center_scale, wBase1, global_bc
  
  ;save background
  save_beam_center_background,  Event=event, BASE=wBase1
  
  XMANAGER, "launch_beam_center_base", wBase1, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END


