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

