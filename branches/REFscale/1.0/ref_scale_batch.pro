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

;This function creates the SF array when loading the batch file, and
;populate the angle values in the same time.
PRO create_SF_array, Event
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,GET_UVALUE=global
  BatchTable       = (*(*global).BatchTable)
  NbrRowMax        = (SIZE(batchTable))(2)
  index            = 0
  SF_array         = FLTARR(1)
  angle_array      = FLTARR(1)
  FOR i=0,(NbrRowMax-1) DO BEGIN
    IF (BatchTable[0,i] EQ 'YES') THEN BEGIN
      IF (index EQ 0) THEN BEGIN
        SF_array[0] = BatchTable[8,i]
        angle_array[0] = BatchTable[4,i]
      ENDIF ELSE BEGIN
        SF_array = [SF_array,BatchTable[8,i]]
        angle_array = [angle_array,BatchTable[4,i]]
      ENDELSE
      index++
    ENDIF
  ENDFOR
  (*(*global).SF_array)    = SF_array
  (*(*global).angle_array) = angle_array
END

;==============================================================================
PRO apply_sf_to_data, Event, DRfiles,  spin_state_nbr=spin_state_nbr

  widget_control, event.top, GET_UVALUE=global
  
  BatchTable       = (*(*global).BatchTable)
  NbrRowMax        = (size(batchTable))(2)
  flt0_ptr         = (*global).flt0_ptr
  flt1_ptr         = (*global).flt1_ptr
  flt2_ptr         = (*global).flt2_ptr
  flt1_rescale_ptr = (*global).flt1_rescale_ptr
  flt2_rescale_ptr = (*global).flt2_rescale_ptr
  flt_index        = 0
  
  nbr_files = (size(DRfiles))[1]
  
  index_nbr_files = 0
  while (index_nbr_files lt nbr_files) do begin
    SF_value = BatchTable[8,index_nbr_files]
    if (SF_value eq '') then begin
      index_nbr_files++
      continue
    endif else begin
      sf = float(SF_value)
    endelse
    
    if (n_elements(spin_state_nbr) ne 0) then begin
    
      flt1 = *flt1_ptr[index_nbr_files, spin_state_nbr]
      flt2 = *flt2_ptr[index_nbr_files, spin_state_nbr]
      
    endif else begin
    
      flt1 = *flt1_ptr[index_nbr_files]
      flt2 = *flt2_ptr[index_nbr_files]
      
    endelse
    
    ;rescale data
    flt1 /= SF
    flt2 /= SF
    
    if (n_elements(spin_state_nbr) ne 0) then begin
    
      *flt1_rescale_ptr[index_nbr_files, spin_state_nbr] = flt1
      *flt2_rescale_ptr[index_nbr_files, spin_state_nbr] = flt2
      
    endif else begin
    
      *flt1_rescale_ptr[index_nbr_files] = flt1
      *flt2_rescale_ptr[index_nbr_files] = flt2
      
    endelse
    
    index_nbr_files++
  endwhile
  
;(*global).flt1_rescale_ptr = flt1_rescale_ptr
;(*global).flt2_rescale_ptr = flt2_rescale_ptr
;(*global).flt1_rescale_ptr = flt1
;(*global).flt2_rescale_ptr = flt2
  
END

;==============================================================================
FUNCTION retrieveDRfiles, Event, BatchTable
  ;Get Nbr of non-empty rows
  NbrRow         = getGlobalVariable('NbrRow')
  NbrRowNotEmpty = 0
  NbrDrFiles     = 0
  FOR i=0,(NbrRow-1) DO BEGIN
    IF (BatchTable[1,i] NE '') THEN BEGIN
      ++NbrRowNotEmpty
      IF (BatchTable[0,i] EQ 'YES') THEN BEGIN
        ++NbrDrFiles
      ENDIF
    ENDIF
  ENDFOR
  
  ;Create array of list of files
  DRfiles = STRARR(NbrDrFiles)
  ;get for each row the path/output_file_name
  j=0
  FOR i=0,(NbrRowNotEmpty-1) DO BEGIN
    iRow = OBJ_NEW('idl_parse_command_line',BatchTable[9,i])
    IF (BatchTable[0,i] EQ 'YES') THEN BEGIN
      outputPath     = iRow->getOutputPath()
      outputFileName = iRow->getOutputFileName()
      DRfiles[j++] = outputPath + outputFileName
    ENDIF
    obj_destroy, iRow
  ENDFOR
  RETURN,DRfiles
