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
;   Laboratory nor the names of its contributors may be used to endiorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

PRO saveExclusionBorders, Event, ADD=add

  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF ((*global).facility EQ 'LENS') THEN RETURN
  
  ;get tube and pixel of first corner
  tube0_data  = FIX(getTextFieldValue(Event,'corner_pixel_x0'))
  pixel0_data = FIX(getTextFieldValue(Event,'corner_pixel_y0'))
  
  ;get tubes and pixels width
  tube_width_data   = FIX(getTextFieldValue(Event,'corner_pixel_width'))
  pixel_height_data = FIX(getTextFieldValue(Event,'corner_pixel_height'))
  
  ;get tube and pixel of other side
  tube1_data = tube0_data + tube_width_data - 1
  pixel1_data = pixel0_data + pixel_height_data - 1

  jk_selection_x0y0x1y1 = (*(*global).jk_selection_x0y0x1y1)
  
  IF ((*global).selection_type EQ 'inside') THEN BEGIN ;inside selection
  
    IF ((size(jk_selection_x0y0x1y1))(0) EQ 0) THEN BEGIN
      jk_selection_x0y0x1y1 = INTARR(4)
      jk_selection_x0y0x1y1[0] = tube0_data
      jk_selection_x0y0x1y1[1] = pixel0_data
      jk_selection_x0y0x1y1[2] = tube1_data
      jk_selection_x0y0x1y1[3] = pixel1_data
    ENDIF ELSE BEGIN
      new_array = INTARR(4)
      new_array[0] = tube0_data
      new_array[1] = pixel0_data
      new_array[2] = tube1_data
      new_array[3] = pixel1_data
      jk_selection_x0y0x1y1 = [jk_selection_x0y0x1y1,new_array]
    ENDELSE
    
  ENDIF ELSE BEGIN ;outside selection
  
    tube_min = MIN([tube0_data,tube1_data], MAX=tube_max)
    pixel_min = MIN([pixel0_data,pixel1_data], MAX=pixel_max)
    
    geo_tube_max = 192
    geo_tube_min = 0
    geo_pixel_max = 256
    geo_pixel_min = 0
    
    region = INTARR(4,4)
    ;region1
    xmin = geo_tube_min
    xmax = tube_min
    ymin = geo_pixel_min
    ymax = pixel_max
    region[*,0] = [xmin,ymin,xmax,ymax]
    ;region 2
    xmin = tube_min
    xmax = geo_tube_max
    ymin = geo_pixel_min
    ymax = pixel_min
    region[*,1] = [xmin,ymin,xmax,ymax]
    ;region 3
    xmin = tube_max
    xmax = geo_tube_max
    ymin = pixel_min
    ymax = geo_pixel_max
    region[*,2] = [xmin,ymin,xmax,ymax]
    ;region 4
    xmin = geo_tube_min
    xmax = tube_max
    ymin = pixel_max
    ymax = geo_pixel_max
    region[*,3] = [xmin,ymin,xmax,ymax]
    
    IF ((size(jk_selection_x0y0x1y1))(0) EQ 0) THEN BEGIN
      jk_selection_x0y0x1y1 = region[*,0]
    ENDIF ELSE BEGIN
      jk_selection_x0y0x1y1 = [jk_selection_x0y0x1y1,region[*,0]]
    ENDELSE
    jk_selection_x0y0x1y1 = [jk_selection_x0y0x1y1,region[*,1]]
    jk_selection_x0y0x1y1 = [jk_selection_x0y0x1y1,region[*,2]]
    jk_selection_x0y0x1y1 = [jk_selection_x0y0x1y1,region[*,3]]
    
  ENDELSE
  
  (*(*global).jk_selection_x0y0x1y1) = jk_selection_x0y0x1y1
  
END

;==============================================================================
PRO tmp

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
  
  ;calculate size of pixel_array STRARR
  nbr_pixels_total = LONG(ABS(nbr_tubes)) * LONG(ABS(pixel_height_data))
  IF ((*global).selection_type EQ 'outside') THEN BEGIN ;outside selection
    nbr_pixels_total = 192L * 256L - nbr_pixels_total
  ENDIF
  
  IF (nbr_pixels_total GT 0) THEN BEGIN
  
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
    
    IF ((*global).selection_type EQ 'inside') THEN BEGIN ;inside selection
    
      index = 0
      IF (nbr_pixels_total GT 0) THEN BEGIN
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
      ENDIF
      
    ENDIF ELSE BEGIN ;outside selection
    
      index = 0L
      IF (nbr_pixels_total GT 0) THEN BEGIN
        FOR tube=1,192L DO BEGIN
          FOR pixel=0,255L DO BEGIN
            IF (~(tube GE from_tube AND $
              tube LE to_tube AND $
              pixel GE from_pixel AND $
              pixel LE to_pixel)) THEN BEGIN
              
              bank = getBankNumber(tube)
              tube_local = getTubeLocal(tube)
              
              ;   print, 'index: ' + string(index) + ', tube: ' + string(tube) + $
              ;', pixel: ' + string(pixel) + ' -> bank: ' + string(bank)
              line = 'bank' + STRCOMPRESS(bank,/REMOVE_ALL)
              line += '_' + STRCOMPRESS(tube_local,/REMOVE_ALL)
              line += '_' + STRCOMPRESS(pixel,/REMOVE_ALL)
              pixel_array[index] = line
              index++
            ENDIF
          ENDFOR
        ENDFOR
      ENDIF
      
    ENDELSE
    
  ENDIF ELSE BEGIN ;end of (if(nbr_pixels_total GT 0))
  
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
  
  IF (N_ELEMENTS(add) NE 0) THEN BEGIN
    add_to_global_exclusion_array, event, pixel_array
  ENDIF
  
END
