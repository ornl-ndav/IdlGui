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

pro SaveExclusionFile_SNS, Event
  compile_opt idl2

  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/HOURGLASS
  
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  pixel_array = (*(*global).global_exclusion_array)
  PixelArray_of_DeadTubes = (*(*global).PixelArray_of_DeadTubes)
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  folder         = (*global).selection_path
  file_name      = getTextfieldValue(Event,'save_roi_text_field')
  full_file_name = folder + file_name
  
  text = '> Saving Exclusion Region:'
  IDLsendToGeek_addLogBookText, Event, text
  text = '-> ROI file name: ' + full_file_name
  IDLsendToGeek_addLogBookText, Event, text
  
  ;create file
  text = '-> Writing file ... ' + PROCESSING
  IDLsendToGeek_addLogBookText, Event, text
  error = 0
  ;CATCH, error   ;REMOVE_ME
  IF (error NE 0) then begin
    CATCH, /CANCEL
    IDLsendToGeek_ReplaceLogBookText, Event, PROCESSING, FAILED
  ENDIF ELSE BEGIN
    ;open output file
    OPENW, 1, full_file_name
    
    inclusion_pixel_array = INTARR(48,4,256) + 1
    IF (pixel_array[0] NE '') THEN BEGIN
      inclusion_pixel_array = InverseROI(pixel_array)
    ENDIF
    
    DeadTubes = INTARR(48,4,256) + 1
    IF (PixelArray_of_Deadtubes[0] NE '') THEN BEGIN
      DeadTubes = InverseROI(PixelArray_of_DeadTubes)
    ENDIF
    
    ;copy the excluded pixels
    FOR bank=0,47 DO BEGIN
      FOR tube=0,3 DO BEGIN
        FOR pixel=0,255 DO BEGIN
          IF (inclusion_pixel_array[bank,tube,pixel] EQ 1 AND $
            DeadTubes[bank,tube,pixel] EQ 1) THEN BEGIN
            line = 'bank' + STRCOMPRESS(bank+1,/REMOVE_ALL) + '_' + $
              STRCOMPRESS(tube,/REMOVE_ALL) + '_' + $
              STRCOMPRESS(pixel,/REMOVE_ALL)
            PRINTF, 1, line
          ENDIF
        ENDFOR
      ENDFOR
    ENDFOR
    
    ;add jk exclusion region if any
    jk_selection = (*(*global).jk_selection_x0y0x1y1)
    nbr = N_ELEMENTS(jk_selection)
    IF (nbr GT 1) THEN BEGIN
      nbr_iteration = nbr/4
      index = 0
      WHILE (index LT nbr_iteration) DO BEGIN
        x0 = STRCOMPRESS(jk_selection[index*4],/REMOVE_ALL)
        y0 = STRCOMPRESS(jk_selection[index*4+1],/REMOVE_ALL)
        x1 = STRCOMPRESS(jk_selection[index*4+2],/REMOVE_ALL)
        y1 = STRCOMPRESS(jk_selection[index*4+3],/REMOVE_ALL)
        line = '#jk: ' + x0 + ',' + y0 + ',' + x1 + ',' + y1
        PRINTF, 1, line
        index++
      ENDWHILE
    ENDIF

    ;circle
    jk_selection = (*(*global).jk_selection_xyr)
    nbr = N_ELEMENTS(jk_selection)
    IF (nbr GT 1) THEN BEGIN
      nbr_iteration = nbr/3
      index = 0
      WHILE (index LT nbr_iteration) DO BEGIN
        x = STRCOMPRESS(jk_selection[index*3],/REMOVE_ALL)
        y = STRCOMPRESS(jk_selection[index*3+1],/REMOVE_ALL)
        r = STRCOMPRESS(jk_selection[index*3+2],/REMOVE_ALL)
        line = '#jk: ' + x + ',' + y + ',' + r
        PRINTF, 1, line
        index++
      ENDWHILE
    ENDIF

;FIXME FIXME FIXME FIXME
;    ;sector
;    jk_selection = (*(*global).jk_selection_x0y0x1y1)
;    nbr = N_ELEMENTS(jk_selection)
;    IF (nbr GT 1) THEN BEGIN
;      nbr_iteration = nbr/4
;      index = 0
;      WHILE (index LT nbr_iteration) DO BEGIN
;        x0 = STRCOMPRESS(jk_selection[index*4],/REMOVE_ALL)
;        y0 = STRCOMPRESS(jk_selection[index*4+1],/REMOVE_ALL)
;        x1 = STRCOMPRESS(jk_selection[index*4+2],/REMOVE_ALL)
;        y1 = STRCOMPRESS(jk_selection[index*4+3],/REMOVE_ALL)
;        line = '#jk: ' + x0 + ',' + y0 + ',' + x1 + ',' + y1
;        PRINTF, 1, line
;        index++
;      ENDWHILE
;    ENDIF

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