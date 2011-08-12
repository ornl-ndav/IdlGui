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
;    This routine will load a configuration file and will
;    repopulate all the fields using these infos
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro load_configuration, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  path = (*global).config_path
  id = widget_info(event.top, find_by_uname='main_base')
  
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
      
    message = 'Loading of configuration file: ' + cfg_full_file_name[0] + $
      ' ... FAILED!'
    Log_book_update, event, message=message
    
  endif else begin
  
    (*global).config_path = new_path
    restore, filename=cfg_full_file_name, /relaxed_structure_assignment
    
    repopulate_gui, event, cfg_structure
    check_go_button, event=event
    
    message = 'Loading of configuration file: ' + cfg_full_file_name[0] + $
      ' ... OK!'
    Log_book_update, event, message=message
    
  endelse
  
end

;+
; :Description:
;    This function will create a structure of all the settings and parameters
;    used in the application
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
;    and will save the configuration currently in used
;
; :Keywords:
;    event
;
;
;
; :Author: j35
;-
pro save_configuration, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  path = (*global).config_path
  id = widget_info(event.top, find_by_uname='main_base')
  
  cfg_full_file_name = dialog_pickfile(default_extension='.cfg',$
    dialog_parent=id, $
    filter='*.cfg',$
    /overwrite_prompt, $
    path=path, $
    /write,$
    get_path=new_path, $
    title='Save configuration file')
    
  if (cfg_full_file_name[0] eq '') then return
  
  cfg_structure = retrieve_cfg_structure(event)
  (*global).config_path = new_path
  
  catch, error
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
    text = 'Save configuration file: ' + cfg_full_file_name[0] + ' FAILED!'
    Log_book_update, Event, message=text
    
    message = 'Saving configuration into file: ' + cfg_full_file_name[0] + $
      ' ... FAILED!'
    Log_book_update, event, message=message
    
  endif else begin
  
    save, cfg_structure, filename=cfg_full_file_name
    
    text = 'Saved configuration file: ' + cfg_full_file_name[0]
    Log_book_update, Event, message=text
    
    message = 'Saving configuration into file: ' + cfg_full_file_name[0] + $
      ' ... OK!'
    Log_book_update, event, message=message
    
  endelse
  
end

