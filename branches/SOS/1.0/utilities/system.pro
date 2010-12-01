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
;    Checks if findnexus can be found in the path
;
; :Returns:
;   1 if findnexus has been found in the path
;   0 if findnexus is not in the path
;
; :Author: j35
;-
function is_findnexus_there
  compile_opt idl2
  
  cmd = 'findnexus'
  spawn, cmd, result, err
  
  sz_err = n_elements(err)
  
  if (sz_err eq 1) then return, 0
  return, 1
  
end

;+
; :Description:
;    retrieve full file path of nexus file
;
; :Keywords:
;    event
;    run_number
;
; :Author: j35
;-
function get_nexus, event=event, run_number=run_number
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  instrument = (*global).instrument
  
  if (~keyword_set(run_number)) then return, 'N/A'
  
  cmd = 'findnexus -i ' + instrument + ' ' + strcompress(run_number,/remove_all)
  spawn, cmd, full_nexus_name, err
  
  if (full_nexus_name[0] eq '') then return, 'N/A'
  
  ;check if nexus exists
  sz = n_elements(full_nexus_name)
  if (sz EQ 1) then begin
    result = STRMATCH(full_nexus_name[0],"ERROR*")
    if (result GE 1) then begin
      return, 'N/A'
    endif else begin
      return, full_nexus_name[0]
    endelse
  endif else begin
    return, full_nexus_name[0]
  endelse
  
end