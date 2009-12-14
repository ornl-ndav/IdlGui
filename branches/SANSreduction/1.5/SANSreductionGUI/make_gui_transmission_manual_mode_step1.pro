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

FUNCTION design_transmission_manual_mode_step1, wBase, base

  base = WIDGET_BASE(wBase,$
    UNAME = 'manual_transmission_step1',$
    SCR_XSIZE = xsize, $
    SCR_YSIZE = ysize, $
    SENSITIVE = 1,$
    MAP = 1,$
    /TRACKING_EVENTS)
    
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='manual_transmission_step1')
  tab_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = tab_geometry.xsize
  ysize = tab_geometry.ysize
  
  ;  base = WIDGET_BASE(tab,$
  ;    SCR_XSIZE = xsize, $
  ;    SCR_YSIZE = ysizxe, $
  ;    TITLE = 'STEP 1/ Define Beam Stop Region')
  
  xoffset = 50 ;xoffset of scale widget_draw
  yoffset = 50 ;yoffset of scale widget_draw
  xsize_main = 450 ;size of main plot
  ysize_main = 400 ;size of main plot
  main_xoffset = xsize/2 - xsize_main/2
  main_yoffset = yoffset
  
  main_plot = WIDGET_DRAW(base,$
    XOFFSET = xoffset,$
    YOFFSET = main_yoffset,$
    SCR_XSIZE = xsize_main,$
    SCR_YSIZE = ysize_main,$
    /BUTTON_EVENTS,$
    /TRACKING_EVENTS,$
    /MOTION_EVENTS,$
    UNAME = 'manual_transmission_step1_draw')
    
  scale = WIDGET_DRAW(base,$
    XOFFSET = 0,$
    YOFFSET = main_yoffset-yoffset,$
    SCR_XSIZE = xsize_main+2*xoffset-2,$
    SCR_YSIZE = ysize_main+2*yoffset,$
    UNAME = 'manual_transmission_step1_draw_scale')
    
  ;right part of plot
  base_right = WIDGET_BASE(base,$
    XOFFSET = xsize_main+2*xoffset,$
    YOFFSET = 0,$
    /COLUMN,$
    FRAME = 0)
    
  ;lin/log flags
  col1 = WIDGET_BASE(base_right,$
    ;/COLUMN,$
    /ROW,$
    /EXCLUSIVE)
    
  lin = WIDGET_BUTTON(col1,$
    VALUE = 'Linear',$
    /NO_RELEASE, $
    UNAME = 'transmission_manual_step1_linear')
    
  log = WIDGET_BUTTON(col1,$
    VALUE = 'Log',$
    /NO_RELEASE, $
    UNAME = 'transmission_manual_step1_log')
    
  WIDGET_CONTROL, lin, /SET_BUTTON
  
  ;x0, y0, x1 and y1
  base_values = WIDGET_BASE(base_right,$
    /COLUMN,$
    FRAME=1)
    
  title = WIDGET_LABEL(base_values,$
    VALUE = '   Selection Info   ', $
    FRAME = 1)
  space = WIDGET_LABEL(base_values,$
    VALUE = ' ')
    
  ;tube 0 and 1
  row1 = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(row1,$
    VALUE = 'Tube Edge 1 :')
  value = WIDGET_LABEL(row1,$
    VALUE = 'N/A',$
    UNAME = 'trans_manual_step1_x0')
    
  row2 = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(row2,$
    VALUE = 'Tube Edge 2 :')
  value = WIDGET_LABEL(row2,$
    VALUE = 'N/A',$
    UNAME = 'trans_manual_step1_x1')
    
  space = WIDGET_LABEL(base_values,$
    VALUE = ' ')
    
  ;pixel 0 and 1
  row2 = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(row2,$
    VALUE = 'Pixel Edge 1 :')
  value = WIDGET_LABEL(row2,$
    VALUE = 'N/A',$
    UNAME = 'trans_manual_step1_y0')
    
  row4 = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(row4,$
    VALUE = 'Pixel Edge 2 :')
  value = WIDGET_LABEL(row4,$
    VALUE = 'N/A',$
    UNAME = 'trans_manual_step1_y1')
    
  ;x and y of cursor
  base_values = WIDGET_BASE(base_right,$
    /COLUMN,$
    FRAME=1)
    
  title = WIDGET_LABEL(base_values,$
    VALUE = '    Cursor Info     ', $
    FRAME = 1)
  ;  space = WIDGET_LABEL(base_values,$
  ;    VALUE = ' ')
    
  ;tube, pixel and counts
  row1 = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(row1,$
    VALUE = 'Tube   :')
  value = WIDGET_LABEL(row1,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    UNAME = 'trans_manual_step1_cursor_tube')
  row2 = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(row2,$
    VALUE = 'Pixel  :')
  value = WIDGET_LABEL(row2,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    UNAME = 'trans_manual_step1_cursor_pixel')
  row3 = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(row3,$
    VALUE = 'Counts :')
  value = WIDGET_LABEL(row3,$
    VALUE = 'N/A            ',$
    SCR_XSIZE = 50,$
    /ALIGN_LEFT,$
    UNAME = 'trans_manual_step1_cursor_counts')
    
    space = WIDGET_LABEL(base_right,$
    VALUE = ' ')
