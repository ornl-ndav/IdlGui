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

PRO CheckCommandline_for_jk, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;default parameters
  cmd_status               = 1      ;by default, cmd can be activated
  missing_arguments_text   = ['']   ;list of missing arguments
  missing_argument_counter = 0
  list_OF_files_to_send    = STRARR(1)
  
  ;Check first tab
  cmd = 'eqsans_reduce'
  
  ;run number
  run_number = STRCOMPRESS(getTextFieldValue(Event,$
    'reduce_jk_tab1_run_number'),/REMOVE_ALL)
  IF (run_number NE '') THEN BEGIN
    cmd += ' -r ' + run_number
  ENDIF ELSE BEGIN
    cmd += ' -r ?'
    missing_arguments_text = ['- Run Number [INPUT]']
    cmd_status = 0
    ++missing_argument_counter
  END
  
  ;OUTPUT tab =================================================================
  
  ;Root name of output file
  root_value = STRCOMPRESS(getTextFieldValue(Event,$
    'reduce_jk_tab2_root_name_extension'),/REMOVE_ALL)
  IF (root_value NE '') THEN BEGIN
    cmd += ' -o ' + root_value
  ENDIF
  
  Iq = is_this_button_selected(Event,value='Iq')
  IF (Iq EQ 0) THEN BEGIN
    cmd += ' -nosave Iq'
  ENDELSE
  
  IvQxQy = is_this_button_selected(Event,value='IvQxQy')
  IF (IvQxQy EQ 1) THEN BEGIN
    cmd += ' -save IvQxy'
  ENDIF
  
  IvXY = is_this_button_selected(Event,value='IvXY')
  IF (IvXY EQ 1) THEN BEGIN
    cmd += ' -save IvXY'
  ENDIF
  
  tof2D = is_this_button_selected(Event,value='tof2D')
  IF (tof2D EQ 1) THEN BEGIN
    cmd += ' -save tof2D'
  ENDIF
  
  tofIq = is_this_button_selected(Event,value='tofIq')
  IF (tofIq EQ 1) THEN BEGIN
    cmd += ' -save tofIq'
  ENDIF
  
  IvTof = is_this_button_selected(Event,value='IvTof')
  IF (IvTof EQ 1) THEN BEGIN
    cmd += ' -save IvTof'
  ENDIF
  
  IvWl = is_this_button_selected(Event,value='IvWl')
  IF (IvWl EQ 1) THEN BEGIN
    cmd += ' -save IvWl'
  ENDIF
  
  TvTof = is_this_button_selected(Event,value='TvTof')
  IF (TvTof EQ 1) THEN BEGIN
    cmd += ' -save TvTof'
  ENDIF
  
  TvWl = is_this_button_selected(Event,value='TvWl')
  IF (TvWl EQ 1) THEN BEGIN
    cmd += ' -save TvWl'
  ENDIF
  
  MvTof = is_this_button_selected(Event,value='MvTof')
  IF (MvTof EQ 1) THEN BEGIN
    cmd += ' -save MvTof'
  ENDIF
  
  MvWl = is_this_button_selected(Event,value='MvWl')
  IF (MvWl EQ 1) THEN BEGIN
    cmd += ' -save MvWl'
  ENDIF
  
  ;advanced part1 ============================================================
  
  ;Normalize data
  flag = get_JK_advanced_part1_normalization_flag(Event)
  IF (flag EQ 1) THEN BEGIN
    cmd += ' -nm'
  ENDIF
  
  ;sample detector
  distance = STRCOMPRESS(getTextFieldValue(Event,$
    'reduce_jk_tab3_tab1_sample_detector_distance'),/REMOVE_ALL)
  IF (distance NE '') THEN BEGIN
    cmd += ' -sdd ' + distance
  ENDIF
  
  ;sample source
  distance = STRCOMPRESS(getTextFieldValue(Event,$
    'reduce_jk_tab3_tab1_sample_source_distance'),/REMOVE_ALL)
  IF (distance NE '14.0') THEN BEGIN
    IF (distance EQ '') THEN BEGIN
      cmd += ' -s2src ?'
      missing_arguments_text = [missing_arguments_text, $
        '- Distance Sample-Source [ADVANCED/PART1]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF ELSE BEGIN
      cmd += ' -s2src ' + distance
    ENDELSE
  ENDIF
  
  ;monitor detector
  distance = STRCOMPRESS(getTextFieldValue(Event, $
    'reduce_jk_tab3_tab1_monitor_detector_distance'),/REMOVE_ALL)
  IF (distance NE '10.001') THEN BEGIN
    IF (distance EQ '') THEN BEGIN
      cmd += ' -m2src ?'
      missing_arguments_text = [missing_arguments_text, $
        '- Distance Monitor-Detector [ADVANCED/PART1]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF ELSE BEGIN
      cmd += ' -m2src ' + distance
    ENDELSE
  ENDIF
  
  ;number of pixels in x and y directions
  pixel_x = STRCOMPRESS(getTextFieldValue(Event, $
    'reduce_jk_tab3_tab1_number_of_x_pixels'),/REMOVE_ALL)
  IF (pixel_x NE '192') THEN BEGIN
    IF (pixel_x EQ '') THEN BEGIN
      cmd += ' -nx ?'
      missing_arguments_text = [missing_arguments_text, $
        '- Number of X pixels [ADVANCED/PART1]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF ELSE BEGIN
      cmd += ' -nx ' + pixel_x
    ENDELSE
  ENDIF
  
  pixel_y = STRCOMPRESS(getTextFieldValue(Event, $
    'reduce_jk_tab3_tab1_number_of_y_pixels'),/REMOVE_ALL)
  IF (pixel_y NE '256') THEN BEGIN
    IF (pixel_y EQ '') THEN BEGIN
      cmd += ' -ny ?'
      missing_arguments_text = [missing_arguments_text, $
        '- Number of Y pixels [ADVANCED/PART1]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF ELSE BEGIN
      cmd += ' -ny ' + pixel_y
    ENDELSE
  ENDIF
  
  ;detector pixels size
  xpix = STRCOMPRESS(getTextFieldValue(Event, $
    'reduce_jk_tab3_tab1_x_size'),/REMOVE_ALL)
  IF (xpix NE '5.5') THEN BEGIN
    IF (xpix EQ '') THEN BEGIN
      cmd += ' -xpix ?'
      missing_arguments_text = [missing_arguments_text, $
        '- Detector X Pixel Size [ADVANCED/PART1]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF ELSE BEGIN
      cmd += ' -xpix ' + xpix
    ENDELSE
  ENDIF
  
  ypix = STRCOMPRESS(getTextFieldValue(Event, $
    'reduce_jk_tab3_tab1_y_size'),/REMOVE_ALL)
  IF (ypix NE '4.0467') THEN BEGIN
    IF (ypix EQ '') THEN BEGIN
      cmd += ' -ypix ?'
      missing_arguments_text = [missing_arguments_text, $
        '- Detector Y Pixel Size [ADVANCED/PART1]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF ELSE BEGIN
      cmd += ' -ypix ' + ypix
    ENDELSE
  ENDIF
  
  ;Spectrum Center
  spec_value = get_JK_advanced_part1_spectrum_center_flag(Event)
  IF (spec_value EQ 1) THEN BEGIN ;yes auto find spectrum center
    cmd += ' -ac 2'
  ENDIF ELSE BEGIN
    spec_x = STRCOMPRESS(getTextFieldValue(Event, $
      'reduce_jk_tab3_tab1_spectrum_x_center'),/REMOVE_ALL)
    IF (spec_x EQ '') THEN BEGIN
      spec_x = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- X Spectrum Center [ADVANCED/PART1]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    cmd += ' -xc ' + spec_x
    
    spec_y = STRCOMPRESS(getTextFieldValue(Event, $
      'reduce_jk_tab3_tab1_spectrum_y_center'),/REMOVE_ALL)
    IF (spec_y EQ '') THEN BEGIN
      spec_y = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- Y Spectrum Center [ADVANCED/PART1]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    cmd += ' -yc ' + spec_y
  ENDELSE
  
  ;advanced part2 ============================================================
  
  
  
  
  
  ;- Put cmd in the text box -
  putCommandLine, Event, cmd
  
  ;- put list of  missing arguments
  putMissingArguments, Event, missing_arguments_text
  ;- tells how may missing arguments were found
  putMissingArgNumber, Event, missing_argument_counter
  
  ;- activate GO DATA REDUCTION BUTTON only if cmd_status is 1
  activate_go_data_reduction, Event, cmd_status
  
END
