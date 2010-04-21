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
;    This routines desactivate the remove file button of tab2 when there
;    is no more files to be removed
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro desactivate_remove_files_button, event
  compile_opt idl2
  
  activate_widget, Event, 'remove_file', 0
  
end


;+
; :Description:
;    This procedures remove the list of files selected in the table
;    of tab2
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro remove_files, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  list_of_files = (*(*global).list_of_files)
  nbr_files = n_elements(list_of_files)
  
  id = widget_info(event.top, find_by_uname='table_uname')
  selection = widget_info(id, /table_select)
  
  row_min = selection[1]
  row_max = selection[3]
  
  if (nbr_files le row_min) then return
  row_max = row_max ge nbr_files ? (nbr_files-1) : row_max
  
  ;put empty string in place of file name of row(s) selected
  ;just one row selected
  if (row_max eq row_min) then begin
    list_of_files[row_max] = ''
  endif else begin ;more than 1 row selected
    list_of_files[row_min:row_max] = ''
  endelse
  
  ;remove empty row from list_of_files
  new_size = nbr_files - (row_max - row_min) - 1
  if (new_size eq 0) then begin
    (*(*global).list_of_files) = strarr(1)
    desactivate_remove_files_button, event
    update_list_of_files_table, event
    return
  endif
  new_list_of_files = strarr(new_size)
  
  new_index = 0
  old_index = 0
  while (old_index lt nbr_files) do begin
    if (list_of_files[old_index] ne '') then begin
      new_list_of_files[new_index] = list_of_files[old_index]
      new_index++
    endif
    old_index++
  endwhile
  
  (*(*global).list_of_files) = new_list_of_files
  update_list_of_files_table, event

end
