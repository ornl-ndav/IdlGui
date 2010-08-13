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
  base_array_error     = (*(*global).total_array_error_untouched)
  
;  x0 = (*global).step5_x0 ;lambda
;  y0 = (*global).step5_y0 ;pixel
;  x1 = (*global).step5_x1 ;lambda
;  y1 = (*global).step5_y1 ;pixel
  
;  xmin = MIN([x0,x1],MAX=xmax)
;  ymin = MIN([y0,y1],MAX=ymax)
;  ymin = FIX(ymin/2)
;  ymax = FIX(ymax/2)
; CHANGE CODE (RC Ward, 13 June 2010): 
; REPLACE SCREEN CAPTURE OF SCALING WITH THAT FROM STEP4 AS MODIFIED BY USER

;     xmin = (*global).step5_selection_savefrom_step4[0]
;     xmax = (*global).step5_selection_savefrom_step4[2]
;     ymin = (*global).step5_selection_savefrom_step4[1]
;     ymax = (*global).step5_selection_savefrom_step4[3]

     range = (*global).step5_selection_savefrom_step4
     xmin = range[0]
     xmax = range[2]
     ymin = range[1]
     ymax = range[3]
; Change code (RC Ward, 1 Aug 2010): print in status box the shifts employed
sxmin = STRING(xmin, FORMAT = '(I5)')
symin = STRING(ymin, FORMAT = '(I5)')
sxmax = STRING(xmax, FORMAT = '(I5)')
symax = STRING(ymax, FORMAT = '(I5)')
LogMessage = '> Step 5 (RECAP): Selection Window  xmin: ' + sxmin + '  xmax: ' + sxmax + '  ymin: ' + symin + '  symax: ' + symax
IDLsendToGeek_addLogBookText, Event, LogMessage      
  
  array_selected = base_array_untouched[xmin:xmax,ymin:ymax]
  y = (SIZE(array_selected))(2)
  array_selected_total = TOTAL(array_selected,2)/FLOAT(y)
  
  array_error_selected = base_array_error[xmin:xmax,ymin:ymax]
  array_error_selected_total = TOTAL(array_error_selected,2)/FLOAT(y)

  x_axis = (*(*global).x_axis)
  
  x_axis_selected = x_axis[xmin:xmax]
  
  IF (type EQ 'IvsQ') THEN BEGIN
    x_axis_in_Q = convert_from_lambda_to_Q(x_axis_selected)
    x_axis = x_axis_in_Q
  ENDIF ELSE BEGIN
    x_axis = x_axis_selected
  ENDELSE
  
  (*(*global).step5_selection_x_array) = x_axis
  (*(*global).step5_selection_y_array) = array_selected_total
  (*(*global).step5_selection_y_error_array) = array_error_selected_total
  
  xmin = MIN(x_axis,MAX=xmax)
  ymin = MIN(array_selected_total,MAX=ymax)
  
  (*global).x0y0x1y1 = [xmin,ymin,xmax,ymax]

     sxmin = STRCOMPRESS(xmin,/REMOVE_ALL)
     sxmax = STRCOMPRESS(xmax,/REMOVE_ALL)      
     symin = STRCOMPRESS(ymin,/REMOVE_ALL)
     symax = STRCOMPRESS(ymax,/REMOVE_ALL)
           
      (*global).X_Y_min_max_backup = [sxmin, symin, sxmax, symax]
      symin = STRCOMPRESS((*global).step4_ymin_global_value,/REMOVE_ALL)  
      putTextFieldValue, Event, 'step5_new_zoom_x_min', sxmin
      putTextFieldValue, Event, 'step5_new_zoom_x_max', sxmax
      putTextFieldValue, Event, 'step5_new_zoom_y_min', symin
      putTextFieldValue, Event, 'step5_new_zoom_y_max', symax
 
END

;------------------------------------------------------------------------------
PRO display_step5_rescale_plot, Event, with_range=with_range

  WIDGET_CONTROL, Event.top, GET_UVALUE=global

