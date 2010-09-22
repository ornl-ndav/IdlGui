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
;   This routine cleanup all the pointers from the main program and is
;   reached when the application is exited.
;
; :Params:
;    tlb
;
; :Author: j35
;-
pro ref_off_scale_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global, /no_copy

  if (n_elements(global) eq 0) then return
  
  ptr_free, (*global).tmp_pData_x
  ptr_free, (*global).tmp_pData_y
  ptr_free, (*global).tmp_pData_y_error
  
  ptr_free, (*global).pData_x
  ptr_free, (*global).pData_y
  ptr_free, (*global).pData_y_error
  
  ptr_free, (*global).pData_x_2d
  ptr_free, (*global).pData_y_2d
  ptr_free, (*global).pData_y_error_2d
  
  ptr_free, (*global).pDataPlot_x
  ptr_free, (*global).pDataPlot_y
  ptr_free, (*global).pDataPlot_y_error
  
  ptr_free, global
  
end
