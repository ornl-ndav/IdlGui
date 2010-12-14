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

pro setButton, base=base, event=event, uname=uname, reverse_flag=reverse_flag
  compile_opt idl2
  
  if (keyword_set(reverse_flag)) then begin
  set_button_value = 0
  endif else begin
  set_button_value = 1
  endelse
  
  if (keyword_set(event)) then begin
    id = widget_info(event.top, find_by_uname=uname)
  endif else begin
    id = widget_info(base, find_by_uname=uname)
  endelse
  widget_control, id, set_button = set_button_value
end

;+
; :Description:
;    Change the value of the given widget
;
; :Params:
;    uname
;    value
;
; :Keywords:
;    base
;    event
;
; :Author: j35
;-
pro setValue, base=base, event=event, uname, value
  compile_opt idl2
  
  if (n_elements(event) ne 0) then begin
    id = widget_info(event.top, find_by_uname=uname)
  endif else begin
    id = widget_info(base, find_by_uname=uname)
  endelse
  widget_control, id, set_value=value
  
end

;+
; :Description:
;    Changes the status of a widget (sensitive or not)
;
; :Keywords:
;    id
;    event
;    uname
;    sensitive
;
; :Author: j35
;-
pro setSensitive, id=id, event=event, uname=uname, sensitive=sensitive
  compile_opt idl2
  
  if (n_elements(event) ne 0 && $
    n_elements(uname) ne 0) then begin
    id = widget_info(event.top, find_by_uname=uname)
    widget_control, id, sensitive=sensitive
  endif
  
end

;+
; :Description:
;    Select the region defined by the keywords
;
; :Keywords:
;    event
;    base
;    uname
;    from_row
;    to_row
;
; :Author: j35
;-
pro setTableSelect, event=event, base=base, uname=uname, $
    from_row=from_row, to_row=to_row
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    id = widget_info(event.top, find_by_uname=uname)
  endif else begin
    id = widget_info(base, find_by_uname=uname)
  endelse
  
  ;keep showing the same region of the table
  table_view = widget_info(id, /table_view)
  
  geometry = widget_info(id, /geometry)
  nbr_column = geometry.xsize
  from_column = 0
  to_column = nbr_column-1
  
  widget_control, id, $
    set_table_select=[from_column, from_row, to_column, to_row]
    
  widget_control, id, set_table_view=table_view
  
end
