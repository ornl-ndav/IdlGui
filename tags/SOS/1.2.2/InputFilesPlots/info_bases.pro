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

pro px_vs_tof_base_move_info_bases, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  id = widget_info(event.top, $
    find_by_uname='px_vs_tof_input_files_widget_base')
  ;widget_control, id, /realize
  geometry = widget_info(id,/geometry)
  xoffset = geometry.xoffset
  yoffset = geometry.yoffset
  xsize   = geometry.xsize
  
  info_base = (*global_px_vs_tof).cursor_info_base
  if (widget_info(info_base, /valid_id) ne 0) then begin
    widget_control, info_base, xoffset=xsize+xoffset
    widget_control, info_base, yoffset=yoffset-20
  endif
  
  xaxis_id = (*global_px_vs_tof).counts_vs_xaxis_base
  if (widget_info(xaxis_id,/valid_id) ne 0) then begin
    if (widget_info(info_base,/valid_id) ne 0) then begin
      info_geometry = widget_info(info_base,/geometry)
      ysize = info_geometry.ysize
      xaxis_yoffset = ysize + 5
    endif else begin
      xaxis_yoffset = -20
    endelse
    widget_control, xaxis_id, xoffset=xsize+xoffset
    widget_control, xaxis_id, yoffset=yoffset+xaxis_yoffset
  endif
  
  yaxis_id = (*global_px_vs_tof).counts_vs_yaxis_base
  if (widget_info(yaxis_id,/valid_id) ne 0) then begin
    if (widget_info(xaxis_id,/valid_id) ne 0) then begin ;there is xaxis
      xaxis_geometry = widget_info(xaxis_id,/geometry)
      ysize = xaxis_geometry.ysize
      yaxis_yoffset = ysize + 35 + xaxis_geometry.yoffset
    endif else begin
      if (widget_info(info_base,/valid_id) ne 0) then begin
        info_geometry = widget_info(info_base,/geometry)
        ysize = info_geometry.ysize
        yaxis_yoffset = ysize + 15 + info_geometry.yoffset
      endif else begin
        yaxis_yoffset = -20 + yoffset
      endelse
    endelse
    widget_control, yaxis_id, xoffset=xsize+xoffset
    widget_control, yaxis_id, yoffset=yaxis_yoffset
  endif
  
end

;+
; :Description:
;    Shows the cursor, counts vs pixel and counts vs tof bases
;
; :Params:
;    event
;
; :Author: j35
;-
pro px_vs_tof_show_all_info, event
  compile_opt idl2
  
  px_vs_tof_show_cursor_info, event
  px_vs_tof_show_counts_vs_xaxis, event
  px_vs_tof_show_counts_vs_yaxis, event
  
end

;+
; :Description:
;    show the cursor info base
;
; :Params:
;    event
;
; :Author: j35
;-
pro px_vs_tof_show_cursor_info, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  info_base = (*global_px_vs_tof).cursor_info_base
  
  if (widget_info(info_base, /valid_id) EQ 0) THEN BEGIN
    parent_base_uname = 'px_vs_tof_input_files_widget_base'
    px_vs_tof_cursor_info_base, event=event, $
      parent_base_uname=parent_base_uname
  endif
  
end

;+
; :Description:
;    show the counts vs tof (lambda) base
;
; :Params:
;    event
;
; :Author: j35
;-
pro px_vs_tof_show_counts_vs_xaxis, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  counts_vs_xaxis_plot_id = (*global_px_vs_tof).counts_vs_xaxis_base
  if (widget_info(counts_vs_xaxis_plot_id,/valid_id) eq 0) then begin
    px_vs_tof_counts_vs_axis_base, event=event, $
      parent_base_uname = 'px_vs_tof_input_files_widget_base', $
      xaxis = 'tof'
  endif
  
end

;+
; :Description:
;    show the counts vs pixel (angle) base
;
; :Params:
;    event
;
; :Author: j35
;-
pro px_vs_tof_show_counts_vs_yaxis, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global_px_vs_tof
  
  counts_vs_yaxis_plot_id = (*global_px_vs_tof).counts_vs_yaxis_base
  if (widget_info(counts_vs_yaxis_plot_id,/valid_id) eq 0) then begin
    px_vs_tof_counts_vs_axis_base, event=event, $
      parent_base_uname = 'px_vs_tof_input_files_widget_base', $
      xaxis = 'pixel'
  endif
  
end