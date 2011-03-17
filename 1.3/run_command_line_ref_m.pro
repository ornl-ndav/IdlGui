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

pro run_command_line_ref_m, event

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
  
;  IF (~isWithDataInstrumentGeometryOverwrite(Event)) then begin
;  
;    geo_cmd = (*global).ts_geom
;    
;    geometry_file = getgeometry_file(event)
;    geo_cmd += ' ' + geometry_file
;    
;    cvinfo_file = getcvinfo_file(event)
;    geo_cmd += ' -m ' + cvinfo_file
;    
;    ;get dirpix and refpix values
;    dirpix = float(getTextFieldValue(event,'info_dirpix'))
;    refpix = float(getTextFieldValue(event,'info_refpix'))
;    
;    geo_cmd += ' -D DIRPIX=' + strcompress(dirpix,/remove_all)
;    geo_cmd += ' -D REFPIX=' + strcompress(refpix,/remove_all)
;    geo_cmd += ' -o ' + (*global).tmp_geometry_file
;    cmd_text = 'Running geometry generator:'
;    putLogBookMessage, Event, cmd_text, Append=1
;    cmd_text = '-> ' + geo_cmd
;    putLogBookMessage, Event, cmd_text, Append=1
;    SPAWN, geo_cmd, listening, err_listening
;    status_text = 'Create temp. geometry .... DONE'
;    putTextFieldValue, event, 'data_reduction_status_text_field', status_text, 0
;    
;  endif

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
    
    spawn, cmd[index], listening, err_listening ;REMOVE_ME
    
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