; Code change RCW (Feb 11, 2010): Get Background color from XML file
; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
  PlotBackground = (*global).BackgroundCurvePlot
  ref_plot_data_color = (*global).ref_plot_data_color
  ref_plot_error_color = (*global).ref_plot_error_color
  
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN
  ENDIF
  
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
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
  IF (N_ELEMENTS(with_range)) THEN BEGIN

; Change code (RC Ward, 29 April 2010): Add this code to pick up the axis scaling values

    xmin = getTextFieldValue(Event,'step5_new_zoom_x_min')
    xmax = getTextFieldValue(Event,'step5_new_zoom_x_max')
    ymin = getTextFieldValue(Event,'step5_new_zoom_y_min')
    ymax = getTextFieldValue(Event,'step5_new_zoom_y_max')
    xrange = [xmin,xmax]
    yrange = [ymin,ymax]

; Change code (RC Ward, 29 April 2010): comment out this code once the code above is set up  
;    x0y0x1y1 = (*global).x0y0x1y1_graph
;    xmin = MIN ([x0y0x1y1[0],x0y0x1y1[2]],MAX=xmax)
;    ymin = MIN ([x0y0x1y1[1],x0y0x1y1[3]],MAX=ymax)
;    xrange = [xmin,xmax]
;    yrange = [ymin,ymax]   
    ;    print, 'x0y0x1y1_graph[1]: ' + strcompress(x0y0x1y1[1])
    ;    print, 'x0y0x1y1_graph[3]: ' + strcompress(x0y0x1y1[3])
    ;
    ;    x0y0x1y1 = (*global).x0y0x1y1
    ;    print, 'x0y0x1y1[1]: ' + strcompress(x0y0x1y1[1])
    ;    print, 'x0y0x1y1[3]: ' + strcompress(x0y0x1y1[3])
    ;    print
    ;

; test for lin/log
    LinLog = getCWBgroupValue(Event, 'step5_rescale_lin_log_plot')

    IF (LinLog EQ 0) THEN BEGIN ;linear

    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XRANGE = xrange,$
      XSTYLE = 1,$
      YRANGE = yrange,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1
      
    ENDIF ELSE BEGIN ;log
 
     PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XRANGE = xrange,$
      XSTYLE = 1,$
      YRANGE = yrange,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1,$
      /YLOG
      
    ENDELSE
      
  ENDIF ELSE BEGIN

; test for lin/log
    LinLog = getCWBgroupValue(Event, 'step5_rescale_lin_log_plot')

    IF (LinLog EQ 0) THEN BEGIN ;linear
  
    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XSTYLE = 1,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1
      
    ENDIF ELSE BEGIN ;log

    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XSTYLE = 1,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1,$
      /YLOG

    ENDELSE

      
    xmin = MIN(x_axis,MAX=xmax)
    ymin = MIN(array_selected_total,MAX=ymax)
    (*global).x0y0x1y1_graph = [xmin,ymin,xmax,ymax]
    
  ENDELSE
  
  errplot, x_axis,$
    array_selected_total-array_error_selected_total,$
    array_selected_total+array_error_selected_total,$
    color = FSC_COLOR(ref_plot_error_color)
 
 ; Change in Code: Replot the data points on top of the error bars (RC Ward, Feb 11, 2010)
    OPLOT, x_axis, $
    array_selected_total, $
    color = FSC_COLOR(ref_plot_data_color), $
    PSYM=1
    
  !P.FONT = 0
  
END

;------------------------------------------------------------------------------
PRO display_step5_rescale_plot_from_zoom, Event, with_range=with_range

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
; Code change RCW (Feb 11, 2010): Get Background color from XML file
; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
  PlotBackground = (*global).BackgroundCurvePlot
  ref_plot_data_color = (*global).ref_plot_data_color
  ref_plot_error_color = (*global).ref_plot_error_color
  
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
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT

