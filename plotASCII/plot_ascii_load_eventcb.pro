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

PRO browse_button, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global_load
  global = (*global_load).global
  
  path = (*global).path
  filter = ['*.dat','*.txt']
  widget_id = WIDGET_INFO(Event.top, FIND_BY_UNAME='plot_ascii_load_base_uname')
  title = 'Select ASCII file(s) to load'
  
  file_list = DIALOG_PICKFILE(/READ,$
    FILTER = filter,$
    PATH = path,$
    DIALOG_PARENT = widget_id, $
    GET_PATH = new_path, $
    /MULTIPLE_FILES, $
    /MUST_EXIST, $
    TITLE = title)
    
  IF (file_list[0] NE '') THEN BEGIN
    (*global).path = new_path
    
    add_file_list_to_full_list, Event, file_list
    populate_load_table, Event
    
  ENDIF
  
END

;------------------------------------------------------------------------------
PRO add_file_list_to_full_list, Event, file_list

  WIDGET_CONTROL, Event.top, GET_UVALUE=global_load
  global = (*global_load).global
  
  ascii_file_list = (*global).ascii_file_list
  
  nbr_new_file = N_ELEMENTS(file_list)
  index = 0
  WHILE (index LT nbr_new_file) DO BEGIN
    ascii_file_list[index] = file_list[index]
    index++
    
  ENDWHILE
  (*global).ascii_file_list = ascii_file_list
  
END

;------------------------------------------------------------------------------
FUNCTION get_first_empty_table_index, load_table
  sz = (size(load_table))(2)
  index = 0
  WHILE (index LT sz) DO BEGIN
    IF (STRCOMPRESS(load_table[0,index],/REMOVE_ALL) EQ '') THEN RETURN, index
    index++
  ENDWHILE
  RETURN, -1
END

;..............................................................................
PRO populate_load_table, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global_load
  
  global = (*global_load).global
  ascii_file_list = (*global).ascii_file_list
  dim_y = N_ELEMENTS(ascii_file_list) ;50 for now
  load_table = (*global).load_table
  
  index = 0
  index_table = get_first_empty_table_index(load_table)
  IF (index_table EQ -1) THEN RETURN
  WHILE(index LT dim_y) DO BEGIN
    file = ascii_file_list[index]
    IF (STRCOMPRESS(file,/REMOVE_ALL) EQ '') THEN BREAK
    load_table[0,index_table] = 'X'
    load_table[1,index_table] = file
    index++
    index_table++
  ENDWHILE
  (*global).load_table = load_table
  putValueInTable, Event, 'plot_ascii_load_base_table', load_table
END

;------------------------------------------------------------------------------
PRO select_full_row, Event

  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='plot_ascii_load_base_table')
  selection = WIDGET_INFO(id, /TABLE_SELECT)
  row_selected = selection[1]
  left_top_view = WIDGET_INFO(id, /TABLE_VIEW)
  
  WIDGET_CONTROL, id, SET_TABLE_SELECT=[0,row_selected, 1, row_selected]
  WIDGET_CONTROL, id, SET_TABLE_VIEW=left_top_view
  
END


