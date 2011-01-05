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
;    Fully reset the application
;
; :Params:
;    event
;
; :Author: j35
;-
pro full_reset, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  message = '> Full reset of session !! ****'
  
  ;reset of tab1
  (*(*global).list_data_nexus) = !null
  (*(*global).list_data_runs) = !null
  (*(*global).list_norm_nexus) = !null
  
  max_nbr_data_nexus = (*global).max_nbr_data_nexus
  big_table = strarr(2,max_nbr_data_nexus)
  (*global).big_table = big_table
  putValue, event=event, base=main_base, 'tab1_table', big_table
  
  putValue, event=event, 'd_sd_uname', ''
  putValue, event=event, 'd_md_uname', ''
  
  ;reset tab2
  putValue, event=event, 'rtof_file_text_field_uname', ''
  putValue, event=event, 'rtof_nexus_geometry_file', ''
  
  log_book_update, event, message=message
  
  check_rtof_buttons_status, event
  check_go_button, event=event
  
  ;reset data structure
  structure = (*global).structure_data_working_with_nexus
  create_structure_data, structure=structure, $
    data=!null, $
    xaxis=!null, $
    yaxis=!null
  (*global).structure_data_working_with_nexus = structure
  
  structure = (*global).structure_data_working_with_rtof
  create_structure_data, structure=structure, $
    data=!null, $
    xaxis=!null, $
    yaxis=!null
  (*global).structure_data_working_with_rtof = structure
  
  refresh_configuration_table, event=event

end