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
;    This routine builds the top menu of the main base
;
; :Params:
;    top_base_menu
;
;
;
; :Author: j35
;-
pro build_menu, top_base_menu
  compile_opt idl2
  
  ;configuration menu
  configuration = widget_button(top_base_menu,$
    value = 'Configuration',$
    /menu)
  load = widget_button(configuration,$
    value = 'Load...',$
    uname = 'load_configuration_uname')
  save = widget_button(configuration,$
    value = 'Save...',$
    uname = 'save_configuration_uname')
  settings = widget_button(configuration,$
    value = 'Settings...',$
    uname = 'settings_configuration_uname',$
    /separator)
    
  ;session
  session = widget_button(top_base_menu,$
  value = 'Reset',$
  /menu)
  data = widget_button(session,$
  uname='reset_data_files_uname',$
  value = 'Data files')
  ob = widget_button(session,$
  uname = 'reset_open_beam_files_uname',$
  value = 'Open beam')
  df = widget_button(session,$
  uname = 'reset_dark_field_files_uname',$
  value = 'Dark field')
  full_reset = widget_button(session,$
  value = 'Full session',$
  /separator,$
  uname = 'full_reset_of_session_uname')  
    
  ;Help
  help = widget_button(top_base_menu,$
    value = 'Help',$
    /menu)
  log_book = widget_button(help,$
    value = 'Log book',$
    uname = 'log_book_uname')
  about = widget_button(help,$
    value = 'About iMARS',$
    /separator,$
    uname = 'about_imars_uname')
    help_button = widget_button(help,$
    value = 'Help...',$
    uname = 'help_uname')
    
end



