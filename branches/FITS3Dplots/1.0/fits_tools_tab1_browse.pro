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

PRO browse_fits_files, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;reset list_of_fits_error_files
  fits_error_files = STRARR((*global).max_nbr_fits_files)
  (*(*global).list_fits_error_file) = fits_error_files
  
  path = (*global).fits_path
  filter = ['*']
  widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  title = 'Select FITS file(s)'
  
  file_list = DIALOG_PICKFILE(/READ,$
    FILTER = filter,$
    PATH = path,$
    DIALOG_PARENT = widget_id, $
    GET_PATH = new_path, $
    /MULTIPLE_FILES, $
    /MUST_EXIST, $
    TITLE = title)
    
  IF (file_list[0] NE '') THEN BEGIN
  
    (*global).fits_path = new_path
    
    ;indicate initialization with hourglass icon
    WIDGET_CONTROL,/HOURGLASS
    
    nbr_file_loaded = N_ELEMENTS(file_list)
    
    ;can't work on more than (*global).max_nbr_fits_files
    ;files at the same times (fixed to 20 for now)
    IF (nbr_file_loaded GE (*global).max_nbr_fits_files) THEN BEGIN
      display_limited_fits_file_error_message, Event
      RETURN
    ENDIF
    
    MapBase, Event, uname='tab1_loaded_base_info', 1
    FOR i=0,(nbr_file_loaded-1) DO BEGIN
    
      short_file_name = FILE_BASENAME(file_list[i])
      putValue, Event, 'tab1_loaded_info_file', short_file_name
      status_retrieve = retrieve_data_of_new_file(Event=event, $
        file_name=file_list[i], sData=sData)
        
      IF (status_retrieve EQ 1b) THEN BEGIN
        add_file_to_list_of_files, Event=event, file_name=file_list[i], $
          status=status
        IF (status EQ 0b) THEN BEGIN
          display_limited_fits_file_error_message, Event
          RETURN
        ENDIF
        
      ENDIF ELSE BEGIN ;status_retrieve EQ 0b
      
        add_file_to_list_of_error_files, Event=event, file_name=file_list[i]
        
      ENDELSE
    ENDFOR
    MapBase, Event, uname='tab1_loaded_base_info', 0
    
    WIDGET_CONTROL, HOURGLASS=0
    
    ;if there was at least one file not loaded, inform the user
    list_fits_error_files = (*(*global).list_fits_error_file)
    index = get_first_empty_table_index(list_fits_error_files)
    IF (index EQ -1 OR index NE 0) THEN BEGIN
      display_loading_fits_file_error_message, Event
    ENDIF
    
    ;update big table
    update_tab1_big_table, Event
    
    ;update name of P vs C output ascii file (tab2)
    update_tab2_pvsc_ascii_file_name, Event
    
    ;update name of fits image files (tab3)
    update_tab3_fits_file_name, Event
    
    ;check gui of tab2
    check_create_pvsc_button_status, Event
    check_tab2_plot_button_status, Event
    
    ;check gui of tab3
    check_create_fits_button_status, Event
    check_tab3_plot_button_status, Event
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO add_file_to_list_of_files, Event=event, file_name=file_name, status=status

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  status = 1b
  list_fits_file = (*(*global).list_fits_file)
  index = get_first_empty_table_index(list_fits_file)
  IF (index NE -1) THEN BEGIN
    list_fits_file[index] = file_name
  ENDIF ELSE BEGIN ;we reach the max number of fits files
    status = 0b
  ENDELSE
  (*(*global).list_fits_file) = list_fits_file
  
END

;------------------------------------------------------------------------------
PRO add_file_to_list_of_error_files, Event=event, file_name=file_name

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  list_fits_error_files = (*(*global).list_fits_error_file)
  index = get_first_empty_table_index(list_fits_error_files)
  IF (index NE -1) THEN BEGIN
    list_fits_error_files[index] = file_name
  ENDIF
  (*(*global).list_fits_error_file) = list_fits_error_files
  
END

;------------------------------------------------------------------------------
PRO display_limited_fits_file_error_message, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  text = ['Can not process more than ' + $
    STRCOMPRESS((*global).max_nbr_fits_files,/REMOVE_ALL) + ' FITS ' + $
    ' files at the same time!',$
    '',$
    'Please contact j35@ornl.gov if you want to change this limitation']
  widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  result = DIALOG_MESSAGE(text, /ERROR, $
    /CENTER, $
    DIALOG_PARENT = widget_id, $
    TITLE = 'Loading error!')
END

;------------------------------------------------------------------------------
PRO display_loading_fits_file_error_message, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  text = ['Error loading the following file(s):', '']
  
  list_fits_error_file= (*(*global).list_fits_error_file)
  sz = N_ELEMENTS(list_fits_error_file)
  index = 1
  error_file = list_fits_error_file[0]
  WHILE (index LT sz) DO BEGIN
    IF (error_file EQ '') THEN BREAK
    text = [text, '   -> ' + error_file]
    error_file = list_fits_error_file[index]
    index++
  ENDWHILE
  widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  result = DIALOG_MESSAGE(text, /ERROR, $
    /CENTER, $
    DIALOG_PARENT = widget_id, $
    TITLE = 'Loading error!')
    
END

;------------------------------------------------------------------------------
PRO update_tab1_big_table, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  list_fits_file = (*(*global).list_fits_file)
  big_table = STRARR((*global).max_nbr_fits_files)
  
  x_array = (*(*global).pXArray)
  
  index = 0
  WHILE (index LT (*global).max_nbr_fits_files) DO BEGIN
  
    file_name = list_fits_file[index]
    IF (file_name EQ '') THEN BREAK
    x_current_array = *x_array[index]
    nbr_events = N_ELEMENTS(x_current_array)
    big_table[index] = file_name + ' (' + $
      STRCOMPRESS(nbr_events,/REMOVE_ALL) + ' events)'
    index++
  ENDWHILE
  
  putValueInTable, Event, 'tab1_fits_table', TRANSPOSE(big_table)
  
END