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
;    Reached by the preview of .txt file button
;
; :Params:
;    event
;
; :Author: j35
;-
pro preview_txt_file, event
  compile_opt idl2
  
  ext = '.txt'
  preview_file, event=event, ext=ext
  
end

;+
; :Description:
;    Reached by the preview of _forDave.txt file button
;
; :Params:
;    event
;
; :Author: j35
;-
pro preview_fordave_txt_file, event
  compile_opt idl2
  
  ext = '.hscn'
  preview_file, event=event, ext=ext
  
end

;+
; :Description:
;    This routine display the contain of the file on top and center of the
;    current main base window
;
; :Keywords:
;    event
;    ext    either '.txt' or '_forDave.txt'
;
; :Author: j35
;-
pro preview_file, event=event, ext=ext
  compile_opt idl2
  
  path = getButtonValue(event, 'tab2_output_folder_button_uname')
  file_name = getTextFieldValue(event, $
    'tab2_output_file_name_text_field_uname')
  full_file_name = path + file_name + ext
  
  if (~file_test(full_file_name)) then return
  
  group = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  xdisplayfile, full_file_name[0], $
    title = full_file_name[0], $
    group = group, $
    /center
    
end