; Change code (RC Ward, 29 April 2010): Add this code to pick up the axis scaling values
    xmin = getTextFieldValue(Event,'step5_new_zoom_x_min')
    xmax = getTextFieldValue(Event,'step5_new_zoom_x_max')
    ymin = getTextFieldValue(Event,'step5_new_zoom_y_min')
    ymax = getTextFieldValue(Event,'step5_new_zoom_y_max')

; Change code (RC Ward, 29 April 2010): comment out this code once the code above is set up  
;  x0y0x1y1 = (*global).x0y0x1y1_graph
;  xmin = MIN ([x0y0x1y1[0],x0y0x1y1[2]],MAX=xmax)
;  ymin = MIN ([x0y0x1y1[1],x0y0x1y1[3]],MAX=ymax)

  xrange = [xmin,xmax]
  yrange = [ymin,ymax]
  
  ;    print, 'x0y0x1y1_graph[1]: ' + strcompress(x0y0x1y1[1])
  ;    print, 'x0y0x1y1_graph[3]: ' + strcompress(x0y0x1y1[3])
  ;
  ;    x0y0x1y1 = (*global).x0y0x1y1
  ;    print, 'x0y0x1y1[1]: ' + strcompress(x0y0x1y1[1])
  ;    print, 'x0y0x1y1[3]: ' + strcompress(x0y0x1y1[3])
  ;    print
  ;
  
  LinLog = getCWBgroupValue(Event, 'step5_rescale_lin_log_plot')

  IF (LinLog EQ 0) THEN BEGIN ;linear
  
    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XRANGE = xrange,$
      XSTYLE = 1,$
      YRANGE = yrange,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1
      
  ENDIF ELSE BEGIN ;log
  
    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XRANGE = xrange,$
      XSTYLE = 1,$
      YRANGE = yrange,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1,$
      /YLOG
      
  ENDELSE
  
  errplot, x_axis,$
    array_selected_total-array_error_selected_total,$
    array_selected_total+array_error_selected_total,$
    color = FSC_COLOR(ref_plot_error_color)
    
; Change in Code: Replot the data points on top of the error bars (RC Ward, Feb 11, 2010)
    OPLOT, x_axis, $
    array_selected_total, $
    color = FSC_COLOR(ref_plot_data_color), $
    PSYM=1

  !P.FONT = 0
  
END

;------------------------------------------------------------------------------
PRO display_step5_rescale_plot_first_time, Event
;print, "display_step5_rescale_plot_first_time"
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
; Code change RCW (Feb 11, 2010): Get Background color from XML file
; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
  PlotBackground = (*global).BackgroundCurvePlot
  ref_plot_data_color = (*global).ref_plot_data_color
  ref_plot_error_color  = (*global).ref_plot_error_color
  
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN
  ENDIF
  
  ;create array of data
;print, " in display_step5_rescale_plot_first_time - call to create_step5_selection_data"
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
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
 
; Change code (RC Ward, 29 April 2010): Add this code to pick up the axis scaling values
    xmin = getTextFieldValue(Event,'step5_new_zoom_x_min')
    xmax = getTextFieldValue(Event,'step5_new_zoom_x_max')
    ymin = getTextFieldValue(Event,'step5_new_zoom_y_min')
    ymax = getTextFieldValue(Event,'step5_new_zoom_y_max')

    xrange = [xmin,xmax]
    yrange = [ymin,ymax]
     
  LinLog = getCWBgroupValue(Event, 'step5_rescale_lin_log_plot')
  IF (LinLog EQ 0) THEN BEGIN ;linear
  
    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XSTYLE = 1,$
      XRANGE = xrange,$
      YSTYLE = 1,$
      RETAIN = 2, $
      YRANGE = yrange,$
;      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1
      
  ENDIF ELSE BEGIN
  
    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XSTYLE = 1,$
      XRANGE = xrange,$
      YSTYLE = 1,$
      RETAIN = 2, $
      YRANGE = yrange,$
      /YLOG,$
