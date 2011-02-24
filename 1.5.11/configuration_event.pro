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

;+
; :Description:
;    This function will create a structure of all the settings and parameters
;    used in the reduction
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function retrieve_cfg_structure, event
  compile_opt idl2
  
  iStructure = obj_new("IDLconfiguration")
  _structure = iStructure.getConfig(event)
  obj_destroy, iStructure
  
  return, _structure
end

;+
; :Description:
;    This routine is going to ask the user for a configuration file name
;    and will save the configuration of all the reduce tabs
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro save_configuration, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  path = (*global).config_path
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  cfg_full_file_name = dialog_pickfile(default_extension='.cfg',$
    dialog_parent=id, $
    filter='*.cfg',$
    /overwrite_prompt, $
    path=path, $
    ;file = 'remove_me',$
    /write,$
    get_path=new_path, $
    title='Save configuration file')
    
  if (cfg_full_file_name[0] eq '') then return
  
  cfg_structure = retrieve_cfg_structure(event)
  (*global).config_path = new_path
  
  catch, error
  error = 0
  if (error ne 0) then begin
    catch,/cancel
    
    message_text = ['Error while trying to create the configuration',$
      cfg_full_file_name,'','Please contact j35@ornl.gov to investigate error',$
      '','Configuration not save !']
    result = dialog_message(message_text, $
      /error, $
      dialog_parent=id,$
      /center, $
      title = 'Configuration not saved!')
      
  endif else begin
  
    save, cfg_structure, filename=cfg_full_file_name
    
  endelse
  
end


;+
; :Description:
;    will load a configuration file and will repopulate all the reduce tabs
;    with it
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro load_configuration, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  path = (*global).config_path
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  cfg_full_file_name = dialog_pickfile(default_extension='.cfg', $
    dialog_parent=id, $
    path=path, $
    /read, $
    filter = '*.cfg', $
    get_path=new_path, $
    title = 'Load configuration file')
    
  if (cfg_full_file_name[0] eq '') then return
  
  catch, error
  if (error ne 0) then begin
  catch,/cancel
    
    message_text = ['Configuration file failed to load!','',$
    ' File: ' + cfg_full_file_name[0], $
    'File format is not supported by this application']
    result = dialog_message (message_text,$
    /error,$
    /center,$
    dialog_parent=id,$
    title = 'Configuration file failed to load!')
  
  text = 'Loading of configuration file failed ! (' + cfg_full_file_name[0] + $
  ')'
  AppendLogBookMessage, Event, text

  endif else begin
  
  (*global).config_path = new_path
  restore, filename=cfg_full_file_name, /relaxed_structure_assignment
  
  repopulate_gui, event, cfg_structure

  text = 'Loaded configuration file: ' + cfg_full_file_name[0]
  AppendLogBookMessage, Event, text
  
  endelse
  
end

