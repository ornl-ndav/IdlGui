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
PRO replot_beam_center_calibration_range, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, leave
  
  draw_uname = 'beam_center_main_draw'
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  DEVICE, DECOMPOSED=1
  
  ;Calibration Range ..........................................................
  tube_min_data = FIX(getTextFieldValue(event,$
    'beam_center_calculation_tube_left'))
  tube_max_data = FIX(getTextFieldValue(Event,$
    'beam_center_calculation_tube_right'))
  pixel_min_data = FIX(getTextFieldValue(Event,$
    'beam_center_calculation_pixel_left'))
  pixel_max_data = FIX(getTextFieldValue(Event,$
    'beam_center_calculation_pixel_right'))
    
  ;adding +1 for max to have the all tube/pixel included in the selection
  x_min = getBeamCenterTubeDevice_from_data(tube_min_data, global)
  x_max = getBeamCenterTubeDevice_from_data(tube_max_data+1, global)
  y_min = getBeamCenterPixelDevice_from_data(pixel_min_data, global)
  y_max = getBeamCenterPixelDevice_from_data(pixel_max_data+1, global)
  
  color = (*global).calibration_range_default_selection.color
  thick = (*global).calibration_range_default_selection.thick
  color = convert_rgb(color)
  
  PLOTS, x_min, y_min, /DEVICE, COLOR=color
  PLOTS, x_min, y_max, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, $
    THICK=thick
  PLOTS, x_max, y_max, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, $
    THICK=thick
  PLOTS, x_max, y_min, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, $
    THICK=thick
  PLOTS, x_min, y_min, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, $
    THICK=thick
    
  leave:
  
  DEVICE, DECOMPOSED=0
  
END

;------------------------------------------------------------------------------
PRO replot_beam_center_beam_stop, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, leave
  
  draw_uname = 'beam_center_main_draw'
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  DEVICE, DECOMPOSED=1
  
  tube_min_data = FIX(getTextFieldValue(Event,$
    'beam_center_beam_stop_tube_left'))
  tube_max_data = FIX(getTextFieldValue(Event,$
    'beam_center_beam_stop_tube_right'))
  pixel_min_data = FIX(getTextFieldValue(Event,$
    'beam_center_beam_stop_pixel_left'))
  pixel_max_data = FIX(getTextFieldValue(Event,$
    'beam_center_beam_stop_pixel_right'))
    
  ;adding +1 for max to have the all tube/pixel included in the selection
  x_min = getBeamCenterTubeDevice_from_data(tube_min_data, global)
  x_max = getBeamCenterTubeDevice_from_data(tube_max_data+1, global)
  y_min = getBeamCenterPixelDevice_from_data(pixel_min_data, global)
  y_max = getBeamCenterPixelDevice_from_data(pixel_max_data+1, global)
  
  color = (*global).beam_stop_default_selection.color
  thick = (*global).beam_stop_default_selection.thick
  color = convert_rgb(color)
  
  PLOTS, x_min, y_min, /DEVICE, COLOR=color
  PLOTS, x_min, y_max, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, $
    THICK=thick
  PLOTS, x_max, y_max, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, $
    THICK=thick
  PLOTS, x_max, y_min, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, $
    THICK=thick
  PLOTS, x_min, y_min, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0, $
    THICK=thick
    
  leave:
  
  DEVICE, DECOMPOSED=0
  
END

;------------------------------------------------------------------------------
PRO replot_calculation_range_cursor, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, leave
  
  draw_uname = 'beam_center_main_draw'
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  DEVICE, DECOMPOSED=1
  
  tube_data = FIX(getTextFieldValue(Event,$
    'beam_center_2d_plot_tube'))
  pixel_data = FIX(getTextFieldValue(Event,$
    'beam_center_2d_plot_pixel'))
    
  tube  = getBeamCenterTubeDevice_from_data(tube_data, global)
  pixel = getBeamCenterPixelDevice_from_data(pixel_data, global)
  
  color = (*global).calculation_range_default.color
  thick = (*global).calculation_range_default.thick
  color = convert_rgb(color)
  
  x_min = 0
  y_min = 0
  x_max = (*global).main_draw_xsize
  y_max = (*global).main_draw_ysize
  
  IF ((*global).calculation_range_tab_mode EQ 'tube1' OR $
    (*global).calculation_range_tab_mode EQ 'tube2') THEN BEGIN
    tube_linestyle = (*global).calculation_range_default.working_linestyle
    pixel_linestyle = (*global).calculation_range_default.not_working_linestyle
  ENDIF ELSE BEGIN
    tube_linestyle = (*global).calculation_range_default.not_working_linestyle
    pixel_linestyle = (*global).calculation_range_default.working_linestyle
  ENDELSE
  
  PLOTS, 0, pixel, /DEVICE, COLOR=color
  PLOTS, x_max, pixel, /DEVICE, COLOR=color, /CONTINUE, $
    LINESTYLE=pixel_linestyle, $
    THICK=thick
    
  PLOTS, tube, 0, /DEVICE, COLOR=color
  PLOTS, tube, y_max, /DEVICE, COLOR=color, /CONTINUE, $
    LINESTYLE=tube_linestyle, $
    THICK=thick
    
  leave:
  
  DEVICE, DECOMPOSED=0
  
