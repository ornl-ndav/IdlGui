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

;This function extrapolates the exact right pixel position that corresponds
;to the counts of the left pixel
FUNCTION extrapolate_exact_pixel, left_pixel_intensity, data, pixel_right

  Num1 = FLOAT(data(pixel_right + 1) - data(pixel_right))
  Num2 = FLOAT(left_pixel_intensity - data(pixel_right))
  
  exact_right_pixel = FLOAT(pixel_right) + Num2/Num1
  
  RETURN, exact_right_pixel
  
END

;------------------------------------------------------------------------------
FUNCTION retrieve_calculation_range, Event

  ON_IOERROR, error
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  data = (*(*global).tt_zoom_data)
  min_tube_plotted  = (*global).min_tube_plotted
  min_pixel_plotted = (*global).min_pixel_plotted
  
  ;calculation range
  tube1  = FIX(getTextFieldValue(Event,'tube1_button_value'))
  tube2  = FIX(getTextFieldValue(Event,'tube2_button_value'))
  pixel1 = FIX(getTextFieldValue(Event,'pixel1_button_value'))
  pixel2 = FIX(getTextFieldValue(Event,'pixel2_button_value'))
  
  tube_min  = MIN([tube1,tube2], MAX=tube_max)
  pixel_min = MIN([pixel1,pixel2], MAX=pixel_max)
  
  (*global).calculation_range_offset.pixel = pixel_min
  
  tube_min_offset  = tube_min - min_tube_plotted
  tube_max_offset  = tube_max - min_tube_plotted
  pixel_min_offset = pixel_min - min_pixel_plotted
  pixel_max_offset = pixel_max - min_pixel_plotted
  
  array = data[tube_min_offset:tube_max_offset, $
    pixel_min_offset:pixel_max_offset]
    
  RETURN, array
  
  error:
  RETURN, ''
  
END

;------------------------------------------------------------------------------
;pixel is the pixel value on the left side
;data are the array of the 2d data counts vs pixels for only the range
;specified in the calculation range
FUNCTION find_equivalent_right_pixel_from_pixel_on_left_side, Event, data, pixel

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ideal_beam_center = (*global).ideal_beam_center
  ibc_pixel = ideal_beam_center.pixel
  ibc_pixel_offset = ideal_beam_center.pixel_offset
  calculation_range_pixel_offset = (*global).calculation_range_offset.pixel
  range_pixel_min = FLOAT((ibc_pixel - calculation_range_pixel_offset) - $
    ibc_pixel_offset)
  range_pixel_max = FLOAT((ibc_pixel - calculation_range_pixel_offset) + $
    ibc_pixel_offset)
    
  left_pixel_intensity = data[pixel]
  pixel_left = pixel
  
  nbr_data = N_ELEMENTS(data)
  index=(nbr_data-1)
  WHILE (index GT pixel) DO BEGIN
  
    pixel_right = index
    IF (data[pixel_right] GT left_pixel_intensity) THEN BEGIN
    
      ;check that the beam center won't be offside of the range specified
      IF (((FLOAT(pixel_right) + FLOAT(pixel_left))/2 GE range_pixel_min) AND $
        ((FLOAT(pixel_right) + FLOAT(pixel_left))/2 LE range_pixel_max)) THEN BEGIN
        extrapolated_pixel_right = $
          extrapolate_exact_pixel(left_pixel_intensity, $
          data, $
          pixel_right)
        RETURN, extrapolated_pixel_right
      ENDIF
    ENDIF
    index--
  ENDWHILE
  
  RETURN, -1
END

;------------------------------------------------------------------------------
FUNCTION find_equivalent_left_pixel_from_pixel_on_right_side, Event, data, pixel

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ideal_beam_center = (*global).ideal_beam_center
  ibc_pixel = ideal_beam_center.pixel
  ibc_pixel_offset = ideal_beam_center.pixel_offset
  calculation_range_pixel_offset = (*global).calculation_range_offset.pixel
  range_pixel_min = FLOAT((ibc_pixel - calculation_range_pixel_offset) - $
    ibc_pixel_offset)
  range_pixel_max = FLOAT((ibc_pixel - calculation_range_pixel_offset) + $
    ibc_pixel_offset)
    
  right_pixel_intensity = data[pixel]
  pixel_right = pixel
  
  nbr_data = N_ELEMENTS(data)
  index = 0
  WHILE (index LT pixel) DO BEGIN
  
    pixel_left = index
    IF (data[pixel_left] GT right_pixel_intensity) THEN BEGIN
    
      ;check that the beam center won't be offside of the range specified
      IF (((FLOAT(pixel_right) + FLOAT(pixel_left))/2 GE range_pixel_min) AND $
        ((FLOAT(pixel_right) + FLOAT(pixel_left))/2 LE range_pixel_max)) THEN BEGIN
        extrapolated_pixel_left = $
          extrapolate_exact_pixel(right_pixel_intensity, $
          data, $
          pixel_left)
        RETURN, extrapolated_pixel_left
      ENDIF
    ENDIF
    index++
  ENDWHILE
  
  RETURN, -1
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
FUNCTION beam_center_pixel_calculation_function, Event, $
    MODE=mode, $
    DATA=data
    
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;initialize bc_pixel
  bc_pixel = 0
  
  ;get number of tubes (how many times we need to repeat the calculation)
  nbr_tubes = (size(data))(1)
  
  ;nbr of points to use in calculation
  nbr_cal = FIX(getTextFieldValue(Event,'beam_center_nbr_points_to_use'))
  
  ;get offset of first pixel to used
  first_offset = FIX(getTextFieldValue(Event,'beam_center_peak_offset'))
  
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
          getLastPixelOfIncreasingCounts(data_IvsPixel)
        IF (up_last_pixel_to_used_offset NE -1) THEN BEGIN
          FOR i=0,(nbr_cal-1) DO BEGIN
            pixel_to_use = up_last_pixel_to_used_offset - first_offset - i
            right_pixel = $
              find_equivalent_right_pixel_from_pixel_on_left_side(Event, $
              data_IvsPixel, pixel_to_use)
            beam_center = (FLOAT(pixel_to_use) + FLOAT(right_pixel)) / 2
            array_of_pixels[i,index] = beam_center
          ENDFOR
        ENDIF ELSE BEGIN
          arrray_of_pixels[*,index] = -1
        ENDELSE
      END
      
      'down': BEGIN
        down_last_pixel_to_used_offset = $
          getLastPixelOfDecreasingCounts(data_IvsPixel)
        IF (down_last_pixel_to_used_offset NE -1) THEN BEGIN
          FOR i=0,(nbr_cal-1) DO BEGIN
            pixel_to_use = down_last_pixel_to_used_offset + first_offset + i
            left_pixel = $
              find_equivalent_left_pixel_from_pixel_on_right_side(Event, $
              data_IvsPixel, pixel_to_use)
            beam_center = (FLOAT(pixel_to_use) + FLOAT(left_pixel)) / 2
            array_of_pixels[i,index] = beam_center
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