;      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1
      
  ENDELSE
  
  xmin = MIN(x_axis,MAX=xmax)
  ymin = MIN(array_selected_total,MAX=ymax)
  (*global).x0y0x1y1_graph = [xmin,ymin,xmax,ymax]
  
  errplot, x_axis,$
    array_selected_total-array_error_selected_total,$
    array_selected_total+array_error_selected_total,$
    color = FSC_COLOR(ref_plot_error_color)
 
  ; Change in Code: Replot the data points on top of the error bars (RC Ward, Feb 11, 2010)
    OPLOT, x_axis, $
    array_selected_total, $
    color = FSC_COLOR(ref_plot_data_color), $
    PSYM=1
 
  !P.FONT = 0
  
END

;------------------------------------------------------------------------------
PRO display_step5_rescale_after_rescale_during_zoom_selection, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
; Code change RCW (Feb 11, 2010): Get Background color from XML file
; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
  PlotBackground = (*global).BackgroundCurvePlot
  ref_plot_data_color = (*global).ref_plot_data_color
  ref_plot_error_color  = (*global).ref_plot_error_color
  
  ;create array of data
  ;create_step5_selection_data, Event
  
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
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
  LinLog = getCWBgroupValue(Event, 'step5_rescale_lin_log_plot')
  IF (LinLog EQ 0) THEN BEGIN ;linear
  
    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XSTYLE = 1,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1
      
  ENDIF ELSE BEGIN
  
    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XSTYLE = 1,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1,$
      /YLOG
      
  ENDELSE
  
  xmin = MIN(x_axis,MAX=xmax)
  ymin = MIN(array_selected_total,MAX=ymax)
  (*global).x0y0x1y1_graph = [xmin,ymin,xmax,ymax]
  
  errplot, x_axis,$
    array_selected_total-array_error_selected_total,$
    array_selected_total+array_error_selected_total,$
    color = FSC_COLOR(ref_plot_error_color)

  ; Change in Code: Replot the data points on top of the error bars (RC Ward, Feb 11, 2010)
    OPLOT, x_axis, $
    array_selected_total, $
    color = FSC_COLOR(ref_plot_data_color), $
    PSYM=1
    
  !P.FONT = 0
  
END

;------------------------------------------------------------------------------
PRO display_step5_rescale_reset_zoom, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
; Code change RCW (Feb 11, 2010): Get Background color from XML file
; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
  PlotBackground = (*global).BackgroundCurvePlot
  ref_plot_data_color = (*global).ref_plot_data_color
  ref_plot_error_color  = (*global).ref_plot_error_color
  
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
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
  LinLog = getCWBgroupValue(Event, 'step5_rescale_lin_log_plot')
  IF (LinLog EQ 0) THEN BEGIN ;linear
  
    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XSTYLE = 1,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1
      
  ENDIF ELSE BEGIN
  
    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XSTYLE = 1,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1,$
      /YLOG
      
  ENDELSE
  
  xmin = MIN(x_axis,MAX=xmax)
  ymin = MIN(array_selected_total,MAX=ymax)
  (*global).x0y0x1y1_graph = [xmin,ymin,xmax,ymax]
  (*global).x0y0x1y1 = [xmin,ymin,xmax,ymax]
  
;Code Change (RC Ward, Feb 11, 2010): Replot the data points on top of the error bars 
  errplot, x_axis,$
    array_selected_total-array_error_selected_total,$
    array_selected_total+array_error_selected_total,$
    color = FSC_COLOR(ref_plot_error_color) 
 
  oplot, x_axis, $
    array_selected_total, $
    color = FSC_COLOR(ref_plot_data_color), $
    PSYM=1

    
  !P.FONT = 0
  
END

;------------------------------------------------------------------------------
PRO redisplay_step5_rescale_plot, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ; Code change RCW (Feb 11, 2010): Get Background color from XML file
  PlotBackground = (*global).BackgroundCurvePlot
  ref_plot_data_color = (*global).ref_plot_data_color
  ref_plot_error_color  = (*global).ref_plot_error_color
  
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
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
; Change code (RC Ward, 29 April 2010): Add this code to pick up the axis scaling values
    xmin = getTextFieldValue(Event,'step5_new_zoom_x_min')
    xmax = getTextFieldValue(Event,'step5_new_zoom_x_max')
    ymin = getTextFieldValue(Event,'step5_new_zoom_y_min')
    ymax = getTextFieldValue(Event,'step5_new_zoom_y_max')

  
