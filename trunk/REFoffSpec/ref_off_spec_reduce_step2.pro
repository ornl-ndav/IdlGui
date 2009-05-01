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

PRO activate_norm_combobox, Event, status=status

  uname_list = STRARR(11)
  uname_base = 'reduce_tab2_spin_combo_base'
  for i=0,10 do begin
    uname_list[i] = uname_base + STRCOMPRESS(i)
  ENDFOR
  
  MapList, Event, uname_list, status
  
END

;------------------------------------------------------------------------------
PRO mode1_spin_state_combobox_changed, Event

  value = getComboListSelectedValue(Event,$
    'reduce_step2_mode1_spin_state_combobox')
    
  uname_list = STRARR(11)
  uname_base = 'reduce_tab2_spin_value'
  for i=0,10 do begin
    uname_list[i] = uname_base + STRCOMPRESS(i)
  ENDFOR
  
  put_list_value, Event, uname_list, value
  
END

;------------------------------------------------------------------------------
PRO reduce_step2_run_number_normalization, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  WIDGET_CONTROL, /HOURGLASS
  
  TextField = getTextFieldValue(Event,'reduce_step2_normalization_text_field')
  
  ;stop now if there is nothing to do
  IF (STRCOMPRESS(TextField,/REMOVE_ALL) EQ '') THEN BEGIN
    WIDGET_CONTROL, HOURGLASS = 0
    RETURN
  ENDIF
  
  ;display list of runs
  LogText = '> Run or List of Normalization Runs entered by user: ' + TextField
  IDLsendToGeek_addLogBookText, Event, LogText
  
  ;retrieve list of runs
  ListOfRuns = ParseTextField(TextField)
  
  ;list of runs after parsing
  LogText = '-> Run or List of Normalization Runs after Parsing: ' + STRJOIN(ListOfRuns,',')
  IDLsendToGeek_addLogBookText, Event, LogText
  
  ;  ;get proposal selected by user (from droplist)
  ;  proposalSelected = getComboListSelectedValue(Event, $
  ;    'reduce_tab2_list_of_proposal')
  ;  LogText = '-> Normalization Proposal Folder Selected: ' + proposalSelected
  ;  IDLsendToGeek_addLogBookText, Event, LogText
  
  ;get full nexus file name for the runs loaded
  LogText = '-> Retrieve List of Full Normalization NeXus File Names:'
  IDLsendToGeek_addLogBookText, Event, LogText
  nbr_runs = N_ELEMENTS(ListOfRuns)
  index    = 0
  nexus_file_list = STRARR(nbr_runs)
  WHILE (index LT nbr_runs) DO BEGIN
    full_nexus_name = findnexus(Event,$
      RUN_NUMBER = ListOfRuns[index],$
      INSTRUMENT = (*global).instrument,$
      ;     PROPOSAL   = proposalSelected,$
      isNexusExist)
    LogText = '-> Run #: ' + ListOfRuns[index]
    IF (isNexusExist) THEN BEGIN
      LogText += ' => ' + full_nexus_name
      nexus_file_list[index] = full_nexus_name
    ENDIF ELSE BEGIN
      LogText += ' => NeXus file not FOUND !'
    ENDELSE
    IDLsendToGeek_addLogBookText, Event, LogText
    index++
  ENDWHILE
  
  ;remove the runs not found by STRJOIN with ',' and STRPLIT with ','
  ;after removing blank spaces
  
  form1 = STRJOIN(nexus_file_list,',')
  form2 = STRCOMPRESS(form1,/REMOVE_ALL)
  nexus_file_list = STRSPLIT(form2,',',/EXTRACT)
  
  addNormNexusToList, Event, nexus_file_list
  
  refresh_reduce_step2_big_table, Event
  
END

