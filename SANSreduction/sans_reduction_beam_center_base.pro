;================================= =============================================
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
    
      curr_tab_selected = getCurrentTabSelect(Event,'beam_center_tab')
      
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        
        ;just moving the mouse over the main plot
        CASE (curr_tab_selected) OF
          1: BEGIN ;Calculation range
            tube_data  = getBeamCenterTubeData_from_device(Event.x, global)
            putTextFieldValue, Event, 'beam_center_2d_plot_tube', $
              STRCOMPRESS(tube_data,/REMOVE_ALL)
            pixel_data = getBeamCenterPixelData_from_device(Event.y, global)
            putTextFieldValue, Event, 'beam_center_2d_plot_pixel', $
              STRCOMPRESS(pixel_data,/REMOVE_ALL)
            plot_beam_center_background, Event
            ;            replot_beam_center_calibration_range, Event
            replot_beam_center_beam_stop, Event
            replot_calculation_range_cursor, Event
            plot_calculation_range_selection, Event
            display_counts_vs_pixel_and_tube_live, Event
          END
          ELSE:
        ENDCASE
        
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          (*global).left_button_pressed = 1
          curr_cursor = (*global).current_cursor_status
          IF (curr_cursor EQ (*global).cursor_selection) THEN BEGIN ;selection
            CASE (curr_tab_selected) OF
              ;              2: BEGIN ;Data Range Displayed
              ;                ;need to reset the tube and pixel values
              ;                putTextFieldValue, Event, 'beam_center_calculation_tube_right',$
              ;                  'N/A'
              ;                putTextFieldValue, Event, 'beam_center_calculation_pixel_right',$
              ;                  'N/A'
              ;                tube_data  = getBeamCenterTubeData_from_device(Event.x, global)
              ;                putTextFieldValue, Event, 'beam_center_calculation_tube_left', $
              ;                  STRCOMPRESS(tube_data,/REMOVE_ALL)
              ;                pixel_data = getBeamCenterPixelData_from_device(Event.y, global)
              ;                putTextFieldValue, Event, 'beam_center_calculation_pixel_left', $
              ;                  STRCOMPRESS(pixel_data,/REMOVE_ALL)
              ;              END
              0: BEGIN;beam stop region
                ;need to reset the tube and pixel values
                putTextFieldValue, Event, 'beam_center_beam_stop_tube_right',$
                  'N/A'
                putTextFieldValue, Event, 'beam_center_beam_stop_pixel_right',$
                  'N/A'
                tube_data  = getBeamCenterTubeData_from_device(Event.x, global)
                putTextFieldValue, Event, 'beam_center_beam_stop_tube_left', $
                  STRCOMPRESS(tube_data,/REMOVE_ALL)
                pixel_data = getBeamCenterPixelData_from_device(Event.y, global)
                putTextFieldValue, Event, 'beam_center_beam_stop_pixel_left', $
                  STRCOMPRESS(pixel_data,/REMOVE_ALL)
              END
              1: BEGIN ;Calculation Range
                plot_beam_center_background, Event
                replot_beam_center_beam_stop, Event
                record_calculation_range_value, Event
                plot_calculation_range_selection, Event
                replot_calculation_range_cursor, Event
              END
            ENDCASE
          ENDIF ELSE BEGIN ;moving selection
            CASE (curr_tab_selected) OF
              ;              2: BEGIN;Data Range Displayed
              ;                tube_data  = getBeamCenterTubeData_from_device(Event.x, global)
              ;                (*global).calibration_range_moving_tube_start = tube_data
              ;                pixel_data = getBeamCenterPixelData_from_device(Event.y, global)
              ;                (*global).calibration_range_moving_pixel_start = pixel_data
              ;              END
              0: BEGIN ;Beam Stop Region
                tube_data  = getBeamCenterTubeData_from_device(Event.x, global)
                (*global).beam_stop_range_moving_tube_start = tube_data
                pixel_data = getBeamCenterPixelData_from_device(Event.y, global)
                (*global).beam_stop_range_moving_pixel_start = pixel_data
              END
              1: BEGIN ;Calculation Range
                plot_beam_center_background, Event
                replot_beam_center_beam_stop, Event
                record_calculation_range_value, Event
                plot_calculation_range_selection, Event
                replot_calculation_range_cursor, Event
              END
            ENDCASE
          ENDELSE
        ENDIF
        
        IF (event.press EQ 0 AND $ ;moving mouse with button pressed
          (*global).left_button_pressed EQ 1) THEN BEGIN
          ;          curr_tab_selected = getCurrentTabSelect(Event,'beam_center_tab')
          curr_cursor = (*global).current_cursor_status
          IF (curr_cursor EQ (*global).cursor_selection) THEN BEGIN ;selection
            CASE (curr_tab_selected) OF
              ;              2: BEGIN ;Data Range Displayed
              ;                plot_beam_center_background, Event
              ;                tube_data  = getBeamCenterTubeData_from_device(Event.x, global)
              ;                putTextFieldValue, Event, 'beam_center_calculation_tube_right', $
              ;                  STRCOMPRESS(tube_data,/REMOVE_ALL)
              ;                pixel_data = getBeamCenterPixelData_from_device(Event.y, global)
              ;                putTextFieldValue, Event, 'beam_center_calculation_pixel_right', $
              ;                  STRCOMPRESS(pixel_data,/REMOVE_ALL)
              ;                replot_beam_center_calibration_range, Event
              ;                replot_beam_center_beam_stop, Event
              ;              END
              0: BEGIN ;Beam Stop Region
                plot_beam_center_background, Event
                tube_data  = getBeamCenterTubeData_from_device(Event.x, global)
                putTextFieldValue, Event, 'beam_center_beam_stop_tube_right', $
                  STRCOMPRESS(tube_data,/REMOVE_ALL)
                pixel_data = getBeamCenterPixelData_from_device(Event.y, global)
                putTextFieldValue, Event, 'beam_center_beam_stop_pixel_right', $
                  STRCOMPRESS(pixel_data,/REMOVE_ALL)
                ;                replot_beam_center_calibration_range, Event
                replot_beam_center_beam_stop, Event
                plot_calculation_range_selection, Event, MODE_DISABLE=1
              END
              1: BEGIN ;Calculation Range
                plot_beam_center_background, Event
                replot_beam_center_beam_stop, Event
                record_calculation_range_value, Event
                plot_calculation_range_selection, Event
                replot_calculation_range_cursor, Event
              END
            ENDCASE
          ENDIF ELSE BEGIN ;moving selection
            CASE (curr_tab_selected) OF
              ;              2: BEGIN ;Data Range Displayed
              ;                plot_beam_center_background, Event
              ;                IF (validate_or_not_calibration_range_moving(Event)) THEN BEGIN
              ;
              ;                  X = Event.x
              ;                  Y = Event.y
              ;                  tube_data  = getBeamCenterTubeData_from_device(X, global)
              ;                  pixel_data = getBeamCenterPixelData_from_device(Y, global)
              ;                  offset_tube = tube_data - $
              ;                    (*global).calibration_range_moving_tube_start
              ;                  offset_pixel = pixel_data - $
              ;                    (*global).calibration_range_moving_pixel_start
              ;
              ;                  tube_min_data = FIX(getTextFieldValue(Event,$
              ;                    'beam_center_calculation_tube_left'))
              ;                  tube_max_data = FIX(getTextFieldValue(Event,$
              ;                    'beam_center_calculation_tube_right'))
              ;                  pixel_min_data = FIX(getTextFieldValue(Event,$
              ;                    'beam_center_calculation_pixel_left'))
              ;                  pixel_max_data = FIX(getTextFieldValue(Event,$
              ;                    'beam_center_calculation_pixel_right'))
              ;
              ;                  tube_min = MIN([tube_min_data,tube_max_data],MAX=tube_max)
              ;                  pixel_min = MIN([pixel_min_data,pixel_max_data],MAX=pixel_max)
              ;
              ;                  new_tube_min = tube_min_data + offset_tube
              ;                  new_tube_max = tube_max_data + offset_tube
              ;
              ;                  IF (new_tube_min LT (*global).min_tube_plotted) THEN BEGIN
              ;                    new_tube_min = (*global).min_tube_plotted
              ;                    new_tube_max = tube_max_data
              ;                    tube_data = (*global).calibration_range_moving_tube_start
              ;                  ENDIF
              ;                  IF (new_tube_max GT (*global).max_tube_plotted) THEN BEGIN
              ;                    new_tube_max = (*global).max_tube_plotted
              ;                    new_tube_min = tube_min_data
              ;                    tube_data = (*global).calibration_range_moving_tube_start
              ;                  ENDIF
              ;
              ;                  putTextFieldValue, Event, $
              ;                    'beam_center_calculation_tube_left', $
              ;                    STRCOMPRESS(new_tube_min,/REMOVE_ALL)
              ;                  putTextFieldValue, Event, $
              ;                    'beam_center_calculation_tube_right', $
              ;                    STRCOMPRESS(new_tube_max,/REMOVE_ALL)
              ;
              ;                  (*global).calibration_range_moving_tube_start = tube_data
              ;
              ;                  new_pixel_min = pixel_min_data + offset_pixel
              ;                  new_pixel_max = pixel_max_data + offset_pixel
              ;
              ;                  IF (new_pixel_min LT (*global).min_pixel_plotted) THEN BEGIN
              ;                    new_pixel_min = (*global).min_pixel_plotted
              ;                    new_pixel_max = pixel_max_data
              ;                    pixel_data = (*global).calibration_range_moving_pixel_start
              ;                  ENDIF
              ;                  IF (new_pixel_max GT (*global).max_pixel_plotted) THEN BEGIN
              ;                    new_pixel_max = (*global).max_pixel_plotted
              ;                    new_pixel_min = pixel_min_data
              ;                    pixel_data = (*global).calibration_range_moving_pixel_start
              ;                  ENDIF
              ;
              ;                  putTextFieldValue, Event, $
              ;                    'beam_center_calculation_pixel_left', $
              ;                    STRCOMPRESS(new_pixel_min,/REMOVE_ALL)
              ;                  putTextFieldValue, Event, $
              ;                    'beam_center_calculation_pixel_right', $
              ;                    STRCOMPRESS(new_pixel_max,/REMOVE_ALL)
              ;
              ;                  (*global).calibration_range_moving_pixel_start = pixel_data
              ;
              ;
              ;                ENDIF
              ;                replot_beam_center_calibration_range, Event
              ;                replot_beam_center_beam_stop, Event
              ;              ;                replot_calculation_range_cursor, Event
              ;              END
              0: BEGIN ;beam stop region
                plot_beam_center_background, Event
                IF (validate_or_not_beam_stop_range_moving(Event)) THEN BEGIN
                
                  X = Event.x
                  Y = Event.y
                  tube_data  = getBeamCenterTubeData_from_device(X, global)
                  pixel_data = getBeamCenterPixelData_from_device(Y, global)
                  offset_tube = tube_data - $
                    (*global).beam_stop_range_moving_tube_start
                  offset_pixel = pixel_data - $
                    (*global).beam_stop_range_moving_pixel_start
                    
                  tube_min_data = FIX(getTextFieldValue(Event,$
                    'beam_center_beam_stop_tube_left'))
                  tube_max_data = FIX(getTextFieldValue(Event,$
                    'beam_center_beam_stop_tube_right'))
                  pixel_min_data = FIX(getTextFieldValue(Event,$
                    'beam_center_beam_stop_pixel_left'))
                  pixel_max_data = FIX(getTextFieldValue(Event,$
                    'beam_center_beam_stop_pixel_right'))
                    
                  tube_min = MIN([tube_min_data,tube_max_data],MAX=tube_max)
                  pixel_min = MIN([pixel_min_data,pixel_max_data],MAX=pixel_max)
                  
                  new_tube_min = tube_min_data + offset_tube
                  new_tube_max = tube_max_data + offset_tube
                  
                  IF (new_tube_min LT (*global).min_tube_plotted) THEN BEGIN
                    new_tube_min = (*global).min_tube_plotted
                    new_tube_max = tube_max_data
                    tube_data = (*global).beam_stop_range_moving_tube_start
                  ENDIF
                  IF (new_tube_max GT (*global).max_tube_plotted) THEN BEGIN
                    new_tube_max = (*global).max_tube_plotted
                    new_tube_min = tube_min_data
                    tube_data = (*global).beam_stop_range_moving_tube_start
                  ENDIF
                  
                  putTextFieldValue, Event, $
                    'beam_center_beam_stop_tube_left', $
                    STRCOMPRESS(new_tube_min,/REMOVE_ALL)
                  putTextFieldValue, Event, $
                    'beam_center_beam_stop_tube_right', $
                    STRCOMPRESS(new_tube_max,/REMOVE_ALL)
                    
                  (*global).beam_stop_range_moving_tube_start = tube_data
                  
                  new_pixel_min = pixel_min_data + offset_pixel
                  new_pixel_max = pixel_max_data + offset_pixel
                  
                  IF (new_pixel_min LT (*global).min_pixel_plotted) THEN BEGIN
                    new_pixel_min = (*global).min_pixel_plotted
                    new_pixel_max = pixel_max_data
                    pixel_data = (*global).beam_stop_range_moving_pixel_start
                  ENDIF
                  IF (new_pixel_max GT (*global).max_pixel_plotted) THEN BEGIN
                    new_pixel_max = (*global).max_pixel_plotted
                    new_pixel_min = pixel_min_data
                    pixel_data = (*global).beam_stop_range_moving_pixel_start
                  ENDIF
                  
                  putTextFieldValue, Event, $
                    'beam_center_beam_stop_pixel_left', $
                    STRCOMPRESS(new_pixel_min,/REMOVE_ALL)
                  putTextFieldValue, Event, $
                    'beam_center_beam_stop_pixel_right', $
                    STRCOMPRESS(new_pixel_max,/REMOVE_ALL)
                    
                  (*global).beam_stop_range_moving_pixel_start = pixel_data
                  
                  
                ENDIF
                replot_beam_center_beam_stop, Event
                plot_calculation_range_selection, Event, MODE_DISABLE=1
              END
              1: BEGIN ;Calculation Range
                plot_beam_center_background, Event
                replot_beam_center_beam_stop, Event
                record_calculation_range_value, Event
                plot_calculation_range_selection, Event
                switch_calculation_range_button, Event, WAY='forward'
                replot_calculation_range_cursor, Event
              END
            ENDCASE
          ENDELSE
          
        ENDIF
        
        IF (event.release EQ 1 AND $ ;releasing left button
          (*global).left_button_pressed EQ 1) THEN BEGIN
          (*global).left_button_pressed = 0
          
          ;    curr_tab_selected = getCurrentTabSelect(Event,'beam_center_tab')
          CASE (curr_tab_selected) OF
            ;            2: BEGIN ;Data Range Displayed
            ;
            ;              tube_min = getTextFieldValue(Event,$
            ;                'beam_center_calculation_tube_left')
            ;              tube_max = getTextFieldValue(Event,$
            ;                'beam_center_calculation_tube_right')
            ;              pixel_min = getTextFieldValue(Event,$
            ;                'beam_center_calculation_pixel_left')
            ;              pixel_max = getTextFieldValue(Event,$
            ;                'beam_center_calculation_pixel_right')
            ;
            ;              Tmin = MIN([tube_min,tube_max],MAX=tmax)
            ;              Pmin = MIN([pixel_min,pixel_max],MAX=pmax)
            ;
            ;              sTmin = STRCOMPRESS(Tmin,/REMOVE_ALL)
            ;              sTmax = STRCOMPRESS(Tmax,/REMOVE_ALL)
            ;              sPmin = STRCOMPRESS(Pmin,/REMOVE_ALL)
            ;              sPmax = STRCOMPRESS(Pmax,/REMOVE_ALL)
            ;
            ;              (*global).calculation_tubeLR_pixelLR_backup = $
            ;                [sTmin, sTmax, sPmin, sPmax]
            ;
            ;            END
            0: BEGIN ;Beam Stop Region
            
              tube_min = getTextFieldValue(Event,$
                'beam_center_beam_stop_tube_left')
              tube_max = getTextFieldValue(Event,$
                'beam_center_beam_stop_tube_right')
              pixel_min = getTextFieldValue(Event,$
                'beam_center_beam_stop_pixel_left')
              pixel_max = getTextFieldValue(Event,$
                'beam_center_beam_stop_pixel_right')
                
              Tmin = MIN([tube_min,tube_max],MAX=tmax)
              Pmin = MIN([pixel_min,pixel_max],MAX=pmax)
              
              sTmin = STRCOMPRESS(Tmin,/REMOVE_ALL)
              sTmax = STRCOMPRESS(Tmax,/REMOVE_ALL)
              sPmin = STRCOMPRESS(Pmin,/REMOVE_ALL)
              sPmax = STRCOMPRESS(Pmax,/REMOVE_ALL)
              
              (*global).beam_stop_tubeLR_pixelLR_backup = $
                [sTmin, sTmax, sPmin, sPmax]
                
            END
            1: BEGIN ;Calculation Range
            
              switch_calculation_range_button, Event, WAY='forward'
              
              tube_data = getTextFieldValue(event,'beam_center_2d_plot_tube')
              pixel_data = getTextFieldValue(Event,'beam_center_2d_plot_pixel')
              
              sT = STRCOMPRESS(tube_data,/REMOVE_ALL)
              sP = STRCOMPRESS(pixel_data,/REMOVE_ALL)
              (*global).twoD_plots_tubeLR_pixelLR_backup = [sT, sP]
              
            END
            
          ENDCASE
          
        ENDIF
        
        IF (event.press EQ 4) THEN BEGIN ;right click
          switch_cursor_shape, Event
          CASE (curr_tab_selected) OF
            1: BEGIN ;Calculation Range
              switch_calculation_range_button, Event, WAY='backward'
            END
            ELSE:
          ENDCASE
        ENDIF
        
      ENDIF ELSE BEGIN ;endif of catch statement
        id = WIDGET_INFO(Event.top,$
          find_by_uname='beam_center_main_draw')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        WSET, id_value
        
        IF (event.enter EQ 1) THEN BEGIN
          ;check activated button
          ;       curr_tab_selected = getCurrentTabSelect(Event,'beam_center_tab')
          CASE (curr_tab_selected) OF
            ;            2: standard = (*global).current_cursor_status
            0: standard = (*global).current_cursor_status
            1: standard = (*global).cursor_selection
          ENDCASE
          DEVICE, CURSOR_STANDARD=standard
        ENDIF ELSE BEGIN ;leave main plot
          putTextFieldValue, Event, 'beam_center_2d_plot_tube', 'N/A'
          putTextFieldValue, Event, 'beam_center_2d_plot_pixel', 'N/A'
          display_counts_vs_pixel_and_tube_live, Event, ERASE=1
          standard = (*global).cursor_selection
          plot_beam_center_background, Event
          plot_calculation_range_selection, Event, MODE_DISABLE=1
          replot_beam_center_beam_stop, Event
        ENDELSE
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE ;enf of catch statement
      
    END
    
    ;button1 (beam stop region) -------------------------------------------
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
    
    ;tube left, right, pixel left and right of calibration base
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='beam_center_calculation_tube_left'): BEGIN
      calculation_range_manual_input, Event
    END
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='beam_center_calculation_tube_right'): BEGIN
      calculation_range_manual_input, Event
    END
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='beam_center_calculation_pixel_left'): BEGIN
      calculation_range_manual_input, Event
    END
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='beam_center_calculation_pixel_right'): BEGIN
      calculation_range_manual_input, Event
    END
    
    ;button2 (calculation region) ----------------------------------------------
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
    
    ;tube edge1, 2 and pixel edge1 and 2
    WIDGET_INFO(Event.top, FIND_BY_UNAME='tube1_button_uname'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_beam_center_tab2_buttons, Event, MODE='tube1'
        ENDIF
      ENDIF ELSE BEGIN ;endif of catch statement
        id = WIDGET_INFO(Event.top,$
          find_by_uname='tube1_button_uname')
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
    
    WIDGET_INFO(Event.top, FIND_BY_UNAME='tube2_button_uname'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_beam_center_tab2_buttons, Event, MODE='tube2'
        ENDIF
      ENDIF ELSE BEGIN ;endif of catch statement
        id = WIDGET_INFO(Event.top,$
          find_by_uname='tube2_button_uname')
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
    
    WIDGET_INFO(Event.top, FIND_BY_UNAME='pixel1_button_uname'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_beam_center_tab2_buttons, Event, MODE='pixel1'
        ENDIF
      ENDIF ELSE BEGIN ;endif of catch statement
        id = WIDGET_INFO(Event.top,$
          find_by_uname='pixel1_button_uname')
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
    
    WIDGET_INFO(Event.top, FIND_BY_UNAME='pixel2_button_uname'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_beam_center_tab2_buttons, Event, MODE='pixel2'
        ENDIF
      ENDIF ELSE BEGIN ;endif of catch statement
        id = WIDGET_INFO(Event.top,$
          find_by_uname='pixel2_button_uname')
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
    
    ;button3 (data range displayed) ------------------------------------------
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
    
    ;tube and pixel input
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='beam_center_2d_plot_tube'): BEGIN
      twoD_plot_range_manual_input, Event
    END
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='beam_center_2d_plot_pixel'): BEGIN
      twoD_plot_range_manual_input, Event
    END
    
    ;--------------------------------------------------------------------------
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
        IF (curr_tab_selected EQ 1) THEN BEGIN
          display_beam_center_tab2_buttons, Event
        ENDIF
      ENDIF
    END
    
    ;CANCEL button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='beam_stop_cancel_button'): BEGIN
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='beam_center_calculation_base')
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
    left_button_pressed: 0,$
    
    moving_pixel_range: 5,$ ;user has to click within that range to move it
    moving_tube_range: 2, $
    
    calibration_range_moving_tube_start: 0,$
    calibration_range_moving_pixel_start: 0,$
    calculation_tubeLR_pixelLR_backup: STRARR(4), $
    
    calculation_range_tab_mode: 'tube1', $
    
    beam_stop_range_moving_tube_start: 0,$
    beam_stop_range_moving_pixel_start: 0,$
    beam_stop_tubeLR_pixelLR_backup: STRARR(4), $
    
    twoD_plots_tubeLR_pixelLR_backup: STRARR(4), $
    
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
    color_selected: [255,0,255],$
    thick: 1,$
    working_linestyle: 0,$
    not_working_linestyle: 2,$
    thick_selected: 1}, $
    
    beam_stop_default_selection: {tube_min: 90, $
    tube_max: 101, $
    pixel_min: 121, $
    pixel_max: 134, $
    color: [0,255,0], $ ;blue but I want GREEN
    thick: 2}, $
    
    calculation_range_default: {tube: 110, $
    pixel: 130, $
    color: [255,255,255],$
    working_linestyle: 0, $
    not_working_linestyle: 1,$
    thick: 2}, $
    
    tt_zoom_data: PTR_NEW(0L), $ [tube,pixel]
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
  
  ;save background
  save_beam_center_background,  Event=event, BASE=wBase1
  
  plot_default_beam_center_selections, base=wBase1, global=global_bc
  plot_beam_center_scale, wBase1, global_bc
  
  XMANAGER, "launch_beam_center_base", wBase1, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END


