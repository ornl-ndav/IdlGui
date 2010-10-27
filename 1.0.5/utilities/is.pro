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
;    Return the status of a button (selected or not)
;
; :Keywords:
;    id
;    event
;    uname
;
; :Returns:
;   status of the button  -> 0 for not selected
;                         -> 1 for selected
;
; :Author: j35
;-
function isButtonSelected, id=id, event=event, uname=uname
  compile_opt idl2
  
  if (n_elements(id) ne 0) then begin
    status = widget_info(id,/button_set)
    return, status
  endif
  
  if (n_elements(event) ne 0 && $
    n_elements(uname) ne 0) then begin
    
    id = widget_info(event.top, find_by_uname=uname)
    status = widget_info(id,/button_set)
    return, status
  endif
  
  return, 'N/A'
  
end

;+
; :Description:
;    returns the status of the button
;    1 if enabled
;    0 if disabled
;
; :Keywords:
;    event
;    uname
;
; :Returns:
;   status of the button
;
;
; :Author: j35
;-
function isButtonEnabled, event=event, uname=uname
  compile_opt idl2
  
  id = widget_info(event.top, find_by_uname=uname)
  status = widget_info(id, /sensitive)
  return, status
  
end

;+
; :Description:
;    returns the status of the show_plot button (tab1)
;
; :Params:
;    event
;
; :Returns:
;   returns the status of the button

; :Author: j35
;-
function isShowScaledDataButtonEnabled, event
  compile_opt idl2
  
  uname = 'show_plot'
  status = isButtonEnabled(event=event, uname=uname)
  return, status
  
end

;+
; :Description:
;    returns the status of the automatic loading button
;
; :Params:
;    event

; :Author: j35
;-
function isAutomaticLoadingOn, event
  compile_opt idl2
  
  uname = 'auto_spin_detection'
  button_selected = isButtonSelected(event=event, uname=uname)
  return, button_selected
  
end
