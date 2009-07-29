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

PRO makeExclusionArray_SNS, Event

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;get tube and pixel of first corner
  tube0_data  = FIX(getTextFieldValue(Event,'corner_pixel_x0'))
  pixel0_data = FIX(getTextFieldValue(Event,'corner_pixel_y0'))
  
  ;get tubes and pixels width
  tube_width_data   = FIX(getTextFieldValue(Event,'corner_pixel_width'))
  nbr_tubes = tube_width_data
  pixel_height_data = FIX(getTextFieldValue(Event,'corner_pixel_height'))
  
  tube_sign = 1
  IF (tube_width_data LT 0) THEN tube_sign = -1
  
  pixel_sign = 1
  IF (pixel_height_data LT 0) THEN pixel_sign = -1
  
  ;go 2 by 2 for front and back panels only
  ;start at 1 if back panel
  panel_selected = getPanelSelected(Event)
  CASE (panel_selected) OF
    'front': BEGIN ;front
      ;      nbr_tubes = tube_width_data / 2
      tube_increment = 2
    END
    'back': BEGIN ;back
      ;      nbr_tubes = tube_width_data / 2
      tube_increment = 2
    END
    ELSE: BEGIN ;Both
      ;      nbr_tubes = tube_width_data
      tube_increment = 1
    END
  ENDCASE
  pixel_increment = pixel_sign
  
  nbr_pixels_total = (ABS(nbr_tubes)) * (ABS(pixel_height_data))
  ;print, 'nbr_pixels_total: ' + string(nbr_pixels_total)
  ;print, 'nbr_tubes: ' + string(nbr_tubes)
  ;print, 'pixel_height_data: ' + string(pixel_height_data)
  pixel_array = STRARR(nbr_pixels_total)
  
  IF (pixel_height_data GT 0) THEN BEGIN
    pixel_coeff = -1
  ENDIF ELSE BEGIN
    pixel_coeff = +1
  ENDELSE
  pixel1_data = pixel0_data + (pixel_height_data + pixel_coeff) * $
    pixel_increment
  from_pixel = MIN([pixel1_data,pixel0_data],MAX=to_pixel)
  
  IF (tube_width_data GT 0) THEN BEGIN
    tube_coeff = -1
  ENDIF ELSE BEGIN
    tube_coeff = +1
  ENDELSE
  tube1_data  = tube0_data + (tube_width_data + tube_coeff) * tube_increment
  from_tube = MIN([tube1_data, tube0_data],MAX=to_tube)
  
  ;print, 'from tube: ' + string(tube0_data) + ' to tube: ' + $
  ;string(tube1_data) + ' with increment: ' + string(tube_increment)
  ;print, 'from pixel: ' + string(pixel0_data) + ' to pixel: ' + $
  ;string(pixel1_data) + ' with increment: ' + string(pixel_increment)
  index = 0
  tube = from_tube
  WHILE (tube LE to_tube) DO BEGIN
    pixel = from_pixel
    WHILE (pixel LE to_pixel) DO BEGIN
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
    tube += tube_increment
  ENDWHILE
  
  add_to_global_exclusion_array, event, pixel_array
  
END

;------------------------------------------------------------------------------
PRO add_to_global_exclusion_array, event, pixel_array

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  global_exclusion_array = (*(*global).global_exclusion_array)
  IF (global_exclusion_array[0] EQ '') THEN BEGIN ;first time adding pixels
    global_exclusion_array = pixel_array
  ENDIF ELSE BEGIN
    global_exclusion_array = [global_exclusion_array, pixel_array]
  ENDELSE
  (*(*global).global_exclusion_array) = global_exclusion_array
  
END

;------------------------------------------------------------------------------
PRO SaveExclusionFile_SNS, Event

  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  pixel_array = (*(*global).global_exclusion_array)
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  folder         = (*global).selection_path
  file_name      = getTextfieldValue(Event,'save_roi_text_field')
  full_file_name = folder + file_name
  
  ;go 2 by 2 for front and back panels only
  ;start at 1 if back panel
  panel_selected = getPanelSelected(Event)
  CASE (panel_selected) OF
    'front': BEGIN ;front
      panel = 'front panel'
    END
    'back': BEGIN ;back
      panel = 'back panel'
    END
    ELSE: BEGIN ;Both
      panel = 'both panels'
    END
  ENDCASE
  
  text = '> Saving Exclusion Region for ' + panel
  IDLsendToGeek_addLogBookText, Event, text
  text = '-> ROI file name: ' + full_file_name
  IDLsendToGeek_addLogBookText, Event, text
  
  ;create file
  text = '-> Writing file ... ' + PROCESSING
  IDLsendToGeek_addLogBookText, Event, text
  error = 0
  CATCH, error
  IF (error NE 0) then begin
    CATCH, /CANCEL
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
  ENDIF ELSE BEGIN
    ;open output file
    OPENW, 1, full_file_name
    FOR i=0,N_ELEMENTS(pixel_array)-1 DO BEGIN
      PRINTF, 1, pixel_array[i]
    ENDFOR
    CLOSE, 1
    FREE_LUN, 1
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, OK
  ENDELSE
  
  putTextFieldValue, Event, 'roi_file_name_text_field', full_file_name
  ;enable PREVIEW button if file exist
  IF (FILE_TEST(full_file_name)) THEN BEGIN
    activate_widget = 1
  ENDIF ELSE BEGIN
    activate_widget = 0
  ENDELSE
  activate_widget, Event, 'preview_roi_exclusion_file', activate_widget
  
  ;turn off hourglass
  WIDGET_CONTROL,HOURGLASS=0
  
END