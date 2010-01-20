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

;This procedure will determines which pixels are part of the circle exclusion
;region
PRO calculate_circle_exclusion_pixels, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ON_IOERROR, error
  
  tube_selected  = FIX(getTextFieldValue(Event,'circle_tube_center'))
  pixel_selected = FIX(getTextFieldValue(Event,'circle_pixel_center'))
  radius         = FLOAT(getTextFieldValue(Event,'circle_radius_value'))
  
  ;determine how many pixels (going to the top and bottom) are in the circle
  nbr_pixel_up = getNbrOfPixelsInExclusion(Event, pixel_selected, radius, $
    direction='up')
  nbr_pixel_down = getNbrOfPixelsInExclusion(Event, pixel_selected, radius, $
    direction='down')
    
  ;print, 'nbr_pixel_up: ' + string(nbr_pixel_up)
  ;print, 'nbr_pixel_down: ' + string(nbr_pixel_down)
    
  ;determine how many tubes (going right and left) are in the circle
  nbr_tube_right = getNbrOfTubeInExclusion(Event, tube_selected, radius, $
    direction='right')
  nbr_tube_left = getNbrOfTubeInExclusion(Event, tube_selected, radius, $
    direction='left')
    
  ;print, 'nbr_tube_right: ' + string(nbr_tube_right)
  ;print, 'nbr_tube_left: ' + string(nbr_tube_left)
    
  ;Now we need to determine which pixels/tubes in the square
  ;  pixel_selected + nbr_pixel_up -> pixel_selected - nbr_pixel_down
  ;  tube_selected-nbr-tube_left -> tube_selected + nbr_tube_right
  ;are really withing radius from the center
  tube_list  = STRARR(1)
  pixel_list = STRARR(1)
  determine_array_of_pixel_tube_selected, Event,$
    nbr_tube_left=nbr_tube_left, $
    nbr_tube_right=nbr_tube_right, $
    nbr_pixel_down=nbr_pixel_down, $
    nbr_pixel_up=nbr_pixel_up, $
    radius = radius, $
    tube_selected = tube_selected, $
    pixel_selected = pixel_selected, $
    tube_list = tube_list, $
    pixel_list = pixel_list
    
  error: ;input format is wrong
  
END

;------------------------------------------------------------------------------
;This procedure replot the main plot before addign the circle selection
PRO refresh_main_plot_for_circle_selection, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  TV, (*(*global).background), true=3
  
END

;-------------------------------------------------------------------------------
;type: tube, pixel, radius
;direction: plus, minus
PRO change_circle_value, Event, type=type, direction=direction

  CASE (type) OF
    'tube'  : BEGIN
      uname = 'circle_tube_center'
      off_value = 1
    END
    'pixel' : BEGIN
      uname = 'circle_pixel_center'
      off_value = 1
    END
    'radius': BEGIN
      uname = 'circle_radius_value'
      off_value = 0.1
    END
  ENDCASE
  
  ON_IOERROR, error
  
  value =  getTextFieldValue(Event,uname)
  CASE (type) OF
    'tube'  : value = FIX(value)
    'pixel' : value = FIX(value)
    'radius': value = FLOAT(value)
  ENDCASE
  
  IF (direction EQ 'plus') THEN BEGIN
    value += off_value
  ENDIF ELSE BEGIN
    value -= off_value
  ENDELSE
  
  CASE (type) OF
    'tube' : BEGIN
      IF (value GT 192) THEN value = 191
      IF (value LE 0) THEN value = 1
    END
    'pixel' : BEGIN
      IF (value GT 255) THEN value = 255
      IF (value LT 0) THEN value = 0
    END
    'radius' : BEGIN
      IF (value LE 0) THEN value = 0.1
    END
  ENDCASE
  
  putTextFieldValue, Event, uname, STRCOMPRESS(value,/REMOVE_ALL)
  RETURN
  
  error:
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  message_text = [type + ' value (' + STRCOMPRESS(value,/REMOVE_ALL) + $
    ') is not a valid number','','Please check your input!']
  result = DIALOG_MESSAGE(message_text,$
    /ERROR, $
    /CENTER, $
    DIALOG_PARENT = id,$
    TITLE = type + ' input ERROR!')
    
END