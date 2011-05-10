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
;   This routine will show the dialog_pickfile to let the user selects the
;   output folde
;
; :Params:
;    event
;
; :Author: j35
;-
pro browse_output_path, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  path = (*global).BatchDefaultPath
  dialog_id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
  title = 'Select the destination folder'
  
  new_path = dialog_pickfile(/directory,$
    dialog_parent = dialog_id,$
    /must_exist,$
    path = path, $
    title = title)
    
  if (new_path ne '') then begin
    (*global).BatchDefaultPath = new_path
    putValueInTextField, Event, 'output_path_button', new_path
    check_previews_button, event
  endif
  
end


;+
; :Description:
;   This procedures will update live (as the user is typing) the contain of
;   the scaled and combined scaled labels file name in the output file tab
;
; :Params:
;    event
;
; :Author: j35
;-
pro output_file_name_value, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  value = getTextfieldValue(event,'output_short_file_name')
  ext = getTextFieldValue(event,'output_file_name_extension')
  
  ;check if we are working with spin states
  working_with_ref_m_batch = (*global).working_with_ref_m_batch
  if (working_with_ref_m_batch) then begin
    spins = (*(*global).list_of_spins_for_each_angle)
  endif else begin
    spins = ['']
  endelse
  
  scaled_uname = 'scaled_data_file_name_value_'
  combined_scaled_uname = 'combined_scaled_data_file_name_value_'
  
  nbr_spins = n_elements(spins)
  scaled = value
  combined_scaled = value
  index = 0
  while (index lt nbr_spins) do begin
    if (spins[index] ne '') then begin
      local_scaled = scaled + '_' + spins[index] + ext
      putTextFieldValue, event, $
        scaled_uname + strcompress(index,/remove_all), $
        local_scaled[0]
      putTextFieldValue, event, 'scaled_data_spin_state_' + $
        strcompress(index,/remove_all), spins[index] + ':'
      local_combined_scaled = combined_scaled + '_combined' + spins[index] + ext
      putTextFieldValue, event, combined_scaled_uname + $
        strcompress(index,/remove_all), local_combined_scaled[0]
      putTextFieldValue, event, 'combined_scaled_data_spin_state_' + $
        strcompress(index,/remove_all), spins[index] + ':'
    endif else begin
      local_scaled = scaled + ext
      putTextFieldValue, event, scaled_uname + strcompress(index,/remove_all), $
        local_scaled[0]
      local_combined_scaled = combined_scaled + '_combined' + ext
      putTextFieldValue, event, combined_scaled_uname + $
        strcompress(index,/remove_all), local_combined_scaled[0]
    endelse
    
    index++
  endwhile
  
  ;this routine will check if we can enabled or not the preview buttons
  check_previews_button, event
  
end

;+
; :Description:
;   This procedure will enables or not the preview button on the right of the
;   scaled and combined scaled data file name
;
; :Params:
;    event
;
; :Author: j35
;-
pro check_previews_button, event
  compile_opt idl2
  
  path = getButtonValue(event,'output_path_button')
  
  scaled_uname = 'scaled_data_file_name_value_'
  combined_scaled_uname = 'combined_scaled_data_file_name_value_'
  
  for i=0,3 do begin
    index = strcompress(i,/remove_all)
    
    scaled = getTextFieldValue(event,scaled_uname+index)
    full_scaled = path + scaled
    if (file_test(full_scaled)) then begin
      status = 1
    endif else begin
      status = 0
    endelse
    ActivateWidget, Event, 'scaled_data_file_preview_' + index, status
    
    combined_scaled = getTextFieldValue(event,combined_scaled_uname+index)
    full_scaled = path + scaled
    if (file_test(full_scaled)) then begin
      status = 1
    endif else begin
      status = 0
    endelse
    ActivateWidget, Event, 'combined_scaled_data_file_preview_' + index, status
    
  endfor
  
end

;+
; :Description:
;   will used the xdisplayfile and show the contain of the scaled data file
;
; :Params:
;    event
;    index
;
; :Author: j35
;-
pro preview_of_scaled_data_file, event, index
  compile_opt idl2
  
  index = strcompress(index,/remove_all)
  file_name = getTextFieldValue(event, 'scaled_data_file_name_value_' + index)
  preview_of_file, event, file_name[0]
  
end

