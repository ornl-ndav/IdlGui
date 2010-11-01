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

;************************* REF_M / d_SD **************************************

;+
; :Description:
;    Test to retrieve d_SD value for old REF_M file format
;    and for spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_old_SD_value
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_5000.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_d_SD()
  obj_destroy, myObject
  
  assert, v_u[0] eq '2340.00', 'Wrong d_SD value for REF_M_5000 (old NeXus format) Off_Off'
  
  return, 1
end

;+
; :Description:
;    Test to retrieve d_SD unit for old REF_M file format
;    and for spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_old_SD_unit
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_5000.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_d_SD()
  obj_destroy, myObject
  
  assert, v_u[1] eq 'millimetre', 'Wrong d_SD unit for REF_M_5000 (old NeXus format) Off_Off'
  
  return, 1
end

;+
; :Description:
;    Test to retrieve d_SD value for new REF_M file format
;    and for spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_new_SD_value
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_8324.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_d_SD()
  obj_destroy, myObject
  
  assert, v_u[0] eq '2562.00', 'Wrong d_SD value for REF_M_8324 (new NeXus format) Off_Off'
  
  return, 1
end

;+
; :Description:
;    Test to retrieve d_SD unit for new REF_M file format
;    and for spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_new_SD_unit
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_5000.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_d_SD()
  obj_destroy, myObject
  
  assert, v_u[1] eq 'millimetre', 'Wrong d_SD unit for REF_M_8324 (new NeXus format) Off_Off'
  
  return, 1
end

;************************* REF_L / d_SD **************************************

;+
; :Description:
;    Test to retrieve d_SD value for REF_L
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_L_SD_value
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_L_38955.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name)
  v_u = myObject->get_d_SD()
  obj_destroy, myObject
  
  assert, v_u[0] eq '1430.0', 'Wrong d_SD value for REF_L_38955'
  
  return, 1
end

;+
; :Description:
;    Test to retrieve d_SD unit for REF_L
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_L_SD_unit
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_L_38955.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name)
  v_u = myObject->get_d_SD()
  obj_destroy, myObject
  
  assert, v_u[1] eq 'mm', 'Wrong d_SD unit for REFL_L_38955'
  
  return, 1
end

;************************* REF_L / theta **************************************

;+
; :Description:
;    Test to retrieve theta for REF_L
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_L_theta_value
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_L_38955.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name)
  v_u = myObject->get_theta()
  obj_destroy, myObject
  
  assert, v_u[0] eq '0.730263', 'Wrong theta value for REF_L_38955'
  
  return, 1
end


;+
; :Description:
;    Test to retrieve theta unit for REF_L
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_L_theta_unit
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_L_38955.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name)
  v_u = myObject->get_theta()
  obj_destroy, myObject
  
  assert, v_u[1] eq 'degree', 'Wrong theta unit for REF_L_38955'
  
  return, 1
end


;************************* REF_M / theta **************************************

;+
; :Description:
;    Test to retrieve theta unit for old REF_M
;    spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_old_theta_unit
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_5000.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_theta()
  obj_destroy, myObject
  
  assert, v_u[1] eq '', 'Wrong theta unit for REF_M_5000 (old format)'
  
  return, 1
end

;+
; :Description:
;    Test to retrieve theta value for old REF_M
;    spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_old_theta_value
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_5000.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_theta()
  obj_destroy, myObject
  
  assert, v_u[0] eq '', 'Wrong theta value for REF_M_5000 (old format)'
  
  return, 1
end

;+
; :Description:
;    Test to retrieve theta unit for new REF_M
;    spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_new_theta_unit
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_8324.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_theta()
  obj_destroy, myObject
  
  assert, v_u[1] eq '', 'Wrong theta unit for REF_M_8324 (new format)'
  
  return, 1
end

;+
; :Description:
;    Test to retrieve theta value for new REF_M
;    spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_new_theta_value
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_8324.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_theta()
  obj_destroy, myObject
  
  assert, v_u[0] eq '', 'Wrong theta value for REF_M_8324 (new format)'
  
  return, 1
end

;************************* REF_L / twotheta ***********************************

;+
; :Description:
;    Test to retrieve twotheta for REF_L
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_L_twotheta_value
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_L_38955.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name)
  v_u = myObject->get_twotheta()
  obj_destroy, myObject
  
  assert, v_u[0] eq '5.46954', 'Wrong twotheta value for REF_L_38955'
  
  return, 1
end

;+
; :Description:
;    Test to retrieve twotheta unit for REF_L
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_L_twotheta_unit
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_L_38955.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name)
  v_u = myObject->get_twotheta()
  obj_destroy, myObject
  
  assert, v_u[1] eq 'degree', 'Wrong twotheta value for REFL_38955'
  
  return, 1
