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
        putTextFieldValue, Event, 'trans_manual_step1_cursor_tube', $
          STRCOMPRESS(tube,/REMOVE_ALL)
        putTextFieldValue, Event, 'trans_manual_step1_cursor_pixel', $
          STRCOMPRESS(pixel,/REMOVE_ALL)
          
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
      refresh_trans_manual_step2_plots_counts_vs_x_and_y, Event
    END
    
    ;STEP2 - STEP2 - STEP2 - STEP2 - STEP2 - STEP2 - STEP2 - STEP2 - STEP2 -
    
    ;Number of iteration text box
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_nbr_iterations'): BEGIN
      trans_manual_step2_calculate_background, Event
    END
    
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_calculate'): BEGIN
      trans_manual_step2_calculate_background, Event
    END
    
    ;edit background value
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_edit_background'): BEGIN
      map_base, Event, 'trans_manual_step2_edit_background_base', 0
      map_base, Event, 'trans_manual_step2_lock_edit_background_base', 1
      putTextFieldValue, Event, 'trans_manual_step2_background_edit', $
        STRCOMPRESS((*global).trans_manual_step2_background,/REMOVE_ALL)
    END
    
    ;background value edit widget_text
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME = 'trans_manual_step2_background_edit'): BEGIN
      trans_manual_step2_manual_input_of_background, Event
    END
    
    ;lock edit background value
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_lock_edit_background'): BEGIN
      map_base, Event, 'trans_manual_step2_edit_background_base', 1
      map_base, Event, 'trans_manual_step2_lock_edit_background_base', 0
      putTextFieldValue, Event, 'trans_manual_step2_background_value', $
        STRCOMPRESS((*global).trans_manual_step2_background,/REMOVE_ALL)
    END
    
    ;Algorithm description button
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_algorithm_description'): BEGIN
      display_trans_step2_algorith_image, Event
    END
    
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_manual_step2_go_to_previous_step'): BEGIN
      MapBase, event, uname='manual_transmission_step1', 1
      plot_trans_manual_step1_background, Event
      refresh_plot_selection_trans_manual_step1, Event
      plot_transmission_step1_scale_from_event, Event
    END
    
    ELSE:
  ENDCASE
  
END

;------------------------------------------------------------------------------
FUNCTION isTranManualStep1LinSelected, Event
  RETURN, isLinSelected_uname(Event, uname='transmission_manual_step1_linear')
END

;------------------------------------------------------------------------------
PRO transmission_manual_mode_gui, wBase, main_base_geometry, sys_color_window_bk

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 700 ;width of various steps of manual mode
  ysize = 840 ;height of various steps of manual mode
  
  xoffset = main_base_xoffset + main_base_xsize/2-xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2-ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Transmission Calculation -> STEP 1/3: ' + $
    'Define Beam Stop Region',$
    UNAME        = 'transmission_manual_mode_base',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup)
    
  ;design step1
  step1_base = design_transmission_manual_mode_step1(wBase)
  
  ;design step2
  step2_base = design_transmission_manual_mode_step2(wBase)
  
  WIDGET_CONTROL, wBase, /REALIZE
  
  plot_transmission_step1_scale, step1_base, sys_color_window_bk
  
END

;------------------------------------------------------------------------------
PRO plot_data_around_beam_stop, EVENT=event, MAIN_BASE=wBase, $
    global, $
    global_step1
    
  both_banks = (*(*global).both_banks)
  zoom_data = both_banks[*,112:151,80:111]
  
  t_zoom_data = TOTAL(zoom_data,1)
  tt_zoom_data = TRANSPOSE(t_zoom_data)
  (*(*global_step1).tt_zoom_data) = tt_zoom_data
  rtt_zoom_data = CONGRID(tt_zoom_data, 450, 400)
  (*(*global_step1).rtt_zoom_data) = rtt_zoom_data
  
  id = WIDGET_INFO(wBase,FIND_BY_UNAME='manual_transmission_step1_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TVSCL, rtt_zoom_data
  
END

;------------------------------------------------------------------------------
PRO refresh_transmission_manual_step1_main_plot, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_step1
  
  data = (*(*global_step1).rtt_zoom_data)
  
  IF (~isTranManualStep1LinSelected(Event)) THEN BEGIN ;log mode
    index = WHERE(data EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      data[index] = !VALUES.D_NAN
    ENDIF
    Data_log = ALOG10(Data)
    Data_log_bytscl = BYTSCL(Data_log,/NAN)
    data = data_log_bytscl
  ENDIF
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='manual_transmission_step1_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  DEVICE, DECOMPOSED = 0
  LOADCT,5,/SILENT
  
  TVSCL, data, /DEVICE
  
  save_transmission_manual_step1_background,  EVENT=Event
  
END

;------------------------------------------------------------------------------
PRO plot_trans_manual_step1_background, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  id = WIDGET_INFO(event.top,FIND_BY_UNAME='manual_transmission_step1_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TV, (*(*global).background), true=3
  
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
PRO launch_transmission_manual_mode_base, main_event

  id = WIDGET_INFO(main_event.top, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,main_event.top,GET_UVALUE=global
  
  ;build gui
  wBase = ''
  sys_color_window_bk = 0
  transmission_manual_mode_gui, wBase, $
    main_base_geometry, sys_color_window_bk
    
  global_step1 = PTR_NEW({ wbase: wbase,$
    global: global,$
    background: PTR_NEW(0L), $
    rtt_zoom_data: PTR_NEW(0L), $
    tt_zoom_data: PTR_NEW(0L), $
    counts_vs_x: PTR_NEW(0L), $
    counts_vs_y: PTR_NEW(0L), $
    pixel_x_axis: PTR_NEW(0L), $
    tube_x_axis: PTR_NEW(0L), $
    counts_vs_xy: PTR_NEW(0L), $
    trans_manual_step2_background: 0L, $
    trans_manual_step2_transmission_intensity: 0L, $
    left_button_clicked: 0, $
    sys_color_window_bk: sys_color_window_bk, $
    working_with_xy: 0, $
    x0y0x1y1: INTARR(4), $
    main_event: main_event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_step1
  XMANAGER, "launch_transmission_manual_mode", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
  plot_data_around_beam_stop, main_base=wBase, global, global_step1
  
  ;save background
  save_transmission_manual_step1_background,  Event=event, MAIN_BASE=wBase
  
END

