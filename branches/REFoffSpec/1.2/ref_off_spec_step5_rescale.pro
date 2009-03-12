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

PRO create_step5_selection_data, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
  CASE (selection_value) OF
    1: type = 'IvsQ'
    2: type = 'IvsLambda'
  ENDCASE
  
  WIDGET_CONTROL, /HOURGLASS
  
  base_array_untouched = (*(*global).total_array_untouched)
  base_array_error     = (*(*global).total_array_error)
  
  x0 = (*global).step5_x0 ;lambda
  y0 = (*global).step5_y0 ;pixel
  x1 = (*global).step5_x1 ;lambda
  y1 = (*global).step5_y1 ;pixel
  
  xmin = MIN([x0,x1],MAX=xmax)
  ymin = MIN([y0,y1],MAX=ymax)
  ymin = FIX(ymin/2)
  ymax = FIX(ymax/2)
  
  array_selected = base_array_untouched[xmin:xmax,ymin:ymax]
  y = (size(array_selected))(2)
  array_selected_total = TOTAL(array_selected,2)/FLOAT(y)
  
  array_error_selected = base_array_error[xmin:xmax,ymin:ymax]
  array_error_selected_total = TOTAL(array_error_selected,2)/FLOAT(y)
  
  x_axis = (*(*global).x_axis)
  
  x_axis_selected = x_axis[xmin:xmax]
  x_axis_in_Q = convert_from_lambda_to_Q(x_axis_selected)
  
  IF (type EQ 'IvsQ') THEN BEGIN
    x_axis = x_axis_in_Q
  ENDIF ELSE BEGIN
    x_axis = x_axis_selected
  ENDELSE
  
  (*(*global).step5_selection_x_array) = x_axis
  (*(*global).step5_selection_y_array) = array_selected_total
  (*(*global).step5_selection_y_error_array) = array_error_selected_total
  
END

;------------------------------------------------------------------------------
PRO display_step5_rescale_plot, Event, with_range=with_range

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;create array of data
  create_step5_selection_data, Event
  
  selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
  CASE (selection_value) OF
    1: type = 'IvsQ'
    2: type = 'IvsLambda'
  ENDCASE
  
  !P.FONT = 1
  IF (type EQ 'IvsQ') THEN BEGIN
    x_axis_label = 'Q( Angstroms!E-1!N )'
  ENDIF ELSE BEGIN
    x_axis_label = 'Lambda_T (Angstroms)'
  ENDELSE
  
  y_axis_label = 'Intensity'
  
  x_axis = (*(*global).step5_selection_x_array)
  array_selected_total = (*(*global).step5_selection_y_array)
  array_error_selected_total = (*(*global).step5_selection_y_error_array)
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_rescale_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  
  IF (N_ELEMENTS(with_range)) THEN BEGIN
  
    x0y0x1y1 = (*global).x0y0x1y1
    xmin = MIN ([x0y0x1y1[0],x0y0x1y1[2]],MAX=xmax)
    ymin = MIN ([x0y0x1y1[1],x0y0x1y1[3]],MAX=ymax)
    xrange = [xmin,xmax]
    yrange = [ymin,ymax]
    
    plot, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XRANGE = xrange,$
      XSTYLE = 1,$
      YRANGE = yrange,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      PSYM=1
      
  ENDIF ELSE BEGIN
  
    plot, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XSTYLE = 1,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      PSYM=1
      
    xmin = MIN(x_axis,MAX=xmax)
    ymin = MIN(array_selected_total,MAX=ymax)
    (*global).x0y0x1y1_graph = [xmin,ymin,xmax,ymax]
    
  ENDELSE
  
  errplot, x_axis,$
    array_selected_total-array_error_selected_total,$
    array_selected_total+array_error_selected_total,$
    color=150
    
  !P.FONT = 0
  
END

