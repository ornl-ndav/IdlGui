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

PRO plot_tab_fitting_gui, wBase, main_base_geometry, sys_color_window_bk

  main_base_xoffset = main_base_geometry.xoffset
  main_base_yoffset = main_base_geometry.yoffset
  main_base_xsize = main_base_geometry.xsize
  main_base_ysize = main_base_geometry.ysize
  
  xsize = 450 ;width of various steps of manual mode
  ysize = 450 ;height of various steps of manual mode
  
  xoffset = main_base_xoffset + main_base_xsize
  yoffset = main_base_yoffset + main_base_ysize/2-ysize/2
  
  ourGroup = WIDGET_BASE()
  
  wBase = WIDGET_BASE(TITLE = 'Fitting',$
    UNAME        = 'plot_tab_fitting_base',$
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    /BASE_ALIGN_CENTER,$
    GROUP_LEADER = ourGroup)
    
  NoEqBase = WIDGET_BASE(wBase, $
    UNAME = 'plot_tab_fitting_no_base',$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    MAP = 0,$
    /BASE_ALIGN_CENTER)
    
  draw = WIDGET_DRAW(NoEqBase,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'plot_tab_fitting_base_no_equation_draw')
    
  EqBase = WIDGET_BASE(wBase, $
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    /BASE_ALIGN_CENTER)
    
  xyoffb = [91,265]
  label_xsize = 100
  b = WIDGET_LABEL(EqBase,$
    UNAME = 'plot_tab_fitting_b_coeff',$
    XOFFSET = xyoffb[0],$
    YOFFSET = xyoffb[1],$
    /ALIGN_LEFT,$
    VALUE = 'N/A',$
    FRAME = 1,$
    SCR_XSIZE = label_xsize)
  XYoffa = [220,xyoffb[1]]
  a = WIDGET_LABEL(EqBase,$
    XOFFSET = xyoffa[0],$
    UNAME = 'plot_tab_fitting_a_coeff',$
    YOFFSET = xyoffa[1],$
    /ALIGN_LEFT, $
    VALUE = 'N/A',$
    FRAME = 1,$
    SCR_XSIZE = label_xsize)
    
  xyoffi0 = [200,330]
  i0 = WIDGET_LABEL(EqBase,$
    VALUE = 'N/A',$
    SCR_XSIZE = label_xsize,$
    UNAME = 'plot_tab_fitting_i0_coeff',$
    FRAME=1,$
    /ALIGN_LEFT,$
    XOFFSET = xyoffi0[0],$
    yoffset = xyoffi0[1])
  xyoffrg_value = [xyoffi0[0],385]
  r_value = WIDGET_LABEL(EqBase,$
    VALUE = 'N/A',$
    SCR_XSIZE = label_xsize,$
    FRAME=1,$
    UNAME = 'plot_tab_fitting_r_coeff',$
    /ALIGN_LEFT,$
    XOFFSET = xyoffrg_value[0],$
    yoffset = xyoffrg_value[1])
  xyoffrg_units = [320,xyoffrg_value[1]]
  r_units = WIDGET_LABEL(EqBase,$
    VALUE = 'Angstroms',$
    SCR_XSIZE = label_xsize,$
    FRAME=1,$
    /ALIGN_LEFT,$
    XOFFSET = xyoffrg_units[0],$
    yoffset = xyoffrg_units[1])
    
  draw = WIDGET_DRAW(EqBase,$
    SCR_XSIZE = xsize,$
    SCR_YSIZE = ysize,$
    UNAME = 'plot_tab_fitting_base_draw')
    
  WIDGET_CONTROL, wBase, /REALIZE
  
END
