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
    x_min_device = (*global).trans_manual_step2_xmin_device
    x_max_device = (*global).trans_manual_step2_xmax_device
    y_min_device = (*global).trans_manual_step2_ymin_device
    y_max_device = (*global).trans_manual_step2_ymax_device
    
    data_array_min = CONVERT_COORD(x_min_device, y_min_device,/DEVICE,/TO_DATA)
    data_array_max = CONVERT_COORD(x_max_device, y_max_device,/DEVICE,/TO_DATA)
    
    x_min_data = data_array_min[0]
    x_max_data = data_array_max[0]
    y_min_data = data_array_min[1]
    y_max_data = data_array_max[1]
    
    (*global).trans_manual_step2_top_plot_ymin_data = y_min_data
    (*global).trans_manual_step2_top_plot_ymax_data = y_max_data
    (*global).trans_manual_step2_top_plot_xmin_data = x_min_data
    (*global).trans_manual_step2_top_plot_xmax_data = x_max_data
    
    plot_trans_manual_step2_counts_vs_y, Event
    
    ;get ymin and ymax of bottom plot
    data_array_min = CONVERT_COORD(x_min_device, y_min_device,/DEVICE,/TO_DATA)
    data_array_max = CONVERT_COORD(x_max_device, y_max_device,/DEVICE,/TO_DATA)
    
    x_min_data = data_array_min[0]
    x_max_data = data_array_max[0]
    y_min_data = data_array_min[1]
    y_max_data = data_array_max[1]
    
    (*global).trans_manual_step2_bottom_plot_ymin_data = y_min_data
    (*global).trans_manual_step2_bottom_plot_ymax_data = y_max_data
    (*global).trans_manual_step2_bottom_plot_xmin_data = x_min_data
    (*global).trans_manual_step2_bottom_plot_xmax_data = x_max_data
    
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
PRO plot_average_value, Event, average_value

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  counts_vs_xy = (*(*global).user_counts_vs_xy)
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
  counts_vs_xy     = (*(*global).counts_vs_xy)
  
  ;get pixel min, pixel max, tube min and tube max selected by user
  tube_min = FIX(getTextFieldValue(Event,'trans_manual_step2_tube_min'))
  tube_max = FIX(getTextFieldValue(Event,'trans_manual_step2_tube_max'))
  pixel_min = FIX(getTextFieldValue(Event,'trans_manual_step2_pixel_min'))
  pixel_max = FIX(getTextFieldValue(Event,'trans_manual_step2_pixel_max'))
  
  ;get true pixel min and max values
  tube_min_graph = (*global).trans_manual_step2_top_plot_xmin_data
  tube_max_graph = (*global).trans_manual_step2_top_plot_xmax_data
  pixel_min_graph = (*global).trans_manual_step2_bottom_plot_xmin_data
  pixel_max_graph = (*global).trans_manual_step2_bottom_plot_xmax_data
  
  tube_min_offset = tube_min - tube_min_graph
  tube_max_offset = tube_max_graph - tube_max
  pixel_min_offset = pixel_min - pixel_min_graph
  pixel_max_offset = pixel_max_graph - pixel_max
  
  nbr_tube = (size(counts_vs_xy))(1)
  nbr_pixel = (size(counts_vs_xy))(2)
  
  array = counts_vs_xy[tube_min_offset:nbr_tube-tube_max_offset-1,$
    pixel_min_offset:nbr_pixel-pixel_max_offset-1]
    
  get_transmission_peak_tube_pixel_value, Event, $
    array, $
    background_value, $
    tube_min, $
    pixel_min
    
  array_list = WHERE(array GT background_value)
  array_peak = array[array_list]
  transmission_intensity = TOTAL(array_peak)
  (*global).trans_manual_step2_transmission_intensity = transmission_intensity
  putTextFieldValue, Event, 'trans_manual_step2_trans_intensity_value', $
    STRCOMPRESS(transmission_intensity,/REMOVE_ALL)
    
END

;------------------------------------------------------------------------------
PRO get_transmission_peak_tube_pixel_value, Event, array, background_value, $
    tube_min_offset, pixel_min_offset
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
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
  
