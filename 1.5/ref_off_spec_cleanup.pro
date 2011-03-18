;+
; :Description:
;    this function is reached when the main application is destroy
;
; :Params:
;    tlb
;
;
;
; :Author: j35
;-
pro ref_off_spec_cleanup, tlb
  compile_opt idl2
  
  widget_control, tlb, get_uvalue=global, /no_copy
  
  tof_selection_base_uname_killed, global
  
  if (n_elements(global) eq 0) then return
  
  ptr_free, (*global).roi_base_background
  ptr_free, (*global).norm_tof
  ptr_free, (*global).tmp_norm_tof
  ptr_free, (*global).reduce_tab1_table
  ptr_free, (*global).reduce_tab1_nexus_file_list
  ptr_free, (*global).reduce_run_sangle_table
  ptr_free, (*global).sangle_tData
  ptr_free, (*global).sangle_tof
  ptr_free, (*global).sangle_background_plot
  ptr_free, (*global).list_of_files_to_load_in_step2
  ptr_free, (*global).reduce_tab2_nexus_file_list
  ptr_free, (*global).norm_data
  ptr_free, (*global).norm_tData
  ptr_free, (*global).norm_rtData
  ptr_free, (*global).norm_rtData_log
  ptr_free, (*global).nexus_spin_state_roi_table
  ptr_free, (*global).nexus_spin_state_back_roi_table
  ptr_free, (*global).array_selected_total_backup
  ptr_free, (*global).array_selected_total_error_backup
  ptr_free, (*global).step5_selection_x_array
  ptr_free, (*global).step5_selection_y_array
  ptr_free, (*global).step5_selection_y_error_array
  ptr_free, (*global).pixel_offset_array
  ptr_free, (*global).step4_2_2_x_array_to_fit
  ptr_free, (*global).ref_pixel_list
  ptr_free, (*global).ref_pixel_offset_list
  ptr_free, (*global).ref_pixel_list_original
  ptr_free, (*global).RefPixSave
  ptr_free, (*global).PreviousRefPix
  ptr_free, (*global).SangleDone
  ptr_free, (*global).ref_x_list
  ptr_free, (*global).congrid_coeff_array
  ptr_free, (*global).list_of_ascii_files
  ptr_free, (*global).list_of_ascii_files_p1
  ptr_free, (*global).list_of_ascii_files_p2
  ptr_free, (*global).list_of_ascii_files_p3
  ptr_free, (*global).short_list_of_ascii_files
  ptr_free, (*global).trans_coeff_list
  ptr_free, (*global).pData
  ptr_free, (*global).pData_y
  ptr_free, (*global).pData_y_error
  ptr_free, (*global).realign_pData_y
  ptr_free, (*global).realign_pData_y_error
  ptr_free, (*global).pData_x
  ptr_free, (*global).x_axis
  ptr_free, (*global).x_axis_max_values
  ptr_free, (*global).total_array
  ptr_free, (*global).total_array_untouched
  ptr_free, (*global).total_array_error
  ptr_free, (*global).total_array_error_untouched
  ptr_free, (*global).step4_step2_step1_xrange
  ptr_free, (*global).step4_step2_data_to_plot
  ptr_free, (*global).ivslambda_selection
  ptr_free, (*global).new_ivslambda_selection
  ptr_free, (*global).ivslambda_selection_backup
  ptr_free, (*global).ivslambda_selection_error_backup
  ptr_free, (*global).ivslambda_selection_step3_backup
  ptr_free, (*global).ivslambda_selection_error_step3_backup
  
  ptr_free, global
  
end

;+
; :Description:
;   Reached when the main base is killed
;
; :Params:
;    global
;
; :Author: j35
;-
pro tof_selection_base_uname_killed, global
  compile_opt idl2
  
  id_base = (*global).roi_selection_counts_vs_pixel_base_id
  if (widget_info(id_base, /valid_id) ne 0) then begin
    WIDGET_CONTROL, id_base,/DESTROY
  endif
  
end