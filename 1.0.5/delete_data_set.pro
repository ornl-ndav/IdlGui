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
;    Remove all the blank lines of the given spin state index (0, 1, 2 or 3)
;
; :Params:
;    files_SF_list
;    nbr_spins
;    nbr_column
;    nbr_row
;
; :Keywords:
;    spin_index
;
; :Author: j35
;-
pro remove_empty_lines_of_this_spin, spin_index=i, files_SF_list, nbr_spins, nbr_column, nbr_row
  compile_opt idl2
  
  _line_index = 0
  _tmp_spin_table = strarr(nbr_spins, nbr_column, nbr_row)
  _no_empty = where(files_SF_list[i,0,*] ne '', nbr)
  _empty = where(files_SF_list[i,0,*] eq '', nbr_empty)
  
  if (nbr ge 1) then begin
    if (nbr_empty ne -1) then begin ;check if the first empty is outside the last not empty
      if (_empty[0] gt _no_empty[n_elements(_no_empty)-1]) then return
    endif
    left_index = indgen(nbr)
    _tmp_spin_table[i,*,left_index] = files_SF_list[i,*,_no_empty]
    files_SF_list[i,*,*] = _tmp_spin_table[i,*,*]
  endif
  
end

;+
; :Description:
;    Go through all the lines of the table (tab1) and remove
;    the empty lines
;
; :Params:
;    event
;    spin_state: -1 = all spin states
;                 0 = first spin state (Off_Off) or when there is no spin states
;                 1 = second spin state (Off_On)
;                 2 = third spin state (On_Off)
;                 3 = fourth spin state (On_On)
;
; :Author: j35
;-
pro remove_empty_lines, event, spin_state=spin_state
  compile_opt idl2
  
  if (n_elements(spin_state) eq 0) then spin_state=0
  
  widget_control, event.top, get_uvalue=global
  
  files_SF_list = (*global).files_SF_list
  
  nbr_row = (size(files_SF_list))[3]
  nbr_spins = (size(files_SF_list))[1]
  nbr_column = (size(files_SF_list))[2]
  
  case (spin_state) of
    -1 : begin
      i=0
      while (i lt nbr_spins) do begin
        remove_empty_lines_of_this_spin, spin_index=i, files_SF_list, nbr_spins, nbr_column, nbr_row
        i++
      endwhile
    end
    0 : begin
      remove_empty_lines_of_this_spin, spin_index=0, files_SF_list, nbr_spins, nbr_column, nbr_row
    end
    1 : begin
      remove_empty_lines_of_this_spin, spin_index=1, files_SF_list, nbr_spins, nbr_column, nbr_row
    end
    2 : begin
      remove_empty_lines_of_this_spin, spin_index=2, files_SF_list, nbr_spins, nbr_column, nbr_row
    end
    3 : begin
      remove_empty_lines_of_this_spin, spin_index=3, files_SF_list, nbr_spins, nbr_column, nbr_row
    end
    else:
  endcase
  
  (*global).files_SF_list  = files_SF_list
  
end

;+
; :Description:
;    remove all the entries from a given row_number
;       -> Files entry (big table)
;       -> data arrays
;
; :Params:
;    event
;    from_row
;    to_row
;
; :Author: j35
;-
pro delete_entry, event, from_row, to_row, spin_state=spin_state
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  if (n_elements(spin_state) eq 0) then spin_state = 0
  
  files_SF_list = (*global).files_SF_list
  
  index = from_row
  while (index le to_row) do begin
    files_SF_list[spin_state,*,index] = ''
    index++
  endwhile
  
  (*global).files_SF_list = files_SF_list
  
end