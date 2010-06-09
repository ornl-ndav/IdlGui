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
;   This function returns the exact angle formed by the sector
;   tube_center-tube and pixel_center-pixel

; :Keywords:
;    tube_center
;    pixel_center
;    tube
;    pixel
;
; :Returns:
;   angle value
;
; :Author: j35
;-
function gettAngleOffset, tube_center=tube_center, $
    pixel_center=pixel_center, $
    tube=tube, $
    pixel=pixel
    
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;length of pixel and width of tube
  tube_size = (*global).tube_size
  pixel_size = (*global).pixel_size
  
  delta_pixel = float(abs(pixel - pixel_center)) * pixel_size
  delta_tube  = float(abs(tube - tube_center)) * tube_size
  
  angle = atan(delta_pixel,delta_tube)
  angle_deg = angle / !dtor
  
  return, angle_deg
end

;+
; :Description:
;   This function returns the angle offset of the given (tube,pixel) given
;   according to the (tube_center,pixel_center).
;   if tube>tube_center, we are in the right part of the graph
;   if tube<tube_center, we are in the left part of the graph
;   if pixel>pixel_center, we are above the pixel center
;   if pixel<pixel_center, we are below the pixel center

; :Keywords:
;    tube_center
;    pixel_center
;    tube
;    pixel
;
; :Returns:
;    the angle offset (0, 90, 180 or 270)
;;
; :Author: j35
;-
function gettAngleOffset, tube_center=tube_center, $
    pixel_center=pixel_center, $
    tube=tube, $
    pixel=pixel
    
  compile_opt idl2
  
  angle_offset = 0
  tube_diff = tube - tube_center
  pixel_diff = pixel - pixel_center
  
  if (tube_diff ge 0) then begin ;we are on the right of tube center
    if (pixel_diff ge 0) then begin ;we are in the top right corner
      angle_offset = 0
    endif else begin ;we are in the bottom right corner
      angle_offset = 270
    endelse
  endif else begin ;we are on the left of the tube center
    if (pixel_diff ge 0) then begin ;we are in the top left corner
      angle_offset = 90
    endif else begin ;we are in the bottom left corner
      angle_offset = 180
    endelse
  endelse
  
  return, float(angle_offset)
  
end

;+
; :Description:
;   This routines determines the pixel inside the selection defined
;
; :Params:
;    event
;
; :Author: j35
;-
pro sector_selection, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  on_ioerror, error
  
  ;angles
  s_start_angle = strcompress(getTextFieldValue(event,$
    'sector_start_angle'),/remove_all)
  s_end_angle   = strcompress(getTextFieldValue(event,$
    'sector_end_angle'),/remove_all)
  start_angle = fix(s_start_angle)
  end_angle   = fix(s_end_angle)
  
  ;center
  s_tube  = strcompress(getTextFieldValue(event,$
    'sector_tube_center'),/remove_all)
  s_pixel = strcompress(getTextFieldValue(event,$
    'sector_pixel_center'),/remove_all)
  center_tube  = fix(s_tube)
  center_pixel = fix(s_pixel)
  
  ;by default, we want to exclude nothing
  exclusion_detector_array = INTARR(48,4,256)
  index = 0L
  for bank=0,47 do begin
    for tube=0,3 do begin
      for pixel=0,255 do begin
      
        current_pixel = pixel
        current_tube  = bank*4+tube
        
        ;get angle offset
        angle_offset = getAngleOffset(tube_center=center_tube,$
          pixel_center=center_pixel,$
          tube = current_tube,$
          pixel= current_pixel)
          
        ;get angle
        local_angle = getAngle(tube_center=center_tube,$
          pixel_center=center_pixel,$
          tube = current_tube,$
          pixel= current_pixel)
          
        ;final angle
        global_angle = angle_offset + local_angle
        
        if (global_angle ge start_angle) then begin
          if (global_angle le end_angle) then begin
            exclusion_detector_array[bank,tube,pixel] = 1
          endif
        endif
        
      endfor
    endfor
  endfor
  
  error:
  return
  
end