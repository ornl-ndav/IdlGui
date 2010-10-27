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

pro full_reset, event, except_files_sf_list=except_files_sf_list
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  (*global).stop_scaling_spin_status = intarr(4)
  (*global).list_of_files_created = ptr_new(0L)
  
  (*global).master_data = ptrarr(4,/allocate_heap)
  (*global).master_data_error = ptrarr(4,/allocate_heap)
  (*global).master_xaxis = ptrarr(4,/allocate_heap)
  
  (*global).tmp_pData_x = ptr_new(0L)
  (*global).tmp_pData_y = ptr_new(0L)
  (*global).tmp_pData_y_error = ptr_new(0L)
  
  (*global).tmp_pData_x_2d = ptr_new(0L)
  (*global).tmp_pData_y_2d = ptr_new(0L)
  (*global).tmp_pData_y_error_2d = ptr_new(0L)
  
  (*global).pData_x = ptrarr(20,4,/allocate_heap)
  (*global).pData_y = ptrarr(20,4,/allocate_heap)
  (*global).pData_y_error = ptrarr(20,4,/allocate_heap)
  
  (*global).file_index_sorted = ptrarr(4,/allocate_heap) 
  if (n_elements(except_files_sf_list) eq 0) then begin
  (*global).files_SF_list = strarr(4,3,20)
  endif
  
end