;+
; :Description:
;    repopulate the application using the config structure retrieved
;
; :Params:
;    event
;    _structure
;
;
;
; :Author: j35
;-
pro repopulate_gui, event, _structure
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;working with NeXus
  data_norm_table = _structure.data_norm_table
  putValue, event=event, 'tab1_table', data_norm_table
  (*global).big_table = data_norm_table
  (*global).input_path = _structure.input_path
  
  ;settings base
  putValue, event=event, 'ranges_qx_min', _structure.ranges_qx_min
  putValue, event=event, 'ranges_qz_min', _structure.ranges_qz_min
  putValue, event=event, 'tof_min', _structure.tof_min
  putValue, event=event, 'ranges_qx_max', _structure.ranges_qx_max
  putValue, event=event, 'ranges_qz_max', _structure.ranges_qz_max
  putValue, event=event, 'tof_max', _structure.tof_max
  
  putValue, event=event, 'center_pixel', _structure.center_pixel
  putValue, event=event, 'pixel_size', _structure.pixel_size
  
  putValue, event=event, 'detector_dimension_x', $
    _structure.detector_dimension_x
  putValue, event=event, 'detector_dimension_y', $
    _structure.detector_dimension_y
    
  putValue, event=event, 'pixel_min', _structure.pixel_min
  putValue, event=event, 'pixel_max', _structure.pixel_max
  
  putValue, event=event, 'd_sd_uname', _structure.d_sd
  putValue, event=event, 'd_md_uname', _structure.d_md
  
  putValue, event=event, 'rtof_file_text_field_uname', $
    _structure.rtof_file_text_field
    
  ;load rtof file if any
  if (file_test(_structure.rtof_file_text_field)) then begin
    file_name = _structure.rtof_file_text_field
    file_name = strtrim(file_name,2)
    file_name = file_name[0]
    result = load_rtof_file(event, file_name)
  endif
  
  putValue, event=event, 'rtof_nexus_geometry_file', $
    _structure.rtof_nexus_geometry_file
  putValue, event=event, 'rtof_ranges_qx_min', $
    _structure.rtof_ranges_qx_min
  putValue, event=event, 'rtof_ranges_qz_min', $
    _structure.rtof_ranges_qz_min
  putValue, event=event, 'rtof_tof_min', $
    _structure.rtof_tof_min
  putValue, event=event, 'rtof_ranges_qx_max', $
    _structure.rtof_ranges_qx_max
  putValue, event=event, 'rtof_ranges_qz_max', $
    _structure.rtof_ranges_qz_max
  putValue, event=event, 'rtof_tof_max', $
    _structure.rtof_tof_max
  putValue, event=event, 'rtof_center_pixel', $
    _structure.rtof_center_pixel
  putValue, event=event, 'rtof_pixel_size', $
    _structure.rtof_pixel_size
  putValue, event=event, 'rtof_theta_value', $
    _structure.rtof_theta_value
  putValue, event=event, 'rtof_theta_units', $
    _structure.rtof_theta_units
  putValue, event=event, 'rtof_twotheta_value', $
    _structure.rtof_twotheta_value
  putValue, event=event, 'rtof_twotheta_units', $
    _structure.rtof_twotheta_units
  putValue, event=event, 'rtof_pixel_min', $
    _structure.rtof_pixel_min
  putValue, event=event, 'rtof_pixel_max', $
    _structure.rtof_pixel_max
  putValue, event=event, 'rtof_d_sd_uname', $
    _structure.rtof_d_sd_uname
  putValue, event=event, 'rtof_d_md_uname', $
    _structure.rtof_d_md_uname
    
  mapBase, event=event, status=_structure.is_rtof_nexus_base_mapped, $
    uname='rtof_nexus_base'
  if (_structure.is_rtof_nexus_base_mapped) then begin
    check_rtof_buttons_status, event
    check_go_button, event=event
  endif
  
  mapBase, event=event, status=_structure.is_rtof_configuration_base_mapped, $
    uname='rtof_configuration_base'
    
  ;General sittings
  putValue, event=event, 'bins_qx', $
    _structure.bins_qx
  putValue, event=event, 'bins_qz', $
    _structure.bins_qz
  putValue, event=event, 'qxwidth_uname', $
    _structure.qxwidth_uname
  putValue, event=event, 'tnum_uname', $
    _structure.tnum_uname
    
  ;output tab
  (*global).output_path = _structure.output_path
  putValue, event=event, 'output_file_name', $
    _structure.output_file_name
  if (_structure.is_output_working_with_nexus_plot_checked) then begin
    setButton, event=event, uname='output_working_with_nexus_plot'
  endif else begin
    setButton, event=event, uname='output_working_with_nexus_plot', $
      /reverse_flag
  endelse
  
  if (_structure.is_output_working_with_rtof_plot_checked) then begin
    setButton, event=event, uname='output_working_with_rtof_plot'
  endif else begin
    setButton, event=event, uname='output_working_with_rtof_plot', $
      /reverse_flag
  endelse
  
  ;Add code here if the droplist contains more than 1 entry
  
  if (_structure.is_email_switch_checked) then begin
    setButton, event=event, uname='email_switch_uname'
  endif else begin
    setButton, event=event, uname='email_switch_uname', $
      /reverse_flag
  endelse
  
  putValue, event=event, 'email_to_uname', $
    _structure.email_to_uname
  putValue, event=event, 'email_subject_uname', $
    _structure.email_subject_uname
  mapBase, event=event, status=_structure.is_email_base_mapped, $
    uname='email_base'
    
    
    
  (*(*global).full_log_book) = _structure.log_book
  if (_structure.is_log_book_enabled) then begin
    display_log_book, event=event
  endif
  
  update_main_interface, event=event
  
end