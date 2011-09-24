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
;    Using the TOF provided (if any), the pixel selection (if any),
;    the program will calculate the Qmin and Qmax
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro populate_Q_widgets, event=event
  compile_opt idl2
  
  debug = 0b
  
  Qmin_value=''
  Qmax_value=''
  
  ;TOF
  tof_min = strcompress(getTextFieldValue(Event,'tof_cutting_min'),$
    /remove_all)
  tof_max = strcompress(getTextFieldValue(event,'tof_cutting_max'),$
    /remove_all)
    
  ;no need to go further because one of the tof field is empty
  if (tof_min eq '' or tof_max eq '') then begin
    reset_Q_widgets, event=event
    return
  endif
  
  IF (isTOFcuttingUnits_microS(Event)) then begin
    coeff = 1e-6
  endif else begin
    coeff = 1e-3
  endelse
  tof_min = (float(tof_min) eq 0.) ? 1 : tof_min
  tof_min_s = float(tof_min) * coeff
  tof_max_s = float(tof_max) * coeff
  
  if (debug) then print, 'tof_min_s: ' , tof_min_s
  if (debug) then print, 'tof_max_s: ' , tof_max_s
  
  ;Pixel range
  pixel_min = strcompress(getTextFieldValue(event, $
    'data_d_selection_roi_ymin_cw_field'),/remove_all)
  pixel_max = strcompress(getTextFieldValue(event, $
    'data_d_selection_roi_ymax_cw_field'),/remove_all)
    
  if (debug) then print, 'pixel_min: ' , pixel_min
  if (debug) then print, 'pixel_max: ' , pixel_max
  
  ;no need to go further if we are missing a pixel values (min or max)
  if (pixel_min eq '' or pixel_max eq '') then begin
    reset_Q_widgets, event=event
    return
  endif
  
  ;distance Moderator-detector in meters
  widget_control, event.top, get_uvalue=global
;  on_ioerror, float_error
  distance_moderator_sample = float((*global).distance_moderator_sample)
  
  if (debug) then print, 'distance_moderator_sample: ' , $
  distance_moderator_sample
  
  ;sangle = polar_angle/2 of pixel min and pixel max positions
  ;sangle_min_max = (*global).sangle_min_max
  ;sangle_min = min(sangle_min_max,max=sangle_max)
  
  calculate_sangle, event, refpix=pixel_min, sangle=sangle_min
  calculate_sangle, event, refpix=pixel_max, sangle=sangle_max
  
  if (sangle_min eq '-1' || sangle_max eq '-1') then begin
    reset_Q_widgets, event=event
    return
  endif
  
  if (debug) then print, 'sangle_min: ' , sangle_min
  if (debug) then print, 'sangle_max: ' , sangle_max
  
  ;global constants
  m_n = 1.67495e-27
  h   = 6.626e-34
  pi  = !pi
  
  ;factor = (4*pi*m_n*distance_moderator_detector
  factor = (4.*pi*m_n*distance_moderator_sample)/h
  if (debug) then print, 'factor: ' , factor
  
  ;Qmin
  Qmin = factor * (sin(sangle_min))
  Qmin /= tof_max_s
  if (debug) then print, 'Qmin: ' , Qmin
  
  ;Qmax
  Qmax = factor * (sin(sangle_max))
  Qmax /= tof_min_s
  if (debug) then print, 'Qmax: ' , Qmax
  
  ;Angstroms
  Qmin = Qmin[0] * 1e-10
  Qmax = Qmax[0] * 1e-10
  
  _Qmin = min([Qmin,Qmax],max=_Qmax)
  
  putValue, event=event, 'q_min_text_field', strcompress(_Qmin,/remove_all)
  putValue, event=event, 'q_max_text_field', strcompress(_Qmax,/remove_all)
  
  return
  
  if (debug) then print, 'after return statment in populate_q_widgets'
  
  float_error:
  reset_Q_widgets, event=event
  
end

;+
; :Description:
;    This procedure reset the contain of the Qmin and Qmax fields in the
;    reduce tab.
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro reset_Q_widgets, event=event
  compile_opt idl2
  
  Qmin_value=' '
  Qmax_value=' '
  
  putValue, event=event, 'q_min_text_field', Qmin_value
  putValue, event=event, 'q_max_text_field', Qmax_value
  
end