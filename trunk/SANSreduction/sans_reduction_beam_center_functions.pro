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

;------------------------------------------------------------------------------
FUNCTION validate_or_not_beam_stop_range_moving, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  tube_min_data = FIX(getTextFieldValue(event,$
    'beam_center_beam_stop_tube_left'))
  tube_max_data = FIX(getTextFieldValue(Event,$
    'beam_center_beam_stop_tube_right'))
  pixel_min_data = FIX(getTextFieldValue(Event,$
    'beam_center_beam_stop_pixel_left'))
  pixel_max_data = FIX(getTextFieldValue(Event,$
    'beam_center_beam_stop_pixel_right'))
    
  tube_data = (*global).beam_stop_range_moving_tube_start
  pixel_data = (*global).beam_stop_range_moving_pixel_start
  
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


;------------------------------------------------------------------------------
FUNCTION cleanup_calculation_range_input, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, error
  
  tube_min_data = FIX(getTextFieldValue(event,$
    'beam_center_calculation_tube_left'))
  tube_max_data = FIX(getTextFieldValue(Event,$
    'beam_center_calculation_tube_right'))
  pixel_min_data = FIX(getTextFieldValue(Event,$
    'beam_center_calculation_pixel_left'))
  pixel_max_data = FIX(getTextFieldValue(Event,$
    'beam_center_calculation_pixel_right'))
    
  tube_min = MIN([tube_min_data,tube_max_data],MAX=tube_max)
  pixel_min = MIN([pixel_min_data,pixel_max_data],MAX=pixel_max)
  
  min_pixel_plotted = (*global).min_pixel_plotted
  max_pixel_plotted = (*global).max_pixel_plotted+1
  min_tube_plotted = (*global).min_tube_plotted
  max_tube_plotted = (*global).max_tube_plotted+1
  
  IF (tube_min LT min_tube_plotted) THEN tube_min = min_tube_plotted
  IF (tube_max GT max_tube_plotted) THEN tube_max = max_tube_plotted
  IF (pixel_min LT min_pixel_plotted) THEN pixel_min = min_pixel_plotted
  IF (pixel_max GT max_pixel_plotted) THEN pixel_max = max_pixel_plotted
  
  sTmin = STRCOMPRESS(tube_min,/REMOVE_ALL)
  sTmax = STRCOMPRESS(tube_max,/REMOVE_ALL)
  sPmin = STRCOMPRESS(pixel_min,/REMOVE_ALL)
  sPmax = STRCOMPRESS(pixel_max,/REMOVE_ALL)
  
  putTextFieldValue, Event, 'beam_center_calculation_tube_left', sTmin
  putTextFieldValue, Event, 'beam_center_calculation_tube_right', sTmax
  putTextFieldValue, Event, 'beam_center_calculation_pixel_left', sPmin
  putTextFieldValue, Event, 'beam_center_calculation_pixel_right', sPmax
  
  (*global).calculation_tubeLR_pixelLR_backup = [sTmin, sTmax, $
    sPmin, sPmax]
    
  RETURN, 1
  
  error: RETURN, 0
  
END

