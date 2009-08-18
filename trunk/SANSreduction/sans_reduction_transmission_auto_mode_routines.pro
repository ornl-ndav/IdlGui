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

PRO plot_transmission_auto_scale, base, sys_color_window_bk

  ;change color of background
  id = WIDGET_INFO(base,FIND_BY_UNAME='auto_transmission_draw_scale')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  device, decomposed=1
  sys_color = WIDGET_INFO(base,/SYSTEM_COLORS)
  sys_color_window_bk = sys_color.window_bk
  
  xmargin_left  = 7.5
  xmargin_right = 5.8
  ymargin_bottom = 5.9
  ymargin_top    = 2.1
  
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
    XMARGIN     = [xmargin_left, xmargin_right],$
    YMARGIN     = [ymargin_bottom, ymargin_top],$
    /NODATA
  AXIS, yaxis=1, YRANGE=[112,152], YTICKS=20, YSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = -0.025
  AXIS, xaxis=1, XRANGE=[80,112], XTICKS=16, XSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = -0.025
    
  DEVICE, decomposed = 0
  
END
