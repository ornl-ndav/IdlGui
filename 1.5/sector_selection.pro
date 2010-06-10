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
;    local_tube
;    local_pixel
;
; :Returns:
;   angle value
;
; :Author: j35
;-
function getAngle, event, $
    tube_center=tube_center, $
    pixel_center=pixel_center, $
    local_tube=local_tube, $
    local_pixel=local_pixel
    
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;length of pixel and width of tube
  tube_size = (*global).tube_size
  pixel_size = (*global).pixel_size
  
  delta_pixel = float(local_pixel - pixel_center) * pixel_size
  delta_tube  = float(local_tube - tube_center) * tube_size
  
  angle = atan(abs(delta_pixel),abs(delta_tube))
  angle_deg = angle / !dtor
  
  if (delta_tube ge 0) then begin ;right part
    if (delta_pixel ge 0) then begin ;top right part
      return, angle_deg
    endif else begin ;bottom right part
      return, -angle_deg
    endelse
  endif else begin ;left part
    if (delta_pixel ge 0) then begin ;top left part
      return, -angle_deg
    endif else begin ;bottom left part
      return, angle_deg
    endelse
  endelse
  
end

;+
; :Description:
;   This function returns the angle offset of the given (tube,pixel) given
;   according to the (tube_center,pixel_center).
;   if local_tube>tube_center, we are in the right part of the graph
;   if local_tube<tube_center, we are in the left part of the graph
;   if local_pixel>pixel_center, we are above the pixel center
;   if local_pixel<pixel_center, we are below the pixel center

; :Keywords:
;    tube_center
;    pixel_center
;    local_tube
;    local_pixel
;
; :Returns:
;    the angle offset (0, 90, 180 or 270)
;;
; :Author: j35
;-
function getAngleOffset, tube_center=tube_center, $
    pixel_center=pixel_center, $
    local_tube = local_tube, $
    local_pixel = local_pixel
    
  compile_opt idl2
  
  if (n_elements(local_tube) eq 0) then local_tube=0
  if (n_elements(local_pixel) eq 0) then local_pixel=0
  
  angle_offset = 0
  tube_diff = local_tube - tube_center
  pixel_diff = local_pixel - pixel_center
  
  if (tube_diff ge 0) then begin ;we are on the right of tube center
    if (pixel_diff ge 0) then begin ;we are in the top right corner
      angle_offset = 0
    endif else begin ;we are in the bottom right corner
      angle_offset = 360
    endelse
  endif else begin ;we are on the left of the tube center
    angle_offset = 180
  endelse
  
  return, float(angle_offset)
  
end

;+
; :Description:
;   the main purpose is to check if the start and end angles are valid
;   (number <= 360) and if start angle is > end angle, select from start to 360
;   and 0 to end angle
;
; :Params:
;    event

