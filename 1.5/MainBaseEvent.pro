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

PRO MAIN_BASE_event, Event

  ;get global structure
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL, id, GET_UVALUE=global
  
  wWidget = Event.top            ;widget id
  
  IF ((*global).data_nexus_file_name NE '') THEN BEGIN
    bAdvancedToolId = WIDGET_INFO((*global).advancedToolId, /VALID_ID)
    IF (bAdvancedToolId) THEN BEGIN
      status = 0
    ENDIF ELSE BEGIN
      status = 1
    ENDELSE
    uname_list = ['clear_selection_button',$
      'exclusion_base',$
      'clear_selection_button']
    activate_widget_list, Event, uname_list, status
  ENDIF
  
  CASE Event.id OF
  
    ;counts vs tof plot
    WIDGET_INFO(wWidget, FIND_BY_UNAME='counts_vs_tof_preview_plot'): BEGIN
    END
  
    ;facility Selection
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='facility_selection_validate_button'): begin
      facility_selected, Event, (*global).scroll
    end
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='config_base_no'): BEGIN
      MapBase, Event, uname='config_base', 0
      activate_widget, Event, 'main_tab', 1
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='main_tab'): BEGIN
      tab_event, Event ;_eventcb
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='help_button'): BEGIN
      start_help, Event ;_eventcb
    END
    
    ;= TAB1 (LOAD DATA) =======================================================
    
    ;manual input of x0, y0, width and Height
    WIDGET_INFO(wWidget, FIND_BY_UNAMe='corner_pixel_x0'): BEGIN
      makeExclusionArray_SNS, Event, add=1
      load_exclusion_roi_for_sns, Event, (*(*global).global_exclusion_array)
      save_background,  Event, GLOBAL=global
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAMe='corner_pixel_y0'): BEGIN
      makeExclusionArray_SNS, Event, add=1
      load_exclusion_roi_for_sns, Event, (*(*global).global_exclusion_array)
      save_background,  Event, GLOBAL=global
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAMe='corner_pixel_width'): BEGIN
      makeExclusionArray_SNS, Event, add=1
      load_exclusion_roi_for_sns, Event, (*(*global).global_exclusion_array)
      save_background,  Event, GLOBAL=global
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAMe='corner_pixel_height'): BEGIN
      makeExclusionArray_SNS, Event, add=1
      load_exclusion_roi_for_sns, Event, (*(*global).global_exclusion_array)
      save_background,  Event, GLOBAL=global
    END
    
    ;Selection inside button
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='selection_inside_draw_uname'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_selection_images, EVENT=event, $
            selection='inside'
          (*global).selection_type = 'inside'
        ENDIF
      ENDIF ELSE BEGIN ;endif of catch statement
        IF (event.enter EQ 1) THEN BEGIN
          id = WIDGET_INFO(Event.top,$
            find_by_uname='selection_inside_draw_uname')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF
      ENDELSE ;enf of catch statement
    END
    
    ;Selection outside button
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='selection_outside_draw_uname'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_selection_images, EVENT=event, $
            selection='outside'
          (*global).selection_type = 'outside'
        ENDIF
      ENDIF ELSE BEGIN ;endif of catch statement
        IF (event.enter EQ 1) THEN BEGIN
          id = WIDGET_INFO(Event.top,$
            find_by_uname='selection_outside_draw_uname')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF
      ENDELSE ;enf of catch statement
    END
    
    ;- Main Plot --------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='draw_uname'): BEGIN
      error = 0
      CATCH, error ;if mouse enters the draw or leaves then no error to catch
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        id = WIDGET_INFO(Event.top,find_by_uname='draw_uname')
        WIDGET_CONTROL, id, GET_VALUE=id_value
        WSET, id_value
        standard = 31
        DEVICE, CURSOR_STANDARD=standard
        IF ((*global).data_nexus_file_name NE '') THEN BEGIN
          getXYposition, Event ;_get
          IF ((*global).facility EQ 'LENS') THEN BEGIN
            IF ((*global).Xpixel  EQ 80L) THEN BEGIN
              putCountsValue, Event, Event.x/8., Event.y/8. ;_put
            ENDIF ELSE BEGIN
              putCountsValue, Event, Event.x/2., Event.y/2. ;_put
            ENDELSE
          ENDIF ELSE BEGIN
            error = 0
            CATCH, error
            IF (error NE 0) THEN BEGIN
              CATCH,/CANCEL
              RETURN
            ENDIF
            ;check if both panels are plotted
            id = WIDGET_INFO(Event.top,FIND_BY_UNAME='show_both_banks_button')
            value = WIDGET_INFO(id, /BUTTON_SET)
            coeff = 2
            IF (value EQ 1) THEN coeff = 1
            putCountsValue, Event, $
              Event.x/(coeff * (*global).congrid_x_coeff),$
              Event.y/(*global).congrid_y_coeff
          ENDELSE
          IF (Event.press EQ 1) THEN BEGIN
            IF ((*global).facility EQ 'LENS') THEN BEGIN
              IF ((*global).Xpixel  EQ 80L) THEN BEGIN
                X = Event.x/8.
                Y = Event.y/8.
              ENDIF ELSE BEGIN
                X = Event.x/2.
                Y = Event.y/2.
              ENDELSE
              
              putTextFieldValue, Event, $
                'x_center_value', STRCOMPRESS(X,/REMOVE_ALL)
              putTextFieldValue, Event, $
                'y_center_value', STRCOMPRESS(Y,/REMOVE_ALL)
                
            ENDIF ELSE BEGIN ;'SNS'
            
              (*global).left_button_clicked = 1
              (*global).mouse_moved = 0
              x0_device = Event.x
              y0_device = Event.y
              
              x0_data = convert_xdevice_into_data(Event, x0_device)
              y0_data = convert_ydevice_into_data(Event, y0_device)
              
              X = x0_data
              Y = y0_data
              
              x0_device = convert_xdata_into_device(Event, x0_data)
              y0_device = convert_ydata_into_device(Event, y0_data)
              
              (*global).x0_device = x0_device
              (*global).y0_device = y0_device
              
              putTextFieldValue, Event, $
                'corner_pixel_x0', $
                STRCOMPRESS(X+1)
              putTextFieldValue, Event, $
                'corner_pixel_y0', $
                STRCOMPRESS(Y)
                
            ENDELSE
          ENDIF
          
          IF ((*global).facility EQ 'SNS') THEN BEGIN ;for SNS only
          
            ;display width and height
            IF (event.release EQ 1) THEN BEGIN ;left button release
              (*global).left_button_clicked = 0
              IF ((*global).mouse_moved EQ 0) THEN RETURN
              temp_x_device = Event.x
              temp_y_device = Event.y
              
              ;ask user if he wants to validate his selection or not
              message = 'Do you want to validate your selection?'
              title = 'Validate Selection?'
              id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
              result = DIALOG_MESSAGE(message,$
                DIALOG_PARENT = id,$
                /CENTER,$
                /QUESTION,$
                title=title)
              IF (result EQ 'Yes') THEN BEGIN
                CATCH, /CANCEL
                TV, (*(*global).background), true=3
                display_excluded_pixels, Event, $
                  temp_x_device=temp_x_device, $
                  temp_y_device=temp_y_device
                makeExclusionArray_SNS, Event, ADD=1
                save_background,  Event, GLOBAL=global
              ENDIF ELSE BEGIN
                TV, (*(*global).background), true=3
              ENDELSE
            ENDIF
            
            IF (event.press EQ 0 AND $ ;moving mouse with left button clicked
              (*global).left_button_clicked EQ 1) THEN BEGIN
              
              (*global).mouse_moved = 1
              
              x0_data = getTextFieldValue(Event,'corner_pixel_x0')
              y0_data = getTextFieldValue(Event,'corner_pixel_y0')
              
              x1_device = Event.x
              y1_device = Event.y
              
              x1_data = convert_xdevice_into_data(Event, x1_device)
              y1_data = convert_ydevice_into_data(Event, y1_device)
              
              x1_data++
              
              width  = x1_data - x0_data
              ;go 2 by 2 for front and back panels only
              ;start at 1 if back panel
              panel_selected = getPanelSelected(Event)
              CASE (panel_selected) OF
                'front': BEGIN ;front
                  width /= 2
                END
                'back': BEGIN ;back
                  width /= 2
                END
                ELSE:
              ENDCASE
              
              IF (width EQ 0) THEN BEGIN
                width = 1
              ENDIF ELSE BEGIN
                IF (width LE 0) THEN BEGIN
                  width -= 1
                ENDIF ELSE BEGIN
                  width += 1
                ENDELSE
              ENDELSE
              
              height = y1_data - y0_data
              IF (height EQ 0) THEN BEGIN
                height = 1
              ENDIF ELSE BEGIN
                IF (height LT 0) THEN BEGIN
                  height -= 1
                ENDIF ELSE BEGIN
                  height += 1
                ENDELSE
              ENDELSE
              
              x1_device = convert_xdata_into_device(Event, x1_data)
              y1_device = convert_ydata_into_device(Event, y1_data)
              
              (*global).x1_device = x1_device
              (*global).y1_device = y1_device
              
              putTextFieldValue, Event, 'corner_pixel_width', width
              putTextFieldValue, Event, 'corner_pixel_height', height
              
              TV, (*(*global).background), true=3
              ;lin_or_log_plot, Event ;refresh of main plot
              display_selection_manually, Event
              
            ENDIF
            
          ENDIF
          
        ENDIF
        
      ENDIF ELSE BEGIN ;endif of catch /tracking events
      
        IF (Event.enter EQ 0) THEN BEGIN
        
          putTextFieldValue, Event, 'x_value', 'N/A'
          putTextFieldValue, Event, 'y_value', 'N/A'
          putTextFieldValue, Event, 'counts_value', 'N/A'
          IF ((*global).facility EQ 'SNS') THEN BEGIN
            putTextFieldValue, Event, 'bank_number_value', 'N/A'
            putTextFieldValue, Event, 'tube_local_number_value', 'N/A'
          ENDIF
          
        ENDIF
        
      ENDELSE ;endelse of catch /tracking event
      
    END
    
    ;-Linear of Logarithmic scale
    WIDGET_INFO(wWidget, FIND_BY_UNAME='z_axis_scale'): BEGIN
      IF (isAutoExcludeDeadTubeSelected(Event)) THEN BEGIN
        refresh_plot, Event ;_plot
        load_exclusion_roi_for_sns, Event, (*(*global).global_exclusion_array)
        plot_exclusion_of_dead_tubes, Event
        save_background,  Event, GLOBAL=global
      ENDIF ELSE BEGIN
        refresh_plot, Event ;_plot
        load_exclusion_roi_for_sns, Event, (*(*global).global_exclusion_array)
        save_background,  Event, GLOBAL=global
      ENDELSE
    ;      lin_or_log_plot, Event
    ;      RefreshRoiExclusionPlot, Event   ;_plot
    END
    
    ;- Run Number cw_field ----------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='run_number_cw_field'): BEGIN
      load_run_number, Event     ;_eventcb
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
        result = DIALOG_MESSAGE('Wrong input file', $
          /ERROR, $
          /CENTER, $
          TITLE='LOADING ERROR!', $
          DIALOG_PARENT=widget_id)
      ENDIF ELSE BEGIN
        IF ((*global).data_nexus_file_name NE '') THEN BEGIN
          auto_exclude_dead_tubes, Event
          save_background,  Event, GLOBAL=global
          makeExclusionArray_SNS, Event
          IF ((*global).facility EQ 'SNS') THEN BEGIN
            MapBase, Event, uname='transmission_launcher_base', 1
            display_images, EVENT=event
            display_selection_images, Event=event
            get_and_plot_tof_array, Event
          ENDIF
        ENDIF ELSE BEGIN
          MapBase, Event, uname='transmission_launcher_base', 0
          display_selection_images, EVENT=event, OFF=1
        ENDELSE
        
      ENDELSE
    END
    
    ;- Browse Button ----------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='browse_nexus_button'): BEGIN
      browse_nexus, Event ;_eventcb
      error = 0
    ; CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
        widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
        result = DIALOG_MESSAGE('Wrong input file', $
          /ERROR, $
          /CENTER, $
          TITLE='LOADING ERROR!', $
          DIALOG_PARENT=widget_id)
      ENDIF ELSE BEGIN
        IF ((*global).data_nexus_file_name NE '') THEN BEGIN
          auto_exclude_dead_tubes, Event
          save_background,  Event, GLOBAL=global
          makeExclusionArray_SNS, Event
          IF ((*global).facility EQ 'SNS') THEN BEGIN
            MapBase, Event, uname='transmission_launcher_base', 1
            display_images, EVENT=event
            display_selection_images, Event=event
            get_and_plot_tof_array, Event
          ENDIF
        ENDIF
      ENDELSE
    END
    
    ;- Selection Button -------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_tool_button'): BEGIN
      selection_tool, Event ;_eventcb
    END
    
    ;- Browse Selection File --------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_browse_button'): BEGIN
      browse_selection_file, Event ;_selection
      save_background,  Event, GLOBAL=global
    END
    
    ;- Preview Selection File -------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_preview_button'): BEGIN
      preview_selection_file, Event ;_selection
    END
    
    ;- Selection File Name Text Field -----------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_file_name_text_field'): BEGIN
      selection_text_field, Event ;_selection
    END
    
    ;- Selection Load Button --------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_load_button'): BEGIN
      LoadPlotSelection, Event ;_selection
      save_background,  Event, GLOBAL=global
    END
    
    ;-Exclusion Region Selection Tool -----------------------------------------
    ;- Preview button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='preview_exclusion_region'): BEGIN
      PreviewExclusionRegionCircle, Event ;_exclusion
    END
    
    ;- Plot button (fast)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_fast_exclusion_region'): BEGIN
      FastExclusionRegionCircle, Event ;_exclusion
    END
    
    ;- Plot button (accurate)
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_accurate_exclusion_region'): BEGIN
      AccurateExclusionRegionCircle, Event ;_exclusion
    END
    
    ;- Clear Input Boxed
    WIDGET_INFO(wWidget, FIND_BY_UNAME='clear_exclusion_input_boxes'): BEGIN
      ClearInputBoxes, Event ;_exclusion
    END
    
    ;- Type of selection
    WIDGET_INFO(wWidget, FIND_BY_UNAME='exclusion_half_in'): BEGIN
      exclusion_type, Event, INDEX=0 ;_exclusion
    ;        ExclusionRegionCircle, Event ;_exclusion
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='exclusion_half_out'): BEGIN
      exclusion_type, Event, INDEX=1 ;_exclusion
    ;        ExclusionRegionCircle, Event ;_exclusion
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='exclusion_outside_in'): BEGIN
      exclusion_type, Event, INDEX=2 ;_exclusion
    ;        ExclusionRegionCircle, Event ;_exclusion
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='exclusion_outside_out'): BEGIN
      exclusion_type, Event, INDEX=3 ;_exclusion
    ;        ExclusionRegionCircle, Event ;_exclusion
    END
    
    ;- SAVE
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_roi_button'): BEGIN
      IF ((*global).facility EQ 'LENS') THEN BEGIN
        SaveExclusionFile, Event ;_exclusion
      ENDIF ELSE BEGIN
        SaveExclusionFile_SNS, Event
      ENDELSE
    END
    
    ;- SAVE AS folder button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_roi_folder_button'): BEGIN
      SaveExclusionRoiFolderButton, Event ;_exclusion
    END
    
    ;- ROI text field
    WIDGET_INFO(wWidget, FIND_BY_UNAME='save_roi_text_field'): BEGIN
      SaveRoiTextFieldInteraction, Event ;_exclusion
    END
    
    ;- Preview Roi button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='preview_roi_exclusion_file'): BEGIN
      PreviewRoiExclusionFile, Event ;_exclusion
    END
    
    ;-END of Exclusion Region Selection Tool ----------------------------------
    
    ;- Clear Selection Button -------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='clear_selection_button'): BEGIN
      IF ((*global).data_nexus_file_name NE '') THEN BEGIN
        clear_selection_tool, Event ;_selection
        IF (isAutoExcludeDeadTubeSelected(Event)) THEN BEGIN
          plot_exclusion_of_dead_tubes, Event
        ENDIF
        save_background,  Event, GLOBAL=global
      ENDIF
    END
    
    ;- Refresh Plot -----------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='refresh_plot_button'): BEGIN
      IF ((*global).data_nexus_file_name NE '') THEN BEGIN
        IF ((*global).facility EQ 'LENS') THEN BEGIN
          refresh_plot, Event ;_plot
          RefreshRoiExclusionPlot, Event   ;_plot
        ENDIF ELSE BEGIN
          id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
          WIDGET_CONTROL, id, GET_VALUE = id_value
          WSET, id_value
          TV, (*(*global).background), true=3
          display_images, EVENT=event
          display_selection_images, Event=event
        ENDELSE
      ENDIF
    END
    
    ;- Selection Color Button -------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='selection_color_button'): BEGIN
      change_color_OF_selection, Event ;_selection
    END
    
    ;- Plot Color Button ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_color_button'): BEGIN
    END
    
    ;- Show front panels ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='show_front_bank_button'): BEGIN
      IF ((*global).data_nexus_file_name NE '') THEN BEGIN
        (*(*global).DataArray) = (*(*global).front_bank)
        refresh_plot, Event ;_plot
        load_exclusion_roi_for_sns, Event, (*(*global).global_exclusion_array)
        IF (isAutoExcludeDeadTubeSelected(Event)) THEN BEGIN
          plot_exclusion_of_dead_tubes, Event
        ENDIF
        save_background,  Event, GLOBAL=global
      ENDIF
    END
    
    ;- Show back panels ------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='show_back_bank_button'): BEGIN
      IF ((*global).data_nexus_file_name NE '') THEN BEGIN
        (*(*global).DataArray) = (*(*global).back_bank)
        refresh_plot, Event ;_plot
        load_exclusion_roi_for_sns, Event, (*(*global).global_exclusion_array)
        IF (isAutoExcludeDeadTubeSelected(Event)) THEN BEGIN
          plot_exclusion_of_dead_tubes, Event
        ENDIF
        save_background,  Event, GLOBAL=global
      ENDIF
    END
    
    ;- Show front and back panels ---------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='show_both_banks_button'): BEGIN
      IF ((*global).data_nexus_file_name NE '') THEN BEGIN
        (*(*global).DataArray) = (*(*global).both_banks)
        refresh_plot, Event ;_plot
        load_exclusion_roi_for_sns, Event, (*(*global).global_exclusion_array)
        IF (isAutoExcludeDeadTubeSelected(Event)) THEN BEGIN
          plot_exclusion_of_dead_tubes, Event
        ENDIF
        save_background,  Event, GLOBAL=global
      ENDIF
    END
    
    ;Automatically Exclude Dead Tubes or not ----------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME = 'exclude_dead_tube_auto'): BEGIN
      IF ((*global).data_nexus_file_name NE '') THEN BEGIN
        refresh_plot, Event ;_plot
        load_exclusion_roi_for_sns, Event, (*(*global).global_exclusion_array)
        IF (isAutoExcludeDeadTubeSelected(Event)) THEN BEGIN
          plot_exclusion_of_dead_tubes, Event
        ENDIF
        save_background,  Event, GLOBAL=global
        makeExclusionArray_SNS, Event
      ENDIF
    END
    
    ;Transmission calculation button
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='transmission_calculation_button'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_images, EVENT=event, $
            transmission='on'
          launch_transmission_auto_manual_base, Event
        ENDIF ELSE BEGIN
          display_images, EVENT=event, $
            transmission='off'
        ENDELSE
      ENDIF ELSE BEGIN ;endif of catch statement
        IF (event.enter EQ 1) THEN BEGIN
          id = WIDGET_INFO(Event.top,$
            find_by_uname='transmission_calculation_button')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF
      ENDELSE ;enf of catch statement
    END
    
    ;Beam Center Button
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='beam_center_calculation_button'): BEGIN
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN ;press button or othe events
        CATCH,/CANCEL
        IF (event.press EQ 1) THEN BEGIN ;pressed button
          display_images, EVENT=event, $
            beam_center='on'
          launch_beam_center_base, Event
        ENDIF ELSE BEGIN
          display_images, EVENT=event, $
            beam_center='off'
        ENDELSE
      ENDIF ELSE BEGIN ;endif of catch statement
        IF (event.enter EQ 1) THEN BEGIN
          id = WIDGET_INFO(Event.top,$
            find_by_uname='beam_center_calculation_button')
          WIDGET_CONTROL, id, GET_VALUE=id_value
          WSET, id_value
          standard = 58
          DEVICE, CURSOR_STANDARD=standard
        ENDIF
      ENDELSE ;enf of catch statement
    END
    
    ;= TAB2 (REDUCE) ==========================================================
    
    ;---- GO DATA REDUCTION button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='go_data_reduction_button'): BEGIN
      test_RunCommandLine, Event ;_run_commandline
    END
    
    ;==== tab1 (LOAD FILES (1)) ===============================================
    
    ;----Data File ------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_run_number_cw_field'): BEGIN
      LoadNeXus, Event, $
        'data_run_number_cw_field', $
        'data_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='data_browse_button'): BEGIN
      BrowseNexus, Event, $
        'data_browse_button',$
        'data_file_name_text_field'
    END
    
    ;----ROI FIle -------------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='roi_browse_button'): BEGIN
      BrowseNexus, Event, $
        'roi_browse_button',$
        'roi_file_name_text_field'
    END
    
    ;----Solvant Buffer Only File ---------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='solvant_run_number_cw_field'): BEGIN
      LoadNeXus, Event, $
        'solvant_run_number_cw_field',$
        'solvant_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='solvant_browse_button'): BEGIN
      BrowseNexus, Event, $
        'solvant_browse_button',$
        'solvant_file_name_text_field'
    END
    
    ;----Empty Can  -----------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_run_number_cw_field'): BEGIN
      LoadNeXus, Event, $
        'empty_run_number_cw_field',$
        'empty_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='empty_browse_button'): BEGIN
      BrowseNexus, Event, $
        'empty_browse_button',$
        'empty_file_name_text_field'
    END
    
    ;----Open Beam  -----------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='open_run_number_cw_field'): BEGIN
      LoadNeXus, Event, $
        'open_run_number_cw_field',$
        'open_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='open_browse_button'): BEGIN
      BrowseNexus, Event, $
        'open_browse_button',$
        'open_file_name_text_field'
    END
    
    ;----Dark Current  --------------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='dark_run_number_cw_field'): BEGIN
      LoadNeXus, Event, $
        'dark_run_number_cw_field',$
        'dark_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, FIND_BY_UNAME='dark_browse_button'): BEGIN
      BrowseNexus, Event, $
        'dark_browse_button',$
        'dark_file_name_text_field'
    END
    
    ;----Sample Data File -----------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'sample_data_transmission_run_number_cw_field'): BEGIN
    ;       LoadNeXus, Event, $
    ;         'sample_data_transmission_run_number_cw_field', $
    ;         'sample_data_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'sample_data_transmission_browse_button'): BEGIN
      BrowseTxt, Event, $
        'sample_data_transmission_browse_button',$
        'sample_data_transmission_file_name_text_field'
    END
    
    ;----Empty Can Transmission -----------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'empty_can_transmission_run_number_cw_field'): BEGIN
    ;        LoadNeXus, Event, $
    ;          'empty_can_transmission_run_number_cw_field', $
    ;          'empty_can_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'empty_can_transmission_browse_button'): BEGIN
      BrowseTxt, Event, $
        'empty_can_transmission_browse_button',$
        'empty_can_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget,$
      FIND_BY_UNAME= $
      'output_folder'): BEGIN
      BrowseOutputFolder, Event ;_reduce_tab2
    END
    
    ;--- Solvent Transmission -------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'solvent_transmission_run_number_cw_field'): BEGIN
    ;        LoadNeXus, Event, $
    ;          'solvent_transmission_run_number_cw_field', $
    ;          'solvent_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME= $
      'solvent_transmission_browse_button'): BEGIN
      BrowseTxt, Event, $
        'solvent_transmission_browse_button',$
        'solvent_transmission_file_name_text_field'
    END
    
    WIDGET_INFO(wWidget,$
      FIND_BY_UNAME= $
      'output_folder'): BEGIN
      BrowseOutputFolder, Event ;_reduce_tab2
    END
    
    ;Clear File Name text field button ----------------------------------------
    WIDGET_INFO(wWidget,$
      FIND_BY_UNAME= $
      'clear_output_file_name_button'): BEGIN
      clearOutputFileName, Event ;_reduce_tab2
    END
    
    ;Reset File Name ----------------------------------------------------------
    WIDGET_INFO(wWidget,$
      FIND_BY_UNAME= $
      'reset_output_file_name_button'): BEGIN
      ResetOutputFileName, Event ;_reduce_tab2
    END
    
    ;Auto or Manual File Name
    WIDGET_INFO(wWidget,$
      FIND_BY_UNAME= $
      'auto_user_file_name_group'): BEGIN
      IF (getCWBgroupValue(Event, $
        'auto_user_file_name_group') EQ 0) THEN BEGIN
        auto_output_file_name = 1
      ENDIF ELSE BEGIN
        auto_output_file_name = 0
      ENDELSE
      (*global).auto_output_file_name = auto_output_file_name
      activate_widget, Event, $
        'reset_output_file_name_button', $
        auto_output_file_name
    END
    
    ;==== tab2 (PARAMETERS) ===================================================
    
    ;---- YES or NO geometry cw_bgroup ----------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='overwrite_geometry_group'): BEGIN
      GeometryGroupInteraction, Event ;_reduce_tab3
    END
    
    ;---- Browse button of the overwrite geometry button ----------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='overwrite_geometry_button'): BEGIN
      BrowseGeometry, Event ;_reduce_tab3
    END
    
    ;---- Monitor Efficiency --------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='monitor_efficiency_group'): BEGIN
      monitor_efficiency_constant_gui, Event ;_reduce_tab3
    END
    
    ;---- Detector Efficiency -------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='detector_efficiency_group'): BEGIN
      detector_efficiency_constant_gui, Event ;_reduce_tab3
    END
    
    ;---- Min Lambda Cut off --------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='minimum_lambda_cut_off_group'): BEGIN
      min_lambda_cut_off_gui, Event ;_reduce_tab3
    END
    
    ;---- Max Lambda Cut off --------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='maximum_lambda_cut_off_group'): BEGIN
      max_lambda_cut_off_gui, Event ;_reduce_tab3
    END
    
    ;---- Scaling Constant ----------------------------------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='scaling_constant_group'): BEGIN
      scaling_constant_gui, Event ;_reduce_tab3
    END
    
    ;---- Wavelength dependent background subtraction -------------------------
    WIDGET_INFO(wWidget, FIND_BY_UNAME='wave_help_button'): BEGIN
      id = WIDGET_INFO(wWidget, $
        FIND_BY_UNAME='wave_dependent_back_sub_text_field')
      id1 = WIDGET_INFO(wWidget, $
        FIND_BY_UNAME='wave_para_label_uname')
        
      IF (Event.select EQ 1) THEN BEGIN ;button pressed
        WIDGET_CONTROL, id, GET_VALUE = value
        (*global).wave_para_value = value
        WIDGET_CONTROL, id1, SET_VALUE = (*global).wave_para_help_label
        WIDGET_CONTROL, id, SET_VALUE = (*global).wave_para_help_value
      ENDIF ELSE BEGIN
        value = (*global).wave_para_value
        WIDGET_CONTROL, id1, SET_VALUE = (*global).wave_para_label
        WIDGET_CONTROL, id, SET_VALUE = value
      ENDELSE
      
      value = getTextFieldValue(Event,'wave_dependent_back_sub_text_field')
      IF (value EQ '') THEN BEGIN
        status = 0
      ENDIF ELSE BEGIN
        status = 1
      ENDELSE
      activate_widget, Event, 'acce_base', status
      
    END
    
    ;---- Browse button of Wavelength Dependent Back. subtraction -------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='wave_dependent_back_browse_button'): BEGIN
      BrowseLoadWaveFile, Event ;_reduce_tab3
      value = getTextFieldValue(Event,'wave_dependent_back_sub_text_field')
      IF (value EQ '') THEN BEGIN
        status = 0
      ENDIF ELSE BEGIN
        status = 1
      ENDELSE
      activate_widget, Event, 'acce_base', status
      
    END
    
    ;--- comma-delimited list of increasing coefficients ----------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='wave_dependent_back_sub_text_field'): BEGIN
      value = getTextFieldValue(Event,'wave_dependent_back_sub_text_field')
      IF (value EQ '') THEN BEGIN
        status = 0
      ENDIF ELSE BEGIN
        status = 1
      ENDELSE
      activate_widget, Event, 'acce_base', status
    END
    
    ;---- Clear Wavelength coefficient text field -----------------------------
    WIDGET_INFO(wWidget,$
      FIND_BY_UNAME= $
      'wave_clear_text_field'): BEGIN
      putTextFieldValue, Event, 'wave_dependent_back_sub_text_field',''
      (*global).scaling_value = ''
    END
    
    ;= TAB3 (PLOT) ============================================================
    
    ;---- Refresh plot --------------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='plot_refresh_plot_ascii_button'): BEGIN
      rePlotAsciiData, Event ;_tab_plot
    END
    
    ;----- Advanced Plot ------------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='plot_advanced_plot_ascii_button'): BEGIN
      plot_advanced_ascii_data, Event
    END
    
    ;plot widget_draw
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='plot_draw_uname'): BEGIN
      
      IF ((*global).ascii_file_load_status) THEN BEGIN
      
        error = 0
        CATCH, error
        IF (error NE 0) THEN BEGIN
          CATCH,/CANCEL
          
          draw_id = widget_info(Event.top, find_by_uname='plot_draw_uname')
          WIDGET_CONTROL, draw_id, GET_VALUE = view_plot_id
          wset,view_plot_id
          
          IF (isPlotTabZoomSelected(Event)) THEN BEGIN ;ZOOM
          
            IF (Event.press EQ 1) THEN BEGIN ;left click
              (*global).plot_left_click = 1
              CURSOR, X, Y, /DATA
              xyminmax = FLTARR(4)
              xyminmax[0] = X
              xyminmax[1] = Y
              (*global).xyminmax = xyminmax
            ENDIF
            
            IF ((*global).plot_left_click) THEN BEGIN ;moving mouse with left click
              rePlotAsciiData, Event ;_tab_plot
              xyminmax = (*global).xyminmax
              CURSOR, X, Y, /DATA, /NOWAIT
              xyminmax[2] = X
              xyminmax[3] = Y
              (*global).xyminmax = xyminmax
              plot_zoom_selection_plot_tab, Event
            ENDIF
            
            IF (Event.release EQ 1) THEN BEGIN ;release left click
              (*global).old_xyminmax = (*global).xyminmax
              rePlotAsciiData, Event ;_tab_plot
              (*global).plot_left_click = 0
            ENDIF
            
          ENDIF ELSE BEGIN ;if fitting selected
          
            xaxis_type = getPlotTabXaxisScale(Event)
            IF (xaxis_type NE 'Q2') THEN RETURN
            yaxis_type = getPlotTabYaxisScale(Event)
            IF (xaxis_type EQ 'lin') THEN RETURN
            
            IF ((*global).plot_left_click) THEN BEGIN ;moving mouse with left click
              xminmax_fitting = (*global).xminmax_fitting
              CURSOR, X, Y, /DATA, /NOWAIT
              xaxis_type = getPlotTabXaxisScale(Event)
              IF (xaxis_type EQ 'Q2') THEN BEGIN
                X = SQRT(X)
              ENDIF
              xminmax_fitting[1] = X
              (*global).xminmax_fitting = xminmax_fitting
              (*global).fitting_to_plot = 1b
              retrieve_xarray_yarray_SigmaYarray_for_fitting, Event
              rePlotAsciiData, Event ;_tab_plot
            ENDIF
            
            IF (Event.press EQ 1) THEN BEGIN ;left click
              (*global).plot_left_click = 1
              CURSOR, X, Y, /DATA
              xaxis_type = getPlotTabXaxisScale(Event)
              IF (xaxis_type EQ 'Q2') THEN BEGIN
                X = SQRT(X)
              ENDIF
              xminmax_fitting = FLTARR(2)
              xminmax_fitting[0] = X
              (*global).xminmax_fitting = xminmax_fitting
              (*global).fitting_to_plot = 0b
              rePlotAsciiData, Event ;_tab_plot
            ENDIF
            
            IF (Event.release EQ 1) THEN BEGIN ;release left click
              retrieve_xarray_yarray_SigmaYarray_for_fitting, Event
              rePlotAsciiData, Event ;_tab_plot
              (*global).plot_left_click = 0
              (*global).fitting_to_plot = 1b
              calculate_fitting_function, Event
              plot_fitting, Event
            ENDIF
            
          ENDELSE ;end of if zoom or fitting selected
          
        ENDIF ELSE BEGIN ;end of catch statement
        
          IF (Event.enter EQ 1) THEN BEGIN ;entering plot
            id = WIDGET_INFO(Event.top, FIND_BY_UNAME='plot_draw_uname')
            WIDGET_CONTROL, id, /INPUT_FOCUS
          ENDIF
          
        ENDELSE
        
      ENDIF ;end of if ascii_file_load_status
      
    END
    
    ;zoom button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_zoom_button'): BEGIN
      help_label = 'Click-Move-Release to zoom - double click to reset zoom'
      putTextFieldValue, Event, 'plot_tab_help_label', help_label
    END
    
    ;fitting button
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_fit_button'): BEGIN
      equation_to_show = getFittingEquationToShow(Event)
      IF (equation_to_show EQ 'no') THEN BEGIN
        help_label = ''
      ENDIF ELSE BEGIN
        help_label = (*global).plot_tab_fitting_help_message
      ENDELSE
      putTextFieldValue, Event, 'plot_tab_help_label', help_label
      
      id = (*global).plot_tab_fitting_wBase
      ;not a valid id so we need to mapped it
      IF (WIDGET_INFO(id, /VALID_ID) EQ 0) THEN BEGIN
        display_plot_tab_fitting_base, Event
      ENDIF ELSE BEGIN
        WIDGET_CONTROL, id, /SHOW
      ENDELSE
      
      display_fitting_base_draw, $
        MAIN_BASE=(*global).plot_tab_fitting_wBase, $
        EQUATION=equation_to_show
    END
    
    ;yaxis and xaxis scales
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_y_axis_lin'): BEGIN
      rePlotAsciiData, Event
      display_right_equation_in_fitting_base, Event
      plot_fitting, Event
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_y_axis_log'): BEGIN
      rePlotAsciiData, Event
      display_right_equation_in_fitting_base, Event
      plot_fitting, Event
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_y_axis_log_Q_IQ'): BEGIN
      rePlotAsciiData, Event
      display_right_equation_in_fitting_base, Event
      plot_fitting, Event
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_y_axis_log_Q2_IQ'): BEGIN
      rePlotAsciiData, Event
      display_right_equation_in_fitting_base, Event
      plot_fitting, Event
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_x_axis_lin'): BEGIN
      rePlotAsciiData, Event
      display_right_equation_in_fitting_base, Event
      plot_fitting, Event
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_x_axis_log'): BEGIN
      rePlotAsciiData, Event
      display_right_equation_in_fitting_base, Event
      plot_fitting, Event
    END
    WIDGET_INFO(wWidget, FIND_BY_UNAME='plot_tab_x_axis_Q2'): BEGIN
      rePlotAsciiData, Event
      display_right_equation_in_fitting_base, Event
      plot_fitting, Event
    END
    
    ;---- Browse ASCII file ---------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='plot_input_file_browse_button'): BEGIN
      BrowseInputAsciiFile, Event ;_tab_plot
    END
    
    ;---- Input text field ----------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='plot_input_file_text_field'): BEGIN
      check_IF_file_exist, Event ;_tab_plot
    END
    
    ;---- Load File Button ----------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='plot_input_file_load_button'): BEGIN
      LoadAsciiFile, Event ;_tab_plot
    END
    
    ;---- Preview button ------------------------------------------------------
    WIDGET_INFO(wWidget, $
      FIND_BY_UNAME='plot_input_file_preview_button'): BEGIN
      preview_ascii_file, event ;_tab_plot
    END
    
    ;= TAB4 (LOG BOOK) ========================================================
    WIDGET_INFO(wWidget, FIND_BY_UNAME='send_to_geek_button'): BEGIN
      SendToGeek, Event       ;_IDLsendToGeek
    END
    
    ELSE:
    
  ENDCASE
  
  IF ((*global).build_command_line) THEN BEGIN
    CheckCommandLine, Event         ;_command_line
  ENDIF
  
END
