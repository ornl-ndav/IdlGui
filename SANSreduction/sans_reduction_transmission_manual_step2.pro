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

PRO refresh_trans_manual_step2_plots_counts_vs_x_and_y, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH, /CANCEL
    RETURN
  ENDIF
  
  x0y0x1y1 = (*global).x0y0x1y1
  x0 = x0y0x1y1[0]
  y0 = x0y0x1y1[1]
  x1 = x0y0x1y1[2]
  y1 = x0y0x1y1[3]
  
  IF (x0 + y0 NE 0 AND $
    x1 + y1 NE 0) THEN BEGIN
    
    plot_trans_manual_step2_counts_vs_x, Event
    
    ;get ymin and ymax of top plot
    x_ref_device = (522-60)/2
    y_min_device = (*global).trans_manual_step2_ymin_device
    y_max_device = (*global).trans_manual_step2_ymax_device
    
    y_min_data_array = CONVERT_COORD(x_ref_device, y_min_device,/DEVICE,/TO_DATA)
    y_max_data_array = CONVERT_COORD(x_ref_device, y_max_device,/DEVICE,/TO_DATA)
    
    y_min_data = y_min_data_array[1]
    y_max_data = y_max_data_array[1]
    
    (*global).trans_manual_step2_top_plot_ymin_data = y_min_data
    (*global).trans_manual_step2_top_plot_ymax_data = y_max_data
    
    plot_trans_manual_step2_counts_vs_y, Event
    
    ;get ymin and ymax of bottom plot
    y_min_data_array = CONVERT_COORD(x_ref_device, y_min_device,/DEVICE,/TO_DATA)
    y_max_data_array = CONVERT_COORD(x_ref_device, y_max_device,/DEVICE,/TO_DATA)
    
    y_min_data = y_min_data_array[1]
    y_max_data = y_max_data_array[1]
    
    (*global).trans_manual_step2_bottom_plot_ymin_data = y_min_data
    (*global).trans_manual_step2_bottom_plot_ymax_data = y_max_data
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO display_trans_step2_algorith_image, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  ;build gui
  wBase = ''
  transmission_manual_mode_step2_info_gui, Event, wBase
  
  XMANAGER, "display_trans_step2_algorith_image", wBase, $
    GROUP_LEADER = ourGroup, /NO_BLOCK
    
END

;------------------------------------------------------------------------------
PRO transmission_manual_mode_step2_info_gui, Event, wBase

  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='transmission_manual_mode_base')
  main_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  xsize = 500
  ysize= 375
  xoffset = main_base_xoffset + main_base_xsize/2-xsize/2
  yoffset = main_base_yoffset + main_base_ysize/2-ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Algorithm used to calculate Background',$
    MAP          = 1,$
    XOFFSET = xoffset,$
    YOFFSET = yoffset,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    GROUP_LEADER = ourGroup)
    
  draw = WIDGET_DRAW(wBase,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'trans_manual_step2_image')
    
  WIDGET_CONTROL, wBase, /REALIZE
  
  image = READ_PNG('SANSreduction_images/algorithm_engine.png')
  mode_id = WIDGET_INFO(wBase, $
    FIND_BY_UNAME='trans_manual_step2_image')
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, image, 0, 0,/true
  
END

;------------------------------------------------------------------------------
PRO trans_manual_step2_calculate_background, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  counts_vs_xy = (*(*global).counts_vs_xy)
  nbr_pixels = N_ELEMENTS(counts_vs_xy)
  
  s_nbr_iterations = getTextFieldValue(Event,$
    'trans_manual_step2_nbr_iterations')
  nbr_iterations = FIX(s_nbr_iterations)
  average = FLTARR(nbr_iterations)
  
  array = counts_vs_xy
  index = 0
  WHILE (index LT nbr_iterations) DO BEGIN
    IF (index NE 0) THEN BEGIN
      array_list = WHERE(array GE average[index-1],counts)
      IF (counts GT 0) THEN BEGIN
        array[array_list] = 0
      ENDIF
    ENDIF
    total = TOTAL(array)
    average_value = FLOAT(total)/FLOAT(nbr_pixels)
    plot_average_value, Event, average_value
    average[index] = average_value
    index++
  ENDWHILE
  
  background = FIX(average_value)
  s_background = STRCOMPRESS(background,/REMOVE_ALL)
  putTextFieldValue, Event, 'trans_manual_step2_background_value', s_background
  (*global).trans_manual_step2_background = background
  
  calculate_trans_manual_step2_transmission_intensity, Event
  
