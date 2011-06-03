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
;    Return the zero based index of the droplist given by its uname
;
; :Keywords:
;    event
;    uname
;
; :Returns:
;   index selected
;
; :Author: j35
;-
function getDroplistIndex, event=event, uname=uname
  compile_opt idl2
  
  id = widget_info(event.top, find_by_uname=uname)
  index = widget_info(id, /droplist_select)
  
  return, index
end

;+
; :Description:
;    Get value (lable) of droplist index selected
;
; :Keywords:
;    event
;    uname
;
; :Author: j35
;-
function getDroplistIndexValue, event=event, uname=uname
  compile_opt idl2
  
  index = getDroplistIndex(event=event, uname=uname)
  id = widget_info(event.top, find_by_uname=uname)
  widget_control, id, get_value=list
  
  return, list[index]
end

;+
; :Description:
;    return the value of the widget defined
;    by its uname (passed as argument)
;
; :Keywords:
;   event
;   base
;   uname
;
; :Author: j35
;-
function getValue, id=id, event=event, base=base, uname=uname
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

;+
; :Description:
;    Determine the current spin state selected
;
; :Params:
;   event
; :Returns:
;   returns the current spin state
;
; :Author: j35
;-
function get_current_spin_state_selected, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  current_spin_state_selected = (*global).current_spin_state_selected
  return, current_spin_state_selected
  
end

;+
; :Description:
;    using the left and right values, create the sequence
;
; :Keywords:
;    from   first number of sequence
;    to     last number of sequence
;
; :Author: j35
;-
function getSequence, from=left, to=right
  compile_opt idl2
  
  no_error = 0
  catch, no_error
  if (no_error ne 0) then begin
    catch,/cancel
    return, ['']
  endif else begin
    on_ioerror, done
    iLeft  = long(left)
    iRight = long(right)
    sequence = indgen(iRight-iLeft+1)+iLeft
    return, strcompress(string(sequence),/remove_all)
    done:
    return, [strcompress(left,/remove_all)]
  ENDELSE
END

;+
; :Description:
;    get index of line selected
;
; :Keywords:
;    event
;    base
;    uname    ;by default, uname is for the main table of main gui (tab1)
;
; :Author: j35
;-
function get_table_lines_selected, event=event, base=base, uname=uname

  if (~keyword_set(uname)) then uname = 'tab1_table'
  
  if (keyword_set(event)) then begin
    id = widget_info(event.top, find_by_uname=uname)
  endif else begin
    id = widget_info(base, find_by_uname=uname)
  endelse
  selection = widget_info(id, /table_select)
  
  return, selection
end

;+
; :Description:
;    This returns the row selected
;
; :Keywords:
;    event
;    base
;    uname
;
; :Author: j35
;-
function get_table_row_selected, event=event, base=base, uname=uname
  compile_opt idl2
  
  full_selection = get_table_lines_selected(event=event, $
    base=base, $
    uname=uname)
    
  sz = size(full_selection,/dim)
  if (n_elements(sz) eq 1) then begin
    return, full_selection[1]
  endif else begin
    return, reform(full_selection[1,*])
  endelse
  
end

;+
; :Description:
;    Using the uname of the table, this function returns the file that
;    is currently selected for this table
;
;
;
; :Keywords:
;    event
;    base
;    uname
;
; :Author: j35
;-
function get_file_selected, event=event, base=base, uname=uname
  compile_opt idl2
  
  row_selected = get_table_row_selected(event=event,base=base,uname=uname)
  value_line = getValue(event=event, base=base, uname=uname)
  
  if (value_line[0] eq '') then return, ''
  
  return, value_line[row_selected]
end

;+
; :Description:
;    Return the files selected giving the type ('data_file','open_beam',
;    'dark_field')
;
;
;
; :Keywords:
;    event
;    type
;
; :Returns:
;   list of files selected
;
; :Author: j35
;-
function get_file_selected_of_type, event=event, type=type
  compile_opt idl2
  
  case (type) of
    'data_file': begin
      uname='data_files_table'
    end
    'open_beam': begin
      uname='open_beam_table'
    end
    'dark_field': begin
      uname='dark_field_table'
    end
  endcase
  
  file_name_selected = get_file_selected(event=event, uname=uname)
  
  return, file_name_selected
end


