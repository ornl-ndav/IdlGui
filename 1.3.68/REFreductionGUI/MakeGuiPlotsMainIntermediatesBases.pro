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

PRO MakeGuiPlotsMainIntermediatesBases, PLOTS_BASE

  input_file = WIDGET_LABEL(PLOTS_BASE,$
    VALUE = 'Input ASCII File',$
    XOFFSET = 20,$
    YOFFSET = 775)
    
  main_base = WIDGET_BASE(PLOTS_BASE,$
    /COLUMN)
    
  row1 = WIDGET_BASE(main_base,$ ;--------------------------------------------
    /ROW)
    
  refresh = WIDGET_BUTTON(row1,$
    VALUE = '  REFRESH PLOT  ',$
    UNAME = 'refresh_plot_button',$
    SENSITIVE = 0)
    
  space = WIDGET_LABEL(row1,$
  VALUE = '                                  ')  
    
  label = WIDGET_LABEL(row1,$
  VALUE = 'To ZOOM, Click first corner and release on opposite corner. ' + $
  'Double click to reset zoom',$
  UNAME = 'plot_tab_zoom_help_label',$
  SENSITIVE = 0)
    
  row2 = WIDGET_BASE(main_base,$ ;--------------------------------------------
    /ROW)
    
  row2col1 = WIDGET_BASE(row2,$ ;||||||||||||||||||||||||||||||||||||||||||||||
    /COLUMN,$
    SENSITIVE = 0,$
    /ALIGN_CENTER, $
    UNAME = 'plot_tab_y_axis_lin_log_base',$
    /EXCLUSIVE)
    
  lin = WIDGET_BUTTON(row2col1,$
    VALUE = 'Lin',$
    /NO_RELEASE, $
    UNAME = 'plot_tab_y_axis_lin')
    
  log = WIDGET_BUTTON(row2col1,$
    VALUE = 'Log',$
    /NO_RELEASE, $
    UNAME = 'plot_tab_y_axis_log')
    
  WIDGET_CONTROL, lin, /SET_BUTTON
  
  draw = WIDGET_DRAW(row2,$
    SCR_XSIZE = 1100,$
    SCR_YSIZE = 730,$
    UNAME = 'main_plot_draw',$
    /MOTION_EVENTS, $
    /BUTTON_EVENTS)
    
  empty_space = WIDGET_LABEL(main_base,$
    VALUE = '')
    
  row3 = WIDGET_BASE(main_base, $ ;||||||||||||||||||||||||||||||||||||||||||
    /COLUMN,$
    FRAME = 1)
    
  empty = WIDGET_LABEL(row3,$
    VALUE = '')
    
  row3row2 = WIDGET_BASE(row3,$
    /ROW)
    
  browse = WIDGET_BUTTON(row3row2,$
    VALUE = '   BROWSE ...   ',$
    UNAME = 'plot_tab_browse_input_file_button')
    
  text = WIDGET_TEXT(row3row2,$
    VALUE = '',$
    UNAME = 'plot_tab_input_file_text_field',$
    /ALL_EVENTS, $
    XSIZE = 145,$
    /EDITABLE)
    
  load = WIDGET_BUTTON(row3row2,$
    VALUE = '  LOAD FILE  ',$
    UNAME = 'plot_tab_load_file_button',$
    SENSITIVE = 0)
    
  preview = WIDGET_BUTTON(row3row2,$
    VALUE = '  PREVIEW  ',$
    UNAME = 'plot_tab_preview_button',$
    SENSITIVE = 0)
    
END
