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
;    resize a widget
;
; :Params:
;    event
;    uname
;    str_sz
;
; :Author: j35
;-
pro resize_widget, event, uname, str_sz
  compile_opt idl2
  
  id = widget_info(event.top, find_by_uname=uname)
  widget_control, id, xsize=str_sz*3
  
end

;+
; :Description:
;    Map the base given by the uname
;
; :Keywords:
;    event
;    map
;    uname
;
; :Author: j35
;-
pro mapBase, event=event, status=status, uname=uname
  compile_opt idl2
  
  id = widget_info(event.top, find_by_uname=uname)
  widget_control, id, map=status
  
end

;+
; :Description:
;    Activate or not a button

; :Keywords:
;    event
;    status
;    uname
;
; :Author: j35
;-
pro activate_button, event=event, status=status, uname=uname
  compile_opt idl2
  
  id = widget_info(event.top, find_by_uname=uname)
  widget_control, id, /set_button
  
end

;+
; :Description:
;    Display a dialog message about a problem defined in the
;    arguments.
;
; :Keywords:
;    event
;    message
;    title
;
; :Author: j35
;-
pro show_error_message, event=event, message=message, title=title
  compile_opt idl2
  
  id = widget_info(event.top, find_by_uname='main_base')
  result = dialog_message(message,$
    title = title, $
    dialog_parent=id,$
    /center,$
    /information)
    
end


