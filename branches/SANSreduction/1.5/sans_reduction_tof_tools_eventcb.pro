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

PRO populate_tof_tools_base, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  tof_counts = (*(*global).tof_counts)
  tof_tof = (*(*global).array_of_tof_bins)
  
  sz = N_ELEMENTS(tof_tof)
  
  tof_base   = (*global).tof_tools_base
  tof_fields_mode1 = (*global).tof_fields_mode1
  tof_fields_mode2 = (*global).tof_fields_mode2
  
  ;populate 'display a predefined tof range'
  ;select everything by default
  default_from_tof = tof_tof[0]
  default_from_bin = 0
  default_to_tof = tof_tof[sz-1]
  default_to_bin = sz-1
  
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_from_tof_micros')
  WIDGET_CONTROL, id, SET_VALUE= default_from_tof
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_to_tof_micros')
  WIDGET_CONTROL, id, SET_VALUE= default_to_tof
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_from_tof_bin')
  WIDGET_CONTROL, id, SET_VALUE= default_from_bin
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_to_tof_bin')
  WIDGET_CONTROL, id, SET_VALUE= default_to_bin
  
  ;save default value
  tof_fields_mode1.from.tof = default_from_tof
  tof_fields_mode1.to.tof   = default_to_tof
  tof_fields_mode1.from.bin = default_from_bin
  tof_fields_mode1.to.bin   = default_to_bin
  
  ;populate 'play tofs'
  ;select first 10 bins by default
  default_from_tof = tof_tof[0]
  default_from_bin = 0
  default_to_tof = tof_tof[sz-1]
  default_to_bin = sz-1
  
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_from_tof_micros')
  WIDGET_CONTROL, id, SET_VALUE= default_from_tof
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_to_tof_micros')
  WIDGET_CONTROL, id, SET_VALUE= default_to_tof
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_from_tof_bin')
  WIDGET_CONTROL, id, SET_VALUE= default_from_bin
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_to_tof_bin')
  WIDGET_CONTROL, id, SET_VALUE= default_to_bin
  
  ;save default value
  tof_fields_mode2.from.tof = default_from_tof
  tof_fields_mode2.to.tof   = default_to_tof
  tof_fields_mode2.from.bin = default_from_bin
  tof_fields_mode2.to.bin   = default_to_bin
  
  ;populate min and max values the user can input
  ;Display a predefined TOF range and play tofs
  
  minstring = '(min: '
  maxstring = '(max: '
  
  tof_min_value = minstring + STRCOMPRESS(default_from_tof,/REMOVE_ALL) + ')'
  tof_max_value = maxstring + STRCOMPRESS(default_to_tof,/REMOVE_ALL) + ')'
  bin_min_value = minstring + $
    STRCOMPRESS(FIX(default_from_bin),/REMOVE_ALL) + ')'
  bin_max_value = maxstring + STRCOMPRESS(FIX(default_to_bin),/REMOVE_ALL) + ')'
  
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_from_tof_micros_help')
  WIDGET_CONTROL, id, SET_VALUE=tof_min_value
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_to_tof_micros_help')
  WIDGET_CONTROL, id, SET_VALUE=tof_max_value
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_from_tof_micros_help')
  WIDGET_CONTROL, id, SET_VALUE=tof_min_value
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_to_tof_micros_help')
  WIDGET_CONTROL, id, SET_VALUE=tof_max_value
  
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_from_tof_bin_help')
  WIDGET_CONTROL, id, SET_VALUE=bin_min_value
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode1_to_tof_bin_help')
  WIDGET_CONTROL, id, SET_VALUE=bin_max_value
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_from_tof_bin_help')
  WIDGET_CONTROL, id, SET_VALUE=bin_min_value
  id = WIDGET_INFO(tof_base, FIND_BY_UNAME='mode2_to_tof_bin_help')
  WIDGET_CONTROL, id, SET_VALUE=bin_max_value
  
  (*global).tof_fields_mode1 = tof_fields_mode1
  (*global).tof_fields_mode2 = tof_fields_mode2
  
END