;  x0y0x1y1 = (*global).x0y0x1y1
  ;(*global).x0y0x1y1_graph = x0y0x1y1 (already commented out)
  
;  xmin = MIN ([x0y0x1y1[0],x0y0x1y1[2]],MAX=xmax)
;  ymin = MIN ([x0y0x1y1[1],x0y0x1y1[3]],MAX=ymax)
  xrange = [xmin,xmax]
  yrange = [ymin,ymax]
  
  LinLog = getCWBgroupValue(Event, 'step5_rescale_lin_log_plot')
  IF (LinLog EQ 0) THEN BEGIN ;linear
  
    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XRANGE = xrange,$
      XSTYLE = 1,$
      YRANGE = yrange,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1
      
  ENDIF ELSE BEGIN
  
    PLOT, x_axis, $
      array_selected_total, $
      XTITLE=x_axis_label, $
      YTITLE=y_axis_label,$
      XRANGE = xrange,$
      XSTYLE = 1,$
      YRANGE = yrange,$
      YSTYLE = 1,$
      CHARSIZE = 2,$
      BACKGROUND = FSC_COLOR(PlotBackground),$
      color = FSC_COLOR(ref_plot_data_color), $
      PSYM=1,$
      /YLOG
      
  ENDELSE
  
  errplot, x_axis,$
    array_selected_total-array_error_selected_total,$
    array_selected_total+array_error_selected_total,$
    color = FSC_COLOR(ref_plot_error_color)
    
  ; Change in Code: Replot the data points on top of the error bars (RC Ward, Feb 11, 2010)
    OPLOT, x_axis, $
    array_selected_total, $
     color = FSC_COLOR(ref_plot_data_color), $
    PSYM=1 
    
  !P.FONT = 0
  
END

;------------------------------------------------------------------------------
PRO redisplay_step5_rescale_plot_after_scaling, Event
;print, "redisplay_step5_rescale_plot_after_scaling"
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
; Code change RCW (Feb 11, 2010): Get Background color from XML file
; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
  PlotBackground = (*global).BackgroundCurvePlot
  ref_plot_data_color = (*global).ref_plot_data_color
  ref_plot_error_color  = (*global).ref_plot_error_color
  
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
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
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
  
  PLOT, x_axis, $
    array_selected_total, $
    XTITLE=x_axis_label, $
    YTITLE=y_axis_label,$
    XRANGE = xrange,$
    XSTYLE = 1,$
    YRANGE = yrange,$
    YSTYLE = 1,$
    CHARSIZE = 2,$
    BACKGROUND = FSC_COLOR(PlotBackground),$
    color = FSC_COLOR(ref_plot_data_color), $
    PSYM=1
    
  errplot, x_axis,$
    array_selected_total-array_error_selected_total,$
    array_selected_total+array_error_selected_total,$   
    color = FSC_COLOR(ref_plot_error_color) 

  ; Change in Code: Replot the data points on top of the error bars (RC Ward, Feb 11, 2010)
    OPLOT, x_axis, $
    array_selected_total, $
    color = FSC_COLOR(ref_plot_data_color), $
    PSYM=1

    
  !P.FONT = 0
  
END

;------------------------------------------------------------------------------
;plot selection for zoom
PRO plot_recap_rescale_selection, Event
;print, "plot_recap_rescale_selection"
  WIDGET_CONTROL, Event.top, GET_UVALUE=global

; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
  ref_plot_zoombox_color = (*global).ref_plot_zoombox_color
  
  x0 = (*global).recap_rescale_x0
  y0 = (*global).recap_rescale_y0
  x1 = (*global).recap_rescale_x1
  y1 = (*global).recap_rescale_y1
  
  xmin = MIN([x0,x1], MAX=xmax)
  ymin = MIN([y0,y1], MAX=ymax)
  
  DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
 
  color = FSC_COLOR(ref_plot_zoombox_color) 
  
  PLOTS, [xmin, xmin, xmax, xmax, xmin],$
    [ymin,ymax, ymax, ymin, ymin],$
    /DEVICE,$
    COLOR =color
    
