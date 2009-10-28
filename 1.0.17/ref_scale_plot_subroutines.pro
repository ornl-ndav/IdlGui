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

PRO populate_min_max_axis, Event, $
    flt0, $
    flt1
    
  WIDGET_CONTROL,Event.top, get_uvalue=global
  
  ;populate min/max x/y axis
  min_xaxis = MIN(flt0,max=max_xaxis,/nan)
  min_yaxis = MIN(flt1,max=max_yaxis,/nan)
  ;keep in global value of x and y min and max
  (*(*global).XYMinMax) = [min_xaxis,$
    max_xaxis,$
    min_yaxis,$
    max_yaxis]
    
  ;reduce the number of digit displayed
  ;  min_xaxis_display = NUMBER_FORMATTER(min_xaxis)
  ;  max_xaxis_display = NUMBER_FORMATTER(max_xaxis)
  ;  min_yaxis_display = NUMBER_FORMATTER(min_yaxis)
  ;  max_yaxis_display = NUMBER_FORMATTER(max_yaxis)
    
  min_xaxis_display = string(min_xaxis)
  max_xaxis_display = string(max_xaxis)
  min_yaxis_display = string(min_yaxis)
  max_yaxis_display = string(max_yaxis)
  
  PopulateXYScaleAxis, Event, $ ;_put
    min_xaxis_display, $
    max_xaxis_display, $
    min_yaxis_display, $
    max_yaxis_display
    
  CreateDefaultXYMinMax,Event,$ ;_gui
    min_xaxis,$
    max_xaxis,$
    min_yaxis,$
    max_yaxis
    
END