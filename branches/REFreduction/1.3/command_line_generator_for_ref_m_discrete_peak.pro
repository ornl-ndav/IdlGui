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
;   promote products derived from this software without specific written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

;+
; :Description:
;    This function will return the min and max pixel values from the
;    pixel_list
;
; :Params:
;    pixel_list
;
; :Returns:
;    [pixel_min, pixel_max]
;
;
; :Author: j35
;-
function calculate_pixel_range, pixel_list
  compile_opt idl2
  
  nbr_pixels = (size(pixel_list,/dim))[1]
  
  _pixel_min = 500
  _pixel_max = 0
  
  _index = 0
  while (_index lt nbr_pixels) do begin
  
    _local_pixel_1 = pixel_list[0,_index]
    _local_pixel_2 = pixel_list[1,_index]
    
    _local_pixel_min = min([_local_pixel_1, _local_pixel_2], $
      max=_local_pixel_max)
      
    _pixel_min = (_local_pixel_min lt _pixel_min) ? $
      _local_pixel_min : _pixel_min
    _pixel_max = (_local_pixel_max gt _pixel_max) ? $
      _local_pixel_max : _pixel_max
      
    _index++
  endwhile
  
  return, [_pixel_min, _pixel_max]
  
end

;+
; :Description:
;    this procedure builds the command line for the REF_M instrument
;    when the 'discrete reflective peak' has been selected
;
; :Params:
;    event
;
; :Author: j35
;-
pro command_line_generator_for_ref_m_discrete_peak, event
  compile_opt idl2
  
  ;get global structure
  WIDGET_CONTROL,event.top,get_uvalue=global
  
  discrete_roi_selection = (*(*global).discrete_roi_selection)
  
  ;determine the list of pixels = strarr(2,nbr_discrete_rois)
  pixel_list = parse_discrete_roi_selection(discrete_roi_selection)
  (*(*global).pixel_range_discrete_mode) = pixel_list
  nbr_pixels = (size(pixel_list,/dim))[1] ;how many discrete rois
  
  if (pixel_list[0] eq '') then return
  
  ;  ;pixel_min_max = (*global).broad_peak_pixel_range
  ;  pixel_min = fix(getValue(event=event, $
  ;    uname='data_d_selection_roi_ymin_cw_field'))
  ;  pixel_max = fix(getValue(event=event, $
  ;    uname='data_d_selection_roi_ymax_cw_field'))
  ;
  ;  _pixel_min = min([pixel_min, pixel_max], max=_pixel_max)
  ;
  ;  pixel_min_max = [_pixel_min, _pixel_max]
  ;  (*global).broad_peak_pixel_range = pixel_min_max
  
  ;determine the number of discrete selection
  nbr_rois = (size(pixel_list,/dim))[1]
  
  ;  pixel_min = pixel_min_max[0]
  ;  pixel_max = pixel_min_max[1]
  ;  _pixels = pixel_max - pixel_min
  ;  pixel_range = indgen(_pixels) + pixel_min
  ;  (*(*global).pixel_range_broad_mode) = pixel_range
  ;  nbr_pixels = n_elements(pixel_range)
  
  ;determine the spin states to use
  value = getButtonValue(event,'other_spin_states')
  if (value eq 1) then begin ;no other spin states
    nbr_spin_states = 1
  endif else begin
    nbr_spin_states = get_nbr_spin_states(event)
  endelse
  
  ;this array will store for each spin state and each pixel the name
  ;of the output file name
  list_of_output_file_name = strarr(nbr_spin_states, nbr_rois)
  list_of_tmp_data_roi_file_name_for_discrete_mode = strarr(nbr_rois)
  
  ;size of the command line array
  cmd = strarr(nbr_spin_states, nbr_rois)
  
  ;now that we have a Data peak ROI selected, we can build the command line
  StatusMessage = 0 ;will increase by 1 each time a field is missing
  
  ;add called to SLURM if hostname is not heater,lrac or mrac
  spawn, 'hostname', listening
  CASE (listening[0]) OF
    'lrac.sns.gov' : cmd += 'srun -Q -p lracq '
    'mrac.sns.gov' : cmd += 'srun -Q -p mracq '
    ELSE: BEGIN
      cmd += 'srun -Q -p heaterq '
    END
  ENDCASE
  
  cmd += (*global).driver_name ;name of function to call
  
  ;repeat or not reduction for other spin states
  value = getButtonValue(event,'other_spin_states') ;0 for yes, 1 for no
  if (value eq 1) then begin
  
    norm_pola_state = (*global).norm_pola_state
    CASE (norm_pola_state) of
      0: norm_path = 'Off_Off'
      1: norm_path = 'Off_On'
      2: norm_path = 'On_Off'
      3: norm_path = 'On_On'
      else: norm_path = '-?'
    ENDCASE
    norm_spin_state_path = ['entry-' + norm_path]
    norm_spin_state = [norm_path]
    
    data_pola_state = (*global).data_pola_state
    CASE (data_pola_state) of
      0: data_path = 'Off_Off'
      1: data_path = 'Off_On'
      2: data_path = 'On_Off'
      3: data_path = 'On_On'
      else: data_path = '-?'
    ENDCASE
    data_spin_state_path = ['entry-' + data_path]
    data_spin_state = [data_path]
    
    nbr_spin_states = 1
    
  endif else begin
  
    ;create arrays of data path
    spin_state_config = (*global).spin_state_config
    spin_state_selected_index = where(spin_state_config eq 1)
    list_data_path = ['entry-Off_Off',$
      'entry-Off_On',$
      'entry-On_Off',$
      'entry-On_On']
    spin_state = ['Off_Off',$
      'Off_On','On_Off','On_On']
    data_spin_state_path = list_data_path[spin_state_selected_index]
    data_spin_state      = spin_state[spin_state_selected_index]
    (*(*global).data_spin_state_discrete_mode) = data_spin_state
    
  endelse
  
  ;used to calculate the Qrange
  sangle_min_max = fltarr(2)
  sangle=-10
  
  ;determine pixel min and max
  pixel_range = calculate_pixel_range(pixel_list)
  
  calculate_sangle, event, refpix=pixel_range[0], sangle=sangle
  sangle_min_max[0] = sangle
  calculate_sangle, event, refpix=pixel_range[-1], sangle=sangle
  sangle_min_max[1] = sangle
  ;record the min and max sangles values
  (*global).sangle_min_max = sangle_min_max
  
  _index_spin_state = 0  ;up to nbr_spin_states
  ;while (index_spin_state lt nbr_spin_states) do begin
  while (_index_spin_state lt nbr_spin_states) do begin
  
    _index_pixel_range = 0 ;up to nbr_pixels
    while (_index_pixel_range lt nbr_pixels) do begin
      
      _index = _index_spin_state * nbr_pixels + _index_pixel_range
      
      ;*****DATA***************************************************************
      ;get Data run numbers text field
      data_run_numbers = getTextFieldValue(Event, 'reduce_data_runs_text_field')
      if (data_run_numbers NE '') then begin
        cmd[_index_spin_state, _index_pixel_range] += ' ' + data_run_numbers
      endif else begin
        cmd[_index_spin_state, _index_pixel_range] += ' ?'
      endelse
      
      cmd[_index_spin_state, _index_pixel_range] += ' ' + $
        (*global).data_path_flag
      cmd[_index_spin_state, _index_pixel_range] += '=/' + $
        data_spin_state_path[_index_spin_state] + '/'
      cmd[_index_spin_state, _index_pixel_range] += $
        (*global).data_path_flag_suffix
        
      cmd[_index_spin_state, _index_pixel_range] += ' --data-roi-file='
      if (_index_spin_state eq 0) then begin
        ;get data ROI file (must create 1 temporary ROI file for each pixel).
        ;Those temporary files will be created only at the beginning of the
        ;reduction but the names of those ROI will be created here.
        from_px = strcompress(pixel_list[0,_index_pixel_range],/remove_all)
        to_px   = strcompress(pixel_list[1,_index_pixel_range],/remove_all)
        
        data_roi_file = '~/tmp_data_roi_for_pixel_' + from_px + '_to_' + $
        to_px + '.dat'
        list_of_tmp_data_roi_file_name_for_discrete_mode[_index_pixel_range] = $
          data_roi_file
      endif else begin
        data_roi_file = $
          list_of_tmp_data_roi_file_name_for_discrete_mode[_index_pixel_range]
      endelse
      cmd[_index_spin_state, _index_pixel_range] += data_roi_file
      
      if (isDataWithBackground(Event)) then begin ;with background substraction
      
        ;get Peak or Background
        PeakBaseStatus = isPeakBaseMap(Event)
        IF (PeakBaseStatus EQ 1) THEN BEGIN ;exclusion peak
        
          ;bring values of ymin and ymax from data base
          ymin = getTextFieldValue(Event,'data_d_selection_peak_ymin_cw_field')
          ymax = getTextFieldValue(Event,'data_d_selection_peak_ymax_cw_field')
          putTextFieldValue, Event, $
            'data_exclusion_low_bin_text', $
            STRCOMPRESS(ymin[0],/REMOVE_ALL), 0
          putTextFieldValue, Event, $
            'data_exclusion_high_bin_text', $
            STRCOMPRESS(ymax[0],/REMOVE_ALL), 0
            
          cmd[_index_spin_state, _index_pixel_range] += ' --data-peak-excl='
          ;get data peak exclusion
          data_peak_exclusion_min = $
            STRCOMPRESS(getTextFieldValue(Event, $
            'data_exclusion_low_bin_text'), $
            /remove_all)
          IF (data_peak_exclusion_min NE '') THEN BEGIN
            cmd[_index_spin_state, _index_pixel_range] += $
              STRCOMPRESS(data_peak_exclusion_min,/REMOVE_ALL)
          ENDIF ELSE BEGIN
            cmd[_index_spin_state, _index_pixel_range]         += '?'
          ENDELSE
          
          data_peak_exclusion_max = $
            STRCOMPRESS(getTextFieldValue(Event, $
            'data_exclusion_high_bin_text'),$ $
            /REMOVE_ALL)
          IF (data_peak_exclusion_max NE '') THEN BEGIN
            cmd[_index_spin_state, _index_pixel_range] += ' ' + $
              STRCOMPRESS(data_peak_exclusion_max,/REMOVE_ALL)
          ENDIF ELSE BEGIN
            cmd[_index_spin_state, _index_pixel_range]         += ' ?'
          ENDELSE
          
          ;Be sure that the following statement
          ;(Ymin_peak=Ymin_back && Ymax_peak=Ymax_back) is wrong
          Ymin_peak = data_peak_exclusion_min
          Ymax_peak = data_peak_exclusion_max
          Ymin_back = $
            STRCOMPRESS(getTextFieldValue(Event, $
            'data_d_selection_background_ymin_cw_field'), $
            /REMOVE_all)
          Ymax_back = $
            STRCOMPRESS(getTextFieldValue(Event, $
            'data_d_selection_background_ymax_' + $
            'cw_field'), $
            /REMOVE_ALL)
            
        ENDIF ELSE BEGIN ;background file
        
          ;get value of back file from data base
          BackFile = getTextFieldValue(Event,'data_back_selection_file_value')
          BackFile = BackFile[0]
          cmd[_index_spin_state, _index_pixel_range] += ' --dbkg-roi-file='
          ;get data ROI file
          data_roi_file = $
            getTextFieldValue(Event, $
            'data_back_selection_file_value')
          IF (data_roi_file NE '') THEN BEGIN
            cmd[_index_spin_state, _index_pixel_range] += data_roi_file
          ENDIF ELSE BEGIN
            cmd[_index_spin_state, _index_pixel_range]        += '?'
          ENDELSE
          
        ENDELSE
        
      endif
      
      ;check if user wants data background or not
      IF (isDataWithBackground(Event)) THEN BEGIN ;yes, with background
        ;activate DATA Intermediate Plots
        MapBase, Event, 'reduce_plot2_base', 0
      ENDIF ELSE BEGIN
        cmd[_index_spin_state, _index_pixel_range] += ' --no-bkg'
        MapBase, Event, 'reduce_plot2_base', 1
      END
      
      ;tof cutting
      tof_min = STRCOMPRESS(getTextFieldValue(Event,'tof_cutting_min'),$
        /REMOVE_ALL)
      IF (tof_min NE '') THEN BEGIN
      
        IF (isTOFcuttingUnits_microS(Event)) THEN BEGIN ;microS
        
          ON_IOERROR, error_min1
          error_status = 1
          tof_min = FLOAT(tof_min)
          error_status = 0
          tof_min = STRCOMPRESS(tof_min,/REMOVE_ALL)
          error_min1:
          IF (error_status) THEN BEGIN
            tof_min = '?'
          ENDIF
          
        ENDIF ELSE BEGIN
        
          ON_IOERROR, error_min
          error_status = 1
          tof_min = FLOAT(tof_min)
          error_status = 0
          tof_min *= 1000. ;to convert to microS
          tof_min = STRCOMPRESS(tof_min,/REMOVE_ALL)
          
          error_min:
          IF (error_status) THEN BEGIN
            tof_min = '?'
          ENDIF
          
        ENDELSE
        
        cmd[_index_spin_state, _index_pixel_range] += ' --tof-cut-min=' + $
          tof_min
          
      ENDIF
      
      tof_max = STRCOMPRESS(getTextFieldValue(Event,'tof_cutting_max'),$
        /REMOVE_ALL)
      IF (tof_max NE '') THEN BEGIN
      
        IF (isTOFcuttingUnits_microS(Event)) THEN BEGIN ;microS
        
          ON_IOERROR, error_max1
          error_status = 1
          tof_max = FLOAT(tof_max)
          error_status = 0
          tof_max = STRCOMPRESS(tof_max,/REMOVE_ALL)
          error_max1:
          IF (error_status) THEN BEGIN
            tof_max = '?'
          endif
          
        ENDIF ELSE BEGIN
        
          ON_IOERROR, error_max
          error_status = 1
          tof_max = FLOAT(tof_max)
          error_status = 0
          tof_max *= 1000. ;to convert to microS
          tof_max = STRCOMPRESS(tof_max,/REMOVE_ALL)
          
          error_max:
          IF (error_status) THEN BEGIN
            tof_max = '?'
          ENDIF
          
        ENDELSE
        
        cmd[_index_spin_state, _index_pixel_range] += ' --tof-cut-max=' + $
          tof_max
      ENDIF
      
      ;calculate sangle according to the current pixel used
      _pixel = float(mean(float([pixel_list[0,_index_pixel_range],$
        pixel_list[1,_index_pixel_range]])))
      sangle = -10
      calculate_sangle, event, refpix=_pixel, sangle=sangle
      
      ;scattering angle flag
      cmd[_index_spin_state, _index_pixel_range] += ' --scatt-angle='
      rad_sangle = sangle
      rad_sangle_x2 = strcompress(2. * float(rad_sangle),/remove_all)
      rad_sangle_error = strcompress(0.,/remove_all)
      rad_sangle_units = 'units=radians'
      cmd[_index_spin_state, _index_pixel_range] += rad_sangle_x2 + ',' + $
        rad_sangle_error + ',' + rad_sangle_units
        
      ;*****NORMALIZATION******************************************************
      ;check if user wants to use normalization or not
      if (isReductionWithNormalization(Event)) then begin
      
        ;activate Normalization Intermediate Plots
        MapBase, Event, 'reduce_plot4_base', 0
        MapBase, Event, 'reduce_plot6_base', 0
        
        ;get normalization run numbers
        norm_run_numbers = $
          getTextFieldValue(Event, $
          'reduce_normalization_runs_text_field')
        cmd[_index_spin_state, _index_pixel_range] += ' --norm='
        if (norm_run_numbers NE '') then begin
          cmd[_index_spin_state, _index_pixel_range] += norm_run_numbers
        endif else begin
          cmd[_index_spin_state, _index_pixel_range] += '?'
        endelse
        
        ;normalization path
        value = getButtonValue(event,'normalization_pola_state')
        if (value eq 1) then begin
          cmd[_index_spin_state, _index_pixel_range] += $
            (*global).norm_path_flag
        endif else begin
          cmd[_index_spin_state, _index_pixel_range] += ' --norm-data-paths'
          cmd[_index_spin_state, _index_pixel_range] += '=/' + $
            data_spin_state_path[_index_spin_state] + '/'
          cmd[_index_spin_state, _index_pixel_range] += $
            (*global).data_path_flag_suffix
        endelse
        ActivateWidget, Event, 'norm_pola_base', norm_pola_sensitive
        
        ;get normalization ROI file
        norm_roi_file = $
          getTextFieldValue(Event,$
          'reduce_normalization_region_of_interest_file_name')
        norm_roi_file = norm_roi_file[0]
        cmd[_index_spin_state, _index_pixel_range] += '  --norm-roi-file='
        IF (norm_roi_file NE '') THEN BEGIN
          cmd[_index_spin_state, _index_pixel_range] += $
            STRCOMPRESS(norm_roi_file,/remove_all)
        ENDIF ELSE BEGIN
          cmd[_index_spin_state, _index_pixel_range] += '?'
        ENDELSE
        
        if (isNormWithBackground(Event)) then begin ;without background
        
          ;get Peak or Background
          PeakBaseStatus = isNormPeakBaseMap(Event)
          IF (PeakBaseStatus EQ 1) THEN BEGIN ;exclusion peak
          
            ;bring values of ymin and ymax from norm base
            ymin = getTextFieldValue(Event, $
              'norm_d_selection_peak_ymin_cw_field')
            ymax = getTextFieldValue(Event, $
              'norm_d_selection_peak_ymax_cw_field')
            putTextFieldValue, Event, $
              'norm_exclusion_low_bin_text', $
              STRCOMPRESS(ymin[0],/REMOVE_ALL), 0
            putTextFieldValue, Event, $
              'norm_exclusion_high_bin_text', $
              STRCOMPRESS(ymax[0],/REMOVE_ALL), 0
              
            cmd[_index_spin_state, _index_pixel_range] += ' --norm-peak-excl='
            ;get norm peak exclusion
            norm_peak_exclusion_min = $
              STRCOMPRESS(getTextFieldValue(Event,$
              'norm_exclusion_low_bin_text'), $
              /REMOVE_ALL)
            IF (norm_peak_exclusion_min NE '') THEN BEGIN
              cmd[_index_spin_state, _index_pixel_range] += $
                STRCOMPRESS(norm_peak_exclusion_min,$
                /REMOVE_ALL)
            ENDIF ELSE BEGIN
              cmd[_index_spin_state, _index_pixel_range]         += '?'
            ENDELSE
            
            norm_peak_exclusion_max = $
              STRCOMPRESS(getTextFieldValue(Event, $
              'norm_exclusion_high_bin_text'),$ $
              /REMOVE_ALL)
            IF (norm_peak_exclusion_max NE '') THEN BEGIN
              cmd[_index_spin_state, _index_pixel_range] += ' ' + $
                STRCOMPRESS(norm_peak_exclusion_max,/REMOVE_ALL)
            ENDIF ELSE BEGIN
              cmd[_index_spin_state, _index_pixel_range]         += ' ?'
            ENDELSE
            
            ;Be sure that (Ymin_peak=Ymin_back && Ymax_peak=Ymax_back) is wrong
            Ymin_peak = norm_peak_exclusion_min
            Ymax_peak = norm_peak_exclusion_max
            Ymin_back = $
              STRCOMPRESS(getTextFieldValue(Event, $
              'norm_d_selection_background_' + $
              'ymin_cw_field'), $
              /REMOVE_all)
            Ymax_back = $
              STRCOMPRESS(getTextFieldValue(Event, $
              'norm_d_selection_background_ymax_' + $
              'cw_field'), $
              /REMOVE_ALL)
              
          ENDIF ELSE BEGIN            ;background file
          
            ;get value of back file from norm base
            BackFile = getTextFieldValue(Event,'norm_back_selection_file_value')
            BackFile = BackFile[0]
            cmd[_index_spin_state, _index_pixel_range] += ' --nbkg-roi-file='
            ;get norm ROI file
            norm_roi_file = $
              getTextFieldValue(Event, $
              'norm_back_selection_file_value')
            IF (norm_roi_file NE '') THEN BEGIN
              cmd[_index_spin_state, _index_pixel_range] += norm_roi_file
            ENDIF ELSE BEGIN
              cmd[_index_spin_state, _index_pixel_range]        += '?'
            ENDELSE
            
          ENDELSE
          
        endif
        
        ;check if user wants normalization background or not
        if (isNormWithBackground(Event)) then begin ;yes, with background
          MapBase, Event, 'reduce_plot5_base', 0 ;back. norm. plot is available
        endif else begin
          cmd[_index_spin_state, _index_pixel_range] += ' --no-norm-bkg'
          MapBase, Event, 'reduce_plot5_base', 1 ;back. norm. is not available
        endelse
        
      endif else begin                ;no normalization file
      
        ;remove Normalization Intermediate Plots
        MapBase, Event, 'reduce_plot4_base', 1
        MapBase, Event, 'reduce_plot5_base', 1
        MapBase, Event, 'reduce_plot6_base', 1
        
      endelse                         ;end of (~isWithoutNormalization)
      
      ;get name of instrument
      cmd[_index_spin_state, _index_pixel_range] += ' --inst=' + $
        (*global).instrument
        
      ;reduction mode (per selection or per pixel selected)
      if ((*global).reduction_mode ne 'one_per_selection') then begin
      
        if (_index_pixel_range eq 0 && _index_spin_state eq 0) then begin
        
          populate_Q_widgets, event=event
          
          Q_min = getTextFieldValue(Event, 'q_min_text_field')
          Q_max = getTextFieldValue(Event, 'q_max_text_field')
          Q_width = getTextfieldValue(Event, 'q_width_text_field')
          Q_scale = getQSCale(Event)
          
          if (strcompress(Q_min,/remove_all) eq '') then return
          if (strcompress(Q_max,/remove_all) eq '') then return
          
          ;if Q_width is not empty, used this one
          ;if Q_width is empty, calculate Q_width according to Number bins needed
          if (strcompress(Q_width,/remove_all) eq '') then begin
            
            nbr_bins = getTextFieldValue(Event, 'q_nbins_text_field')
            if (Q_scale eq 'lin') then begin
              Q_width = (float(Q_max) - float(Q_min)) / float(nbr_bins)
            endif else begin
              Q_width = (float(Q_max)/float(Q_min))^(1./nbr_bins)-1.
            endelse
            putValue, event=event, 'q_width_text_field', $
              strcompress(Q_width,/remove_all)
          
          endif
          
        endif else begin
        
          Q_min = getTextFieldValue(Event, 'q_min_text_field')
          Q_max = getTextFieldValue(Event, 'q_max_text_field')
          
          Q_width = getTextfieldValue(Event, 'q_width_text_field')
          Q_scale = getQSCale(Event)

        endelse
        
        cmd[_index_spin_state, _index_pixel_range] += ' --mom-trans-bins='
        
        if (Q_min NE '') then begin ;Q_min
          cmd[_index_spin_state, _index_pixel_range] += $
            STRCOMPRESS(Q_min,/remove_all)
        endif else begin
          cmd[_index_spin_state, _index_pixel_range] += '?'
        endelse
        
        if (Q_max NE '') then begin ;Q_max
          cmd[_index_spin_state, _index_pixel_range] += ',' + $
            STRCOMPRESS(Q_max,/remove_all)
        endif else begin
          cmd[_index_spin_state, _index_pixel_range] += ',?'
        endelse
        
        if (Q_width NE '') then begin ;Q_width
          cmd[_index_spin_state, _index_pixel_range] += ',' + $
            STRCOMPRESS(Q_width,/remove_all)
        endif else begin
          cmd[_index_spin_state, _index_pixel_range] += ',?'
        endelse
        ;Q_scale (lin or log)
        cmd[_index_spin_state, _index_pixel_range] += ',' + Q_scale
        
      endif
      
      ;get info about detector angle
      angle_value = getTextFieldValue(Event,'detector_value_text_field')
      angle_err   = getTextFieldValue(Event,'detector_error_text_field')
      angle_units = getDetectorAngleUnits(Event)
      
      if (angle_value NE '' OR $    ;user wants to input the angle value and err
        angle_err NE '') then begin
        
        cmd[_index_spin_state, _index_pixel_range] += ' --angle-offset='
        
        if (angle_value NE '') then begin ;angle_value
          cmd[_index_spin_state, _index_pixel_range] += $
            STRCOMPRESS(angle_value,/remove_all)
        endif else begin
          cmd[_index_spin_state, _index_pixel_range] += '?'
        endelse
        
        if (angle_err NE '') then begin ;angle_err
          cmd[_index_spin_state, _index_pixel_range] += ',' + $
            STRCOMPRESS(angle_err,/remove_all)
        endif else begin
          cmd[_index_spin_state, _index_pixel_range] += ',?'
        endelse
        
        cmd[_index_spin_state, _index_pixel_range] += ',units=' + $
          STRCOMPRESS(angle_units,/remove_all)
          
      endif else begin
      
      endelse
      
      ;get info about filter or not
      if (~isWithFiltering(Event)) then begin ;no filtering
        cmd[_index_spin_state, _index_pixel_range] += ' --no-filter'
      endif
      
      ;get info about deltaT/T
      IF (isWithDToT(Event)) THEN BEGIN ;store deltaT over T
        cmd[_index_spin_state, _index_pixel_range] += ' --store-dtot'
      ENDIF
      
      ;overwrite data instrument geometry file
      if (isWithDataInstrumentGeometryOverwrite(Event)) then BEGIN
        cmd[_index_spin_state, _index_pixel_range] += ' --data-inst-geom='
        ;with instrument geometry
        IGFile = (*global).InstrumentDataGeometryFileName
        if (IGFile NE '') then begin ;instrument geometry file is not empty
          cmd[_index_spin_state, _index_pixel_range] += IGFile
        endif else begin
          cmd[_index_spin_state, _index_pixel_range] += '?'
        endelse
      ENDIF
      
      ;overwrite norm instrument geometry file
      if (isWithNormInstrumentGeometryOverwrite(Event)) then BEGIN
        ;with instrument geometry
        cmd[_index_spin_state, _index_pixel_range] += ' --norm-inst-geom='
        IGFile = (*global).InstrumentNormGeometryFileName
        if (IGFile NE '') then begin ;instrument geometry file is not empty
          cmd[_index_spin_state, _index_pixel_range] += IGFile
          ;display last part of file name in button
          button_value = getFileNameOnly(IGFIle)
        endif else begin
          cmd[_index_spin_state, _index_pixel_range] += '?'
        endelse
        
      endif
      
      ;get name from output path and name
      outputPath = (*global).dr_output_path
      outputFileName = getOutputFileName(Event)
      outputFileName = add_spin_state_and_pixel_range_to_outputFileName(Event,$
        outputFileName,$
        data_spin_state[_index_spin_state],$
        pixel_list[*,_index_pixel_range])
      NewOutputFileName = outputPath + outputFileName
      cmd[_index_spin_state, _index_pixel_range] += ' --output=' + $
        NewOutputFileName
        
      list_of_output_file_name[_index_spin_state, _index_pixel_range] = $
        NewOutputFileName
        
      _index_pixel_range++
    endwhile
    
    _index_spin_state++
  endwhile
  
  ;record the name of all the output files
  (*(*global).list_of_output_file_name_for_discrete_mode) = $
    list_of_output_file_name
    
  (*(*global).list_of_tmp_data_roi_file_name_for_discrete_mode) = $
    list_of_tmp_data_roi_file_name_for_discrete_mode
    
  ;generate intermediate plots command line
  IP_cmd = RefReduction_CommandLineIntermediatePlotsGenerator(Event)
  cmd += IP_cmd
  
  ;save the big command line table generated
  (*(*global).cmd_discrete_mode) = cmd
  
END