END

;==============================================================================
;This function put the BatchTable in the table of the Batch Tab
PRO DisplayBatchTable, Event, NewTable
  ;new BatchTable
  NewBatchTable = NewTable
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='ref_scale_batch_table_widget')
  WIDGET_CONTROL, id, SET_VALUE=NewBatchTable
END

;This function retrieves from the big BatchTable, only the information
;that will be displayed in the table of the Batch tab
;==============================================================================
PRO UpdateBatchTable, Event, BatchTable
  ;display information from column 2/3/8/7 (in this order)
  NewTable = STRARR(5,20)
  NewTable[0,*] = BatchTable[0,*]
  NewTable[1,*] = BatchTable[1,*]
  NewTable[2,*] = BatchTable[2,*]
  NewTable[3,*] = BatchTable[8,*]
  NewTable[4,*] = BatchTable[7,*]
  ;repopulate Table
  DisplayBatchTable, Event, NewTable
END

;==============================================================================
;This function reset the batch table
PRO ResetBatch, Event
  NewTable = STRARR(5,20)
  ;repopulate Table
  DisplayBatchTable, Event, NewTable
  ;reset batch file name loaded
  putValueInTextField, Event, 'load_batch_file_text_field', ''
END

;==============================================================================
;This function checks if all the output data reduction file exist or not
FUNCTION CheckFilesExist, Event, DRfiles
  sz = (SIZE(DRfiles))(1)
  LogText = '-> Check if all Intermediate files exist or not:'
  idl_send_to_geek_addLogBookText, Event, LogText
  file_status = 1
  FOR i=0,(sz-1) DO BEGIN
    IF(FILE_TEST(DRfiles[i])) THEN BEGIN
      LogText = '--> ' + DRfiles[i] + ' ... FOUND'
    ENDIF ELSE BEGIN
      LogText = '--> ' + DRfiles[i] + ' ... NOT FOUND !!'
      file_status = 0
    ENDELSE
    idl_send_to_geek_addLogBookText, Event, LogText
  ENDFOR
  RETURN, file_status
END

;+
; :Description:
;    checks if the user does not try to add more than 1 time the same ascii
;    file. If it does, the program complains and the loading process will
;    stop there
;
; :Params:
;    event
;    DRfiles

; :Author: j35
;-
function checkFilesUniq, event, DRfiles
  compile_opt idl2
  
  help, DRfiles
  
  return, 0
  
end


;+
; :Description:
;   checks if all the file exist and return 1 in this case. 0 otherwise
;
; :Params:
;    Event
;    DRfiles
;
; :Author: j35
;-
function CheckFilesExist_ref_m, Event, DRfiles
  compile_opt idl2
  
  LogText = '-> Check if all Intermediate files exist or not:'
  file_status = 1
  
  sz1 = (size(DRfiles))[1]
  sz2 = (size(DRfiles))[2]
  index2 = 0
  while (index2 lt sz2) do begin
    index1 = 0
    while (index1 lt sz1) do begin
      if (file_test(DRfiles[index1,index2])) then begin
        LogText = '--> ' + DRfiles[index1,index2] + '... FOUND'
      endif else begin
        LogText = '--> ' + DRfiles[index1,index2] + '... NOT FOUND!!'
        file_status = 0
      endelse
      idl_send_to_geek_addLogBookText, Event, LogText
      index1++
    endwhile
    index2++
  endwhile
  
  return, file_status
end

;+
; :Description:
;   This functions checks if the list of files is uniq.
;
; :Params:
;    event
;    DRfiles
;
; :Author: j35
;-
function CheckFileUniq, event, DRfiles
  compile_opt idl2
  
  nbr_files = n_elements(DRfiles)
  
  if (nbr_files eq 1) then begin
    display_error_message, Event, type='1file'
    return, 0
  endif
  
  uniq_array = DRfiles[uniq(DRfiles, sort(DRfiles))]
  nbr_uniq = n_elements(uniq_array)
  if (nbr_uniq ne nbr_files) then begin
    display_error_message, event, type='not_uniq'
    return, 0
  endif
  
  return, 1
