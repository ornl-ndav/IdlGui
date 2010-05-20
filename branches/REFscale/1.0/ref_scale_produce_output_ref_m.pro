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

pro ProduceOutputFile_ref_m, Event

  widget_control, event.top, get_uvalue=global
  
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
  
  list_of_spins_for_each_angle = (*(*global).list_of_spins_for_each_angle)
  nbr_spins = n_elements(list_of_spins_for_each_angle)
  
  scaled_uname = 'scaled_data_file_name_value_'
  combined_scaled_uname = 'combined_scaled_data_file_name_value_'
  path = getButtonValue(event,'output_path_button')
  
  ;make sure the user has write access there
  if (not(file_test(path[0],/directory,/write))) then begin
    idl_send_to_geek_addLogBookText, Event, $
      '-> Does user has write access to this directory ... NO'
    message = 'You do not have enough privileges to write at this location'
    title   = 'Please change the output file directory'
    dialog_id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
    result = dialog_message(message,$
      /ERROR,$
      /center,$
      dialog_parent=dialog_id,$
      TITLE = title)
    return
  endif else begin
    idl_send_to_geek_addLogBookText, Event, $
      '-> Does user has write access to this directory ... YES'
  endelse
  
  ;get list of files
  DRfiles = (*(*global).DRfiles)
  
  file_created_status = intarr(nbr_spins)
  combined_file_created_status = intarr(nbr_spins)
  
  ;metadata of the CE file
  metadata_CE_file = (*global).metadata_CE_file
  
  index_spin = 0
  while (index_spin lt nbr_spins) do begin
  
    MasterText = *metadata_CE_file[index_spin]
    
    s_index_spin = strcompress(index_spin,/remove_all)
    local_scaled_uname = scaled_uname + s_index_spin
    outputFileName = getTextFieldValue(event,local_scaled_uname)
    outputFileName = path[0] + outputFileName[0]
    
    local_combined_scaled_uname = combined_scaled_uname + s_index_spin
    combinedOutputFileName = getTextFieldValue(event,$
      local_combined_scaled_uname)
    combinedOutputFileName = path[0] + combinedOutputFileName[0]
    
    idl_send_to_geek_addLogBookText, event, '-> Working with spin state ' + $
      list_of_spins_for_each_angle[index_spin]
      
    idl_send_to_geek_addLogBookText, Event, '--> Output File Name : ' + $
      outputFileName
      
    ;get list of files
    list_of_files = DRfiles[index_spin,*]
    nbrFiles = n_elements(list_of_files)
    
    ;get global object of data of interest
    flt0_ptr = (*global).flt0_rescale_ptr
    flt1_ptr = (*global).flt1_rescale_ptr
    flt2_ptr = (*global).flt2_rescale_ptr
    
    ;calculate in first loop how many data point total we have
    nbr_data_point = 0
    full_flt0 = fltarr(1)
    full_flt1 = fltarr(1)
    full_flt2 = fltarr(1)
    full_master_text = [MasterText,'']
    
    ;loop over all the files to get output
    for i=0,(nbrFiles-1) do begin
    
      ;add a blank line before all data
      MasterText   = [MasterText,'']
      
      ;get name of file first
      fileName     = list_of_files[i]
      TextFileName = '## ' + fileName + '##'
      MasterText   = [MasterText,TextFileName]
      full_master_text  = [full_master_text,TextFileName]
      
      idl_send_to_geek_addLogBookText, Event, '--> Working with File # ' + $
        STRCOMPRESS(i,/REMOVE_ALL) + ' (' + fileName + ')'
        
      ;add the value of the angle (in degree)
      angle_array  = (*(*global).angle_array)
      angle_value  = angle_array[i]
      TextAngle    = '#Incident angle: ' + strcompress(angle_value)
      TextAngle   += ' degrees'
      MasterText   = [MasterText,TextAngle]
      full_master_text = [full_master_text,TextAngle]
      
      ;retrieve flt0, flt1 and flt2
      flt0 = *flt0_ptr[i,index_spin]
      flt1 = *flt1_ptr[i,index_spin]
      flt2 = *flt2_ptr[i,index_spin]
      
      ;remove INF, -INF and NAN values from arrays
      index = getArrayRangeOfNotNanValues(flt1) ;_get
      flt0  = flt0(index)
      flt1  = flt1(index)
      flt2  = flt2(index)
      
      ;remove data where DeltaR>R
      index = GEvalue(flt1, flt2) ;_get
      flt0  = flt0(index)
      flt1  = flt1(index)
      flt2  = flt2(index)
      
      if (i eq 0) then begin
        full_flt0 = flt0
        full_flt1 = flt1
        full_flt2 = flt2
      endif else begin
        full_flt0 = [full_flt0,flt0]
        full_flt1 = [full_flt1,flt1]
        full_flt2 = [full_flt2,flt2]
      endelse
      
      flt0Size = (size(flt0))(1)
      nbr_data_point += flt0Size
      FOR j=0,(flt0Size-1) DO BEGIN
        TextData = strcompress(flt0[j])
        TextData += ' '
        TextData += strcompress(flt1[j])
        TextData += ' '
        TextData += strcompress(flt2[j])
        MasterText = [MasterText,TextData]
      ENDFOR
      
    ENDFOR ;loop over all the files for a given spin
    
    idl_send_to_geek_addLogBookText, Event, '--> Producing output file ... ' + $
      PROCESSING
    output_error = 0
    catch, output_error
    if (output_error NE 0) THEN BEGIN
      catch, /cancel
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, FAILED
      file_created_status[index_spin] = 0
    endif else begin
      ;create output file name
      ;remove first row of MasterText
      MasterText = MasterText[1:*]
      createOutputFile, Event, outputFileName, MasterText ;_produce_output
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, OK
      file_created_status[index_spin] = 1
    endelse
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
    average_overlap, full_flt0_sorted, full_flt1_sorted, full_flt2_sorted
    
    sz = n_elements(full_flt0_sorted)
    data_text = strarr(1)
    for i=0l,(sz-1) do begin
      local_data_text = strcompress(full_flt0_sorted[i],/remove_all)
      local_data_text += ' ' + strcompress(full_flt1_sorted[i],/remove_all)
      local_data_text += ' ' + strcompress(full_flt2_sorted[i],/remove_all)
      data_text = [data_text,local_data_text]
    endfor
    MasterText = [full_master_text, data_text]
    
    idl_send_to_geek_addLogBookText, Event, '-> Producing output file ... ' + $
      PROCESSING
    output_error = 0
    CATCH, output_error
    IF (output_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, FAILED
      ;      ActivateWidget, Event, 'combined_scaled_data_file_preview', 0
      combined_file_created_status[index_spin] = 0
    ENDIF ELSE BEGIN
      ;create output file name
      MasterText = MasterText[1:*]
      createOutputFile, Event, CombinedoutputFileName, MasterText ;_produce_output
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, OK
      ;      ActivateWidget, Event, 'combined_scaled_data_file_preview', 1
      combined_file_created_status[index_spin] = 1
    ENDELSE
    idl_send_to_geek_showLastLineLogBook, Event
    
    index_spin++
  endwhile
  
  catch,/cancel
  
  ;send output files by email
  result1 = 0
  result2 = 0
  result_send_email = 0
  list_file = strarr(1)
  if (getButtonValidated(event,'send_by_email_output') eq 0) then begin
    if (total(file_created_status) gt 0) then begin
      for i=0,(nbr_spins-1) do begin
        OutputfileName = getOutputfileName_of_index(event,i)
        if (file_created_status[i]) then begin
          list_file = [list_file, outputFileName]
          result1 = 1
        endif
      endfor
    endif
    
    if (total(combined_file_created_status) gt 0) then begin
      for i=0,(nbr_spins-1) do begin
        OutputfileName = getCombinedOutputfileName_of_index(event,i)
        if (file_created_status[i]) then begin
          list_file = [list_file, outputFileName]
          result2 = 1
        endif
      endfor
    endif
    
    if (result2 + result1 GT 0) then begin
      result_send_email = send_files_by_email(event, list_file)
    endif
  endif
  
  title = 'Output File Status'
  message_text = ['Output Files created!']
  if (result2 + result1 GT 0) then begin
    message_text = [message_text,$
    'Files sent to ' + (*global).email]
  endif
  id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
  result = dialog_message(message_text,$
    title = title,$
    /center,$
    dialog_parent = id,$
    /information)
    
END
