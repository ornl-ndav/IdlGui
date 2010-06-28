;=========================================================================a=====
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
;    This takes the name of the button, looks for its link in the configuration file
;    and passes it to the main launch_appication procedure to start the
;    application
;
; :Params:
;    event
;    button_name
;
; :Author: j35
;-
pro launch_this_application, event, button_name
  compile_opt idl2
  
  file = OBJ_NEW('IDLxmlParser','.NeedHelp.cfg')
  application = file->getValue(tag=['configuration','link',button_name])
  obj_destroy, file
  
  launch_application, event, application
  
  ;pop up dialog message that informs the user that the process worked
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
  title = 'Fix applied with success!'
  message_text = ['Your fix has been applied, if problem persists','',$
  'please use the >Personalize help< tab of this application', '',$
  'to contact us and to help us finding the issue!'] 
  result = dialog_message(message_text,/information,title=title,$
  /center,dialog_parent=widget_id)

end

;+
; :Description:
;     launch the application given
;
; :Params:
;    event
;    application
;
; :Author: j35
;-
pro launch_application, event, application
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  widget_control, /hourglass
  
  reco_space = strsplit(application,'\',/extract)
  application = strjoin(reco_space,' ')
  
  cmd = application + ' &'
;  print, cmd
  spawn, cmd
  
  widget_control, hourglass=0
  
end