END

;------------------------------------------------------------------------------
;plot selection for zoom
PRO plot_recap_rescale_CE_selection, Event
;print, "plot_recap_rescale_CE_selection"
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
  ref_plot_vertical_color = (*global).ref_plot_vertical_color
  
  x0y0x1y1 = (*global).x0y0x1y1_graph
  y0 = x0y0x1y1[1]
  y1 = x0y0x1y1[3]
  ymin = MIN([y0,y1],MAX=ymax)
  
  x0 = x0y0x1y1[0]
  x1 = x0y0x1y1[2]
  xmin = MIN([x0,x1],MAX=xmax)
  
  CURSOR, x, y, /DATA, /NOWAIT
  
  IF (x GE xmin AND $
    x LE xmax) THEN BEGIN
    
     color = FSC_COLOR(ref_plot_vertical_color)
    
    DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
    LOADCT, color_table, /SILENT
    
    PLOTS, x,ymin, $
    color=color, /DATA
    PLOTS, x,ymax, $
    color=color, /CONTINUE, /DATA
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO plot_recap_rescale_other_selection, Event, type=type
;print, "plot_recap_rescale_other_selection"
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
  ref_plot_vertical_color = (*global).ref_plot_vertical_color
  
  CASE (type) OF
    'left': x = (*global).recap_rescale_selection_left
    'right': x = (*global).recap_rescale_selection_right
    'all': BEGIN
      x1 = (*global).recap_rescale_selection_left
      x2 = (*global).recap_rescale_selection_right
    END
  ENDCASE
  
  DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
  x0y0x1y1 = (*global).x0y0x1y1_graph
  y0 = x0y0x1y1[1]
  y1 = x0y0x1y1[3]
  ymin = MIN([y0,y1],MAX=ymax)
  xa = x0y0x1y1[0]
  xb = x0y0x1y1[2]
  xmin = MIN([xa,xb],MAX=xmax)
  
  IF (type EQ 'all') THEN BEGIN
     color = FSC_COLOR(ref_plot_vertical_color)
    
    IF (x1 LT xmin) THEN BEGIN
      x1 = xmin
    ENDIF ELSE BEGIN
      IF (x1 GT xmax) THEN BEGIN
        x1 = xmax
      ENDIF
      PLOTS, x1,ymin, $
      color=color, /DATA
      PLOTS, x1,ymax, color=color, /CONTINUE, /DATA
    ENDELSE
    
    IF (x2 LT xmin) THEN BEGIN
      x2 = xmin
    ENDIF ELSE BEGIN
      IF (x2 GT xmax) THEN BEGIN
        x2 = xmax
      ENDIF
      PLOTS, x2,ymin, $
      color=color, /DATA
      PLOTS, x2,ymax, $
      color=color, /CONTINUE, /DATA
    ENDELSE
    
  ENDIF ELSE BEGIN
    x = (x LT xmin) ? xmin : x
    x = (x GT xmax) ? xmax : x
    PLOTS, x,ymin, $
    color=color, /DATA
    PLOTS, x,ymax, $
    color=color, /CONTINUE, /DATA
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO plot_selection_after_zoom, Event
;print, "plot_selection_after_zoom"
; Change Code (RC Ward, 8 June 2010): This code is now used to plot the selection box in Step 5
; It will be called initially to show the original selection box from Step 4
; and whenever there is a change in the selection box by the user
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
; Code Change (RC Ward, 8 June 2010): Change color to that of zoombox color
  ref_plot_zoombox_color = (*global).ref_plot_zoombox_color
  
  range = (*global).step5_selection_savefrom_step4
  
  DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
  y0 = range[1]
  y1 = range[3]
  ymin = MIN([y0,y1], MAX=ymax)
  x1 = range[0]
  x2 = range[2]
  xmin = MIN([x1,x2],MAX=xmax)
  
