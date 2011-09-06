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
;    This function returns the name of the button, according to the uname of the
;    button (using the configuration file that gives the position of the buttons)
;
; :Params:
;    button_uname
;
; :Author: j35
;-
function getButtonName, button_uname
  compile_opt idl2
  
  index_button = strsplit(button_uname,'button',/extract,/regex)
  if (index_button eq -1) then return, ''
  index_button = fix(index_button) - 1
  
  ;get list of buttons
  file = OBJ_NEW('IDLxmlParser','.NeedHelp.cfg')
  list_buttons = file->getValue(tag=['configuration','buttons_pos'])
  obj_destroy, file
  list = strsplit(list_buttons,',',/extract)
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, ''
  endif

  if (index_button ge n_elements(list)) then return, ''
  
  return, list[index_button]
end

;+
; :Description:
;    This function returns the name of the button of tab3, according to the uname of the
;    button (using the configuration file that gives the position of the buttons)
;
; :Params:
;    button_uname
;
; :Author: j35
;-
function getButtonNameTab3, button_uname
  compile_opt idl2
  
  index_button = strsplit(button_uname,'tab3_button',/extract,/regex)
  if (index_button eq -1) then return, ''
  index_button = fix(index_button) - 1
  
  ;get list of buttons
  file = OBJ_NEW('IDLxmlParser','.NeedHelp.cfg')
  list_buttons = file->getValue(tag=['configuration','tab3_buttons_pos'])
  obj_destroy, file
  list = strsplit(list_buttons,',',/extract)
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, ''
  endif

  if (index_button ge n_elements(list)) then return, ''
  
  return, list[index_button]
end