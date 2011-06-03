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
;    reset the contain of the tables
;
;
;
; :Keywords:
;    event
;    uname
;
; :Author: j35
;-
pro reset_table, event=event, uname=uname
  compile_opt idl2
  
  table = getValue(event=event,uname=uname)
  sz = n_elements(table)
  id = widget_info(event.top, find_by_uname=uname)
  index=1
  while (index lt sz) do begin
    widget_control, id, delete_rows=0
    index++
  endwhile
  
  putValue, event=event, uname, strarr(1,1)
  
  ;add log book message
  message = 'Reset ' + uname
  log_book_update, event, message=message
  
end

;+
; :Description:
;    Full reset of the preview base
;
;
;
; :Keywords:
;    event
;
; :Author: j35
;-
pro full_reset_of_preview_base, event=event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;reset metadata
  (*(*global).preview_file_metadata) = !null
  
  ;reset plot
  id_draw = widget_info(Event.top, find_by_uname='preview_draw_uname')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  erase
  
  ;reset name of file previewed
  putValue, event=event, 'preview_file_name_label', 'N/A'
  
end