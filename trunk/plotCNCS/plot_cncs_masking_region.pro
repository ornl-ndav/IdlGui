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
;This function returns the list of pixels included in the list of tubes
FUNCTION getPixelList_from_tubeArray, tube_array

  pixels_first_tube = LINDGEN(128L)
  
  sz = N_ELEMENTS(tube_array)
  index = 0
  WHILE (index LT sz) DO BEGIN
  
    tube = tube_array[index]
    IF (N_ELEMENTS(final_list) EQ 0) THEN BEGIN
      final_list = pixels_first_tube + 128L * tube
    ENDIF ELSE BEGIN
      final_list = [final_list, pixels_first_tube + 128L * tube]
    ENDELSE
    
    index++
  ENDWHILE
  
  RETURN, final_list
  
END

;------------------------------------------------------------------------------
;This function returns the list of pixels included in the list of rows
FUNCTION getPixelList_from_rowArray, row_array

  pixels_first_row = LINDGEN(50L * 8L) * 128L
  
  sz = N_ELEMENTS(row_array)
  index = 0
  WHILE (index LT sz) DO BEGIN
  
    row = row_array[index]
    IF (N_ELEMENTS(final_list) EQ 0) THEN BEGIN
      final_list = pixels_first_row + row
    ENDIF ELSE BEGIN
      final_list = [final_list, pixels_first_row + row]
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

;------------------------------------------------------------------------------
PRO plot_masking_box, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  
  x1 = (*global1).X1_masking
  y1 = (*global1).Y1_masking
  x2 = (*global1).X2_masking
  y2 = (*global1).Y2_masking
  
  IF (x1 EQ 0L AND $
    x2 EQ 0L) THEN RETURN
    
  xmin = MIN([x1,x2], MAX=xmax)
  ymin = MIN([y1,y2], MAX=ymax)
  
  DEVICE, DECOMPOSED=0
  LOADCT, 5, /SILENT
  
  ;check if we want lin or log
  lin_status = isMainPlotLin(Event)
  IF (lin_status EQ 1) THEN BEGIN
    color = 150
  ENDIF ELSE BEGIN
    ;color = FSC_COLOR('white')
    color = 255*3
  ENDELSE
  
  id = WIDGET_INFO(Event.top,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  PLOTS, [xmin, xmin, xmax, xmax, xmin],$
    [ymin,ymax, ymax, ymin, ymin],$
    /DEVICE,$
    LINESTYLE = 5,$
    COLOR =color
    
END

;------------------------------------------------------------------------------
PRO saving_masking_background, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global
  
  ;select plot area
  id = WIDGET_INFO(Event.top,find_by_uname='main_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  background = TVRD(TRUE=3)
  DEVICE, copy=[0,0,1867L,4*128L+1,0,0,id_value]
  (*(*global).background_for_masking) = background
  
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
  
  ;retrieve list of pixel to exclude from tube cw_field
  tube_field = getTextFieldValue(Event,'selection_tube')
  IF (STRCOMPRESS(tube_field,/REMOVE_ALL) NE '') THEN BEGIN
    tube_array = getArray(tube_field)
    pixel_index = getPixelList_from_tubeArray(tube_array)
    excluded_pixel_array[pixel_index] = 1
    ;remove contains of cw_field bank
    putTextFieldValue, Event, 'selection_tube', ''
  ENDIF
  
  ;retrieve list of pixel to exclude from row cw_field
  row_field = getTextFieldValue(Event,'selection_row')
  IF (STRCOMPRESS(row_field,/REMOVE_ALL) NE '') THEN BEGIN
    row_array = getArray(row_field)
    pixel_index = getPixelList_from_rowArray(row_array)
    excluded_pixel_array[pixel_index] = 1
    ;remove contains of cw_field bank
    putTextFieldValue, Event, 'selection_row', ''
  ENDIF
  
  (*(*global).excluded_pixel_array) = excluded_pixel_array
  display_excluded_pixels, Event, excluded_pixel_array
  
  ;save background in case manual selection is next
  saving_masking_background, Event
  
END