;------------------------------------------------------------------------------
PRO display_step5_rescale_reset_zoom, Event, with_range=with_range

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
  CASE (selection_value) OF
    1: type = 'IvsQ'
    2: type = 'IvsLambda'
  ENDCASE
  
  !P.FONT = 1
  IF (type EQ 'IvsQ') THEN BEGIN
    x_axis_label = 'Q( Angstroms!E-1!N )'
  ENDIF ELSE BEGIN
    x_axis_label = 'Lambda_T (Angstroms)'
  ENDELSE
  
  y_axis_label = 'Intensity'
  
  x_axis = (*(*global).step5_selection_x_array)
  array_selected_total = (*(*global).step5_selection_y_array)
  array_error_selected_total = (*(*global).step5_selection_y_error_array)
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_rescale_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  
  IF (N_ELEMENTS(with_range)) THEN BEGIN
  
    x0y0x1y1 = (*global).x0y0x1y1
    xmin = MIN ([x0y0x1y1[0],x0y0x1y1[2]],MAX=xmax)
    ymin = MIN ([x0y0x1y1[1],x0y0x1y1[3]],MAX=ymax)
    xrange = [xmin,xmax]
    yrange = [ymin,ymax]
    
    plot, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XRANGE = xrange,$
      XSTYLE = 1,$
      YRANGE = yrange,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      PSYM=1
      
  ENDIF ELSE BEGIN
  
    plot, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XSTYLE = 1,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      PSYM=1
      
    xmin = MIN(x_axis,MAX=xmax)
    ymin = MIN(array_selected_total,MAX=ymax)
    (*global).x0y0x1y1_graph = [xmin,ymin,xmax,ymax]
    
  ENDELSE
  
  errplot, x_axis,$
    array_selected_total-array_error_selected_total,$
    array_selected_total+array_error_selected_total,$
    color=150
    
  !P.FONT = 0
  
END

;------------------------------------------------------------------------------
PRO redisplay_step5_rescale_plot, Event

  print, 'in redisplay_step5_rescale_plot'

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
  CASE (selection_value) OF
    1: type = 'IvsQ'
    2: type = 'IvsLambda'
  ENDCASE
  
  !P.FONT = 1
  IF (type EQ 'IvsQ') THEN BEGIN
    x_axis_label = 'Q( Angstroms!E-1!N )'
  ENDIF ELSE BEGIN
    x_axis_label = 'Lambda_T (Angstroms)'
  ENDELSE
  
  y_axis_label = 'Intensity'
  
  x_axis = (*(*global).step5_selection_x_array)
  array_selected_total = (*(*global).step5_selection_y_array)
  array_error_selected_total = (*(*global).step5_selection_y_error_array)
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_rescale_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  
  x0y0x1y1 = (*global).x0y0x1y1
  ;(*global).x0y0x1y1_graph = x0y0x1y1
  
  
  
  xmin = MIN ([x0y0x1y1[0],x0y0x1y1[2]],MAX=xmax)
  ymin = MIN ([x0y0x1y1[1],x0y0x1y1[3]],MAX=ymax)
  xrange = [xmin,xmax]
  yrange = [ymin,ymax]
  
  print, 'yrange:'
  print, yrange
  
  plot, x_axis, $
    array_selected_total, $
    XTITLE=x_axis_label, $
    YTITLE=y_axis_label,$
    XRANGE = xrange,$
    XSTYLE = 1,$
    YRANGE = yrange,$
    YSTYLE = 1,$
    CHARSIZE = 2,$
    PSYM=1
    
  errplot, x_axis,$
    array_selected_total-array_error_selected_total,$
    array_selected_total+array_error_selected_total,$
    color=150
    
  !P.FONT = 0
  
END

