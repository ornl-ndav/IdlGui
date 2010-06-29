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

;This function extrapolates the exact right element position that corresponds
;to the counts of the left element
FUNCTION extrapolate_exact_element, left_element_intensity, data, element_right

  IF ((element_right + 1) GE N_ELEMENTS(data)) THEN element_right--
  
  Num1 = FLOAT(data[element_right + 1] - data[element_right])
  Num2 = FLOAT(left_element_intensity - data[element_right])
  
  exact_right_element = FLOAT(element_right) + Num2/Num1
  
  RETURN, exact_right_element
  
END

;------------------------------------------------------------------------------
FUNCTION retrieve_calculation_range, Event=event, base=base

  ON_IOERROR, error
  
  IF (N_ELEMENTS(event) NE 0) THEN BEGIN ;with event
  
    ;get global structure
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
    
    data = (*(*global).tt_zoom_data)
    min_tube_plotted  = (*global).min_tube_plotted
    min_pixel_plotted = (*global).min_pixel_plotted
    
    ;remove beam stop region (if any)
    tube_left = FIX(getTextFieldValue(Event,$
      'beam_center_beam_stop_tube_left'))
    tube_right = FIX(getTextFieldValue(Event,$
      'beam_center_beam_stop_tube_right'))
    pixel_left = FIX(getTextFieldValue(Event,$
      'beam_center_beam_stop_pixel_left'))
    pixel_right = FIX(getTextFieldValue(Event,$
      'beam_center_beam_stop_pixel_right'))
    bs_tube_min = MIN([tube_left,tube_right],MAX=bs_tube_max)
    bs_pixel_min = MIN([pixel_left,pixel_right],MAX=bs_pixel_max)
    
    bs_tube_min_offset = bs_tube_min - min_tube_plotted
    bs_tube_max_offset = bs_tube_max - min_tube_plotted
    bs_pixel_min_offset = bs_pixel_min - min_pixel_plotted
    bs_pixel_max_offset = bs_pixel_max - min_pixel_plotted
    
    data[bs_tube_min_offset:bs_tube_max_offset, $
      bs_pixel_min_offset:bs_pixel_max_offset] = 0
      
    ;calculation range
    tube1  = FIX(getTextFieldValue(Event,$
      'beam_center_calculation_range_tube_left'))
    tube2  = FIX(getTextFieldValue(Event,$
      'beam_center_calculation_range_tube_right'))
    pixel1 = FIX(getTextFieldValue(Event,$
      'beam_center_calculation_range_pixel_left'))
    pixel2 = FIX(getTextFieldValue(Event,$
      'beam_center_calculation_range_pixel_right'))
      
    tube_min  = MIN([tube1,tube2], MAX=tube_max)
    pixel_min = MIN([pixel1,pixel2], MAX=pixel_max)
    
    (*global).calculation_range_offset.pixel = pixel_min
    (*global).calculation_range_offset.tube  = tube_min
    
    tube_min_offset  = tube_min - min_tube_plotted
    tube_max_offset  = tube_max - min_tube_plotted
    pixel_min_offset = pixel_min - min_pixel_plotted
    pixel_max_offset = pixel_max - min_pixel_plotted
    
    array = data[tube_min_offset:tube_max_offset, $
      pixel_min_offset:pixel_max_offset]
      
    RETURN, array
    
  ENDIF ELSE BEGIN ;with wbase
  
    ;get global structure
    WIDGET_CONTROL,base,GET_UVALUE=global
    
    data = (*(*global).tt_zoom_data)
    min_tube_plotted  = (*global).min_tube_plotted
    min_pixel_plotted = (*global).min_pixel_plotted
    
    ;remove beam stop region (if any)
    tube_left = FIX(getTextFieldValue_from_base(base, $
      'beam_center_beam_stop_tube_left'))
    tube_right = FIX(getTextFieldValue_from_base(base, $
      'beam_center_beam_stop_tube_right'))
    pixel_left = FIX(getTextFieldValue_from_base(base, $
      'beam_center_beam_stop_pixel_left'))
    pixel_right = FIX(getTextFieldValue_from_base(base, $
      'beam_center_beam_stop_pixel_right'))
    bs_tube_min = MIN([tube_left,tube_right],MAX=bs_tube_max)
    bs_pixel_min = MIN([pixel_left,pixel_right],MAX=bs_pixel_max)
    
    bs_tube_min_offset = bs_tube_min - min_tube_plotted
    bs_tube_max_offset = bs_tube_max - min_tube_plotted
    bs_pixel_min_offset = bs_pixel_min - min_pixel_plotted
    bs_pixel_max_offset = bs_pixel_max - min_pixel_plotted
    
    data[bs_tube_min_offset:bs_tube_max_offset, $
      bs_pixel_min_offset:bs_pixel_max_offset] = 0
      
    ;calculation range
    tube1  = FIX(getTextFieldValue_from_base(base,$
      'beam_center_calculation_range_tube_left'))
    tube2  = FIX(getTextfieldValue_from_base(base,$
      'beam_center_calculation_range_tube_right'))
    pixel1 = FIX(getTextFieldValue_from_base(base,$
      'beam_center_calculation_range_pixel_left'))
    pixel2 = FIX(getTextFieldValue_from_base(base,$
      'beam_center_calculation_range_pixel_right'))
      
    tube_min  = MIN([tube1,tube2], MAX=tube_max)
    pixel_min = MIN([pixel1,pixel2], MAX=pixel_max)
    
    (*global).calculation_range_offset.pixel = pixel_min
    (*global).calculation_range_offset.tube  = tube_min
    
    tube_min_offset  = tube_min - min_tube_plotted
    tube_max_offset  = tube_max - min_tube_plotted
    pixel_min_offset = pixel_min - min_pixel_plotted
    pixel_max_offset = pixel_max - min_pixel_plotted
    
    array = data[tube_min_offset:tube_max_offset, $
      pixel_min_offset:pixel_max_offset]
      
    RETURN, array
    
  ENDELSE
  
  error:
  RETURN, ''
  
