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

PRO plot_zoom_selection_plot_tab, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  xyminmax = (*global).xyminmax
  
  x1 = xyminmax[0]
  y1 = xyminmax[1]
  x2 = xyminmax[2]
  y2 = xyminmax[3]
  
  plot_selection_style = (*global).plot_selection_style
  color = plot_selection_style.color
  linestyle = plot_selection_style.linestyle
  thick = plot_selection_style.thick
  
  DEVICE, DECOMPOSED = 1
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'plot_draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
 
  PLOTS, x1, y1, /DATA
  PLOTS, x1, y2, /DATA, /CONTINUE, COLOR=FSC_COLOR(color)
  PLOTS, x2, y2, /DATA, /CONTINUE, COLOR=FSC_COLOR(color)
  PLOTS, x2, y1, /DATA, /CONTINUE, COLOR=FSC_COLOR(color)
  PLOTS, x1, y1, /DATA, /CONTINUE, COLOR=FSC_COLOR(color)

END