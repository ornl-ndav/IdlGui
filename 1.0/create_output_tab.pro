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
;    where to create the output file button
;
; :Params:
;    event
;
; :Author: j35
;-
pro where_create_output_file, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  output_path = (*global).output_path
  id = widget_info(event.top, find_by_uname='main_base')
  result = dialog_pickfile(/directory,$
    dialog_parent=id, $
    get_path=path, $
    title = 'Select output folder')
    
  if (path[0] ne '') then begin
    (*global).output_path = path[0]
    putValue, event=event, 'output_path_button', path[0]
  endif
  
  return
end

;+
; :Description:
;    This routine checks which buttons/base should be enabled or not, according
;    to the status of the main application.
;    ex: Working with NeXus ran with sucess -> enabled "last data set created
;    in WORKING WITH NEXUS"
;
; :Params:
;    event
;
; :Author: j35
;-
pro check_creat_output_widgets, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;check "last data set created in working with nexus"
  structure_data_working_with_nexus = (*global).structure_data_working_with_nexus
  data = (*(*structure_data_working_with_nexus).data)
  if (data eq !null) then begin
    status_nexus = 0
    reverse_set_button = 1
  endif else begin
    status_nexus = 1
    reverse_set_button = 0
  endelse
  (*global).create_output_status_nexus = status_nexus
  activate_button, event=event, status=status_nexus, $
    uname='output_working_with_nexus_plot'
  setButton, event=event, $
    uname='output_working_with_nexus_plot', $
    reverse_flag=reverse_set_button
    
  ;check "last data set created in working with rtof"
  structure_data_working_with_rtof = (*global).structure_data_working_with_rtof
  data = (*(*structure_data_working_with_rtof).data)
  if (data eq !null) then begin
    status_rtof = 0
    reverse_set_button = 1
  endif else begin
    status_rtof = 1
    reverse_set_button = 0
  endelse
  (*global).create_output_status_rtof = status_rtof
  activate_button, event=event, status=status_rtof, $
    uname='output_working_with_rtof_plot'
  setButton, event=event, $
    uname='output_working_with_rtof_plot', $
    reverse_flag=reverse_set_button
    
    check_create_output_file_button, event
end

;+
; :Description:
;    This procedure checks the status of the various widgets inside the
;    tab and enabled or not the CREATE FILE button
;
; :Params:
;    event
;
; :Author: j35
;-
pro check_create_output_file_button, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  button_status = 1b
  
  ;check output file name
  output_file_name = getValue(event=event, uname='output_file_name')
  if (strcompress(output_file_name,/remove_all) eq '') then button_status=0b
  
  status_rtof = (*global).create_output_status_rtof
  status_nexus = (*global).create_output_status_nexus
  
  if (status_rtof+status_nexus eq 0) then button_status=0b
  
  activate_button, event=event, $
    status=button_status, $
    uname='create_output_button'
    
    
    
    
    
    
    
    
    
end