;------------------------------------------------------------------------------
PRO reduce_step2_browse_normalization, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  path  = (*global).browsing_path
  title = 'Select 1 or several Normalization NeXus file(s)'
  default_extenstion = '.nxs'
  
  LogText = '> Browsing for 1 or more Normalization NeXus file(s)' + $
    ' in Reduce/step2:'
  IDLsendToGeek_addLogBookText, Event, LogText
  
  nexus_file_list = DIALOG_PICKFILE(DEFAULT_EXTENSION = default_extension,$
    FILTER = ['*.nxs'],$
    GET_PATH = new_path,$
    /MULTIPLE_FILES,$
    /MUST_EXIST,$
    PATH = path,$
    TITLE = title)
    
  IF (nexus_file_list[0] NE '') THEN BEGIN
  
    IF (new_path NE path) THEN BEGIN
      (*global).browsing_path = new_path
      LogText = '-> New browsing_path is: ' + new_path
    ENDIF
    
    addNormNexusToList, Event, nexus_file_list
    
    refresh_reduce_step2_big_table, Event
    
  ENDIF ELSE BEGIN
    LogText = '-> User canceled Browsing for 1 or more Normalization' + $
      ' NeXus file(s)'
    IDLsendToGeek_addLogBookText, Event, LogText
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO refresh_reduce_step2_big_table, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  norm_run_number = (*global).nexus_norm_list_run_number
  IF (norm_run_number[0,0] NE '') THEN BEGIN
  
    ;activate list_of_norm base and show norm run numbers selected
    putValueInTable, Event, $
      'reduce_step2_list_of_norm_files_table', $
      (*global).nexus_norm_list_run_number
    MapBase, Event, 'reduce_step2_list_of_norm_files_base', 1
    MapBase, Event, 'reduce_step2_list_of_normalization_file_hidden_base', 0
    
    ;show the polarization base
    MapBase, Event, 'reduce_step2_polarization_base', 1
    MapBase, Event, 'reduce_step2_polarization_mode_hidden_base', 0
    display_buttons, EVENT=EVENT, $
    ACTIVATE=(*global).reduce_step2_polarization_mode_status, $
    global
    
    tab1_table = (*(*global).reduce_tab1_table)
    data_run_number = tab1_table[0,*]
    IF (data_run_number[0] NE '') THEN BEGIN
    
      ;put run number in the droplists of the big table and show the number
      ;of lines that corresponds to the number of data files loaded
      PopulateStep2BigTabe, Event
      
    ENDIF
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO reduce_step2_remove_run, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  nexus_file_list = (*(*global).reduce_tab2_nexus_file_list) ;size of nbr of files
  nexus_run_number = (*global).nexus_norm_list_run_number ;STRARR(1,11)
  
  ;get index selected or range selected
  selection_array = getTableSelection(Event, $
    'reduce_step2_list_of_norm_files_table')
    
  selection = selection_array[1,*]
  
  IF (selection[0] EQ 0 and $
    N_ELEMENTS(nexus_file_list) EQ 1 ) THEN BEGIN
    nexus_file_list = PTR_NEW(0L)
    nexus_run_number = STRARR(1,11)
    
    MapBase, Event, 'reduce_step2_list_of_norm_files_base', 0
    MapBase, Event, 'reduce_step2_list_of_normalization_file_hidden_base', 1
    MapBase, Event, 'reduce_step2_polarization_base', 0
    MapBase, Event, 'reduce_step2_polarization_mode_hidden_base', 1
    
    hideStep2BigTable, Event
    
    (*global).nexus_norm_list_run_number = nexus_run_number
    (*(*global).reduce_tab2_nexus_file_list) = nexus_file_list
    
  ENDIF ELSE BEGIN
  
    get_new_list, nexus_file_list, nexus_run_number, selection
    (*global).nexus_norm_list_run_number = nexus_run_number
    (*(*global).reduce_tab2_nexus_file_list) = nexus_file_list
    
    ;activate list_of_norm base and show norm run numbers selected
    putValueInTable, Event, $
      'reduce_step2_list_of_norm_files_table', $
      (*global).nexus_norm_list_run_number
    MapBase, Event, 'reduce_step2_list_of_norm_files_base', 1
    MapBase, Event, 'reduce_step2_list_of_normalization_file_hidden_base', 0
    
    ;put run number in the droplists of the big table and show the number
    ;of lines that corresponds to the number of data files loaded
    PopulateStep2BigTabe, Event
    
    ;show the polarization base
    MapBase, Event, 'reduce_step2_polarization_base', 1
    MapBase, Event, 'reduce_step2_polarization_mode_hidden_base', 0
    display_buttons, EVENT=EVENT, $
    ACTIVATE=(*global).reduce_step2_polarization_mode_status, global
    
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO addNormNexusToList, Event, new_nexus_file_list

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  nexus_file_list = (*(*global).reduce_tab2_nexus_file_list)
  reduce_tab1_working_pola_state_list = (*global).nexus_list_OF_pola_state
  reduce_tab1_working_pola_state = reduce_tab1_working_pola_state_list[0]
  
  IF ((SIZE(nexus_file_list))(0) EQ 0) THEN BEGIN ;first time adding norm file
  
    nexus_file_list = new_nexus_file_list
    (*(*global).reduce_tab2_nexus_file_list) = nexus_file_list
    
  ;    sz = N_ELEMENTS(nexus_file_list_browsed)
  ;    nexus_norm_list_run_number = STRARR(1,11)
  ;
  ;    index = 0
  ;    WHILE (index LT sz) DO BEGIN
  ;      ;retrieve RunNumber of nexus file name
  ;
  ;      iNexus = OBJ_NEW('IDLgetMetadata', $
  ;        nexus_file_list[index],$
  ;        reduce_tab1_working_pola_state)
  ;      IF (~OBJ_VALID(iNexus)) THEN BEGIN
  ;        index ++
  ;        CONTINUE
  ;      ENDIF
  ;      RunNumber = iNexus->getRunNumber()
  ;      OBJ_DESTROY, iNexus
  ;      nexus_norm_list_run_number[0,index] = RunNumber
  ;      index++
  ;    ENDWHILE
  ;    (*global).nexus_norm_list_run_number = nexus_norm_list_run_number
    
  ENDIF ELSE BEGIN ;list of nexus is not empty
  
    new_nexus_file_list = getOnlyDefineRunNumber(new_nexus_file_list)
    nexus_file_list = [nexus_file_list,new_nexus_file_list]
    (*(*global).reduce_tab2_nexus_file_list) = nexus_file_list
    
  ENDELSE
  
  sz = N_ELEMENTS(nexus_file_list)
  nexus_norm_list_run_number = STRARR(1,11)
  
  index = 0
  WHILE (index LT sz) DO BEGIN
    ;retrieve RunNumber of nexus file name
  
    iNexus = OBJ_NEW('IDLgetMetadata', $
      nexus_file_list[index],$
      reduce_tab1_working_pola_state)
    IF (~OBJ_VALID(iNexus)) THEN BEGIN
      nexus_norm_list_run_number[0,index] = 'N/A'
      index ++
    ENDIF ELSE BEGIN
      RunNumber = iNexus->getRunNumber()
      OBJ_DESTROY, iNexus
      nexus_norm_list_run_number[0,index] = RunNumber
      index++
    ENDELSE
  ENDWHILE
  
  (*global).nexus_norm_list_run_number = nexus_norm_list_run_number
  
