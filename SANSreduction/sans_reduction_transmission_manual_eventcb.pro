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

PRO launch_transmission_manual_mode_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  CASE Event.id OF
  
    ;STEP1 - STEP1 - STEP1 - STEP1 - STEP1 - STEP1 - STEP1 - STEP1 - STEP1 -
  
    ;main_plot
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='manual_transmission_step1_draw'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        
        tube  = getTransManualStep1Tube(Event.x)
        pixel = getTransManualStep1Pixel(Event.y)
        counts = getTransManualStep1Counts(Event, tube, pixel)
        putTextFieldValue, Event, 'trans_manual_step1_cursor_tube', $
          STRCOMPRESS(tube,/REMOVE_ALL)
        putTextFieldValue, Event, 'trans_manual_step1_cursor_pixel', $
          STRCOMPRESS(pixel,/REMOVE_ALL)
        putTextFieldValue, Event, 'trans_manual_step1_cursor_counts', $
          STRCOMPRESS(counts,/REMOVE_ALL)
          
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          plot_trans_manual_step1_background, Event
          (*global).left_button_clicked = 1
          IF ((*global).working_with_xy EQ 0) THEN BEGIN ;working with x0y0
            plot_selection, Event, mode='x0y0'
          ENDIF ElSE BEGIN ;working with x1y1
            plot_selection, Event, mode='x1y1'
          ENDELSE
        ENDIF
        
        IF (event.press EQ 0 AND $ ;moving mouse with button clicked
          (*global).left_button_clicked EQ 1) THEN BEGIN
          plot_trans_manual_step1_background, Event
          IF ((*global).working_with_xy EQ 0) THEN BEGIN ;working with x0y0
            plot_selection, Event, mode='x0y0'
          ENDIF ElSE BEGIN ;working with x1y1
            plot_selection, Event, mode='x1y1'
          ENDELSE
        ENDIF
        
        IF (event.release EQ 1) THEN BEGIN ;left button release
          (*global).left_button_clicked = 0
          (*global).need_to_reset_trans_step2 = 1
        ENDIF
        
        IF (event.press EQ 4) THEN BEGIN ;right click
          plot_trans_manual_step1_background, Event
          IF ((*global).working_with_xy EQ 0) THEN BEGIN
            (*global).working_with_xy = 1
            refresh_plot_selection_trans_manual_step1, Event
          ENDIF ELSE BEGIN
            (*global).working_with_xy = 0
            refresh_plot_selection_trans_manual_step1, Event
          ENDELSE
        ENDIF
        
      ENDIF ELSE BEGIN ;endif of catch statement
        IF (event.enter EQ 1) THEN BEGIN
          id = WIDGET_INFO(Event.top,$
            find_by_uname='manual_transmission_step1_draw')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 31
          DEVICE, CURSOR_STANDARD=standard
        ENDIF ELSE BEGIN
          putTextFieldValue, Event, 'trans_manual_step1_cursor_tube', $
            'N/A'
          putTextFieldValue, Event, 'trans_manual_step1_cursor_pixel', $
            'N/A'
          putTextFieldValue, Event, 'trans_manual_step1_cursor_counts', $
            'N/A'
        ENDELSE
      ENDELSE ;enf of catch statement
    END
    
    ;linear plot
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='transmission_manual_step1_linear'): BEGIN
      refresh_transmission_manual_step1_main_plot, Event
      refresh_plot_selection_trans_manual_step1, Event
    END
    
    ;log plot
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='transmission_manual_step1_log'): BEGIN
      refresh_transmission_manual_step1_main_plot, Event
      refresh_plot_selection_trans_manual_step1, Event
    END
    
    ;move on to step2 button
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='move_to_trans_manual_step2'): BEGIN
      map_base, Event, 'manual_transmission_step1', 0
      ;change title
      title = 'Transmission Calculation -> STEP 2/3: Calculate Background'
      title += ' and Transmission Intensity'
      ChangeTitle, Event, uname='transmission_manual_mode_base', title
      
      display_trans_manual_step2_3Dview_button, Event, $
        MODE= (*global).trans_manual_3dview_status
        
      ;;;make this perform only if the selection of step1 has changed
      IF ((*global).need_to_reset_trans_step2 EQ 1) THEN BEGIN
      
        refresh_trans_manual_step2_plots_counts_vs_x_and_y, Event
        
        save_transmission_manual_step2_top_plot_background,  EVENT=Event, $
          working_with_tube='neither'
        save_transmission_manual_step2_bottom_plot_background,  EVENT=Event, $
          working_with_pixel='neither'
        ;;same thing for this
        x_min_data = (*global).trans_manual_step2_top_plot_xmin_data
        putTextFieldValue, Event, 'trans_manual_step2_tube_min', $
          STRCOMPRESS(x_min_data,/REMOVE_ALL)
        x_max_data = (*global).trans_manual_step2_top_plot_xmax_data
        putTextFieldValue, Event, 'trans_manual_step2_tube_max', $
          STRCOMPRESS(x_max_data,/REMOVE_ALL)
          
        x_min_data = (*global).trans_manual_step2_bottom_plot_xmin_data
        putTextFieldValue, Event, 'trans_manual_step2_pixel_min', $
          STRCOMPRESS(x_min_data,/REMOVE_ALL)
        x_max_data = (*global).trans_manual_step2_bottom_plot_xmax_data
        putTextFieldValue, Event, 'trans_manual_step2_pixel_max', $
          STRCOMPRESS(x_max_data,/REMOVE_ALL)
        (*global).need_to_reset_trans_step2 = 0
        
      ENDIF ELSE BEGIN
      
        plot_counts_vs_tube_step2_tube_selection_manual_input, Event
        plot_counts_vs_pixel_step2_pixel_selection_manual_input, Event
        
      ENDELSE
      
    END
    
    ;STEP2 - STEP2 - STEP2 - STEP2 - STEP2 - STEP2 - STEP2 - STEP2 - STEP2 -
    
    ;Counts vs tube integratd over pixel plot
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME = 'trans_manual_step2_counts_vs_x'): BEGIN
      
      IF (event.press EQ 1) THEN BEGIN ;pressed button
        (*global).left_button_clicked = 1
        (*global).trans_manual_3dview_status = 'disable'
        display_trans_manual_step2_3Dview_button, Event, $
          MODE= (*global).trans_manual_3dview_status
          
        IF ((*global).working_with_tube EQ 1) THEN BEGIN ;working with tube 1
          plot_counts_vs_tube_step2_tube_selection, Event, tube=1
        ENDIF ElSE BEGIN ;working with tube 2
          plot_counts_vs_tube_step2_tube_selection, Event, tube=2
        ENDELSE
      ENDIF
      
      IF (event.release EQ 1) THEN BEGIN ;left button release
        (*global).left_button_clicked = 0
      ENDIF
      
      IF (event.press EQ 0 AND $ ;moving mouse with button clicked
        (*global).left_button_clicked EQ 1) THEN BEGIN
        IF ((*global).working_with_tube EQ 1) THEN BEGIN ;working with tube 1
          plot_counts_vs_tube_step2_tube_selection, Event, tube=1
        ENDIF ElSE BEGIN ;working with tube 2
          plot_counts_vs_tube_step2_tube_selection, Event, tube=2
        ENDELSE
      ENDIF
      
      IF (event.press EQ 4) THEN BEGIN ;right click
        IF ((*global).working_with_tube EQ 1) THEN BEGIN
          (*global).working_with_tube = 2
          save_transmission_manual_step2_top_plot_background,  EVENT=Event, $
            working_with_tube = 'right'
        ENDIF ELSE BEGIN
          (*global).working_with_tube = 1
          save_transmission_manual_step2_top_plot_background,  EVENT=Event, $
            working_with_tube = 'left'
        ENDELSE
      ENDIF
      
    END
    
    ;Counts vs pixel integrated over tube plot
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_counts_vs_y'): BEGIN
      
      IF (event.press EQ 1) THEN BEGIN ;pressed button
        (*global).trans_manual_3dview_status = 'disable'
        display_trans_manual_step2_3Dview_button, Event, $
          MODE= (*global).trans_manual_3dview_status
          
        (*global).left_button_clicked = 1
        IF ((*global).working_with_pixel EQ 1) THEN BEGIN ;working with pixel 1
          plot_counts_vs_pixel_step2_pixel_selection, Event, pixel=1
        ENDIF ElSE BEGIN ;working with tube 2
          plot_counts_vs_pixel_step2_pixel_selection, Event, pixel=2
        ENDELSE
      ENDIF
      
      IF (event.release EQ 1) THEN BEGIN ;left button release
        (*global).left_button_clicked = 0
      ENDIF
      
      IF (event.press EQ 0 AND $ ;moving mouse with button clicked
        (*global).left_button_clicked EQ 1) THEN BEGIN
        IF ((*global).working_with_pixel EQ 1) THEN BEGIN ;working with pixel 1
          plot_counts_vs_pixel_step2_pixel_selection, Event, pixel=1
        ENDIF ElSE BEGIN ;working with pixel 2
          plot_counts_vs_pixel_step2_pixel_selection, Event, pixel=2
        ENDELSE
      ENDIF
      
      IF (event.press EQ 4) THEN BEGIN ;right click
        IF ((*global).working_with_pixel EQ 1) THEN BEGIN
          (*global).working_with_pixel = 2
          save_transmission_manual_step2_bottom_plot_background,  $
            EVENT=Event, working_with_pixel = 'right'
        ENDIF ELSE BEGIN
          (*global).working_with_pixel = 1
          save_transmission_manual_step2_bottom_plot_background,  $
            EVENT=Event, working_with_pixel = 'left'
        ENDELSE
      ENDIF
      
    END
    
    ;----------------------------------
    ;Range of tubes
    ;Tube min
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_tube_min'): BEGIN
      (*global).trans_manual_3dview_status = 'disable'
      display_trans_manual_step2_3Dview_button, Event, $
        MODE= (*global).trans_manual_3dview_status
      plot_counts_vs_tube_step2_tube_selection_manual_input, Event
    END
    
    ;Tube max
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_tube_max'): BEGIN
      (*global).trans_manual_3dview_status = 'disable'
      display_trans_manual_step2_3Dview_button, Event, $
        MODE= (*global).trans_manual_3dview_status
      plot_counts_vs_tube_step2_tube_selection_manual_input, Event
    END
    
    ;Range of pixels
    ;Pixel min
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME = 'trans_manual_step2_pixel_min'): BEGIN
      (*global).trans_manual_3dview_status = 'disable'
      display_trans_manual_step2_3Dview_button, Event, $
        MODE= (*global).trans_manual_3dview_status
      plot_counts_vs_pixel_step2_pixel_selection_manual_input, Event
    END
    
    ;Pixel max
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME = 'trans_manual_step2_pixel_max'): BEGIN
      (*global).trans_manual_3dview_status = 'disable'
      display_trans_manual_step2_3Dview_button, Event, $
        MODE= (*global).trans_manual_3dview_status
      plot_counts_vs_pixel_step2_pixel_selection_manual_input, Event
    END
    
    ;------------------------------
    ;Number of iteration text box
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_nbr_iterations'): BEGIN
      (*global).trans_manual_3dview_status = 'disable'
      display_trans_manual_step2_3Dview_button, Event, $
        MODE= (*global).trans_manual_3dview_status
      trans_manual_step2_calculate_background, Event
    END
    
    ;calculate background --------------
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_calculate'): BEGIN
      trans_manual_step2_calculate_background, Event
      (*global).trans_manual_3dview_status = 'off'
      display_trans_manual_step2_3Dview_button, Event, $
        MODE= (*global).trans_manual_3dview_status
      activate_widget, Event, 'trans_manual_step2_go_to_next_step', 1
    END
    
    ;    ;edit background value
    ;    WIDGET_INFO(Event.top, $
    ;      FIND_BY_UNAME='trans_manual_step2_edit_background'): BEGIN
    ;      map_base, Event, 'trans_manual_step2_edit_background_base', 0
    ;      map_base, Event, 'trans_manual_step2_lock_edit_background_base', 1
    ;      putTextFieldValue, Event, 'trans_manual_step2_background_edit', $
    ;        STRCOMPRESS((*global).trans_manual_step2_background,/REMOVE_ALL)
    ;    END
    ;
    ;    ;background value edit widget_text
    ;    WIDGET_INFO(Event.top, $
    ;      FIND_BY_UNAME = 'trans_manual_step2_background_edit'): BEGIN
    ;      trans_manual_step2_manual_input_of_background, Event
    ;    END
    ;
    ;    ;lock edit background value
    ;    WIDGET_INFO(Event.top, $
    ;      FIND_BY_UNAME='trans_manual_step2_lock_edit_background'): BEGIN
    ;      map_base, Event, 'trans_manual_step2_edit_background_base', 1
    ;      map_base, Event, 'trans_manual_step2_lock_edit_background_base', 0
    ;      putTextFieldValue, Event, 'trans_manual_step2_background_value', $
    ;        STRCOMPRESS((*global).trans_manual_step2_background,/REMOVE_ALL)
    ;    END
    
    ;3d button view
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_3d_view_button'): BEGIN
      
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        
        IF (event.press EQ 1) THEN BEGIN
          display_trans_manual_step2_3Dview_button, Event, MODE='on'
          show_trans_manual_step2_3dview, Event
          display_trans_manual_step2_3Dview_button, Event, MODE='off'
        ENDIF
        
      ENDIF ELSE BEGIN ;endif of catch statement
        id = WIDGET_INFO(Event.top,$
          find_by_uname='trans_manual_step2_3d_view_button')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        WSET, id_value
        IF (event.enter EQ 1) THEN BEGIN
          standard = 58
        ENDIF ELSE BEGIN
          standard = 31
        ENDELSE
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE ;enf of catch statement
      
    END
    
    ;Algorithm description button
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_algorithm_description'): BEGIN
      display_trans_step2_algorith_image, Event
    END
    
    ;previous button
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_go_to_previous_step'): BEGIN
      ;change title
      title = 'Transmission Calculation -> STEP 1/3: '
      title += 'Define Beam Stop Region'
      ChangeTitle, Event, uname='transmission_manual_mode_base', title
      MapBase, event, uname='manual_transmission_step1', 1
      plot_trans_manual_step1_background, Event
      refresh_plot_selection_trans_manual_step1, Event
      plot_transmission_step1_scale_from_event, Event
    END
    
    ;move on to step3 button
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_go_to_next_step'): BEGIN
      map_base, Event, 'manual_transmission_step2', 0
      ;change title
      title = 'Transmission Calculation -> STEP 3/3: Determine Beam Center'
      title += ' Pixel'
      ChangeTitle, Event, uname='transmission_manual_mode_base', title
      
      plot_transmission_step3_scale, Event
      plot_transmission_step3_main_plot, Event
      plot_transmission_step3_bottom_plots, Event
      save_transmission_manual_step3_background,  EVENT=event
      
    END
    
    ;STEP3 - STEP3 - STEP3 - STEP3 - STEP3 - STEP3 - STEP3 - STEP3 - STEP3 -
    
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME = 'manual_transmission_step3_draw'): BEGIN
      
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        
        tube  = getTransManualStep3Tube(Event)
        pixel = getTransManualStep3Pixel(Event)
        counts = getTransManualStep3Counts(Event, tube, pixel)
        putTextFieldValue, Event, 'trans_manual_step3_tube_value', $
          STRCOMPRESS(tube,/REMOVE_ALL)
        putTextFieldValue, Event, 'trans_manual_step3_pixel_value', $
          STRCOMPRESS(pixel,/REMOVE_ALL)
        putTextFieldValue, Event, 'trans_manual_step3_counts_value', $
          STRCOMPRESS(counts,/REMOVE_ALL)
          
        plot_trans_manual_step3_background, Event
        
        IF (event.press EQ 1) THEN BEGIN ;pressed button
        
          plot_transmission_step3_main_plot, Event
          plot_pixel_selected_below_cursor, event, tube, pixel
          save_transmission_manual_step3_background,  EVENT=event
          
          putTextFieldValue, Event, $
            'trans_manual_step3_beam_center_tube_value', $
            STRCOMPRESS(tube,/REMOVE_ALL)
          putTextFieldValue, Event, $
            'trans_manual_step3_beam_center_pixel_value', $
            STRCOMPRESS(pixel,/REMOVE_ALL)
          putTextFieldValue, Event, $
            'trans_manual_step3_beam_center_counts_value', $
            STRCOMPRESS(counts,/REMOVE_ALL)
            
        ENDIF ELSE BEGIN
        
          plot_pixel_below_cursor, Event, tube, pixel
          
        ENDELSE
        
        
      ENDIF ELSE BEGIN ;endif of catch statement
      
        IF (event.enter EQ 1) THEN BEGIN
          id = WIDGET_INFO(Event.top,$
            find_by_uname='manual_transmission_step3_draw')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 31
          DEVICE, CURSOR_STANDARD=standard
        ENDIF ELSE BEGIN
          putTextFieldValue, Event, 'trans_manual_step3_tube_value', 'N/A'
          putTextFieldValue, Event, 'trans_manual_step3_pixel_value', 'N/A'
          putTextFieldValue, Event, 'trans_manual_step3_counts_value', 'N/A'
          plot_trans_manual_step3_background, Event
        ENDELSE
      ENDELSE ;enf of catch statement
      
    END
    
    ;linear and logarithmic buttons
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='transmission_manual_step3_linear'): BEGIN
      replot_transmission_step3_main_plot, Event
    END
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='transmission_manual_step3_log'): BEGIN
      replot_transmission_step3_main_plot, Event
    END
    
    ;go back to step2 button
    ;move on to step3 button
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step3_previous_button'): BEGIN
      map_base, Event, 'manual_transmission_step2', 1
      ;change title
      title = 'Transmission Calculation -> STEP 2/3: Calculate Background'
      title += ' and Transmission Intensity'
      ChangeTitle, Event, uname='transmission_manual_mode_base', title
      
      display_trans_manual_step2_3Dview_button, Event, $
        MODE= (*global).trans_manual_3dview_status
        
      plot_counts_vs_tube_step2_tube_selection_manual_input, Event
      plot_counts_vs_pixel_step2_pixel_selection_manual_input, Event
      
    END
    
    ELSE:
  ENDCASE
  
END
