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
  main_global = (*global).global
  
  CASE Event.id OF
  
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_auto_cancel_button'): BEGIN
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='transmission_auto_mode_base')
      WIDGET_CONTROL, id, /DESTROY
    END
    
    ;refresh button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_auto_refresh_button'): BEGIN
      plot_auto_data_around_beam_stop, EVENT=event, main_global, global
      plot_trans_auto_central_selection, Event=event
      display_selection_info_values, Event=event, global
      plot_trans_auto_counts_vs_x_and_y, Event=event, global
      trans_auto_calculate_background, Event=event
      calculate_trans_auto_transmission_intensity, Event=event
      display_beam_center_pixel, Event=event
      display_beam_center_pixel, Event=event
      output_trans_file_from_base, Event=event
      plot_transmission_file, Event=event
    END
    
    ;switch to manual mode
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='trans_auto_go_to_manual_button'): BEGIN
      switch_to_manual_mode, Event
    END
    
    ;OK button
    WIDGET_INFO(Event.top, FIND_BY_UNAME='trans_auto_ok_button'): BEGIN
      id = WIDGET_INFO(Event.top, $
        FIND_BY_UNAME='transmission_auto_mode_base')
      WIDGET_CONTROL, id, /DESTROY
      main_event  = (*global).main_event
      output_file_name = (*global).output_file_name
      putTextFieldValue, main_event, $
        'sample_data_transmission_file_name_text_field', output_file_name
    END
    
    ELSE:
    
  ENDCASE
  
END

;------------------------------------------------------------------------------
PRO switch_to_manual_mode, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  main_event = (*global).main_event
  launch_transmission_manual_mode_base, main_event
  
  id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='transmission_auto_mode_base')
  WIDGET_CONTROL, id, /DESTROY
  
END

;------------------------------------------------------------------------------
PRO plot_trans_auto_central_selection, wbase=wBase, Event=event

  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    WIDGET_CONTROL,wBase,GET_UVALUE=global
    id = WIDGET_INFO(wBase,FIND_BY_UNAME='auto_transmission_draw')
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='auto_transmission_draw')
  ENDELSE
  
  x0y0x1y1 = (*global).x0y0x1y1
  
  x0 = x0y0x1y1[0]
  y0 = x0y0x1y1[1]
  x1 = x0y0x1y1[2]
  y1 = x0y0x1y1[3]
  
  color = 175
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
  
  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    id = WIDGET_INFO(wBase,FIND_BY_UNAME='auto_transmission_draw')
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='auto_transmission_draw')
  ENDELSE
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
PRO display_selection_info_values, wBase=wBase, Event=event, global_auto

  tube_pixel_edges = (*global_auto).tube_pixel_edges
  
  tube1 = STRCOMPRESS(tube_pixel_edges[0],/REMOVE_ALL)
  tube2 = STRCOMPRESS(tube_pixel_edges[2],/REMOVE_ALL)
  pixel1 = STRCOMPRESS(tube_pixel_edges[1],/REMOVE_ALL)
  pixel2 = STRCOMPRESS(tube_pixel_edges[3],/REMOVE_ALL)
  
  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    putTextFieldValueMainBase, wBase, uname='trans_auto_x0', tube1
    putTextFieldValueMainBase, wBase, uname='trans_auto_y0', pixel1
    putTextFieldValueMainBase, wBase, uname='trans_auto_x1', tube2
    putTextFieldValueMainBase, wBase, uname='trans_auto_y1', pixel2
  ENDIF ELSE BEGIN
    putTextFieldValue, Event, 'trans_auto_x0', tube1
    putTextFieldValue, event, 'trans_auto_y0', pixel1
    putTextFieldValue, event, 'trans_auto_x1', tube2
    putTextFieldValue, event, 'trans_auto_y1', pixel2
  ENDELSE
  
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
PRO plot_trans_auto_counts_vs_x_and_y, wBase=wbase, Event=event, global

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
  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    id = WIDGET_INFO(wBase,FIND_BY_UNAME='trans_auto_step1_counts_vs_x')
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_auto_step1_counts_vs_x')
  ENDELSE
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  plot, x_axis, counts_vs_x, XSTYLE=1, XTITLE='Tube #', YTITLE='Counts', $
    TITLE = 'Counts vs tube integrated over pixel', $
    XTICKS = N_ELEMENTS(x_axis)-1, $
    PSYM = -1
    
  ;Counts vs tube (integrated over x)
  x_axis = INDGEN(N_ELEMENTS(counts_vs_y)) + pixel_min + yoffset
  (*(*global).pixel_x_axis) = x_axis
  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    id = WIDGET_INFO(wBase,FIND_BY_UNAME='trans_auto_step1_counts_vs_y')
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_auto_step1_counts_vs_y')
  ENDELSE
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  plot, x_axis, counts_vs_y, XSTYLE=1, XTITLE='Pixel #', YTITLE='Counts', $
    TITLE = 'Counts vs pixel integrated over tube', $
    XTICKS = N_ELEMENTS(x_axis)-1, $
    PSYM = -1
    
