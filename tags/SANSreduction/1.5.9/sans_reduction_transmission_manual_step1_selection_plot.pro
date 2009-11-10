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

PRO plot_big_cross_bar, Event

  color_working = 250
  linestyle_working = 0
  
  xmin = 0
  xmax = 450
  ymin = 0
  ymax = 400
  
  x0 = Event.x
  y0 = Event.y
  
  PLOTS, x0, ymin, /DEVICE, COLOR=color_working
  PLOTS, x0, ymax, /DEVICE, COLOR=color_working, /CONTINUE, $
    LINESTYLE=linestyle_working
  PLOTS, xmin, y0, /DEVICE, COLOR=color_working
  PLOTS, xmax, y0, /DEVICE, COLOR=color_working, /CONTINUE, $
    LINESTYLE=linestyle_working
    
END

;------------------------------------------------------------------------------
PRO backup_plot_selection, Event, mode=mode
  ;mode = 'x0y0' or 'x1y1'

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  x0y0x1y1 = (*global).x0y0x1y1
  color_non_working = 100
  color_working = 250
  
  IF (mode EQ 'x0y0') THEN BEGIN ;x0y0
    x0y0x1y1[0] = Event.X
    x0y0x1y1[1] = Event.Y
    color_working = color_working
    color_1 = color_non_working
    linestyle_0 = 0
    linestyle_1 = 1
    tube  = getTransManualStep1Tube(Event.x)
    pixel = getTransManualStep1Pixel(Event.y)
    putTextFieldValue, Event, 'trans_manual_step1_x0', $
      STRCOMPRESS(tube,/REMOVE_ALL)
    putTextFieldValue, Event, 'trans_manual_step1_y0', $
      STRCOMPRESS(pixel,/REMOVE_ALL)
  ENDIF ELSE BEGIN ;x1y1
    x0y0x1y1[2] = Event.X
    x0y0x1y1[3] = Event.Y
    color_1 = color_working
    color_0 = color_non_working
    linestyle_0 = 1
    linestyle_1 = 0
    tube  = getTransManualStep1Tube(Event.x)
    pixel = getTransManualStep1Pixel(Event.y)
    putTextFieldValue, Event, 'trans_manual_step1_x1', $
      STRCOMPRESS(tube,/REMOVE_ALL)
    putTextFieldValue, Event, 'trans_manual_step1_y1', $
      STRCOMPRESS(pixel,/REMOVE_ALL)
  ENDELSE
  
  (*global).x0y0x1y1 = x0y0x1y1
  
  xmin = 0
  xmax = 450
  ymin = 0
  ymax = 400
  
  
  x0 = x0y0x1y1[0]
  y0 = x0y0x1y1[1]
  x1 = x0y0x1y1[2]
  y1 = x0y0x1y1[3]
  
  IF (x0 NE 0 AND y0 NE 0) THEN BEGIN
  
    PLOTS, x0, ymin, /DEVICE, COLOR=color_0
    PLOTS, x0, ymax, /DEVICE, COLOR=color_0, /CONTINUE, LINESTYLE=linestyle_0
    PLOTS, xmin, y0, /DEVICE, COLOR=color_0
    PLOTS, xmax, y0, /DEVICE, COLOR=color_0, /CONTINUE, LINESTYLE=linestyle_0
    
  ENDIF
  
  IF (x1 NE 0 AND y1 NE 0) THEN BEGIN
  
    PLOTS, x1, ymin, /DEVICE, COLOR=color_1
    PLOTS, x1, ymax, /DEVICE, COLOR=color_1, /CONTINUE, LINESTYLE=linestyle_1
    PLOTS, xmin, y1, /DEVICE, COLOR=color_1
    PLOTS, xmax, y1, /DEVICE, COLOR=color_1, /CONTINUE, LINESTYLE=linestyle_1
    
  ENDIF
  
  plot_trans_manual_step1_central_selection, Event
  plot_trans_manual_step1_counts_vs_x_and_y, Event
  
END

