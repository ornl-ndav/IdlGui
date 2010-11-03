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
  file_name = 'SNS_offspec_instruments.cfg'
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



;test routine
d_SD_m = 1430*1e-3
d_MS_m = 13480*1e-3
tof_value = 200
tof_units = 'micros'
lambda = calculate_lambda(tof_value=tof_value, $
tof_units = tof_units, $
d_SD_m = d_SD_m, $
d_MS_m = d_MS_m, $
lambda_units = 'Angstroms')
print, '--> Test: Lambda for 200microsS is (Angstroms): ' , lambda
end

