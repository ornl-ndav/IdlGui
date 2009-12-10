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

PRO plot_data_for_beam_center_base, $
    EVENT=event, $
    base=base, $
    MAIN_GLOBAL=main_global, $
    GLOBAL_BC = global_bc
    
  min_pixel = (*global_bc).min_pixel_plotted
  max_pixel = (*global_bc).max_pixel_plotted
  min_tube  = (*global_bc).min_tube_plotted
  max_tube  = (*global_bc).max_tube_plotted
  
  both_banks = (*(*main_global).both_banks)
  zoom_data = both_banks[*,min_pixel:max_pixel,min_tube:max_tube]
  t_zoom_data = TOTAL(zoom_data,1)
  tt_zoom_data = TRANSPOSE(t_zoom_data)
  (*(*global_bc).tt_zoom_data) = tt_zoom_data
  rtt_zoom_data = CONGRID(tt_zoom_data, 400,350)
  (*(*global_bc).rtt_zoom_data) = rtt_zoom_data
  
  id = WIDGET_INFO(base,FIND_BY_UNAME='beam_center_main_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TVSCL, rtt_zoom_data
  
END

;------------------------------------------------------------------------------
;save background
PRO save_beam_center_background,  Event=event, BASE=base

  uname = 'beam_center_main_draw'
  IF (N_ELEMENTS(base) NE 0) THEN BEGIN
    id = WIDGET_INFO(base, FIND_BY_UNAME=uname)
    WIDGET_CONTROL,base,GET_UVALUE=global
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, event.top, GET_UVALUE=global
    id = WIDGET_INFO(Event.top,find_by_uname=uname)
  ENDELSE
  
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize   = geometry.xsize
  ysize   = geometry.ysize
  
  DEVICE, copy =[0, 0, xsize, ysize, 0, 0, id_value]
  (*(*global).background) = background
  
END

;------------------------------------------------------------------------------
PRO plot_beam_center_scale, base, global

  ;change color of background
  id = WIDGET_INFO(base,FIND_BY_UNAME='beam_center_main_draw_scale')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  device, decomposed=1
  sys_color = WIDGET_INFO(base,/SYSTEM_COLORS)
  sys_color_window_bk = sys_color.window_bk
  
  min_pixel = (*global).min_pixel_plotted
  max_pixel = (*global).max_pixel_plotted
  min_tube  = (*global).min_tube_plotted
  max_tube  = (*global).max_tube_plotted
  
  xmargin = 8.2
  ymargin = 5
  
  xrange = [min_tube,max_tube+1]
  yrange = [min_pixel,max_pixel+1]
  
  plot, randomn(s,80), $
    XRANGE     = xrange,$
    YRANGE     = yrange,$
    COLOR      = convert_rgb([0B,0B,255B]), $
    BACKGROUND = convert_rgb(sys_color_window_bk),$
    THICK      = 1, $
    TICKLEN    = -0.025, $
    XTICKLAYOUT = 0,$
    XSTYLE      = 1,$
    YSTYLE      = 1,$
    YTICKLAYOUT = 0,$
    XTICKS      = 12,$
    XMINOR      = 2,$
    YMINOR      = 2,$
    YTICKS      = 14,$
    XTITLE      = 'TUBES',$
    YTITLE      = 'PIXELS',$
    XMARGIN     = [xmargin, xmargin+0.2],$
    YMARGIN     = [ymargin, ymargin],$
    /NODATA
  AXIS, yaxis=1, YRANGE=yrange, YTICKS=14, YSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = -0.025
  AXIS, xaxis=1, XRANGE=xrange, XTICKS=12, XSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = -0.025
    
  DEVICE, decomposed = 0
  
END

;------------------------------------------------------------------------------
PRO switch_cursor_shape, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  curr_tab_selected = getCurrentTabSelect(Event,'beam_center_tab')
  IF (curr_tab_selected EQ 1) THEN RETURN
  
  current_cursor_status = (*global).current_cursor_status
  IF (current_cursor_status EQ (*global).cursor_selection) THEN BEGIN
    (*global).current_cursor_status = (*global).cursor_moving
  ENDIF ELSE BEGIN
    (*global).current_cursor_status = (*global).cursor_selection
  ENDELSE
  
  draw_uname = 'beam_center_main_draw'
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  DEVICE, CURSOR_STANDARD=(*global).current_cursor_status
  
END

;------------------------------------------------------------------------------
PRO plot_beam_center_background, Event

  ;get global structure
  WIDGET_CONTROL,event.top,GET_UVALUE=global
  
  id = WIDGET_INFO(event.top,FIND_BY_UNAME='beam_center_main_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TV, (*(*global).background), true=3
  
END

;------------------------------------------------------------------------------
PRO plot_iSurface_tab1, BASE=base, EVENT=event

  IF (N_ELEMENTS(base) NE 0) THEN BEGIN
    WIDGET_CONTROL, BASE, GET_UVALUE=global
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, Event.top, GET_UVALUE=global
  ENDELSE
  
  ;retrieve data and tube and pixel offset
  tt_zoom_data      = (*(*global).tt_zoom_data)
  min_tube_plotted  = (*global).min_tube_plotted
  min_pixel_plotted = (*global).min_pixel_plotted
  
  ;get beam stop region
  IF (N_ELEMENTS(base) NE 0) THEN BEGIN
    tube_left = FIX(getTextFieldValue_from_base(base,$
      'beam_center_beam_stop_tube_left'))
    tube_right = FIX(getTextFieldValue_from_base(base,$
      'beam_center_beam_stop_tube_right'))
    pixel_left = FIX(getTextFieldValue_from_base(base,$
      'beam_center_beam_stop_pixel_left'))
    pixel_right = FIX(getTextFieldValue_from_base(base,$
      'beam_center_beam_stop_pixel_right'))
  ENDIF ELSE BEGIN
    tube_left = FIX(getTextFieldValue(Event, $
      'beam_center_beam_stop_tube_left'))
    tube_right = FIX(getTextFieldValue(Event, $
      'beam_center_beam_stop_tube_right'))
    pixel_left = FIX(getTextFieldValue(Event, $
      'beam_center_beam_stop_pixel_left'))
    pixel_right = FIX(getTextFieldValue(Event, $
      'beam_center_beam_stop_pixel_right'))
  ENDELSE
  
  x_min = MIN([tube_left, tube_right], MAX=x_max)
  y_min = MIN([pixel_left, pixel_right], MAX=y_max)
  
  x0 = x_min - min_tube_plotted
  x1 = x_max - min_tube_plotted
  y0 = y_min - min_pixel_plotted
  y1 = y_max - min_pixel_plotted
  
  tt_zoom_data[x0:x1,y0:y1] = 0
  
  draw_uname = 'beam_center_calculation_counts_vs_tube_draw'
  IF (N_ELEMENTS(base) NE 0) THEN BEGIN
    id = WIDGET_INFO(base,FIND_BY_UNAME=draw_uname)
  ENDIF ELSE BEGIN
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME=draw_uname)
  ENDELSE
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  DEVICE, decomposed=1
  ;Surface, tt_zoom_data, /LEGO, COLOR=convert_rgb([255B,0B,255B])
  ;Surface, tt_zoom_data, /NoData, COLOR=FSC_COLOR('red'), $
  ;  XTITLE='Tube', YTITLE='Pixel', ZTITLE='Counts', $
  ;  CHARSIZE = 1.5
  ;Surface, tt_zoom_data, /LEGO, COLOR=FSC_COLOR('blue'), /NoErase, $
  ;  XSTYLE = 4, YSTYLE = 4, ZSTYLE = 4
  CONTOUR, tt_zoom_data, NLEVELS=2
  
  
  DEVICE, decomposed=0
  
END

;------------------------------------------------------------------------------
PRO beam_center_plot, Base=base, Event=event

  DEVICE, DECOMPOSED=1
  
  uname = 'beam_center_main_draw'
  IF (N_ELEMENTS(event) NE 0) THEN BEGIN
  
    WIDGET_CONTROL, event.top, GET_UVALUE=global
    id = WIDGET_INFO(Event.top,find_by_uname=uname)
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    
    bc_tube = getTextFieldValue(event, 'beam_center_tube_center_value')
    bc_pixel = getTextFieldValue(event, 'beam_center_pixel_center_value')
    
  ENDIF ELSE BEGIN
  
    id = WIDGET_INFO(base, FIND_BY_UNAME=uname)
    WIDGET_CONTROL,base,GET_UVALUE=global
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    
    bc_tube = getTextFieldValue_from_base(base, $
      'beam_center_tube_center_value')
    bc_pixel = getTextFieldValue_from_base(base, $
      'beam_center_pixel_center_value')
      
  ENDELSE
  
  IF (bc_tube NE 'N/A' AND $
    bc_pixel NE 'N/A') THEN BEGIN
    
    IF (input_is_a_valid_number(bc_tube) AND $
      input_is_a_valid_number(bc_pixel)) THEN BEGIN ;valid numbers
      
      IF (tube_is_in_expected_range(BASE=base, EVENT=event, bc_tube) AND $
        pixel_is_in_expected_range(BASE=base, EVENT=event, bc_pixel)) THEN BEGIN
        
        bc_tube_value = FIX(bc_tube)
        bc_pixel_value = FIX(bc_pixel)
        
        tube  = getBeamCenterTubeDevice_from_data(bc_tube_value, global)
        pixel = getBeamCenterPixelDevice_from_data(bc_pixel_value, global)
        
        color = FSC_COLOR('white')
        thick = 3
        
        PLOTS, tube, pixel, /DEVICE, COLOR=color
        PLOTS, tube, pixel+1, /DEVICE, COLOR=color, /CONTINUE, $
          LINESTYLE=0, THICK=thick
        PLOTS, tube+1, pixel+1, /DEVICE, COLOR=color, /CONTINUE, $
          LINESTYLE=0, THICK=thick
        PLOTS, tube+1, pixel, /DEVICE, COLOR=color, /CONTINUE, $
          LINESTYLE=0, THICK=thick
        PLOTS, tube, pixel, /DEVICE, COLOR=color, /CONTINUE, $
          LINESTYLE=0, THICK=thick
          
      ENDIF
      
    ENDIF
    
  ENDIF
  
  DEVICE, DECOMPOSED=0
  
END