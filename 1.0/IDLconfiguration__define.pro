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
;    Return the current selection [left,top,right,bottom]
;
;
;
; :Keywords:
;    event
;    type    ['data','open_beam','dark_field']
;
; :Author: j35
;-
function getSelectedFile, event=event,type=type
  compile_opt idl2
  
  case (type) of
    'data': uname='data_files_table'
    'open_beam': uname='open_beam_table'
    'dark_field': uname='dark_field_table'
  endcase
  
  selection = get_table_lines_selected(event=event, uname=uname)
  return, selection
  
end

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
  
  ;FIXME
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
  
  ;1) Input
  _structure = {list_data_files: $
    getValue(event=event,uname='data_files_table'),$
    list_open_beam_files: $
    getValue(event=event,uname='open_beam_table'),$
    list_dark_field_files: $
    getValue(event=event,uname='dark_field_table'),$
    
    selected_data_file: $
    getSelectedFile(event=event,type='data'),$
    selected_open_beam_file: $
    getSelectedFile(event=event,type='open_beam'), $
    selected_dark_field_file: $
    getSelectedFile(event=event,type='dark_field'), $
    
    preview_file: getValue(event=event,$
    uname='preview_file_name_label'),$
    is_with_gamma_filtering: $
    isButtonSelected(event=event,uname='with_gamma_filtering_uname'), $
    
    type: (*global).current_type_selected, $
    
    ;gamma filtering
    gamma_filtering: (*global).gamma_filtering, $
    gamma_filtering_coeff: (*global).gamma_filtering_coeff, $
    
    roi_loaded: getValue(event=event,$
    uname='roi_text_field_uname'),$
    
    output_folder: getValue(event=event,$
    uname='output_folder_button'),$
    is_tiff_selected: $
    isButtonSelected(event=event,uname='format_tiff_button'), $
    is_fits_selected: $
    isButtonSelected(event=event,uname='format_fits_button'), $
    is_png_selected: $
    isButtonSelected(event=event,uname='format_png_button'), $
    
    is_log_book_enabled: isLogBookEnabled(event=event), $
    log_book: (*(*global).log_book)}
    
  return, _structure
end

function IDLconfiguration::init
  return, 1
end


pro IDLconfiguration__define
  void = {IDLconfiguration, $
    tmp: ''}
end



