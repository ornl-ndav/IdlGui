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
PRO Add_file_to_lis_OF_files, list_OF_files_to_send, new_file
  IF (list_OF_files_to_send[0] EQ '') THEN BEGIN
    list_OF_files_to_send[0] = new_file
  ENDIF ELSE BEGIN
    list_OF_files_to_send = [list_OF_files_to_send, new_file]
  ENDELSE
END

;------------------------------------------------------------------------------
FUNCTION getBmonPath, event, file
  ;get global structure
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  bmon_path = (*global).beam_monitor_data_path
  bmon_path_value = (*global).beam_monitor_flag
  no_error = 0
  CATCH, no_error
  IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, bmon_path_value[1]
  ENDIF ELSE BEGIN
    fileID = H5F_OPEN(file)
    pathID = H5D_OPEN(fileID, bmon_path[0])
    RETURN, bmon_path_value[0]
  ENDELSE
END

;------------------------------------------------------------------------------
PRO CheckCommandLine, Event
  ;get global structure
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL, id, GET_UVALUE=global
  
  ;default parameters
  cmd_status               = 1      ;by default, cmd can be activated
  missing_arguments_text   = ['']   ;list of missing arguments
  missing_argument_counter = 0
  list_OF_files_to_send    = STRARR(1)
  
  ;Check first tab
  IF (getCWBgroupValue(Event,'mode_group_uname') EQ 0) THEN BEGIN
    ;transmission mode
    cmd = (*global).ReducePara.transmission_driver_name ;driver to launch
  ENDIF ELSE BEGIN ;background mode
    cmd = (*global).ReducePara.background_driver_name ;driver to launch
  ENDELSE
  
  ;- LOAD FILES TAB -------------------------------------------------------------
  
  ;-Data File-
  file_run = getTextFieldValue(Event,'data_file_name_text_field')
  IF (file_run NE '' AND $
    FILE_TEST(file_run,/REGULAR)) THEN BEGIN
    cmd += ' ' + file_run
  ENDIF ELSE BEGIN
    cmd += ' ?'
    missing_arguments_text = ['- Valid Data File (LOAD FILES)']
    cmd_status = 0
    ++missing_argument_counter
    
  END
  
  ;-facility and instrument flags
  cmd += ' ' + (*global).facility_flag
  facility_list = (*global).facility_list
  cmd += '=' + facility_list[0]
  
  cmd +=  ' ' + (*global).instrument_flag
  instrument_list = (*global).instrument_list
  cmd += '=' + instrument_list[0]
  
  IF (getCWBgroupValue(Event,'mode_group_uname') EQ 0) THEN BEGIN
    ;transmission mode
    ;get monitor path
    cmd += ' --bmon-path='
    IF (file_run EQ '') THEN BEGIN
      cmd += '?'
    ENDIF ElSE BEGIN
      path = getBmonPath(Event, file_run)
      cmd += path
    ENDELSE
  ENDIF
  
  ;-ROI File-
  file_run = getTextFieldValue(Event,'roi_file_name_text_field')
  IF (file_run NE '' AND $
    FILE_TEST(file_run,/REGULAR)) THEN BEGIN
    flag = (*global).CorrectPara.roi.flag
    cmd += ' ' + flag + '=' + file_run
    Add_file_to_lis_OF_files, list_OF_files_to_send, file_run
  ENDIF
  
  ;Check first tab (check only if transmission mode is used)
  IF (getCWBgroupValue(Event,'mode_group_uname') EQ 0) THEN BEGIN
    ;-Transmission Background-
    file_run = getTextFieldValue(Event,'transm_back_file_name_text_field')
    IF (file_run NE '' AND $
      FILE_TEST(file_run,/REGULAR)) THEN BEGIN
      flag = (*global).CorrectPara.transm_back.flag
      cmd += ' ' + flag + '=' + file_run
      Add_file_to_lis_OF_files, list_OF_files_to_send, file_run
    ENDIF
  ENDIF
  
  ;-Output Path-
  output_path = getButtonValue(Event,'output_folder')
  cmd += ' --output='
  IF (FILE_TEST(output_path,/DIRECTORY)) THEN BEGIN
    cmd += output_path
  ENDIF ELSE BEGIN
    cmd += '?'
    ++missing_argument_counter
    missing_arguments_text = [missing_arguments_text, $
      '- Select an existing outupt folder' + $
      ' (LOAD FILES)']
  ENDELSE
  
  ;-Output File-
  output_file = getTextfieldValue(Event, 'output_file_name')
  IF (output_file NE '') THEN BEGIN
    cmd += output_file
  ENDIF ELSE BEGIN
    cmd += '?'
    ++missing_argument_counter
    missing_arguments_text = [missing_arguments_text, $
      '- Define an ouput file name' + $
      ' (LOAD FILES)']
  ENDELSE
  
  (*global).current_output_file_name   = output_path + output_file
  (*global).short_data_nexus_file_name = output_file
  (*global).path_data_nexus_file       = output_path
  
  ;- PARAMETERS  ----------------------------------------------------------------
  
  ;-geometry file to overwrite
  IF (getCWBgroupValue(Event,'overwrite_geometry_group') EQ 0) THEN BEGIN
    cmd += ' --inst-geom='
    IF ((*global).inst_geom NE '') THEN BEGIN
      cmd += (*global).inst_geom
    ENDIF ELSE BEGIN
      cmd += '?'
      cmd_status = 0
      ++missing_argument_counter
      missing_arguments_text = [missing_arguments_text, $
        '- Instrument' + $
        ' Geometry File (LOAD FILES)']
    ENDELSE
  ENDIF
  
  IF (getCWBgroupValue(Event,'mode_group_uname') EQ 0) THEN BEGIN
  
    ;-check if Transmission Background is there or not
    file_run = getTextFieldValue(Event,'transm_back_file_name_text_field')
    IF (file_run EQ '') THEN BEGIN
    
      uname_list = ['monitor_efficiency_title',$
        'monitor_efficiency_base',$
        'detector_efficiency_base',$
        'detector_efficiency_title']
      activate_widget_list, Event, uname_list, 1
      
      ;-detector efficiency
      IF (getCWBgroupValue(Event, 'detector_efficiency_group') EQ 0) THEN BEGIN
      
        activate_intermediate_base = 0
        cmd += ' ' + (*global).ReducePara.detector_efficiency.flag
        
        cmd += ' ' + (*global).ReducePara.detector_efficiency_scale + '='
        value = getTextFieldValue(Event, 'detector_efficiency_scaling_value')
        IF (value NE '') THEN BEGIN
          cmd += STRCOMPRESS(value,/REMOVE_ALL)
          cmd += ',0.0'
        ENDIF ELSE BEGIN
          cmd += '?,0.0'
          cmd_status = 0
          ++missing_argument_counter
          missing_arguments_text = [missing_arguments_text, $
            '- Scaling Detector Efficiency Value ' + $
            '(PARAMETERS)']
        ENDELSE
        
        cmd += ' ' + (*global).ReducePara.detector_efficiency_attenuator + '='
        value = getTextFieldValue(Event, 'detector_efficiency_attenuator_value')
        IF (value NE '') THEN BEGIN
          cmd += STRCOMPRESS(value,/REMOVE_ALL)
          cmd += ',0.0'
        ENDIF ELSE BEGIN
          cmd += '?,0.0'
          cmd_status = 0
          ++missing_argument_counter
          missing_arguments_text = [missing_arguments_text, $
            '- Attenuator Detector Efficiency Value ' + $
            '(PARAMETERS)']
        ENDELSE
        
        ;-monitor efficiency
        IF (getCWBgroupValue(Event, 'monitor_efficiency_group') EQ 0) THEN BEGIN
          activate_intermediate_base = 0
          cmd += ' ' + (*global).ReducePara.monitor_efficiency.flag
          cmd += ' ' + (*global).ReducePara.monitor_efficiency_constant + '='
          value = getTextFieldValue(Event, 'monitor_efficiency_constant_value')
          IF (value NE '') THEN BEGIN
            cmd += STRCOMPRESS(value,/REMOVE_ALL)
            cmd += ',0.0'
          ENDIF ELSE BEGIN
            cmd += '?,0.0'
            cmd_status = 0
            ++missing_argument_counter
            missing_arguments_text = [missing_arguments_text, $
              '- Monitor Efficiency Value ' + $
              '(PARAMETERS)']
          ENDELSE
        ENDIF ELSE BEGIN
          activate_intermediate_base = 1
        ENDELSE
        map_base, Event, 'beam_monitor_hidding_base', activate_intermediate_base
        
      ENDIF ELSE BEGIN
        activate_intermediate_base = 1
      ENDELSE
      
    ENDIF ELSE BEGIN ;file_run NE ''
    
      uname_list = ['monitor_efficiency_title',$
        'monitor_efficiency_base',$
        'detector_efficiency_base',$
        'detector_efficiency_title']
      activate_widget_list, Event, uname_list, 0
      
    ENDELSE
    
  ENDIF
  
  ;-time offsets of detector and beam monitor
  detectorTO = getTextFieldValue(Event,'time_zero_offset_detector_uname')
  cmd += ' ' + (*global).ReducePara.detect_time_offset + '='
  IF (detectorTO NE '') THEN BEGIN
    cmd += detectorTO + ',0'
  ENDIF ELSE BEGIN
    cmd += '?'
    cmd_status = 0
    ++missing_argument_counter
    missing_arguments_text = [missing_arguments_text, $
      '- Detector Offset ' + $
      '(PARAMETERS)']
  ENDELSE
  
  IF (getCWBgroupValue(Event,'mode_group_uname') EQ 0) THEN BEGIN
    beamTO = getTextFieldValue(Event,'time_zero_offset_beam_monitor_uname')
    cmd += ' ' + (*global).ReducePara.monitor_time_offset + '='
    IF (beamTO NE '') THEN BEGIN
      cmd += beamTO + ',0'
    ENDIF ELSE BEGIN
      cmd += '?'
      cmd_status = 0
      ++missing_argument_counter
      missing_arguments_text = [missing_arguments_text, $
        '- Beam Monitor ' + $
        'Offset (PARAMETERS)']
    ENDELSE
  ENDIF
  
  ;-Wavelength min, max, width and unit
  Valuemin   = getTextFieldValue(Event,'wave_min_text_field')
  Valuemax   = getTextFieldValue(Event,'wave_max_text_field')
  Valuewidth = getTextFieldValue(Event,'wave_width_text_field')
  Valueunits = getCWBgroupValue(Event,'wave_scale_group')
  cmd += ' ' + (*global).CorrectPara.wavelength_range.flag + '='
  IF (Valuemin NE '') THEN BEGIN
    cmd += STRCOMPRESS(Valuemin,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    cmd += '?'
    cmd_status = 0
    ++missing_argument_counter
    missing_arguments_text = [missing_arguments_text, $
      '- Wavelength minimum ' + $
      '(PARAMETERS)']
  ENDELSE
  cmd += ','
  IF (Valuemax NE '') THEN BEGIN
    cmd += STRCOMPRESS(Valuemax,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    cmd += '?'
    cmd_status = 0
    ++missing_argument_counter
    missing_arguments_text = [missing_arguments_text, $
      '- Wavelength maximum ' + $
      '(PARAMETERS)']
  ENDELSE
  cmd += ','
  IF (Valuewidth NE '') THEN BEGIN
    cmd += STRCOMPRESS(Valuewidth,/REMOVE_ALL)
  ENDIF ELSE BEGIN
    cmd += '?'
    cmd_status = 0
    ++missing_argument_counter
    missing_arguments_text = [missing_arguments_text, $
      '- Wavelength width ' + $
      '(PARAMETERS)']
  ENDELSE
  cmd += ','
  IF (Valueunits EQ 0) THEN BEGIN
    cmd += 'lin'
  ENDIF ELSE BEGIN
    cmd += 'log'
  ENDELSE
  
  IF (getCWBgroupValue(Event,'mode_group_uname') EQ 1) THEN BEGIN
    ;background mode
  
    ;Accelerator Down Time
    Value   = getTextFieldValue(Event,'accelerator_down_time_text_field')
    cmd += ' ' + (*global).ReducePara.acc_down_time + '='
    IF (Value NE '') THEN BEGIN
      cmd += STRCOMPRESS(Value,/REMOVE_ALL)
    ENDIF ELSE BEGIN
      cmd += '?'
      cmd_status = 0
      ++missing_argument_counter
      missing_arguments_text = [missing_arguments_text, $
        '- Accelerator Down Time ' + $
        '(PARAMETERS)']
    ENDELSE
    cmd += ',0.0'
  ENDIF
  
  ;-verbose mode
  ;IF (getCWBgroupValue(Event, 'verbose_mode_group') EQ 0) THEN BEGIN
  cmd += ' ' + (*global).ReducePara.verbose
  ;ENDIF
  
  ;-min lambda cut-off mode
  IF (getCWBgroupValue(Event, 'minimum_lambda_cut_off_group') EQ 0) THEN BEGIN
    cmd += ' ' + (*global).ReducePara.min_lambda_cut_off + '='
    value = getTextFieldValue(Event, 'minimum_lambda_cut_off_value')
    IF (value NE '') THEN BEGIN
      cmd += STRCOMPRESS(value,/REMOVE_ALL)
    ENDIF ELSE BEGIN
      cmd += '?'
      cmd_status = 0
      ++missing_argument_counter
      missing_arguments_text = [missing_arguments_text, $
        '- Min. Lambda Cut-Off ' + $
        '(PARAMETERS)']
    ENDELSE
  ENDIF
  
  ;-max lambda cut-off mode
  IF (getCWBgroupValue(Event, 'maximum_lambda_cut_off_group') EQ 0) THEN BEGIN
    cmd += ' ' + (*global).ReducePara.max_lambda_cut_off + '='
    value = getTextFieldValue(Event, 'maximum_lambda_cut_off_value')
    IF (value NE '') THEN BEGIN
      cmd += STRCOMPRESS(value,/REMOVE_ALL)
    ENDIF ELSE BEGIN
      cmd += '?'
      cmd_status = 0
      ++missing_argument_counter
      missing_arguments_text = [missing_arguments_text, $
        '- Max. Lambda Cut-Off ' + $
        '(PARAMETERS)']
    ENDELSE
  ENDIF
  
  IF (getCWBgroupValue(Event,'mode_group_uname') EQ 0) THEN BEGIN
    ;transmission mode
  
    ;- INTERMEDIATE ---------------------------------------------------------------
    IntermPlots = getCWBgroupValue(Event,'intermediate_group_uname')
    ;beam monitor after conversion to Wavelength
    IF (IntermPlots[0] EQ 1) THEN BEGIN
      cmd += ' ' + (*global).IntermPara.bmon_wave.flag
    ENDIF
    ;beam monitor in Wavelength after efficiency correction
    IF (IntermPlots[1] EQ 1) THEN BEGIN
      cmd += ' ' + (*global).IntermPara.bmon_effc.flag
    ENDIF
    ;data of each pixel after wavelength conversion
    IF (IntermPlots[2] EQ 1) THEN BEGIN
      cmd += ' ' + (*global).IntermPara.wave.flag
    ENDIF
    ;monitor spectrum after rebin to detector wavelength axis
    IF (IntermPlots[3] EQ 1) THEN BEGIN
      cmd += ' ' + (*global).IntermPara.bmon_rebin.flag
    ENDIF
    
  ENDIF
  
  ;- Put cmd in the text box -
  putCommandLine, Event, cmd
  
  ;- put list of  missing arguments
  putMissingArguments, Event, missing_arguments_text
  
  ;- tells how may missing arguments were found
  putMissingArgNumber, Event, missing_argument_counter
  
  ;- activate GO DATA REDUCTION BUTTON only if cmd_status is 1
  activate_go_data_reduction, Event, cmd_status
  
  (*(*global).list_OF_files_to_send) = list_OF_files_to_send
  
END
