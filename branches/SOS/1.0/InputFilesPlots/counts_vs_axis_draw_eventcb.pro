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

pro save_draw_zoom_selection, main_event, tof=tof, pixel=pixel
  compile_opt idl2
  
  widget_control, main_event.top, get_uvalue=global_px_vs_tof
  
  selection = (*global_px_vs_tof).draw_zoom_selection
  data_selection = (*global_px_vs_tof).draw_zoom_data_selection
  
  if (keyword_set(tof)) then begin
    tof0 = tof[0]
    tof1 = tof[1]
    
    ;make sure they are sorted
    if (tof0 ne 'N/A' && tof1 ne 'N/A') then begin
      f_tof0 = float(tof0)
      f_tof1 = float(tof1)
      tof_min = min([f_tof0,f_tof1],max=tof_max)
      tof0 = tof_min
      tof1 = tof_max
    endif
    
    tof0 = string(tof0)
    tof1 = string(tof1)
    
    if (tof0 ne 'N/A') then begin
      _tof0 = tof0
      _tof0_device = px_vs_tof_data_to_device(global_px_vs_tof, tof=_tof0)
      data_selection[0] = _tof0
      selection[0] = _tof0_device
    endif else begin
      data_selection[0] = -1
      selection[0] = -1
    endelse
    
    if (tof1 ne 'N/A') then begin
      _tof1 = tof1
      _tof1_device = px_vs_tof_data_to_device(global_px_vs_tof, tof=_tof1)
      data_selection[2] = _tof1
      selection[2] = _tof1_device
    endif else begin
      data_selection[2] = -1
      selection[2] = -1
    endelse
    
  endif ;end of keyword tof set
  
  if (keyword_set(pixel)) then begin
  
    pixel0 = pixel[0]
    pixel1 = pixel[1]
    
    ;make sure they are sorted
    if (pixel0 ne 'N/A' && pixel1 ne 'N/A') then begin
      f_pixel0 = float(pixel0)
      f_pixel1 = float(pixel1)
      pixel_min = min([f_pixel0,f_pixel1],max=pixel_max)
      pixel0 = pixel_min
      pixel1 = pixel_max
    endif
    
    pixel0 = string(pixel0)
    pixel1 = string(pixel1)
    
    if (pixel0 ne 'N/A') then begin
      _pixel0 = pixel0
      _pixel0_device = px_vs_tof_data_to_device(global_px_vs_tof, pixel=_pixel0)
      data_selection[1] = _pixel0
      selection[1] = _pixel0_device
    endif else begin
      data_selection[1] = -1
      selection[1] = -1
    endelse
    
    if (pixel1 ne 'N/A') then begin
      _pixel1 = pixel1
      _pixel1_device = px_vs_tof_data_to_device(global_px_vs_tof, pixel=_pixel1)
      data_selection[3] = _pixel1
      selection[3] = _pixel1_device
    endif else begin
      data_selection[3] = -1
      selection[3] = -1
    endelse
    
  endif ;end of keyword tof set
  
  (*global_px_vs_tof).draw_zoom_selection = selection
  (*global_px_vs_tof).draw_zoom_data_selection = data_selection
  
end
