;================================= =============================================
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

;This procedure will create the temporary geometry file using the
;beam center pixel and tube offset calculated by the program
PRO create_tmp_geometry, Event

  ;retrieve beam center tube and pixel calculated
  bc_tube  = FLOAT(getTextFieldValue(Event,'beam_center_tube_center_value'))
  bc_pixel = FLOAT(getTextFieldValue(Event,'beam_center_pixel_center_value'))
  
  ;Determine pixel offset
  default_bc_pixel = 255./2. ;value of default pixel beam center
  bc_pixel_offset = bc_pixel - default_bc_pixel ;pixel offset (pixel)
  pixel_size = 1.1/256. ;pixel size (m)
  bc_pixel_offset_distance_m = pixel_size * bc_pixel_offset ;pixel offset (m)
  
  ;Determine tube offset
  default_bc_tube = 97. ;value of default tube beam center
  bc_tube_offset = bc_tube - default_bc_tube ;tube offset (tube)
  tube_front_size = 0.0079 ;front tube size (m)
  tube_back_size  = 0.0031 ;back tube size (m)
  
  bc_tube_offset_distance_m = 0
  IF (bc_tube_offset LT 0) THEN BEGIN ;tube center is on the left of default
    WHILE (bc_tube_offset LT -1) DO BEGIN
      decimal_part = FIX(bc_tube_offset)
      IF ((decimal_part MOD 2) EQ 0) THEN BEGIN ;even number (means front tube)
        bc_tube_offset_distance_m -= tube_front_size
        type = 'last state was front'
      ENDIF ELSE BEGIN ;odd number (means back tube)
        bc_tube_offset_distance_m -= tube_back_size
        type = 'last state was back'
      ENDELSE
      bc_tube_offset++
    ENDWHILE
    CASE (type) OF
      'last state was front': BEGIN
        bc_tube_offset_distance_m += bc_tube_offset * tube_back_size
      END
      'last state was back': BEGIN
        bc_tube_offset_distance_m += bc_tube_offset * tube_front_size
      END
    ENDCASE
  ENDIF ;end of if (bc_tube_offset LT 0)
  
  IF (bc_tube_offset GT 0) THEN BEGIN ;tube center is on the right of default
    WHILE (bc_tube_offset GT 1) DO BEGIN
      decimal_part = FIX(bc_tube_offset)
      IF ((decimal_part MOD 2) EQ 1) THEN BEGIN ;odd number (means front tube)
        bc_tube_offset_distance_m += tube_front_size
        type = 'front'
      ENDIF ELSE BEGIN ;even number (means back tube)
        bc_tube_offset_distance_m += tube_back_size
        type = 'back'
      ENDELSE
      bc_tube_offset--
    ENDWHILE
    CASE (type) OF
      'front': bc_tube_offset_distance_m += bc_tube_offset * tube_back_size
      'back':  bc_tube_offset_distance_m += bc_tube_offset * tube_front_size
    ENDCASE
  ENDIF
  
;  print, 'bc_pixel_offset_distance_m: ' + string(bc_pixel_offset_distance_m)
;  print, 'bc_tube_offset_distance_m: ' + string(bc_tube_offset_distance_m)
  
END