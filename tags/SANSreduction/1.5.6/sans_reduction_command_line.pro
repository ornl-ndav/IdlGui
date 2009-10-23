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
      fileID = h5f_open(file)
      pathID = h5d_open(fileID, bmon_path[0])
      RETURN, bmon_path_value[0]
    ENDELSE
  END
  
  ;------------------------------------------------------------------------------
  ;This function builds the command line
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
    cmd = (*global).ReducePara.driver_name ;driver to launch
    
    ;- LOAD FILES TAB (1) ---------------------------------------------------------
    
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
    facility = (*global).facility
    cmd += '=' + facility
    
    cmd +=  ' ' + (*global).instrument_flag
    instrument = (*global).instrument
    cmd += '=' + instrument
    
    ;get monitor path
    cmd += ' --bmon-path='
    IF (file_run EQ '') THEN BEGIN
      cmd += '?'
    ENDIF ElSE BEGIN
      path = getBmonPath(Event, file_run)
      cmd += path
    ENDELSE
    
    ;add list of banks mandatory flag for sns instrument only
    IF ((*global).facility EQ 'SNS') THEN BEGIN
      cmd += ' --data-paths=1-48'
    ENDIF
    
    ;-ROI File-
    file_run = getTextFieldValue(Event,'roi_file_name_text_field')
    IF (file_run NE '' AND $
      FILE_TEST(file_run,/REGULAR)) THEN BEGIN
      flag = (*global).CorrectPara.roi.flag
      cmd += ' ' + flag + '=' + file_run
      Add_file_to_lis_OF_files, list_OF_files_to_send, file_run
    ENDIF
    
    ;-Solvant Buffer Only-
    file_run = getTextFieldValue(Event,'solvant_file_name_text_field')
    IF (file_run NE '' AND $
      FILE_TEST(file_run,/REGULAR)) THEN BEGIN
      flag = (*global).CorrectPara.solv_buffer.flag
      cmd += ' ' + flag + '=' + file_run
    ENDIF
    
    ;-Emtpy Can-
    file_run = getTextFieldValue(Event,'empty_file_name_text_field')
    IF (file_run NE '' AND $
      FILE_TEST(file_run,/REGULAR)) THEN BEGIN
      flag = (*global).CorrectPara.empty_can.flag
      cmd += ' ' + flag + '=' + file_run
    ENDIF
    
    ;-Open Beam-
    file_run = getTextFieldValue(Event,'open_file_name_text_field')
    IF (file_run NE '' AND $
      FILE_TEST(file_run,/REGULAR)) THEN BEGIN
      flag = (*global).CorrectPara.open_beam.flag
      cmd += ' ' + flag + '=' + file_run
    ENDIF
    
    ;-Dark Current-
    file_run = getTextFieldValue(Event,'dark_file_name_text_field')
    IF (file_run NE '' AND $
      FILE_TEST(file_run,/REGULAR)) THEN BEGIN
      flag = (*global).CorrectPara.dark_current.flag
      cmd += ' ' + flag + '=' + file_run
    ENDIF
    
    ;- LOAD FILES TAB (2) ---------------------------------------------------------
    
    ;-Sample Data Transmission-
    file_run = getTextFieldValue(Event, $
      'sample_data_transmission_file_name_text_field')
    IF (file_run NE '' AND $
      FILE_TEST(file_run,/REGULAR)) THEN BEGIN
      flag = (*global).CorrectPara.sample_data_trans.flag
      cmd += ' ' + flag + '=' + file_run
      Add_file_to_lis_OF_files, list_OF_files_to_send, file_run
    ENDIF
    
    ;-Emtpy Can transmisison-
    file_run = getTextFieldValue(Event, $
      'empty_can_transmission_file_name_text_field')
    IF (file_run NE '' AND $
      FILE_TEST(file_run,/REGULAR)) THEN BEGIN
      flag = (*global).CorrectPara.empty_can_trans.flag
      cmd += ' ' + flag + '=' + file_run
      Add_file_to_lis_OF_files, list_OF_files_to_send, file_run
    ENDIF
    
    ;-Solvent transmisison-
    file_run = getTextFieldValue(Event, $
      'solvent_transmission_file_name_text_field')
    IF (file_run NE '' AND $
      FILE_TEST(file_run,/REGULAR)) THEN BEGIN
      flag = (*global).CorrectPara.solvent.flag
      cmd += ' ' + flag + '=' + file_run
      Add_file_to_lis_OF_files, list_OF_files_to_send, file_run
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
    (*global).ascii_path = output_path
    
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
      inst_geom = getButtonValue(Event,'overwrite_geometry_button')
      IF (inst_geom NE '') THEN BEGIN
        cmd += inst_geom
        Add_file_to_lis_OF_files, list_OF_files_to_send, inst_geom
      ENDIF ELSE BEGIN
        cmd += '?'
        cmd_status = 0
        ++missing_argument_counter
        missing_arguments_text = [missing_arguments_text, $
          '- Instrument' + $
          ' Geometry File (LOAD FILES)']
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
      
    ENDIF ELSE BEGIN
      activate_intermediate_base = 1
    ENDELSE
    
    ;-Q min, max, width and unit
    Qmin   = getTextFieldValue(Event,'qmin_text_field')
    Qmax   = getTextFieldValue(Event,'qmax_text_field')
    Qwidth = getTextFieldValue(Event,'qwidth_text_field')
    ;    Qunits = getCWBgroupValue(Event,'q_scale_group')
    cmd += ' ' + (*global).ReducePara.monitor_rebin + '='
    IF (Qmin NE '') THEN BEGIN
      format_error = 1
      ON_IOERROR, error
      fQmin = FLOAT(Qmin)
      IF (fQmin EQ FLOAT(0)) THEN BEGIN
        cmd += '?'
        cmd_status = 0
        ++missing_argument_counter
        missing_arguments_text = [missing_arguments_text, $
        '- Qmin MUST be > 0 (PARAMETERS)']
      ENDIF ELSE BEGIN
        cmd += STRCOMPRESS(Qmin,/REMOVE_ALL)
      ENDELSE
      format_error = 0
      error:
      IF (format_error EQ 1) THEN BEGIN
        cmd += '?'
        cmd_status = 0
        ++missing_argument_counter
        missing_arguments_text = [missing_arguments_text, $
        '- Qmin MUST be valid number (PARAMETERS)']
            ENDIF
    ENDIF ELSE BEGIN
      cmd += '?'
      cmd_status = 0
      ++missing_argument_counter
      missing_arguments_text = [missing_arguments_text, '- Q minimum ' + $
        '(PARAMETERS)']
    ENDELSE
    cmd += ','
    IF (Qmax NE '') THEN BEGIN
      cmd += STRCOMPRESS(Qmax,/REMOVE_ALL)
    ENDIF ELSE BEGIN
      cmd += '?'
      cmd_status = 0
      ++missing_argument_counter
      missing_arguments_text = [missing_arguments_text, '- Q maximum ' + $
        '(PARAMETERS)']
    ENDELSE
    cmd += ','
    IF (Qwidth NE '') THEN BEGIN
      cmd += STRCOMPRESS(Qwidth,/REMOVE_ALL)
    ENDIF ELSE BEGIN
      cmd += '?'
      cmd_status = 0
      ++missing_argument_counter
      missing_arguments_text = [missing_arguments_text, '- Q width ' + $
        '(PARAMETERS)']
    ENDELSE
    cmd += ','
    ;    IF (Qunits EQ 0) THEN BEGIN
    ;      cmd += 'lin'
    ;    ENDIF ELSE BEGIN
    cmd += 'log'
    ;    ENDELSE
    
    ;-verbose mode
    ;IF (getCWBgroupValue(Event, 'verbose_mode_group') EQ 0) THEN BEGIN
    cmd += ' ' + (*global).ReducePara.verbose
    ;ENDIF
    
    ;-min_lambda cut-off mode
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
          '- Low Lambda Cut-Off ' + $
          '(PARAMETERS)']
      ENDELSE
    ENDIF
    
    ;-max_lambda cut-off mode
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
          '- High Lambda Cut-Off ' + $
          '(PARAMETERS)']
      ENDELSE
    ENDIF
    
    ;- Wavelength dependent background subtraction
    value = getTextFieldValue(Event,'wave_dependent_back_sub_text_field')
    IF (value NE '') THEN BEGIN
      cmd += ' ' + (*global).ReducePara.wave_dep_back_sub + '='
      cmd += value
    ENDIF
    
    ;-scaling constant
    IF (getCWBgroupValue(Event, 'scaling_constant_group') EQ 0) THEN BEGIN
      activate_intermediate_base = 0
      cmd += ' ' + (*global).CorrectPara.scale.flag + '='
      value = getTextFieldValue(Event, 'scaling_constant_value')
      IF (value NE '') THEN BEGIN
        cmd += STRCOMPRESS(value,/REMOVE_ALL)
      ENDIF ELSE BEGIN
        cmd += '?'
        cmd_status = 0
        ++missing_argument_counter
        missing_arguments_text = [missing_arguments_text, $
          '- Scaling Constant Value ' + $
          '(PARAMETERS)']
      ENDELSE
    ENDIF
    
    ;Accelerator Down time (seconds)
    value = getTextFieldValue(Event,'wave_dependent_back_sub_text_field')
    IF (value NE '') THEN BEGIN ;required if none empty list of coefficients
    
      prefix_flag = ',0.0,"seconds"'
      
      ;data
      file_run = getTextFieldValue(Event,'data_file_name_text_field')
      IF (file_run NE '') THEN BEGIN
        cmd += ' ' + (*global).accelerator_data_flag + '='
        value1 = getTextFieldValue(Event, 'acce_data_text_field')
        IF (value1 NE '') THEN BEGIN
          cmd += STRCOMPRESS(value1,/REMOVE_ALL) + prefix_flag
        ENDIF ELSE BEGIN
          cmd += '?' + prefix_flag
          cmd_status = 0
          ++missing_argument_counter
          missing_arguments_text = [missing_arguments_text, $
            '- Data Accelerator Down Time ' + $
            '(PARAMETERS)']
        ENDELSE
        activate_data = 1
      ENDIF ELSE BEGIN
        activate_data = 0
      ENDELSE
      uname_list = ['acce_data_label',$
        'acce_data_text_field']
      activate_widget_list, Event, uname_list, activate_data
      
      ;solvent
      file_run = getTextFieldValue(Event,'solvant_file_name_text_field')
      IF (file_run NE '') THEN BEGIN
        cmd += ' ' + (*global).accelerator_solvent_flag + '='
        value1 = getTextFieldValue(Event, 'acce_solvent_text_field')
        IF (value1 NE '') THEN BEGIN
          cmd += STRCOMPRESS(value1,/REMOVE_ALL) + prefix_flag
        ENDIF ELSE BEGIN
          cmd += '?' + prefix_flag
          cmd_status = 0
          ++missing_argument_counter
          missing_arguments_text = [missing_arguments_text, $
            '- Solvent Accelerator Down Time ' + $
            '(PARAMETERS)']
        ENDELSE
        activate_solvent = 1
      ENDIF ELSE BEGIN
        activate_solvent = 0
      ENDELSE
      uname_list = ['acce_solvent_label',$
        'acce_solvent_text_field']
      activate_widget_list, Event, uname_list, activate_solvent
      
      ;empty can
      file_run = getTextFieldValue(Event,'empty_file_name_text_field')
      IF (file_run NE '') THEN BEGIN
        cmd += ' ' + (*global).accelerator_empty_can_flag + '='
        value1 = getTextFieldValue(Event, 'acce_empty_can_text_field')
        IF (value1 NE '') THEN BEGIN
          cmd += STRCOMPRESS(value1,/REMOVE_ALL) + prefix_flag
        ENDIF ELSE BEGIN
          cmd += '?' + prefix_flag
          cmd_status = 0
          ++missing_argument_counter
          missing_arguments_text = [missing_arguments_text, $
            '- Empty Can Accelerator Down Time ' + $
            '(PARAMETERS)']
        ENDELSE
        activate_empty_can = 1
      ENDIF ELSE BEGIN
        activate_empty_can = 0
      ENDELSE
      uname_list = ['acce_empty_can_label',$
        'acce_empty_can_text_field']
      activate_widget_list, Event, uname_list, activate_empty_can
      
      ;Open Beam
      file_run = getTextFieldValue(Event,'open_file_name_text_field')
      IF (file_run NE '') THEN BEGIN
        cmd += ' ' + (*global).accelerator_open_beam_flag + '='
        value1 = getTextFieldValue(Event, 'acce_open_beam_text_field')
        IF (value1 NE '') THEN BEGIN
          cmd += STRCOMPRESS(value1,/REMOVE_ALL) + prefix_flag
        ENDIF ELSE BEGIN
          cmd += '?' + prefix_flag
          cmd_status = 0
          ++missing_argument_counter
          missing_arguments_text = [missing_arguments_text, $
            '- Open Beam Accelerator Down Time ' + $
            '(PARAMETERS)']
        ENDELSE
        activate_open_beam = 1
      ENDIF ELSE BEGIN
        activate_open_beam = 0
      ENDELSE
      uname_list = ['acce_open_beam_label',$
        'acce_open_beam_text_field']
      activate_widget_list, Event, uname_list, activate_open_beam
      
    ENDIF
    
    scaling_value = (*global).scaling_value
    IF (scaling_value NE '') THEN BEGIN
      cmd +=  ' ' + (*global).scaling_value_flag + '=' + scaling_value
    ENDIF
    
    IF (getCWBgroupValue(Event, $
      'beam_monitor_normalization_group') EQ 1) THEN BEGIN ;without beam monitor
      cmd += ' --no-bmon-norm'
    ENDIF
    
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
    ;Fractional Counts and Area after Q Rebinning
    IF (IntermPlots[4] EQ 1) THEN BEGIN
      cmd += ' ' + (*global).IntermPara.fract_counts.flag
    ENDIF
    ;combined spectrum of data after beam monitor normalization
    IF (IntermPlots[5] EQ 1) THEN BEGIN
      cmd += ' ' + (*global).IntermPara.bmnon_wave.flag
      map_status = 1
      ;-wavelength min, max, width and unit
      Lambdamin   = getTextFieldValue(Event,'lambda_min_text_field')
      Lambdamax   = getTextFieldValue(Event,'lambda_max_text_field')
      Lambdawidth = getTextFieldValue(Event,'lambda_width_text_field')
      Lambdaunits = getCWBgroupValue(Event,'lambda_scale_group')
      cmd += ' ' + (*global).IntermPara.bmnon_wave.flag1 + '='
      IF (Lambdamin NE '') THEN BEGIN
        cmd += STRCOMPRESS(Lambdamin,/REMOVE_ALL)
      ENDIF ELSE BEGIN
        cmd += '?'
        cmd_status = 0
        ++missing_argument_counter
        missing_arguments_text = [missing_arguments_text, '- Lambda ' + $
          'minimum ' + $
          '(INTERMEDIATE FILES)']
      ENDELSE
      cmd += ','
      IF (Lambdamax NE '') THEN BEGIN
        cmd += STRCOMPRESS(Lambdamax,/REMOVE_ALL)
      ENDIF ELSE BEGIN
        cmd += '?'
        cmd_status = 0
        ++missing_argument_counter
        missing_arguments_text = [missing_arguments_text, '- Lambda ' + $
          'maximum ' + $
          '(INTERMEDIATE FILES)']
      ENDELSE
      cmd += ','
      IF (Lambdawidth NE '') THEN BEGIN
        cmd += STRCOMPRESS(Lambdawidth,/REMOVE_ALL)
      ENDIF ELSE BEGIN
        cmd += '?'
        cmd_status = 0
        ++missing_argument_counter
        missing_arguments_text = [missing_arguments_text, '- Lambda ' + $
          'width ' + $
          '(INTERMEDIATE FILES)']
      ENDELSE
      cmd += ','
      IF (Lambdaunits EQ 0) THEN BEGIN
        cmd += 'lin'
      ENDIF ELSE BEGIN
        cmd += 'log'
      ENDELSE
    ENDIF ELSE BEGIN
      map_status = 0
    ENDELSE
    map_base, Event, 'lambda_base', map_status
    
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
