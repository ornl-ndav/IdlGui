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

;+
; :Description:
;    This routine will plot the 2 background regions, and the peak region
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro greg_selection, event
  compile_opt idl2
  
end


;+
; :Description:
;    This routine will just refresh the background regions and the peak region
;    as well
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro refresh_greg_selection, event
  compile_opt idl2
  
  REFReduction_RescaleDataPlot, Event
  
  roi1_from = fix(getValue(event=event, uname='greg_roi1_from_value'))
  roi1_to = fix(getValue(event=event, uname='greg_roi1_to_value'))
  
  roi2_from = fix(getValue(event=event, uname='greg_roi2_from_value'))
  roi2_to = fix(getValue(event=event, uname='greg_roi2_to_value'))
  
  id = widget_info(event.top, find_by_uname='load_data_D_draw')
  geometry = widget_info(id,/geometry)
  xsize_1d_draw = geometry.scr_xsize
  
  if (roi1_from ne 0) then begin
    roi1_from_device = getYDeviceFromData(event=event, $
      type='data', $
      data_value=roi1_from)
      
    plots, 0, roi1_from_device, /device, color=fsc_color('green')
    plots, xsize_1d_draw, roi1_from_device, /device, color=fsc_color('green'), $
    /continue
    
  endif

  if (roi1_to ne 0) then begin
    roi1_to_device = getYDeviceFromData(event=event, $
      type='data', $
      data_value=roi1_to)
      
    plots, 0, roi1_to_device, /device, color=fsc_color('green')
    plots, xsize_1d_draw, roi1_to_device, /device, color=fsc_color('green'), $
    /continue
  
  endif
  
  if (roi2_from ne 0) then begin
    roi2_from_device = getYDeviceFromData(event=event, $
      type='data', $
      data_value=roi2_from)
      
    plots, 0, roi2_from_device, /device, color=fsc_color('green')
    plots, xsize_1d_draw, roi2_from_device, /device, color=fsc_color('green'), $
    /continue
    
  endif

  if (roi2_to ne 0) then begin
    roi2_to_device = getYDeviceFromData(event=event, $
      type='data', $
      data_value=roi2_to)
      
    plots, 0, roi2_to_device, /device, color=fsc_color('green')
    plots, xsize_1d_draw, roi2_to_device, /device, color=fsc_color('green'), $
    /continue
  
  endif
  
  plot_data_peak_value, event

end