END

;------------------------------------------------------------------------------
PRO calculation_range_manual_input, Event
  valid_input = cleanup_calculation_range_input(Event)
  IF (valid_input) THEN BEGIN
    plot_beam_center_background, Event
    replot_beam_center_calibration_range, Event
    replot_beam_center_beam_stop, Event
    replot_calculation_range_cursor, Event
  ENDIF
END

;------------------------------------------------------------------------------
PRO twoD_plot_range_manual_input, Event
  valid_input = cleanup_twoD_plot_range_input(Event)
  IF (valid_input) THEN BEGIN
    plot_beam_center_background, Event
    replot_beam_center_calibration_range, Event
    replot_beam_center_beam_stop, Event
    replot_calculation_range_cursor, Event
  ENDIF
END

;------------------------------------------------------------------------------
PRO display_counts_vs_pixel_and_tube_live, Event, ERASE=erase

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, leave
  
  IF (N_ELEMENTS(erase) EQ 0) THEN BEGIN
    data = (*(*global).tt_zoom_data)
    min_tube_plotted = (*global).min_tube_plotted
    min_pixel_plotted = (*global).min_pixel_plotted
    max_tube_plotted = (*global).max_tube_plotted
    max_pixel_plotted = (*global).max_pixel_plotted
    
    smooth_parameter = FIX(getTextFieldValue(Event, $
      'beam_center_smooth_parameter'))
      
    tube_selected = FIX(getTextFieldValue(Event,'beam_center_2d_plot_tube'))
    pixel_selected = FIX(getTextFieldValue(Event,'beam_center_2d_plot_pixel'))
    
    IF (tube_selected EQ (max_tube_plotted+1)) THEN RETURN
    iF (pixel_selected EQ (max_pixel_plotted + 1)) THEN RETURN
    
    ;remove beam stop region from plot
    bs_tube_left = getTextFieldValue(Event,$
      'beam_center_beam_stop_tube_left')
    bs_tube_right = getTextFieldValue(Event,$
      'beam_center_beam_stop_tube_right')
    bs_pixel_left = getTextFieldValue(Event,$
      'beam_center_beam_stop_pixel_left')
    bs_pixel_right = getTextFieldValue(Event,$
      'beam_center_beam_stop_pixel_right')
      
    i_bs_TL = FIX(bs_tube_left)
    i_bs_TR = FIX(bs_tube_right)
    i_bs_PL = FIX(bs_pixel_left)
    i_bs_PR = FIX(bs_pixel_right)
    
    tube_left_offset = i_bs_TL - min_tube_plotted
    tube_right_offset = i_bs_TR - min_tube_plotted
    pixel_left_offset = i_bs_PL - min_pixel_plotted
    pixel_right_offset = i_bs_PR - min_pixel_plotted
    
    x_min = MIN([tube_left_offset,tube_right_offset],MAX=x_max)
    y_min = MIN([pixel_left_offset,pixel_right_offset],MAX=y_max)
    data[x_min:x_max,y_min:y_max] = 0
    
    pixel_data  = data[tube_selected - min_tube_plotted,*]
    tube_data = data[*, pixel_selected - min_pixel_plotted]
    
    ;plot counts vs tube
    draw_uname = 'beam_center_calculation_counts_vs_tube_draw'
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    title = 'Counts vs tube for pixel ' + $
      STRCOMPRESS(pixel_selected,/REMOVE_ALL)
    xtitle = 'Tube'
    ytitle = 'Counts'
    xrange = INDGEN(N_ELEMENTS(tube_data)) + min_tube_plotted
    PLOT, xrange, tube_data, TITLE=title, YTITLE=ytitle, XTITLE=xtitle, $
      XSTYLE=1, PSYM=-1
      
    new_array = smooth(tube_data, smooth_parameter)
    OPLOT, xrange, new_array, color=FSC_COLOR('red')
    
    ;plot the cursor at the pixel position
    PLOTS, tube_selected, tube_data[tube_selected - min_tube_plotted], $
      PSYM = 6, COLOR = FSC_COLOR('green'), /DATA, THICK=3
      
    ;plot counts vs pixel
    draw_uname = 'beam_center_calculation_counts_vs_pixel_draw'
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    title = 'Counts vs pixel for tube ' + $
      STRCOMPRESS(tube_selected,/REMOVE_ALL)
    xtitle = 'Pixel'
    ytitle = 'Counts'
    xrange = INDGEN(N_ELEMENTS(pixel_data)) + min_pixel_plotted
    PLOT, xrange, pixel_data, TITLE=title, XTITLE=xtitle, YTITLE=ytitle, $
      XSTYLE=1, PSYM=-1
      
    new_array = smooth(pixel_data, smooth_parameter)
    OPLOT, xrange, new_array, color=FSC_COLOR('red')
    
    ;plot the cursor at the tube position
    PLOTS, pixel_selected, pixel_data[pixel_selected - min_pixel_plotted], $
      PSYM = 6, COLOR = FSC_COLOR('green'), /DATA, THICK=3
      
  ENDIF ELSE BEGIN
  
    ;plot counts vs tube
    draw_uname = 'beam_center_calculation_counts_vs_tube_draw'
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    ERASE
    
    ;plot counts vs pixel
    draw_uname = 'beam_center_calculation_counts_vs_pixel_draw'
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    ERASE
    
  ENDELSE
  
  leave:
  