;------------------------------------------------------------------------------
PRO refresh_plot_selection_trans_manual_step1, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
;  working_with = (*global).working_with_xy
;  x0y0x1y1 = (*global).x0y0x1y1
;  
;  IF (~isTranManualStep1LinSelected(Event)) THEN BEGIN ;log mode
;    color_non_working = 900
;    color_working = 550
;  ENDIF ELSE BEGIN
;    color_non_working = 100
;    color_working = 250
;  ENDELSE
;  
;  IF (working_with EQ 0) THEN BEGIN ;x0y0
;    color_0 = color_working
;    color_1 = color_non_working
;    linestyle_0 = 0
;    linestyle_1 = 2
;  ENDIF ELSE BEGIN ;x1y1
;    color_1 = color_working
;    color_0 = color_non_working
;    linestyle_0 = 2
;    linestyle_1 = 0
;  ENDELSE
;  
;  xmin = 0
;  xmax = 450
;  ymin = 0
;  ymax = 400
;  
;  x0 = x0y0x1y1[0]
;  y0 = x0y0x1y1[1]
;  x1 = x0y0x1y1[2]
;  y1 = x0y0x1y1[3]
;  
;  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='manual_transmission_step1_draw')
;  WIDGET_CONTROL, id, GET_VALUE=id_value
;  WSET, id_value
;  
;  IF (x0 NE 0 AND y0 NE 0) THEN BEGIN
;  
;    PLOTS, x0, ymin, /DEVICE, COLOR=color_0
;    PLOTS, x0, ymax, /DEVICE, COLOR=color_0, /CONTINUE, LINESTYLE=linestyle_0
;    PLOTS, xmin, y0, /DEVICE, COLOR=color_0
;    PLOTS, xmax, y0, /DEVICE, COLOR=color_0, /CONTINUE, LINESTYLE=linestyle_0
;    
;  ENDIF
;  
;  IF (x1 NE 0 AND y1 NE 0) THEN BEGIN
;  
;    PLOTS, x1, ymin, /DEVICE, COLOR=color_1
;    PLOTS, x1, ymax, /DEVICE, COLOR=color_1, /CONTINUE, LINESTYLE=linestyle_1
;    PLOTS, xmin, y1, /DEVICE, COLOR=color_1
;    PLOTS, xmax, y1, /DEVICE, COLOR=color_1, /CONTINUE, LINESTYLE=linestyle_1
;    
;  ENDIF
  
  plot_trans_manual_step1_central_selection, Event
  plot_trans_manual_step1_counts_vs_x_and_y, Event
  
END

;------------------------------------------------------------------------------
PRO plot_trans_manual_step1_central_selection, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  x0y0x1y1 = (*global).x0y0x1y1
  
  x0 = x0y0x1y1[0]
  y0 = x0y0x1y1[1]
  x1 = x0y0x1y1[2]
  y1 = x0y0x1y1[3]
  
  IF (~isTranManualStep1LinSelected(Event)) THEN BEGIN ;log mode
    color = 0
  ENDIF ELSE BEGIN
    color = 175
  ENDELSE
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='manual_transmission_step1_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  IF (x0 + y0 NE 0 AND $
    x1 + y1 NE 0) THEN BEGIN
    
    PLOTS, x0, y0, /DEVICE, COLOR=color, THICK=2
    PLOTS, x0, y1, /DEVICE, COLOR=color, THICK=2, /CONTINUE
    PLOTS, x1, y1, /DEVICE, COLOR=color, THICK=2, /CONTINUE
    PLOTS, x1, y0, /DEVICE, COLOR=color, THICK=2, /CONTINUE
    PLOTS, x0, y0, /DEVICE, COLOR=color, THICK=2, /CONTINUE
    
    validate_go_button = 1
    
  ENDIF ELSE BEGIN
  
    validate_go_button = 0
    
  ENDELSE
  
  activate_widget, Event, 'move_to_trans_manual_step2', validate_go_button
  
END

;------------------------------------------------------------------------------
PRO plot_trans_manual_step1_counts_vs_x_and_y, Event

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
    
    ;retrieve tube and pixel edges 1 and 2
    tube1 = getTextFieldValue(Event,'trans_manual_step1_x0')
    tube2 = getTextFieldValue(Event,'trans_manual_step1_x1')
    pixel1 = getTextFieldValue(Event,'trans_manual_step1_y0')
    pixel2 = getTextFieldValue(Event,'trans_manual_step1_y1')
    
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
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step1_counts_vs_x')
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    plot, x_axis, counts_vs_x, XSTYLE=1, XTITLE='Tube #', YTITLE='Counts', $
      TITLE = 'Counts vs tube integrated over pixel', $
      XTICKS = N_ELEMENTS(x_axis)-1, $
      PSYM = -1
      
    ;Counts vs tube (integrated over x)
    x_axis = INDGEN(N_ELEMENTS(counts_vs_y)) + pixel_min + yoffset
    (*(*global).pixel_x_axis) = x_axis
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='trans_manual_step1_counts_vs_y')
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    plot, x_axis, counts_vs_y, XSTYLE=1, XTITLE='Pixel #', YTITLE='Counts', $
      TITLE = 'Counts vs pixel integrated over tube', $
      XTICKS = N_ELEMENTS(x_axis)-1, $
      PSYM = -1
      
  ENDIF
  
END