; :Author: j35
;-
pro sector_selection_check, event
  compile_opt idl2
  
  ;angles
  s_start_angle = strcompress(getTextFieldValue(event,$
    'sector_start_angle'),/remove_all)
  if (s_start_angle eq '') then return
  s_end_angle   = strcompress(getTextFieldValue(event,$
    'sector_end_angle'),/remove_all)
  if (s_end_angle eq '') then return
  start_angle = fix(s_start_angle)
  end_angle   = fix(s_end_angle)
  
  if (start_angle gt 360) then return
  if (end_angle gt 360) then return
  
  ;by default, we want to exclude nothing
  exclusion_detector_array = INTARR(48,4,256)
  
  ;replot background
  refresh_main_plot_for_circle_selection, Event
  
  if (start_angle gt end_angle) then begin
    sector_selection, event, start_angle, 360, exclusion_detector_array
    sector_selection, event, 0, end_angle, exclusion_detector_array
  endif else begin
    sector_selection, event, start_angle, end_angle, exclusion_detector_array
  endelse
  
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
pro sector_selection, event, start_angle, end_angle, exclusion_detector_array
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  on_ioerror, error
  
  ;center
  s_tube  = strcompress(getTextFieldValue(event,$
    'sector_tube_center'),/remove_all)
  if (s_tube eq '') then return
  s_pixel = strcompress(getTextFieldValue(event,$
    'sector_pixel_center'),/remove_all)
  if (s_pixel eq '') then return
  center_tube  = fix(s_tube)
  center_pixel = fix(s_pixel)
  
  index = 0L
  for bank=0,47 do begin
    for tube=0,3 do begin
      for pixel=0,255 do begin
      
        current_pixel = pixel
        current_tube  = bank*4+tube
        
        ;get angle offset
        angle_offset = getAngleOffset(tube_center=center_tube,$
          pixel_center=center_pixel,$
          local_tube = current_tube,$
          local_pixel= current_pixel)
          
        ;get angle
        local_angle = getAngle(event, $
          tube_center=center_tube,$
          pixel_center=center_pixel,$
          local_tube = current_tube,$
          local_pixel= current_pixel)
          
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
  
  tube_list  = STRARR(1)
  pixel_list = STRARR(1)
  determine_array_of_pixel_tube_selected_by_sector, Event,$
    exclusion_detector_array,$
    tube_list,$
    pixel_list
    
  nbr_tube_list = N_ELEMENTS(tube_list)
  IF (nbr_tube_list EQ 1) THEN RETURN
  IF (nbr_tube_list EQ 2) THEN BEGIN
    tube_list = tube_list[1]
    pixel_lsit = pixel_list[1]
  ENDIF
  IF (nbr_tube_list GT 2) THEN BEGIN
    tube_list = tube_list[1:nbr_tube_list-1]
    pixel_list = pixel_list[1:nbr_tube_list-1]
  ENDIF
  
  (*(*global).sector_tube_list) = tube_list
  (*(*global).sector_pixel_list) = pixel_list
  
  plot_sector_exclusion_pixel, Event, tube_list, pixel_list
  
  error:
  return
  
end


;+
; :Description:
;   This procedures creates the list of pixel and tube to include in
;   exclusion region
;
; :Params:
;    Event
;    exclusion_detector_array
;    tube_list
;    pixel_list
;;
; :Author: j35
;-
pro determine_array_of_pixel_tube_selected_by_sector, Event,$
    exclusion_detector_array,$
    tube_list,$
    pixel_list
  compile_opt idl2
  
  for bank=0,47 do begin
    for tube=0,3 do begin
      for pixel=0,255 do begin
      
        if (exclusion_detector_array[bank,tube,pixel] eq 1) then begin
          current_pixel = pixel
          current_tube  = bank*4+tube
          tube_list = [tube_list,current_tube]
          pixel_list = [pixel_list,current_pixel]
        endif
        
      endfor
    endfor
  endfor
  
end

;+
; :Description:
;   plot the sector selected by user (exclusion region)
;
; :Params:
;    Event
;    tube_array
;    pixel_array
;
; :Author: j35
;-
pro plot_sector_exclusion_pixel, Event, tube_array, pixel_array
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  
  IF (N_ELEMENTS(COEFF) EQ 0) THEN  coeff = FLOAT((*global).congrid_x_coeff)
  
  color = FSC_COLOR('pink')
  
  for pixel_index = 0, N_ELEMENTS(pixel_array)-1 do begin
  
    x1 = tube_array[pixel_index] * coeff
    x2 = (tube_array[pixel_index] + 1) * coeff
    y1 = (pixel_array[pixel_index] - 1 ) * coeff
    y2 = (pixel_array[pixel_index]) * coeff
    
    PLOTS, x1, y1, /DEVICE, COLOR=color
    PLOTS, x1, y2, /DEVICE, /CONTINUE, COLOR=color
    PLOTS, x2, y2, /DEVICE, /CONTINUE, COLOR=color
    PLOTS, x2, y1, /DEVICE, /CONTINUE, COLOR=color
    PLOTS, x1, y1, /DEVICE, /CONTINUE, COLOR=color
    
  endfor
  
end
