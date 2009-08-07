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

FUNCTION design_transmission_manual_mode_step2, wBase

  base = WIDGET_BASE(wBase,$
    UNAME = 'manual_transmission_step2',$
    SCR_XSIZE = xsize, $
    SCR_YSIZE = ysize, $
    SENSITIVE = 1,$
    MAP = 1,$
    /TRACKING_EVENTS)
    
  id = WIDGET_INFO(wBase, FIND_BY_UNAME='manual_transmission_step2')
  tab_geometry = WIDGET_INFO(id,/GEOMETRY)
  xsize = tab_geometry.xsize
  ysize = tab_geometry.ysize
  
  column1 = WIDGET_BASE(base,$
    /COLUMN)
    
  rowa = WIDGET_BASE(column1,$ ;============================
    /ROW)
    
  col1 = WIDGET_BASE(rowa,$ ;...............................
    /COLUMN)
    
  xsize = 540
  ysize = 410
  draw1 = WIDGET_DRAW(col1,$
    XSIZE = xsize, $
    YSIZE = ysize, $
    UNAME = 'trans_manual_step2_counts_vs_x')
    
  draw2 = WIDGET_DRAW(col1,$
    XSIZE = xsize, $
    YSIZE = ysize, $
    UNAME = 'trans_manual_step2_counts_vs_y')
    
  col2 = WIDGET_BASE(rowa,$ ;...............................
    /BASE_ALIGN_CENTER,$
    SCR_XSIZE = 130,$
    /COLUMN)
    
  label = WIDGET_LABEL(col2,$
    VALUE = 'Number of')
  label = WIDGET_LABEL(col2,$
    VALUE = 'Iterations')
  value = WIDGET_TEXT(col2,$
    VALUE = '2',$
    /EDITABLE,$
    UNAME = 'trans_manual_step2_nbr_iterations',$
    XSIZE = 2)
    
  space = WIDGET_LABEL(col2,$
    VALUE = ' ')
    
  calculate = WIDGET_BUTTON(col2,$
    VALUE = 'Calculate Background',$
    UNAME = 'trans_manual_step2_calculate')
    
  space = WIDGET_LABEL(col2,$
    VALUE = ' ')
    
  label = WIDGET_LABEL(col2,$
    VALUE = 'Background Value:')
  label = WIDGET_LABEL(col2,$
    VALUE = '(Counts/pixel)')
  value = WIDGET_LABEL(col2,$
    VALUE = 'N/A',$
    UNAME = 'trans_manual_step2_background_value',$
    SCR_XSIZE = 50,$
    FRAME = 1)
    
  FOR i=0,8 DO BEGIN
    space = WIDGET_LABEL(col2,$
      VALUE = ' ')
  ENDFOR

  label = WIDGET_LABEL(col2,$
  VALUE = 'Transmission Intensity:')
  label = WIDGET_LABEL(col2,$
  VALUE = '(counts)')
  value = WIDGET_LABEL(col2,$
  VALUE = 'N/A',$
  SCR_XSIZE = 60,$
  UNAME = 'trans_manual_step2_trans_intensity_value')

  FOR i=0,9 DO BEGIN
    space = WIDGET_LABEL(col2,$
      VALUE = ' ')
  ENDFOR
  
  help = WIDGET_BUTTON(col2,$
  VALUE = 'Algorithm Description',$
  UNAME = 'trans_manual_step2_algorithm_description')
  
  FOR i=0,3 DO BEGIN
    space = WIDGET_LABEL(col2,$
      VALUE = ' ')
  ENDFOR

  button = WIDGET_BUTTON(col2,$
    VALUE = ' << Previous Step ',$
    UNAME= 'trans_manual_step2_go_to_previous_step')
  button = WIDGET_BUTTON(col2,$
    VALUE = '   Next Step >>   ',$
    UNAME = 'trans_manual_step2_go_to_next_step')
      
  RETURN, base
  
END

