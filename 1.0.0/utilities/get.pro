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
;    returns the name of the instrument according to the name of the input
;    file provided
;
; :Params:
;    file_name
;
; :Author: j35
;-
function getInstrument, file_name
  compile_opt idl2
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    return, 'instr_undefined_'
  endif
  
  _split1 = strsplit(file_name,'/',/extract)
  _split2 = strsplit(_split1[-1],'_',/extract)
  
  return, _split2[0] + '_' + _split2[1]
  
end

;+
; :Description:
;    get list of lines selected in table (tab1)
;
; :Params:
;    event
;
; :Author: j35
;-
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
; :Keywords:
;   spin_state    the spin state to used (0, 1, 2 or 3)
;
;  :Returns:
;    nbr_files
;
; :Author: j35
;-
function get_number_of_files_loaded, event, spin_state=spin_state
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  if (n_elements(spin_state) eq 0) then spin_state=0
  
  ;find first empty entry using the table data
  files_SF_list = (*global).files_SF_list ;[spin, column, row]
  file_names = files_SF_list[spin_state,0,*]
  file_names = reform(file_names)
  
  empty_index = where(file_names eq '',nbr)
  if (nbr eq -1) then begin
    nbr_files = (size(file_SF_list))[3]
  endif else begin
    empty_index = reform(empty_index)
    nbr_files = empty_index[0]
  endelse
  
  return, nbr_files
  
end

;+
; :Description:
;    get the total number of files loaded
;    in all the spin states
;
; :Params:
;    event
;
; :Author: j35
;-
function get_total_number_of_files_loaded, event
  compile_opt idl2
  
  _number_files = 0
  
  ;loop over all the spin states
  for i=0,3 do begin
    _number_files += get_number_of_files_loaded(event, spin_state=i)
  endfor
  
  return, _number_files
  
end

;+
; :Description:
;    return the value of the widget defined
;    by its uname (passed as argument)
;
; :Keywords:
;   event
;   base
;
; :Params:
;    uname
;
; :Author: j35
;-
function getValue, id=id, event=event, base=base, uname
  compile_opt idl2
  
  if (n_elements(event) ne 0) then begin
    _id = widget_info(event.top, find_by_uname=uname)
  endif
  if (n_elements(base) ne 0) then begin
    _id = widget_info(base, find_by_uname=uname)
  endif
  if (n_elements(id) ne 0) then begin
    _id = id
  endif
  widget_control, _id, get_value=value
  return, value
  
end

;+
; :Description:
;    Determine which tab is currently selected
;
; :Keywords:
;    id
;    event
;    uname
;
; :Returns:
;   returns the current tab selected
;
; :Author: j35
;-
function getTabSelected, id=id, event=event, uname=uname
   compile_opt idl2
   
   if (n_elements(event) ne 0) then begin
   id = widget_info(event.top, find_by_uname=uname)
endif

  tab_selected = widget_info(id, /tab_current)
  return, tab_selected
   
   end