;------------------------------------------------------------------------------
PRO turn_on_tof_mode, Event, MODE=mode
  IF (MODE EQ 1) THEN BEGIN ;mode1
    base1_status=1
    base2_status=0
  ENDIF ELSE BEGIN ;mode2
    base1_status=0
    base2_status=1
  ENDELSE
  map_base, Event, 'display_tof_range_base', base1_status
  map_base, Event, 'play_tof_range_base', base2_status
END

;------------------------------------------------------------------------------
PRO save_tof_min_max, Event, MODE=mode
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof
  global = (*global_tof).global
  IF (MODE EQ 1) THEN BEGIN ;mode1
    xmin = getTextFieldValue(Event,'mode1_from_tof_micros')
    xmax = getTextFieldValue(Event,'mode1_to_tof_micros')
  ENDIF ELSE BEGIN
    xmin = getTextFieldValue(Event,'mode2_from_tof_micros')
    xmax = getTextFieldValue(Event,'mode2_to_tof_micros')
  ;xwidth = getTextFieldValue(Event,'tof_bin_size')
  ;tof_tof = (*(*global).array_of_tof_bins)
  ;xmax = tof_tof[xmin+xwidth]
  ENDELSE
  tof_range = (*global).tof_range
  tof_range.min = xmin
  tof_range.max = xmax
  (*global).tof_range = tof_range
END

