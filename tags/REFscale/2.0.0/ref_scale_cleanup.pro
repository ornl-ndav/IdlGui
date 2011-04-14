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
pro ref_scale_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global, /no_copy
  
  cleaning_base_id = (*global).cleaning_base_id
  if (widget_info(cleaning_base_id,/valid_id) ne 0) then begin
    widget_control, cleaning_base_id,/destroy
  endif
  
  if (n_elements(global) eq 0) then return
  
  ;free up the pointers of the global pointer
  ptr_free, (*global).BatchTable
  ptr_free, (*global).data_spin_state
  ptr_free, (*global).norm_spin_state
  ptr_free, (*global).list_of_spins_for_each_angle
  ptr_free, (*global).DRfiles
  ptr_free, (*global).flt0_ptr
  ptr_free, (*global).flt1_ptr
  ptr_free, (*global).flt2_ptr
  ptr_free, (*global).flt0_rescale_ptr
  ptr_free, (*global).flt1_rescale_ptr
  ptr_free, (*global).flt2_rescale_ptr
  ptr_free, (*global).fit_cooef_ptr
  ptr_free, (*global).flt0_range
  ptr_free, (*global).XYMinMax
  ptr_free, (*global).CEcooef
  ptr_free, (*global).flt0_CE_range
  ptr_free, (*global).metadata_CE_file
  ptr_free, (*global).flt0_xaxis
  ptr_free, (*global).flt1_yaxis
  ptr_free, (*global).flt2_yaxis_err
  ptr_free, (*global).FileHistory
  ptr_free, (*global).list_of_files
  ptr_free, (*global).Q1_array
  ptr_free, (*global).Q2_array
  ptr_free, (*global).SF_array
  ptr_free, (*global).angle_array
  ptr_free, (*global).color_array
  ptr_free, (*global).Qmin_array
  ptr_free, (*global).Qmax_array
  ptr_free, (*global).ListOfLongFileName
  ptr_free, global
  
end