;+
; :Description:
;   will used the xdisplayfile and show the contain of the combined
;   scaled data file
;
; :Params:
;    event
;    index
;
; :Author: j35
;-
pro preview_of_combined_scaled_data_file, event, index
  compile_opt idl2
  
  index = strcompress(index,/remove_all)
  file_name = getTextFieldValue(event, $
    'combined_scaled_data_file_name_value_' + index)
  preview_of_file, event, file_name[0]
  
end

;+
; :Description:
;   using xdisplayfile, display preview of file name
;
; :Params:
;    event
;    file_name
;
; :Author: j35
;-
pro preview_of_file, event, file_name
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  path = (*global).BatchDefaultPath
  file_name = path + file_name
  id = widget_info(event.top,find_by_uname='MAIN_BASE_ref_scale')
  xdisplayfile, file_name, group=id,$
    title = 'Preview of ' + file_name, $
    /center
    
end

;******************************************************************************
;this function create the output file name
;if CE file name is REF_L_2893.txt
;the output file name will be: REF_L_2893_CE_scaling.txt
FUNCTION createOuputFileName, Event
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control,id,get_uvalue=global
  
  ;full_CE_name = (*global).full_CE_name
  ;dir_name = file_dirname(full_CE_name,/mark_directory)
  
  instrument = (*global).instrument
  
  table = getValue(event=event, uname='ref_scale_batch_table_widget')
  CE = table[1,0]
  
  time_stamp = RefScale_GenerateIsoTimeStamp()
  
  output_file_name = instrument + '_' + CE + '_' + $
  time_stamp + '_scaled'

;  ;remove the .txt extension
;  full_ce_name_1 = strsplit(base_name,'.txt',/regex,/extract)
  
;  ;add '_CE_scalling.txt'
;  output_file_name = full_ce_name_1[0] + '_scaled
  
  RETURN, output_file_name
END

;******************************************************************************

;This function create the output file
PRO createOutputFile, Event, output_file_name, MasterText

  ;size of MasterText
  MasterTextSize = (size(MasterText))(1)
  
  openw, 1, output_file_name
  
  for i=0,(MasterTextsize-1) do begin
    printf, 1,MasterText[i]
  endfor
  
  close, 1
  free_lun, 1
  
END

;^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*