;; For verification only
;  trans_peak_tube = (*(*global).trans_peak_tube)
;  trans_peak_pixel = (*(*global).trans_peak_pixel)
;  nbr = N_ELEMENTS(trans_peak_tube)
;  FOR i=0,nbr-1 do begin
;    print, 'tube/pixel: ' + strcompress(trans_peak_tube[i],/remove_all) + $
;      ',' + strcompress(trans_peak_pixel[i],/remove_all)
;  ENDFOR
  
END

;------------------------------------------------------------------------------
PRO plot_counts_vs_tube_step2_tube_selection, Event, tube=tube

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  plot_trans_manual_step2_counts_vs_x, Event
  IF (tube EQ 1) THEN BEGIN ;working with left side
    background = (*(*global).top_plot_background_with_right_tube)
  ENDIF ELSE BEGIN
    background = (*(*global).top_plot_background_with_left_tube)
  ENDELSE
  
  CURSOR, X, Y, /DATA, /NOWAIT
  
  y_min = (*global).trans_manual_step2_top_plot_ymin_data
  y_max = (*global).trans_manual_step2_top_plot_ymax_data
  x_min = (*global).trans_manual_step2_top_plot_xmin_data
  x_max = (*global).trans_manual_step2_top_plot_xmax_data
  
  ;take snapshot
  ;background = TVREAD(TRUE=3)
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_x')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TV, background, true=3
  
  background = TVRD(TRUE=3)
  DEVICE, copy=[41,60,522,390,41,60,id_value]
  
  IF (tube EQ 1) THEN BEGIN
    X = FIX(X) + 0.5
    IF (X LE x_min) THEN BEGIN
      X = x_min
      sX = STRCOMPRESS(FIX(X),/REMOVE_ALL)
    ENDIF ELSE BEGIN
      sX = STRCOMPRESS(FIX(X)+1,/REMOVE_ALL)
    ENDELSE
    (*global).step2_tube_left = X
    POLYFILL, [x_min, X, X, x_min], $
      [y_min, y_min, y_max, y_max], $
      color=FSC_COLOR('red'), /data
    putTextFieldValue, Event,'trans_manual_step2_tube_min', sX
  ENDIF ELSE BEGIN
    X = FIX(X) + 0.5
    IF (X GE x_max) THEN X = x_max
    (*global).step2_tube_right = X
    POLYFILL, [X, x_max, x_max, X], $
      [y_min, y_min, y_max, y_max], $
      color=FSC_COLOR('red'), /data
    putTextFieldValue, Event,'trans_manual_step2_tube_max', $
      STRCOMPRESS(FIX(X),/REMOVE_ALL)
  ENDELSE
  
  foreground = TVRD(TRUE=3)
  alpha= 0.25
  TV, (foreground*alpha)+(1-alpha)*background, true=3
  
END

;------------------------------------------------------------------------------
PRO save_transmission_manual_step2_top_plot_background,  $
    EVENT=event, $
    working_with_tube = working_with_tube
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  plot_trans_manual_step2_counts_vs_x, Event
  y_min = (*global).trans_manual_step2_top_plot_ymin_data
  y_max = (*global).trans_manual_step2_top_plot_ymax_data
  x_min = (*global).trans_manual_step2_top_plot_xmin_data
  x_max = (*global).trans_manual_step2_top_plot_xmax_data
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_x')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  DEVICE, copy=[41,60,522,390,41,60,id_value]
  
  CASE (working_with_tube) OF
    'right': BEGIN
      X= (*global).step2_tube_left
      IF (X NE 0.) THEN BEGIN
        POLYFILL, [x_min, X, X, x_min], $
          [y_min, y_min, y_max, y_max], $
          color=FSC_COLOR('deep pink'), /data
      ENDIF
    END
    'left': BEGIN
      X = (*global).step2_tube_right
      IF (X NE 0.) THEN BEGIN
        POLYFILL, [X, x_max, x_max, X], $
          [y_min, y_min, y_max, y_max], $
          color=FSC_COLOR('deep pink'), /data
      ENDIF
    END
    'neither': BEGIN
    END
    ELSE:
  ENDCASE
  
  foreground = TVRD(TRUE=3)
  alpha= 0.25
  TV, (foreground*alpha)+(1-alpha)*background, true=3
  
  ;now I can save as background
  uname = 'trans_manual_step2_counts_vs_x'
  id = WIDGET_INFO(Event.top,find_by_uname=uname)
  
  background = TVRD(TRUE=3)
  ;  geometry = WIDGET_INFO(id,/GEOMETRY)
  ;  xsize   = geometry.xsize
  ;  ysize   = geometry.ysize
  
  ;  DEVICE, copy =[0, 0, xsize, ysize, 0, 0, id_value]
  
  CASE (working_with_tube) OF
    'right': BEGIN
      (*(*global).top_plot_background_with_left_tube) = background
    END
    'left': BEGIN
      (*(*global).top_plot_background_with_right_tube) = background
    END
    ELSE: BEGIN
      (*(*global).top_plot_background_with_left_tube) = background
      (*(*global).top_plot_background_with_right_tube) = background
    END
  ENDCASE
  
  ;replot other selection if any
  background = TVRD(TRUE=3)
  DEVICE, copy=[41,60,522,390,41,60,id_value]
  CASE (working_with_tube) OF
    'left': BEGIN
      X= (*global).step2_tube_left
      IF (X NE 0.) THEN BEGIN
        POLYFILL, [x_min, X, X, x_min], $
          [y_min, y_min, y_max, y_max], $
          color=FSC_COLOR('red'), /data
      ENDIF
    END
    'right': BEGIN
      X = (*global).step2_tube_right
      IF (X NE 0.) THEN BEGIN
        POLYFILL, [X, x_max, x_max, X], $
          [y_min, y_min, y_max, y_max], $
          color=FSC_COLOR('red'), /data
      ENDIF
    END
    'neither': BEGIN
    END
    ELSE:
  ENDCASE
  
  foreground = TVRD(TRUE=3)
  alpha= 0.25
  TV, (foreground*alpha)+(1-alpha)*background, true=3

