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
  cmd = (*global).eqsans_reduce_mpi
  
  ;run number
  run_number = STRCOMPRESS((*global).run_number,/REMOVE_ALL)
  IF (run_number NE '') THEN BEGIN
    cmd += ' -r ' + run_number
  ENDIF ELSE BEGIN
    cmd += ' -r ?'
    missing_arguments_text = ['- Run Number [LOAD DATA']
    cmd_status = 0
    ++missing_argument_counter
  END
  
  ;OUTPUT tab =================================================================
  
  ;Root name of output file
  root_value = STRCOMPRESS(getTextFieldValue(Event,$
    'reduce_jk_tab2_root_name_extension'),/REMOVE_ALL)
  output_path = STRCOMPRESS(getButtonValue(Event,$
    'reduce_jk_tab2_output_folder_button'),/REMOVE_ALL)
  IF (root_value NE '') THEN BEGIN
    cmd += ' -o ' + output_path + root_value
  ENDIF ELSE BEGIN
    missing_arguments_text = ['- Output File Name [OUTPUT]']
    cmd_status = 0
    ++missing_argument_counter
    cmd += ' -o ' + output_path + '?'
  ENDELSE
  
  Iq = is_this_button_selected(Event,value='Iq')
  IF (Iq EQ 0) THEN BEGIN
    cmd += ' -nosave Iq'
  ENDIF
  
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
  
  IF (isJkSliceDataSelected(Event)) THEN BEGIN ;check tbIq and tb2D flags
    tbIq = is_this_button_selected(Event,value='tbIq')
    IF (tbIq EQ 1) THEN BEGIN
      cmd += ' -save tbIq'
    ENDIF
    tb2D = is_this_button_selected(Event,value='tb2D')
    IF (tb2D EQ 1) THEN BEGIN
      cmd += ' -save tb2D'
    ENDIF
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
  
  ;Dark current/Blocked
  dark_current = STRCOMPRESS(getTextFieldValue(Event, $
    'reduce_jk_tab3_tab1_dark_current'),/REMOVE_ALL)
  IF (dark_current NE '') THEN BEGIN
    cmd += ' -dc ' + dark_current
  ENDIF
  
  ;Vanadium
  vanadium = STRCOMPRESS(getTextFieldValue(Event, $
    'reduce_jk_tab3_tab1_vanadium'),/REMOVE_ALL)
  IF (vanadium NE '') THEN BEGIN
    cmd += ' -van ' + vanadium
  ENDIF
  
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
  
  ;correction for source spectrum using transmission at the center
  IF (~is_correction_for_source_spectrum(Event)) THEN BEGIN
    cmd += ' -ssc 0'
  ENDIF
  
  ;correction for Q-coverage difference for different wavelength neutrons
  IF (~is_correction_for_Q_coverage(Event)) THEN BEGIN
    cmd += ' -qcc 0'
  ENDIF
  
  ;Transmission
  IF (is_auto_find_transmission(Event)) THEN BEGIN
    cmd += ' -at'
  ENDIF ELSE BEGIN
    x_axis = STRCOMPRESS(getTextFieldValue(Event,$
      'reduce_jk_tab3_tab1_transmission_x_axis'),/REMOVE_ALL)
    IF (x_axis EQ '') THEN BEGIN
      x_axis = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- x-axis value of Transmission [ADVANCED/PART2]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    cmd += ' -nxt ' + x_axis
    
    y_axis = STRCOMPRESS(getTextFieldValue(Event,$
      'reduce_jk_tab3_tab1_transmission_y_axis'),/REMOVE_ALL)
    IF (y_axis EQ '') THEN BEGIN
      y_axis = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- y-axis value of Transmission [ADVANCED/PART2]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    cmd += ' -nyt ' + y_axis
  ENDELSE
  
  ;Number of time channel slices
  nbr_time_channel = STRCOMPRESS(getTextFieldValue(Event,$
    'reduce_jk_tab3_tab1_number_time_channel'),/REMOVE_ALL)
  IF (nbr_time_channel NE '400') THEN BEGIN
    IF (nbr_time_channel EQ '') THEN BEGIN
      nbr_time_channel = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- Number of Time Channel [ADVANCED/PART2]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    cmd += ' -ntof ' + nbr_time_channel
  ENDIF
  
  ;source frequency
  src_freq = STRCOMPRESS(getTextFieldValue(Event, $
    'reduce_jk_tab3_tab2_source_frequency'),/REMOVE_ALL)
  IF (src_freq NE '60') THEN BEGIN
    IF (src_freq EQ '') THEN BEGIN
      src_freq = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- Source Frequency [ADVANCED/PART2]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    cmd += ' -rep ' + src_freq
  ENDIF
  
  ;frame tof offset
  tof_offset = STRCOMPRESS(getTextFieldValue(Event, $
    'reduce_jk_tab3_tab2_tof_offset'),/REMOVE_ALL)
  IF (tof_offset NE '0') THEN BEGIN
    IF (tof_offset EQ '') THEN BEGIN
      tof_offset = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- Frame TOF offset [ADVANCED/PART2]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    cmd += ' -tof0 ' + tof_offset
  ENDIF
  
  ;Half width of the proton pulse to be excluded
  width = STRCOMPRESS(getTextFieldValue(Event, $
    'reduce_jk_tab3_tab2_width'),/REMOVE_ALL)
  IF (width NE '0') THEN BEGIN
    IF (width EQ '') THEN BEGIN
      width = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- Half Width of Proton Pulse [ADVANCED/PART2]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    cmd += ' -pphw ' + width
  ENDIF
  
  ;Discard data at the beginning and end of a frame
  discard_beg = STRCOMPRESS(getTextFieldValue(Event, $
    'reduce_jk_tab3_tab2_discard_data_beginning'),/REMOVE_ALL)
  discard_end = STRCOMPRESS(getTextFieldValue(Event, $
    'reduce_jk_tab3_tab2_discard_data_end'),/REMOVE_ALL)
  IF (discard_beg NE '0' OR discard_end NE '0') THEN BEGIN
    IF (discard_beg EQ '') THEN BEGIN
      discard_beg = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- Discard data at the beginning of a frame [ADVANCED/PART2]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    IF (discard_end EQ '') THEN BEGIN
      discard_end = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- Discard data at the end of a frame [ADVANCED/PART2]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    us_flag = is_discard_value_in_us_selected(Event)
    IF (us_flag) THEN BEGIN
      cmd += ' -tofcut ' + discard_beg + ' ' + discard_end
    ENDIF ELSE BEGIN
      cmd += ' -wlcut ' + discard_beg + ' ' + discard_end
    ENDELSE
  ENDIF
  
  ;Frame wavelength
  frame_value = STRCOMPRESS(getTextFieldValue(Event,$
    'reduce_jk_tab3_tab2_frame_wavelength'),/REMOVE_ALL)
  IF (frame_value NE '0') THEN BEGIN
    IF (frame_value EQ '') THEN BEGIN
      frame_value = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- Frame Wavelength offset [ADVANCED/PART2]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    cmd += ' -wl0 ' + frame_value
  ENDIF
  
  ;slice data
  IF (isJkSliceDataSelected(Event)) THEN BEGIN
    value1 = STRCOMPRESS(getTextFieldValue(Event,$
      'reduce_jk_tab3_tab2_slice_value1'),/REMOVE_ALL)
    value2 = STRCOMPRESS(getTextFieldValue(Event,$
      'reduce_jk_tab3_tab2_slice_value2'),/REMOVE_ALL)
    value3 = STRCOMPRESS(getTextFieldValue(Event,$
      'reduce_jk_tab3_tab2_slice_value3'),/REMOVE_ALL)
    IF (isJkSliceTimeSelected(Event)) THEN BEGIN ;time
      type = 't'
      cmd += ' -timebin'
    ENDIF ELSE BEGIN ;pulse
      type = 'p'
      cmd += ' -pulsebin'
    ENDELSE
    
    IF (value1 EQ '') THEN BEGIN
      value1 = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- Missing ' + type + '1 value in Slice Data [ADVANCED/PART2]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    cmd += ' ' + value1
    
    IF (value2 EQ '') THEN BEGIN
      value2 = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- Missing ' + type + '2 value in Slice Data [ADVANCED/PART2]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    cmd += ' ' + value2
    
    IF (value3 EQ '') THEN BEGIN
      value3 = '?'
      missing_arguments_text = [missing_arguments_text, $
        '- Missing ' + type + ' step in Slice Data [ADVANCED/PART2]']
      cmd_status = 0
      ++missing_argument_counter
    ENDIF
    cmd += ' ' + value3
    
  ENDIF
  
  ;add ROI
  
  ;rectangles
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
      cmd += ' -rmask ' + x0 + ' ' + y0 + ' ' + x1 + ' ' + y1
      index++
    ENDWHILE
  ENDIF
  
  ;circular
  jk_selection = (*(*global).jk_selection_xyr)
  nbr = N_ELEMENTS(jk_selection)
  IF (nbr GT 1) THEN BEGIN
    nbr_iteration = nbr/3
    index = 0
    WHILE (index LT nbr_iteration) DO BEGIN
      x = STRCOMPRESS(FIX(jk_selection[index*3]),/REMOVE_ALL)
      y = STRCOMPRESS(FIX(jk_selection[index*3+1]),/REMOVE_ALL)
      r = STRCOMPRESS(jk_selection[index*3+2],/REMOVE_ALL)
      cmd += ' -cmask ' + x + ' ' + y + ' ' + r
      index++
    ENDWHILE
  ENDIF
  
  ;sector
  jk_selection = (*(*global).jk_selection_sector)
  nbr = N_ELEMENTS(jk_selection)
  IF (nbr GT 1) THEN BEGIN
    nbr_iteration = nbr/2
    index = 0
    WHILE (index LT nbr_iteration) DO BEGIN
      angle_min = STRCOMPRESS(FIX(jk_selection[index*2]),/REMOVE_ALL)
      angle_max = STRCOMPRESS(FIX(jk_selection[index*2+1]),/REMOVE_ALL)
      cmd += ' -pie ' + angle_min + ' ' + angle_max
      index++
    ENDWHILE
  ENDIF
  
  ;- Put cmd in the text box -
  putCommandLine, Event, cmd
  
  ;- put list of  missing arguments
  putMissingArguments, Event, missing_arguments_text
  ;- tells how may missing arguments were found
  putMissingArgNumber, Event, missing_argument_counter
  
  ;- activate GO DATA REDUCTION BUTTON only if cmd_status is 1
  activate_go_data_reduction, Event, cmd_status
  
END
