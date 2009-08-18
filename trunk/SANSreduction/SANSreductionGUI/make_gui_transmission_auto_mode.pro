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

FUNCTION design_transmission_auto_mode, wBase

  base = WIDGET_BASE(wBase,$
    UNAME = 'auto_transmission_step1',$
    SCR_XSIZE = xsize, $
    SCR_YSIZE = ysize, $
    SENSITIVE = 1,$
    MAP = 1,$
    /TRACKING_EVENTS)
    
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='auto_transmission_step1')
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
    UNAME = 'auto_transmission_step1_draw')
    
  scale = WIDGET_DRAW(base,$
    XOFFSET = 0,$
    YOFFSET = main_yoffset-yoffset,$
    SCR_XSIZE = xsize_main+2*xoffset-2,$
    SCR_YSIZE = ysize_main+2*yoffset,$
    UNAME = 'auto_transmission_draw_scale')
    
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
    UNAME = 'transmission_auto_step1_linear')
    
  log = WIDGET_BUTTON(col1,$
    VALUE = 'Log',$
    /NO_RELEASE, $
    UNAME = 'transmission_auto_step1_log')
    
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
    UNAME = 'trans_auto_step1_x0')
    
  row2 = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(row2,$
    VALUE = 'Tube Edge 2 :')
  value = WIDGET_LABEL(row2,$
    VALUE = 'N/A',$
    UNAME = 'trans_auto_step1_x1')
    
  space = WIDGET_LABEL(base_values,$
    VALUE = ' ')
    
  ;pixel 0 and 1
  row2 = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(row2,$
    VALUE = 'Pixel Edge 1 :')
  value = WIDGET_LABEL(row2,$
    VALUE = 'N/A',$
    UNAME = 'trans_auto_step1_y0')
    
  row4 = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(row4,$
    VALUE = 'Pixel Edge 2 :')
  value = WIDGET_LABEL(row4,$
    VALUE = 'N/A',$
    UNAME = 'trans_auto_step1_y1')
    
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
    UNAME = 'trans_auto_step1_cursor_tube')
  row2 = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(row2,$
    VALUE = 'Pixel  :')
  value = WIDGET_LABEL(row2,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    UNAME = 'trans_auto_step1_cursor_pixel')
  row3 = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(row3,$
    VALUE = 'Counts :')
  value = WIDGET_LABEL(row3,$
    VALUE = 'N/A            ',$
    SCR_XSIZE = 50,$
    /ALIGN_LEFT,$
    UNAME = 'trans_auto_step1_cursor_counts')
    
  message = ['  SELECTION MANUAL',$
    'Left Click to select',$
    'first corner of beam',$
    'stop region. Then',$
    'right click to switch',$
    'to other corner and',$
    'left click again to',$
    'select this corner.']
    
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
    UNAME = 'trans_auto_step1_counts_vs_x')
    
  space = WIDGET_LABEL(base_part2,$
    VALUE = '')
    
  plot2 = WIDGET_DRAW(base_part2,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'trans_auto_step1_counts_vs_y')
    
  ;third row of gui ==================================
  button = WIDGET_BUTTON(base,$
    XOFFSET = 580,$
    YOFFSET = ysize_main+2*yoffset + ysize + 9,$
    SENSITIVE = 0,$
    UNAME = 'move_to_trans_auto_step2',$
    VALUE = ' Next Step >> ')
    
  RETURN, base
  
END