end

;+
; :Description:
;   This procedure pops up a personalize dialog_message according to the
;   type given
;
; :Params:
;    event
;
; :Keywords:
;    type
;
; :Author: j35
;-
pro display_error_message, event, type=type
  compile_opt idl2
  
  id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
  
  case (type) of
    '1file': message = 'Batch file contains only 1 ascii file to load!'
    'not_uniq': message = 'Batch file contains several times the same ascii file!'
  endcase
  
  result = dialog_message(message,$
    /error,$
    /center,$
    dialog_parent=id,$
    title='Loading Error!')
    
end

;==============================================================================
function batch_repopulate_gui, Event, DRfiles, spin_state_nbr=spin_state_nbr

  widget_control, event.top, GET_UVALUE=global
  
  ;retrieve parameters
  (*global).NbrFilesLoaded = 0
  loading_error            = 0
  
  ;Nbr of files to load
  sz = (SIZE(DRfiles))(1)
  
  for i=0,(sz-1) do begin ;loop over number of files
  
    index = (*global).NbrFilesLoaded
    SuccessStatus = StoreFlts(Event, $
      DRfiles[i], i, $
      spin_state_nbr=spin_state_nbr)
      
      print, spin_state_nbr
      
    if (SuccessStatus) then begin
    
      ShortFileName = get_file_name_only(DRfiles[i]) ;_get
      LongFileName  = DRfiles[i]
      
      ;apply auto cleanup of data if switch is on
      if ((*global).settings_auto_cleaning_flag) then begin ;apply auto cleanup
        cleanup_reduce_data, event, file_name = LongFileName
        ;re-read the data from fresh cleanup file
        SuccessStatus = StoreFlts(Event, DRfiles[i], i)
      endif
      
      ;add list of files for only first spin state
      if (n_elements(spin_state_nbr) ne 0 and $
        spin_state_nbr eq 0) then begin
        AddNewFileToDroplist, Event, ShortFileName, LongFileName ;_Gui
      endif
      
    endif else begin
    
      loading_error = 1
      break ;leave the for loop
      
    endelse
    
  endfor
  
  if (loading_error EQ 0) then begin
  
    ;for REF_L or first REF_M spin state
  
    if (spin_state_nbr eq 0) then begin
    
      ;define color_array
      index_array = getIndexArrayOfActiveBatchRow(Event)
      sz          = (SIZE(index_array))(1)
      color_array = (FLOAT(225)/sz)*INDGEN(sz)+25
      (*(*global).color_array) = color_array
      ;reset Qmin and Qmax
      (*(*global).Qmin_array) = FLTARR(sz)
      (*(*global).Qmax_array) = FLTARR(sz)
      
      ;create SF_array
      create_SF_array, Event
      
      ;if there is already a SF, apply it
      BatchTable = (*(*global).BatchTable)
      SF_value_0 = BatchTable[8,0]
      if (SF_value_0 ne '') then begin
      
        ;apply the SF to the data
        apply_sf_to_data, Event, DRfiles,  spin_state_nbr=spin_state_nbr
        ;plot all loaded files
        PlotLoadedFiles, Event      ;_Plot
        ;force the axis to start at 0
        putValueInTextField, Event,'XaxisMinTextField', $
          strcompress(0,/remove_all)
        putValueInTextField, Event,'YaxisMinTextField', $
          strcompress(0.000001,/remove_all)
        putValueInTextField, Event,'YaxisMaxTextField', $
          strcompress(2,/remove_all)
        plot_loaded_file, Event, 'all' ;_Plot
        
      endif else begin ;perform scaling ourselves
      
        auto_full_scaling_from_batch_file, Event
        
      endelse
      
    endif ;end of >>> if(spin_state_nbr) eq 0
    
    ;for REF_M other spin states
    if (spin_state_nbr gt 0) then begin
      ;apply the SF to the data
      apply_sf_to_data, Event, DRfiles,  spin_state_nbr=spin_state_nbr
    endif
    
    ;activate step2
    (*global).force_activation_step2 = 1
    ;activate step3
    ActivateStep3_fromBatch, Event, 1
    return, 1
    
  endif else begin
  
      (*global).force_activation_step2 = 0
      ActivateStep3_fromBatch, Event, 0
      reset_all_button, Event
      return, 0
    
  endelse
    
