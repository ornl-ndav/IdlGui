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

FUNCTION validate_or_not_calibration_range_moving, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  tube_min_data = FIX(getTextFieldValue(event,$
    'beam_center_calculation_tube_left'))
  tube_max_data = FIX(getTextFieldValue(Event,$
    'beam_center_calculation_tube_right'))
  pixel_min_data = FIX(getTextFieldValue(Event,$
    'beam_center_calculation_pixel_left'))
  pixel_max_data = FIX(getTextFieldValue(Event,$
    'beam_center_calculation_pixel_right'))
    
  tube_data = (*global).calibration_range_moving_tube_start
  pixel_data = (*global).calibration_range_moving_pixel_start

  offset_tube_max = ABS(tube_max_data - tube_data)
  offset_tube_min = ABS(tube_min_data - tube_data)
  offset_pixel_max = ABS(pixel_max_data - pixel_data)
  offset_pixel_min = ABS(pixel_min_data - pixel_data)
  
  moving_pixel_range = (*global).moving_pixel_range
  moving_tube_range = (*global).moving_tube_range
  
  IF (offset_tube_max LE moving_tube_range) THEN RETURN, 1
  IF (offset_tube_min LE moving_tube_range) THEN RETURN, 1
  IF (offset_pixel_max LE moving_pixel_range) THEN RETURN, 1
  IF (offset_pixel_min LE moving_pixel_range) THEN RETURN, 1

  RETURN, 0
  
END





