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
;    This function converts the angle given into the unit desired
;
; :Keywords:
;    angle
;    from_unit   ;'degree' or 'rad'
;    to_unit     ''degree' or 'rad'
;    
; :Returns:
;   angle in the correct units 
;
; :Author: j35
;-
function convert_angle, angle=angle, $
    from_unit=from_unit,$
    to_unit=to_unit
  compile_opt idl2
  
  if (from_unit eq to_unit) then return, angle
  
  ;convert everything into rad
  case (from_unit) of
  'rad': from_factor = 1
  'degree': from_factor = 1/(!dtor)
  endcase
  angle_rad = angle * from_factor
  
  ;convert into desired unit
  case (to_unit) of
  'rad': to_factor = 1
  'degree': to_factor = !dtor
  endcase
  angle_rad *= to_factor

  return, angle_rad
end


;+
; :Description:
;    Convert the distance having the from_unit unit into the unit given
;    in the keyword to_unit

; :Keywords:
;    distance
;    from_unit   any from the following list ['m','dm','cm','mm',
;                'milliletre','microm','nano']
;    to_unit     any from the following list ['m','dm','cm','mm',
;                'millimetre','microm','nano']
;
; :Author: j35
;-
function convert_distance, distance=distance, $
    from_unit = from_unit, $
    to_unit = to_unit
  compile_opt idl2
  
  _distance = float(distance)
  if (~keyword_set(from_unit)) then return, 'N/A'
  if (~keyword_set(to_unit)) then return, 'N/A'
  
  ;convert distance into m
  case (strlowcase(from_unit)) of
    'm': _from_factor = 1.
    'dm': _from_factor = 1.e-1
    'cm': _from_factor = 1.e-2
    'mm': _from_factor = 1.e-3
    'millimetre': _from_facto = 1.e-3
    'microm': _from_factor = 1.e-6
    'nanom': _from_factor = 1.e-9
    else: return, 'N/A'
  endcase
  
  _distance *= _from_factor
  
  ;convert into the distance requested
  case (strlowcase(to_unit)) of
    'm': _to_factor = 1.
    'dm': _to_factor = 10.
    'cm': _to_factor = 1.e2
    'mm': _to_factor = 1.e3
    'millimetre': _to_factor = 1.e3
    'microm': _to_factor = 1.e6
    'nanom': _to_factor = 1.e9
    else: return, 'N/A'
  endcase
  
  _distance *= _to_factor
  
  return, _distance
  
end

;+
; :Description:
;    Convert into seconds the tof value according to the units given
;
; :Keywords:
;    tof_value
;    tof_units
;
; :Author: j35
;-
function convert_to_s, tof_value=tof_value, tof_units=tof_units
  compile_opt idl2
  
  if (n_elements(tof_units) eq 0) then tof_units = 's'
  
  case (strlowcase(tof_units)) of
    's': factor = 1
    'micros': factor = 1e-6
    'nanos': factor = 1e-9
    'ms': factor = 1e-3
    else: return, 'N/A'
  endcase
  
  return, tof_value * factor
end

;+
; :Description:
;    This function converts into Lambda the tof
;    specified
;
; :Keywords:
;    tof_value
;    tof_units   (default 's')
;    d_SD_m   distance Sample-Detector in meters
;    d_MS_m   distance Moderator-Sample in meters
;    lambda_units (default 'Angstroms')
;
; :Author: j35
;-
function calculate_lambda, tof_value=tof_value, $
    tof_units=tof_units, $
    d_SD_m = d_SD_m, $
    d_MS_m = d_MS_m, $
    lambda_units=lambda_units
  compile_opt idl2
  
  _tof_s = convert_to_s(tof_value=tof_value, tof_units=tof_units)
  
  if (n_elements(lambda_units) eq 0) then lambda_units = 'angstroms'
  
  ;retrieve h and m_n values
  file_name = 'SOS_instruments.cfg'
  iFile = obj_new('IDLxmlParser', file_name)
  h = iFile->getValue(tag=['constants','h'])
  m_n = iFile->getValue(tag=['constants','m_n'])
  obj_destroy, iFile
  
  case (strlowcase(lambda_units)) of
    'angstroms': factor = 1e10
    'm': factor = 1
    else: return, 'N/A'
  endcase
  
  _v = (double(d_SD_m) + double(d_MS_m)) / double(_tof_s)
  _lambda = double(h) / (double(m_n) * _v) * factor
  
  return, _lambda
end



;;test routine
;d_SD_m = 1430*1e-3
;d_MS_m = 13480*1e-3
;tof_value = 200
;tof_units = 'micros'
;lambda = calculate_lambda(tof_value=tof_value, $
;tof_units = tof_units, $
;d_SD_m = d_SD_m, $
;d_MS_m = d_MS_m, $
;lambda_units = 'Angstroms')
;print, '--> Test: Lambda for 200microsS is (Angstroms): ' , lambda
;end

