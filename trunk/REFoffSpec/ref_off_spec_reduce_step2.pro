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
  
    (*(*global).reduce_tab2_nexus_file_list) = nexus_file_list
    
    IF (new_path NE path) THEN BEGIN
      (*global).browsing_path = new_path
      LogText = '-> New browsing_path is: ' + new_path
    ENDIF
    IDLsendToGeek_addLogBookText, Event, LogText
    display_message_about_files_browsed, Event, nexus_file_list
    
  ;      IF ((*global).reduce_tab1_working_pola_state EQ '') THEN BEGIN
  ;        ;get list of polarization state available and display list_of_pola base
  ;        nexus_file_name = nexus_file_list[0]
  ;        status = retrieve_list_OF_polarization_state(Event, $
  ;          nexus_file_name, $
  ;          list_OF_pola_state)
  ;        IF (status EQ 0) THEN RETURN
  ;
  ;     ENDIF ELSE BEGIN
  ;
  ;        ;update the table
  ;        AddNexusToReduceTab1Table, Event
    
  ;      ENDELSE
    
  ENDIF ELSE BEGIN
    LogText = '-> User canceled Browsing for 1 or more Normalization' + $
    ' NeXus file(s)'
    IDLsendToGeek_addLogBookText, Event, LogText
  ENDELSE
  
END
