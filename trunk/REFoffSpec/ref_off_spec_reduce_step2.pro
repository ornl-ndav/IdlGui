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
    uname_list[i] = uname_base + strcompress(i)
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
    uname_list[i] = uname_base + strcompress(i)
  ENDFOR
  
  put_list_value, Event, uname_list, value
  
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
    
    ;activate list_of_norm base and show norm run numbers selected
    
    putValueInTable, Event, $
      'reduce_step2_list_of_norm_files_table', $
      (*global).nexus_norm_list_run_number
    help, (*global).nexus_norm_list_run_number
    MapBase, Event, 'reduce_step2_list_of_norm_files_base', 1
    MapBase, Event, 'reduce_step2_list_of_normalization_file_hidden_base', 0
    
    ;put run number in the droplist of the big table and show the number
    ;of lines that corresponds to the number of data files loaded
    PopulateStep2BigTabe, Event
    
  ENDIF ELSE BEGIN
    LogText = '-> User canceled Browsing for 1 or more Normalization' + $
      ' NeXus file(s)'
    IDLsendToGeek_addLogBookText, Event, LogText
  ENDELSE
  
END

;------------------------------------------------------------------------------
PRO addNormNexusToList, Event, nexus_file_list_browsed

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  nexus_file_list = (*(*global).reduce_tab2_nexus_file_list)
  reduce_tab1_working_pola_state_list = (*global).nexus_list_OF_pola_state
  reduce_tab1_working_pola_state = reduce_tab1_working_pola_state_list[0]
  
  IF ((size(nexus_file_list))(0) EQ 0) THEN BEGIN ;first time adding norm file
    nexus_file_list = nexus_file_list_browsed
    (*(*global).reduce_tab2_nexus_file_list) = nexus_file_list
    sz = N_ELEMENTS(nexus_file_list_browsed)
    nexus_norm_list_run_number = STRARR(1,11)
    index = 0
    WHILE (index LT sz) DO BEGIN
      ;retrieve RunNumber of nexus file name
    
      iNexus = OBJ_NEW('IDLgetMetadata', $
        nexus_file_list[index],$
        reduce_tab1_working_pola_state)
      IF (~OBJ_VALID(iNexus)) THEN BEGIN
        index ++
        CONTINUE
      ENDIF
      RunNumber = iNexus->getRunNumber()
      OBJ_DESTROY, iNexus
      nexus_norm_list_run_number[0,index] = RunNumber
      index++
    ENDWHILE
    (*global).nexus_norm_list_run_number = nexus_norm_list_run_number
    
  ENDIF ELSE BEGIN ;list of nexus is not empty
  
  
  ENDELSE
  
END

;-----------------------------------------------------------------------------
PRO    PopulateStep2BigTabe, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
   tab1_table = (*(*global).reduce_tab1_table)
  data_run_number = tab1_table[0,*]
  sz = N_ELEMENTS(nexus_file_list)
  index = 0
  WHILE (index LT sz) DO BEGIN
    uname = 'reduce_tab2_data_value'+ STRCOMPRESS(index)
    putTextFieldValue, Event, uname, data_run_number[index]
    uname = 'reduce_tab2_data_recap_base_#' + strcompress(index)
    MapBase, Event, uname, 1
    index++
  ENDWHILE
  
  MapBase, Event, 'reduce_step2_label_table_base', 1
  
END