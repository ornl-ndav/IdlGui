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

;This function will return a table of pixel selected
;ex:    0   0   1   0   0
;       0   1   1   1   0
;       0   1   1   1   0
;       0   0   1   0   0
PRO determine_array_of_pixel_tube_selected, Event,$
    nbr_tube_left=nbr_tube_left, $
    nbr_tube_right=nbr_tube_right, $
    nbr_pixel_down=nbr_pixel_down, $
    nbr_pixel_up=nbr_pixel_up, $
    radius = radius, $
    tube_selected = tube_selected, $
    pixel_selected = pixel_selected, $
    tube_list = tube_list, $
    pixel_list = pixel_list
    
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  pixel_size = (*global).pixel_size
  tube_size  = (*global).tube_size
  
  FOR pixel_index = -nbr_pixel_down, nbr_pixel_up DO BEGIN ;loop bottom/top
    FOR tube_index = -nbr_tube_left, nbr_tube_right DO BEGIN ;loop left/right
      verti_distance = ABS(pixel_index) * pixel_size
      horiz_distance = ABS(tube_index) * tube_size
      distance = SQRT(verti_distance^2 + horiz_distance^2)
      IF (distance LE radius) THEN BEGIN
      tube_list = [tube_list,tube_index + tube_selected]
      pixel_list = [pixel_list,pixel_index + pixel_selected]
      ENDIF
    ENDFOR
  ENDFOR
  
END

;------------------------------------------------------------------------------
FUNCTION getNbrOfPixelsInExclusion, Event, pixel_selected, radius, $
    direction= direction
    
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  max_pixel = 255
  pixel_size = (*global).pixel_size
  
  nbr_pixel_offset = 0 ;number of pixel between pixel selected and current pixel
  pixel_offset = pixel_selected ;starting point for pixel
  pixel_offset_distance = 0 ;distance from center to current pixel
  
  IF (direction EQ 'up') THEN BEGIN
    WHILE (pixel_offset_distance LE radius) DO BEGIN
      IF (pixel_offset GT max_pixel) THEN RETURN, nbr_pixel_offset
      nbr_pixel_offset++
      pixel_offset++
      pixel_offset_distance += pixel_size
    ENDWHILE
  ENDIF ELSE BEGIN ;'down'
    WHILE (pixel_offset_distance LE radius) DO BEGIN
      IF (pixel_offset LT 0) THEN RETURN, nbr_pixel_offset
      nbr_pixel_offset++
      pixel_offset--
      pixel_offset_distance += pixel_size
    ENDWHILE
  ENDELSE
  
  RETURN, nbr_pixel_offset
  
END

;------------------------------------------------------------------------------
FUNCTION getNbrOfTubeInExclusion, Event, tube_selected, radius, $
    direction=direction
    
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  max_tube = 192
  tube_size = (*global).tube_size
  
  nbr_tube_offset = 0 ;number of tube between tube selected and current tube
  tube_offset = tube_selected ;starting point for tube
  tube_offset_distance = 0 ;distance from center to current tube
  
  IF (direction EQ 'right') THEN BEGIN
    WHILE (tube_offset_distance LE radius) DO BEGIN
      IF (tube_offset GT max_tube) THEN RETURN, nbr_tube_offset
      nbr_tube_offset++
      tube_offset++
      tube_offset_distance += tube_size
    ENDWHILE
  ENDIF ELSE BEGIN ;'left'
    WHILE (tube_offset_distance LE radius) DO BEGIN
      IF (tube_offset LT 0) THEN RETURN, nbr_tube_offset
      nbr_tube_offset++
      tube_offset--
      tube_offset_distance += tube_size
    ENDWHILE
  ENDELSE
  
  RETURN, nbr_tube_offset
  
END