END

;------------------------------------------------------------------------------
;element is the element value on the left side (tube or pixel)
;data are the array of the 2d data counts vs pixels/tubes for only the range
;specified in the calculation range
;mode is 'tube' or 'pixel'
FUNCTION find_equivalent_right_element_from_element_on_left_side, Event=event, $
    base=base,$
    data, $
    element, $
    MODE=mode, $
    DATA_OFFSET = data_offset
    
  IF (N_ELEMENTS(event) NE 0) THEN BEGIN
    ;get global structure
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDIF ELSE BEGIN
    ;get global structure
    WIDGET_CONTROL,base,GET_UVALUE=global
  ENDELSE
  
  ideal_beam_center = (*global).ideal_beam_center
  IF (MODE EQ 'tube') THEN BEGIN
    ibc_element = ideal_beam_center.tube
    ibc_element_offset = ideal_beam_center.tube_offset
    calculation_range_element_offset = (*global).calculation_range_offset.tube
    tube_offset = DATA_OFFSET
  ENDIF ELSE BEGIN
    ibc_element = ideal_beam_center.pixel
    ibc_element_offset = ideal_beam_center.pixel_offset
    calculation_range_element_offset = (*global).calculation_range_offset.pixel
  ENDELSE
  
  range_element_min = FLOAT((ibc_element - $
    calculation_range_element_offset) - ibc_element_offset)
  range_element_max = FLOAT((ibc_element - $
    calculation_range_element_offset) + ibc_element_offset)
    
  left_element_intensity = data[element]
  element_left = element
  
  nbr_data = N_ELEMENTS(data)
  index=(nbr_data-1)
  WHILE (index GT element) DO BEGIN
  
    element_right = index
    IF (data[element_right] GT left_element_intensity) THEN BEGIN
    
      IF (MODE EQ 'pixel') THEN BEGIN
      
        ;check that the beam center won't be offside of the range specified
        IF (((FLOAT(element_right) + $
          FLOAT(element_left))/2 GE range_element_min) AND $
          ((FLOAT(element_right) + $
          FLOAT(element_left))/2 LE range_element_max)) THEN BEGIN
          extrapolated_element_right = $
            extrapolate_exact_element(left_element_intensity, $
            data, $
            element_right)
          RETURN, extrapolated_element_right
        ENDIF
        
      ENDIF ELSE BEGIN
      
        element_right_test = 2*element_right + tube_offset
        element_left_test = 2*element_left + tube_offset
        ;check that the beam center won't be offside of the range specified
        IF (((FLOAT(element_right_test) + $
          FLOAT(element_left_test))/2 GE range_element_min) AND $
          ((FLOAT(element_right_test) + $
          FLOAT(element_left_test))/2 LE range_element_max)) THEN BEGIN
          extrapolated_element_right = $
            extrapolate_exact_element(left_element_intensity, $
            data, $
            element_right)
          RETURN, extrapolated_element_right
        ENDIF
        
      ENDELSE
      
    ENDIF
    index--
  ENDWHILE
  
  RETURN, -1
