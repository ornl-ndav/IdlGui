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
;    Preview the file currently selected
;
;
;
; :Keywords:
;    event
;    type  -> ['data_file','open_beam','dark_field']
;
; :Author: j35
;-
pro preview_currently_selected_file, event=event, type=type
  compile_opt idl2
  
  widget_control, /hourglass
  
  widget_control, event.top, get_uvalue=global
  if (keyword_set(type)) then begin
    (*global).current_type_selected = type
  endif else begin
    type = (*global).current_type_selected
  endelse
  
  file_name_selected = get_file_selected_of_type(event=event, type=type)
  file_base_name = file_basename(file_name_selected)
  
  case (type) of
    'data_file': label='Data: '
    'open_beam': label='Open beam: '
    'dark_field': label='Dark field: '
  endcase
  
  if (strcompress(file_base_name[0],/remove_all) eq '') then $
    file_base_name='N/A'
    
  if (n_elements(file_base_name) gt 1) then begin
    file_base_name = file_base_name[0] + ' (...)'
  endif else begin
    file_base_name = file_base_name[0]
  endelse
  
  putValue, event=event, 'preview_file_name_label', label + file_base_name
  display_preview_of_file, event=event, file_name=file_name_selected
  display_preview_roi, event=event
  refresh_zoom_base, event=event

  widget_control, hourglass=0
  
end

;+
; :Description:
;    Plot the currently selected fits file
;
; :Keywords:
;    event
;    file_name
;    type
;
; :Author: j35
;-
pro display_preview_of_file, event=event, file_name=file_name
  compile_opt idl2
  
  id_draw = widget_info(Event.top, find_by_uname='preview_draw_uname')
  widget_control, id_draw, get_value=id_value
  wset,id_value
  
  is_with_gamma_filtering = $
    isButtonSelected(event=event,uname='with_gamma_filtering_uname')
    
  widget_control, event.top, get_uvalue=global
  
  read_fits_file, event=event, file_name=file_name, data=data, metadata=metadata
  if (data eq !null) then begin
    full_reset_of_preview_base, event=event
    return
  endif
  
  (*(*global).preview_file_metadata) = metadata
  
  geometry = widget_info(id_draw,/geometry)
  xsize = geometry.scr_xsize
  ysize = geometry.scr_ysize
  
  size_preview_data = size(data,/dim)
  (*global).size_preview_data = size_preview_data
  
  apply_gamma_filtering, event=event, data=data
  
  new_data = congrid(data, xsize, ysize)
  tvscl, new_data
  
  (*(*global).preview_data) = data
  
end

;+
; :Description:
;    Apply gamma filtering or not to data
;
;
;
; :Keywords:
;    event
;    data
;
; :Author: j35
;-
pro apply_gamma_filtering, event=event, data=data
  compile_opt idl2
  
  bGamma = isButtonSelected(event=event,uname='with_gamma_filtering_uname')
  if (bGamma eq 0b) then return
  gamma_cleaner, data=data
  
end
