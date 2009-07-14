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

FUNCTION getXYfromPixelID, pixelID
  y = pixelID MOD 128
  x = pixelID / 128
  RETURN, [x,y]
END

;------------------------------------------------------------------------------
FUNCTION getx0y0x1y1, Event, xy

  xmin = xy[0]
  ymin = xy[1]
  
  WIDGET_CONTROL, event.top, GET_UVALUE=global
  
  Xfactor = (*global).Xfactor
  Yfactor = (*global).Yfactor
  
  Xcoeff  = (*global).Xcoeff
  off     = (*global).off
  
  ;get ymin and ymax
  ymin = ymin * Yfactor
  ymax = ymin + Yfactor
  
  ;get xmin and xmax
  bank_nbr = xmin / 8
  ;if bank >=37, then make two more shifts to the right
  IF (bank_nbr GE 36) THEN BEGIN ;because banks have been shifted to the left
    bank_nbr += 2
    xmin += 16
  ENDIF
  xmin = ( bank_nbr + xmin ) * xfactor
  xmax = xmin + Xfactor
  
  RETURN, [xmin, ymin, xmax, ymax]
  
END

;------------------------------------------------------------------------------
;This function returns the list of pixels included in the list of banks
FUNCTION getPixelList_from_bankArray, bank_array

  pixels_first_bank = LINDGEN(1024L)
  
  sz = N_ELEMENTS(bank_array)
  index = 0
  WHILE (index LT sz) DO BEGIN
  
    bank = bank_array[index]
    IF (N_ELEMENTS(final_list) EQ 0) THEN BEGIN
      final_list = pixels_first_bank + 1024L * bank
    ENDIF ELSE BEGIN
      final_list = [final_list, pixels_first_bank + 1024L * bank]
    ENDELSE
    
    index++
  ENDWHILE
  
  RETURN, final_list
  
END

;------------------------------------------------------------------------------
PRO display_excluded_pixels, Event, excluded_pixel_array

  excluded_pixels_index = WHERE(excluded_pixel_array EQ 1, sz)
  ;  excluded_pixels = excluded_pixel_array[excluded_pixels_index]
  
  ;select plot area
  id = WIDGET_INFO(Event.top,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  index = 0
  WHILE (index LT sz) DO BEGIN
  
    xy = getXYfromPixelID(excluded_pixels_index[index])
    x0y0x1y1 = getx0y0x1y1(Event, xy)
    
    xmin = x0y0x1y1[0]
    ymin = x0y0x1y1[1]
    xmax = x0y0x1y1[2]
    ymax = x0y0x1y1[3]
    
    PLOTS, [xmin, xmin, xmax, xmax, xmin],$
      [ymin,ymax, ymax, ymin, ymin],$
      /DEVICE,$
      LINESTYLE = 0,$
      COLOR =250
      
    index++
  ENDWHILE
  
END

;==============================================================================
;------------------------------------------------------------------------------
PRO refresh_masking_region, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global
  
  excluded_pixel_array = (*(*global).excluded_pixel_array)
  
  ;retrieve list of pixel to exclude from pixelid cw_field
  pixelid_field = getTextFieldValue(Event,'selection_pixelid')
  IF (STRCOMPRESS(pixelid_field,/REMOVE_ALL) NE '') THEN BEGIN
    pixelid_array = getArray(pixelid_field)
    excluded_pixel_array[pixelid_array] = 1
    ;remove contains of cw_field pixelid
    putTextFieldValue, Event, 'selection_pixelid', ''
  ENDIF
  
  ;retrieve list of pixel to exclude from Bank cw_field
  bank_field = getTextFieldValue(Event,'selection_bank')
  IF (STRCOMPRESS(bank_field,/REMOVE_ALL) NE '') THEN BEGIN
    bank_array = getArray(bank_field)
    ;shift bank array number to the left as bank
    ;1 -> 0 for processing purpose only
    bank_array =  bank_array - 1
    pixel_index = getPixelList_from_bankArray(bank_array)
    excluded_pixel_array[pixel_index] = 1
    ;remove contains of cw_field bank
    putTextFieldValue, Event, 'selection_bank', ''
  ENDIF
  
  (*(*global).excluded_pixel_array) = excluded_pixel_array
  display_excluded_pixels, Event, excluded_pixel_array
  
END