END

;-----------------------------------------------------------------------------
PRO PopulateStep2BigTabe, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  tab1_table = (*(*global).reduce_tab1_table)
  data_run_number = tab1_table[0,*]
  norm_roi_list = (*global).reduce_step2_norm_roi
  
  sz = N_ELEMENTS(data_run_number)
  index = 0
  WHILE (index LT sz) DO BEGIN
  
    IF (data_run_number[0,index] NE '') THEN BEGIN
    
      ;populate norm label or droplist
      populate_reduce_step2_norm_droplist, Event
      
      ;populate data labels
      uname = 'reduce_tab2_data_value'+ STRCOMPRESS(index)
      putTextFieldValue, Event, uname, data_run_number[0,index]
      uname = 'reduce_tab2_data_recap_base_#' + STRCOMPRESS(index)
      MapBase, Event, uname, 1
      
      putTextFieldValue, Event, $
        'reduce_tab2_roi_value' + STRCOMPRESS(index),$
        norm_roi_list[index]
        
    ENDIF ELSE BEGIN
    
      error = 0
      CATCH, error
      IF (error NE 0) THEN BEGIN
        CATCH, /CANCEL
      ENDIF ELSE BEGIN
        uname = 'reduce_tab2_data_recap_base_#' + STRCOMPRESS(index)
        MapBase, Event, uname, 0
      ENDELSE

    ENDELSE
    
    index++
    
  ENDWHILE
  
  IF (data_run_number[0,0] NE '') THEN BEGIN
    MapBase, Event, 'reduce_step2_label_table_base', 1
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO hideStep2BigTable, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  tab1_table = (*(*global).reduce_tab1_table)
  data_run_number = tab1_table[0,*]
  
  sz = N_ELEMENTS(data_run_number)
  index = 0
  WHILE (index LT sz) DO BEGIN
  
    IF (data_run_number[0,index] NE '') THEN BEGIN
      uname = 'reduce_tab2_data_recap_base_#' + STRCOMPRESS(index)
      MapBase, Event, uname, 0
    ENDIF
    index++
    
  ENDWHILE
  
  MapBase, Event, 'reduce_step2_label_table_base', 0
  