END

;==============================================================================
PRO ref_scale_PreviewBatchFile, Event
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,GET_UVALUE=global
  ;retrieve BatchFileName
  BatchFileName = getBatchFileName(Event)
  XDISPLAYFILE, BatchFileName, $
    TITLE='Preview of ' + BatchFileName, $
    /center, $
    group=id
END

;==============================================================================
PRO ref_scale_refresh_batch_file, Event
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  LogText = '> Refresh Batch File:'
  idl_send_to_geek_addLogBookText, Event, LogText
  BatchFileName = (*global).BatchFileName
  LogText = '-> Batch File Name: ' + BatchFileName
  idl_send_to_geek_addLogBookText, Event, LogText
  
  iFile = OBJ_NEW('idl_create_batch_file', $
    Event, $
    BatchFileName, $
    (*(*global).BatchTable))
    
END

;==============================================================================
PRO ref_scale_save_as_batch_file, Event
  id=WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
  WIDGET_CONTROL,id,GET_UVALUE=global
  
  path            = (*global).BatchDefaultPath
  filter          = (*global).BatchDefaultFileFilter
  new_path        = ''
  batch_extension = (*global).BatchExtension
  
  dialog_id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
  BatchFileName   = DIALOG_PICKFILE(FILTER            = filter,$
    GET_PATH          = new_path,$
    PATH              = path,$
    DEFAULT_EXTENSION = batch_extension,$
    dialog_parent     = dialog_id,$
    /OVERWRITE_PROMPT,$
    /WRITE)
    
  IF (BatchFileName NE '') THEN BEGIN
    LogText = '> Save Batch File:'
    idl_send_to_geek_addLogBookText, Event, LogText
    (*global).BatchFileName = BatchFileName
    LogText = '-> Batch File Name: ' + BatchFileName
    idl_send_to_geek_addLogBookText, Event, LogText
    ;put new name of BatchFile in LoadBatchFile text field
    putValueInTextField, Event, 'load_batch_file_text_field', BatchFileName
    ;Create batch file
    iFile = OBJ_NEW('idl_create_batch_file', $
      Event, $
      BatchFileName, $
      (*(*global).BatchTable))
    ;reset the path
    (*global).BatchDefaultPath = new_path
  ENDIF
  
  
END

;+
; :Description:
;   this procedure takes a string of data spin states and activates or hide
;   the spin states of interest. This is based on the first entry of the
;   batch file assuming that all the other entries use the same set of spin
;   states
;
; :Params:
;    event
;
; :Author: j35
;-
pro activate_right_spin_states_button, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  data_spin_state = (*(*global).data_spin_state)
  spin_state = data_spin_state[0]
  spins = strsplit(spin_state,'/',/extract,count=nbr)
  (*(*global).list_of_spins_for_each_angle) = spins
  
  index = 0
  first_time = 1b
  while (index lt nbr) do begin
    uname = strlowcase(strcompress(spins[index],/remove_all))
    ActivateWidget, event, uname, 1
    if (first_time) then begin
      set_button, event, uname
      first_time = 0b
    endif
    index++
  endwhile
  
end


