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

FUNCTION isLinSelected, Event

  id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME='full_detector_count_vs_tof_linear_plot')
  value = WIDGET_INFO(id, /BUTTON_SET)
  RETURN, value
END

;----------------------------------------------------------------------------
FUNCTION isInsideDrawingRegion, Event, x, y

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  IF (x LT (*global1).device_xmin OR $
    x GT (*global1).device_xmax OR $
    y LT (*global1).device_ymin OR $
    y GT (*global1).device_ymax) THEN RETURN, 0
    
  RETURN, 1
END

;------------------------------------------------------------------------------
PRO launch_couts_vs_tof_base_Event, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  CASE event.id OF
  
    ;selection tool selected
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME = 'full_detector_counts_vs_tof_selection_tool'): BEGIN
      MapBase, Event, 'selection_base', 1
      MapBase, Event, 'zoom_base', 0
    END
    
    ;zoom tool selected
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME = 'full_detector_counts_vs_tof_zoom_tool'): BEGIN
      MapBase, Event, 'selection_base', 0
      MapBase, Event, 'zoom_base', 1
    END
    
    ;draw plot
    WIDGET_INFO(Event.top, $
      FIND_BY_UNAME='counts_vs_tof_main_base_draw'): BEGIN
      
      ;if in selection mode only ===================
      IF (isButtonSelected(Event, $
        'full_detector_counts_vs_tof_selection_tool')) THEN BEGIN
        
        ;if we are inside
        IF (isInsideDrawingRegion(Event, Event.x, Event.y)) THEN BEGIN
        
          IF (event.release EQ 1) THEN BEGIN ;release left click
            (*global1).left_click = 0b
          ENDIF
          
          IF (event.press NE 4) THEN BEGIN
            IF (event.type EQ 0) THEN BEGIN ;left click
              (*global1).left_click = 1b
              CURSOR, x_data, y_data, /DATA
              x_device = Event.x
              y_device = Event.y
              x0y0x1y1_data = (*global1).x0y0x1y1_data
              x0y0x1y1_device = (*global1).x0y0x1y1_device
              IF ((*global1).left_clicked) THEN BEGIN
                x0y0x1y1_data[0] = x_data
                x0y0x1y1_data[1] = y_data
                x0y0x1y1_device[0] = x_device
                x0y0x1y1_device[1] = y_device
              ENDIF ELSE BEGIN
                x0y0x1y1_data[2] = x_data
                x0y0x1y1_data[3] = y_data
                x0y0x1y1_device[2] = x_device
                x0y0x1y1_device[3] = y_device
              ENDELSE
              (*global1).x0y0x1y1_data = x0y0x1y1_data
              (*global1).x0y0x1y1_device = x0y0x1y1_device
              ;replot the background counts vs tof file
              replot_counts_vs_tof_full_detector, Event
              display_selection, Event
            ENDIF
            calculate_average_value, Event
          ENDIF
          
          IF (event.type EQ 2 AND $ ;moving the mouse with left click
            (*global1).left_click) THEN BEGIN
            CURSOR, x_data, y_data, /DATA
            x_device = Event.x
            y_device = Event.y
            x0y0x1y1_data = (*global1).x0y0x1y1_data
            x0y0x1y1_device = (*global1).x0y0x1y1_device
            IF ((*global1).left_clicked) THEN BEGIN
              x0y0x1y1_data[0] = x_data
              x0y0x1y1_data[1] = y_data
              x0y0x1y1_device[0] = x_device
              x0y0x1y1_device[1] = y_device
            ENDIF ELSE BEGIN
              x0y0x1y1_data[2] = x_data
              x0y0x1y1_data[3] = y_data
              x0y0x1y1_device[2] = x_device
              x0y0x1y1_device[3] = y_device
            ENDELSE
            (*global1).x0y0x1y1_data = x0y0x1y1_data
            (*global1).x0y0x1y1_device = x0y0x1y1_device
            ;replot the background counts vs tof file
            replot_counts_vs_tof_full_detector, Event
            display_selection, Event
            calculate_average_value, Event
          ENDIF
          
          IF (event.press EQ 4) THEN BEGIN ;right click
            switch_left_right_click, Event
          ENDIF
          
        ENDIF ;end of 'if we are inside drawing region'
        
      ENDIF ELSE BEGIN ; Zoom button selected =======================
      
        IF (Event.press EQ 1) THEN BEGIN ;left mouse pressed
        
          ;if we are outside, reset
          IF (~isInsideDrawingRegion(Event, Event.x, Event.y)) THEN BEGIN
            (*global1).x0_data = 0.
            (*global1).y0_data = 0.
            (*global1).x1_data = 0.
            (*global1).y1_data = 0.
            (*global1).x0_data_backup = (*global1).x0_data
            (*global1).y0_data_backup = (*global1).y0_data
            (*global1).x1_data_backup = (*global1).x1_data
            (*global1).y1_data_backup = (*global1).y1_data
            (*global1).display_xmin = (*global1).display_xmin_backup
            (*global1).display_ymin = (*global1).display_ymin_backup
            (*global1).display_xmax = (*global1).display_xmax_backup
            (*global1).display_ymax = (*global1).display_ymax_backup
            replot_counts_vs_tof_full_detector, event
            display_selection, Event ;that produces average line
            replot_average, Event
            
          ENDIF ELSE BEGIN
          
            (*global1).left_mouse_pressed = 1
            CURSOR, X, Y, /data, /nowait
            (*global1).x0_data = X
            (*global1).y0_data = Y
            (*global1).x0_device = Event.x
            (*global1).y0_device = Event.y
            
          ENDELSE
          
        ENDIF
        
        IF (Event.type EQ 2) THEN BEGIN ;moving mouse with left button clicked
          IF ((*global1).left_mouse_pressed) THEN BEGIN
            (*global1).x1_device = Event.x
            (*global1).y1_device = Event.y
            ;refresh plot only if we still are inside the plotting area
            IF (isInsideDrawingRegion(Event, Event.x, Event.y)) THEN BEGIN
              ;MovingMouseInTof, Event
              ;replot the background counts vs tof file
              replot_counts_vs_tof_full_detector, Event, MOVING='yes'
              plotSelection_inCountsVsTofPlot, Event
              display_selection, Event ;that produces average line
              replot_average, Event
            ENDIF
          ENDIF
        ENDIF
        
        IF (Event.release EQ 1) THEN BEGIN ;left mouse released
          IF ((*global1).left_mouse_pressed) THEN BEGIN
            CURSOR, X, Y, /data, /nowait
            (*global1).x1_data = X
            (*global1).y1_data = Y
            redefine_xy_display_limit, Event
            replot_counts_vs_tof_full_detector, Event
            display_selection, Event
            replot_average, Event
            (*global1).left_mouse_pressed = 0
            (*global1).x0_data_backup = (*global1).x0_data
            (*global1).y0_data_backup = (*global1).y0_data
            (*global1).x1_data_backup = (*global1).x1_data
            (*global1).y1_data_backup = (*global1).y1_data
            
          ENDIF
        ENDIF
        
      ENDELSE
      
    END
    
    ;linear plot
    WIDGET_INFO(event.top, $
      FIND_BY_UNAME='full_detector_count_vs_tof_linear_plot'): BEGIN
      replot_counts_vs_tof_full_detector, event, MOVING=moving
      display_selection, Event
      average = (*global1).average
      IF (average NE 'N/A') THEN plot_average, Event, DOUBLE(average)
    END
    
    ;log plot
    WIDGET_INFO(event.top, $
      FIND_BY_UNAME='full_detector_count_vs_tof_log_plot'): BEGIN
      replot_counts_vs_tof_full_detector, event, MOVING=moving
      display_selection, Event
      average = (*global1).average
      IF (average NE 'N/A') THEN plot_average, Event, DOUBLE(average)
    END
    
    ELSE:
  ENDCASE
  
