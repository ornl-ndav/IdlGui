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

PRO plot_transmission_step3_scale, Event

  ;change color of background
  id = WIDGET_INFO(Event.top,$
    FIND_BY_UNAME='manual_transmission_step3_draw_scale')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  device, decomposed=1
  sys_color_window_bk = (*global).sys_color_window_bk
  
  ;get pixel min, pixel max, tube min and tube max selected by user
  tube_min = FIX(getTextFieldValue(Event,'trans_manual_step2_tube_min'))
  tube_max = FIX(getTextFieldValue(Event,'trans_manual_step2_tube_max'))
  pixel_min = FIX(getTextFieldValue(Event,'trans_manual_step2_pixel_min'))
  pixel_max = FIX(getTextFieldValue(Event,'trans_manual_step2_pixel_max'))
  
  tube_diff = (tube_max - tube_min)
  IF (~isOdd(tube_diff)) THEN BEGIN
    tube_max++
  ENDIF
  
  pixel_diff = (pixel_max - pixel_min)
  IF (~isOdd(pixel_diff)) THEN BEGIN
    pixel_max++
  ENDIF
  
  xtick = tube_max - tube_min + 1
  ytick = pixel_max - pixel_min + 1
  
  (*global).step3_tube_min = tube_min
  (*global).step3_tube_max = tube_max
  (*global).step3_pixel_min = pixel_min
  (*global).step3_pixel_max = pixel_max
  
  xmargin_left   = 8.2
  xmargin_right  = 5.5
  ymargin_bottom = 4.9
  ymargin_top    = 3.1
  plot, randomn(s,80), $
    XRANGE     = [tube_min, tube_max+1],$
    YRANGE     = [pixel_min, pixel_max+1],$
    COLOR      = convert_rgb([0B,0B,255B]), $
    ;    BACKGROUND = convert_rgb(sys_color.face_3d),$
    BACKGROUND = convert_rgb(sys_color_window_bk),$
    THICK      = 1, $
    TICKLEN    = -0.025, $
    XTICKLAYOUT = 0,$
    XSTYLE      = 1,$
    YSTYLE      = 1,$
    YTICKLAYOUT = 0,$
    XTICKS      = xtick,$
    YTICKS      = ytick,$
    XTITLE      = 'TUBES',$
    YTITLE      = 'PIXELS',$
    XMARGIN     = [xmargin_left, xmargin_right],$
    YMARGIN     = [ymargin_bottom, ymargin_top],$
    /NODATA
  AXIS, yaxis=1, YRANGE=[pixel_min,pixel_max+1], YTICKS=ytick, YSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = -0.025
  AXIS, xaxis=1, XRANGE=[tube_min,tube_max+1], XTICKS=xtick, XSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = -0.025
    
  DEVICE, decomposed = 0
  
END