END

;------------------------------------------------------------------------------
PRO plot_counts_vs_pixel_step2_pixel_selection, Event, pixel=pixel

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  plot_trans_manual_step2_counts_vs_y, Event
  IF (pixel EQ 1) THEN BEGIN ;working with botto pixel
    background = (*(*global).bottom_plot_background_with_right_pixel)
  ENDIF ELSE BEGIN
    background = (*(*global).bottom_plot_background_with_left_pixel)
  ENDELSE
  
  CURSOR, X, Y, /DATA, /NOWAIT
  
  y_min = (*global).trans_manual_step2_bottom_plot_ymin_data
  y_max = (*global).trans_manual_step2_bottom_plot_ymax_data
  x_min = (*global).trans_manual_step2_bottom_plot_xmin_data
  x_max = (*global).trans_manual_step2_bottom_plot_xmax_data
  
  ;take snapshot
  ;background = TVREAD(TRUE=3)
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_y')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TV, background, true=3
  
  background = TVRD(TRUE=3)
  DEVICE, copy=[41,60,522,390,41,60,id_value]
  
  IF (pixel EQ 1) THEN BEGIN
    X = FIX(X) + 0.5
    IF (X LE x_min) THEN BEGIN
      X = x_min
      sX = STRCOMPRESS(FIX(X),/REMOVE_ALL)
    ENDIF ELSE BEGIN
      sX = STRCOMPRESS(FIX(X)+1,/REMOVE_ALL)
    ENDELSE
    (*global).step2_pixel_left = X
    POLYFILL, [x_min, X, X, x_min], $
      [y_min, y_min, y_max, y_max], $
      color=FSC_COLOR('red'), /data
    putTextFieldValue, Event,'trans_manual_step2_pixel_min', sX
  ENDIF ELSE BEGIN
    X = FIX(X) + 0.5
    IF (X GE x_max) THEN X = x_max
    (*global).step2_pixel_right = X
    POLYFILL, [X, x_max, x_max, X], $
      [y_min, y_min, y_max, y_max], $
      color=FSC_COLOR('red'), /data
    putTextFieldValue, Event,'trans_manual_step2_pixel_max', $
      STRCOMPRESS(FIX(X),/REMOVE_ALL)
  ENDELSE
  
  foreground = TVRD(TRUE=3)
  alpha= 0.25
  TV, (foreground*alpha)+(1-alpha)*background, true=3
  
END

