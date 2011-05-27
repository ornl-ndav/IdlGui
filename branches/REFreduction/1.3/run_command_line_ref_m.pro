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

;+
; :Description:
;   This procedure defines the name of the geometry file
;
; :Params:
;    event

; :Author: j35
;-
pro create_name_of_tmp_geometry_file, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  output_path = getOutputPathFromButton(Event)
  data_run_number = strcompress((*global).data_run_number,/remove_all)
  geo_file_name = (*global).instrument + '_' + data_run_number
  geo_file_name += '_geometry.nxs'
  
  tmp_geometry_file = output_path + geo_file_name
  (*global).tmp_geometry_file = tmp_geometry_file
  
end

;+
; :Description:
;    Run the command line for REF_M instrument
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro run_command_line_ref_m, event
  compile_opt idl2
  
  ;get global structure
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  WIDGET_CONTROL,id,get_uvalue=global
  
  PROCESSING = (*global).processing_message ;processing message
  
  ;status_text = 'Create temp. geometry .... ' + PROCESSING
  ;putTextFieldValue, event, 'data_reduction_status_text_field', status_text, 0
  
  ;check the run numbers and replace them by full nexus path
  ;check first DATA run numbers
  ReplaceDataRunNumbersByFullPath, Event
  ;check second NORM run numbers
  IF (isReductionWithNormalization(Event)) THEN BEGIN
    ReplaceNormRunNumbersByFullPath, Event
  ENDIF
  
  ;re-run the CommandLineGenerator
  REFreduction_CommandLineGenerator, Event
  
  ;disable RunCommandLine
  ActivateWidget, Event,'start_data_reduction_button', 0
  
  ;get command line to generate
  cmd = getTextFieldValue(Event,'reduce_cmd_line_preview')
  
  ;indicate initialization with hourglass icon
  WIDGET_CONTROL,/hourglass
  
  sz = N_ELEMENTS(cmd)
  bash_cmd_array = cmd
  first_ref_m_file_to_plot = -1
  index = 0
  nbr_reduction_success = 0
  while(index lt sz) do begin
  
    status_text = 'Data Reduction # ' + strcompress(index+1,/remove_all) + $
      ' ... ' + PROCESSING
    putTextFieldValue, event, 'data_reduction_status_text_field', status_text, 0
    
    ;display command line in log-book
    cmd_text = 'Running Command Line #' + strcompress(index+1,/remove_all) + ': '
    putLogBookMessage, Event, cmd_text, Append=1
    cmd_text = ' -> ' + cmd[index]
    putLogBookMessage, Event, cmd_text, Append=1
    cmd_text = '......... ' + PROCESSING
    putLogBookMessage, Event, cmd_text, Append=1
    
    spawn, cmd[index], listening, err_listening
    
    IF (err_listening[0] NE '') THEN BEGIN
    
      ;remove cmd from array because this cmd failed
      bash_cmd_array[index] = ''
      
      (*global).DataReductionStatus = 'ERROR'
      LogBookText = getLogBookText(Event)
      Message = '* ERROR! *'
      putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING
      ErrorLabel = 'ERROR MESSAGE:'
      putLogBookMessage, Event, ErrorLabel, Append=1
      putLogBookMessage, Event, err_listening, Append=1
      
      status_text = 'Data Reduction # ' + strcompress(index+1,/remove_all) + $
        ' ... ERROR! (-> Check Log Book)'
      putTextFieldValue, event, 'data_reduction_status_text_field', $
        status_text, 0
        
    endif else begin
    
      nbr_reduction_success++ ;at least 1 successful reduction
      
      (*global).DataReductionStatus = 'OK'
      if (first_ref_m_file_to_plot eq -1) then begin
        first_ref_m_file_to_plot = index
        GenerateBatchFileName_ref_m, Event
      endif
      
      LogBookText = getLogBookText(Event)
      Message = 'Done'
      putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING
      
      status_text = 'Data Reduction # ' + strcompress(index+1,/remove_all) + $
        ' ... DONE'
      putTextFieldValue, event, 'data_reduction_status_text_field', $
        status_text, 0
        
      ;manually creating I(Q) output file
      if (strlowcase((*global).overwrite_q_output_file) eq 'yes') then begin
      
        text = 'Overwriting I(Q) output file ... ' + PROCESSING
        putLogBookMessage, Event, cmd_text, Append=1
        
        list_of_output_file_name = (*(*global).list_of_output_file_name)
        
        overwritting_i_of_q_output_file, event, $
          cmd=cmd[index], $
          output_file_name=list_of_output_file_name[index]
          
        LogBookText = getLogBookText(Event)
        Message = 'Done'
        putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING
        
      endif
      
    endelse
    
    index++
  endwhile
  
  ;reactivate run command button
  ActivateWidget, Event,'start_data_reduction_button', 1
  
  if (nbr_reduction_success gt 0) then begin
    ;populate Batch table
    populate_ref_m_batch_table, event, bash_cmd_array
  endif
  
  ;turn off hourglass
  WIDGET_CONTROL,hourglass=0
  
  (*global).first_ref_m_file_to_plot = first_ref_m_file_to_plot
  