END

;------------------------------------------------------------------------------
PRO plot_average_value, Event, average_value

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  counts_vs_xy = (*(*global).counts_vs_xy)
  nbr_pixel    = (size(counts_vs_xy))(2)
  nbr_tube     = (size(counts_vs_xy))(1)
  
  ;tube
  plot_trans_manual_step2_counts_vs_x, Event
  x_axis = (*(*global).tube_x_axis)
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_x')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  average_value_tube = average_value * nbr_pixel
  plots, x_axis[0], average_value_tube, /DATA
  plots, x_axis[N_ELEMENTS(x_axis)-1], average_value_tube, /DATA, /CONTINUE, $
    COLOR=50
    
  ;pixel
  plot_trans_manual_step2_counts_vs_y, Event
  x_axis = (*(*global).pixel_x_axis)
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_y')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  average_value_pixel = average_value * nbr_tube
  plots, x_axis[0], average_value_pixel, /DATA
  plots, x_axis[N_ELEMENTS(x_axis)-1], average_value_pixel, /DATA, /CONTINUE, $
    COLOR=50
    
END

;------------------------------------------------------------------------------
PRO plot_trans_manual_step2_counts_vs_x, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  ;Counts vs tube (integrated over y)
  x_axis_tube = (*(*global).tube_x_axis)
  counts_vs_x = (*(*global).counts_vs_x)
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_x')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  plot, x_axis_tube, counts_vs_x, XSTYLE=1, XTITLE='Tube #', YTITLE='Counts', $
    TITLE = 'Counts vs tube integrated over pixel', PSYM=-2, $
    XTICKS = N_ELEMENTS(x_axis_tube)-1
    
END

;------------------------------------------------------------------------------
PRO plot_trans_manual_step2_counts_vs_y, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  ;Counts vs tube (integrated over x)
  x_axis_pixel = (*(*global).pixel_x_axis)
  counts_vs_y = (*(*global).counts_vs_y)
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_y')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  plot, x_axis_pixel, counts_vs_y, XSTYLE=1, XTITLE='Pixel #', $
    YTITLE='Counts', $
    TITLE = 'Counts vs pixel integrated over tube', $
    PSYM = -2, $
    XTICKS = N_ELEMENTS(x_axis_pixel)-1
    
END

;------------------------------------------------------------------------------
PRO trans_manual_step2_manual_input_of_background, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  average_value = getTextFieldValue(Event,$
    'trans_manual_step2_background_edit')
  (*global).trans_manual_step2_background = average_value
  
  plot_average_value, Event, average_value
  
  calculate_trans_manual_step2_transmission_intensity, Event
  
END

;------------------------------------------------------------------------------
PRO calculate_trans_manual_step2_transmission_intensity, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  background_value = (*global).trans_manual_step2_background
  array            = (*(*global).counts_vs_xy)
  
  array_list = WHERE(array GE background_value)
  array_peak = array[array_list]
  transmission_intensity = TOTAL(array_peak)
  (*global).trans_manual_step2_transmission_intensity = transmission_intensity
  putTextFieldValue, Event, 'trans_manual_step2_trans_intensity_value', $
    STRCOMPRESS(transmission_intensity,/REMOVE_ALL)
    
END

;------------------------------------------------------------------------------
PRO plot_counts_vs_tube_step2_tube_selection, Event, tube=tube

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  plot_trans_manual_step2_counts_vs_x, Event
  CURSOR, X, Y, /DATA, /NOWAIT
  
  y_min = (*global).trans_manual_step2_top_plot_ymin_data
  y_max = (*global).trans_manual_step2_top_plot_ymax_data
  
  PLOTS, x, y_min, /DATA
  PLOTS, x, y_max, /DATA, /CONTINUE, COLOR=1000
  
END