;print, "in plot_selection_after_zoom: selection box is: ", xmin, xmax, ymin, ymax  
;  color = ref_plot_zoombox_color
     color = FSC_COLOR(ref_plot_zoombox_color)
  
    PLOTS, xmin,ymin, color=color, /DATA
    PLOTS, xmin,ymax, color=color, /CONTINUE, /DATA
 
    PLOTS, xmax,ymin, color=color, /DATA
    PLOTS, xmax,ymax, color=color, /CONTINUE, /DATA
    
    PLOTS, xmin,ymin, color=color, /DATA
    PLOTS, xmax,ymin, color=color, /CONTINUE, /DATA
 
    PLOTS, xmin,ymax, color=color, /DATA
    PLOTS, xmax,ymax, color=color, /CONTINUE, /DATA
 
END

;------------------------------------------------------------------------------
;PRO enabled_or_not_recap_rescale_button, Event
;print, "enabled_or_not_recap_rescale_button"
;  WIDGET_CONTROL, Event.top, GET_UVALUE=global
;  
;  x1 = (*global).recap_rescale_selection_left
;  x2 = (*global).recap_rescale_selection_right
;  
;  IF (x1 NE 0. AND x2 NE 0.) THEN BEGIN
;    status = 1
;  ENDIF ELSE BEGIN
;    status = 0
;  ENDELSE
;  activate_widget, Event, 'step5_rescale_scale_to_1', status
;  
;END

;------------------------------------------------------------------------------
PRO calculate_average_recap_rescale, Event
;print, "calculate_average_recap_rescale"
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
    array_selected_total_error = (*(*global).step5_selection_y_error_array)
    Average = MEAN(array_selected_total[Index_min:Index_max])
    Scaling_factor = Average
    
    (*global).step5_scaling_factor = scaling_factor
    
    (*(*global).array_selected_total_backup) = array_selected_total
    array_selected_total = array_selected_total / Average
    (*(*global).step5_selection_y_array) = array_selected_total
    
    (*(*global).array_selected_total_error_backup) = array_selected_total_error
    array_selected_total_error = array_selected_total_error / Average
    (*(*global).step5_selection_y_error_array) = array_selected_total_error
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO plot_average_recap_rescale, Event
;print, "plot_average_recap_rescale"
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
  ref_plot_average_color = (*global).ref_plot_average_color
  
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
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
    LOADCT, color_table, /SILENT
    
;    color = ref_plot_average_color
     color = FSC_COLOR(ref_plot_average_color)
    PLOTS, xmin,Average, $
    color=color, /DATA
    PLOTS, xmax,Average, $
    color=color, /CONTINUE, /DATA
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO replot_average_recap_rescale, Event
;print, "replot_average_recap_rescale"
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
  ref_plot_average_color = (*global).ref_plot_average_color
    
  x1 = (*global).recap_rescale_selection_left
  x2 = (*global).recap_rescale_selection_right
  xmin = MIN([x1,x2],MAX=xmax)
  
  ;  x0y0x1y1 = (*global).x0y0x1y1
  ;  xa = x0y0x1y1[0]
  ;  xb = x0y0x1y1[2]
  ;  x_range_min = MIN([xa,xb],MAX=x_range_max)
  
  average = (*global).recap_rescale_average
  
  x0y0x1y1 = (*global).x0y0x1y1_graph
  xa = x0y0x1y1[0]
  xb = x0y0x1y1[2]
  x_range_min = MIN([xa,xb],MAX=x_range_max)
  ;  print, 'x_range_min: ' + string(x_range_min)
  ;  print, 'x_range_max: ' + string(x_range_max)
  
  IF (xmin LT x_range_min) THEN BEGIN
    xmin = x_range_min
  ENDIF ELSE BEGIN
    IF (xmax GT x_range_max) THEN BEGIN
      xmax = x_range_max
    ENDIF
  ENDELSE
  
  IF (average NE 0.0) THEN BEGIN
  
    DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
    LOADCT, color_table, /SILENT
    