;------------------------------------------------------------------------------
PRO redisplay_step5_rescale_plot_after_scaling, Event

  print, 'in redisplay_step5_rescale_plot_after_scaling'

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
  CASE (selection_value) OF
    1: type = 'IvsQ'
    2: type = 'IvsLambda'
  ENDCASE
  
  !P.FONT = 1
  IF (type EQ 'IvsQ') THEN BEGIN
    x_axis_label = 'Q( Angstroms!E-1!N )'
  ENDIF ELSE BEGIN
    x_axis_label = 'Lambda_T (Angstroms)'
  ENDELSE
  
  y_axis_label = 'Intensity'
  
  x_axis = (*(*global).step5_selection_x_array)
  array_selected_total = (*(*global).step5_selection_y_array)
  array_error_selected_total = (*(*global).step5_selection_y_error_array)
  
  id_draw = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_rescale_draw')
  WIDGET_CONTROL, id_draw, GET_VALUE=id_value
  WSET,id_value
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  
  x0y0x1y1 = (*global).x0y0x1y1
  
  xmin = MIN ([x0y0x1y1[0],x0y0x1y1[2]],MAX=xmax)
  ymin = 0
  ymax = 1.2
  ;ymin = MIN ([x0y0x1y1[1],x0y0x1y1[3]],MAX=ymax)
  xrange = [xmin,xmax]
  yrange = [ymin,ymax]
  
  x0y0x1y1_graph = (*global).x0y0x1y1_graph
  x0y0x1y1_graph[1] = ymin
  x0y0x1y1_graph[3] = ymax
  (*global).x0y0x1y1_graph = x0y0x1y1_graph 
  
  plot, x_axis, $
    array_selected_total, $
    XTITLE=x_axis_label, $
    YTITLE=y_axis_label,$
    XRANGE = xrange,$
    XSTYLE = 1,$
    YRANGE = yrange,$
    YSTYLE = 1,$
    CHARSIZE = 2,$
    PSYM=1
    
  errplot, x_axis,$
    array_selected_total-array_error_selected_total,$
    array_selected_total+array_error_selected_total,$
    color=150
    
  !P.FONT = 0
  
END

;------------------------------------------------------------------------------
;plot selection for zoom
PRO plot_recap_rescale_selection, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  x0 = (*global).recap_rescale_x0
  y0 = (*global).recap_rescale_y0
  x1 = (*global).recap_rescale_x1
  y1 = (*global).recap_rescale_y1
  
  xmin = MIN([x0,x1], MAX=xmax)
  ymin = MIN([y0,y1], MAX=ymax)
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  
  color = 150
  
  plots, [xmin, xmin, xmax, xmax, xmin],$
    [ymin,ymax, ymax, ymin, ymin],$
    /DEVICE,$
    COLOR =color
    
END

;------------------------------------------------------------------------------
;plot selection for zoom
PRO plot_recap_rescale_CE_selection, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  x0y0x1y1 = (*global).x0y0x1y1_graph
  y0 = x0y0x1y1[1]
  y1 = x0y0x1y1[3]
  
  ymin = MIN([y0,y1], MAX=ymax)
  
  color = 50
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  
  cursor, x, y, /DATA, /NOWAIT
  
  plots, x,ymin, color=color, /DATA
  plots, x,ymax, color=color, /CONTINUE, /DATA
  
END

;------------------------------------------------------------------------------
PRO plot_recap_rescale_other_selection, Event, type=type

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  CASE (type) OF
    'left': x = (*global).recap_rescale_selection_left
    'right': x = (*global).recap_rescale_selection_right
    'all': BEGIN
      x1 = (*global).recap_rescale_selection_left
      x2 = (*global).recap_rescale_selection_right
    END
  ENDCASE
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  
  x0y0x1y1 = (*global).x0y0x1y1_graph
  y0 = x0y0x1y1[1]
  y1 = x0y0x1y1[3]
  ymin = MIN([y0,y1], MAX=ymax)
  
  print, 'in plot_recap_rescale_other_selection'
  print, 'y0: ' + strcompress(y0)
  print, 'y1: ' + strcompress(y1)
  
  IF (type EQ 'all') THEN BEGIN
    ;    x0y0x1y1 = (*global).x0y0x1y1
    ;    y0 = x0y0x1y1[1]
    ;    y1 = x0y0x1y1[3]
    ;    ymin = MIN([y0,y1], MAX=ymax)
    ;
    ;    print, x0y0x1y1
  
    color = 50
    plots, x1,ymin, color=color, /DATA
    plots, x1,ymax, color=color, /CONTINUE, /DATA
    plots, x2,ymin, color=color, /DATA
    plots, x2,ymax, color=color, /CONTINUE, /DATA
  ENDIF ELSE BEGIN
    plots, x,ymin, color=color, /DATA
    plots, x,ymax, color=color, /CONTINUE, /DATA
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO enabled_or_not_recap_rescale_button, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  x1 = (*global).recap_rescale_selection_left
  x2 = (*global).recap_rescale_selection_right
  
  IF (x1 NE 0. AND x2 NE 0.) THEN BEGIN
    status = 1
  ENDIF ELSE BEGIN
    status = 0
  ENDELSE
  activate_widget, Event, 'step5_rescale_scale_to_1', status
  