END

;------------------------------------------------------------------------------
PRO populate_reduce_step2_norm_droplist, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  norm_run_number = (*global).nexus_norm_list_run_number
  
  tab1_table = (*(*global).reduce_tab1_table)
  data_run_number = tab1_table[0,*]
  data_run_number = getOnlyDefineRunNumber(data_run_number)
  sz_data = N_ELEMENTS(data_run_number)
  
  norm_run_number = getOnlyDefineRunNumber(norm_run_number)
  sz_norm = N_ELEMENTS(norm_run_number)
  
  index_data = 0
  WHILE (index_data LT sz_data) DO BEGIN ;loop over all data runs
  
    IF ((sz_norm) EQ 1) THEN BEGIN
      uname = 'reduce_tab2_norm_value' + STRCOMPRESS(index_data)
      putTextFieldValue, Event, uname, norm_run_number[0]
      uname = 'reduce_tab2_norm_base' + STRCOMPRESS(index_data)
      MapBase, Event, uname, 0
    ENDIF ELSE BEGIN
      uname = 'reduce_tab2_norm_combo' + STRCOMPRESS(index_data)
      SetDroplistValue, Event, uname, norm_run_number
      uname = 'reduce_tab2_norm_base' + STRCOMPRESS(index_data)
      MapBase, Event, uname, 1
    ENDELSE
    
    index_data++
  ENDWHILE
  
END

;------------------------------------------------------------------------------
PRO reduce_step2_browse_roi, Event, row=row

  PRINT, 'in reduce_step2_browse_roi'
  
  iRow = row
  row = STRCOMPRESS(row)
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  PROCESSING = (*global).processing
  OK         = (*global).ok
  FAILED     = (*global).failed
  
  path  = (*global).ROI_path
  
  data_run = getTextFieldValue(Event,'reduce_tab2_data_value' + row)
  title = 'Select Region Of Interest File for Data Run # ' + data_run + $
    ': '
  default_extenstion = '.dat'
  
  LogText = '> Browsing for 1 ROI file for data run # ' + data_run + $
    ': '
  IDLsendToGeek_addLogBookText, Event, LogText
  
  roi_file = DIALOG_PICKFILE(DEFAULT_EXTENSION = default_extension,$
    FILTER = ['*_roi.dat'],$
    GET_PATH = new_path,$
    /MUST_EXIST,$
    PATH = path,$
    TITLE = title)
    
  IF (roi_file[0] NE '') THEN BEGIN
  
    reduce_step2_norm_roi = (*global).reduce_step2_norm_roi
    reduce_step2_norm_roi[iRow] = roi_file[0]
    (*global).reduce_step2_norm_roi = reduce_step2_norm_roi
    
    IF (new_path NE path) THEN BEGIN
      (*global).ROI_path = new_path
      LogText = '-> New ROI browsing_path is: ' + new_path
    ENDIF
    
    refresh_reduce_step2_big_table, Event
    
  ENDIF ELSE BEGIN
    LogText = '-> User canceled Browsing for a ROI file.'
    IDLsendToGeek_addLogBookText, Event, LogText
  ENDELSE
  
END
