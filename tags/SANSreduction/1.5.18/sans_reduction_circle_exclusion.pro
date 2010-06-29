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

PRO saveExclusionCircleJK, Event, ADD=add

  ON_IOERROR, error ;catch any conversion to fix or float errors
  
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  tube_selected  = FIX(getTextFieldValue(Event,'circle_tube_center'))
  pixel_selected = FIX(getTextFieldValue(Event,'circle_pixel_center'))
  radius         = FLOAT(getTextFieldValue(Event,'circle_radius_value'))
  
  region = [tube_selected, pixel_selected, radius]
  
  jk_selection_xyr = (*(*global).jk_selection_xyr)
  
  IF ((size(jk_selection_xyr))(0) EQ 0) THEN BEGIN
    jk_selection_xyr = region
  ENDIF ELSE BEGIN
    jk_selection_xyr = [jk_selection_xyr,region]
  ENDELSE
  
  (*(*global).jk_selection_xyr) = jk_selection_xyr

  error:
  
END

;------------------------------------------------------------------------------
;Validate the exclusion
PRO validate_circular_selection, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  tube_list = (*(*global).circular_tube_list)
  pixel_list = (*(*global).circular_pixel_list)
  
  nbr_pixels_total = N_ELEMENTS(tube_list)
  pixel_array = STRARR(nbr_pixels_total)
  
  IF (nbr_pixels_total GT 0) THEN BEGIN
    index = 0
    WHILE (index LT nbr_pixels_total) DO BEGIN
      tube = tube_list[index]
      pixel = pixel_list[index]
      bank = getBankNumber(tube)
      tube_local = getTubeLocal(tube)
      ;   print, 'index: ' + string(index) + ', tube: ' + string(tube) + $
      ;', pixel: ' + string(pixel) + ' -> bank: ' + string(bank)
      line = 'bank' + STRCOMPRESS(bank,/REMOVE_ALL)
      line += '_' + STRCOMPRESS(tube_local,/REMOVE_ALL)
      line += '_' + STRCOMPRESS(pixel,/REMOVE_ALL)
      pixel_array[index] = line
      pixel++
      index++
    ENDWHILE
    
  ENDIF ELSE BEGIN ;enf of if(nbr_pixels_total GT 0)
  
    pixel_array = ['']
    
  ENDELSE
  
  ;check if Automatically Exclude Dead Tubes is ON
  IF (isAutoExcludeDeadTubeSelected(Event)) THEN BEGIN
    dead_tube_nbr = (*(*global).dead_tube_nbr)
    nbr_dead_tube = N_ELEMENTS(dead_tube_nbr)
    sz_pixel_array = LONG(nbr_dead_tube) * 256L
    IF (sz_pixel_array GT 0) THEN BEGIN
      PixelArray_of_Deadtubes = STRARR(sz_pixel_array)
      
      index = 0L ;make sure the index is long
      dead_tube_index = 0L
      WHILE (dead_tube_index LT nbr_dead_tube) DO BEGIN
        tube_global = dead_tube_nbr[dead_tube_index]
        bank = getBankNumber(tube_global+1)
        tube_local = getTubeLocal(tube_global+1)
        FOR pixel=0,255L DO BEGIN
          line = 'bank' + STRCOMPRESS(bank,/REMOVE_ALL)
          line += '_' + STRCOMPRESS(tube_local,/REMOVE_ALL)
          line += '_' + STRCOMPRESS(pixel,/REMOVE_ALL)
          PixelArray_of_DeadTubes[index] = line
          index++
        ENDFOR
        dead_tube_index++
      ENDWHILE
      
    ENDIF ELSE BEGIN;reset PixelArray_of_DeadTubes
      PixelArray_of_DeadTubes = STRARR(1)
    ENDELSE
  ENDIF ELSE BEGIN
    PixelArray_of_DeadTubes = STRARR(1)
    
  ENDELSE
  
  (*(*global).PixelArray_of_DeadTubes) = PixelArray_of_DeadTubes
  
  add_to_global_exclusion_array, event, pixel_array
  
END

;------------------------------------------------------------------------------
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
  
  (*(*global).circular_tube_list) = tube_list
  (*(*global).circular_pixel_list) = pixel_list
  
  plot_circle_exclusion_pixel, Event, tube_list, pixel_list
  
  error: ;input format is wrong
  
END

;------------------------------------------------------------------------------
PRO plot_circle_exclusion_pixel, Event, tube_array, pixel_array

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  
  IF (N_ELEMENTS(COEFF) EQ 0) THEN  coeff = FLOAT((*global).congrid_x_coeff)
  
;  DataArray = (*(*global).DataArray)
  
  color = FSC_COLOR('green')
  
  FOR pixel_index = 0, N_ELEMENTS(pixel_array)-1 DO BEGIN
  
    x1 = tube_array[pixel_index] * coeff
    x2 = (tube_array[pixel_index] + 1) * coeff
    y1 = (pixel_array[pixel_index] - 1 ) * coeff
    y2 = (pixel_array[pixel_index]) * coeff
    
    PLOTS, x1, y1, /DEVICE, COLOR=color
    PLOTS, x1, y2, /DEVICE, /CONTINUE, COLOR=color
    PLOTS, x2, y2, /DEVICE, /CONTINUE, COLOR=color
    PLOTS, x2, y1, /DEVICE, /CONTINUE, COLOR=color
    PLOTS, x1, y1, /DEVICE, /CONTINUE, COLOR=color
    
  ENDFOR
  
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
      IF (direction EQ '2plus' OR direction EQ '2minus') THEN BEGIN
        off_value = 1
      ENDIF ELSE BEGIN
        off_value = 0.1
      ENDELSE
    END
  ENDCASE
  
  ON_IOERROR, error
  
  value =  getTextFieldValue(Event,uname)
  CASE (type) OF
    'tube'  : value = FIX(value)
    'pixel' : value = FIX(value)
    'radius': value = FLOAT(value)
  ENDCASE
  
  IF (direction EQ 'plus' OR direction EQ '2plus') THEN BEGIN
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

;------------------------------------------------------------------------------
PRO display_error_message_about_circular_selection, Event

  title = 'Circular Selection Error !'
  message = ['Circular selection needs to be done with both panels seleted!','',$
    'Please select BOTH PANELS at the top right of the main plot!']
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  result = DIALOG_MESSAGE(message,$
    title=title, /ERROR, /CENTER, DIALOG_PARENT=id)
    
END