;------------------------------------------------------------------------------
;This procedures takes the given argument form (from/to) (mode1/2) (bin/micros),
;calculates the equivalent in the other units (bin<->micros) and repopulates
;the other field from the same mode and type
PRO update_other_tof_field, Event, $
    MODE=mode, $  ;1 or 2
    AXIS=axis,$ ;'micros' or 'bin'
    TYPE=type ;'from' or 'to'
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof
  global = (*global_tof).global
  
  success = 0
  
  CASE (MODE) OF
    1: BEGIN
      mode_base = 'mode1_'
      tof_fields = (*global).tof_fields_mode1
    END
    2: BEGIN
      mode_base = 'mode2_'
      tof_fields = (*global).tof_fields_mode2
    END
  ENDCASE
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='tof_tools_widget_base')
  
  CASE (TYPE) OF
    'from': BEGIN ;from
      CASE (AXIS) OF
        'micros': BEGIN ;micros
          micros = getTextFieldValue(Event,mode_base+'from_tof_micros')
          bin = convert_micros_to_bin(Event,micros)
          result = is_from_lower_than_to(Event, MODE=mode, TEST='micros')
          IF (bin EQ -1) THEN BEGIN ;outside of range
            micro_min = getTextFieldValue(Event,mode_base+'from_tof_micros_help')
            micro_max = getTextFieldValue(Event,mode_base+'to_tof_micros_help')
            text = ['INPUT ERROR',$
              STRCOMPRESS(micros,/REMOVE_ALL) + ' is outside of range',$
              micro_min + ' - ' + micro_max]
            result = DIALOG_MESSAGE(text, $
              /CENTER, $
              DIALOG_PARENT=id,$
              /ERROR)
            value = tof_fields.from.tof
            putTextFieldValue, Event, mode_base+'from_tof_micros', value
          ENDIF ELSE BEGIN
            result = is_from_lower_than_to(Event, MODE=mode, $
            TEST='micros') ;make sure from<to
            IF (result EQ 0b) THEN BEGIN
              text = ['INPUT ERROR',$
                'FROM value is greater or equal to TO value !']
              result = DIALOG_MESSAGE(text, $
                /CENTER, $
                DIALOG_PARENT=id,$
                /ERROR)
              value = tof_fields.from.tof
              putTextFieldValue, Event, mode_base+'from_tof_micros', value
            ENDIF ELSE BEGIN
              sbin = STRCOMPRESS(bin,/REMOVE_ALL)
              putTextFieldValue, Event,mode_base+'from_tof_bin', sbin
              xmin = getTextFieldValue(Event,mode_base+'from_tof_micros')
              xmax = getTextFieldValue(Event,mode_base+'to_tof_micros')
              tof_fields.from.tof = micros
              success = 1
            ENDELSE
          ENDELSE
        END
        'bin': BEGIN ;bin
          bin = getTextFieldValue(Event,mode_base+'from_tof_bin')
          micros = convert_bin_to_micros(Event,bin)
          IF (micros EQ -1) THEN BEGIN ;outside of range
            bin_min = getTextFieldValue(Event,mode_base+'from_tof_bin_help')
            bin_max = getTextFieldValue(Event,mode_base+'to_tof_bin_help')
            text = ['INPUT ERROR',$
              STRCOMPRESS(bin,/REMOVE_ALL) + ' is outside of range',$
              bin_min + ' - ' + bin_max]
            result = DIALOG_MESSAGE(text, $
              /CENTER,$
              DIALOG_PARENT=id,$
              /ERROR)
            value = tof_fields.from.bin
            putTextFieldValue, Event, mode_base+'from_tof_bin', value
          ENDIF ELSE BEGIN
            result = is_from_lower_than_to(Event, MODE=mode, TEST='bin') ;make sure from<to
            IF (result EQ 0b) THEN BEGIN
              text = ['INPUT ERROR',$
                'FROM value is greater or equal to TO value !']
              result = DIALOG_MESSAGE(text, $
                /CENTER, $
                DIALOG_PARENT=id,$
                /ERROR)
              value = tof_fields.from.bin
              putTextFieldValue, Event, mode_base+'from_tof_bin', value
            ENDIF ELSE BEGIN
              smicros = STRCOMPRESS(micros,/REMOVE_ALL)
              putTextFieldValue, Event,mode_base+'from_tof_micros', smicros
              xmin = getTextFieldValue(Event,mode_base+'from_tof_micros')
              xmax = getTextFieldValue(Event,mode_base+'to_tof_micros')
              tof_fields.from.bin = bin
              success = 1
            ENDELSE
          ENDELSE
        END
      ENDCASE
    END
    'to': BEGIN ;to
      CASE (AXIS) OF
        'micros': BEGIN
          micros = getTextFieldValue(Event,mode_base+'to_tof_micros')
          bin = convert_micros_to_bin(Event,micros)
          IF (bin EQ -1) THEN BEGIN ;outside of range
            micro_min = getTextFieldValue(Event,mode_base+'from_tof_micros_help')
            micro_max = getTextFieldValue(Event,mode_base+'to_tof_micros_help')
            text = ['INPUT ERROR',$
              STRCOMPRESS(micros,/REMOVE_ALL) + ' is outside of range',$
              micro_min + ' - ' + micro_max]
            result = DIALOG_MESSAGE(text, $
              /CENTER, $
              DIALOG_PARENT=id,$
              /ERROR)
            value = tof_fields.to.tof
            putTextFieldValue, Event, mode_base+'to_tof_micros', value
          ENDIF ELSE BEGIN
            result = is_from_lower_than_to(Event, MODE=mode,$
            TEST='micros') ;make sure from<to
            IF (result EQ 0b) THEN BEGIN
              text = ['INPUT ERROR',$
                'FROM value is greater or equal to TO value !']
              result = DIALOG_MESSAGE(text, $
                /CENTER, $
                DIALOG_PARENT=id,$
                /ERROR)
              value = tof_fields.to.tof
              putTextFieldValue, Event, mode_base+'to_tof_micros', value
            ENDIF ELSE BEGIN
              sbin = STRCOMPRESS(bin,/REMOVE_ALL)
              putTextFieldValue, Event,mode_base+'to_tof_bin', sbin
              xmin = getTextFieldValue(Event,mode_base+'from_tof_micros')
              xmax = getTextFieldValue(Event,mode_base+'to_tof_micros')
              tof_fields.to.tof = micros
              success = 1
            ENDELSE
          ENDELSE
        END
        'bin': BEGIN
          bin = getTextFieldValue(Event,mode_base+'to_tof_bin')
          micros = convert_bin_to_micros(Event,bin)
          IF (micros EQ -1) THEN BEGIN ;outside of range
            bin_min = getTextFieldValue(Event,mode_base+'from_tof_bin_help')
            bin_max = getTextFieldValue(Event,mode_base+'to_tof_bin_help')
            text = ['INPUT ERROR',$
              STRCOMPRESS(bin,/REMOVE_ALL) + ' is outside of range',$
              bin_min + ' - ' + bin_max]
            result = DIALOG_MESSAGE(text, $
              /CENTER,$
              DIALOG_PARENT=id,$
              /ERROR)
            value = tof_fields.to.bin
            putTextFieldValue, Event, mode_base+'to_tof_bin', value
          ENDIF ELSE BEGIN
            result = is_from_lower_than_to(Event, MODE=mode, $
            TEST='bin') ;make sure from<to
            IF (result EQ 0b) THEN BEGIN
              text = ['INPUT ERROR',$
                'FROM value is greater or equal to TO value !']
              result = DIALOG_MESSAGE(text, $
                /CENTER, $
                DIALOG_PARENT=id,$
                /ERROR)
              value = tof_fields.to.bin
              putTextFieldValue, Event, mode_base+'to_tof_bin', value
            ENDIF ELSE BEGIN
              smicros = STRCOMPRESS(micros,/REMOVE_ALL)
              putTextFieldValue, Event,mode_base+'to_tof_micros', smicros
              xmin = getTextFieldValue(Event,mode_base+'from_tof_micros')
              xmax = getTextFieldValue(Event,mode_base+'to_tof_micros')
              tof_fields.to.bin = bin
              success = 1
            ENDELSE
          ENDELSE
        END
      ENDCASE
    END
    'width': BEGIN
    END
  ENDCASE
  
  IF (success) THEN BEGIN
    tof_range = (*global).tof_range
    tof_range.min = xmin
    tof_range.max = xmax
    (*global).tof_range = tof_range
    main_event = (*global_tof).main_event
    replot_counts_vs_tof, main_event
    
    CASE (MODE) OF
      1: BEGIN
        mode_base = 'mode1_'
        (*global).tof_fields_mode1 = tof_fields
      END
      2: BEGIN
        mode_base = 'mode2_'
        (*global).tof_fields_mode2 = tof_fields
      END
    ENDCASE
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO populate_range_currently_displayed, Event

  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof
  global = (*global_tof).global
  tof_tof = (*(*global).tof_tof)
  
  from_bin  = getTextFieldValue(Event,'mode2_from_tof_bin')
  bin_width = getTextFieldValue(Event,'tof_bin_size')
  to_bin = from_bin + bin_width
  
  from_tof = tof_tof[from_bin]
  to_tof   = tof_tof[to_bin]
  
  s_from_tof = STRCOMPRESS(from_tof,/REMOVE_ALL)
  s_from_bin = STRCOMPRESS(from_bin,/REMOVE_ALL)
  s_to_tof   = STRCOMPRESS(to_tof,/REMOVE_ALL)
  s_to_bin   = STRCOMPRESS(to_bin,/REMOVE_ALL)
  
  tof_text = s_from_tof + ' - ' + s_to_tof
  bin_text = s_from_bin + ' - ' + s_to_bin
  
  putTextFieldValue, Event, 'tof_range_displayed', tof_text
  putTextFieldValue, Event, 'bin_range_displayed', bin_text
  
