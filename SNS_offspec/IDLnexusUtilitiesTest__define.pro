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
;    Test to retrieve d_SD value for old REF_M file format
;    and for spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_M_SD_value
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_5000.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_d_SD()
  
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
function IDLnexusUtilitiesTest::test_REF_M_SD_unit
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_5000.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_d_SD()
  
  assert, v_u[1] eq 'millimetre', 'Wrong d_SD unit for REF_M_5000 (old NeXus format) Off_Off'
  
  return, 1
end

;+
; :Description:
;    Test to retrieve d_SD value for old REF_L
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_L_SD_value
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_L_38955.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name)
  v_u = myObject->get_d_SD()
  
  assert, v_u[0] eq '1430.0', 'Wrong d_SD value for REF_L_38599'
  
  return, 1
end

;+
; :Description:
;    Test to retrieve d_SD unit for old REF_M file format
;    and for spin state Off_Off
;
; :Author: j35
;-
function IDLnexusUtilitiesTest::test_REF_L_SD_unit
  compile_opt idl2
  
  file_name= 'unit_test_files/REF_M_5000.nxs'
  myObject = obj_new('IDLnexusUtilities',file_name, spin_state='Off_Off')
  v_u = myObject->get_d_SD()
  
  assert, v_u[1] eq 'millimetre', 'Wrong d_SD unit for REFL_L_38599'
  
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