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

  IF (N_ELEMENTS(mode) EQ 0) THEN mode='button3_on'
  
  path = 'SANSreduction_images/'
  button3 = path + ['cursor_plot_on', $
    'cursor_plot_off'] + '.png'
  button1 = path + ['beam_stop_on', $
    'beam_stop_off'] + '.png'
  button2 = path + ['calculation_range_on', $
    'calculation_range_off'] + '.png'
    
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
    'off': BEGIN
      button1_png = button1[1]
      button2_png = button2[1]
      button3_png = button3[1]
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
    STRCOMPRESS(pixel_max,/REMOVE_ALL)
    
  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_beam_stop_pixel_right', $
    STRCOMPRESS(pixel_min,/REMOVE_ALL)
    
;  ;Calculation range
;  tube  = (*global).calculation_range_default.tube
;  pixel = (*global).calculation_range_default.pixel
;  
;  putTextFieldValueMainBase, wBase, $
;    UNAME='beam_center_2d_plot_tube', $
;    STRCOMPRESS(tube,/REMOVE_ALL)
;    
;  putTextFieldValueMainBase, wBase, $
;    UNAME='beam_center_2d_plot_pixel', $
;    STRCOMPRESS(pixel,/REMOVE_ALL)

  ;Calculation Range
  tube1 = (*global).calculation_range_default.tube1
  tube2 = (*global).calculation_range_default.tube2
  pixel1 = (*global).calculation_range_default.pixel1
  pixel2 = (*global).calculation_range_default.pixel2
  
  stube_min = STRCOMPRESS(tube1,/REMOVE_ALL)
  stube_max = STRCOMPRESS(tube2,/REMOVE_ALL)
  spixel_min = STRCOMPRESS(pixel1,/REMOVE_ALL)
  spixel_max = STRCOMPRESS(pixel2,/REMOVE_ALL)
  
  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_calculation_range_tube_left', stube_min
    
  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_calculation_range_tube_right', stube_max
    
  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_calculation_range_pixel_left', spixel_max
    
  putTextFieldValueMainBase, wBase, $
    UNAME='beam_center_calculation_range_pixel_right', spixel_min
    
        
END

;------------------------------------------------------------------------------
PRO display_beam_center_tab2_buttons, Event, MODE=mode

  path = 'SANSreduction_images/'
  tube1 = path + ['tube1_on',$
    'tube1_off'] + '.png'
  tube2 = path + ['tube2_on',$
    'tube2_off'] + '.png'
  pixel1 = path + ['pixel1_on',$
    'pixel1_off'] + '.png'
  pixel2 = path + ['pixel2_on',$
    'pixel2_off'] + '.png'
    
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  IF (N_ELEMENTS(MODE) EQ 0) THEN BEGIN
    mode = (*global).calculation_range_tab_mode
  ENDIF ELSE BEGIN
    (*global).calculation_range_tab_mode = mode
  ENDELSE
  
  CASE (mode) OF
    'tube1': BEGIN
      tube1_button = READ_PNG(tube1[0])
      tube2_button = READ_PNG(tube2[1])
      pixel1_button = READ_PNG(pixel1[1])
      pixel2_button = READ_PNG(pixel2[1])
    END
    'tube2': BEGIN
      tube1_button = READ_PNG(tube1[1])
      tube2_button = READ_PNG(tube2[0])
      pixel1_button = READ_PNG(pixel1[1])
      pixel2_button = READ_PNG(pixel2[1])
    END
    'pixel1': BEGIN
      tube1_button = READ_PNG(tube1[1])
      tube2_button = READ_PNG(tube2[1])
      pixel1_button = READ_PNG(pixel1[0])
      pixel2_button = READ_PNG(pixel2[1])
    END
    'pixel2': BEGIN
      tube1_button = READ_PNG(tube1[1])
      tube2_button = READ_PNG(tube2[1])
      pixel1_button = READ_PNG(pixel1[1])
      pixel2_button = READ_PNG(pixel2[0])
    END
  ENDCASE
  
  tube1_uname = 'tube1_button_uname'
  mode_id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME=tube1_uname)
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, tube1_button, 0, 0,/true
  
  tube2_uname = 'tube2_button_uname'
  mode_id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME=tube2_uname)
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, tube2_button, 0, 0,/true
  
  pixel1_uname = 'pixel1_button_uname'
  mode_id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME=pixel1_uname)
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, pixel1_button, 0, 0,/true
  
  pixel2_uname = 'pixel2_button_uname'
  mode_id = WIDGET_INFO(Event.top, $
    FIND_BY_UNAME=pixel2_uname)
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, pixel2_button, 0, 0,/true
  
END

;------------------------------------------------------------------------------
PRO switch_calculation_range_button, Event, WAY=way

  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  mode = (*global).calculation_range_tab_mode
  
  CASE (mode) OF
    'tube1': BEGIN
      IF (WAY EQ 'forward') THEN BEGIN
        mode = 'tube2'
      ENDIF ELSE BEGIN
        mode = 'pixel2'
      ENDELSE
    END
    'tube2': BEGIN
      IF (WAY EQ 'forward') THEN BEGIN
        mode = 'pixel1'
      ENDIF ELSE BEGIN
        mode = 'tube1'
      ENDELSE
    END
    'pixel1': BEGIN
      IF (WAY EQ 'forward') THEN BEGIN
        mode = 'pixel2'
      ENDIF ELSE BEGIN
        mode = 'tube2'
      ENDELSE
    END
    'pixel2': BEGIN
      IF (WAY EQ 'forward') THEN BEGIN
        mode = 'tube1'
      ENDIF ELSE BEGIN
        mode = 'pixel1'
      ENDELSE
    END
  ENDCASE
  
  display_beam_center_tab2_buttons, Event, MODE=mode
  
END