END

;------------------------------------------------------------------------------
PRO plot_range_currently_displayed, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global_tof
  global = (*global_tof).global
  main_event = (*global_tof).main_event
  
  counts = (*(*global).tof_counts)
  max_counts = MAX(counts,MIN=min_counts)
  
  id = WIDGET_INFO(main_event.top, FIND_BY_UNAME = 'counts_vs_tof_preview_plot')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  
  tof_range = getTextFieldValue(Event,'tof_range_displayed')
  tof_array = STRSPLIT(tof_range,' - ', /EXTRACT)
  tof_min = tof_array[0]
  tof_max = tof_array[1]
  
  xmin = tof_min
  xmax = tof_max
  
  linestyle = 2
  
  PLOTS, xmin, min_counts, /DATA
  PLOTS, xmin, max_counts, /DATA, /CONTINUE, COLOR=FSC_COLOR('blue'), $
    THICK= 2, LINESTYLE=linestyle
    
  PLOTS, xmax, min_counts, /DATA
  PLOTS, xmax, max_counts, /DATA, /CONTINUE, COLOR=FSC_COLOR('blue'), $
    THICK= 2, LINESTYLE=linestyle
    
  DEVICE, DECOMPOSED=0
  
END

;------------------------------------------------------------------------------
FUNCTION checkPauseStop, Event

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global_tof
  
  ;check pause status
  id_pause = WIDGET_INFO(event.top,find_by_uname='pause_tof_button')
  pause_status = 0b; continue by default to play tof
  IF WIDGET_INFO(id_pause,/valid_id) then begin
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
    ENDIF ELSE BEGIN
      event_id = WIDGET_EVENT(id_pause,/nowait)
      IF (event_id.press EQ 1) THEN BEGIN
        display_play_pause_stop_buttons, EVENT=Event, activate='pause'
        pause_status = 1b
      ENDIF
    ENDELSE
  ENDIF
  
  id_pause = WIDGET_INFO(event.top,find_by_uname='stop_tof_button')
  stop_status = 0b
  IF WIDGET_INFO(id_pause,/valid_id) then begin
    CATCH, error
    IF (error NE 0) THEN BEGIN
      CATCH,/CANCEL
    ENDIF ELSE BEGIN
      event_id = WIDGET_EVENT(id_pause,/nowait)
      IF (event_id.press EQ 1) THEN BEGIN
        display_play_pause_stop_buttons, EVENT=Event, activate='stop'
        stop_status = 1b
      ENDIF
    ENDELSE
  ENDIF
  
  RETURN, [pause_status,stop_status]
  
