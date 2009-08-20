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

PRO display_beam_stop_images, main_base=main_base, mode=mode, Event=event

  IF (N_ELEMENTS(mode) EQ 0) THEN mode='button1_on'
  
  path = 'SANSreduction_images/'
  button1 = path + ['calibration_range_on', $
    'calibration_range_off'] + '.png'
  button2 = path + ['beam_stop_on', $
    'beam_stop_off'] + '.png'
  button3 = path + ['twoD_plots_on', $
    'twoD_plots_off'] + '.png'
    
  CASE (mode) OF
    'button1_on': BEGIN
      button1_png = button1[0]
      button2_png = button2[1]
      button3_png = button3[1]
    END
    'button2_on': BEGIN
      button1_png = button1[1]
      button2_png = button2[0]
      button3_png = button3[1]
    END
    'button3_on': BEGIN
      button1_png = button1[1]
      button2_png = button2[1]
      button3_png = button3[0]
    END
  ENDCASE
  
  cali_button = READ_PNG(button1_png)
  beam_button = READ_PNG(button2_png)
  twoD_button = READ_PNG(button3_png)
  
  button1_uname = 'beam_center_button1'
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, $
      FIND_BY_UNAME=button1_uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME=button1_uname)
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, cali_button, 0, 0,/true
  
  button2_uname = 'beam_center_button2'
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, $
      FIND_BY_UNAME=button2_uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME=button2_uname)
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, beam_button, 0, 0,/true
  
  button3_uname = 'beam_center_button3'
  IF (N_ELEMENTS(main_base) NE 0) THEN BEGIN
    mode_id = WIDGET_INFO(main_base, $
      FIND_BY_UNAME=button3_uname)
  ENDIF ELSE BEGIN
    mode_id = WIDGET_INFO(Event.top, $
      FIND_BY_UNAME=button3_uname)
  ENDELSE
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, twoD_button, 0, 0,/true
  
END

;------------------------------------------------------------------------------
PRO populate_defaults_wigets_values, wBase, global

  ;Calculation Range
  tube_min = (*global).calibration_range_default_selection.tube_min
  tube_max = (*global).calibration_range_default_selection.tube_max
  pixel_min = (*global).calibration_range_default_selection.pixel_min
  pixel_max = (*global).calibration_range_default_selection.pixel_max
  
  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_calculation_tube_left', $
    STRCOMPRESS(tube_min,/REMOVE_ALL)
    
  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_calculation_tube_right', $
    STRCOMPRESS(tube_max,/REMOVE_ALL)

  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_calculation_pixel_left', $
    STRCOMPRESS(pixel_min,/REMOVE_ALL)

  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_calculation_pixel_right', $
    STRCOMPRESS(pixel_max,/REMOVE_ALL)

  ;Beam Stop Region
  tube_min = (*global).beam_stop_default_selection.tube_min
  tube_max = (*global).beam_stop_default_selection.tube_max
  pixel_min = (*global).beam_stop_default_selection.pixel_min
  pixel_max = (*global).beam_stop_default_selection.pixel_max
  
  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_beam_stop_tube_left', $
    STRCOMPRESS(tube_min,/REMOVE_ALL)

  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_beam_stop_tube_right', $
    STRCOMPRESS(tube_max,/REMOVE_ALL)

  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_beam_stop_pixel_left', $
    STRCOMPRESS(pixel_min,/REMOVE_ALL)

  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_beam_stop_pixel_right', $
    STRCOMPRESS(pixel_max,/REMOVE_ALL)
    
END

