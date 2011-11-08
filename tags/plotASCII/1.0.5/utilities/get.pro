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

FUNCTION getTextFieldValue, Event, uname
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getTableValue, event_load=event_load, main_event=main_event, uname
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    id = WIDGET_INFO(Event_load.top,FIND_BY_UNAME=uname)
    WIDGET_CONTROL, id, GET_VALUE=value
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, main_event.top, GET_UVALUE=global
    value = (*global).load_table
  ENDELSE
  RETURN, value
END

;------------------------------------------------------------------------------
;this function returns the first row and column of the selection
FUNCTION getCellSelectedTab1, Event, uname
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  selection = WIDGET_INFO(id, /TABLE_SELECT)
  RETURN, selection[0:1]
END

;------------------------------------------------------------------------------
FUNCTION getButtonValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getTab2_cl_array, Event
  path = getButtonValue(Event,'tab2_manual_input_folder')
  path = STRCOMPRESS(path,/REMOVE_ALL)
  prefix = getTextFieldValue(Event,'tab2_manual_input_suffix_name')
  prefix = STRCOMPRESS(prefix,/REMOVE_ALL)
  suffix = getTextFieldValue(Event,'tab2_manual_input_prefix_name')
  suffix = STRCOMPRESS(suffix,/REMOVE_ALL)
  cl_text_array = STRARR(2)
  cl_text_array[0] = path + prefix+ '_'
  cl_text_array[1] = '.' + suffix
  RETURN, cl_text_array
END

;------------------------------------------------------------------------------
FUNCTION get_local_filename, file_name
  file_array = STRSPLIT(file_name,'##',/EXTRACT)
  RETURN, STRTRIM(file_array[0])
END

;------------------------------------------------------------------------------
FUNCTION get_list_of_input_file, Event, event_load=event_load, $
    main_event=main_event
    
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    event = event_load
  ENDIF ELSE BEGIN
    event = main_event
  ENDELSE
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    global = (*global).global
  ENDIF
  
  load_table = (*global).load_table
  nbr_row = (size(load_table))(2)
  
  index = 0
  ascii_file = STRCOMPRESS(load_table[1,index],/REMOVE_ALL)
  list_ascii_file = [ascii_file]
  index++
  ascii_file = STRCOMPRESS(load_table[1,index],/REMOVE_ALL)
  WHILE (ascii_file NE '') DO BEGIN
    list_ascii_file = [list_ascii_file,ascii_file]
    index++
    ascii_file = STRCOMPRESS(load_table[1,index],/REMOVE_ALL)
  ENDWHILE
  
  RETURN, list_ascii_file
  
END

;------------------------------------------------------------------------------
FUNCTION get_number_of_files_loaded, event_load=event_load, $
    main_event=main_event
    
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    event = event_load
  ENDIF ELSE BEGIN
    event = main_event
  ENDELSE
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF (N_ELEMENTS(event_load) NE 0) THEN BEGIN
    global = (*global).global
  ENDIF
  
  table = getTableValue(event_load=event_load, main_event=main_event, $
    'plot_ascii_load_base_table')
  nbr_row = (size(table))(2)
  
  index = 0
  ascii_file = STRCOMPRESS(table[1,index],/REMOVE_ALL)
  WHILE (ascii_file NE '') DO BEGIN
    ascii_file = STRCOMPRESS(table[1,index],/REMOVE_ALL)
    index++
  ENDWHILE
  
  RETURN, index-1
  
END

;------------------------------------------------------------------------------
FUNCTION get_first_empty_table_index, load_table
  sz = (size(load_table))(2)
  index = 0
  WHILE (index LT sz) DO BEGIN
    IF (STRCOMPRESS(load_table[1,index],/REMOVE_ALL) EQ '') THEN RETURN, index
    index++
  ENDWHILE
  RETURN, -1
END

;------------------------------------------------------------------------------
FUNCTION getFirstEmptyXarrayIndex, event_load=event_load
table = getTableValue(event_load=event_load, 'plot_ascii_load_base_table')
index = get_first_empty_table_index(table)
return, index
END
