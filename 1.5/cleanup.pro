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
;    Kill the center pixel base when leaving the main application
;
; :Params:
;    global
;
; :Author: j35
;-
pro centerpix_base_uname_killed, global
  compile_opt idl2
  
  id = (*global).center_px_counts_vs_pixel_base_id
  if (widget_info(id, /valid_id) ne 0) then begin
    widget_control, id, /destroy
  endif
  
end

;+
; :Description:
;    This routine is ran just before the main program exit.
;
; :Params:
;    tlb
;
; :Author: j35
;-
pro ref_reduction_Cleanup, tlb
compile_opt idl2

  WIDGET_CONTROL, tlb, GET_UVALUE=global, /NO_COPY

  ;kill the center pixel base if there
  centerpix_base_uname_killed, global

  IF N_ELEMENTS(global) EQ 0 THEN RETURN
  
  ; Free up the pointers
  ptr_free, (*global).substrate_type
  ptr_free, (*global).counts_vs_pixel
  ptr_free, (*global).tof_axis_ms
  ptr_free, (*global).in_empty_cell_empty_cell_ptr
  ptr_free, (*global).in_empty_cell_data_ptr
  ptr_free, (*global).empty_cell_d_tvimg
  ptr_free, (*global).empty_cell_ec_tvimg
  ptr_free, (*global).empty_cell_images
  ptr_free, (*global).sf_data_tof
  ptr_free, (*global).sf_empty_cell_tof
  ptr_free, (*global).distance_sample_pixel_array
  ptr_free, (*global).sf_recap_d_total_ptr
  ptr_free, (*global).list_pola_state
  ptr_free, (*global).my_package
  ptr_free, (*global).debugging_structure
  ptr_free, (*global).batch_data_runs
  ptr_free, (*global).batch_norm_runs
  ptr_free, (*global).batch_NormNexus
  ptr_free, (*global).batch_dataNexus
  ptr_free, (*global).BatchTable
  ptr_free, (*global).Xarray
  ptr_free, (*global).Yarray
  ptr_free, (*global).SigmaYarray
  ptr_free, (*global).Xarray_untouched
  ptr_free, (*global).bank1_data
  ptr_free, (*global).new_rescaled_tvimg
  ptr_free, (*global).bank1_norm
  ptr_free, (*global).bank1_empty_cell
  ptr_free, (*global).FilesToPlotList
  ptr_free, (*global).PlotsTitle
  ptr_free, (*global).CurrentPlotsFullFileName
  ptr_free, (*global).ExtOfAllPlots
  ptr_free, (*global).data_dd_ptr
  ptr_free, (*global).data_d_ptr
  ptr_free, (*global).empty_cell_dd_ptr
  ptr_free, (*global).data_d_total_ptr
  ptr_free, (*global).norm_d_total_ptr
  ptr_free, (*global).empty_cell_d_ptr
  ptr_free, (*global).empty_cell_d_total_ptr
  ptr_free, (*global).norm_dd_ptr
  ptr_free, (*global).tvimg_empty_cell_ptr
  ptr_free, (*global).tvimg_norm_ptr
  ptr_free, (*global).data_roi_selection
  ptr_free, (*global).norm_roi_selection
  ptr_free, (*global).data_back_selection
  ptr_free, (*global).norm_back_selection
  ptr_free, (*global).norm_peak_selection
  ptr_free, (*global).data_peak_selection
  ptr_free, (*global).flt0_ptr
  ptr_free, (*global).flt1_ptr
  ptr_free, (*global).flt2_ptr
  ptr_free, (*global).fltPreview_ptr
  ptr_free, (*global).fltPreview_xml_ptr
  ptr_free, (*global).DataXYZminmaxArray
  ptr_free, (*global).NormXYZminmaxArray
  ptr_free, (*global).data_1d_3d_min_max
  ptr_free, (*global).data_2d_3d_min_max
  ptr_free, (*global).normalization_1d_3d_min_max
  ptr_free, (*global).normalization_2d_3d_min_max
  
  ptr_free, global
  
END