;------------------------------------------------------------------------------
PRO save_transmission_manual_step2_bottom_plot_background,  $
    EVENT=event, $
    working_with_pixel = working_with_pixel
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  plot_trans_manual_step2_counts_vs_y, Event
  y_min = (*global).trans_manual_step2_bottom_plot_ymin_data
  y_max = (*global).trans_manual_step2_bottom_plot_ymax_data
  x_min = (*global).trans_manual_step2_bottom_plot_xmin_data
  x_max = (*global).trans_manual_step2_bottom_plot_xmax_data
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_y')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  DEVICE, copy=[41,60,522,390,41,60,id_value]
  
  CASE (working_with_pixel) OF
    'right': BEGIN
      X= (*global).step2_pixel_left
      POLYFILL, [x_min, X, X, x_min], $
        [y_min, y_min, y_max, y_max], $
        color=FSC_COLOR('deep pink'), /data
    END
    'left': BEGIN
      X = (*global).step2_pixel_right
      POLYFILL, [X, x_max, x_max, X], $
        [y_min, y_min, y_max, y_max], $
        color=FSC_COLOR('deep pink'), /data
    END
    'neither': BEGIN
    END
    ELSE:
  ENDCASE
  
  foreground = TVRD(TRUE=3)
  alpha= 0.25
  TV, (foreground*alpha)+(1-alpha)*background, true=3
  
  ;now I can save as background
  uname = 'trans_manual_step2_counts_vs_y'
  id = WIDGET_INFO(Event.top,find_by_uname=uname)
  
  background = TVRD(TRUE=3)
  ;  geometry = WIDGET_INFO(id,/GEOMETRY)
  ;  xsize   = geometry.xsize
  ;  ysize   = geometry.ysize
  
  ;  DEVICE, copy =[0, 0, xsize, ysize, 0, 0, id_value]
  
  CASE (working_with_pixel) OF
    'right': BEGIN
      (*(*global).bottom_plot_background_with_left_pixel) = background
    END
    'left': BEGIN
      (*(*global).bottom_plot_background_with_right_pixel) = background
    END
    ELSE: BEGIN
      (*(*global).bottom_plot_background_with_left_pixel) = background
      (*(*global).bottom_plot_background_with_right_pixel) = background
    END
  ENDCASE
  
  ;replot other selection if any
  background = TVRD(TRUE=3)
  DEVICE, copy=[41,60,522,390,41,60,id_value]
  
  CASE (working_with_pixel) OF
    'left': BEGIN
      X= (*global).step2_pixel_left
      IF (X EQ 0.) THEN RETURN
      POLYFILL, [x_min, X, X, x_min], $
        [y_min, y_min, y_max, y_max], $
        color=FSC_COLOR('red'), /data
    END
    'right': BEGIN
      X = (*global).step2_pixel_right
      IF (X EQ 0.) THEN RETURN
      POLYFILL, [X, x_max, x_max, X], $
        [y_min, y_min, y_max, y_max], $
        color=FSC_COLOR('red'), /data
    END
    'neither': BEGIN
    END
    ELSE:
  ENDCASE
  
  foreground = TVRD(TRUE=3)
  alpha= 0.25
  TV, (foreground*alpha)+(1-alpha)*background, true=3
  
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
PRO trans_manual_step2_calculate_background, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  counts_vs_xy = (*(*global).counts_vs_xy)  ;DBLARR(tube,pixel)
  
  ;get pixel min, pixel max, tube min and tube max selected by user
  tube_min = FIX(getTextFieldValue(Event,'trans_manual_step2_tube_min'))
  tube_max = FIX(getTextFieldValue(Event,'trans_manual_step2_tube_max'))
  pixel_min = FIX(getTextFieldValue(Event,'trans_manual_step2_pixel_min'))
  pixel_max = FIX(getTextFieldValue(Event,'trans_manual_step2_pixel_max'))
  
  ;get true pixel min and max values
  tube_min_graph = (*global).trans_manual_step2_top_plot_xmin_data
  tube_max_graph = (*global).trans_manual_step2_top_plot_xmax_data
  pixel_min_graph = (*global).trans_manual_step2_bottom_plot_xmin_data
  pixel_max_graph = (*global).trans_manual_step2_bottom_plot_xmax_data
  
  tube_min_offset = tube_min - tube_min_graph
  tube_max_offset = tube_max_graph - tube_max
  pixel_min_offset = pixel_min - pixel_min_graph
  pixel_max_offset = pixel_max_graph - pixel_max
  
  nbr_tube = (size(counts_vs_xy))(1)
  nbr_pixel = (size(counts_vs_xy))(2)
  
  user_counts_vs_xy = counts_vs_xy[tube_min_offset:nbr_tube-tube_max_offset-1,$
    pixel_min_offset:nbr_pixel-pixel_max_offset-1]
  nbr_pixels = N_ELEMENTS(user_counts_vs_xy)
  
  s_nbr_iterations = getTextFieldValue(Event,$
    'trans_manual_step2_nbr_iterations')
  nbr_iterations = FIX(s_nbr_iterations)
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
    ;    plot_average_value, Event, average_value
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
  putTextFieldValue, Event, 'trans_manual_step2_background_value', s_background
  (*global).trans_manual_step2_background = background
  