END

;------------------------------------------------------------------------------
PRO calculate_average_recap_rescale, Event

  print,'in calculate_average_recap_rescale'

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  x1 = (*global).recap_rescale_selection_left
  x2 = (*global).recap_rescale_selection_right
  
  xmin = MIN([x1,x2],MAX=xmax)
  
  ;calculate average if left and right selection
  IF (x1 NE 0. AND x2 NE 0.) THEN BEGIN
  
    x_axis = (*(*global).step5_selection_x_array)
    aIndex = getArrayRangeFromlda1lda2(x_axis, xmin, xmax)
    Index_min = aIndex[0]
    Index_max = aIndex[1]
    
    array_selected_total = (*(*global).step5_selection_y_array)
    Average = MEAN(array_selected_total[Index_min:Index_max])
    Scaling_factor = Average
    
    (*(*global).array_selected_total_backup) = array_selected_total
    array_selected_total = array_selected_total / Average

    (*(*global).step5_selection_y_array) = array_selected_total
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO plot_average_recap_rescale, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  x1 = (*global).recap_rescale_selection_left
  x2 = (*global).recap_rescale_selection_right
  
  xmin = MIN([x1,x2],MAX=xmax)
  
  ;calculate average if left and right selection
  IF (x1 NE 0. AND x2 NE 0.) THEN BEGIN
  
    x_axis = (*(*global).step5_selection_x_array)
    aIndex = getArrayRangeFromlda1lda2(x_axis, xmin, xmax)
    Index_min = aIndex[0]
    Index_max = aIndex[1]
    
    array_selected_total = (*(*global).step5_selection_y_array)
    Average = MEAN(array_selected_total[Index_min:Index_max])
    (*global).recap_rescale_average = average
    
    DEVICE, DECOMPOSED=0
    LOADCT, 5, /SILENT
    
    color = 200
    plots, xmin,Average, color=color, /DATA
    plots, xmax,Average, color=color, /CONTINUE, /DATA
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO replot_average_recap_rescale, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  x1 = (*global).recap_rescale_selection_left
  x2 = (*global).recap_rescale_selection_right
  xmin = MIN([x1,x2],MAX=xmax)
  
  average = (*global).recap_rescale_average
  
  IF (average NE 0.0) THEN BEGIN
  
    DEVICE, DECOMPOSED=0
    LOADCT, 5, /SILENT
    
    color = 200
    plots, xmin,Average, color=color, /DATA
    plots, xmax,Average, color=color, /CONTINUE, /DATA
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO plot_average_1_recap_rescale, Event ;plot the average horizontal value

  print, 'in plot_average_1_recap_rescale'
  
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  x1 = (*global).recap_rescale_selection_left
  x2 = (*global).recap_rescale_selection_right
  xmin = MIN([x1,x2],MAX=xmax)
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  
  color = 150
  plots, xmin, 1., color=color, /DATA
  plots, xmax, 1., color=color, /CONTINUE, /DATA
  
  (*global).recap_rescale_average = 1
  
END
