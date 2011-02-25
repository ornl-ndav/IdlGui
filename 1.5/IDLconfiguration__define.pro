;===============================================================================
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
;===============================================================================

function IDLconfiguration::getConfig, event
  compile_opt idl2
  
  ;tf: text field
  ;b : button
  ;s : switch (switch button that can be ON or OFF)
  ;eb: enabled button
  
  ;1) Input
  _structure = {tf1_1: getTextFieldValue(event, 'rsdf_run_number_cw_field'), $
    tf2_1: getTextFieldValue(event, 'bdf_run_number_cw_field'), $
    tf3_1: getTextFieldValue(event, 'ndf_run_number_cw_field'), $
    tf4_1: getTextFieldValue(event, 'ecdf_run_number_cw_field'), $
    tf5_1: getTextFieldValue(event, 'dsb_run_number_cw_field'), $
    
    ;2) Input
    tf1_2: getTextFieldValue(event, 'proif_text'), $
    tf2_2: getTextFieldValue(event, 'aig_list_of_runs_text'), $
    b1_2:  getButtonvalue(event, 'output_folder_name'), $
    tf3_2: getTextFieldValue(event, 'of_list_of_runs_text'), $
    
    ;3) Setup
    s1_3: isButtonSelected(event, 'rmcnf_button'), $
    s2_3: isButtonSelected(event, 'verbose_button'), $
    s3_3: isButtonSelected(event, 'absm_button'), $
    s4_3: isButtonSelected(event, 'nmn_button'), $
    s5_3: isButtonSelected(event, 'nmec_button'), $
    s6_3: isButtonSelected(event, 'niw_button'), $
    e1_3: isButtonEnabled(event, 'niw_button'), $
    tf1_3: getTextFieldValue(event, 'nisw_field'), $
    tf2_3: getTextFieldValue(event, 'niew_field'), $
    s7_3: isButtonSelected(event, 'te_button'), $
    e2_3: isButtonEnabled(event, 'te_button'), $
    tf3_3: getTextFieldValue(event, 'te_low_field'), $
    tf4_3: getTextFieldValue(event, 'te_high_field'), $
    
    ;4) Time-Indep. Back
    s1_4: isButtonSelected(event, 'tib_tof_button'), $
    tf1_4: getTextFieldValue(event, 'tibtof_channel1_text'), $
    tf2_4: getTextFieldValue(event,  'tibtof_channel2_text'), $
    tf3_4: getTextFieldValue(event, 'tibtof_channel3_text'), $
    tf4_4: getTextFieldValue(event, 'tibtof_channel4_text'), $
    
    s2_4: isButtonSelected(event, 'tibc_for_sd_button'), $
    tf5_4: getTextFieldValue(event, 'tibc_for_sd_value_text'), $
    tf6_4: getTextFieldValue(event, 'tibc_for_sd_error_text'), $
    
    s3_4: isButtonSelected(event, 'tibc_for_bd_button'), $
    tf7_4: getTextFieldValue(event, 'tibc_for_bd_value_text'), $
    tf8_4: getTextFieldValue(event, 'tibc_for_bd_error_text'), $
    
    s4_4: isButtonSelected(event, 'tibc_for_nd_button'), $
    tf9_4: getTextFieldValue(event, 'tibc_for_nd_value_text'), $
    tf10_4: getTextFieldValue(event, 'tibc_for_nd_error_text'), $
    
    s5_4: isButtonSelected(event, 'tibc_for_ecd_button'), $
    tf11_4: getTextFieldValue(event, 'tibc_for_ecd_value_text'), $
    tf12_4: getTextFieldValue(event, 'tibc_for_ecd_error_text'), $
    
    s6_4: isButtonSelected(event, 'tibc_for_scatd_button'), $
    tf13_4: getTextFieldValue(event, 'tibc_for_scatd_value_text'), $
    tf14_4: getTextFieldValue(event, 'tibc_for_scatd_error_text'), $
    
    ;5) Lambda-Dep. Back
    s1_5: isButtonSelected(event, $
    'use_iterative_background_subtraction_cw_bgroup'), $
    tf1_5: getTextFieldValue(event, $
    'scale_constant_lambda_dependent_back_uname'), $
    tf2_5: getTextFieldValue(event, 'chopper_frequency_value'), $
    tf3_5: getTextFieldValue(event, 'chopper_wavelength_value'), $
    tf4_5: getTextFieldValue(event, 'tof_least_background_value'), $
    
    tf5_5: getTextFieldValue(event, 'pte_min_text'), $
    tf6_5: getTextFieldValue(event, 'pte_max_text'), $
    tf7_5: getTextFieldValue(event, 'pte_bin_text'), $
    
    tf8_5: getTextFieldValue(event, 'detailed_balance_temperature_value'), $
    tf9_5: getTextFieldValue(event, 'ratio_tolerance_value'), $
    tf10_5: getTextFieldValue(event, 'number_of_iteration'), $
    tf11_5: getTextFieldValue(event, 'min_wave_dependent_back'), $
    tf12_5: getTextFieldValue(event, 'max_wave_dependent_back'), $
    tf13_5: getTextFieldValue(event, 'small_wave_dependent_back'), $
    
    s2_5: isButtonSelected(event, 'amorphous_reduction_verbosity_cw_bgroup'), $
    
    ;6) Scaling Cst.
    s1_6: isButtonSelected(event, 'csbss_button'), $
    tf1_6: getTextFieldValue(event, 'csbss_value_text'), $
    tf2_6: getTextFieldValue(event, 'csbss_error_text'), $
    
    s2_6: isButtonSelected(event, 'csn_button'), $
    tf3_6: getTextFieldValue(event, 'csn_value_text'), $
    tf4_6: getTextFieldValue(event, 'csn_error_text'), $
    
    s3_6: isButtonSelected(event, 'bcs_button'), $
    tf5_6: getTextFieldValue(event, 'bcs_value_text'), $
    tf6_6: getTextFieldValue(event, 'bcs_error_text'), $
    
    s4_6: isButtonSelected(event, 'bcn_button'), $
    tf7_6: getTextFieldValue(event, 'bcn_value_text'), $
    tf8_6: getTextFieldValue(event, 'bcn_error_text'), $
    
    s5_6: isButtonSelected(event, 'cs_button'), $
    tf9_6: getTextFieldValue(event, 'cs_value_text'), $
    tf10_6: getTextFieldValue(event, 'cs_error_text'), $
    
    s6_6: isButtonSelected(event, 'cn_button'), $
    tf11_6: getTextFieldValue(event, 'cn_value_text'), $
    tf12_6: getTextFieldValue(event, 'cn_error_text'), $
    
    ;7) Data Control
    s1_7: isButtonSelected(event, 'csfds_button'), $
    tf1_7: getTextFieldValue(event, 'csfds_value_text'), $
    
    s2_7: isButtonSelected(event, 'tzsp_button'), $
    tf2_7: getTextFieldValue(event, 'tzsp_value_text'), $
    tf3_7: getTextFieldValue(event, 'tzsp_error_text'), $
    
    s3_7: isButtonSelected(event, 'tzop_button'), $
    tf4_7: getTextFieldValue(event, 'tzop_value_text'), $
    tf5_7: getTextFieldValue(event, 'tzop_error_text'), $
    
    tf6_7: getTextFieldValue(event, 'eha_min_text'), $
    tf7_7: getTextFieldValue(event, 'eha_max_text'), $
    tf8_7: getTextFieldValue(event, 'eha_bin_text'), $
    
    s4_7: isButtonSelected(event, 'mtha_button'), $
    tf9_7: getTextFieldValue(event, 'mtha_min_text'), $
    tf10_7: getTextFieldValue(event, 'mtha_max_text'), $
    tf11_7: getTextFieldValue(event, 'mtha_bin_text'), $
    
    s5_7: isButtonSelected(event, 'gifw_button'), $
    tf12_7: getTextFieldValue(event, 'gifw_value_text'), $
    tf13_7: getTextfieldValue(event, 'gifw_error_text'), $
    
    s6_7: isButtonSelected(event, 'tof_cutting_button'), $
    tf14_7: getTextFieldValue(event, 'tof_cutting_min_text'), $
    tf15_7: getTextFieldValue(event, 'tof_cutting_max_text'), $
    
    s7_7: isButtonSelected(event, 'scale_sqe_by_solid_angle_group_uname'), $
    
    ;8) Output
    s1_8: isButtonSelected(event, 'waio_button'), $
    s2_8: isButtonSelected(event, 'woctib_button'), $
    s3_8: isButtonSelected(event, 'wopws_button'), $
    s4_8: isButtonSelected(event, 'womws_button'), $
    s5_8: isButtonSelected(event, 'womes_button'), $
    s6_8: isButtonSelected(event, 'worms_button'), $
    s7_8: isButtonSelected(event, 'wocpsamn_button'), $
    tf1_8: getTextFieldValue(event, 'wa_min_text'), $
    tf2_8: getTextFieldValue(event, 'wa_max_text'), $
    tf3_8: getTextFieldValue(event, 'wa_bin_width_text'), $
    s8_8: isButtonSelected(event, 'wolidsb_button'), $
    s9_8: isButtonSelected(event, 'pwsavn_button'), $
    s10_8: isButtonSelected(event, 'sad')}
    
  return, _structure
end

function IDLconfiguration::init
  return, 1
end


pro IDLconfiguration__define
  void = {IDLconfiguration, $
    tmp: ''}
end



