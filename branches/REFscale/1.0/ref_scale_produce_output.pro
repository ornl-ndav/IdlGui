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
  
  value = getTextfieldValue(event,'output_short_file_name')
  ext = getTextFieldValue(event,'output_file_name_extension')
  
  scaled = value + ext
  combined_scaled = value + '_combined' + ext
  
  putTextFieldValue, event, 'scaled_data_file_name_value', scaled[0]
  putTextFieldValue, event, 'combined_scaled_data_file_name_value', $
    combined_scaled[0]
    
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
  scaled = getTextFieldValue(event,'scaled_data_file_name_value')
  combined_scaled = getTextFieldValue(event,$
    'combined_scaled_data_file_name_value')
    
  full_scaled = path + scaled
  if (file_test(full_scaled)) then begin
    status = 1
  endif else begin
    status = 0
  endelse
  ActivateWidget, Event, 'scaled_data_file_preview', status
  
  full_combined_scaled = path + combined_scaled
  if (file_test(full_combined_scaled)) then begin
    status = 1
  endif else begin
    status = 0
  endelse
  ActivateWidget, Event, 'combined_scaled_data_file_preview', status
  
end


;+
; :Description:
;   will used the xdisplayfile and show the contain of the scaled data file
;
; :Params:
;    event
;
; :Author: j35
;-
pro preview_of_scaled_data_file, event
  compile_opt idl2
  
  file_name = getTextFieldValue(event, 'scaled_data_file_name_value')
  preview_of_file, event, file_name[0]
  
end

;+
; :Description:
;   will used the xdisplayfile and show the contain of the combined
;   scaled data file
;
; :Params:
;    event
;
; :Author: j35
;-
pro preview_of_combined_scaled_data_file, event
  compile_opt idl2
  
  file_name = getTextFieldValue(event, 'combined_scaled_data_file_name_value')
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
  
  full_CE_name = (*global).full_CE_name
  base_name = file_basename(full_CE_name)
  
  ;remove the .txt extension
  full_ce_name_1 = strsplit(base_name,'.txt',/regex,/extract)
  
  ;add '_CE_scalling.txt'
  output_file_name = full_ce_name_1[0] + '_scaled
  
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
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  widget_control, id, get_uvalue=global
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  idl_send_to_geek_addLogBookText, Event, '> Create Output File Array :'
  
  ;text string to output
  MasterText = ''
  
  ;get output file name
  outputFileName = getOutputFileName(Event)
  
    idl_send_to_geek_addLogBookText, Event, '-> Output File Name : ' + $
    outputFileName
    
  ;make sure the user has write access there
  file_path = FILE_DIRNAME(outputFileName)
  IF (FILE_TEST(file_path,/directory,/write)) THEN BEGIN
    idl_send_to_geek_addLogBookText, Event, $
      '-> Does user has write access to this directory ... YES'
      
    ;metadata of the CE file
    metadata_CE_file = (*(*global).metadata_CE_file)
    MasterText += metadata_CE_file
    
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
    
    ;loop over all the files to get output
    for i=0,(nbrFiles-1) do begin
    
      ;add a blank line before all data
      MasterText   = [MasterText,'']
      
      ;get name of file first
      fileName     = list_of_files[i]
      TextFileName = '## ' + fileName + '##'
      MasterText   = [MasterText,TextFileName]
      
      idl_send_to_geek_addLogBookText, Event, '-> Working with File # ' + $
        STRCOMPRESS(i,/REMOVE_ALL) + ' (' + fileName + ')'
        
      ;add the value of the angle (in degree)
      angle_array  = (*(*global).angle_array)
      angle_value  = angle_array[i]
      TextAngle    = '#Incident angle: ' + strcompress(angle_value)
      TextAngle   += ' degrees'
      MasterText   = [MasterText,TextAngle]
      
      ;retrieve flt0, flt1 and flt2
      flt0 = *flt0_ptr[i]
      flt1 = *flt1_ptr[i]
      flt2 = *flt2_ptr[i]
      
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
      
      flt0Size = (size(flt0))(1)
      FOR j=0,(flt0Size-1) DO BEGIN
        TextData = strcompress(flt0[j])
        TextData += ' '
        TextData += strcompress(flt1[j])
        TextData += ' '
        TextData += strcompress(flt2[j])
        MasterText = [MasterText,TextData]
      ENDFOR
      
    ENDFOR
    
    idl_send_to_geek_addLogBookText, Event, '> Producing output file ... ' + $
      PROCESSING
    output_error = 0
    CATCH, output_error
    IF (output_error NE 0) THEN BEGIN
      CATCH,/CANCEL
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, FAILED
    ;      ActivateWidget, Event, 'preview_output_file_button', 0
    ENDIF ELSE BEGIN
      ;create output file name
      createOutputFile, Event, outputFileName, MasterText ;_produce_output
      idl_send_to_geek_ReplaceLogBookText, Event, PROCESSING, OK
    ;      ActivateWidget, Event, 'preview_output_file_button', 1
    ENDELSE
    idl_send_to_geek_showLastLineLogBook, Event
    
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
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL, id, GET_UVALUE=global
  FileName = createOuputFileName(Event)
  ;display the name of the output file name
  putValueInLabel, Event, $
    'output_short_file_name', $
    FileName                      ;_put
  output_file_name_value, event
END

;##############################################################################
;******************************************************************************
PRO ref_scale_produce_output
END
