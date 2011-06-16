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
;    Check if the log book is enabled or not
;
; :Keywords:
;    event
;
; :Author: j35
;-
function isLogBookEnabled, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  id = (*global).view_log_book_id
  
  if (widget_info(id,/valid_id)) then return, 1b
  return, 0b
  
end

;+
; :Description:
;    This retrieves the various fields infos and save it into the
;    structure called _structure
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function IDLconfiguration::getConfig, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  _structure = {data_norm_table: getValue(event=event,$ ;working with nexus
    uname='tab1_table'), $
    input_path: (*global).input_path, $
    
    ;Settings base
    ranges_qx_min: getValue(event=event, uname='ranges_qx_min'),$
    ranges_qz_min: getValue(event=event, uname='ranges_qz_min'),$
    tof_min: getValue(event=event, uname='tof_min'), $
    ranges_qx_max: getValue(event=event, uname='ranges_qx_max'),$
    ranges_qz_max: getValue(event=event, uname='ranges_qz_max'),$
    tof_max: getValue(event=event, uname='tof_max'), $
    center_pixel: getValue(event=event, uname='center_pixel'),$
    pixel_size: getValue(event=event, uname='pixel_size'),$
    detector_dimension_x: getValue(event=event, uname='detector_dimension_x'),$
    detector_dimension_y: getValue(event=event, uname='detector_dimension_y'),$
    pixel_min: getValue(event=event, uname='pixel_min'),$
    pixel_max: getValue(event=event, uname='pixel_max'),$
    d_sd: getValue(event=event, uname='d_sd_uname'),$
    d_md: getValue(event=event, uname='d_md_uname'),$
    
    ;working with RTOF
    rtof_file_text_field: getValue(event=event, $
    uname='rtof_file_text_field_uname'),$
    rtof_nexus_geometry_file: getValue(event=event, $
    uname='rtof_nexus_geometry_file'),$
    rtof_ranges_qx_min: getValue(event=event, $
    uname='rtof_ranges_qx_min'),$
    rtof_ranges_qz_min: getValue(event=event, $
    uname='rtof_ranges_qz_min'),$
    rtof_tof_min: getValue(event=event, $
    uname='rtof_tof_min'),$
    rtof_ranges_qx_max: getValue(event=event, $
    uname='rtof_ranges_qx_max'), $
    rtof_ranges_qz_max: getValue(event=event, $
    uname='rtof_ranges_qz_max'), $
    rtof_tof_max: getValue(event=event, $
    uname='rtof_tof_max'), $
    rtof_center_pixel: getValue(event=event, $
    uname='rtof_center_pixel'),$
    rtof_pixel_size: getValue(event=event, $
    uname='rtof_pixel_size'), $
    rtof_theta_value: getValue(event=event, $
    uname='rtof_theta_value'), $
    rtof_theta_units: getValue(event=event, $
    uname='rtof_theta_units'), $
    rtof_twotheta_value: getValue(event=event, $
    uname='rtof_twotheta_value'), $
    rtof_twotheta_units: getValue(event=event, $
    uname='rtof_twotheta_units'), $
    rtof_pixel_min: getValue(event=event, $
    uname='rtof_pixel_min'), $
    rtof_pixel_max: getValue(event=event, $
    uname='rtof_pixel_max'), $
    rtof_d_sd_uname: getValue(event=event, $
    uname='rtof_d_sd_uname'), $
    rtof_d_md_uname: getValue(event=event, $
    uname='rtof_d_md_uname'), $
    
    ;general settings
    bins_qx: getValue(event=event, $
    uname='bins_qx'),$
    bins_qz: getValue(event=event, $
    uname='bins_qz'),$
    qxwidth_uname: getValue(event=event, $
    uname='qxwidth_uname'),$
    tnum_uname: getValue(event=event, $
    uname='tnum_uname'),$
    
    ;create output
    output_path: (*global).output_path,$
    output_file_name: getValue(event=event, $
    uname='output_file_name'),$
    is_output_working_with_nexus_plot_checked: $
    isButtonSelected(event=event, uname='output_working_with_nexus_plot'),$
    is_output_working_with_rtof_plot_checked: $
    isButtonSelected(event=event, uname='output_working_with_rtof_plot'),$
    output_format_index_selected: $
    getDroplistIndex(event=event, uname='output_format'),$
    is_email_switch_checked: $
    isButtonSelected(event=event, uname='email_switch_uname'),$
    email_to_uname: getValue(event=event, $
    uname='email_to_uname'),$
    email_subject_uname: getValue(event=event, $
    uname='email_subject_uname'), $
    
    is_log_book_enabled: isLogBookEnabled(event=event), $
    log_book: (*(*global).full_log_book)}
    
  return, _structure
end

function IDLconfiguration::init
  return, 1
end


pro IDLconfiguration__define
  void = {IDLconfiguration, $
    tmp: ''}
end



