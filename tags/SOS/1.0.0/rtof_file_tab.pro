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
;    Allow user to pick the rtof file of interest to load
;
; :Params:
;    event
;
; :Author: j35
;-
pro browse_for_rtof_file_button, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  title = 'Select a rtof file'
  filter = ['*.rtof']
  default_extension = 'rtof'
  id = widget_info(event.top, find_by_uname='main_base')
  path = (*global).input_path
  
  message = '> Browsing for a rtof file...'
  log_book_update, event, message = message
  
  file_name = dialog_pickfile(default_extension = default_extension, $
    dialog_parent = id, $
    title = title, $
    filter = filter, $
    get_path = new_path, $
    path = path)
    
  if (file_name ne '') then begin
    (*global).input_path = new_path
    message = '-> rtof file loaded: ' + file_name[0]
    putvalue, event=event, 'rtof_file_text_field_uname', file_name
    
    ;loading data from rtof file
    result = load_rtof_file(event, file_name)
    
  endif else begin
    message = '-> no rtof file loaded (operation canceled)!'
  endelse
  
  log_book_update, event, message = message
  ;check_preview_rtof_button_status, event
  
end

;+
; :Description:
;    Check if the rtof preview and load buttons can be enabled or not
;
; :Params:
;    event
;
; :Author: j35
;-
pro check_rtof_buttons_status, event
  compile_opt idl2
  
  file_name = getvalue(event=event, uname='rtof_file_text_field_uname')
  if (file_test(file_name) ne 1) then begin
    activate_button, event=event, uname='rtof_file_preview_button', status=0
    activate_button, event=event, uname='load_rtof_file_button', status=0
  endif else begin
    activate_button, event=event, uname='rtof_file_preview_button', status=1
    activate_button, event=event, uname='load_rtof_file_button', status=1
  endelse
  
end

;+
; :Description:
;    Button that will display the containt of the rtof file using
;    xdisplayfile
;
; :Params:
;    event
;
; :Author: j35
;-
pro rtof_file_preview_button_eventcb, event
  compile_opt idl2
  
  file_name = getvalue(event=event, uname='rtof_file_text_field_uname')
  if (file_test(file_name) ne 1) then return
  
  id = widget_info(event.top, find_by_uname='main_base')
  
  xdisplayfile, file_name[0], title=file_name[0], /center, $
    group=id
    
end