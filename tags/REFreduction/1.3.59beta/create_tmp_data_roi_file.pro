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
;   promote products derived from this software without specific written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

;+
; :Description:
;    This routine will create a roi file for only the pixel selected
;
; :Keywords:
;    event
;    pixel
;    output_file_name
;
; :Author: j35
;-
pro create_tmp_data_roi_file, event=event, $
    pixel=pixel, $
    output_file_name=output_file_name
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  openw, 1, output_file_name
  
  NyMax = (*global).Ny_REF_M
  y = pixel
  for x=0,(NyMax-1) DO BEGIN
    text  = 'bank1_' + strcompress(y,/remove_all)
    text += '_' + strcompress(x,/remove_all)
    printf,1,text
  endfor
  
  close, 1
  free_lun, 1
  
end

;+
; :Description:
;    This routine creates a tmp roi file for only the range of pixel
;    selected
;
; :Keywords:
;    event
;    from_px
;    to_px
;    output_file_name
;
; :Author: j35
;-
pro create_tmp_discrete_data_roi_file, event=event, $
    from_px = from_px,$
    to_px = to_px, $
    output_file_name=output_file_name
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  openw, 1, output_file_name
  
  NyMax = (*global).Ny_REF_M
  NxMax = (to_px - from_px ) + 1
  
  for y=from_px, to_px do begin
    for x=0,(NyMax-1) DO BEGIN
      text  = 'bank1_' + strcompress(y,/remove_all)
      text += '_' + strcompress(x,/remove_all)
      printf,1,text
    endfor
  endfor
  
  close, 1
  free_lun, 1
  
end