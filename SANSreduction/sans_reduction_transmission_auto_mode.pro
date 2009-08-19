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

PRO launch_transmission_auto_mode_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  CASE Event.id OF
  
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_auto_ok_button'): BEGIN
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='transmission_auto_mode_base')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    WIDGET_INFO(event.top, find_By_uname='auto_transmission_draw'): BEGIN
      print, 'event.x: ' + string(event.x)
      print, 'evnet.y: ' + string(event.y)
      print
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO plot_trans_manual_step1_central_selection, wBase

  ;get global structure
  WIDGET_CONTROL,wBase,GET_UVALUE=global
  
  x0y0x1y1 = (*global).x0y0x1y1
  
  x0 = x0y0x1y1[0]
  y0 = x0y0x1y1[1]
  x1 = x0y0x1y1[2]
  y1 = x0y0x1y1[3]
  
  color = 175
  
  id = WIDGET_INFO(wBase,FIND_BY_UNAME='auto_transmission_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  PLOTS, x0, y0, /DEVICE, COLOR=color, THICK=2
  PLOTS, x0, y1, /DEVICE, COLOR=color, THICK=2, /CONTINUE
  PLOTS, x1, y1, /DEVICE, COLOR=color, THICK=2, /CONTINUE
  PLOTS, x1, y0, /DEVICE, COLOR=color, THICK=2, /CONTINUE
  PLOTS, x0, y0, /DEVICE, COLOR=color, THICK=2, /CONTINUE
  
END

;------------------------------------------------------------------------------
PRO plot_auto_data_around_beam_stop, EVENT=event, $
    MAIN_BASE=wBase, $
    global, $
    global_step1
    
  both_banks = (*(*global).both_banks)
  zoom_data = both_banks[*,112:151,80:111]
  
  t_zoom_data = TOTAL(zoom_data,1)
  tt_zoom_data = TRANSPOSE(t_zoom_data)
  (*(*global_step1).tt_zoom_data) = tt_zoom_data
  rtt_zoom_data = CONGRID(tt_zoom_data, 350, 300)
  (*(*global_step1).rtt_zoom_data) = rtt_zoom_data
  
  id = WIDGET_INFO(wBase,FIND_BY_UNAME='auto_transmission_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TVSCL, rtt_zoom_data
  
END


;------------------------------------------------------------------------------
PRO transmission_auto_mode_gui, wBase, main_base_geometry, sys_color_window_bk

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 950 ;width of various steps of manual mode
  ysize = 900 ;height of various steps of manual mode
  
  xoffset = main_base_xoffset + main_base_xsize/2-xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2-ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Automatic Transmission Calculation', $
    UNAME        = 'transmission_auto_mode_base',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup)
    
  base = design_transmission_auto_mode(wBase)
  
  WIDGET_CONTROL, wBase, /REALIZE
  
  plot_transmission_auto_scale, base, sys_color_window_bk
  
END

;-----------------------------------------------------------------------------
PRO display_selection_info_values, wBase, global_auto

  tube_pixel_edges = (*global_auto).tube_pixel_edges
  
  tube1 = STRCOMPRESS(tube_pixel_edges[0],/REMOVE_ALL)
  tube2 = STRCOMPRESS(tube_pixel_edges[2],/REMOVE_ALL)
  pixel1 = STRCOMPRESS(tube_pixel_edges[1],/REMOVE_ALL)
  pixel2 = STRCOMPRESS(tube_pixel_edges[3],/REMOVE_ALL)
  
  putTextFieldValueMainBase, wBase, uname='trans_auto_x0', tube1
  putTextFieldValueMainBase, wBase, uname='trans_auto_y0', pixel1
  putTextFieldValueMainBase, wBase, uname='trans_auto_x1', tube2
  putTextFieldValueMainBase, wBase, uname='trans_auto_y1', pixel2
  
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
PRO plot_trans_auto_counts_vs_x_and_y, wBase, global

  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH, /CANCEL
    RETURN
  ENDIF
  
  tube_pixel_edges = (*global).tube_pixel_edges
  tube1 = tube_pixel_edges[0]
  tube2 = tube_pixel_edges[2]
  pixel1 = tube_pixel_edges[1]
  pixel2 = tube_pixel_edges[3]
  
  xoffset = (*global).xoffset_plot
  yoffset = (*global).yoffset_plot
  
  tube1_offset = FIX(tube1) - xoffset
  tube2_offset = FIX(tube2) - xoffset
  pixel1_offset = FIX(pixel1) - yoffset
  pixel2_offset = FIX(pixel2) - yoffset
  
  tube_min = MIN([tube1_offset,tube2_offset],MAX=tube_max)
  pixel_min = MIN([pixel1_offset, pixel2_offset],MAX=pixel_max)
  (*global).tube_pixel_min_max = [tube_min, tube_max, pixel_min, pixel_max]
  
  tt_zoom_data = (*(*global).tt_zoom_data)
  counts_vs_xy = tt_zoom_data[tube_min:tube_max,pixel_min:pixel_max]
  (*(*global).counts_vs_xy) = counts_vs_xy
  counts_vs_x = TOTAL(counts_vs_xy,2)
  counts_vs_y = TOTAL(counts_vs_xy,1)
  (*(*global).counts_vs_x) = counts_vs_x
  (*(*global).counts_vs_y) = counts_vs_y
  
  ;plot data
  ;Counts vs tube (integrated over y)
  x_axis = INDGEN(N_ELEMENTS(counts_vs_x)) + tube_min + xoffset
  (*(*global).tube_x_axis) = x_axis
  id = WIDGET_INFO(wBase,FIND_BY_UNAME='trans_auto_step1_counts_vs_x')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  plot, x_axis, counts_vs_x, XSTYLE=1, XTITLE='Tube #', YTITLE='Counts', $
    TITLE = 'Counts vs tube integrated over pixel', $
    XTICKS = N_ELEMENTS(x_axis)-1, $
    PSYM = -1
    
  ;Counts vs tube (integrated over x)
  x_axis = INDGEN(N_ELEMENTS(counts_vs_y)) + pixel_min + yoffset
  (*(*global).pixel_x_axis) = x_axis
  id = WIDGET_INFO(wBase,FIND_BY_UNAME='trans_auto_step1_counts_vs_y')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  plot, x_axis, counts_vs_y, XSTYLE=1, XTITLE='Pixel #', YTITLE='Counts', $
    TITLE = 'Counts vs pixel integrated over tube', $
    XTICKS = N_ELEMENTS(x_axis)-1, $
    PSYM = -1
    
END

;------------------------------------------------------------------------------
PRO trans_auto_calculate_background, wBase

  ;get global structure
  WIDGET_CONTROL,wBase,GET_UVALUE=global
  
  counts_vs_xy = (*(*global).counts_vs_xy)  ;DBLARR(tube,pixel)
  
  tube_pixel_edges = (*global).tube_pixel_edges
  tube_min = tube_pixel_edges[0]
  tube_max = tube_pixel_edges[2]
  pixel_min = tube_pixel_edges[1]
  pixel_max = tube_pixel_edges[3]
  
  tube_min_offset = 0
  pixel_min_offset = 0
  
  nbr_tube = (size(counts_vs_xy))(1)
  nbr_pixel = (size(counts_vs_xy))(2)
  
  user_counts_vs_xy = counts_vs_xy
  nbr_pixels = N_ELEMENTS(user_counts_vs_xy)
  
  nbr_iterations = (*global).nbr_iteration
  average = FLTARR(nbr_iterations)
  
  array = user_counts_vs_xy
  (*(*global).user_counts_vs_xy) = array
  index = 0
  WHILE (index LT nbr_iterations) DO BEGIN
    IF (index NE 0) THEN BEGIN
      array_list = WHERE(array LE average[index-1],counts)
      IF (counts GT 0) THEN BEGIN
        new_array = array[array_list]
      ENDIF
      average_value = MEAN(new_array)
    ENDIF ELSE BEGIN
      average_value = MEAN(array)
    ENDELSE
    average[index] = average_value
    index++
  ENDWHILE
  
  DEVICE, decomposed = 0
  
  new_nbr_tube = (size(user_counts_vs_xy))(1)
  new_nbr_pixel = (size(user_counts_vs_xy))(2)
  
  xaxis = INDGEN(new_nbr_tube) + tube_min
  yaxis = INDGEN(new_nbr_pixel) + pixel_min
  
  trans_manual_step2 = (*global).trans_manual_step2
  trans_manual_step2.user_counts_vs_xy = PTR_NEW(user_counts_vs_xy)
  trans_manual_step2.xaxis = PTR_NEW(xaxis)
  trans_manual_step2.yaxis = PTR_NEW(yaxis)
  trans_manual_step2.average_value = average_value
  (*global).trans_manual_step2 = trans_manual_step2
  
  background = FIX(average_value)
  s_background = STRCOMPRESS(background,/REMOVE_ALL)
  
  putTextFieldValueMainBase, wBase, UNAME='trans_auto_back_value', s_background
  (*global).trans_auto_background = background
  
END

;------------------------------------------------------------------------------
PRO calculate_trans_auto_transmission_intensity, wBase

  ;get global structure
  WIDGET_CONTROL,wBase,GET_UVALUE=global
  
  background_value = (*global).trans_auto_background
  counts_vs_xy     = (*(*global).counts_vs_xy)
  
  ;get pixel min, pixel max, tube min and tube max selected by user
  tube_pixel_edges = (*global).tube_pixel_edges
  tube_min = tube_pixel_edges[0]
  tube_max = tube_pixel_edges[2]
  pixel_min = tube_pixel_edges[1]
  pixel_max = tube_pixel_edges[3]
  
  nbr_tube = (size(counts_vs_xy))(1)
  nbr_pixel = (size(counts_vs_xy))(2)
  
  array = counts_vs_xy
  
  ;  get_transmission_peak_tube_pixel_value, Event, $
  ;    array, $
  ;    background_value, $
  ;    tube_min, $
  ;    pixel_min
  
  array_list = WHERE(array GT background_value)
  array_peak = array[array_list]
  transmission_intensity = TOTAL(array_peak)
  (*global).trans_auto_transmission_intensity = transmission_intensity
  putTextFieldValueMainBase, wBase, uname='trans_auto_trans_value', $
    STRCOMPRESS(transmission_intensity,/REMOVE_ALL)
    
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
PRO launch_transmission_auto_mode_base, main_event

  id = WIDGET_INFO(main_event.top, FIND_BY_UNAME='MAIN_BASE')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  ;get global structure
  WIDGET_CONTROL,main_event.top,GET_UVALUE=global
  
  ;build gui
  wBase = ''
  sys_color_window_bk = 0
  transmission_auto_mode_gui, wBase, $
    main_base_geometry, sys_color_window_bk
    
  global_auto = PTR_NEW({ wbase: wbase,$
    global: global,$
    rtt_zoom_data: PTR_NEW(0L), $
    tt_zoom_data: PTR_NEW(0L), $
    x0y0x1y1: [127,83,214,153],$
    tube_pixel_edges: [91,123,99,133],$
    nbr_iteration: 2,$
    trans_auto_background: 0L, $
    trans_auto_transmission_intensity: 0L, $
    
    background: PTR_NEW(0L), $
    counts_vs_x: PTR_NEW(0L), $
    counts_vs_y: PTR_NEW(0L), $
    pixel_x_axis: PTR_NEW(0L), $
    tube_x_axis: PTR_NEW(0L), $
    counts_vs_xy: PTR_NEW(0L), $
    
    left_button_clicked: 0, $
    sys_color_window_bk: sys_color_window_bk, $
    working_with_xy: 0, $ ;step1
    trans_manual_step2_ymin_device: 40,$
    trans_manual_step2_ymax_device: 390,$
    trans_manual_step2_xmin_device: 61, $
    trans_manual_step2_xmax_device: 523, $
    
    trans_manual_step2: { user_counts_vs_xy: PTR_NEW(0L), $
    xaxis: PTR_NEW(0L), $
    yaxis: PTR_NEW(0L), $
    average_value: 0. }, $
    trans_manual_3dview_status: 'disable', $
    
    selection_not_working_color: 'deep pink', $
    selection_working_color: 'red', $
    
    trans_manual_step2_top_plot_ymin_data: 0L,$
    trans_manual_step2_top_plot_ymax_data: 0L,$
    trans_manual_step2_top_plot_xmin_data: 0L,$
    trans_manual_step2_top_plot_xmax_data: 0L,$
    
    trans_manual_step2_bottom_plot_ymin_data: 0L,$
    trans_manual_step2_bottom_plot_ymax_data: 0L,$
    trans_manual_step2_bottom_plot_xmin_data: 0L,$
    trans_manual_step2_bottom_plot_xmax_data: 0L, $
    
    need_to_reset_trans_step2: 1, $ ;will go to 1 everytime the selection of step1 changes
    
    trans_peak_tube: PTR_NEW(0L), $
    trans_peak_pixel: PTR_NEW(0L), $
    
    top_plot_background_with_right_tube: PTR_NEW(0L),$
    top_plot_background_with_left_tube: PTR_NEW(0L),$
    bottom_plot_background_with_right_pixel: PTR_NEW(0L),$
    bottom_plot_background_with_left_pixel: PTR_NEW(0L),$
    ;    bottom_plot_background: PTR_NEW(0L),$
    step2_tube_right: 0., $
    step2_tube_left: 0., $
    step2_pixel_left: 0., $
    step2_pixel_right: 0., $
    user_counts_vs_xy: PTR_NEW(0L),$
    
    working_with_tube: 1 ,$ ;step2 left or right
    working_with_pixel: 1, $ ;step2 bottom (1) or top (2) pixel
    tube_pixel_min_max: INTARR(4),$
    xoffset_plot: 80L,$
    yoffset_plot: 112L, $
    
    ;step3
    both_banks: (*(*global).both_banks), $
    step3_3d_data: PTR_NEW(0L), $
    step3_tt_zoom_data: PTR_NEW(0L), $
    step3_rtt_zoom_data: PTR_NEW(0L), $
    step3_xoffset_plot: 84L,$
    step3_yoffset_plot: 116L, $
    step3_counts_vs_x: PTR_NEW(0L), $
    step3_counts_vs_y: PTR_NEW(0L), $
    step3_tube_min: 0, $
    step3_tube_max: 0, $
    step3_pixel_min: 0, $
    step3_pixel_max: 0, $
    step3_background: PTR_NEW(0L), $
    trans_manual_step3_refresh: 1, $
    
    tof_array: PTR_NEW(0L), $
    transmission_peak_value: PTR_NEW(0L), $
    transmission_peak_error_value: PTR_NEW(0L), $
    transmission_lambda_axis: PTR_NEW(0L), $
    
    beam_center_bank_tube_pixel: INTARR(3), $
    
    main_event: main_event})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global_auto
  XMANAGER, "launch_transmission_auto_mode", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
  plot_auto_data_around_beam_stop, main_base=wBase, global, global_auto
  
  plot_trans_manual_step1_central_selection, wBase
  
  display_selection_info_values, wBase, global_auto
  
  plot_trans_auto_counts_vs_x_and_y, wBase, global_auto
  
  trans_auto_calculate_background, wBase
  
  calculate_trans_auto_transmission_intensity, wBase
  
  ;get TOF array
  tof_array = getTOFarray(Event, (*global).data_nexus_file_name)
  (*(*global_auto).tof_array) = tof_array
  
END

