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
get_path=new_path, $
title = 'Load configuration file')

if (cfg_full_file_name[0] eq '') then return

(*global).config_path = new_path
restore, filename=cfg_full_file_name, /relaxed_structure_assignment

repopulate_gui, event, cfg_structure

end