;==============================================================================
PRO ref_scale_LoadBatchFile, Event

  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;Retrieve global parameters
  PROCESSING = (*global).processing
  
  ;pop-up dialog pickfile
  dialog_id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
  BatchFileName = dialog_pickfile(title = 'Pick Batch File to Load ...',$
    PATH     = (*global).BatchDefaultPath,$
    FILTER   = (*global).BatchDefaultFileFilter,$
    dialog_parent=dialog_id,$
    GET_PATH = new_path,$
    /MUST_EXIST)
    
  IF (BatchFileName EQ '') then return
  
  IF (BatchFileName NE '') THEN BEGIN
    reset_all_button, Event ;full reset of the session
    (*global).BatchFileName = BatchFileName
    LogText = '> Loading Batch File:'
    idl_send_to_geek_addLogBookText, Event, LogText
    LogText = '-> File Name : ' + BatchFileName
    idl_send_to_geek_addLogBookText, Event, LogText
    (*global).BatchDefaultPath = new_path
    LogText = '-> Populate Batch Table ... ' + PROCESSING
    idl_send_to_geek_addLogBookText, Event, LogText
    ;put name of batch file in text field
    putValueInTextField, Event, 'load_batch_file_text_field', BatchFileName
    ;retrieve BatchTable
    iTable = OBJ_NEW('idl_load_batch_file', BatchFileName, Event)
    BatchTable = iTable->getBatchTable()
    (*(*global).BatchTable) = BatchTable
    ;Update Batch Tab and put BatchTable there
    UpdateBatchTable, Event, BatchTable
    
    if ((*global).working_with_ref_m_batch) then begin ;ref_m batch file
    
      DRfiles = retrieveDRfiles_ref_m(event, BatchTable)
      (*(*global).DRfiles) = DRfiles
      
      activate_right_spin_states_button, event
      
      ;get full file name of CE reduced file
      (*global).full_CE_name = DRfiles[0,0]
      
      ;check that all the files exist to move on
      FileStatus = CheckFilesExist_ref_m(Event, DRfiles)
      
      ;check that list of files is uniq
      FileStatus = CheckFileUniq(Event, DRfiles)
      
      if (FileStatus eq 1) then begin ;continue loading process
      
        ;work on 1 spin state at a time
        nbr_spin = (size(DRfiles))[1]
        index_spin = 0
        try_load_first_spin_only = 0b
        while (index_spin lt nbr_spin) do begin
        
          local_DRfiles = DRfiles[index_spin,*]
          rDRfiles = reform(local_DRfiles, n_elements(local_DRfiles))
          result = batch_repopulate_gui(Event, $
            rDRfiles, $
            spin_state_nbr=index_spin)
          index_spin++
          if (result eq 0) then begin   ;try to load first spin state only
            try_load_first_spin_only = 1b
            
            title = 'Error loading one of the other spin state'
            msg_txt = ['Program encounter an error while trying to load',$
            'one of the other spin state.',$
            '','This may due to a file with only zeroes in it !','','',$
            'You are going to work with only the first spin state loaded!']
            local_mesg = dialog_message(msg_txt,/error,/center,$
            dialog_parent=dialog_id, title=title)
            
          endif
          
        endwhile
        
        ;try to load first spin state only
        if (try_load_first_spin_only) then begin
          local_DRfiles = DRfiles[0,*]
          rDRfiles = reform(local_DRfiles, n_elements(local_DRfiles))
          
          result = batch_repopulate_gui(Event, $
            rDRfiles)
          if (result eq 0) then begin   ;first spin state failed also
            refresh_bash_file_status = 0
          endif else begin
            refresh_bash_file_status = 1 ;enable REFRESH and SAVE AS Bash File
            UpdateBatchTable, Event, BatchTable
          endelse
        endif else begin
          refresh_bash_file_status = 1 ;enable REFRESH and SAVE AS Bash File
        endelse
        
      endif else begin            ;stop loading process
      
        LogText = '> Loading Batch File ' + BatchFileName + ' ... FAILED'
        idl_send_to_geek_addLogBookText, Event, LogText
        LogText = '-> This can be due to the fact that 1 or more of the ' + $
          ' DR files does not exist !'
        idl_send_to_geek_addLogBookText, Event, LogText
        refresh_bash_file_status = 0 ;enable REFRESH and SAVE AS Bash File
        reset_all_button, Event
        
      endelse
      
      ActivateWidget, Event, 'ref_scale_refresh_batch_file', refresh_bash_file_status
      ActivateWidget, Event, 'ref_scale_save_as_batch_file', refresh_bash_file_status
      ActivateWidget, Event, 'batch_preview_button', refresh_bash_file_status
      if (refresh_bash_file_status) then begin ;loading was successful
        ;this function updates the output file name
        update_output_file_name_from_batch, Event ;_output
      endif else begin
        putValueInLabel, Event, 'output_short_file_name', ''; _put
        message = ['The loading of ' + BatchFileName + ' did not work !',$
          'Check the Log Book !']
        title   = 'Problem Loading the Batch File!'
        dialog_id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
        result = DIALOG_MESSAGE(message,$
          TITLE=title,$
          /error,$
          /center,$
          dialog_parent=dialog_id)
      endelse
      
    endif else begin ;ref_l batch file
    
      ;Retrieve List of Data Reduction files
      DRfiles = retrieveDRfiles(Event, BatchTable)
      ;Check that all the files exist
      FileStatus = CheckFilesExist(Event, DRfiles)
      IF (FileStatus EQ 1) THEN BEGIN ;continue loading process
        ;Repopulate GUI
        result = batch_repopulate_gui(Event, DRfiles)
        IF (result EQ 1) THEN BEGIN
          LogText = '> Loading Batch File ' + BatchFileName + ' ... OK'
          idl_send_to_geek_addLogBookText, Event, LogText
          refresh_bash_file_status = 1
        ENDIF ELSE BEGIN
          LogText = '> Loading Batch File ' + BatchFileName + ' ... FAILED'
          idl_send_to_geek_addLogBookText, Event, LogText
          LogText = '-> This can be due to the fact that 1 or more ' + $
            'of the DR files does not exist !'
          idl_send_to_geek_addLogBookText, Event, LogText
          refresh_bash_file_status = 0 ;enable REFRESH and SAVE AS Bash File
        ENDELSE
      ENDIF ELSE BEGIN            ;stop loading process
        LogText = '> Loading Batch File ' + BatchFileName + ' ... FAILED'
        idl_send_to_geek_addLogBookText, Event, LogText
        LogText = '-> This can be due to the fact that 1 or more of the ' + $
          ' DR files does not exist !'
        idl_send_to_geek_addLogBookText, Event, LogText
        refresh_bash_file_status = 0 ;enable REFRESH and SAVE AS Bash Fil
        reset_all_button, Event
      ENDELSE
      
      ActivateWidget, Event, 'ref_scale_refresh_batch_file', refresh_bash_file_status
      ActivateWidget, Event, 'ref_scale_save_as_batch_file', refresh_bash_file_status
      ActivateWidget, Event, 'batch_preview_button', refresh_bash_file_status
      IF (refresh_bash_file_status) THEN BEGIN ;loading was successfull
        ;this function updates the output file name
        update_output_file_name_from_batch, Event ;_output
      ENDIF ELSE BEGIN
        putValueInLabel, Event, 'output_short_file_name', ''; _put
        message = ['The loading of ' + BatchFileName + ' did not work !',$
          'Check the Log Book !']
        title   = 'Problem Loading the Batch File!'
        dialog_id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
        result = DIALOG_MESSAGE(message,$
          TITLE=title,$
          /error,$
          /center,$
          dialog_parent=dialog_id)
      ENDELSE
      
    endelse
    
  ENDIF ELSE BEGIN
    ;disable REFRESH and SAVE AS Bash File
    refresh_bash_file_status = 0
  ENDELSE
  
;  ActivateWidget, Event, 'ref_scale_refresh_batch_file', refresh_bash_file_status
;  ActivateWidget, Event, 'ref_scale_save_as_batch_file', refresh_bash_file_status
;  ActivateWidget, Event, 'batch_preview_button', refresh_bash_file_status
;  IF (refresh_bash_file_status) THEN BEGIN ;loading was successfull
;    ;this function updates the output file name
;    update_output_file_name_from_batch, Event ;_output
;  ENDIF ELSE BEGIN
;    putValueInLabel, Event, 'output_short_file_name', ''; _put
;    message = ['The loading of ' + BatchFileName + ' did not work !',$
;      'Check the Log Book !']
;    title   = 'Problem Loading the Batch File!'
;    dialog_id = widget_info(event.top, find_by_uname='MAIN_BASE_ref_scale')
;    result = DIALOG_MESSAGE(message,$
;      TITLE=title,$
;      /error,$
;      /center,$
;      dialog_parent=dialog_id)
;  ENDELSE
  
END