END

;-----------------------------------------------------------------------------
PRO redefine_xy_display_limit, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  x0 = (*global1).x0_data
  x1 = (*global1).x1_data
  y0 = (*global1).y0_data
  y1 = (*global1).y1_data
  
  xmin = MIN([x0,x1], MAX=xmax)
  ymin = MIN([y0,y1], MAX=ymax)
  
  (*global1).display_xmin = xmin
  (*global1).display_xmax = xmax
  (*global1).display_ymin = ymin
  (*global1).display_ymax = ymax
  
END

;-----------------------------------------------------------------------------
PRO plotSelection_inCountsVsTofPlot, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  x0 = (*global1).x0_device
  x1 = (*global1).x1_device
  y0 = (*global1).y0_device
  y1 = (*global1).y1_device
  
  IF (x0 EQ 0. AND x1 EQ 0.) THEN RETURN
  
  xmin = MIN([x0,x1], MAX=xmax)
  ymin = MIN([y0,y1], MAX=ymax)
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  
  color = 150
  
  id = WIDGET_INFO(Event.top,find_by_uname='counts_vs_tof_main_base_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  PLOTS, [xmin, xmin, xmax, xmax, xmin],$
    [ymin,ymax, ymax, ymin, ymin],$
    /DEVICE,$
    LINESTYLE = 3,$
    COLOR =color
    
END

;------------------------------------------------------------------------------
PRO  plot_average, Event, average

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  x0y0x1y1_data = (*global1).x0y0x1y1_data
  x0x1 = [x0y0x1y1_data[0],x0y0x1y1_data[2]]
  xmin = MIN(x0x1,MAX=xmax)
  
  IF (average LT (*global1).display_ymin) THEN RETURN
  IF (average GT (*global1).display_ymax) THEN RETURN
  
  PLOTS, xmin, average,/DATA
  PLOTS, xmax, average,/CONTINUE, COLOR=200,/DATA
  
END

;------------------------------------------------------------------------------
PRO  replot_average, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  average = (*global1).average
  
  x0y0x1y1_data = (*global1).x0y0x1y1_data
  x0x1 = [x0y0x1y1_data[0],x0y0x1y1_data[2]]
  xmin = MIN(x0x1,MAX=xmax)
  
  PLOTS, xmin, average,/DATA
  PLOTS, xmax, average,/CONTINUE, COLOR=200,/DATA
  
END

;------------------------------------------------------------------------------
PRO calculate_average_value, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  counts_vs_tof_integrated= (*(*global1).counts_vs_tof_array_integrated)
  x0y0x1y1_data = (*global1).x0y0x1y1_data
  x0x1_data = [x0y0x1y1_data[0],x0y0x1y1_data[2]]
  xmin_data = MIN(x0x1_data,MAX=xmax_data)
  
  IF (xmin_data EQ -1L) THEN RETURN
  IF (xmax_data EQ -1L) THEN RETURN
  
  plot_type = (*global1).plot_type
  IF (plot_type EQ 'tof') THEN BEGIN ;tof mode
    tof_array = (*(*global1).tof_array)
    index_min_array = WHERE(tof_array LT xmin_data,nbr_min)
    IF (nbr_min NE 0) THEN BEGIN
      index_min = index_min_array[nbr_min-1] + 1
    ENDIF ELSE BEGIN
      index_min = 0
    ENDELSE
    
    index_max_array = WHERE(tof_array GT xmax_data,nbr_max)
    IF (nbr_max NE 0) THEN BEGIN
      index_max = index_max_array[0]-1
    ENDIF ELSE BEGIN
      index_max = N_ELEMENTS(tof_array)-1
    ENDELSE
    
    ;make sure index_min and index_max are in the range authorized
    IF (index_max GE N_ELEMENTS(counts_vs_tof_integrated)) THEN BEGIN
      index_max = N_ELEMENTS(counts_vs_tof_integrated)-1
    ENDIF
    
    IF (index_min GE N_ELEMENTS(counts_vs_tof_integrated)) THEN BEGIN
      index_min = N_ELEMENTS(counts_vs_tof_integrated)-1
    ENDIF
    
    diff = index_min - index_max
    IF (diff GT 0) THEN BEGIN
      average = 'N/A'
      total_value = 'N/A'
    ENDIF
    IF (diff EQ 0) THEN BEGIN
      average = counts_vs_tof_integrated[index_min]
      total_value = counts_vs_tof_integrated[index_min]
      plot_average, Event, average
    ENDIF
    IF (diff LT 0) THEN BEGIN
      total_counts = counts_vs_tof_integrated[index_min:index_max]
      average = TOTAL(total_counts) / N_ELEMENTS(total_counts)
      total_value = TOTAL(total_counts)
      plot_average, Event, average
    ENDIF
    
  ENDIF ELSE BEGIN ;#bin mode
  
    xmin_data += 1
    diff = xmin_data - xmax_data
    IF (diff GT 0) THEN BEGIN
      average = 'N/A'
      total_value = 'N/A'
    ENDIF
    IF (diff EQ 0) THEN BEGIN
      average = counts_vs_tof_integrated[xmin_data]
      total_value = counts_vs_tof_integrated[xmin_data]
      plot_average, Event, average
    ENDIF
    IF (diff LT 0) THEN BEGIN
      total_counts = counts_vs_tof_integrated[xmin_data:xmax_data]
      average = TOTAL(total_counts)/N_ELEMENTS(total_counts)
      total_value = TOTAL(total_counts)
      plot_average, Event, average
    ENDIF
    
  ENDELSE
  
  (*global1).average = STRING(average)
  
  putTextFieldValue, Event, 'full_detector_counts_vs_tof_average_value',$
    STRCOMPRESS(average,/REMOVE_ALL)
  putTextFieldValue, Event, 'full_detector_counts_vs_tof_total_value',$
    STRCOMPRESS(total_value,/REMOVE_ALL) + ')'
    
END

;------------------------------------------------------------------------------
PRO display_selection, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  id = WIDGET_INFO(Event.top,find_by_uname='counts_vs_tof_main_base_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  ;plot selection
  x0y0x1y1_device = (*global1).x0y0x1y1_device
  x0x1 = [x0y0x1y1_device[0],x0y0x1y1_device[2]]
  y0y1 = [x0y0x1y1_device[1],x0y0x1y1_device[3]]
  xmin_device = MIN(x0x1,MAX=xmax_device)
  ymin_device = MIN(y0y1,MAX=ymax_device)
  
  x0y0x1y1_data = (*global1).x0y0x1y1_data
  x0x1 = [x0y0x1y1_data[0],x0y0x1y1_data[2]]
  y0y1 = [x0y0x1y1_data[1],x0y0x1y1_data[3]]
  xmin = MIN(x0x1,MAX=xmax)
  ymin = MIN(y0y1,MAX=ymax)
  
  ;make sure x and y are inside the space allowed
  IF (xmax_device GT (*global1).device_xmax) THEN xmax = -1L
  IF (xmax_device LT (*global1).device_xmin) THEN xmax = -1L
  IF (xmin_device LT (*global1).device_xmin) THEN xmin = -1L
  IF (ymax_device GT (*global1).device_ymax) THEN ymax = -1L
  IF (ymin_device LT (*global1).device_ymin) THEN ymin = -1L
  
  ymin_plot = (*global1).display_ymin
  ymax_plot = (*global1).display_ymax
  IF (xmin NE -1L) THEN BEGIN
    PLOTS, xmin, ymin_plot,/DATA
    PLOTS, xmin, ymax_plot,/CONTINUE, COLOR=50,/DATA
    IF (isButtonSelected(Event, $
      'full_detector_counts_vs_tof_selection_tool')) THEN BEGIN
      putTextFieldValue, Event,'full_detector_counts_vs_tof_left_bin', $
        STRCOMPRESS(xmin,/REMOVE_ALL)
    ENDIF
  ENDIF
  IF (xmax NE -1L) THEN BEGIN
    PLOTS, xmax, ymin_plot,/DATA
    PLOTS, xmax, ymax_plot,/CONTINUE, COLOR=100,/DATA
    IF (isButtonSelected(Event, $
      'full_detector_counts_vs_tof_selection_tool')) THEN BEGIN
      putTextFieldValue, Event,'full_detector_counts_vs_tof_right_bin', $
        STRCOMPRESS(xmax,/REMOVE_ALL)
    ENDIF
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO switch_left_right_click, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  left_clicked = (*global1).left_clicked
  IF (left_clicked EQ 1b) THEN BEGIN
    left_clicked = 0b
  ENDIF ELSE BEGIN
    left_clicked = 1b
  ENDELSE
  (*global1).left_clicked = left_clicked
  
END

;------------------------------------------------------------------------------
PRO replot_counts_vs_tof_full_detector, event, MOVING=moving

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  ;replot background
  lin_type = isLinSelected(Event)
  IF (lin_type) THEN BEGIN
    lin_log_type = 'linear'
  ENDIF ELSE BEGIN
    lin_log_type = 'log'
  ENDELSE
  
  xtitle = (*global1).xtitle
  ytitle = (*global1).ytitle
  plot_type = (*global1).plot_type
  counts_vs_tof_integrated = $
    (*(*global1).counts_vs_tof_array_integrated)
    
  id = WIDGET_INFO(Event.top,find_by_uname='counts_vs_tof_main_base_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  IF (N_ELEMENTS(moving) EQ 0) THEN BEGIN
    x0 = (*global1).x0_data
    y0 = (*global1).y0_data
    x1 = (*global1).x1_data
    y1 = (*global1).y1_data
  ENDIF ELSE BEGIN
    x0 = (*global1).x0_data_backup
    y0 = (*global1).y0_data_backup
    x1 = (*global1).x1_data_backup
    y1 = (*global1).y1_data_backup
  ENDELSE
  
  xmin = MIN([x0,x1],MAX=xmax)
  ymin = MIN([y0,y1],MAX=ymax)
  
  IF (xmax EQ 0. OR $
    xmin EQ 0.) THEN BEGIN ;reset plot
    
    IF (plot_type EQ 'tof') THEN BEGIN
      tof_array = (*(*global1).tof_array)
      IF (lin_log_type EQ 'log') THEN BEGIN
        PLOT, tof_array, $
          counts_vs_tof_integrated, $
          XTITLE = xtitle,$
          XSTYLE = 1,$
          YTITLE = ytitle,$
          YSTYLE = 1,$
          FONT='8x13',$
          /YLOG
      ENDIF ELSE BEGIN
        PLOT, tof_array, $
          counts_vs_tof_integrated, $
          XTITLE = xtitle,$
          XSTYLE = 1,$
          YTITLE = ytitle,$
          YSTYLE = 1,$
          FONT='8x13'
      ENDELSE
      Axis, XAxis=1, XRANGE=[0,N_ELEMENTS(counts_vs_tof_integrated)],$
        XTITLE='Bins #'
    ENDIF ELSE BEGIN
      IF (lin_log_type EQ 'log') THEN BEGIN
        PLOT, counts_vs_tof_integrated, $
          XTITLE = xtitle,$
          XSTYLE = 1,$
          YTITLE = ytitle,$
          YSTILE = 1,$
          FONT='8x13',$
          /YLOG
      ENDIF ELSE BEGIN
        PLOT, counts_vs_tof_integrated, $
          XTITLE = xtitle,$
          XSTYLE = 1,$
          YTITLE = ytitle,$
          YSTYEL = 1,$
          FONT='8x13'
      ENDELSE
    ENDELSE
    
  ENDIF ELSE BEGIN ;zoom plot using range specified
  
    IF (plot_type EQ 'tof') THEN BEGIN
      tof_array = (*(*global1).tof_array)
      IF (lin_log_type EQ 'log') THEN BEGIN
        PLOT, tof_array, $
          XRANGE = [xmin,xmax],$
          YRANGE = [ymin,ymax],$
          counts_vs_tof_integrated, $
          XTITLE = xtitle,$
          XSTYLE = 1,$
          YTITLE = ytitle,$
          YSTYLE = 1,$
          FONT='8x13',$
          /YLOG
      ENDIF ELSE BEGIN
        PLOT, tof_array, $
          counts_vs_tof_integrated, $
          XRANGE = [xmin,xmax],$
          YRANGE = [ymin,ymax],$
          XTITLE = xtitle,$
          XSTYLE = 1,$
          YTITLE = ytitle,$
          YSTYLE = 1,$
          FONT='8x13'
      ENDELSE
      Axis, XAxis=1, XRANGE=[0,N_ELEMENTS(counts_vs_tof_integrated)],$
        XTITLE='Bins #'
    ENDIF ELSE BEGIN
      IF (lin_log_type EQ 'log') THEN BEGIN
        PLOT, counts_vs_tof_integrated, $
          XRANGE = [xmin,xmax],$
          YRANGE = [ymin,ymax],$
          XTITLE = xtitle,$
          XSTYLE = 1,$
          YTITLE = ytitle,$
          YSTYLE = 1,$
          FONT='8x13',$
          /YLOG
      ENDIF ELSE BEGIN
        PLOT, counts_vs_tof_integrated, $
          XRANGE = [xmin,xmax],$
          YRANGE = [ymin,ymax],$
          XTITLE = xtitle,$
          XSTYLE = 1,$
          YTITLE = ytitle,$
          YSTYLE = 1,$
          FONT='8x13'
      ENDELSE
    ENDELSE
    
  ENDELSE
  
END

;------------------------------------------------------------------------------
FUNCTION retrieve_tof_array, NexusFileName
  path    = '/entry/bank1/time_of_flight/'
  fileID  = H5F_OPEN(NexusFileName)
  fieldID = H5D_OPEN(fileID, path)
  data    = H5D_READ(fieldID)
  RETURN, data
END

;------------------------------------------------------------------------------
PRO MakeCountsVsTofBase, wBaseBackground

  ourGroup = WIDGET_BASE()
  
  wBaseBackground = WIDGET_BASE(MAP = 1,$
    UNAME = 'counts_vs_tof_main_base',$
    GROUP_LEADER = ourGroup)
  ;    MBAR  = WID_BASE_0_MBAR)
    
  wBase= WIDGET_BASE(wBaseBackground,$
    /COLUMN)
    
  ;    ;HELP MENU in Menu Bar -------------------------------------------------
  ;  HELP_MENU = WIDGET_BUTTON(WID_BASE_0_MBAR,$
  ;    UNAME = 'help_menu',$
  ;    VALUE = 'HELP',$
  ;    /MENU)
  ;
  ;  HELP_BUTTON = WIDGET_BUTTON(HELP_MENU,$
  ;    VALUE = 'HELP',$
  ;    UNAME = 'help_button')
    
  ;ROW 1 --------------------------------------------------
  row1 = WIDGET_BASE(wBase,$
    /BASE_ALIGN_CENTER,$
    /ROW)
    
  ;Selection or zoom cw_bgroup
  row1c = WIDGET_BASE(row1,$
    /ROW,$
    /EXCLUSIVE,$
    FRAME = 5)
    
  selection = WIDGET_BUTTON(row1c,$
    VALUE = 'Selection',$
    UNAME = 'full_detector_counts_vs_tof_selection_tool',$
    /NO_RELEASE)
    
  zoom = WIDGET_BUTTON(row1c,$
    VALUE = 'Zoom',$
    UNAME = 'full_detector_counts_vs_tof_zoom_tool',$
    /NO_RELEASE)
    
  WIDGET_CONTROL, selection, /SET_BUTTON
  
  selection_base = WIDGET_BASE(row1,$ ;SELECTION BASE ************************
    /ROW,$
    UNAME = 'selection_base')
    
  space = WIDGET_LABEL(selection_base,$
    VALUE = '  Selection ->')
    
  value = WIDGET_LABEL(selection_base,$
    VALUE = ' Min:')
  value = WIDGET_LABEL(selection_base,$
    VALUE = 'N/A',$
    SCR_XSIZE = 50,$
    FRAME = 1,$
    /ALIGN_LEFT,$
    UNAME = 'full_detector_counts_vs_tof_left_bin')
  type = WIDGET_LABEL(selection_base,$
    VALUE = 'microS',$
    SCR_XSIZE = 40,$
    UNAME = 'full_detector_counts_vs_tof_left_bin_unit')
    
  value = WIDGET_LABEL(selection_base,$
    VALUE = '  Max:')
  value = WIDGET_LABEL(selection_base,$
    VALUE = 'N/A',$
    SCR_XSIZE = 50,$
    FRAME = 1,$
    /ALIGN_LEFT,$
    UNAME = 'full_detector_counts_vs_tof_right_bin')
  type = WIDGET_LABEL(selection_base,$
    VALUE = 'microS',$
    SCR_XSIZE = 40,$
    UNAME = 'full_detector_counts_vs_tof_right_bin_unit')
    
  value = WIDGET_LABEL(selection_base,$
    VALUE = '   Average (counts/bins) of selection:')
  value = WIDGET_LABEL(selection_base,$
    VALUE = 'N/A',$
    SCR_XSIZE = 70,$
    FRAME = 1,$
    /ALIGN_LEFT,$
    UNAME = 'full_detector_counts_vs_tof_average_value')
    
  total = WIDGET_LABEL(selection_base,$
    value = '(Total:')
  total = WIDGET_LABEL(selection_base,$
    value = 'N/A)',$
    uname = 'full_detector_counts_vs_tof_total_value',$
    /ALIGN_LEFT,$
    SCR_XSIZE = 80)
    
  info = WIDGET_LABEL(selection_base,$
    VALUE = '   (Left click to select min/max value and right click ' + $
    'to switch to other value)')
    
  zoom_base = WIDGET_BASE(wBaseBackground,$ ;ZOOM BASE ************************
    XOFFSET = 185,$
    YOFFSET = 8,$
    /ROW,$
    UNAME = 'zoom_base',$
    MAP = 0)
    
  xsize = 15
  
  xmin = WIDGET_LABEL(zoom_base,$
    VALUE = 'Xmin:')
  xmin = WIDGET_TEXT(zoom_base,$
    VALUE = 'N/A',$
    XSIZE = xsize,$
    UNAME = 'xmin')
  unit = WIDGET_LABEL(zoom_base,$
    VALUE = 'microS',$
    UNAME = 'xaxis_units')
    
  xmax = WIDGET_LABEL(zoom_base,$
    VALUE = '     Xmax:')
  xmax = WIDGET_TEXT(zoom_base,$
    VALUE = 'N/A',$
    XSIZE = xsize,$
    UNAME = 'xmax')
  unit = WIDGET_LABEL(zoom_base,$
    VALUE = 'microS',$
    UNAME = 'xaxis_units')
    
  ymin = WIDGET_LABEL(zoom_base,$
    VALUE = '      Ymin:')
  ymin = WIDGET_TEXT(zoom_base,$
    VALUE = 'N/A',$
    XSIZE = xsize,$
    UNAME = 'ymin')
  unit = WIDGET_LABEL(zoom_base,$
    VALUE = 'microS',$
    UNAME = 'xaxis_units')
    
  ymax = WIDGET_LABEL(zoom_base,$
    VALUE = '     Ymax:')
  ymax = WIDGET_TEXT(zoom_base,$
    VALUE = 'N/A',$
    XSIZE = xsize,$
    UNAME = 'ymax')
  unit = WIDGET_LABEL(zoom_base,$
    VALUE = 'microS',$
    UNAME = 'xaxis_units')
    
    help = WIDGET_LABEL(zoom_base,$
    VALUE = '    (Click outside the plotting frame to reset the zoom.)')
    
  ;ROW 2 --------------------------------------------------
  draw = WIDGET_DRAW(wBase,$
    SCR_XSIZE = 1500,$
    SCR_YSIZE = 600,$
    /MOTION_EVENTS,$
    /BUTTON_EVENTS,$
    UNAME = 'counts_vs_tof_main_base_draw')
    
  ;ROW 3 --------------------------------------------------
    
  ;lin/log cw_bgroup
  row3 = WIDGET_BASE(wBase,$
    /ROW,$
    /EXCLUSIVE,$
    FRAME = 0)
    
  lin = WIDGET_BUTTON(row3,$
    VALUE = 'Linear',$
    UNAME = 'full_detector_count_vs_tof_linear_plot',$
    /NO_RELEASE)
    
  log = WIDGET_BUTTON(row3,$
    VALUE = 'Log.',$
    UNAME = 'full_detector_count_vs_tof_log_plot',$
    /NO_RELEASE)
    
  WIDGET_CONTROL, lin, /SET_BUTTON
  
  WIDGET_CONTROL, wBase, /REALIZE
  
END

;------------------------------------------------------------------------------
PRO Launch_counts_vs_tof_base, $
    counts_vs_tof_array, $
    nexus_file_name, $
    title=title
    
  ;build gui
  wBase = ''
  MakeCountsVsTofBase, wBase
  
  global1 = PTR_NEW({ $
    NexusFileName: nexus_file_name,$
    counts_vs_tof_array: counts_vs_tof_array,$
    counts_vs_tof_array_integrated: PTR_NEW(0L),$
    xtitle: '',$
    ytitle: '',$
    average: '',$
    plot_type: '',$
    tof_array: PTR_NEW(0L),$
    x0_data: 0.,$
    y0_data: 0.,$
    x1_data: 0.,$
    y1_data: 0.,$
    x0_device: 0.,$
    y0_device: 0.,$
    x1_device: 0.,$
    y1_device: 0.,$
    x0_data_backup: 0.,$
    y0_data_backup: 0.,$
    x1_data_backup: 0.,$
    y1_data_backup: 0.,$
    left_mouse_pressed: 0,$
    
    device_xmin: 60,$
    device_xmax: 1481L, $
    device_ymin: 31,$
    device_ymax: 570, $
    
    display_xmin: 0.,$
    display_xmax: 0.,$
    display_ymin: 0.,$
    display_ymax: 0.,$
    
    display_xmin_backup: 0.,$
    display_xmax_backup: 0.,$
    display_ymin_backup: 0.,$
    display_ymax_backup: 0.,$
    
    left_clicked: 1b,$
    x0y0x1y1_data: [-1L,-1L,-1L,-1L],$
    x0y0x1y1_device: [-1L,-1L,-1L,-1L],$
    left_click: 0b,$
    wbase:               wbase})
    
  WIDGET_CONTROL, wBase, SET_UVALUE = global1
  XMANAGER, "launch_couts_vs_tof_base", wBase, GROUP_LEADER = ourGroup, /NO_BLOCK
  
  DEVICE, DECOMPOSED = 0
  loadct, 5, /SILENT
  
  ;retrieve TOF array
  IF (nexus_file_name NE '') THEN BEGIN
    tof_array = retrieve_tof_array(nexus_file_name)
    (*(*global1).tof_array) = tof_array
  ENDIF
  
  ;integrated counts_vs_tof for all pixels
  counts_vs_tof_integrated_1 = TOTAL(counts_vs_tof_array,1)
  counts_vs_tof_integrated_2 = TOTAL(counts_vs_tof_integrated_1,1)
  
  (*(*global1).counts_vs_tof_array_integrated) = counts_vs_tof_integrated_2
  
  ;determine position of maximum
  max = MAX(counts_vs_tof_integrated_2)
  max_index = WHERE(counts_vs_tof_integrated_2 EQ MAX)
  
  IF (nexus_file_name NE '') THEN BEGIN
    title += ' (TOF of maximum intensity is ' + $
      STRCOMPRESS(tof_array[max_index[0]],/REMOVE_ALL) + ' microS)'
  ENDIF ELSE BEGIN
    title += ' (TOF of maximum intensity is at binning #' + $
      STRCOMPRESS(max_index[0],/REMOVE_ALL) + ')'
  ENDELSE
  
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='counts_vs_tof_main_base')
  WIDGET_CONTROL, id, BASE_SET_TITLE=title
  
  id = WIDGET_INFO(wBase,find_by_uname='counts_vs_tof_main_base_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  IF (nexus_file_name NE '') THEN BEGIN
    xtitle = 'TOF (microS)'
    ytitle = 'Counts'
    plot_type = 'tof'
    units_label = 'microS'
  ENDIF ELSE BEGIN
    xtitle = 'Bins #'
    ytitle = 'Counts'
    plot_type = 'bin'
    units_label = 'bins#'
  ENDELSE
  
  !Y.MARGIN = [3,3]
  
  id = WIDGET_INFO(wBase,$
    FIND_BY_UNAME='full_detector_counts_vs_tof_right_bin_unit')
  WIDGET_CONTROL, id, SET_VALUE = units_label
  id = WIDGET_INFO(wBase,$
    FIND_BY_UNAME='full_detector_counts_vs_tof_left_bin_unit')
  WIDGET_CONTROL, id, SET_VALUE = units_label
  
  (*global1).xtitle = xtitle
  (*global1).ytitle = ytitle
  (*global1).plot_type = plot_type
  
  ymin = MIN(counts_vs_tof_integrated_2,MAX=ymax)
  (*global1).display_ymin = ymin
  (*global1).display_ymax = ymax
  IF (nexus_file_name NE '') THEN BEGIN
    (*global1).display_xmin = tof_array[0]
    (*global1).display_xmax = tof_array[N_ELEMENTS(tof_array)-1]
    PLOT, tof_array, $
      counts_vs_tof_integrated_2, $
      XTITLE = xtitle,$
      XSTYLE = 1,$
      YTITLE = ytitle,$
      YSTYLE = 1,$
      FONT='8x13'
    Axis, XAxis=1, XRANGE=[0,N_ELEMENTS(counts_vs_tof_integrated_2)],$
      XTITLE='Bins #'
  ENDIF ELSE BEGIN
    (*global1).display_xmin = 0
    (*global1).display_xmax = N_ELEMENTS(tof_array)
    PLOT, counts_vs_tof_integrated_2, $
      XTITLE = xtitle,$
      XSTYLE = 1,$
      YTITLE = ytitle,$
      YSTYLE = 1,$
      FONT='8x13'
  ENDELSE
  
  (*global1).display_xmin_backup = (*global1).display_xmin
  (*global1).display_ymin_backup = (*global1).display_ymin
  (*global1).display_xmax_backup = (*global1).display_xmax
  (*global1).display_ymax_backup = (*global1).display_ymax
  
END