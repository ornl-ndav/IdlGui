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
;    browse for the files
;
;
;
; :Keywords:
;    event
;    file_type     data_file, open_beam or dark_field
;
; :Author: j35
;-
pro browse_files, event=event, file_type=file_type
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  path = (*global).path
  
  case (file_type) of
    'data_file': begin
      _title = 'data files'
      _table_uname = 'data_files_table'
    end
    'open_beam': begin
      _title = 'open beam files'
      _table_uname = 'open_beam_table'
    end
    'dark_field': begin
      _title = 'dark field files'
      _table_uname = 'dark_field_uname'
    end
  endcase
  title = 'Select 1 or more ' + _title
  
  extension = (*global).file_extension
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  filter = (*global).file_filter
  
  list_file = dialog_pickfile(default_extension=extension,$
    dialog_parent=id,$
    filter=filter,$
    get_path=new_path,$
    path=path,$
    title=title,$
    /multiple_files,$
    /must_exist)

  if (list_file[0] ne '') then begin
    (*global).path = new_path
    
    ;get list of files 
    table = getValue(event=event,uname=_table_uname)
    
    table = reform(table)
    
    id = widget_info(event.top, find_by_uname=_table_uname)
    widget_control, id, insert_rows=n_elements(list_file)-1

    if (table[0] eq '') then begin
    new_table = [list_file]
    endif else begin
    new_table = [table, list_file]
    endelse
    
    table = reform(new_table,1,n_elements(new_table))

    ;replace table with new list
    putValue, event=event, _table_uname, table

  endif
  
  
  
  
  
  
  
end
