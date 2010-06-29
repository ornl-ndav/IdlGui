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

FUNCTION design_transmission_manual_mode_step3, wBase

  id = WIDGET_INFO(wBase, FIND_BY_UNAME='manual_transmission_step2')
  tab_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = tab_geometry.xsize
  ysize = tab_geometry.ysize
  
  base = WIDGET_BASE(wBase,$
    UNAME = 'manual_transmission_step3',$
    SCR_XSIZE = xsize, $
    SCR_YSIZE = ysize, $
    SENSITIVE = 1,$
    MAP = 1,$
    /TRACKING_EVENTS)
    
  xoffset = 40 ;xoffset of scale widget_draw
  yoffset = 40 ;yoffset of scale widget_draw
  xsize_main = 400 ;size of main plot
  ysize_main = 300 ;size of main plot
  main_xoffset = xsize/2 - xsize_main/2
  main_yoffset = yoffset
  
  main_plot = WIDGET_DRAW(base,$
    XOFFSET = xoffset+10,$
    YOFFSET = main_yoffset-9,$
    SCR_XSIZE = xsize_main,$
    SCR_YSIZE = ysize_main,$
    /BUTTON_EVENTS,$
    FRAME = 0, $
    /TRACKING_EVENTS,$
    /MOTION_EVENTS,$
    TOOLTIP = 'Select the beam center pixel to validate the CREATE ' + $
    'TRANSMISSION FILE button.' ,$
    UNAME = 'manual_transmission_step3_draw')
    
  scale = WIDGET_DRAW(base,$
    XOFFSET = 0,$
    YOFFSET = main_yoffset-yoffset,$
    SCR_XSIZE = xsize_main+2*xoffset+2,$
    SCR_YSIZE = ysize_main+2*yoffset,$
    UNAME = 'manual_transmission_step3_draw_scale')
    
  column1 = WIDGET_BASE(base,$
    XOFFSET = xsize_main+2*xoffset+15,$
    /COLUMN)
    
  ;lin/log flags --------------------------------------------------------------
  col1 = WIDGET_BASE(column1,$
    /ROW,$
    /EXCLUSIVE)
    
  lin = WIDGET_BUTTON(col1,$
    VALUE = 'Linear ',$
    /NO_RELEASE, $
    UNAME = 'transmission_manual_step3_linear')
    
  log = WIDGET_BUTTON(col1,$
    VALUE = 'Log ',$
    /NO_RELEASE, $
    UNAME = 'transmission_manual_step3_log')
    
  WIDGET_CONTROL, lin, /SET_BUTTON
  
  ;pixel of cursor (tube, pixel, counts value) --------------------------------
  bc_base = WIDGET_BASE(column1,$
    FRAME=1,$
    /COLUMN)
    
  title = WIDGET_LABEL(bc_base,$
    VALUE = '    Pixel below Cursor     ', $
    FRAME = 1)
    
  row1 = WIDGET_BASE(bc_base,$
    /ROW)
    
  label = WIDGET_LABEL(row1,$
    VALUE = 'Tube   :')
    
  value = WIDGET_LABEL(row1,$
    VALUE = 'N/A',$
    XSIZE = 100,$
    /ALIGN_LEFT, $
    UNAME = 'trans_manual_step3_tube_value')
    
  row2 = WIDGET_BASE(bc_base,$
    /ROW)
    
  label = WIDGET_LABEL(row2,$
    VALUE = 'Pixel  :')
    
  value = WIDGET_LABEL(row2,$
    VALUE = 'N/A',$
    XSIZE = 100,$
    /ALIGN_LEFT, $
    UNAME = 'trans_manual_step3_pixel_value')
    
  row3 = WIDGET_BASE(bc_base,$
    /ROW)
    
  label = WIDGET_LABEL(row3,$
    VALUE = 'Counts :')
    
  value = WIDGET_LABEL(row3,$
    VALUE = 'N/A',$
    SCR_XSIZE = 100,$
    /ALIGN_LEFT,$
    UNAME = 'trans_manual_step3_counts_value')
    
  ;Beam Center (tube, pixel, counts value) --------------------------------
  bc_base = WIDGET_BASE(column1,$
    FRAME=1,$
    /COLUMN)
    
  title = WIDGET_LABEL(bc_base,$
    VALUE = '       Beam Center        ', $
    FRAME = 1)
    
  row1 = WIDGET_BASE(bc_base,$
    /ROW)
    
  label = WIDGET_LABEL(row1,$
    VALUE = 'Tube   :')
    
  value = WIDGET_LABEL(row1,$
    VALUE = 'N/A',$
    XSIZE = 100,$
    /ALIGN_LEFT, $
    UNAME = 'trans_manual_step3_beam_center_tube_value')
    
  row2 = WIDGET_BASE(bc_base,$
    /ROW)
    
  label = WIDGET_LABEL(row2,$
    VALUE = 'Pixel  :')
    
  value = WIDGET_LABEL(row2,$
    VALUE = 'N/A',$
    XSIZE = 100,$
    /ALIGN_LEFT, $
    UNAME = 'trans_manual_step3_beam_center_pixel_value')
  row3 = WIDGET_BASE(bc_base,$
    /ROW)
    
  label = WIDGET_LABEL(row3,$
    VALUE = 'Counts :')
    
  value = WIDGET_LABEL(row3,$
    VALUE = 'N/A',$
    SCR_XSIZE = 100,$
    /ALIGN_LEFT,$
    UNAME = 'trans_manual_step3_beam_center_counts_value')
    
  ;Create Transmission File logo
  create_file = WIDGET_DRAW(column1,$
    SCR_XSIZE = 180,$
    SCR_YSIZE = 105,$
    UNAME = 'trans_manual_step3_create_trans_file',$
    /BUTTON_EVENTS, $
    TOOLTIP = 'Select the beam center pixel to be able to create the ' + $
    'transmission file',$
    /TRACKING_EVENTS, $
    /MOTION_EVENTS)
    
  ;Bottom Base ----------------------------------------------------------------
  bottom_base = WIDGET_BASE(base,$
    YOFFSET = ysize_main + 2*yoffset - 5,$
    /COLUMN)
    
  rowa = WIDGET_BASE(bottom_base,$ ;.................................
    /ROW)
    
  xsize = 340
  ysize = 220
  
  counts_vs_tube = WIDGET_DRAW(rowa,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'trans_manual_step3_counts_vs_tube_plot')
    
  space = WIDGET_LABEL(rowa,$
    VALUE = '')
    
  counts_vs_pixel = WIDGET_DRAW(rowa,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'trans_manual_step3_counts_vs_pixel_plot')
    
  rowb = WIDGET_BASE(bottom_base,$ ;.................................
    /ROW)
    
  counts_vs_tof = WIDGET_DRAW(rowb,$
    SCR_XSIZE = 690,$
    SCR_YSIZE = 190,$
    UNAME = 'trans_manual_step3_counts_vs_tof_plot')
    
  ;last row
  last_row = WIDGET_BASE(bottom_base,$
    /ROW)
    
  cancel = WIDGET_BUTTON(last_row,$
    VALUE = 'CANCEL',$
;    SCR_YSIZE = 35,$
    UNAME = 'trans_manual_step3_cancel_button',$
    SCR_XSIZE = 150)

  space_value = '                 '
  space = WIDGET_LABEL(last_row,$
  VALUE = space_value)

  refresh = WIDGET_BUTTON(last_row,$
  VALUE = 'REFRESH',$
  XSIZE = 150,$
  UNAME = 'trans_manual_step3_refresh_button')

  space = WIDGET_LABEL(last_row,$
  VALUE = space_value)
    
  previous = WIDGET_BUTTON(last_row,$
    SCR_XSIZE = 150,$
    VALUE = ' << Previous Step',$
    UNAME = 'trans_manual_step3_previous_button')
    
  RETURN, base
  
END



