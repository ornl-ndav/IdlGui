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

PRO MakeGuiTofBase, wBase

  ;********************************************************************************
  ;                           Define size arrays
  ;********************************************************************************
  TofPlotBase = { size  : [0,0,730,560],$
    uname : 'tof_plot_base',$
    title : '' }
    
  TofPlotDraw = { size  : [0,0, $
    650, $
    530],$
    uname : 'tof_plot_draw' }
    
  PreviewDraw = { size : [TofPlotDraw.size[2]+20,$
    80,$
    40,$
    ;                        TofPlotBase.size[2]-TofPlotDraw.size[2],$
    TofPlotBase.size[3]-180],$
    uname : 'preview_draw'}
    
  ScaleButton = { uname : 'plot_scale_type',$
    value : 'Linear Y-axis      '}
    
  LinearButton = { uname : 'linear_scale',$
    value : 'Linear'}
    
  LogButton    = { uname : 'log_scale',$
    value : 'Logarithmic'}
    
  ;********************************************************************************
  ;                                Build GUI
  ;********************************************************************************
  ourGroup = WIDGET_BASE()
  wBase = WIDGET_BASE(TITLE        = TofPlotBase.title,$
    UNAME        = TofPlotBase.uname,$
    XOFFSET      = TofPlotBase.size[0],$
    YOFFSET      = TofPlotBase.size[1],$
    SCR_XSIZE    = TofPlotBase.size[2],$
    SCR_YSIZE    = TofPlotBase.size[3],$
    MAP          = 1,$
    GROUP_LEADER = ourGroup,$
    MBAR         = MBAR)
    
  wTofDraw = WIDGET_DRAW(wBase,$
    XOFFSET   = TofPLotDraw.size[0],$
    YOFFSET   = TofPLotDraw.size[1],$
    SCR_XSIZE = TofPLotDraw.size[2],$
    SCR_YSIZE = TofPLotDraw.size[3],$
    UNAME     = TofPLotDraw.uname,$
    /BUTTON_EVENTS,$
    /MOTION_EVENTS)
    
  wPreviewDraw = WIDGET_DRAW(wBase,$
    XOFFSET   = PreviewDraw.size[0],$
    YOFFSET   = PreviewDraw.size[1],$
    SCR_XSIZE = PreviewDraw.size[2],$
    SCR_YSIZE = PreviewDraw.size[3],$
    UNAME     = PreviewDraw.uname)
    
  wScaleButton = WIDGET_BUTTON(MBAR,$
    UNAME = ScaleButton.uname,$
    VALUE = ScaleButton.value,$
    /MENU)
    
  wLinearButton = WIDGET_BUTTON(wScaleButton,$
    UNAME = LinearButton.uname,$
    VALUE = LinearButton.value)
    
  wLogButton = WIDGET_BUTTON(wScaleButton,$
    UNAME = LogButton.uname,$
    VALUE = LogButton.value)
    
  base = WIDGET_BASE(wBase,$
    XOFFSET = 0,$
    YOFFSET = TofPlotDraw.size[3],$
    /COLUMN)
    
  value =   '    Left click + move + release click to Zoom in.
  value += '  Click outside the white plot frame to reset the Zoom'
    
  help1 = WIDGET_LABEL(base,$
    VALUE = value)
  
  WIDGET_CONTROL, wBase, /REALIZE
  
  
END