end

;************************* REF_M / twotheta ***********************************

;+
; :Description:
;    Test to retrieve twotheta unit for old REF_M
;    spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_old_twotheta_unit
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_5000.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_twotheta()
  obj_destroy, myObject
  
  assert, v_u[1] eq '', 'Wrong twotheta unit for REF_M_5000 (old format)'
  
  return, 1
end

;+
; :Description:
;    Test to retrieve twotheta value for old REF_M
;    spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_old_twotheta_value
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_5000.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_twotheta()
  obj_destroy, myObject
  
  assert, v_u[0] eq '', 'Wrong twotheta value for REF_M_5000 (old format)'
  
  return, 1
end

;************************* REF_L&M / full data ********************************

;+
; :Description:
;    Test of the full data set for the REF_L nexus file
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_L_full_data
  compile_opt idl2
  
  file_name = 'unit_test_files/REF_L_38955.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name)
  data = myObject->get_full_data()
  obj_destroy, myObject

  data_sz = size(data)
  assert, array_equal(data_sz,[3,751,256,304,13,58445824]), $
    'Wrong format of full data retrieved from REF_L_38955'
    
  return, 1
end

;+
; :Description:
;    Test of the full data set for the old REF_M nexus file
;    spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_old_full_data
  compile_opt idl2
  
  file_name = 'unit_test_files/REF_M_5000.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  data = myObject->get_full_data()
  obj_destroy, myObject

  data_sz = size(data)
  assert, array_equal(data_sz,[3,251,256,304,13,19533824]), $
    'Wrong format of full data retrieved from REF_M_5000 (old format)'
    
  return, 1
end

;+
; :Description:
;    Test of the full data set for the new REF_M nexus file
;    spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_new_full_data
  compile_opt idl2
  
  file_name = 'unit_test_files/REF_M_8324.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  data = myObject->get_full_data()
  obj_destroy, myObject

  data_sz = size(data)
  assert, array_equal(data_sz,[3,51,256,304,13,3969024]), $
    'Wrong format of full data retrieved from REF_M_8324 (new format)'
    
  return, 1
end

;************************* REF_L&M / tof counts *******************************

;+
; :Description:
;    Test of the tof/counts data set for the REF_L nexus file
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_L_tof_counts_data
  compile_opt idl2
  
  file_name = 'unit_test_files/REF_L_38955.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name)
  data = myObject->get_tof_counts_data()
  obj_destroy, myObject

  data_sz = size(data)
  assert, array_equal(data_sz,[2,2,751,4,1502]), $
    'Wrong format of tof/counts data retrieved from REF_L_38955'
  
  assert, array_equal(data[0:9],$
  [0.0, 0.0, 0.2, 0.0, 0.4, 0.0, 0.6, 0.0, 0.8, 0.0]), $
  'Wrong first 10 values of tof/counts data retrieved from REF_L_38955'  
    
  return, 1
end

;+
; :Description:
;    Test of the tof/counts data set for the old REF_M nexus file
;    spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_old_tof_counts_data
  compile_opt idl2
  
  file_name = 'unit_test_files/REF_M_5000.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  data = myObject->get_tof_counts_data()
  obj_destroy, myObject

  data_sz = size(data)
  assert, array_equal(data_sz,[2,2,251,4,502]), $
    'Wrong format of tof/counts data retrieved from REF_M_5000 (old format)'
  
  assert, array_equal(data[0:9],$
  [0.0, 0.0, 0.4, 0.0, 0.8, 0.0, 1.2, 0.0, 1.6, 0.0]), $
  'Wrong first 10 values of tof/counts data retrieved from REF_M_5000 (old format)'  
    
  return, 1
end

;+
; :Description:
;    Test of the tof/counts data set for the new REF_M nexus file
;    spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_new_tof_counts_data
  compile_opt idl2
  
  file_name = 'unit_test_files/REF_M_8324.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  data = myObject->get_tof_counts_data()
  obj_destroy, myObject

  data_sz = size(data)
  assert, array_equal(data_sz,[2,2,51,4,102]), $
    'Wrong format of tof/counts data retrieved from REF_M_8324 (new format)'
  
  assert, array_equal(data[0:9],$
  [8.0, 0.0, 8.4, 0.0, 8.8, 0.0, 9.2, 0.0, 9.6, 1.0]), $
  'Wrong first 10 values of tof/counts data retrieved from REF_M_8324 (new format)'  
    
  return, 1
end

;+
; :Description:
;    Test unit for class IDLnexusUtilities__define
;
; :Author: j35
;-
pro IDLnexusUtilitiesTest__define
  define = {IDLnexusUtilitiesTest, inherits MGtestCase }
end