;+
; :Description:
;    repopulate the application using the config structure retrieved
;
; :Params:
;    event
;    cfg_structure
;
;
;
; :Author: j35
;-
pro repopulate_gui, event, cfg_structure
  compile_opt idl2
  
  ;1) Input
  putValue, event, 'rsdf_list_of_runs_text', cfg_structure.tf1_1
  putValue, event, 'bdf_list_of_runs_text', cfg_structure.tf2_1
  putValue, event, 'ndf_list_of_runs_text', cfg_structure.tf3_1
  putValue, event, 'ecdf_list_of_runs_text', cfg_structure.tf4_1
  putValue, event, 'dsb_list_of_runs_text', cfg_structure.tf5_1
  
  ;2) Input
  putValue, event, 'proif_text', cfg_structure.tf1_2
  putValue, event, 'aig_list_of_runs_text', cfg_structure.tf2_2
  SetButton, event, 'output_folder_name', cfg_structure.b1_2
  putValue, event, 'of_list_of_runs_text', cfg_structure.tf3_2
  
  ;3) Setup
  SetButton, event, 'rmcnf_button', cfg_structure.s1_3
  setButton, event, 'verbose_button', cfg_structure.s2_3
  setButton, event, 'absm_button', cfg_structure.s3_3
  setButton, event, 'nmn_button', cfg_structure.s4_3
  setButton, event, 'nmec_button', cfg_structure.s5_3
  
  setButton, event, 'niw_button', cfg_structure.s6_3
  _status = (cfg_structure.e1_3 eq 1) ? 1 : 0
  activate_button, event, 'niw_button', _status
  activate_button, event, 'nisw_field_label', _status
  activate_button, event, 'nisw_field', _status
  activate_button, event, 'niew_field_label', _status
  activate_button, event, 'niew_field', _status
  putValue, event, 'nisw_field', cfg_structure.tf1_3
  putValue, event, 'niew_field', cfg_structure.tf2_3
  
  setButton, event, 'te_button', cfg_structure.s7_3
  _status = (cfg_structure.e2_3 eq 1) ? 1 : 0
  activate_button, event, 'te_button', _status
  activate_button, event, 'te_low_field_label', _status
  activate_button, event, 'te_low_field', _status
  activate_button, event, 'te_high_field_label', _status
  activate_button, event, 'te_high_field', _status
  putValue, event, 'te_low_field', cfg_structure.tf3_3
  putValue, event, 'te_high_field', cfg_structure.tf4_3
  
  ;4) Time-Indep. Back
  SetButton, event, 'tib_tof_button', cfg_structure.s1_4
  _status = (cfg_structure.s1_4 eq 1) ? 1 : 0
  activate_button, event, 'tibtof_channel1_text_label', _status
  activate_button, event, 'tibtof_channel1_text', _status
  activate_button, event, 'tibtof_channel2_text_label', _status
  activate_button, event, 'tibtof_channel2_text', _status
  activate_button, event, 'tibtof_channel3_text_label', _status
  activate_button, event, 'tibtof_channel3_text', _status
  activate_button, event, 'tibtof_channel4_text_label', _status
  activate_button, event, 'tibtof_channel4_text', _status
  putValue, event, 'tibtof_channel1_text', cfg_structure.tf1_4
  putValue, event, 'tibtof_channel2_text', cfg_structure.tf2_4
  putValue, event, 'tibtof_channel3_text', cfg_structure.tf3_4
  putValue, event, 'tibtof_channel4_text', cfg_structure.tf4_4
  
  SetButton, event, 'tibc_for_sd_button', cfg_structure.s2_4
  _status = (cfg_structure.s2_4 eq 1) ? 1 : 0
  activate_button, event, 'tibc_for_sd_value_text_label', _status
  activate_button, event, 'tibc_for_sd_value_text', _status
  activate_button, event, 'tibc_for_sd_error_text_label', _status
  activate_button, event, 'tibc_for_sd_error_text', _status
  putValue, event, 'tibc_for_sd_value_text', cfg_structure.tf5_4
  putValue, event, 'tibc_for_sd_error_text', cfg_structure.tf6_4
  
  SetButton, event, 'tibc_for_bd_button', cfg_structure.s3_4
  _status = (cfg_structure.s3_4 eq 1) ? 1 : 0
  activate_button, event, 'tibc_for_bd_value_text_label', _status
  activate_button, event, 'tibc_for_bd_value_text', _status
  activate_button, event, 'tibc_for_bd_error_text_label', _status
  activate_button, event, 'tibc_for_bd_error_text', _status
  putValue, event, 'tibc_for_bd_value_text', cfg_structure.tf7_4
  putValue, event, 'tibc_for_bd_error_text', cfg_structure.tf8_4
  
  SetButton, event, 'tibc_for_nd_button', cfg_structure.s4_4
  _status = (cfg_structure.s4_4 eq 1) ? 1 : 0
  activate_button, event, 'tibc_for_nd_value_text_label', _status
  activate_button, event, 'tibc_for_nd_value_text', _status
  activate_button, event, 'tibc_for_nd_error_text_label', _status
  activate_button, event, 'tibc_for_nd_error_text', _status
  putValue, event, 'tibc_for_nd_value_text', cfg_structure.tf9_4
  putValue, event, 'tibc_for_nd_error_text', cfg_structure.tf10_4
  
  SetButton, event, 'tibc_for_ecd_button', cfg_structure.s5_4
  _status = (cfg_structure.s5_4 eq 1) ? 1 : 0
  activate_button, event, 'tibc_for_ecd_value_text_label', _status
  activate_button, event, 'tibc_for_ecd_value_text', _status
  activate_button, event, 'tibc_for_ecd_error_text_label', _status
  activate_button, event, 'tibc_for_ecd_error_text', _status
  putValue, event, 'tibc_for_ecd_value_text', cfg_structure.tf11_4
  putValue, event, 'tibc_for_ecd_error_text', cfg_structure.tf12_4
  
  SetButton, event, 'tibc_for_scatd_button', cfg_structure.s6_4
  _status = (cfg_structure.s6_4 eq 1) ? 1 : 0
  activate_button, event, 'tibc_for_scatd_value_text_label', _status
  activate_button, event, 'tibc_for_scatd_value_text', _status
  activate_button, event, 'tibc_for_scatd_error_text_label', _status
  activate_button, event, 'tibc_for_scatd_error_text', _status
  putValue, event, 'tibc_for_scatd_value_text', cfg_structure.tf13_4
  putValue, event, 'tibc_for_scatd_error_text', cfg_structure.tf14_4
  
  ;5) Lambda-Dep. Back.
  SetButton, event, 'use_iterative_background_subtraction_cw_bgroup', $
    cfg_structure.s1_5
  putValue, event, 'scale_constant_lambda_dependent_back_uname', $
    cfg_structure.tf1_5
  putValue, event, 'chopper_frequency_value', cfg_structure.tf2_5
  putValue, event, 'chopper_wavelength_value', cfg_structure.tf3_5
  putValue, event, 'tof_least_background_value', cfg_structure.tf4_5
  
  putValue, event, 'pte_min_text', cfg_structure.tf5_5
  putValue, event, 'pte_max_text', cfg_structure.tf6_5
  putValue, event, 'pte_bin_text', cfg_structure.tf7_5
  
  putValue, event, 'detailed_balance_temperature_value', cfg_structure.tf8_5
  putValue, event, 'ratio_tolerance_value', cfg_structure.tf9_5
  putValue, event, 'number_of_iteration', cfg_structure.tf10_5
  putValue, event, 'min_wave_dependent_back', cfg_structure.tf11_5
  putValue, event, 'max_wave_dependent_back', cfg_structure.tf12_5
  putValue, event, 'small_wave_dependent_back', cfg_structure.tf13_5
  
  activate_button, event, 'amorphous_reduction_verbosity_cw_bgroup', $
    cfg_structure.s2_5
    
  ;6) Scaling Cst.
  SetButton, event, 'csbss_button', cfg_structure.s1_6
  putValue, event, 'csbss_value_text', cfg_structure.tf1_6
  putValue, event, 'csbss_error_text', cfg_structure.tf2_6
  
  SetButton, event, 'csn_button', cfg_structure.s2_6
  putValue, event, 'csn_value_text', cfg_structure.tf3_6
  putValue, event, 'csn_error_text', cfg_structure.tf4_6
  
  SetButton, event, 'bcs_button', cfg_structure.s3_6
  putValue, event, 'bcs_value_text', cfg_structure.tf5_6
  putValue, event, 'bcs_error_text', cfg_structure.tf6_6
  
  SetButton, event, 'bcn_button', cfg_structure.s4_6
  putValue, event, 'bcn_value_text', cfg_structure.tf7_6
  putValue, event, 'bcn_value_text', cfg_structure.tf8_6
  
  SetButton, event, 'cs_button', cfg_structure.s5_6
  putValue, event, 'cs_value_text', cfg_structure.tf9_6
  putValue, event, 'cs_error_text', cfg_structure.tf10_6
  
  SetButton, event, 'cn_button', cfg_structure.s6_6
  putValue, event, 'cs_value_text', cfg_structure.tf11_6
  putValue, event, 'cs_error_text', cfg_structure.tf12_6
  
  ;7) Data Control
  SetButton, event, 'csfds_button', cfg_structure.s1_7
  putValue, event, 'csfds_value_text', cfg_structure.tf1_7
  
  SetButton, event, 'tzsp_button', cfg_structure.s2_7
  putValue, event, 'tzsp_value_text', cfg_structure.tf2_7
  putValue, event, 'tzsp_error_text', cfg_structure.tf3_7
  
  SetButton, event, 'tzop_button', cfg_structure.s3_7
  putValue, event, 'tzop_value_text', cfg_structure.tf4_7
  putValue, event, 'tzop_error_text', cfg_structure.tf5_7
  
  putValue, event, 'eha_min_text', cfg_structure.tf6_7
  putValue, event, 'eha_max_text', cfg_structure.tf7_7
  putValue, event, 'eha_bin_text', cfg_structure.tf8_7
  
  SetButton, event, 'mtha_button', cfg_structure.s4_7
  putValue, event, 'mtha_min_text', cfg_structure.tf9_7
  putValue, event, 'mtha_max_text', cfg_structure.tf10_7
  putValue, event, 'mtha_bin_text', cfg_structure.tf11_7
  
  SetButton, event, 'gifw_button', cfg_structure.s5_7
  putValue, event, 'gifw_value_text', cfg_structure.tf12_7
  putValue, event, 'gifw_error_text', cfg_structure.tf13_7
  
  SetButton, event, 'tof_cutting_button', cfg_structure.s6_7
  putValue, event, 'tof_cutting_min_text', cfg_structure.tf14_7
  putValue, event, 'tof_cutting_max_text', cfg_structure.tf15_7
  
  SetButton, event, 'scale_sqe_by_solid_angle_group_uname', $
  cfg_structure.s7_7
  
  ;8) Output
  SetButton, event, 'waio_button', cfg_structure.s1_8
  SetButton, event, 'woctib_button', cfg_structure.s2_8
  SetButton, event, 'wopws_button', cfg_structure.s3_8
  SetButton, event, 'womws_button', cfg_structure.s4_8
  SetButton, event, 'womes_button', cfg_structure.s5_8
  SetButton, event, 'worms_button', cfg_structure.s6_8
  SetButton, event, 'wocpsamn_button', cfg_structure.s7_8
  putValue, event, 'wa_min_text', cfg_structure.tf1_8
  putValue, event, 'wa_max_text', cfg_structure.tf2_8
  putValue, event, 'wa_bin_width_text', cfg_structure.tf3_8
  SetButton, event, 'wolidsb_button', cfg_structure.s8_8
  SetButton, event, 'pwsavn_button', cfg_structure.s9_8
  SetButton, event, 'sad', cfg_structure.s10_8
  
  ;Refresh GUI
  BSSreduction_Reduce_use_iterative_back, Event
  BSSreduction_CommandLineGenerator, Event
  
  
end


