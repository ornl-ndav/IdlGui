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
;    This removed from the id_list the window that have been closed
;
;
;
; :Keywords:
;    dirty_list
;
; :Author: j35
;-
function clean_zoom_base_id, dirty_list=dirty_list
  compile_opt idl2
  
  clean_list = !null
  
  nbr_base = n_elements(dirty_list)
  _index = 0
  while (_index lt nbr_base) do begin
    _id = dirty_list[_index]
    if (widget_info(_id,/valid_id) eq 1) then begin
      clean_list = [clean_list, _id]
    endif
    _index++
  endwhile
  
  return, clean_list
  
end

;+
; :Description:
;    This will take care of cleaning the list of zoom_base_id and
;    registering the new base_id 
;
;
;
; :Keywords:
;    event
;    preview_base  ;id of the preview base from where this is launched
;    new_base
;
;
; :Author: j35
;-
pro add_zoom_base_id, event=event, preview_base=preview_base, new_base=new_base
  compile_opt idl2
  
  if (keyword_set(event)) then begin
    widget_control, event.top, get_uvalue=global
  endif else begin
    widget_control, preview_base, get_uvalue=global_preview
    global = (*global_preview).global
  endelse
  
  list_of_preview_display_base = (*(*global).list_of_preview_display_base)
  clean_list = clean_zoom_base_id(dirty_list=list_of_preview_display_base)
  
  if (keyword_set(new_base)) then begin
    clean_list = [clean_list, new_base]
  endif
  (*(*global).list_of_preview_display_base) = clean_list
  
end