;    space = WIDGET_LABEL(base_right,$
;    VALUE = ' ')

  message = ['  SELECTION MANUAL',$
    'Left click to select',$
    'first corner then',$
    'release click on',$
    'second corner.']
    
  sz= N_ELEMENTS(message)
  FOR i=0,(sz-1) DO BEGIN
    help = WIDGET_LABEL(base_right,$
      VALUE = message[i],$
      /ALIGN_LEFT)
  ENDFOR
  
  ;second part of gui =========================
  base_part2 = WIDGET_BASE(base,$
    XOFFSET = 0,$
    YOFFSET = ysize_main+2*yoffset,$
    /ROW,$
    FRAME = 0)
    
  xsize = 340
  ysize = 300
  
  ;plot Counts vs X integrated over Y
  plot1 = WIDGET_DRAW(base_part2,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'trans_manual_step1_counts_vs_x')
    
  space = WIDGET_LABEL(base_part2,$
    VALUE = '')
    
  plot2 = WIDGET_DRAW(base_part2,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'trans_manual_step1_counts_vs_y')
    
  ;third row of gui ==================================
  ;cancel button
  cancel = WIDGET_BUTTON(base,$
  XOFFSET = 15,$
  XSIZE = 100,$
  YOFFSET = ysize_main+2*yoffset+ysize+9,$
  VALUE = 'CANCEL',$
  UNAME = 'cancel_trans_manual_step1')
  
  ;refresh button
  refresh = WIDGET_BUTTON(base,$
  VALUE = 'REFRESH',$
  UNAME = 'refresh_trans_manual_step1',$
  XOFFSET = 295,$
  YOFFSET = ysize_main+2*yoffset+ysize+9,$
  XSIZE = 100)
  
  button = WIDGET_BUTTON(base,$
    XOFFSET = 580,$
    YOFFSET = ysize_main+2*yoffset + ysize + 9,$
    SENSITIVE = 0,$
    UNAME = 'move_to_trans_manual_step2',$
    VALUE = ' Next Step >> ')
    
  RETURN, base
  
END

;------------------------------------------------------------------------------
PRO plot_transmission_step1_scale, base, sys_color_window_bk

  ;change color of background
  id = WIDGET_INFO(base,FIND_BY_UNAME='manual_transmission_step1_draw_scale')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  device, decomposed=1
  sys_color = WIDGET_INFO(base,/SYSTEM_COLORS)
  sys_color_window_bk = sys_color.window_bk
  
  xmargin = 8.2
  ymargin = 5
  plot, randomn(s,80), $
    XRANGE     = [80,112],$
    YRANGE     = [112,152],$
    COLOR      = convert_rgb([0B,0B,255B]), $
    ;    BACKGROUND = convert_rgb(sys_color.face_3d),$
    BACKGROUND = convert_rgb(sys_color_window_bk),$
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
  AXIS, yaxis=1, YRANGE=[112,152], YTICKS=20, YSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = -0.025
  AXIS, xaxis=1, XRANGE=[80,112], XTICKS=16, XSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = -0.025
    
  DEVICE, decomposed = 0
  
END

;------------------------------------------------------------------------------
PRO plot_transmission_step1_scale_from_event, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  sys_color_window_bk = (*global).sys_color_window_bk
  
  ;change color of background
  id = WIDGET_INFO(Event.top,$
    FIND_BY_UNAME='manual_transmission_step1_draw_scale')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  device, decomposed=1
  
  xmargin = 8.2
  ymargin = 5
  plot, randomn(s,80), $
    XRANGE     = [80,112],$
    YRANGE     = [112,152],$
    COLOR      = convert_rgb([0B,0B,255B]), $
    BACKGROUND = convert_rgb(sys_color_window_bk),$
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
  AXIS, yaxis=1, YRANGE=[112,152], YTICKS=20, YSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = -0.025
  AXIS, xaxis=1, XRANGE=[80,112], XTICKS=16, XSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = -0.025
    
  DEVICE, decomposed = 0
  
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