;------------------------------------------------------------------------------
PRO plot_transmission_step3_main_plot, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  both_banks = (*global).both_banks
  
  tube_min  = (*global).step3_tube_min
  tube_max  = (*global).step3_tube_max
  pixel_min = (*global).step3_pixel_min
  pixel_max = (*global).step3_pixel_max
  
  zoom_data = both_banks[*,pixel_min:pixel_max,tube_min:tube_max]
  
  (*(*global).step3_3d_data) = zoom_data
  
  t_zoom_data = TOTAL(zoom_data,1)
  tt_zoom_data = TRANSPOSE(t_zoom_data)
  (*(*global).step3_tt_zoom_data) = tt_zoom_data
  rtt_zoom_data = CONGRID(tt_zoom_data, 400, 300)
  (*(*global).step3_rtt_zoom_data) = rtt_zoom_data
  
  data = rtt_zoom_data
  
  IF (~isTranManualStep3LinSelected(Event)) THEN BEGIN ;log mode
    index = WHERE(data EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      data[index] = !VALUES.D_NAN
    ENDIF
    Data_log = ALOG10(Data)
    Data_log_bytscl = BYTSCL(Data_log,/NAN)
    data = data_log_bytscl
  ENDIF
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='manual_transmission_step3_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TVSCL, data
  
END

;------------------------------------------------------------------------------
PRO replot_transmission_step3_main_plot, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  data = (*(*global).step3_rtt_zoom_data)
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='manual_transmission_step3_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  IF (~isTranManualStep3LinSelected(Event)) THEN BEGIN ;log mode
    index = WHERE(data EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      data[index] = !VALUES.D_NAN
    ENDIF
    Data_log = ALOG10(Data)
    Data_log_bytscl = BYTSCL(Data_log,/NAN)
    data = data_log_bytscl
  ENDIF
  
  TVSCL, data
  
END

;------------------------------------------------------------------------------
PRO plot_transmission_step3_bottom_plots, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  counts_vs_xy = (*(*global).step3_tt_zoom_data)
  
  counts_vs_x = TOTAL(counts_vs_xy,2)
  counts_vs_y = TOTAL(counts_vs_xy,1)
  (*(*global).step3_counts_vs_x) = counts_vs_x
  (*(*global).step3_counts_vs_y) = counts_vs_y
  
  ;plot data
  ;Counts vs tube (integrated over y)
  x_axis = INDGEN(N_ELEMENTS(counts_vs_x)) + (*global).step3_tube_min
  id = WIDGET_INFO(Event.top,$
    FIND_BY_UNAME='trans_manual_step3_counts_vs_tube_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  plot, x_axis, counts_vs_x, XSTYLE=1, XTITLE='Tube #', YTITLE='Counts', $
    TITLE = 'Counts vs tube integrated over pixel', $
    XTICKS = N_ELEMENTS(counts_vs_x)-1, $
    PSYM = -1
    
  ;Counts vs tube (integrated over x)
  x_axis = INDGEN(N_ELEMENTS(counts_vs_y)) + (*global).step3_pixel_min
  id = WIDGET_INFO(Event.top,$
    FIND_BY_UNAME='trans_manual_step3_counts_vs_pixel_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  PLOT, x_axis, counts_vs_y, XSTYLE=1, XTITLE='Pixel #', YTITLE='Counts', $
    TITLE = 'Counts vs pixel integrated over tube', $
    XTICKS = N_ELEMENTS(counts_vs_y)-1, $
    PSYM = -1
    
END

;------------------------------------------------------------------------------
PRO save_transmission_manual_step3_background,  EVENT=event

  uname = 'manual_transmission_step3_draw'
  WIDGET_CONTROL, event.top, GET_UVALUE=global
  ;select plot area
  id = WIDGET_INFO(Event.top,find_by_uname=uname)
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize   = geometry.xsize
  ysize   = geometry.ysize
  
  DEVICE, copy =[0, 0, xsize, ysize, 0, 0, id_value]
  (*(*global).step3_background) = background
  
END

;------------------------------------------------------------------------------
PRO plot_trans_manual_step3_background, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  id = WIDGET_INFO(event.top,FIND_BY_UNAME='manual_transmission_step3_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TV, (*(*global).step3_background), true=3
  
END

;------------------------------------------------------------------------------
PRO plot_pixel_below_cursor, Event, tube, pixel

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  xmin_device = getStep3TubeDeviceFromData(Event, tube)
  xmax_device = getStep3TubeDeviceFromData(Event, tube+1)
  ymin_device = getStep3PixelDeviceFromData(Event, pixel)
  ymax_device = getStep3PixelDeviceFromData(Event, pixel+1)
  
  color = 100
  
  PLOTS, xmin_device, ymin_device, /DEVICE, COLOR=color
  PLOTS, xmin_device, ymax_device, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0
  PLOTS, xmax_device, ymax_device, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0
  PLOTS, xmax_device, ymin_device, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0
  PLOTS, xmin_device, ymin_device, /DEVICE, COLOR=color, /CONTINUE, LINESTYLE=0
  
END

;------------------------------------------------------------------------------
PRO plot_pixel_selected_below_cursor, event, tube, pixel

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  uname = 'manual_transmission_step3_draw'
  WIDGET_CONTROL, event.top, GET_UVALUE=global
  ;select plot area
  id = WIDGET_INFO(Event.top,find_by_uname=uname)
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  xmin_device = getStep3TubeDeviceFromData(Event, tube)
  xmax_device = getStep3TubeDeviceFromData(Event, tube+1)
  ymin_device = getStep3PixelDeviceFromData(Event, pixel)
  ymax_device = getStep3PixelDeviceFromData(Event, pixel+1)
  
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
PRO plot_counts_vs_tof_step3_beam_center, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  tube = getTextFieldValue(Event,$
    'trans_manual_step3_beam_center_tube_value')
  pixel = getTextFieldValue(Event,$
    'trans_manual_step3_beam_center_pixel_value')
    
  IF (tube EQ 'N/A') THEN RETURN
  tube = FIX(tube)
  pixel = FIX(pixel)
  
  ;get tof array
  tof_array = (*(*global).tof_array)
  
  zoom_data = (*(*global).step3_3d_data) ;[tof,pixel,tube]
  
  new_tube = tube - (*global).step3_tube_min
  new_pixel = pixel - (*global).step3_pixel_min
  
  data = zoom_data[*,new_pixel,new_tube]
  
  id = WIDGET_INFO(event.top,$
    FIND_BY_UNAME='trans_manual_step3_counts_vs_tof_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  PLOT, data, XSTYLE=1, XTITLE='Bin #', YTITLE='Counts', $
    PSYM = -1, $
    POSITION = [0.05,0.17,0.96,0.85]
    
  AXIS, XAXIS=1, XRANGE=[tof_array[0], tof_array[N_ELEMENTS(tof_array)-2]], $
    XTITLE = 'TOF (microS)'
    
  XYOUTS, 0.7, 0.6, 'Counts vs bins # and TOF for Beam Center Selected',/DEVICE
  
END

;------------------------------------------------------------------------------
PRO replot_pixel_selected_below_cursor, event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  uname = 'manual_transmission_step3_draw'
  WIDGET_CONTROL, event.top, GET_UVALUE=global
  ;select plot area
  id = WIDGET_INFO(Event.top,find_by_uname=uname)
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  tube = getTextFieldValue(Event,$
    'trans_manual_step3_beam_center_tube_value')
  pixel = getTextFieldValue(Event,$
    'trans_manual_step3_beam_center_pixel_value')
    
  IF (tube EQ 'N/A') THEN RETURN
  tube = FIX(tube)
  pixel = FIX(pixel)
  
  xmin_device = getStep3TubeDeviceFromData(Event, tube)
  xmax_device = getStep3TubeDeviceFromData(Event, tube+1)
  ymin_device = getStep3PixelDeviceFromData(Event, pixel)
  ymax_device = getStep3PixelDeviceFromData(Event, pixel+1)
  
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
PRO display_step3_create_trans_button, Event, mode=mode

  uname = 'trans_manual_step3_create_trans_file'
  WIDGET_CONTROL, event.top, GET_UVALUE=global
  id = WIDGET_INFO(Event.top,find_by_uname=uname)
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  CASE (mode) OF
    'on': image = 'SANSreduction_images/create_transmission_file_on.png'
    'off': image = 'SANSreduction_images/create_transmission_file_off.png'
    'disable': image = 'SANSreduction_images/create_transmission_file_disable.png'
  ENDCASE
  
  view_png = READ_PNG(image)
  TV, view_png, 0, 0, /true
  
END

;------------------------------------------------------------------------------
PRO launch_transmission_file_name_base, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global
  main_global = (*global).global
  
  ;get info about pixel selected
  tube = getTextFieldValue(Event,$
    'trans_manual_step3_beam_center_tube_value')
  pixel = getTextFieldValue(Event,$
    'trans_manual_step3_beam_center_pixel_value')
  bank = getBankNumber(tube+1)
  
  (*global).beam_center_bank_tube_pixel = [bank, tube, pixel]
  
  transmission_file_name_base, Event, MAIN_GLOBAL=main_global  
  
END

