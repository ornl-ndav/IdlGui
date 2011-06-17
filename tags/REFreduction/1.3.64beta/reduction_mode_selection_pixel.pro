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
;    According to the widgets selected, this procedure will update the widgets
;    of the main GUI.
;
;    If '1 reduction per selection' is selected, user will have the option
;    to manually defined the refpix and Q range will be set to automatic
;
;    If '1 reduction per px selected' is selected, disable the refpix
;    box and ask the user to select himself the Q range in the reduce tab
;
; :Keywords:
;    event
;    status     'one_per_selection' | 'one_per_pixel'
;
; :Author: j35
;-
pro update_reduction_mode_widgets, event=event, status=status
  compile_opt idl2
  
  case (status) of
  'one_per_selection': begin
  sensitive_status=1
  map_status = 0
  end
  'one_per_pixel': begin
  sensitive_status=0
  map_status= 1
  end
  'one_per_discrete': begin
  sensitive_status=0
  map_status=1
  end
  endcase    

  ;data tab
  list_uname = ['info_refpix',$
    'info_refpix_label',$
    'info_sangle_deg',$
    'info_sangle_deg_label',$
    'info_sangle_rad',$
    'info_sangle_rad_units',$
    'info_sangle_rad_label']
    
  sz = n_elements(list_uname)
  for i=0,(sz-1) do begin
    ActivateWidget, Event, list_uname[i], sensitive_status
  endfor
  
  ;reduce tab
  MapBase, Event, 'reduce_q_base', map_status
  
end