;    color = ref_plot_average_color
     color = FSC_COLOR(ref_plot_average_color)
    PLOTS, xmin,Average, $
    color=color, /DATA
    PLOTS, xmax,Average, $
    color=color, /CONTINUE, /DATA
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO plot_average_1_recap_rescale, Event ;plot the average horizontal value
;print, "plot_average_1_recap_rescale"
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
; Code change RCW (Feb 12, 2010): Get line plot colors from XML file
  ref_plot_horizontal_color = (*global).ref_plot_horizontal_color
  
  x1 = (*global).recap_rescale_selection_left
  x2 = (*global).recap_rescale_selection_right
  xmin = MIN([x1,x2],MAX=xmax)
  
  DEVICE, DECOMPOSED=0
; Change code (RC Ward Feb 22, 2010): Pass color_table value for LOADCT from XML configuration file
  color_table = (*global).color_table
  LOADCT, color_table, /SILENT
  
  color = FSC_COLOR(ref_plot_horizontal_color)
  PLOTS, xmin, 1., $
  color=color, /DATA
  PLOTS, xmax, 1., $
  color=color, /CONTINUE, /DATA
  
  (*global).recap_rescale_average = 1
  
END

;------------------------------------------------------------------------------
PRO define_default_recap_output_file, Event
;print, "define_default_recap_output_file"
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
    
  list_of_ascii_files = (*(*global).list_of_ascii_files)
  
  selection_value = getCWBgroupValue(Event,'step5_selection_group_uname')
  CASE (selection_value) OF
    1: BEGIN ;IvsQ
      ext = 'IvsQ.txt'
    END
    2: BEGIN ;IvsLambda
      ext = 'IvsLambda.txt'
    END
  ENDCASE
  
  ;get list of run numbers
  ;run_numbers = getRunNumbersFromAscii(*(*global).list_of_ascii_files)i
  ;run_ext = STRJOIN(run_numbers,'_')
  
  ;get nbr of data files
  sz = N_ELEMENTS(list_of_ascii_files)
  
  ;get first part of name
  ;path = FILE_DIRNAME(list_of_ascii_files[0])
  short_file_name = FILE_BASENAME(list_of_ascii_files[0],'.txt')
  
  ;create default output file name
  output_file = short_file_name
  output_file += '_' + STRCOMPRESS(sz,/REMOVE_ALL) + 'Files'
  output_file += '_' + ext
  
  putTextFieldValue, Event, 'step5_file_name_i_vs_q', output_file
  
  activate_widget, Event, 'step5_create_button_i_vs_q', 1
  ;check if preview button can be validated or not
  update_step5_preview_button, Event ;step5
  
END
PRO step5_rescale_populate_zoom_widgets, Event  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
;  print, "inside step5_rescale_populate_zoom_widgets"
; Change code (RC Ward, 7 June 2010): This routine gets the coordinates of the selection box
; in STEP4 and applies it to STEP5, putting xmin, xmax, ymin, ymax into the boxes
;  
     range = (*global).step5_selection_savefrom_step4
     xmin = range[0]
     xmax = range[2]
     ymin = range[1]
     ymax = range[3]
;           
     sxmin = STRCOMPRESS(xmin,/REMOVE_ALL)
     sxmax = STRCOMPRESS(xmax,/REMOVE_ALL)      
     symin = STRCOMPRESS(ymin,/REMOVE_ALL)
     symax = STRCOMPRESS(ymax,/REMOVE_ALL)      
;
;print, "step5_rescale_populate_zoom_widgets - sxmin: ", sxmin, " sxmax: ", sxmax, " symin: ", symin, " symax: ",symax   
      putTextFieldValue, Event, 'step5_selection_info_xmin_value', sxmin
      putTextFieldValue, Event, 'step5_selection_info_xmax_value', sxmax
      putTextFieldValue, Event, 'step5_selection_info_ymin_value', symin
      putTextFieldValue, Event, 'step5_selection_info_ymax_value', symax
;      
END
