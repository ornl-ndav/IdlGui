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

  id = WIDGET_INFO(wBase, FIND_BY_UNAME='transmission_auto_mode_base')
  tab_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = tab_geometry.xsize
  ysize = tab_geometry.ysize
  
  ;background value and transmission intensity values
  back_base = WIDGET_BASE(wBase,$
    FRAME = 10, $
    /ROW, $
    XOFFSET = 5,$
    YOFFSET = 367)
  label = WIDGET_LABEL(back_base,$
    VALUE = 'Background value:')
  value = WIDGET_LABEL(back_base,$
    VALUE = 'N/A', $
    /ALIGN_LEFT, $
    SCR_XSIZE = 60,$
    UNAME = 'trans_auto_back_value')
  units = WIDGET_LABEL(back_base,$
    VALUE = 'counts/pixel')
    
  trans_base = WIDGET_BASE(wBase,$
    FRAME = 10, $
    /ROW, $
    XOFFSET = 285,$
    YOFFSET = 367)
  label = WIDGET_LABEL(trans_base,$
    VALUE = 'Transmission Intensity:')
  value = WIDGET_LABEL(trans_base,$
    VALUE = 'N/A', $
    /ALIGN_LEFT, $
    SCR_XSIZE = 80,$
    UNAME = 'trans_auto_trans_value')
  units = WIDGET_LABEL(trans_base,$
    VALUE = 'counts')
    
  ;=========================================
  base = WIDGET_BASE(wBase,$
    UNAME = 'auto_transmission',$
    SCR_XSIZE = xsize, $
    SCR_YSIZE = ysize, $
    SENSITIVE = 1,$
    MAP = 1, $
    /COLUMN)
    
  ;ROW1 .................................................
  row1 = WIDGET_BASE(base,$
    /ROW)
    
  ;row1_left ............................................
  xoffset = 40 ;xoffset of scale widget_draw
  yoffset = 40 ;yoffset of scale widget_draw
  xsize_main = 350 ;size of main plot
  ysize_main = 300 ;size of main plot
  main_xoffset = 45
  main_yoffset = 20
  scale_yoffset = 0
  xsize_scale = xsize_main+2*xoffset-2
  ysize_scale = ysize_main+2*yoffset
  
  row1_left = WIDGET_BASE(row1,$
    XSIZE = xsize_scale, $
    YSIZE = ysize_scale)
    
  main_plot = WIDGET_DRAW(row1_left,$
    XOFFSET = main_xoffset,$
    YOFFSET = main_yoffset,$
    SCR_XSIZE = xsize_main,$
    SCR_YSIZE = ysize_main,$
    UNAME = 'auto_transmission_draw')
    
  scale = WIDGET_DRAW(row1_left,$
    XOFFSET = 0,$
    YOFFSET = scale_yoffset,$
    SCR_XSIZE = xsize_scale, $
    SCR_YSIZE = ysize_scale, $
    UNAME = 'auto_transmission_draw_scale')
    
  ;row1_center ...........................................
  row1_center = WIDGET_BASE(row1,$
    /COLUMN)
    
  ;space
  label = WIDGET_LABEL(row1_center, $
    VALUE =  ' ')
    
  ;x0, y0, x1 and y1
  base_values = WIDGET_BASE(row1_center,$
    /COLUMN,$
    FRAME=1)
    
  title = WIDGET_LABEL(base_values,$
    VALUE = '   Selection Info   ', $
    FRAME = 1)
  space = WIDGET_LABEL(base_values,$
    VALUE = ' ')
    
  ;tube 0 and 1
  rowa = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(rowa,$
    VALUE = 'Tube Edge 1  :')
  value = WIDGET_LABEL(rowa,$
    VALUE = 'N/A',$
    UNAME = 'trans_auto_x0')
    
  rowb = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(rowb,$
    VALUE = 'Tube Edge 2  :')
  value = WIDGET_LABEL(rowb,$
    VALUE = 'N/A',$
    UNAME = 'trans_auto_x1')
    
  ;pixel 0 and 1
  rowc = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(rowc,$
    VALUE = 'Pixel Edge 1 :')
  value = WIDGET_LABEL(rowc,$
    VALUE = 'N/A',$
    UNAME = 'trans_auto_y0')
    
  rowd = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(rowd,$
    VALUE = 'Pixel Edge 2 :')
  value = WIDGET_LABEL(rowd,$
    VALUE = 'N/A',$
    UNAME = 'trans_auto_y1')
    
  ;space
  label = WIDGET_LABEL(row1_center, $
    VALUE =  ' ')
    
  ;x and y of cursor
  base_values = WIDGET_BASE(row1_center,$
    /COLUMN,$
    FRAME=1)
    
  title = WIDGET_LABEL(base_values,$
    VALUE = '    Beam Center     ', $
    FRAME = 1)
  space = WIDGET_LABEL(base_values,$
    VALUE = ' ')
    
  ;tube, pixel and counts
  rowa = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(rowa,$
    VALUE = 'Tube   :')
  value = WIDGET_LABEL(rowa,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    UNAME = 'trans_auto_beam_center_tube')
  rowb = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(rowb,$
    VALUE = 'Pixel  :')
  value = WIDGET_LABEL(rowb,$
    VALUE = 'N/A',$
    /ALIGN_LEFT,$
    UNAME = 'trans_auto_beam_center_pixel')
  rowc = WIDGET_BASE(base_values,$
    /ROW)
  label = WIDGET_LABEL(rowc,$
    VALUE = 'Counts :')
  value = WIDGET_LABEL(rowc,$
    VALUE = 'N/A            ',$
    SCR_XSIZE = 50,$
    /ALIGN_LEFT,$
    UNAME = 'trans_auto_beam_center_counts')
    
  ;row1_right ...........................................
  row1_right = WIDGET_BASE(row1,$
    /COLUMN)
    
  xsize = 350
  ysize = 195
  
  ;plot Counts vs X integrated over Y
  plot1 = WIDGET_DRAW(row1_right,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'trans_auto_step1_counts_vs_x')
    
  space = WIDGET_LABEL(row1_right,$
    VALUE = '')
    
  plot2 = WIDGET_DRAW(row1_right,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'trans_auto_step1_counts_vs_y')
    
  ;ROW2 .................................................
  row2 = WIDGET_BASE(base,$
    /ROW)
    
  transmission_plot = WIDGET_DRAW(row2,$
  SCR_XSIZE = 930,$
  SCR_YSIZE = 420,$
  UNAMe = 'trans_auto_trans_plot')  
    
  ;ROW3 -------------------------------
    
  button_row = WIDGET_BASE(base,$
  /ALIGN_CENTER,$
  /ROW)
  
  cancel = WIDGET_BUTTON(button_row,$
  VALUE = 'CANCEL',$
  UNAME = 'trans_auto_cancel_button',$
  SCR_XSIZE = 150, $
  SCR_YSIZE = 35)
  
  space = WIDGET_LABEL(button_row,$
  VALUE = '    ')

  refresh = WIDGET_BUTTON(button_row,$
  VALUE = 'REFRESH',$
  UNAME = 'trans_auto_refresh_button',$
  SCR_XSIZE = 150,$
  SCR_YSIZE = 35) 

  space = WIDGET_LABEL(button_row,$
  VALUE = '    ')
 
  go_manual = WIDGET_BUTTON(button_row,$
  VALUE = 'Switch to Manual Mode',$
  UNAME = 'trans_auto_go_to_manual_button',$
  SCR_XSIZE = 300,$
  SCR_YSIZE = 35)

  space = WIDGET_LABEL(button_row,$
  VALUE = '    ')
  
  ok = WIDGET_BUTTON(button_row,$
  VALUE = 'OK',$
  UNAME = 'trans_auto_ok_button',$
  SCR_XSIZE = 200,$
  SCR_YSIZE = 35)
  
    
    
  RETURN, base
  
END
