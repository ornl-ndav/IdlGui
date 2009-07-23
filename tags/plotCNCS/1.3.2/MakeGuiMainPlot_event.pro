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

PRO MakeGuiMainPLot_Event, event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  CASE event.id OF
  
    ;selection mode button
    WIDGET_INFO(event.top, FIND_BY_UNAME='selection_mode_button'): BEGIN
      id = WIDGET_INFO(Event.top,find_by_uname='selection_mode_button')
      WIDGET_CONTROL, id, GET_VALUE=id_value
      WSET, id_value
      standard = 58
      DEVICE, CURSOR_STANDARD=standard
      IF (event.press EQ 1) THEN BEGIN
        update_selection_masking_mode, Event, mode='selection'
        replot_main_plot_with_scale, Event, without_scale=1
        plot_selection_box, Event
        saving_background, Event
      ENDIF
    END
    
    ;Masking mode button
    WIDGET_INFO(event.top, FIND_BY_UNAME='masking_mode_button'): BEGIN
      id = WIDGET_INFO(Event.top,find_by_uname='masking_mode_button')
      WIDGET_CONTROL, id, GET_VALUE=id_value
      WSET, id_value
      standard = 58
      DEVICE, CURSOR_STANDARD=standard
      IF (event.press EQ 1) THEN BEGIN
        update_selection_masking_mode, Event, mode='masking'
        replot_main_plot_with_scale, Event, without_scale=1
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
        ;save background in case manual selection is next
        saving_background, Event
      ENDIF
    END
    
    ;Counts min value
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_base_min_value'): BEGIN
      replot_main_plot_with_scale, Event
      IF (isSelectionModeSelected(Event)) THEN BEGIN
        plot_selection_box, Event
      ENDIF ELSE BEGIN
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
      ENDELSE
      saving_background, Event
    END
    
    ;Counts max value
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_base_max_value'): BEGIN
      replot_main_plot_with_scale, Event
      IF (isSelectionModeSelected(Event)) THEN BEGIN
        plot_selection_box, Event
      ENDIF ELSE BEGIN
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
      ENDELSE
      saving_background, Event
    END
    
    ;reset scale
    WIDGET_INFO(event.top, FIND_BY_UNAME='reset_scale'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      plot_main_plot_with_new_bin_range, Event, reset_z_scale=1
      IF (isSelectionModeSelected(Event)) THEN BEGIN
        plot_selection_box, Event
      ENDIF ELSE BEGIN
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
      ENDELSE
      saving_background, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;with or without grid
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_plot_with_grid_plot'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      plot_main_plot_with_new_bin_range, Event
      IF (isSelectionModeSelected(Event)) THEN BEGIN
        plot_selection_box, Event
      ENDIF ELSE BEGIN
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
      ENDELSE
      saving_background, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;with or without grid
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_plot_without_grid_plot'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      plot_main_plot_with_new_bin_range, Event
      IF (isSelectionModeSelected(Event)) THEN BEGIN
        plot_selection_box, Event
      ENDIF ELSE BEGIN
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
      ENDELSE
      saving_background, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;linear plot
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_plot_linear_plot'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      plot_main_plot_with_new_bin_range, Event
      IF (isSelectionModeSelected(Event)) THEN BEGIN
        plot_selection_box, Event
      ENDIF ELSE BEGIN
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
      ENDELSE
      saving_background, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;log plot
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_plot_log_plot'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      plot_main_plot_with_new_bin_range, Event
      IF (isSelectionModeSelected(Event)) THEN BEGIN
        plot_selection_box, Event
      ENDIF ELSE BEGIN
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
      ENDELSE
      saving_background, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;counts vs tof of full detector
    WIDGET_INFO(event.top, FIND_BY_UNAME='counts_vs_tof_full_detector'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      job_base = counts_vs_tof_info_base(Event)
      plot_counts_vs_tof_of_full_detector, Event
      WIDGET_CONTROL, HOURGLASS=0
      WIDGET_CONTROL, job_base,/DESTROY
    END
    
    ;counts vs tof of selection
    WIDGET_INFO(event.top, FIND_BY_UNAME='counts_vs_tof_selection'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      job_base = counts_vs_tof_info_base(Event)
      plot_counts_vs_tof_of_selection, Event
      WIDGET_CONTROL, HOURGLASS=0
      WIDGET_CONTROL, job_base,/DESTROY
    END
    
    ;Main plot
    WIDGET_INFO(event.top, FIND_BY_UNAME='main_plot'): begin
      MainPlotInteraction, Event
      
      id = WIDGET_INFO(Event.top,find_by_uname='main_plot')
      WIDGET_CONTROL, id, GET_VALUE=id_value
      WSET, id_value
      standard = 31
      DEVICE, CURSOR_STANDARD=standard
      
      IF (isSelectionModeSelected(Event)) THEN BEGIN ;selection mode -------
      
        IF (Event.press EQ 1) THEN BEGIN ;press left button
          (*global1).left_pressed = 1
          (*global1).X1 = Event.x
          (*global1).Y1 = Event.y
        ENDIF
        
        IF (Event.type EQ 1 AND $
          (*global1).left_pressed EQ 1) THEN BEGIN ;release of left button only
          (*global1).left_pressed = 0
          activateWidget, Event, 'counts_vs_tof_selection', 1
        ENDIF
        
        IF (Event.type EQ 2 AND $
          (*global1).left_pressed EQ 1) THEN BEGIN ;move
          (*global1).X2 = Event.x
          (*global1).Y2 = Event.y
          TV, (*(*global1).background_main_plot), true=3
          plot_selection_box, Event
        ENDIF
        
        IF (Event.press EQ 4) THEN BEGIN ;right mouse pressed
          WIDGET_CONTROL,/HOURGLASS
          X = Event.X
          Y = Event.Y
          index = getBankIndex(Event, X, Y)
          IF (index NE -1) THEN BEGIN
            bankName = getBank(Event)
            PlotBank, (*(*global1).img), $ ;launch the bank view
              index, $
              bankName, $
              (*global1).real_or_tof,$
              (*global1).TubeAngle
          ENDIF
          WIDGET_CONTROL, HOURGLASS=0
        ENDIF
        
      ENDIF ELSE BEGIN ;masking mode selected --------------------
      
        IF (Event.press EQ 1) THEN BEGIN ;press left button
          (*global1).left_pressed = 1
          (*global1).X1_masking = Event.x
          (*global1).Y1_masking = Event.y
        ENDIF
        
        IF (Event.type EQ 2 AND $
          (*global1).left_pressed EQ 1) THEN BEGIN ;move with left pressed
          (*global1).X2_masking = Event.x
          (*global1).Y2_masking = Event.y
          TV, (*(*global1).background_main_plot), true=3
          plot_masking_box, Event
        ENDIF
        
        IF (Event.type EQ 1 AND $
          (*global1).left_pressed EQ 1) THEN BEGIN ;release of left button only
          (*global1).left_pressed = 0
          WIDGET_CONTROL, /HOURGLASS
          create_masking_region_from_manual_selection, Event
          refresh_masking_region, Event
          WIDGET_CONTROL, HOURGLASS=0
        ENDIF
        
      ENDELSE
      
    END
    
    ;Refresh button -----------------------------------------------------------
    WIDGET_INFO(event.top, FIND_BY_UNAME='refresh_plot'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      replot_main_plot_with_scale, Event
      IF (isSelectionModeSelected(Event)) THEN BEGIN
        plot_selection_box, Event
      ENDIF ELSE BEGIN
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
      ENDELSE
      saving_background, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;play button
    WIDGET_INFO(event.top, FIND_BY_UNAME='play_button'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          play_buttons_activation, event, activate_button='play'
          check_from_to_bin_input, Event
          change_from_and_to_bins, Event
          play_tof, Event
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          id = WIDGET_INFO(Event.top,find_by_uname='play_button')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF
      ENDELSE
    END
    
    ;next button
    WIDGET_INFO(event.top, FIND_BY_UNAME='next_button'): BEGIN
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          play_buttons_activation, event, activate_button='next'
          play_next, Event
          play_buttons_activation, event, activate_button='all
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          id = WIDGET_INFO(Event.top,find_by_uname='next_button')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF
      ENDELSE
    END
    
    ;stop button
    WIDGET_INFO(event.top, FIND_BY_UNAME='stop_button'): BEGIN
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          play_buttons_activation, event, activate_button='stop'
          stop_play, Event
          play_buttons_activation, event, activate_button='raw'
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          id = WIDGET_INFO(Event.top,find_by_uname='stop_button')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF
      ENDELSE
    END
    
    ;pause button
    WIDGET_INFO(event.top, FIND_BY_UNAME='pause_button'): BEGIN
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          play_buttons_activation, event, activate_button='pause'
        ENDIF
      ENDIF ELSE BEGIN
        id = WIDGET_INFO(Event.top,find_by_uname='pause_button')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        WSET, id_value
        standard = 58
        DEVICE, CURSOR_STANDARD=standard
      ENDELSE
    END
    
    ;previous button
    WIDGET_INFO(event.top, FIND_BY_UNAME='previous_button'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN
          play_buttons_activation, event, activate_button='previous'
          play_previous, Event
          play_buttons_activation, event, activate_button='all
        ENDIF
      ENDIF ELSE BEGIN
        IF (Event.ENTER EQ 1) THEN BEGIN ;enter
          id = WIDGET_INFO(Event.top,find_by_uname='previous_button')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF
      ENDELSE
    END
    
    ;play/pause.... buttons
    WIDGET_INFO(event.top, FIND_BY_UNAME='play_buttons'): BEGIN
    END
    
    ;View full TOF axis
    WIDGET_INFO(event.top, FIND_BY_UNAME='tof_preview'): BEGIN
      preview_of_tof, Event
    END
    
    ;counts vs tof preview
    WIDGET_INFO(event.top,FIND_BY_UNAME='play_counts_vs_tof_plot'): BEGIN
      id = WIDGET_INFO(Event.top,find_by_uname='play_counts_vs_tof_plot')
      WIDGET_CONTROL, id, GET_VALUE=id_value
      WSET, id_value
      standard = 31
      DEVICE, CURSOR_STANDARD=standard
    END
    
    ;from_bin
    WIDGET_INFO(event.top, FIND_BY_UNAME='from_bin'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      check_from_to_bin_input, Event
      change_from_and_to_bins, Event
      IF (isSelectionModeSelected(Event)) THEN BEGIN
        plot_selection_box, Event
      ENDIF ELSE BEGIN
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
      ENDELSE
      saving_background, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;reset from_bin
    WIDGET_INFO(event.top, FIND_BY_UNAME='reset_from_bin'): BEGIN
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='from_bin')
      WIDGET_CONTROL, /HOURGLASS
      WIDGET_CONTROL, id, SET_VALUE = STRCOMPRESS(1)
      change_from_and_to_bins, Event
      IF (isSelectionModeSelected(Event)) THEN BEGIN
        plot_selection_box, Event
      ENDIF ELSE BEGIN
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
      ENDELSE
      saving_background, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;to_bin
    WIDGET_INFO(event.top, FIND_BY_UNAME='to_bin'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      check_from_to_bin_input, Event
      change_from_and_to_bins, Event
      IF (isSelectionModeSelected(Event)) THEN BEGIN
        plot_selection_box, Event
      ENDIF ELSE BEGIN
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
      ENDELSE
      saving_background, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;reset to_bin
    WIDGET_INFO(event.top, FIND_BY_UNAME='reset_to_bin'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      IF ((*global1).nexus_file_name NE '') THEN BEGIN
        bin_max = N_ELEMENTS((*(*global1).tof_array))
      ENDIF ELSE BEGIN
        img = (*(*global1).img)
        bin_max = (SIZE(img))(1)
      ENDELSE
      id = WIDGET_INFO(Event.top,FIND_BY_UNAME='to_bin')
      WIDGET_CONTROL, id, SET_VALUE = STRCOMPRESS(bin_max-1,/REMOVE_ALL)
      change_from_and_to_bins, Event
      IF (isSelectionModeSelected(Event)) THEN BEGIN
        plot_selection_box, Event
      ENDIF ELSE BEGIN
        excluded_pixel_array = (*(*global1).excluded_pixel_array)
        display_excluded_pixels, Event, excluded_pixel_array
      ENDELSE
      saving_background, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;Masking widgets ==========================================================
    
    ;Reset Selection button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='reset_selection_button'): BEGIN
      excluded_pixel_array = INTARR(128L * 400L)
      (*(*global1).excluded_pixel_array) = excluded_pixel_array
      replot_main_plot_with_scale, Event, without_scale=1
      display_excluded_pixels, Event, excluded_pixel_array
      ;save background in case manual selection is next
      saving_background, Event
    END
    
    ;load mask_button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='load_roi_button'): BEGIN
      load_mask_base, Event
    END
    
    ;edit mask button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='edit_roi_button'): BEGIN
      edit_mask_base, Event
    END
    
    ;save mask button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='save_roi_button'): BEGIN
      save_mask_base, Event
    END
    
    ;pixelID cw_field
    WIDGET_INFO(Event.top, FIND_BY_UNAME='selection_pixelid'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      refresh_masking_region, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;Bank cw_field
    WIDGET_INFO(Event.top, FIND_BY_UNAME='selection_bank'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      refresh_masking_region, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;tube cw_field
    WIDGET_INFO(Event.top, FIND_BY_UNAME='selection_tube'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      refresh_masking_region, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ;row cw_field
    WIDGET_INFO(Event.top, FIND_BY_UNAME='selection_row'): BEGIN
      WIDGET_CONTROL, /HOURGLASS
      refresh_masking_region, Event
      WIDGET_CONTROL, HOURGLASS=0
    END
    
    ELSE:
  ENDCASE
  
END

