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
;    return the index of the first empty row
;
; :Params:
;    table
;
; :Keywords:
;   type    'data' or 'norm'
;
; :Author: j35
;-
function get_first_empty_row_index, table, type=type
  compile_opt idl2
  
  dimension = size(table,/dim)
  nbr_row = dimension[1]
  
  case (type) of
    'data': _column_index=0
    'norm': _column_index=1
  endcase
  
  for i=0,(nbr_row-1) do begin
    if (table[_column_index,i] eq '') then return, i
  endfor
  
  return, -1
  
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
;    gets and returns size of Qz bins
;
; :Params:
;    event
;
; :Author: j35
;-
function get_bins_qz, event
  compile_opt idl2
  return, getValue(event=event, uname='bins_qz')
end

;+
; :Description:
;    gets and returns size of Qx bins
;
; :Params:
;    event
;
; :Author: j35
;-
function get_bins_qx, event
  compile_opt idl2
  return, getValue(event=event, uname='bins_qx')
end

;+
; :Description:
;    gets and returns Qx min
;
; :Params:
;    event
;
; :Author: j35
;-
function get_ranges_qx_min, event
  compile_opt idl2
  return, getValue(event=event, uname='ranges_qx_min')
end
function get_ranges_qx_min_rtof, event
  compile_opt idl2
  return, getValue(event=event, uname='rtof_ranges_qx_min')
end

;+
; :Description:
;    gets and returns Qz min
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_ranges_qz_min, event
  compile_opt idl2
  return, getValue(event=event, uname='ranges_qz_min')
end
function get_ranges_qz_min_rtof, event
  compile_opt idl2
  return, getValue(event=event, uname='rtof_ranges_qz_min')
end

;+
; :Description:
;    gets and returns tof min
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_tof_min, event
  compile_opt idl2
  return, getValue(event=event, uname='tof_min')
end
function get_tof_min_rtof, event
  compile_opt idl2
  return, getValue(event=event, uname='rtof_tof_min')
end

;+
; :Description:
;    gets and returns qx max
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_ranges_qx_max, event
  compile_opt idl2
  return, getValue(event=event, uname='ranges_qx_max')
end
function get_ranges_qx_max_rtof, event
  compile_opt idl2
  return, getValue(event=event, uname='rtof_ranges_qx_max')
end

;+
; :Description:
;    gets and returns Qz max
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_ranges_qz_max, event
  compile_opt idl2
  return, getValue(event=event, uname='ranges_qz_max')
end
function get_ranges_qz_max_rtof, event
  compile_opt idl2
  return, getValue(event=event, uname='rtof_ranges_qz_max')
end

;+
; :Description:
;    gets and returns tof max
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_tof_max, event
  compile_opt idl2
  return, getValue(event=event, uname='tof_max')
end
function get_tof_max_rtof, event
  compile_opt idl2
  return, getValue(event=event, uname='rtof_tof_max')
end

;+
; :Description:
;    gets and returns center pixel
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_center_pixel, event
  compile_opt idl2
  return, getValue(event=event, uname='center_pixel')
end
function get_center_pixel_rtof, event
  compile_opt idl2
  return, getValue(event=event, uname='rtof_center_pixel')
end

;+
; :Description:
;    gets and returns pixel size
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_pixel_size, event
  compile_opt idl2
  return, getValue(event=event, uname='pixel_size')
end
function get_pixel_size_rtof, event
  compile_opt idl2
  return, getValue(event=event, uname='rtof_pixel_size')
end

;+
; :Description:
;    gets and returns pixel min
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_pixel_min, event
  compile_opt idl2
  return, getValue(event=event, uname='pixel_min')
end
function get_pixel_min_rtof, event
  compile_opt idl2
  return, getValue(event=event, uname='rtof_pixel_min')
end

;+
; :Description:
;    gets and returns pixel max
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_pixel_max, event
  compile_opt idl2
  return, getValue(event=event, uname='pixel_max')
end
function get_pixel_max_rtof, event
  compile_opt idl2
  return, getValue(event=event, uname='rtof_pixel_max')
end

;+
; :Description:
;    gets and returns distance sample detector
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_d_sd, event
  compile_opt idl2
  return, getValue(event=event, uname='d_sd_uname')
end
function get_d_sd_rtof, event
  compile_opt idl2
  return, getValue(event=event, uname='rtof_d_sd_uname')
end

;+
; :Description:
;    gets and returns distance moderator detector
;
; :Params:
;    event
;
; :Author: j35
;-
function get_d_md, event
  compile_opt idl2
  return, getValue(event=event, uname='d_md_uname')
end
function get_d_md_rtof, event
  compile_opt idl2
  return, getValue(event=event, uname='rtof_d_md_uname')
end

;+
; :Description:
;    gets and returns qx width
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_qxwidth, event
  compile_opt idl2
  return, getValue(event=event, uname='qxwidth_uname')
end

;+
; :Description:
;    gets and returns tnum
;    Number of data points to remove on both side of spectrum when
;    calculating the scaling factors.
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_tnum, event
  compile_opt idl2
  return, getValue(event=event, uname='tnum_uname')
end

;+
; :Description:
;    returns a structure of the angle value and units from the 
;    rtof text box
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_theta, event
compile_opt idl2
value = getValue(event=event, uname='rtof_theta_value')
units = getValue(event=event, uname='rtof_theta_units')
return, {value:value, units:units}
end

;+
; :Description:
;    returns the value and units of the twotheta angle from the
;    rtof text box 
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
function get_twotheta, event
compile_opt idl2
value = getValue(event=event, uname='rtof_twotheta_value')
units = getValue(event=event, uname='rtof_twotheta_units')
return, {value:value, units:units}
end

