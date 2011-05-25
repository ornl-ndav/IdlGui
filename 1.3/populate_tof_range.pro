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
;    This populate the REDUCE tab / tof range with the
;    freshly loaded data tof range if there is no previous tof
;    defined
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro populate_tof_range, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  tof_cutting_min = strcompress(getTextFieldValue(event,$
    'tof_cutting_min'),/remove_all)
  tof_cutting_max = strcompress(getTextFieldValue(event,$
    'tof_cutting_max'),/remove_all)
    
  if (tof_cutting_min ne '' && tof_cutting_max ne '') then return
  
  tof_axis = (*(*global).tof_axis_ms)
  tof_cutting_min = tof_axis[0]
  tof_cutting_max = tof_axis[-1]
  
  if (isTOFcuttingUnits_microS(Event)) then begin
    _tof_cutting_min = float(tof_cutting_min) / 1000.
    _tof_cutting_max = float(tof_cutting_max) / 1000.
  endif else begin
    _tof_cutting_min = tof_cutting_min
    _tof_cutting_max = tof_cutting_max
  endelse
  
  _s_tof_min = strcompress(_tof_cutting_min,/remove_all)
  _s_tof_max = strcompress(_tof_cutting_max,/remove_all)
  
  putValue, event=event, 'tof_cutting_min', _s_tof_min
  putValue, event=event, 'tof_cutting_max', _s_tof_max
  
end