END

;------------------------------------------------------------------------------
PRO play_tof, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof
  global = (*global_tof).global
  tof_tof = (*(*global).array_of_tof_bins)
  
  ;get nbr of bins per frame
  bin_width = getTextFieldValue(Event,'tof_bin_size')
  ;get time to stay on each frame
  frame_time = getTextFieldValue(Event,'tof_bin_time')
  time_per_frame = FLOAT(frame_time) / 3.
  
  ;starting bin
  starting_bin  = getTextFieldValue(Event,'mode2_from_tof_bin')
  ending_bin    = getTextFieldValue(Event,'mode2_to_tof_bin')
  
  from_bin = starting_bin
  to_bin   = starting_bin + bin_width
  
  WHILE (from_bin LT ending_bin) DO BEGIN
  
    ;tof_range = (*global).tof_range
    ;tof_range.min = tof_tof[from_bin]
    ;tof_range.max = tof_tof[to_bin]
    ;(*global).tof_range = tof_range
    main_event = (*global_tof).main_event
    replot_counts_vs_tof, main_event
    
    s_from_bin = STRCOMPRESS(from_bin,/REMOVE_ALL)
    s_to_bin   = STRCOMPRESS(to_bin,/REMOVE_ALL)
    
    s_from_tof = STRCOMPRESS(tof_tof[from_bin],/REMOVE_ALL)
    s_to_tof   = STRCOMPRESS(tof_tof[to_bin],/REMOVE_ALL)
    
    tof_text = s_from_tof + ' - ' + s_to_tof
    bin_text = s_from_bin + ' - ' + s_to_bin
    
    putTextFieldValue, Event, 'tof_range_displayed', tof_text
    putTextFieldValue, Event, 'bin_range_displayed', bin_text
    
    plot_range_currently_displayed, Event
    display_main_plot_using_tof_input_mode2, Event, from_bin, to_bin
    
    time_index = 0
    while (time_index LT 3) DO BEGIN
      ;check if user click pause or stop
      pause_stop_status = checkPauseStop(event)
      pause_status = pause_stop_status[0]
      stop_status  = pause_stop_status[1]
      IF (pause_status EQ 1) THEN BEGIN
        RETURN
      ENDIF
      
      IF (stop_status) EQ 1 THEN BEGIN
        display_play_pause_stop_buttons, EVENT=Event, activate='stop'
        main_event = (*global_tof).main_event
        replot_counts_vs_tof, main_event
        populate_range_currently_displayed, Event
        plot_range_currently_displayed, Event
        wait, 0.4
        display_play_pause_stop_buttons, EVENT=Event, activate='none'
        RETURN
      ENDIF
      
      WAIT, time_per_frame
      time_index++
      
    ENDWHILE
    
    from_bin = to_bin
    to_bin += bin_width
    
    IF (to_bin GE ending_bin) THEN to_bin = ending_bin
    
  ENDWHILE
  
END