END

;------------------------------------------------------------------------------
PRO plot_live_cursor, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, leave
  
  draw_uname = 'beam_center_main_draw'
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  DEVICE, DECOMPOSED=1
  
  tube_data = FIX(getTextFieldValue(Event,$
    'beam_center_cursor_live_tube_value'))
  pixel_data = FIX(getTextFieldValue(Event,$
    'beam_center_cursor_live_pixel_value'))
    
  tube  = getBeamCenterTubeDevice_from_data(tube_data, global)
  pixel = getBeamCenterPixelDevice_from_data(pixel_data, global)
  
  color = (*global).calculation_range_default.color
  thick = (*global).calculation_range_default.thick
  color = convert_rgb(color)
  
  x_min = 0
  y_min = 0
  x_max = (*global).main_draw_xsize
  y_max = (*global).main_draw_ysize
  
  tube_linestyle = (*global).calculation_range_default.not_working_linestyle
  pixel_linestyle = (*global).calculation_range_default.not_working_linestyle
  
  PLOTS, 0, pixel, /DEVICE, COLOR=color
  PLOTS, x_max, pixel, /DEVICE, COLOR=color, /CONTINUE, $
    LINESTYLE=pixel_linestyle, $
    THICK=thick
    
  PLOTS, tube, 0, /DEVICE, COLOR=color
  PLOTS, tube, y_max, /DEVICE, COLOR=color, /CONTINUE, $
    LINESTYLE=tube_linestyle, $
    THICK=thick
    
  leave:
  
  DEVICE, DECOMPOSED=0
  
END

;------------------------------------------------------------------------------
PRO plot_saved_live_cursor, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, leave
  
  draw_uname = 'beam_center_main_draw'
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  DEVICE, DECOMPOSED=1
  
  tube_data = FIX(getTextFieldValue(Event,$
    'beam_center_cursor_info_tube_value'))
  pixel_data = FIX(getTextFieldValue(Event,$
    'beam_center_cursor_info_pixel_value'))
    
  tube  = getBeamCenterTubeDevice_from_data(tube_data, global)
  pixel = getBeamCenterPixelDevice_from_data(pixel_data, global)
  
  color = (*global).cursor_save_position.color
  thick = (*global).cursor_save_position.thick
  color = FSC_COLOR(color)
  
  x_min = 0
  y_min = 0
  x_max = (*global).main_draw_xsize
  y_max = (*global).main_draw_ysize
  
  PLOTS, 0, pixel, /DEVICE, COLOR=color
  PLOTS, x_max, pixel, /DEVICE, COLOR=color, /CONTINUE, $
    LINESTYLE=pixel_linestyle, $
    THICK=thick
    
  PLOTS, tube, 0, /DEVICE, COLOR=color
  PLOTS, tube, y_max, /DEVICE, COLOR=color, /CONTINUE, $
    LINESTYLE=tube_linestyle, $
    THICK=thick
    
  ;plot counts vs tof of saved cursor position
  plot_counts_vs_tof_of_saved_live_cursor, Event
  
  leave:
  
  DEVICE, DECOMPOSED=0
  
END