END

;+
; :Description:
;    Run the reduction for each pixel of the selection when using the
;    mode "Broad reflective peak" mode
;
; :Params:
;    event
;
; :Keywords:
;   error ;will return 1b if any of the reduction failed
;
;
; :Author: j35
;-
pro run_command_line_ref_m_broad_peak, event, status=status
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;by default, we presume that it's not going to work
  status=0b
  
  processing = (*global).processing_message
  text = '> Launching the hidden jobs of the broad mode:'
  IDLsendLogBook_addLogBookText, Event, text
  
  error=0b ;by default, we suppose that it's going to work
  
  cmd = (*(*global).cmd_broad_mode)
  data_spin_state = (*(*global).data_spin_state_broad_mode)
  spin_state_nbr_steps = n_elements(data_spin_state)
  
  sz = size(cmd, /dim)
  
  nbr_spins = sz[0]
  nbr_pixels = sz[1]
  
  progress_bar, event=event, $
    parent_base_uname='MAIN_BASE', $
    pixel_nbr_steps = nbr_pixels, $
    list_working_spin_states = data_spin_state
    
  ;list of name of data tmp roi file name
  list_of_tmp_data_roi_file_name = $
    (*(*global).list_of_tmp_data_roi_file_name_for_broad_mode)
    
  ;list of pixels
  pixel_range = (*(*global).pixel_range_broad_mode)
  
  text = '-> preprocessing ... ' +  PROCESSING
  IDLsendLogBook_addLogBookText, Event, text
  
  ;pre processing
  ;this is where the temporary data ROI file will be created
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    error=1b
    
    message = 'FAILED!'
    IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message
    
    return
  endif else begin
  
    _index_pixel=0
    while (_index_pixel lt nbr_pixels) do begin
    
      create_tmp_data_roi_file, event=event, $
        pixel=pixel_range[_index_pixel], $
        output_file_name=list_of_tmp_data_roi_file_name[_index_pixel]
        
      update_progress_bar, base=(*global).progress_bar_base, $
        /pre_processing, $
        /increment
        
      _index_pixel++
    endwhile
    
  endelse
  IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, 'OK'
  
  text = '-> Running jobs: '
  IDLsendLogBook_addLogBookText, Event, text
  
  ;main part of reduction
  _index_spin=0
  while (_index_spin lt nbr_spins) do begin
  
    _current_spin_state = data_spin_state[_index_spin]
    
    _index_pixel=0
    while(_index_pixel lt nbr_pixels) do begin
    
      text = '--> [index_spin,pixel_index]:[' + $
        strcompress(_index_spin,/remove_all) + ',' + $
        strcompress(_index_pixel,/remove_all) + ']'
      IDLsendLogBook_addLogBookText, Event, text
      text = '---> cmd: ' + cmd[_index_spin,_index_pixel] + ' ... ' + $
        processing
      IDLsendLogBook_addLogBookText, event, text
      update_progress_bar, base=(*global).progress_bar_base, $
        spin_state=_current_spin_state, $
        /increment
        
      spawn, cmd[_index_spin,_index_pixel], result, error_result
      if (error_result[0] ne '') then begin
        error = 1b
        message = 'FAILED!'
        IDLsendLogBook_ReplaceLogBookText, event, processing, message
        
        IDLsendLogBook_addLogBookText, event, '---> Result: '
        IDLsendLogBook_addLogBookText, event, result
        IDLsendLogBook_addLogBookText, event, '---> Error_Result: '
        IDLsendLogBook_addLogBookText, event, error_result
        
        return
      endif
      message = 'OK'
      IDLsendLogBook_ReplaceLogBookText, event, processing, message
      
      _index_pixel++
    endwhile
    
    _index_spin++
  endwhile
  
  ;phase 1 of post-processing
  ;merging the output files of the various spin states
  list_of_broad_output_file_name = $
    (*(*global).list_of_output_file_name_for_broad_mode)
  list_of_output_file_name = (*(*global).list_of_output_file_name)
  _index_spin=0
  while (_index_spin lt nbr_spins) do begin
  
    _final_output = list_of_output_file_name[_index_spin]
    _list_tmp_output = reform(list_of_broad_output_file_name[_index_spin,*])
    
    merge_files, list_files_to_merge=_list_tmp_output, $
      final_file_name = _final_output, $
      result=result
      
    update_progress_bar, base=(*global).progress_bar_base, $
      /post_processing, $
      /increment
      
    _index_spin++
  endwhile
  
  ;phase 2 of post-processing
  ;removing the temporary data ROI files
  text = '-> postprocessing ... ' +  PROCESSING
  IDLsendLogBook_addLogBookText, Event, text
  
  _index_pixel=0
  while (_index_pixel lt nbr_pixels) do begin
  
    _cmd = 'rm ' + list_of_tmp_data_roi_file_name[_index_pixel]
    spawn, _cmd
    
    _index_pixel++
  endwhile
  IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, 'OK'
  
  update_progress_bar, base=(*global).progress_bar_base, $
    /post_processing, $
    /increment
    
  ;kill the progress bar
  id = (*global).progress_bar_base
  widget_control, id, /destroy
  
  ;if we reached that point, we know that it ran with success
  status= 1b
  