;------------------------------------------------------------------------------
PRO refresh_main_plot_using_tof_input_mode1, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof
  global = (*global_tof).global
  main_event = (*global_tof).main_event
  
  DataArray = (*(*global).DataArray)
  
  ;get from bin
  from_bin = getTextFieldValue(Event,'mode1_from_tof_bin')
  ;get to bin
  to_bin = getTextFieldValue(Event,'mode1_to_tof_bin') - 1
  
  plotStatus = 1 ;by default, plot does work
  plot_error = 0
  CATCH, plot_error
  IF (plot_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN
  ENDIF ELSE BEGIN
  
    DataArray = DataArray[from_bin:to_bin,*,*]
    DataXY = TOTAL(DataArray,1)
    
    tDataXY  = TRANSPOSE(dataXY)
    (*(*global).img) = tDataXY
    ;Check if rebin is necessary or not
    
    x = (size(tDataXY))(1)
    y = (size(tDataXY))(2)
    
    draw_x = (*global).draw_x
    draw_y = (*global).draw_y
    
    rtDataXY = CONGRID(tDataXY, draw_x, draw_y)
    
    congrid_x_coeff = FLOAT(draw_x) / FLOAT(x)
    congrid_y_coeff = FLOAT(draw_y) / FLOAT(y)
    congrid_coeff = MIN([congrid_x_coeff,congrid_y_coeff])
    
    (*global).congrid_x_coeff = congrid_coeff
    (*global).congrid_y_coeff = congrid_coeff
    
    (*(*global).rtDataXY) = rtDataXY ;array plotted
    lin_or_log_plot, main_event
    
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO display_main_plot_using_tof_input_mode2, Event, from_bin, to_bin

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof
  global = (*global_tof).global
  main_event = (*global_tof).main_event
  
  DataArray = (*(*global).DataArray)
  
  plotStatus = 1 ;by default, plot does work
  plot_error = 0
  CATCH, plot_error
  IF (plot_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN
  ENDIF ELSE BEGIN
  
    DataArray = DataArray[from_bin:to_bin,*,*]
    DataXY = TOTAL(DataArray,1)
    
    tDataXY  = TRANSPOSE(dataXY)
    (*(*global).img) = tDataXY
    ;Check if rebin is necessary or not
    
    x = (size(tDataXY))(1)
    y = (size(tDataXY))(2)
    
    draw_x = (*global).draw_x
    draw_y = (*global).draw_y
    
    rtDataXY = CONGRID(tDataXY, draw_x, draw_y)
    
    congrid_x_coeff = FLOAT(draw_x) / FLOAT(x)
    congrid_y_coeff = FLOAT(draw_y) / FLOAT(y)
    congrid_coeff = MIN([congrid_x_coeff,congrid_y_coeff])
    
    (*global).congrid_x_coeff = congrid_coeff
    (*global).congrid_y_coeff = congrid_coeff
    
    (*(*global).rtDataXY) = rtDataXY ;array plotted
    lin_or_log_plot, main_event
    
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO refresh_main_plot_using_tof_input_mode2, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof
  global = (*global_tof).global
  main_event = (*global_tof).main_event
  
  DataArray = (*(*global).DataArray)
  
  ;get from bin
  from_bin = getTextFieldValue(Event,'mode2_from_tof_bin')
  ;get to bin
  to_bin = getTextFieldValue(Event,'mode2_to_tof_bin') - 1
  
  plotStatus = 1 ;by default, plot does work
  plot_error = 0
  CATCH, plot_error
  IF (plot_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN
  ENDIF ELSE BEGIN
  
    DataArray = DataArray[from_bin:to_bin,*,*]
    DataXY = TOTAL(DataArray,1)
    
    tDataXY  = TRANSPOSE(dataXY)
    (*(*global).img) = tDataXY
    ;Check if rebin is necessary or not
    
    x = (size(tDataXY))(1)
    y = (size(tDataXY))(2)
    
    draw_x = (*global).draw_x
    draw_y = (*global).draw_y
    
    rtDataXY = CONGRID(tDataXY, draw_x, draw_y)
    
    congrid_x_coeff = FLOAT(draw_x) / FLOAT(x)
    congrid_y_coeff = FLOAT(draw_y) / FLOAT(y)
    congrid_coeff = MIN([congrid_x_coeff,congrid_y_coeff])
    
    (*global).congrid_x_coeff = congrid_coeff
    (*global).congrid_y_coeff = congrid_coeff
    
    (*(*global).rtDataXY) = rtDataXY ;array plotted
    lin_or_log_plot, main_event
    
  ENDELSE
  
END
