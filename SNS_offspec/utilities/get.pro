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
;    get the total number of files loaded
;    in all the spin states
;
; :Params:
;    event
;
; :Author: j35
;-
function get_total_number_of_files_loaded, event
  compile_opt idl2
  
  _number_files = 0
  
  ;loop over all the spin states
  for i=0,3 do begin
    _number_files += get_number_of_files_loaded(event, spin_state=i)
  endfor
  
  return, _number_files
  
end

;+
; :Description:
;    return the value of the widget defined
;    by its uname (passed as argument)
;
; :Keywords:
;   event
;   base
;   uname
;
; :Author: j35
;-
function getValue, id=id, event=event, base=base, uname=uname
  compile_opt idl2
  
  if (n_elements(event) ne 0) then begin
    _id = widget_info(event.top, find_by_uname=uname)
  endif
  if (n_elements(base) ne 0) then begin
    _id = widget_info(base, find_by_uname=uname)
  endif
  if (n_elements(id) ne 0) then begin
    _id = id
  endif
  widget_control, _id, get_value=value
  return, value
  
end

;+
; :Description:
;    Determine which tab is currently selected
;
; :Keywords:
;    id
;    event
;    uname
;
; :Returns:
;   returns the current tab selected
;
; :Author: j35
;-
function getTabSelected, id=id, event=event, uname=uname
  compile_opt idl2
  
  if (n_elements(event) ne 0) then begin
    id = widget_info(event.top, find_by_uname=uname)
  endif
  
  tab_selected = widget_info(id, /tab_current)
  return, tab_selected
  
end

;+
; :Description:
;    Determine the current spin state selected
;
; :Params:
;   event
; :Returns:
;   returns the current spin state
;
; :Author: j35
;-
function get_current_spin_state_selected, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  current_spin_state_selected = (*global).current_spin_state_selected
  return, current_spin_state_selected
  
end

;+
; :Description:
;    using the left and right values, create the sequence
;
; :Keywords:
;    from   first number of sequence
;    to     last number of sequence
;
; :Author: j35
;-
function getSequence, from=left, to=right
  compile_opt idl2
  
  no_error = 0
  catch, no_error
  if (no_error ne 0) then begin
    catch,/cancel
    return, ['']
  endif else begin
    on_ioerror, done
    iLeft  = fix(left)
    iRight = fix(right)
    sequence = indgen(iRight-iLeft+1)+iLeft
    return, strcompress(string(sequence),/remove_all)
    done:
    return, [strcompress(left,/remove_all)]
  ENDELSE
END