END

;------------------------------------------------------------------------------
PRO trans_auto_calculate_background, wBase=wBase, Event=event

  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    WIDGET_CONTROL,wBase,GET_UVALUE=global
  ENDIF ELSE BEGIN
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDELSE
  
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
  
  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    putTextFieldValueMainBase, wBase, UNAME='trans_auto_back_value', s_background
  ENDIF ELSE BEGIN
    putTextFieldValue, Event, 'trans_auto_back_value', s_background
  ENDELSE
  (*global).trans_auto_background = background
  
END

;------------------------------------------------------------------------------
PRO calculate_trans_auto_transmission_intensity, wBase=wBase, Event=event

  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    WIDGET_CONTROL,wBase,GET_UVALUE=global
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ENDELSE
  
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
  
  get_transmission_auto_peak_tube_pixel_value, wBase=wBase, $
    Event=event, $
    array, $
    background_value, $
    tube_min, $
    pixel_min
    
  array_list = WHERE(array GT background_value)
  array_peak = array[array_list]
  transmission_intensity = TOTAL(array_peak)
  (*global).trans_auto_transmission_intensity = transmission_intensity
  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    putTextFieldValueMainBase, wBase, uname='trans_auto_trans_value', $
      STRCOMPRESS(transmission_intensity,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    putTextFieldValue, Event, 'trans_auto_trans_value', $
      STRCOMPRESS(transmission_intensity,/REMOVE_ALL)
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO get_transmission_auto_peak_tube_pixel_value, wBase=wBase, $
    Event=event, $
    array, $
    background_value, $
    tube_min_offset, $
    pixel_min_offset
    
  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    WIDGET_CONTROL,wBase,GET_UVALUE=global
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ENDELSE
  
  nbr_tube = (size(array))(1)
  nbr_pixel = (size(array))(2)
  
  trans_peak_tube = ['']
  trans_peak_pixel = ['']
  
  FOR tube=0,nbr_tube-1 DO BEGIN
    FOR pixel=0, nbr_pixel-1 DO BEGIN
      IF (array[tube,pixel] GT background_value) THEN BEGIN
        trans_peak_tube = [trans_peak_tube,tube]
        trans_peak_pixel = [trans_peak_pixel,pixel]
      ENDIF
    ENDFOR
  ENDFOR
  
  ;remove first element
  trans_peak_tube = trans_peak_tube[1:N_ELEMENTS(trans_peak_tube)-1]
  trans_peak_pixel = trans_peak_pixel[1:N_ELEMENTS(trans_peak_pixel)-1]
  
  (*(*global).trans_peak_tube) = trans_peak_tube + tube_min_offset
  (*(*global).trans_peak_pixel) = trans_peak_pixel + pixel_min_offset
  
END

;------------------------------------------------------------------------------
PRO create_auto_trans_array, wBase=wBase, Event=event

  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    WIDGET_CONTROL,wBase,GET_UVALUE=global
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ENDELSE
  main_global = (*global).global
  
  bank_tube_pixel = (*global).beam_center_bank_tube_pixel
  bank = bank_tube_pixel[0]
  tube = bank_tube_pixel[1]
  pixel = bank_tube_pixel[2]
  ;print, format='("bank: ",i4,", tube: ",i4,", pixel: ",i4)',bank,tube,pixel
  nexus_file_name = (*main_global).data_nexus_file_name
  
  ;retrieve distance sample_moderator
  distance_moderator_sample = $
    retrieve_distance_moderator_sample(nexus_file_name)
  distance_sample_beam_center_pixel = $
    retrieve_distance_bc_pixel_sample(nexus_file_name, bank, tube, pixel)
  total_distance = distance_moderator_sample + $
    distance_sample_beam_center_pixel
    
  both_banks = (*(*main_global).both_banks) ;[TOF,Pixel,Tube]
  nbr_tof = (size(both_banks))(1)
  
  trans_peak_tube = (*(*global).trans_peak_tube)
  trans_peak_pixel = (*(*global).trans_peak_pixel)
  
  ;check number of pixel part of the transmission file
  nbr_pixel = N_ELEMENTS(trans_peak_tube)
  trans_peak_array = LONARR(nbr_tof) ;total counts for each tof
  trans_peak_array_error = DBLARR(nbr_tof) ;total counts error for each tof
  index = 0
  WHILE (index LT nbr_pixel) DO BEGIN
    tube = trans_peak_tube[index]
    pixel = trans_peak_pixel[index]
    array_of_local_pixel = both_banks[*,pixel,tube] ;pixel from the transmission peak
    trans_peak_array += array_of_local_pixel
    trans_peak_array_error += array_of_local_pixel^2
    index++
  ENDWHILE
  
  ;take square root of result
  trans_peak_array_error = SQRT(trans_peak_array_error)
  
  ;get tof array
  tof_array = (*(*global).tof_array)
  
  ;do the conversion from tof into Lambda
  mass_neutron = (*main_global).mass_neutron
  planck_constant = (*main_global).planck_constant
  coeff = planck_constant / (mass_neutron * DOUBLE(total_distance))
  
  lambda_axis = tof_array * 1e4 * coeff[0] ;1e4 to go into microS and Angstroms
  
  (*(*global).transmission_peak_value) = trans_peak_array
  (*(*global).transmission_peak_error_value) = trans_peak_array_error
  (*(*global).transmission_lambda_axis) = lambda_axis
  
END

;------------------------------------------------------------------------------
PRO display_beam_center_pixel, wBase=wBase, Event=event

  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    WIDGET_CONTROL,wBase, GET_UVALUE=global
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ENDELSE
  
  tube = (*global).tube_beam_center
  pixel = (*global).pixel_beam_center
  bank = getBankNumber(tube+1)
  (*global).beam_center_bank_tube_pixel = [bank, tube, pixel]
  
  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
  counts = getTransAutoCounts(wbase=wbase, tube, pixel)
    putTextFieldValueMainBase, wBase, UNAME='trans_auto_beam_center_tube', $
      STRCOMPRESS(tube,/REMOVE_ALL)
    putTextFieldValueMainBase, wBase, UNAME='trans_auto_beam_center_pixel', $
      STRCOMPRESS(pixel,/REMOVE_ALL)
    putTextFieldValueMainBase, wBase, UNAME='trans_auto_beam_center_counts', $
      STRCOMPRESS(counts,/REMOVE_ALL)
  ENDIF ELSE BEGIN
  counts = getTransAutoCounts(event=event, tube, pixel)
    putTextFieldValue, Event, 'trans_auto_beam_center_tube', $
      STRCOMPRESS(tube,/REMOVE_ALL)
    putTextFieldValue, Event, 'trans_auto_beam_center_pixel', $
      STRCOMPRESS(pixel,/REMOVE_ALL)
    putTextFieldValue, Event, 'trans_auto_beam_center_counts', $
      STRCOMPRESS(counts,/REMOVE_ALL)
  ENDELSE
  
  plot_pixel_auto_selected_below_cursor, wBase=wBase, Event=event, tube, pixel
  
END

;------------------------------------------------------------------------------
PRO plot_pixel_auto_selected_below_cursor, wBase=wBase, Event=event, $
    tube, $
    pixel
    
  uname = 'auto_transmission_draw'
  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    WIDGET_CONTROL,wBase,GET_UVALUE=global
    ;select plot area
    id = WIDGET_INFO(wBase,find_by_uname=uname)
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
    ;select plot area
    id = WIDGET_INFO(Event.top,find_by_uname=uname)
  ENDELSE
  
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  xmin_device = getAutoTubeDeviceFromData(wBase=wBase, Event=event, tube)
  xmax_device = getAutoTubeDeviceFromData(wBase=wBase, Event=event, tube+1)
  ymin_device = getAutoPixelDeviceFromData(wBase=wBase, Event=event, pixel)
  ymax_device = getAutoPixelDeviceFromData(wBase=wBase, Event=event, pixel+1)
  
  color = 250
  
  PLOTS, xmin_device, ymin_device, /DEVICE, COLOR=color
  PLOTS, xmin_device, ymax_device, /DEVICE, COLOR=color, /CONTINUE, THICK=3
  PLOTS, xmax_device, ymax_device, /DEVICE, COLOR=color, /CONTINUE, THICK=3
  PLOTS, xmax_device, ymin_device, /DEVICE, COLOR=color, /CONTINUE, THICK=3
  PLOTS, xmin_device, ymin_device, /DEVICE, COLOR=color, /CONTINUE, THICK=3
  
  color = 0
  
  PLOTS, xmin_device, ymin_device, /DEVICE, COLOR=color
  PLOTS, xmax_device, ymax_device, /DEVICE, COLOR=color, /CONTINUE, THICK=3
  
  PLOTS, xmin_device, ymax_device, /DEVICE, COLOR=color
  PLOTS, xmax_device, ymin_device, /DEVICE, COLOR=color, /CONTINUE, THICK=3
  
END

;------------------------------------------------------------------------------
PRO output_trans_file_from_base, wBase=wBase, Event=event

  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    WIDGET_CONTROL, wBase, GET_UVALUE=global
    id = WIDGET_INFO(wBase, FIND_BY_UNAME='transmission_auto_mode_base')
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
    id = WIDGET_INFO(Event.top, FIND_BY_UNAME='transmission_auto_mode_base')
  ENDELSE
  
  ;retrieve info about pixel selected and file name
  main_global = (*global).global
  
  y_axis = (*(*global).transmission_peak_value)
  y_error_axis = (*(*global).transmission_peak_error_value)
  x_axis = (*(*global).transmission_lambda_axis)
  
  ;get full file name
  nexus_file_name = (*main_global).data_nexus_file_name
  s_run_number = getNexusRunNumber(nexus_file_name)
  output_file_name = '~/results/transmission_' + s_run_number + '.txt'
  (*global).output_file_name = output_file_name
  
  bank_tube_pixel = (*global).beam_center_bank_tube_pixel
  bank = STRCOMPRESS(bank_tube_pixel[0],/REMOVE_ALL)
  tube = STRCOMPRESS(bank_tube_pixel[1],/REMOVE_ALL)
  pixel = STRCOMPRESS(bank_tube_pixel[2],/REMOVE_ALL)
  
  ;first part of file
  first_part = STRARR(5)
  first_part[0] = '#F transmission: ' + nexus_file_name
  first_part[1] = ''
  first_part[2] = "#S 1 Spectrum ID ('bank" + bank + "', (" + tube + $
    ", " + pixel + "))"
  first_part[3] = '#N 3'
  first_part[4] = '#L  wavelength(Angstroms)   Ratio()   Sigma()'
  
  error = 0
  CATCH, error
  IF (error NE 0) then begin
    CATCH, /CANCEL
    title = 'Transmission File Name Creation FAILED!'
    message_text = 'Creation of transmission file ' + output_file_name + $
      ' FAILED!'
    result = DIALOG_MESSAGE(message_text, $
      /CENTER, $
      DIALOG_PARENT=id, $
      /ERROR, $
      TITLE = title)
  ;put error statement here
  ENDIF ELSE BEGIN
    ;open output file
    OPENW, 1, output_file_name
    ;write first part
    FOR i=0,N_ELEMENTS(first_part)-1 DO BEGIN
      PRINTF, 1, first_part[i]
    ENDFOR
    FOR i=0,N_ELEMENTS(y_axis)-1 DO BEGIN
      line = STRCOMPRESS(x_axis[i],/REMOVE_ALL) + ' '
      line += STRCOMPRESS(y_axis[i],/REMOVE_ALL) + ' '
      line += STRCOMPRESS(y_error_axis[i],/REMOVE_ALL)
      PRINTF, 1, line
    ENDFOR
    PRINTF, 1, STRCOMPRESS(x_axis[N_ELEMENTS(x_axis)-1],/REMOVE_ALL)
    
    title =  'Transmission File has been created with SUCCESS!'
    message_text = 'Creation of transmission file ' + output_file_name + $
      ' WORKED!'
  ;    result = DIALOG_MESSAGE(message_text, $
  ;      /INFORMATION, $
  ;      /CENTER, $
  ;      DIALOG_PARENT=id, $
  ;      TITLE = title)
  ENDELSE
  CLOSE, 1
  FREE_LUN, 1
  
END

;------------------------------------------------------------------------------
PRO plot_transmission_file, wBase=wBase, Event=event

  uname = 'trans_auto_trans_plot'
  IF (N_ELEMENTS(wBase) NE 0) THEN BEGIN
    WIDGET_CONTROL, wBase, GET_UVALUE=global
    id = WIDGET_INFO(wBase,find_by_uname=uname)
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
    id = WIDGET_INFO(Event.top,find_by_uname=uname)
  ENDELSE
  
  output_file_name = (*global).output_file_name
  
  y_axis = (*(*global).transmission_peak_value)
  y_error_axis = (*(*global).transmission_peak_error_value)
  x_axis = (*(*global).transmission_lambda_axis)
  
  xtitle = "Lambda (Angstroms)"
  ytitle = "Counts"
  title = "Preview of Transmission file " + output_file_name
  
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  plot, x_axis, y_axis, XTITLE=xtitle, YTITLE=ytitle, TITLE=title
  
END

;------------------------------------------------------------------------------
PRO transmission_auto_Cleanup, tlb

  WIDGET_CONTROL, tlb, GET_UVALUE=global_auto, /NO_COPY
  IF N_ELEMENTS(global_auto) EQ 0 THEN RETURN
  
  ; Free up the pointers
  PTR_FREE, (*global_auto).rtt_zoom_data
  PTR_FREE, (*global_auto).tt_zoom_data
  PTR_FREE, (*global_auto).background
  PTR_FREE, (*global_auto).counts_vs_x
  PTR_FREE, (*global_auto).counts_vs_y
  PTR_FREE, (*global_auto).pixel_x_axis
  PTR_FREE, (*global_auto).tube_x_axis
  PTR_FREE, (*global_auto).counts_vs_xy
  PTR_FREE, (*global_auto).trans_manual_step2.user_counts_vs_xy
  PTR_FREE, (*global_auto).trans_manual_step2.xaxis
  PTR_FREE, (*global_auto).trans_manual_step2.yaxis
  PTR_FREE, (*global_auto).trans_peak_tube
  PTR_FREE, (*global_auto).trans_peak_pixel
  PTR_FREE, (*global_auto).top_plot_background_with_right_tube
  PTR_FREE, (*global_auto).top_plot_background_with_left_tube
  PTR_FREE, (*global_auto).bottom_plot_background_with_right_pixel
  PTR_FREE, (*global_auto).bottom_plot_background_with_left_pixel
  PTR_FREE, (*global_auto).user_counts_vs_xy
  PTR_FREE, (*global_auto).step3_3d_data
  PTR_FREE, (*global_auto).step3_tt_zoom_data
  PTR_FREE, (*global_auto).step3_rtt_zoom_data
  PTR_FREE, (*global_auto).step3_counts_vs_x
  PTR_FREE, (*global_auto).step3_counts_vs_y
  PTR_FREE, (*global_auto).step3_background
  PTR_FREE, (*global_auto).tof_array
  PTR_FREE, (*global_auto).transmission_peak_value
  PTR_FREE, (*global_auto).transmission_peak_error_value
  PTR_FREE, (*global_auto).transmission_lambda_axis
  
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
    
  (*global).transmission_auto_mode_id = wBase
  
  global_auto = PTR_NEW({ wbase: wbase,$
    global: global,$
    rtt_zoom_data: PTR_NEW(0L), $
    tt_zoom_data: PTR_NEW(0L), $
    x0y0x1y1: [127,83,214,153],$
    tube_pixel_edges: [91,123,99,133],$
    nbr_iteration: 2,$
    trans_auto_background: 0L, $
    trans_auto_transmission_intensity: 0L, $
    output_file_name: '',$
    
    tube_beam_center: 95,$
    pixel_beam_center: 127,$
    
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
    xoffset_plot: 80L, $
    tube_min: 80L, $
    tube_max: 111, $
    yoffset_plot: 112L, $
    pixel_min: 112, $
    pixel_max: 151,$
    
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
    GROUP_LEADER = ourGroup, /NO_BLOCK, CLEANUP='transmission_auto_Cleanup'
    
  ;get TOF array
  ; tof_array = getTOFarray(Event, (*global).data_nexus_file_name)
  ; (*(*global_auto).tof_array) = tof_array = (*(*global).tof_array)
  (*(*global_auto).tof_array) = (*(*global).tof_array)
  
  plot_auto_data_around_beam_stop, main_base=wBase, global, global_auto
  
  plot_trans_auto_central_selection, wBase=wbase
  
  display_selection_info_values, wBase=wbase, global_auto
  
  plot_trans_auto_counts_vs_x_and_y, wBase=wbase, global_auto
  
  trans_auto_calculate_background, wBase=wBase
  
  calculate_trans_auto_transmission_intensity, wBase=wBase
  
  display_beam_center_pixel, wBase=wBase
  
  create_auto_trans_array, wBase=wBase
  
  output_trans_file_from_base, wBase=wBase
  
  plot_transmission_file, wBase=wBase
  
END

