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
PRO refresh_masking_region, Event

  WIDGET_CONTROL, event.top, GET_UVALUE=global
  
  excluded_pixel_array = (*(*global).excluded_pixel_array)
  
  ;retrieve list of pixel to exclude from Bank cw_field
  bank_field = getTextFieldValue(Event,'selection_bank')
  bank_array = getArray(bank_field)
  pixel_index = getPixelList_from_bankArray(bank_array)
  excluded_pixel_array[pixel_index] = 1
  
  
  
  
  
END