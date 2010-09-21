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
;    return true (1b) if the file is a batch file
;    This is defined according to the name of the file ('BATCH' in it or not)
;
; :Params:
;    file_name
;
; :Returns:
;    1b if file is a Batch file
;    0b if file is a crtof reduce file (not a reduce file)
;
; :Author: j35
;-
function isFileBatch, file_name
  compile_opt idl2
  u_file_name   = strupcase(file_name)
  search_string = 'BATCH'
  return, strmatch(u_file_name,search_string)
end

;+
; :Description:
;    Add the file_name to the list of files loaded only if file has not been loaded yet
;
; :Params:
;    event
;    file_name
;
; :Author: j35
;-
pro add_file_to_list_of_loaded_files, event, file_name
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  files_SF_list = (*global).files_SF_list
  sz = (size(files_SF_list))[1]
  index = 0
  while(index lt sz) do begin
    if (files_SF_list[0,index] eq '') then begin
      files_SF_list[0,index] = file_name
      files_SF_list[1,index] = 'N/A'
      break
    endif
    index++
  endwhile
  
  (*global).files_SF_list = files_SF_list
  
end

;+
; :Description:
;    Refresh the table of the LOAD and SCALE tab (tab #1)
;
; :Params:
;    event

; :Author: j35
;-
pro refresh_table, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  putValue, event, 'tab1_table', (*global).files_SF_list
  
end


;+
; :Description:
;    Add the tmp_pData_x, tmp_pData_y and tmp_pData_y_error
;    to the full list of data (x, y and error)
;
; :Params:
;    event
;
; :Author: j35
;-
pro add_data_to_list_of_loaded_data, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  _pData_x = (*(*global).tmp_pData_x)
  _pData_y = (*(*global).tmp_pData_y)
  _pData_y_error = (*(*global).tmp_pData_y_error)
  
  ;find first empty entry using the table data
  files_SF_list = (*global).files_SF_list
  file_names = files_SF_list[0,*]
  empty_index = where(file_names eq '',nbr)
  if (nbr ne -1) then new_entry_index = empty_index[0] ;where to put the new data
  
  pData_x       = (*global).pData_x
  pData_y       = (*global).pData_y
  pData_y_error = (*global).pData_y_error
   
  *pData_x[new_entry_index]       = _pData_x
  *pData_y[new_entry_index]       = _pData_y
  *pData_y_error[new_entry_index] = _pData_y_error

  (*global).pData_x       = pData_x
  (*global).pData_y       = pData_y
  (*global).pData_y_error = pData_y_error
  
end

;+
; :Description:
;   This procedure load the files and save the data in the array of pointer DATA and ERROR_DATA
;
; :Params:
;    event
;    ListFullFileName
;
; :Author: j35
;-
pro load_files, event, ListFullFileName
  compile_opt idl2
  
  sz = n_elements(ListFullFileName)
  index = 0
  while (index lt sz) do begin
    file_name = ListFullFileName[index]
    file_is_batch = 0b ;by default, file is not a batch file
    file_is_batch = isFileBatch(file_name)
    if (file_is_batch) then begin ;batch file
      load_batch_file, event, file_name
    endif else begin ;rtof file
      result = load_rtof_file(event, file_name)
      widget_control, event.top, get_uvalue=global
      ;      help, (*(*global).tmp_pData_x)
      ;      help, (*(*global).tmp_pData_y)
      add_data_to_list_of_loaded_data, event
      
      
      if (result) then begin
        add_file_to_list_of_loaded_files, event, file_name
        refresh_table, event
      endif
    endelse
    
    index++
  endwhile
  
end