;Main function that will produce and display the output file.
PRO ProduceOutputFile, Event
  compile_opt idl2
  
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control, id, get_uvalue=global
  
  ;check first that if user wants to send the output by email, an email
  ;has been set up
  if (getButtonValidated(event,'send_by_email_output') eq 0) then begin
    if ((*global).email eq '') then begin
      message_text = ['Please define an email address (email output setup...)',$
        'or turn off email output!','',$
        'Info: Output files have not been created!']
      title = 'email address unknown!'
      result = dialog_message(message_text,$
        /information,$
        title = title,$
        /center,$
        dialog_parent = id)
      return
    endif
  endif
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  idl_send_to_geek_addLogBookText, Event, '> Create Output File Array :'
  
  ;text string to output
  MasterText = ''
  
  ;get scaled output file name
  outputFileName = getOutputFileName(Event)
  ;get combined scaled output file name
  combinedOutputFileName = getCombinedOutputFileName(event)
  
  ;make sure the user has write access there
  file_path = FILE_DIRNAME(outputFileName)
  IF (FILE_TEST(file_path,/directory,/write)) THEN BEGIN
    idl_send_to_geek_addLogBookText, Event, $
      '-> Does user has write access to this directory ... YES'
      
    idl_send_to_geek_addLogBookText, Event, '-> Output File Name : ' + $
      outputFileName
      
    ;metadata of the CE file
    metadata_CE_file = (*global).metadata_CE_file
    MasterText += *metadata_CE_file[0]
    
    ;remove first blank line
    MasterText = MasterText[1:*]
    
    ;get the number of files to print out
    nbrFiles = getNbrElementsInDroplist(Event, 'list_of_files_droplist') ;_get
    idl_send_to_geek_addLogBookText, Event, '-> Number Of files : ' + $
      STRCOMPRESS(nbrFiles,/REMOVE_ALL)
      
    ;get list of files
    list_of_files = (*(*global).list_of_files)
    
    ;get global object of data of interest
    flt0_ptr = (*global).flt0_rescale_ptr
    flt1_ptr = (*global).flt1_rescale_ptr
    flt2_ptr = (*global).flt2_rescale_ptr
    
    ;resolution function
    resolution_function_flag = (*global).resolution_function_switch_flag
    dq_over_q = (*global).dq_over_q
    dq0 = (*global).dq0
    
    ;calculate in first loop how many data point total we have
    nbr_data_point = 0
    full_flt0 = fltarr(1)
    full_flt1 = fltarr(1)
    full_flt2 = fltarr(1)
    
    _axis_label = '#Q(Angstroms^-1) R SigmaR '
    if (resolution_function_flag) then begin
      _axis_label += 'Resolution_function'
    endif
    masterText = [masterText, _axis_label]
    full_master_text = [MasterText,'']
    
    ;loop over all the files to get output
    for i=0,(nbrFiles-1) do begin
    
      ;add a blank line before all data
      MasterText   = [MasterText,'']
      
      ;get name of file first
      fileName     = list_of_files[i]
      TextFileName = '## ' + fileName + '##'
      MasterText   = [MasterText,TextFileName]
      full_master_text = [full_master_text,TextFileName]
      
      idl_send_to_geek_addLogBookText, Event, '-> Working with File # ' + $
        STRCOMPRESS(i,/REMOVE_ALL) + ' (' + fileName + ')'
        
      ;add the value of the angle (in degree)
      angle_array  = (*(*global).angle_array)
      angle_value  = angle_array[i]
      TextAngle    = '#Incident angle: ' + strcompress(angle_value)
      TextAngle   += ' degrees'
      MasterText   = [MasterText,TextAngle]
      full_master_text = [full_master_text,TextAngle]
      
      ;retrieve flt0, flt1 and flt2
      flt0 = *flt0_ptr[i]
      flt1 = *flt1_ptr[i]
      flt2 = *flt2_ptr[i]
      
      ;remove INF, -INF and NAN values from arrays
      index = getArrayRangeOfNotNanValues(flt1) ;_get
      flt0  = flt0[index]
      flt1  = flt1[index]
      flt2  = flt2[index]
      
      ;remove data where DeltaR>R
      index = GEvalue(flt1, flt2) ;_get
      flt0  = flt0[index]
      flt1  = flt1[index]
      flt2  = flt2[index]
      
      if (i eq 0) then begin
        full_flt0 = flt0
        full_flt1 = flt1
        full_flt2 = flt2
      endif else begin
        full_flt0 = [full_flt0,flt0]
        full_flt1 = [full_flt1,flt1]
        full_flt2 = [full_flt2,flt2]
      endelse
      
      flt0Size = (size(flt0))[1]
      nbr_data_point += flt0Size
      FOR j=0,(flt0Size-1) DO BEGIN
        TextData = strcompress(flt0[j])
        TextData += ' '
        TextData += strcompress(flt1[j])
        TextData += ' '
        TextData += strcompress(flt2[j])
        
        ;add a 4th column with resolution function term
        if (resolution_function_flag) then begin
          _value = dq0 + dq_over_q * float(flt0[j])
          TextData += ' ' + strcompress(_value,/remove_all)
        endif
        
        MasterText = [MasterText,TextData]
      ENDFOR
      
    ENDFOR
    
    idl_send_to_geek_addLogBookText, Event, '> Producing output file ... ' + $
      PROCESSING
    output_error = 0
    file_created_status = 1
    CATCH, output_error
    IF (output_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, FAILED
      ActivateWidget, Event, 'scaled_data_file_preview_0', 0
      file_created_status = 0
    ENDIF ELSE BEGIN
      ;create output file name
      createOutputFile, Event, outputFileName, MasterText ;_produce_output
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, OK
      ActivateWidget, Event, 'scaled_data_file_preview_0', 1
    ENDELSE
    idl_send_to_geek_showLastLineLogBook, Event
    
    ;--------------------------------------------------------------------------
    ;working with combined data file now
    idl_send_to_geek_addLogBookText, Event, + $
      '-> Combined Output File Name : ' + $
      CombinedoutputFileName
      
    ;sort the data
    flt0_sorted_index = sort(full_flt0)
    full_flt0_sorted = full_flt0[flt0_sorted_index]
    full_flt1_sorted = full_flt1[flt0_sorted_index]
    full_flt2_sorted = full_flt2[flt0_sorted_index]
    
    ;average overlap data values
    run_average_overlap, event, $
      full_flt0_sorted, $
      full_flt1_sorted, $
      full_flt2_sorted, $
      method='new'
      
    sz = n_elements(full_flt0_sorted)
    data_text = strarr(1)
    for i=0l,(sz-1) do begin
      local_data_text = strcompress(full_flt0_sorted[i],/remove_all)
      local_data_text += ' ' + strcompress(full_flt1_sorted[i],/remove_all)
      local_data_text += ' ' + strcompress(full_flt2_sorted[i],/remove_all)
      
      ;add a 4th column with resolution function term
      if (resolution_function_flag) then begin
        _value = dq0 + dq_over_q * float(full_flt0_sorted[i])
        local_data_text += ' ' + strcompress(_value,/remove_all)
      endif
      
      data_text = [data_text,local_data_text]
    endfor
    MasterText = [full_master_text, data_text]
    
    idl_send_to_geek_addLogBookText, Event, '> Producing output file ... ' + $
      PROCESSING
    output_error = 0
    combined_file_created_status = 1
    CATCH, output_error
    IF (output_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, FAILED
      ActivateWidget, Event, 'combined_scaled_data_file_preview_0', 0
      combined_file_created_status = 0
    ENDIF ELSE BEGIN
      ;create output file name
      createOutputFile, Event, CombinedoutputFileName, MasterText ;_produce_output
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, OK
      ActivateWidget, Event, 'combined_scaled_data_file_preview_0', 1
    ENDELSE
    idl_send_to_geek_showLastLineLogBook, Event
    
    ;send output files by email
    result1 = 0
    result2 = 0
    result_send_email = 0
    list_file = strarr(1)
    if (getButtonValidated(event,'send_by_email_output') eq 0) then begin
      ;if (file_created_status eq 1) then begin
      ;  list_file = [list_file,OutputFileName]
      ;  result1 = 1
      ;endif
      if (combined_file_created_status eq 1) then begin
        list_file = [list_file,CombinedOutputFileName]
        result2 = 1
      endif
      if (result2 GT 0) then begin
        result_send_email = send_files_by_email(event, list_file)
      endif
    endif
    
    ;inform the user that the files have been created (or not)
    message_text = ['']
    file1 = outputFileName
    
    if (file_created_status eq 1) then begin
      file1 += ' ... OK'
    endif else begin
      file1 += ' ... FAILED'
    endelse
    file2 = CombinedoutputFileName
    if (combined_file_created_status eq 1) then begin
      file2 += ' ... OK'
    endif else begin
      file2 += ' ... FAILED'
    endelse
    message_text = [message_text,file1,file2]
    
    message_text = [message_text, '']
    if (result_send_email) then begin
      text = 'Combined output file sent to ' + (*global).email
      message_text = [message_text,text]
    endif
    
    title = 'Output File Status'
    result = dialog_message(message_text,$
      title = title,$
      /center,$
      dialog_parent = id,$
      /information)
      
  ENDIF ELSE BEGIN
    idl_send_to_geek_addLogBookText, Event, $
      '-> Does user has write access to this directory ... NO'
      
    message = 'You do not have enough privileges to write at this location'
    title   = 'Please change the output file directory'
    dialog_id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
    result = DIALOG_MESSAGE(message,$
      /ERROR,$
      /center,$
      dialog_parent=dialog_id,$
      TITLE = title)
  ENDELSE
  
END

;##############################################################################
;******************************************************************************
PRO update_output_file_name, Event ;_output
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL, id, GET_UVALUE=global
  Nbr = (*global).NbrFilesLoaded
  IF (Nbr EQ 1) THEN BEGIN
    FileName = createOuputFileName(Event)
    ;display the name of the output file name
    putValueInLabel, Event, $
      'output_short_file_name', $
      FileName            ;_put
    output_file_name_value, event
  ENDIF
END

;##############################################################################
;******************************************************************************
PRO update_output_file_name_from_batch, Event ;_output
  WIDGET_CONTROL, event.top, GET_UVALUE=global
  FileName = createOuputFileName(Event)
  ;display the name of the output file name
  putValueInLabel, Event, $
    'output_short_file_name', $
    FileName                      ;_put
  output_file_name_value, event
END