;------------------------------------------------------------------------------
FUNCTION cleanup_beam_stop_range_input, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, error
  
  tube_min_data = FIX(getTextFieldValue(event,$
    'beam_center_beam_stop_tube_left'))
  tube_max_data = FIX(getTextFieldValue(Event,$
    'beam_center_beam_stop_tube_right'))
  pixel_min_data = FIX(getTextFieldValue(Event,$
    'beam_center_beam_stop_pixel_left'))
  pixel_max_data = FIX(getTextFieldValue(Event,$
    'beam_center_beam_stop_pixel_right'))
    
  tube_min = MIN([tube_min_data,tube_max_data],MAX=tube_max)
  pixel_min = MIN([pixel_min_data,pixel_max_data],MAX=pixel_max)
  
  min_pixel_plotted = (*global).min_pixel_plotted
  max_pixel_plotted = (*global).max_pixel_plotted+1
  min_tube_plotted = (*global).min_tube_plotted
  max_tube_plotted = (*global).max_tube_plotted+1
  
  IF (tube_min LT min_tube_plotted) THEN tube_min = min_tube_plotted
  IF (tube_max GT max_tube_plotted) THEN tube_max = max_tube_plotted
  IF (pixel_min LT min_pixel_plotted) THEN pixel_min = min_pixel_plotted
  IF (pixel_max GT max_pixel_plotted) THEN pixel_max = max_pixel_plotted
  
  sTmin = STRCOMPRESS(tube_min,/REMOVE_ALL)
  sTmax = STRCOMPRESS(tube_max,/REMOVE_ALL)
  sPmin = STRCOMPRESS(pixel_min,/REMOVE_ALL)
  sPmax = STRCOMPRESS(pixel_max,/REMOVE_ALL)
  
  putTextFieldValue, Event, 'beam_center_beam_stop_tube_left', sTmin
  putTextFieldValue, Event, 'beam_center_beam_stop_tube_right', sTmax
  putTextFieldValue, Event, 'beam_center_beam_stop_pixel_left', sPmin
  putTextFieldValue, Event, 'beam_center_beam_stop_pixel_right', sPmax
  
  (*global).beam_stop_tubeLR_pixelLR_backup = [sTmin, sTmax, $
    sPmin, sPmax]
    
  RETURN, 1
  
  error: RETURN, 0
  
END

;------------------------------------------------------------------------------
FUNCTION cleanup_twoD_plot_range_input, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, error
  
  tube_data = FIX(getTextFieldValue(event,$
    'beam_center_2d_plot_tube'))
  pixel_data = FIX(getTextFieldValue(Event,$
    'beam_center_2d_plot_pixel'))
    
  min_pixel_plotted = (*global).min_pixel_plotted
  max_pixel_plotted = (*global).max_pixel_plotted+1
  min_tube_plotted = (*global).min_tube_plotted
  max_tube_plotted = (*global).max_tube_plotted+1
  
  IF (tube_data LT min_tube_plotted) THEN tube_data = min_tube_plotted
  IF (tube_data GT max_tube_plotted) THEN tube_data = max_tube_plotted
  IF (pixel_data LT min_pixel_plotted) THEN pixel_data = min_pixel_plotted
  IF (pixel_data GT max_pixel_plotted) THEN pixel_data = max_pixel_plotted
  
  sT = STRCOMPRESS(tube_data,/REMOVE_ALL)
  sP = STRCOMPRESS(pixel_data,/REMOVE_ALL)
  
  putTextFieldValue, Event, 'beam_center_2d_plot_tube', sT
  putTextFieldValue, Event, 'beam_center_2d_plot_pixel', sP
  
  (*global).twoD_plots_tubeLR_pixelLR_backup = [sT, sP]
  
  RETURN, 1
  
  error: RETURN, 0
  
END

;-----------------------------------------------------------------------------
FUNCTION getBScalculationRange, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ON_IOERROR, error
  
  ;get tube and pixel calculation range
  bs_calculation_tube_left = FIX(getTextFieldvalue(Event, $
    'tube1_button_value'))
  bs_calculation_tube_right = FIX(getTextFieldValue(Event, $
    'tube2_button_value'))
  bs_calculation_pixel_left = FIX(getTextFieldValue(Event, $
    'pixel1_button_value'))
  bs_calculation_pixel_right = FIX(getTextFieldValue(Event, $
    'pixel2_button_value'))
    
  tube_min = MIN([bs_calculation_tube_left, bs_calculation_tube_right], $
    MAX=tube_max)
  pixel_min = MIN([bs_calculation_pixel_left, bs_calculation_pixel_right], $
    MAX=pixel_max)
    
  RETURN, [tube_min,tube_max,pixel_min,pixel_max]
  
  error:
  
  default = (*global).calculation_range_default
  result = [default.tube1, $
    default.tube2, $
    default.pixel1, $
    default.pixel2]
  RETURN, result
  
END
