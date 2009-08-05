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

FUNCTION design_transmission_manual_mode_tab1, wBase, tab

  id = WIDGET_INFO(wBase, FIND_BY_UNAME='manual_transmission_tab')
  tab_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = tab_geometry.xsize
  ysize = tab_geometry.ysize
  
  base = WIDGET_BASE(tab,$
    SCR_XSIZE = xsize, $
    SCR_YSIZE = ysizxe, $
    TITLE = 'Define Beam Stop Region')
    
  xoffset = 50 ;xoffset of scale widget_draw
  yoffset = 50 ;yoffset of scale widget_draw
  xsize_main = 450 ;size of main plot
  ysize_main = 400 ;size of main plot
  main_xoffset = xsize/2 - xsize_main/2
  main_yoffset = yoffset
  
  main_plot = WIDGET_DRAW(base,$
    XOFFSET = main_xoffset,$
    YOFFSET = main_yoffset,$
    SCR_XSIZE = xsize_main,$
    SCR_YSIZE = ysize_main,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    /MOTION_EVENTS,$
    UNAME = 'manual_transmission_step1_draw')
    
  scale = WIDGET_DRAW(base,$
    XOFFSET = main_xoffset-xoffset,$
    YOFFSET = main_yoffset-yoffset,$
    SCR_XSIZE = xsize_main+2*xoffset-2,$
    SCR_YSIZE = ysize_main+2*yoffset,$
    UNAME = 'manual_transmission_step1_draw_scale')
    
  ;second part of gui
  base_part2 = WIDGET_BASE(base,$
    XOFFSET = 20,$
    YOFFSET = ysize_main+2*yoffset,$
    /COLUMN,$
    FRAME = 0)
    
  ;lin/log flags
  row1 = WIDGET_BASE(base_part2,$
    /ROW,$
    /EXCLUSIVE)
    
  lin = WIDGET_BUTTON(row1,$
    VALUE = 'Linear',$
    UNAME = 'transmission_manual_step1_linear')
    
  log = WIDGET_BUTTON(row1,$
    VALUE = 'Log',$
    UNAME = 'transmission_manual_step1_log')
    
  WIDGET_CONTROL, lin, /SET_BUTTON
  
  RETURN, base
  
END

;------------------------------------------------------------------------------
PRO plot_transmission_step1_scale, base

  ;change color of background
  id = WIDGET_INFO(base,FIND_BY_UNAME='manual_transmission_step1_draw_scale')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  sys_color = WIDGET_INFO(base,/SYSTEM_COLORS)
  xmargin = 8.2
  ymargin = 5
  plot, randomn(s,80), $
    XRANGE     = [80,112],$
    YRANGE     = [112,152],$
    COLOR      = convert_rgb([0B,0B,255B]), $
    BACKGROUND = convert_rgb(sys_color.face_3d),$
    THICK      = 1, $
    TICKLEN    = -0.025, $
    XTICKLAYOUT = 0,$
    XSTYLE      = 1,$
    YSTYLE      = 1,$
    YTICKLAYOUT = 0,$
    XTICKS      = 16,$
    YTICKS      = 20,$
    XTITLE      = 'TUBES',$
    YTITLE      = 'PIXELS',$
    XMARGIN     = [xmargin, xmargin],$
    YMARGIN     = [ymargin, ymargin],$
    /NODATA
  AXIS, yaxis=1, YRANGE=[112,152], YTICKS=20, YSTYLE=1, color=2, $
    TICKLEN = -0.025
  AXIS, xaxis=1, XRANGE=[80,112], XTICKS=16, XSTYLE=1, color=2,$
    TICKLEN = -0.025
    
END

;------------------------------------------------------------------------------
PRO save_transmission_manual_step1_background,  EVENT=event, MAIN_BASE=main_base

  uname = 'manual_transmission_step1_draw'
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    id = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME=uname)
    WIDGET_CONTROL,main_base,GET_UVALUE=global_step1
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, event.top, GET_UVALUE=global_step1
    ;select plot area
    id = WIDGET_INFO(Event.top,find_by_uname=uname)
  ENDELSE
  
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize   = geometry.xsize
  ysize   = geometry.ysize
  
  DEVICE, copy =[0, 0, xsize, ysize, 0, 0, id_value]
  (*(*global_step1).background) = background
  
END