end

; :Description:
;    Run the reduction for each rois  when using the
;    mode "discrete reflective peak" mode
;
; :Params:
;    event
;
; :Keywords:
;   error ;will return 1b if any of the reduction failed
;
;
; :Author: j35
;-
pro run_command_line_ref_m_discrete_peak, event, status=status
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;by default, we presume that it's not going to work
  status=0b
  
  PROCESSING = (*global).processing_message ;processing message
  text = '> Launching the hidden jobs of the discrete mode:'
  IDLsendLogBook_addLogBookText, Event, text
  
  error=0b ;by default, we suppose that it's going to work
  
  cmd = (*(*global).cmd_discrete_mode)
  data_spin_state = (*(*global).data_spin_state_discrete_mode)
  spin_state_nbr_steps = n_elements(data_spin_state)
  
  sz = size(cmd, /dim)
  
  nbr_spins = sz[0]
  nbr_pixels = sz[1]
  
  progress_bar, event=event, $
    parent_base_uname='MAIN_BASE', $
    pixel_nbr_steps = nbr_pixels, $
    list_working_spin_states = data_spin_state
    
  ;list of name of data tmp roi file name
  list_of_tmp_data_roi_file_name = $
    (*(*global).list_of_tmp_data_roi_file_name_for_discrete_mode)
    
  ;list of pixels
  pixel_range = (*(*global).pixel_range_discrete_mode)
  
  ;pre processing
  ;this is where the temporary data ROI file will be created
  
  text = '-> preprocessing ... ' +  PROCESSING
  IDLsendLogBook_addLogBookText, Event, text
  
  ;catch, error
  error = 0
  if (error ne 0) then begin
    catch,/cancel
    error=1b
    
    message = 'FAILED!'
    IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message
    
    return
  endif else begin
  
    _index_pixel=0
    while (_index_pixel lt nbr_pixels) do begin
    
      create_tmp_discrete_data_roi_file, event=event, $
        from_px = fix(pixel_range[0,_index_pixel]),$
        to_px = fix(pixel_range[1,_index_pixel]), $
        output_file_name=list_of_tmp_data_roi_file_name[_index_pixel]
        
      update_progress_bar, base=(*global).progress_bar_base, $
        /pre_processing, $
        /increment
        
      _index_pixel++
    endwhile
    
  endelse
  IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, 'OK'
  
  text = '-> Running jobs: '
  IDLsendLogBook_addLogBookText, Event, text
  
  ;main part of reduction
  _index_spin=0
  while (_index_spin lt nbr_spins) do begin
  
    _current_spin_state = data_spin_state[_index_spin]
    
    _index_pixel=0
    while(_index_pixel lt nbr_pixels) do begin
    
      text = '--> [index_spin,pixel_index]:[' + $
        strcompress(_index_spin,/remove_all) + ',' + $
        strcompress(_index_pixel,/remove_all) + ']'
      IDLsendLogBook_addLogBookText, Event, text
      text = '---> cmd: ' + cmd[_index_spin, _index_pixel] + ' ... ' + $
        PROCESSING
      IDLsendLogBook_addLogBookText, event, text
      
      update_progress_bar, base=(*global).progress_bar_base, $
        spin_state=_current_spin_state, $
        /increment
        
      ;print, cmd[_index_spin, _index_pixel]
      spawn, cmd[_index_spin, _index_pixel], result, error_result
      if (error_result[0] ne '') then begin
        error = 1b
        message = 'FAILED!'
        IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message
        
        IDLsendLogBook_addLogBookText, event, '---> Result: '
        IDLsendLogBook_addLogBookText, event, result
        IDLsendLogBook_addLogBookText, event, '---> Error_Result: '
        IDLsendLogBook_addLogBookText, event, error_result
        
        return
      endif
      
      message = 'OK'
      IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, Message
      
      _index_pixel++
    endwhile
    
    _index_spin++
  endwhile
  
  ;phase 1 of post-processing
  ;merging the output files of the various spin states
  list_of_discrete_output_file_name = $
    (*(*global).list_of_output_file_name_for_discrete_mode)
  list_of_output_file_name = (*(*global).list_of_output_file_name)
  _index_spin=0
  while (_index_spin lt nbr_spins) do begin
  
    _final_output = list_of_output_file_name[_index_spin]
    _list_tmp_output = reform(list_of_discrete_output_file_name[_index_spin,*])
    
    merge_files, list_files_to_merge=_list_tmp_output, $
      final_file_name = _final_output, $
      result=result
      
    update_progress_bar, base=(*global).progress_bar_base, $
      /post_processing, $
      /increment
      
    _index_spin++
  endwhile
  
  text = '-> postprocessing ... ' +  PROCESSING
  IDLsendLogBook_addLogBookText, Event, text
  
  ;phase 2 of post-processing
  ;removing the temporary data ROI files
  _index_pixel=0
  while (_index_pixel lt nbr_pixels) do begin
  
    _cmd = 'rm ' + list_of_tmp_data_roi_file_name[_index_pixel]
    spawn, _cmd
    
    _index_pixel++
  endwhile
  IDLsendLogBook_ReplaceLogBookText, Event, PROCESSING, 'OK'
  
  update_progress_bar, base=(*global).progress_bar_base, $
    /post_processing, $
    /increment
    
  ;kill the progress bar
  id = (*global).progress_bar_base
  widget_control, id, /destroy
  
  ;if we reached that point, we know that it ran with success
  status= 1b
  
end



;+
; :Description:
;    This routine will use the agg_dr_files driver to merge the various
;    tmp_output_file_name into just one ascii file
;
; :Keywords:
;    list_files_to_merge
;    final_file_name
;    result
;
; :Author: j35
;-
pro merge_files, list_files_to_merge=list_files_to_merge, $
    final_file_name = final_file_name, $
    result=result
  compile_opt idl2
  
  driver_name = 'agg_dr_files'
  cmd = driver_name + ' ' + strjoin(list_files_to_merge,' ')
  cmd += ' --output=' + final_file_name
  
  ;run command
  spawn, cmd, result, error_result
  
end

