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

function get_table_lines_selected, event
  id = widget_info(event.top, find_by_uname='tab1_table')
  selection = widget_info(id, /table_select)
  return, selection
end

;+
; :Description:
;    returns the number of files loaded
;
; :Params:
;    event
;
;  :Returns:
;    nbr_files
;
; :Author: j35
;-
function get_number_of_files_loaded, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;find first empty entry using the table data
  files_SF_list = (*global).files_SF_list
  file_names = files_SF_list[0,*]
  empty_index = where(file_names eq '',nbr)
  if (nbr eq -1) then begin
    nbr_files = (size(file_SF_list))[3]
  endif else begin
    nbr_files = empty_index[0]
  endelse
  
  return, nbr_files
end

;+
; :Description:
;    return the value of the widget defined
;    by its uname (passed as argument)
;
; :Params:
;    event
;    uname
;
; :Author: j35
;-
function getValue, event, uname
  compile_opt idl2
  
  id = widget_info(event.top, find_by_uname=uname)
  widget_control, id, get_value=value
  return, value
  
end