END

;------------------------------------------------------------------------------
PRO plot_counts_vs_tube_step2_tube_selection_manual_input, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  plot_trans_manual_step2_counts_vs_x, Event
  
  x_min_selection = FIX(getTextFieldValue(Event,'trans_manual_step2_tube_min'))
  x_max_selection = FIX(getTextFieldValue(Event,'trans_manual_step2_tube_max'))
  
  not_working_color = 'deep pink'
  working_color = 'red'
  
  y_min = (*global).trans_manual_step2_top_plot_ymin_data
  y_max = (*global).trans_manual_step2_top_plot_ymax_data
  x_min = (*global).trans_manual_step2_top_plot_xmin_data
  x_max = (*global).trans_manual_step2_top_plot_xmax_data
  
  ;take snapshot
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_x')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  DEVICE, copy=[41,60,522,390,41,60,id_value]
  
  CASE ((*global).working_with_tube) OF
    1: BEGIN
      left_color = working_color
      right_color = not_working_color
    END
    2: BEGIN
      left_color = not_working_color
      right_color = working_color
    END
  ENDCASE
  
  ;left size
  IF (x_min_selection GT x_min) THEN BEGIN
    X = x_min_selection - 0.5
    (*global).step2_tube_left = X
    POLYFILL, [x_min, X, X, x_min], $
      [y_min, y_min, y_max, y_max], $
      color=FSC_COLOR(left_color), /data
  ENDIF
  
  ;right size
  IF (x_max_selection LT x_max) THEN BEGIN
    X = x_max_selection + 0.5
    POLYFILL, [X, x_max, x_max, X], $
      [y_min, y_min, y_max, y_max], $
      color=FSC_COLOR(right_color), /data
  ENDIF
  
  foreground = TVRD(TRUE=3)
  alpha= 0.25
  TV, (foreground*alpha)+(1-alpha)*background, true=3
  
END

;------------------------------------------------------------------------------
PRO plot_counts_vs_pixel_step2_pixel_selection_manual_input, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  plot_trans_manual_step2_counts_vs_y, Event
  
  not_working_color = (*global).selection_not_working_color
  working_color = (*global).selection_working_color
  
  x_min_selection = FIX(getTextFieldValue(Event,'trans_manual_step2_pixel_min'))
  x_max_selection = FIX(getTextFieldValue(Event,'trans_manual_step2_pixel_max'))
  
  y_min = (*global).trans_manual_step2_bottom_plot_ymin_data
  y_max = (*global).trans_manual_step2_bottom_plot_ymax_data
  x_min = (*global).trans_manual_step2_bottom_plot_xmin_data
  x_max = (*global).trans_manual_step2_bottom_plot_xmax_data
  
  ;take snapshot
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step2_counts_vs_y')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  CASE ((*global).working_with_pixel) OF
    1: BEGIN
      left_color = working_color
      right_color = not_working_color
    END
    2: BEGIN
      left_color = not_working_color
      right_color = working_color
    END
  ENDCASE
  
  background = TVRD(TRUE=3)
  DEVICE, copy=[41,60,522,390,41,60,id_value]
  
  IF (x_min_selection GT x_min) THEN BEGIN
    X = x_min_selection - 0.5
    (*global).step2_pixel_left = X
    POLYFILL, [x_min, X, X, x_min], $
      [y_min, y_min, y_max, y_max], $
      color=FSC_COLOR(left_color), /data
  ENDIF
  
  IF (x_max_selection LT x_max) THEN BEGIN
    X = x_max_selection + 0.5
    (*global).step2_pixel_right = X
    POLYFILL, [X, x_max, x_max, X], $
      [y_min, y_min, y_max, y_max], $
      color=FSC_COLOR(right_color), /data
  ENDIF
  
  foreground = TVRD(TRUE=3)
  alpha= 0.25
  TV, (foreground*alpha)+(1-alpha)*background, true=3
  
END
