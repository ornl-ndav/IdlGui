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
    
  ;edit or not background value
    
  ;  xoffset = 565
  ;  yoffset = 200
  ;  row = WIDGET_BASE(base,$
  ;    XOFFSET = xoffset,$
  ;    YOFFSET = yoffset,$
  ;    UNAME = 'trans_manual_step2_edit_background_base',$
  ;    MAP = 1,$
  ;    /ROW)
  ;  value = WIDGET_LABEL(row,$
  ;    VALUE = 'N/A',$
  ;    UNAME = 'trans_manual_step2_background_value',$
  ;    SCR_XSIZE = 50,$
  ;    FRAME = 1)
  ;  edit_button = WIDGET_BUTTON(row,$
  ;    VALUE = '  EDIT  ',$
  ;    UNAME = 'trans_manual_step2_edit_background')
  ;
  ;  row = WIDGET_BASE(base,$
  ;    XOFFSET = xoffset,$
  ;    YOFFSET = yoffset,$
  ;    UNAME = 'trans_manual_step2_lock_edit_background_base',$
  ;    MAP = 0,$
  ;    /ROW)
  ;  value = WIDGET_TEXT(row,$
  ;    VALUE = 'N/A',$
  ;    /EDITABLE,$
  ;    UNAME = 'trans_manual_step2_background_edit',$
  ;    SCR_XSIZE = 50)
  ;  edit_button = WIDGET_BUTTON(row,$
  ;    VALUE = 'LOCK EDIT',$
  ;    UNAME = 'trans_manual_step2_lock_edit_background')
  ;
  ;..............................................................
    
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
    /BUTTON_EVENTS,$
    /MOTION_EVENTS,$
    UNAME = 'trans_manual_step2_counts_vs_x')
    
  draw2 = WIDGET_DRAW(col1,$
    XSIZE = xsize, $
    YSIZE = ysize, $
    /BUTTON_EVENTS,$
    /MOTION_EVENTS,$
    UNAME = 'trans_manual_step2_counts_vs_y')
    
  col2 = WIDGET_BASE(rowa,$ ;...............................
    /BASE_ALIGN_CENTER,$
    SCR_XSIZE = 130,$
    /COLUMN)
    
  ;range of tubes and pixels base
  tp_base = WIDGET_BASE(col2,$
    FRAME = 1,$
    /COL)
    
  label = WIDGET_LABEL(tp_base,$
    VALUE = 'Range of Tubes:   ')
  row_tube1 = WIDGET_BASE(tp_base,$
    /ROW)
  label = WIDGET_LABEL(row_tube1,$
    VALUE = 'Tube min: ')
  value = WIDGET_TEXT(row_tube1,$
    VALUE = '?',$
    XSIZE = 3,$
    /EDITABLE,$
    UNAME = 'trans_manual_step2_tube_min')
  row_tube2 = WIDGET_BASE(tp_base,$
    /ROW)
  label = WIDGET_LABEL(row_tube2,$
    VALUE = 'Tube max: ')
  value = WIDGET_TEXT(row_tube2,$
    VALUE = '?',$
    XSIZE = 3,$
    /EDITABLE,$
    UNAME = 'trans_manual_step2_tube_max')
    
  space = WIDGET_LABEL(tp_base,$
    VALUE = '')
    
  label = WIDGET_LABEL(tp_base,$
    VALUE = 'Range of Pixels:    ')
  row_tube1 = WIDGET_BASE(tp_base,$
    /ROW)
  label = WIDGET_LABEL(row_tube1,$
    VALUE = 'Pixel min: ')
  value = WIDGET_TEXT(row_tube1,$
    XSIZE = 3,$
    VALUE = '?',$
    /EDITABLE,$
    UNAME = 'trans_manual_step2_pixel_min')
  row_tube2 = WIDGET_BASE(tp_base,$
    /ROW)
  label = WIDGET_LABEL(row_tube2,$
    VALUE = 'Pixel max: ')
  value = WIDGET_TEXT(row_tube2,$
    VALUE = '?',$
    XSIZE = 3,$
    /EDITABLE,$
    UNAME = 'trans_manual_step2_pixel_max')
    
  ;++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
  row_ite = WIDGET_BASE(col2,$
    UNAME = 'trans_manual_step2_nbr_ite_base',$
    SENSITIVE = 1,$
    /ROW)
    
  label = WIDGET_LABEL(row_ite,$
    VALUE = 'Iterations #:')
  value = WIDGET_TEXT(row_ite,$
    VALUE = '2',$
    /EDITABLE,$
    UNAME = 'trans_manual_step2_nbr_iterations',$
    XSIZE = 2)
    
  ;++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  row_bkg = WIDGET_BASE(col2,$
    FRAME = 1,$
    SENSITIVE = 1,$
    UNAME = 'trans_manual_step2_bkg_value_base',$
    /COL)
  label = WIDGET_LABEL(row_bkg,$
    VALUE = 'Background Value    ')
  row_bkg_2 = WIDGET_BASE(row_bkg,$
    /ROW)
  value = WIDGET_LABEL(row_bkg_2,$
    SCR_XSIZE = 45,$
    VALUE = 'N/A',$
    UNAME = 'trans_manual_step2_background_value')
  label = WIDGET_LABEL(row_bkg_2,$
    VALUE = 'counts/pixel')
    
  ;=============================================================================
  ;3D view button
  threeDview = WIDGET_DRAW(col2, $
    SCR_XSIZE = 130, $
    SCR_YSIZE = 40, $
    /BUTTON_EVENTS, $
    /TRACKING_EVENTS, $
    UNAME = 'trans_manual_step2_3d_view_button')
  ;=============================================================================
    
  row_tran = WIDGET_BASE(col2,$
    UNAME = 'trans_manual_step2_tran_base',$
    FRAME = 1,$
    SENSITIVE = 1,$
    /COL)
    
  label = WIDGET_LABEL(row_tran,$
    VALUE = 'Trans. intensity     ')
  row_tran_2 = WIDGET_BASE(row_tran,$
    /ROW)
  value = WIDGET_LABEL(row_tran_2,$
    VALUE = 'N/A',$
    SCR_XSIZE = 60,$
    UNAME = 'trans_manual_step2_trans_intensity_value')
  label = WIDGET_LABEL(row_tran_2,$
    VALUE = 'counts')
    
  ;++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
  help = WIDGET_BUTTON(col2,$
    VALUE = 'Algorithm Description',$
    UNAME = 'trans_manual_step2_algorithm_description')
    
  FOR i=0,9 DO BEGIN
    space = WIDGET_LABEL(col2,$
      VALUE = ' ')
  ENDFOR
  
  xsize = 150
  
  calculate = WIDGET_BUTTON(col2,$
    VALUE = 'Calculate Background',$
    SENSITIVE = 1,$
    SCR_XSIZE = xsize, $
    SCR_YSIZE = 30,$
    UNAME = 'trans_manual_step2_calculate')
    
  space = WIDGET_LABEL(col2,$
    VALUE = ' ')
    
  button = WIDGET_BUTTON(col2,$
    SCR_XSIZE = xsize, $
    VALUE = ' << Previous Step ',$
    UNAME= 'trans_manual_step2_go_to_previous_step')
  button = WIDGET_BUTTON(col2,$
    VALUE = '   Next Step >>   ',$
    SCR_XSIZE = xsize, $
    SENSITIVE = 0,$
    UNAME = 'trans_manual_step2_go_to_next_step')
    
  space = WIDGET_LABEL(col2,$
  VALUE = ' ')
  
  refresh = WIDGET_BUTTON(col2,$
  VALUE = 'REFRESH',$
  SCR_XSIZE = xsize,$
  UNAME = 'trans_manual_step2_refresh_button')
  
  cancel = WIDGET_BUTTON(col2,$
  VALUE = 'CANCEL',$
  SCR_XSIZE = xsize,$
  UNAME = 'trans_manual_step2_cancel_button')
    
  RETURN, base
  
END