;------------------------------------------------------------------------------
PRO plot_counts_vs_tof_of_saved_live_cursor, Event, ERASE=erase

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, leave
  
  IF (N_ELEMENTS(erase) EQ 0) THEN BEGIN
    data = (*(*global).tt_zoom_data)
    min_tube_plotted = (*global).min_tube_plotted
    min_pixel_plotted = (*global).min_pixel_plotted
    max_tube_plotted = (*global).max_tube_plotted
    max_pixel_plotted = (*global).max_pixel_plotted
    
    smooth_parameter = FIX(getTextFieldValue(Event, $
      'beam_center_smooth_parameter'))
      
    tube_data = FIX(getTextFieldValue(Event,$
      'beam_center_cursor_info_tube_value'))
    pixel_data = FIX(getTextFieldValue(Event,$
      'beam_center_cursor_info_pixel_value'))
      
    tube_selected = FIX(tube_data)
    pixel_selected = FIX(pixel_data)
    
    IF (tube_selected EQ (max_tube_plotted+1)) THEN RETURN
    iF (pixel_selected EQ (max_pixel_plotted + 1)) THEN RETURN
    
    ;remove beam stop region from plot
    bs_tube_left = getTextFieldValue(Event,$
      'beam_center_beam_stop_tube_left')
    bs_tube_right = getTextFieldValue(Event,$
      'beam_center_beam_stop_tube_right')
    bs_pixel_left = getTextFieldValue(Event,$
      'beam_center_beam_stop_pixel_left')
    bs_pixel_right = getTextFieldValue(Event,$
      'beam_center_beam_stop_pixel_right')
      
    i_bs_TL = FIX(bs_tube_left)
    i_bs_TR = FIX(bs_tube_right)
    i_bs_PL = FIX(bs_pixel_left)
    i_bs_PR = FIX(bs_pixel_right)
    
    tube_left_offset = i_bs_TL - min_tube_plotted
    tube_right_offset = i_bs_TR - min_tube_plotted
    pixel_left_offset = i_bs_PL - min_pixel_plotted
    pixel_right_offset = i_bs_PR - min_pixel_plotted
    
    x_min = MIN([tube_left_offset,tube_right_offset],MAX=x_max)
    y_min = MIN([pixel_left_offset,pixel_right_offset],MAX=y_max)
    data[x_min:x_max,y_min:y_max] = 0
    
    pixel_data  = data[tube_selected - min_tube_plotted,*]
    tube_data = data[*, pixel_selected - min_pixel_plotted]
    
    ;plot counts vs tube
    draw_uname = 'beam_center_calculation_counts_vs_tube_draw'
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    title = 'Counts vs tube for pixel ' + $
      STRCOMPRESS(pixel_selected,/REMOVE_ALL)
    xtitle = 'Tube'
    ytitle = 'Counts'
    xrange = INDGEN(N_ELEMENTS(tube_data)) + min_tube_plotted
    PLOT, xrange, tube_data, TITLE=title, YTITLE=ytitle, XTITLE=xtitle, $
      XSTYLE=1, PSYM=-1
      
    new_array = smooth(tube_data, smooth_parameter)
    OPLOT, xrange, new_array, color=FSC_COLOR('red')
    
    ;plot the cursor at the pixel position
    PLOTS, tube_selected, tube_data[tube_selected - min_tube_plotted], $
      PSYM = 6, COLOR = FSC_COLOR('green'), /DATA, THICK=3
      
    ;plot counts vs pixel
    draw_uname = 'beam_center_calculation_counts_vs_pixel_draw'
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    title = 'Counts vs pixel for tube ' + $
      STRCOMPRESS(tube_selected,/REMOVE_ALL)
    xtitle = 'Pixel'
    ytitle = 'Counts'
    xrange = INDGEN(N_ELEMENTS(pixel_data)) + min_pixel_plotted
    PLOT, xrange, pixel_data, TITLE=title, XTITLE=xtitle, YTITLE=ytitle, $
      XSTYLE=1, PSYM=-1
      
    new_array = smooth(pixel_data, smooth_parameter)
    OPLOT, xrange, new_array, color=FSC_COLOR('red')
    
    ;plot the cursor at the tube position
    PLOTS, pixel_selected, pixel_data[pixel_selected - min_pixel_plotted], $
      PSYM = 6, COLOR = FSC_COLOR('green'), /DATA, THICK=3
      
  ENDIF ELSE BEGIN
  
    ;plot counts vs tube
    draw_uname = 'beam_center_calculation_counts_vs_tube_draw'
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    ERASE
    
    ;plot counts vs pixel
    draw_uname = 'beam_center_calculation_counts_vs_pixel_draw'
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    ERASE
    
  ENDELSE
  
  leave:
  
END