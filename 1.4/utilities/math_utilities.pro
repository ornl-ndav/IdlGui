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

FUNCTION isWithStep4_step2_step2_error_bars, Event
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME= $
    'step4_step2_step2_with_error_bars_cw_bgroup')
  WIDGET_CONTROL, id, GET_VALUE=index
  RETURN, 0^index
END

;------------------------------------------------------------------------------
;Change the format from Thu Aug 23 16:15:23 2007
;to 2007y_08m_23d_16h_15mn_23s
PRO fit_data, Event, flt0, flt1, flt2, a, b
  ;retrieve global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ; Compute the second degree polynomial fit to the data:
  ;check if we want with error bars or not
  IF (isWithStep4_step2_step2_error_bars(Event)) THEN BEGIN
    cooef = POLY_FIT(flt0, $
      flt1, $
      1, $
      MEASURE_ERRORS = flt2, $
      /DOUBLE,$
      STATUS         = status,$
      SIGMA          = sigma) ;standard error
  ENDIF ELSE BEGIN
    cooef = POLY_FIT(flt0, $
      flt1, $
      1, $
      STATUS         = status,$
      /DOUBLE,$
      SIGMA          = sigma) ;standard error
  ENDELSE
  
  a = cooef[0]
  b = cooef[1]
  
END

;------------------------------------------------------------------------------

FUNCTION convert_from_lambda_to_Q, axis_before
  axis_after = (4. * !PI)/axis_before
  RETURN, axis_after
END

;------------------------------------------------------------------------------
;This function converts the input angle into deg
FUNCTION convert_to_deg, f_angle_rad
  f_angle_deg_local = (180. * f_angle_rad) / !PI
  RETURN, f_angle_deg_local
END

;------------------------------------------------------------------------------
FUNCTION convert_to_rad, f_angle_deg
  f_angle_rad_local = (!PI * f_angle_deg) / 180.
  RETURN, f_angle_rad_local
END

;------------------------------------------------------------------------------
FUNCTION convert_to_metre, distance, units
  units = STRLOWCASE(units)
  CASE (units) OF
    'millimetre': coeff = 0.001
    'decimetre': coeff = 0.01
    'centimetre': coeff = 0.1
    ELSE: coeff = 1
  ENDCASE
  RETURN, (FLOAT(distance) * coeff)
END