END

;------------------------------------------------------------------------------
FUNCTION find_equivalent_left_element_from_element_on_right_side, Event=event, $
    base=base,$
    data, $
    element, $
    MODE=mode, $
    DATA_OFFSET = data_offset
    
  IF (N_ELEMENTS(event) NE 0) THEN BEGIN
    ;get global structure
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
  ENDIF ELSE BEGIN
    ;get global structure
    WIDGET_CONTROL,base,GET_UVALUE=global
  ENDELSE
  
  ideal_beam_center = (*global).ideal_beam_center
  IF (MODE EQ 'tube') THEN BEGIN
    ibc_element = ideal_beam_center.tube
    ibc_element_offset = ideal_beam_center.tube_offset
    calculation_range_element_offset = (*global).calculation_range_offset.tube
    tube_offset = DATA_OFFSET
  ENDIF ELSE BEGIN
    ibc_element = ideal_beam_center.pixel
    ibc_element_offset = ideal_beam_center.pixel_offset
    calculation_range_element_offset = (*global).calculation_range_offset.pixel
  ENDELSE
  
  range_element_min = FLOAT((ibc_element - $
    calculation_range_element_offset) - ibc_element_offset)
  range_element_max = FLOAT((ibc_element - $
    calculation_range_element_offset) + ibc_element_offset)
    
  right_element_intensity = data[element]
  element_right = element
  
  nbr_data = N_ELEMENTS(data)
  index = 0
  WHILE (index LT element) DO BEGIN
  
    element_left = index
    IF (data[element_left] GT right_element_intensity) THEN BEGIN
    
      IF (MODE EQ 'pixel') THEN BEGIN
      
        ;check that the beam center won't be offside of the range specified
        IF (((FLOAT(element_right) + $
          FLOAT(element_left))/2 GE range_element_min) AND $
          ((FLOAT(element_right) + $
          FLOAT(element_left))/2 LE range_element_max)) THEN BEGIN
          extrapolated_element_left = $
            extrapolate_exact_element(right_element_intensity, $
            data, $
            element_left)
          RETURN, extrapolated_element_left
        ENDIF
        
      ENDIF ELSE BEGIN ;mode is tube
      
        element_right_test = 2*element_right + tube_offset
        element_left_test = 2*element_left + tube_offset
        
        ;check that the beam center won't be offside of the range specified
        IF (((FLOAT(element_right_test) + $
          FLOAT(element_left_test))/2 GE range_element_min) AND $
          ((FLOAT(element_right_test) + $
          FLOAT(element_left_test))/2 LE range_element_max)) THEN BEGIN
          extrapolated_element_left = $
            extrapolate_exact_element(right_element_intensity, $
            data, $
            element_left)
          RETURN, extrapolated_element_left
        ENDIF
        
      ENDELSE
      
    ENDIF
    index++
  ENDWHILE
  
  RETURN, -1
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
FUNCTION beam_center_pixel_calculation_function, Event=event, $
    base=base,$
    MODE=mode, $
    DATA=data
    
  IF (N_ELEMENTS(event) NE 0) THEN BEGIN
  
    ;get global structure
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
    
    ;initialize bc_pixel
    bc_pixel = 0
    
    ;get number of tubes (how many times we need to repeat the calculation)
    nbr_tubes = (size(data))(1)
    nbr_pixels = (size(data))(2)
    
    ;nbr of points to use in calculation
    nbr_cal = FIX(getTextFieldValue(Event,'beam_center_nbr_points_to_use'))
    
    ;get offset of first pixel to used
    first_offset = FIX(getTextFieldValue(Event,'beam_center_peak_offset'))
    
  ENDIF ELSE BEGIN
  
    ;get global structure
    WIDGET_CONTROL,base,GET_UVALUE=global
    
    ;initialize bc_pixel
    bc_pixel = 0
    
    ;get number of tubes (how many times we need to repeat the calculation)
    nbr_tubes = (size(data))(1)
    nbr_pixels = (size(data))(2)
    
    ;nbr of points to use in calculation
    nbr_cal = FIX(getTextFieldValue_from_base(base,$
      'beam_center_nbr_points_to_use'))
      
    ;get offset of first pixel to used
    first_offset = FIX(getTextFieldValue_from_base(base,$
      'beam_center_peak_offset'))
      
  ENDELSE
  
  array_of_pixels = FLTARR(nbr_cal, nbr_tubes)
  pixel_offset = (*global).calculation_range_offset.pixel
  
  index = 0
  WHILE (index LT nbr_tubes) DO BEGIN
  
    ;counts vs pixel of current tube
    data_IvsPixel = DATA[index,*]
    
    ;we retrieves for each tube the pixel of the maximum counts on the left
    ;side of the plot
    ;mode: 'up' or 'down'
    CASE (mode) OF
    
      'up': BEGIN
        up_last_pixel_to_used_offset = $
          getLastElementOfIncreasingCounts(data_IvsPixel, MODE='pixel')
        IF (up_last_pixel_to_used_offset NE -1) THEN BEGIN
          FOR i=0,(nbr_cal-1) DO BEGIN ;loop for nbr_cal previous pixels
            pixel_to_use = up_last_pixel_to_used_offset - first_offset - i
            IF (pixel_to_use GT 0) THEN BEGIN
              IF (N_ELEMENTS(event) NE 0) THEN BEGIN
                right_pixel = $
                  find_equivalent_right_element_from_element_on_left_side(Event=event, $
                  data_IvsPixel, pixel_to_use, MODE='pixel')
              ENDIF ELSE BEGIN
                right_pixel = $
                  find_equivalent_right_element_from_element_on_left_side(base=base, $
                  data_IvsPixel, pixel_to_use, MODE='pixel')
              ENDELSE
              IF (right_pixel NE -1) THEN BEGIN
                beam_center = (FLOAT(pixel_to_use) + FLOAT(right_pixel)) / 2
              ENDIF ELSE BEGIN
                beam_center = -1
              ENDELSE
              array_of_pixels[i,index] = beam_center
            ENDIF ELSE BEGIN
              array_of_pixels[*,index] = -1
            ENDELSE
          ENDFOR
        ENDIF ELSE BEGIN
          array_of_pixels[*,index] = -1
        ENDELSE
      END
      
      'down': BEGIN
        down_last_pixel_to_used_offset = $
          getLastElementOfDecreasingCounts(data_IvsPixel, MODE='pixel')
        IF (down_last_pixel_to_used_offset NE -1) THEN BEGIN
          FOR i=0,(nbr_cal-1) DO BEGIN
            pixel_to_use = down_last_pixel_to_used_offset + first_offset + i
            IF (pixel_to_use LT nbr_pixels) THEN BEGIN
              IF (N_ELEMENTS(event) NE 0) THEN BEGIN
                left_pixel = $
                  find_equivalent_left_element_from_element_on_right_side(Event=event, $
                  data_IvsPixel, pixel_to_use, MODE='pixel')
              ENDIF ELSE BEGIN
                left_pixel = $
                  find_equivalent_left_element_from_element_on_right_side(base=base, $
                  data_IvsPixel, pixel_to_use, MODE='pixel')
              ENDELSE
              IF (left_pixel NE -1) THEN BEGIN
                beam_center = (FLOAT(pixel_to_use) + FLOAT(left_pixel)) / 2
              ENDIF ELSE BEGIN
                beam_center = -1
              ENDELSE
              array_of_pixels[i,index] = beam_center
            ENDIF ELSE BEGIN
              array_of_pixels[*,index] = -1
            ENDELSE
          ENDFOR
        ENDIF ELSE BEGIN
          array_of_pixels[*,index] = -1
        ENDELSE
      END
      
    ENDCASE
    
    index++
  ENDWHILE
  
  RETURN, array_of_pixels
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
FUNCTION beam_center_tube_calculation_function, Event=event, $
    base=base,$
    MODE = mode, $
    DATA = data, $
    BANK = bank
    
  IF (N_ELEMENTS(event) NE 0) THEN BEGIN ;event
  
    ;get global structure
    WIDGET_CONTROL,Event.top,GET_UVALUE=global
    
    ;initialize bc_tube
    bc_tube = 0
    
    ;get number of tubes (how many times we need to repeat the calculation)
    nbr_pixels = (size(data))(2)
    nbr_tubes  = (size(data))(1)
    
    ;nbr of points to use in calculation
    nbr_cal = FIX(getTextFieldValue(Event,'beam_center_nbr_points_to_use'))
    
    ;get offset of first tube to used
    first_offset = FIX(getTextFieldValue(Event,'beam_center_peak_offset'))
    
    array_of_tubes = FLTARR(nbr_cal, nbr_pixels)
    
    tube_offset = (*global).calculation_range_offset.tube
    
    local_nbr_tubes = FIX(nbr_tubes)/2
    DATA_LOCAL = INTARR(local_nbr_tubes, nbr_pixels)
    
    data_offset = 0
    IF ((first_offset MOD 2) EQ 0) THEN BEGIN ;even number
      CASE (bank) OF
        'front': data_offset = 0
        'back' : data_offset = 1
      ENDCASE
    ENDIF ELSE BEGIN
      CASE (bank) OF
        'front': data_offset = 1
        'back' : data_offset = 0
      ENDCASE
    ENDELSE
    
    smooth_parameter = FIX(getTextFieldValue(Event, $
      'beam_center_smooth_parameter'))
      
  ENDIF ELSE BEGIN ;base
  
    ;get global structure
    WIDGET_CONTROL,base,GET_UVALUE=global
    
    ;initialize bc_tube
    bc_tube = 0
    
    ;get number of tubes (how many times we need to repeat the calculation)
    nbr_pixels = (size(data))(2)
    nbr_tubes  = (size(data))(1)
    
    ;nbr of points to use in calculation
    nbr_cal = FIX(getTextFieldValue_from_base(base,$
      'beam_center_nbr_points_to_use'))
      
    ;get offset of first tube to used
    first_offset = FIX(getTextFieldValue_from_base(base,$
      'beam_center_peak_offset'))
      
    array_of_tubes = FLTARR(nbr_cal, nbr_pixels)
    
    tube_offset = (*global).calculation_range_offset.tube
    
    local_nbr_tubes = FIX(nbr_tubes)/2
    DATA_LOCAL = INTARR(local_nbr_tubes, nbr_pixels)
    
    data_offset = 0
    IF ((first_offset MOD 2) EQ 0) THEN BEGIN ;even number
      CASE (bank) OF
        'front': data_offset = 0
        'back' : data_offset = 1
      ENDCASE
    ENDIF ELSE BEGIN
      CASE (bank) OF
        'front': data_offset = 1
        'back' : data_offset = 0
      ENDCASE
    ENDELSE
    
    smooth_parameter = FIX(getTextFieldValue_from_base(base, $
      'beam_center_smooth_parameter'))
      
  ENDELSE ;end of event or base
  
  index = data_offset
  i = 0
  WHILE (index LT nbr_tubes AND $
    i LT local_nbr_tubes) DO BEGIN
    DATA_LOCAL[i,*] = data[index,*]
    i++
    index += 2
  ENDWHILE
  
  data_local = smooth(data_local, smooth_parameter)
  
  index = 0
  WHILE (index LT nbr_pixels) DO BEGIN
  
    ;counts vs pixel of current tube
    data_IvsTube = DATA_LOCAL[*,index]
    
    ;we retrieves for each tube the pixel of the maximum counts on the left
    ;side of the plot
    ;mode: 'up' or 'down'
    CASE (mode) OF
    
      'up': BEGIN
        up_last_tube_to_used_offset = $
          getLastElementOfIncreasingCounts(data_IvsTube, MODE='tube')
        IF (up_last_tube_to_used_offset NE -1) THEN BEGIN
          FOR i=0,(nbr_cal-1) DO BEGIN
            tube_to_use = up_last_tube_to_used_offset - first_offset - i
            IF (tube_to_use LT 0) THEN BEGIN
              array_of_tubes[*,index] = -1
            ENDIF ELSE BEGIN
              IF (N_ELEMENTS(event) NE 0) THEN BEGIN
                right_tube =  $
                  find_equivalent_right_element_from_element_on_left_side(Event=event, $
                  data_IvsTube, $
                  tube_to_use, $
                  MODE='tube', $
                  DATA_OFFSET = data_offset)
              ENDIF ELSE BEGIN
                right_tube =  $
                  find_equivalent_right_element_from_element_on_left_side(base=base, $
                  data_IvsTube, $
                  tube_to_use, $
                  MODE='tube', $
                  DATA_OFFSET = data_offset)
              ENDELSE
              IF (right_tube LT 0) THEN BEGIN
                beam_center = -1
              ENDIF ELSE BEGIN
                beam_center = (FLOAT(tube_to_use) + FLOAT(right_tube)) / 2
              ENDELSE
              array_of_tubes[i,index] = beam_center
            ENDELSE
          ENDFOR
        ENDIF ELSE BEGIN
          array_of_tubes[*,index] = -1
        ENDELSE
      END
      'down': BEGIN
        down_last_tube_to_used_offset = $
          getLastElementOfDecreasingCounts(data_IvsTube, MODE='tube')
        IF (down_last_tube_to_used_offset NE -1) THEN BEGIN
          FOR i=0,(nbr_cal-1) DO BEGIN
            tube_to_use = down_last_tube_to_used_offset + first_offset + i
            IF (tube_to_use LT local_nbr_tubes) THEN BEGIN
              IF (N_ELEMENTS(Event) NE 0) THEN BEGIN
                left_tube = $
                  find_equivalent_left_element_from_element_on_right_side(Event=event, $
                  data_IvsTube, $
                  tube_to_use, $
                  MODE='tube', $
                  DATA_OFFSET = data_offset)
              ENDIF ELSE BEGIN
                left_tube = $
                  find_equivalent_left_element_from_element_on_right_side(base=base, $
                  data_IvsTube, $
                  tube_to_use, $
                  MODE='tube', $
                  DATA_OFFSET = data_offset)
              ENDELSE
              IF (left_tube LT 0) THEN BEGIN
                beam_center = -1
              ENDIF ELSE BEGIN
                beam_center = (FLOAT(tube_to_use) + FLOAT(left_tube)) / 2
              ENDELSE
              array_of_tubes[i,index] = beam_center
            ENDIF ELSE BEGIN
              array_of_tubes[*,index] = 1
            ENDELSE
          ENDFOR
        ENDIF ELSE BEGIN
          array_of_tubes[*,index] = -1
        ENDELSE
      END
      
    ENDCASE
    
    index++
  ENDWHILE
  
  RETURN, 2*array_of_tubes + data_offset
END