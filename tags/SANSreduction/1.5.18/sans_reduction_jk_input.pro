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

PRO validate_or_not_get_run_information, Event

  run_number = getTextFieldValue(Event,'reduce_jk_tab1_run_number')
  IF (STRCOMPRESS(run_number,/REMOVE_ALL) EQ '') THEN BEGIN
    activate_widget, Event, 'reduce_jk_tab1_get_run_information', 0
    RETURN
  ENDIF
  
  ON_IOERROR, error
  
  fix_value = FIX(run_number)
  activate_widget, Event, 'reduce_jk_tab1_get_run_information', 1
  RETURN
  
  error:
  activate_widget, Event, 'reduce_jk_tab1_get_run_information', 0
  
END

;------------------------------------------------------------------------------
PRO jk_get_run_information, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;get run number
  run_number = STRCOMPRESS((*global).run_number,/REMOVE_ALL)
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_run_number', $
    run_number
    
  ;create default output file name
  output_file = 'EQSANS_' + run_number
  putTextFieldValue, Event, 'reduce_jk_tab2_root_name_extension', output_file
  
  cmd = (*global).eqsans_reduce + ' -r ' + run_number + ' -ri'
  WIDGET_CONTROL, /HOURGLASS
  spawn, cmd, listening
  WIDGET_CONTROL, HOURGLASS=0
  
  sz = N_ELEMENTS(listening)
  IF (sz GT 1) THEN BEGIN
  
    putTextFieldValue, Event, 'reduce_jk_tab1_run_information_text', $
      listening
    use_run_information_in_jk_gui, Event, INFO=listening
    activate_widget, Event, 'reduce_jk_tab1_run_more_infos', 1
    
  ENDIF ELSE BEGIN
  
    putTextFieldValue, Event, 'reduce_jk_tab1_run_information_text', listening
    activate_widget, Event, 'reduce_jk_tab1_run_more_infos', 0
    
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO use_run_information_in_jk_gui, Event, INFO=info

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  jk_default_value = (*global).jk_default_value
  
  ;retrieve Source rep rate
  source_rate = STRCOMPRESS(retrive_source_rate(info),/REMOVE_ALL)
  IF (source_rate NE '') THEN BEGIN
    putTextFieldValue, Event, 'reduce_jk_tab3_tab2_source_frequency', $
      source_rate
  ENDIF ELSE BEGIN
    putTextFieldValue, Event, 'reduce_jk_tab3_tab2_source_frequency', $
      jk_default_value.source_rate
  ENDELSE
  
  ;retrieve run title
  run_title = retrieve_run_title(info)
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_run_title', $
    run_title
    
  ;retrieve run notes
  run_notes = retrieve_run_notes(info)
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_run_notes', $
    run_notes
    
  ;retrieve start time
  start_time = retrieve_start_time(info)
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_start_time',$
    start_time
    
  ;retrieve total_time
  total_time = retrieve_total_time(info)
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_total_time',$
    total_time
    
  ;retrieve total acc. current
  total_current = retrieve_total_acc_current(info)
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_total_current',$
    total_current
    
  ;retrieve total detector counts
  total_counts = retrieve_total_detector_counts(info)
  putTextFieldValue, Event, $
    'reduce_jk_tab1_run_information_total_detector_counts', $
    total_counts
    
  ;retrieve total monitor counts
  total_counts = retrieve_total_monitor_counts(info)
  putTextFieldValue, Event, $
    'reduce_jk_tab1_run_information_total_monitor_counts', $
    total_counts
    
  ;retrieve wavelength_range
  wave_range_and_units = retrieve_wavelength_range(info)
  sz = N_ELEMENTS(wave_range_and_units)
  IF (sz EQ 3) THEN BEGIN
    MapBase, Event, uname='reduce_jk_tab1_run_information_wave_range2_base', 0
  ENDIF ELSE BEGIN
    MapBase, Event, uname='reduce_jk_tab1_run_information_wave_range2_base', 1
    putTextFieldValue, Event, $
      'reduce_jk_tab1_run_information_wave_range2_min',$
      wave_range_and_units[3]
    putTextFieldValue, Event, $
      'reduce_jk_tab1_run_information_wave_range2_max',$
      wave_range_and_units[4]
    putTextFieldValue, Event, $
      'reduce_jk_tab1_run_information_wave_range2_units',$
      wave_range_and_units[5]
  ENDELSE
  putTextFieldValue, Event, $
    'reduce_jk_tab1_run_information_wave_range_min',$
    wave_range_and_units[0]
  putTextFieldValue, Event, $
    'reduce_jk_tab1_run_information_wave_range_max',$
    wave_range_and_units[1]
  putTextFieldValue, Event, $
    'reduce_jk_tab1_run_information_wave_range_units',$
    wave_range_and_units[2]
    
  ;retrieve sample detector
  sample_detector_array = retrieve_sample_detector_distance(info)
  sample_detector = STRCOMPRESS(sample_detector_array[0],/REMOVE_ALL)
  sample_detector_with_units = STRCOMPRESS(sample_detector_array[1])
  IF (sample_detector EQ '') THEN BEGIN
    sample_detector = jk_default_value.sample_detector
    sample_detector_with_units = jk_default_value.sample_detector_with_units
  ENDIF
  putTextFieldValue, Event, 'reduce_jk_tab3_tab1_sample_detector_distance', $
    sample_detector
  ;put value in top box
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_sample_detector', $
    sample_detector_with_units
    
  ;retrieve sample source
  sample_source = STRCOMPRESS(retrieve_sample_source_distance(info),$
    /REMOVE_ALL)
  IF (sample_source EQ '') THEN BEGIN
    sample_source = jk_default_value.sample_source
  ENDIF
  putTextFieldValue, Event, 'reduce_jk_tab3_tab1_sample_source_distance', $
    sample_source
    
  ;retrieve number of pixels in X and Y directions
  x_y = retrieve_number_of_pixels(info)
  IF (x_y[0] NE '') THEN BEGIN
    X = STRCOMPRESS(x_y[0],/REMOVE_ALL)
    Y = STRCOMPRESS(x_y[1],/REMOVE_ALL)
    putTextFieldValue, Event, 'reduce_jk_tab3_tab1_number_of_x_pixels', X
    putTextFieldValue, Event, 'reduce_jk_tab3_tab1_number_of_y_pixels', Y
  ENDIF ELSE BEGIN
    putTextFieldValue, Event, 'reduce_jk_tab3_tab1_number_of_x_pixels', $
      jk_default_value.number_of_pixels.x
    putTextFieldValue, Event, 'reduce_jk_tab3_tab1_number_of_y_pixels', $
      jk_default_value.number_of_pixels.y
  ENDELSE
  
  ;retrieve pixel size in X and Y directions
  x_y = retrieve_pixels_size(info)
  IF (x_y[0] NE '') THEN BEGIN
    X = STRCOMPRESS(x_y[0],/REMOVE_ALL)
    Y = STRCOMPRESS(x_y[1],/REMOVE_ALL)
    putTextFieldValue, Event, 'reduce_jk_tab3_tab1_x_size', X
    putTextFieldValue, Event, 'reduce_jk_tab3_tab1_y_size', Y
  ENDIF ELSE BEGIN
    putTextFieldValue, Event, 'reduce_jk_tab3_tab1_x_size', $
      jk_default_value.pixels_size.x
    putTextFieldValue, Event, 'reduce_jk_tab3_tab1_y_size', $
      jk_default_value.pixels_size.y
  ENDELSE
  
  ;get Monitor-detector distance
  ;retrieve monitor to source
  monitor_source = STRCOMPRESS(retrieve_monitor_source_distance(info),$
    /REMOVE_ALL)
  IF (monitor_source EQ '') THEN BEGIN
    monitor_source = jk_default_value.monitor_source
  ENDIF
  ;retrieve detector_source
  detector_source = STRCOMPRESS(retrieve_detector_source_distance(info),$
    /REMOVE_ALL)
  IF (detector_source EQ '') THEN BEGIN
    detector_source = jk_default_value.detector_source
  ENDIF
  IF (monitor_source NE '' AND detector_source NE '') THEN BEGIN
    dMS = FLOAT(monitor_source)
    dDS = FLOAT(detector_source)
    monitor_detector = STRCOMPRESS(dDS - dMS,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    monitor_detector = jk_default_value.monitor_detector
  ENDELSE
  putTextFieldValue, Event, 'reduce_jk_tab3_tab1_monitor_detector_distance', $
    monitor_detector
    
END

;------------------------------------------------------------------------------
;Output path
PRO jk_tab2_output_button, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  output_path = (*global).output_path
  title = 'Select where you want to write the output file(s):'
  widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  
  result = DIALOG_PICKFILE(DIALOG_PARENT=widget_id,$
    /DIRECTORY,$
    /MUST_EXIST,$
    PATH=output_path,$
    
    TITLE = title)
    
  IF (result NE '') THEN BEGIN
    (*global).output_path = result
    putNewButtonValue, Event, 'reduce_jk_tab2_output_folder_button', result
    CheckCommandline_for_jk, Event
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO clear_jk_information_base, Event

  text = 'N/A'
  
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_run_title', $
    text
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_run_notes', $
    text
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_start_time',$
    text
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_total_time',$
    text
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_total_current',$
    text
  putTextFieldValue, Event, $
    'reduce_jk_tab1_run_information_total_detector_counts', $
    text
  putTextFieldValue, Event, $
    'reduce_jk_tab1_run_information_total_monitor_counts', $
    text
  putTextFieldValue, Event, $
    'reduce_jk_tab1_run_information_wave_range_min',$
    text
  putTextFieldValue, Event, $
    'reduce_jk_tab1_run_information_wave_range_max',$
    text
  putTextFieldValue, Event, $
    'reduce_jk_tab1_run_information_wave_range_units',$
    text
  putTextFieldValue, Event, 'reduce_jk_tab3_tab1_sample_detector_distance', $
    text
  putTextFieldValue, Event, 'reduce_jk_tab1_run_information_sample_detector', $
    text
  putTextFieldValue, Event, 'reduce_jk_tab3_tab1_sample_source_distance', $
    text
  putTextFieldValue, Event, 'reduce_jk_tab3_tab1_number_of_x_pixels', text
  putTextFieldValue, Event, 'reduce_jk_tab3_tab1_number_of_y_pixels', text
  putTextFieldValue, Event, 'reduce_jk_tab3_tab1_x_size', text
  putTextFieldValue, Event, 'reduce_jk_tab3_tab1_y_size', text
  putTextFieldValue, Event, 'reduce_jk_tab3_tab1_monitor_detector_distance', $
    text
    
END