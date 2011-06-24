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


;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
  TextFieldID = WIDGET_INFO(Event.top,find_by_uname=uname)
  WIDGET_CONTROL, TextFieldID, get_value = TextFieldValue
  RETURN, TextFieldValue
END

;------------------------------------------------------------------------------
FUNCTION getButtonValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;+
; :Description:
;   This functions returns the number of spin states used for the first angle
;   (1,2,3 or 4)
;
; :Params:
;    data_spin_states
;
; :Author: j35
;-
function get_number_of_spin_states_per_angle, data_spin_states
  compile_opt idl2
  
  first_run = data_spin_states[0]
  spins = strsplit(first_run,'/',/extract,count=nbr)
  return, nbr
  
end

;+
; :Description:
;   This functions looks for the index of the given spin states in the list
;   of spin states of files loaded
;   ex: this_spin = 'off_off'
;       list_of_spin = ['off_off','off_on']
;       will return -> 0
;
; :Params:
;    event
;    this_spin
;
; :Author: j35
;-
function get_index_of_this_spin_in_list_of_spins, event, this_spin
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  this_spin = strlowcase(this_spin[0])
  
  list_spin_state = (*(*global).list_of_spins_for_each_angle)
  nbr_spin = n_elements(list_spin_state)
  index = 0
  while (index lt nbr_spin) do begin
    if (this_spin eq strlowcase(list_spin_state[index])) then return, index
    index++
  endwhile
  
  return, -1
end


function getOutputfileName_of_index, event, index
  scaled_uname = 'scaled_data_file_name_value_'
  local_index = strcompress(index,/remove_all)
  uname = scaled_uname + local_index
  file = getTextfieldValue(event,uname)
  path = getButtonValue(event,'output_path_button')
  return, path + file[0]
end

function getCombinedOutputfileName_of_index, event, index
  scaled_uname = 'combined_scaled_data_file_name_value_'
  local_index = strcompress(index,/remove_all)
  uname = scaled_uname + local_index
  file = getTextfieldValue(event,uname)
  path = getButtonValue(event,'output_path_button')
  return, path + file[0]
end

;+
; :Description:
;   return the number of element in the widget-droplist list of files (tab1)
;
; :Params:
;    event
;;
; :Author: j35
;-
function get_nbr_of_files_loaded, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  id = widget_info(event.top, find_by_uname='list_of_files_droplist')
  widget_control, id, get_value=value
  
  nbr_files_loaded = n_elements(value)
  (*global).NbrFilesLoaded = nbr_files_loaded
  
  return, nbr_files_loaded
  
end

;+
; :Description:
;   This function returns the current spin state selected
;   -1 if there is no spin states
;
; :Params:
;    event
;
; :Author: j35
;-
function get_current_spin_index, event
  compile_opt idl2
  
  uname_list = ['off_off','off_on','on_off','on_on']
  sz = n_elements(uname_list)
  index_spin_offset = 0
  for i=0,(sz-1) do begin
    id = widget_info(event.top, find_by_uname=uname_list[i])
    sensitivity = widget_info(id, /sensitive)
    if (sensitivity) then begin
      button_set = widget_info(id,/button_set)
      if (button_set) then return, index_spin_offset
      index_spin_offset++
    endif
  endfor
  return, -1
  
end


;+
; :Description:
;   This function returns the number of spin states
;
; :Params:
;    event
;
; :Author: j35
;-
function get_nbr_spin_states, event
  compile_opt idl2
  
  uname_list = ['off_off','off_on','on_off','on_on']
  sz = n_elements(uname_list)
  nbr_spins = 0
  for i=0,(sz-1) do begin
    id = widget_info(event.top, find_by_uname=uname_list[i])
    sensitivity = widget_info(id, /sensitive)
    if (sensitivity) then nbr_spins++
  endfor
  return, nbr_spins
  
end



;+
; :Description:
;    This function returns the intersection of two arrays
;    ex:
;     array1=[0,1,2,3,4,5,6]
;     array2=[3,4,5,6,7,8,9]
;     will return
;     [3,4,5,6]
;
; :Keywords:
;    array1
;    array2
;
; :Author: j35
;-
function getIntersectionOfArrays, array1=array1, array2=array2
  compile_opt idl2
  
  ;sort the array first
  _array1 = array1[sort(array1)]
  _array2 = array2[sort(array2)]
  
  intersection_array = !null
  
  sz1 = n_elements(_array1)
  sz2 = n_elements(_array2)
  sz_min = min([sz1,sz2])
  
  if (sz_min eq sz1) then begin
    _array_a = _array1
    _array_b = _array2
    endif else begin
    _array_a = _array2
    _array_b = _array1
endelse

  _index1 = 0
  while (_index1 lt sz_min) do begin
  
    val1 = _array_a[_index1]
    _result = where(val1 eq _array_b,nbr)
    if (nbr ne 0) then begin
      intersection_array = [intersection_array,val1]
    endif
    
    _index1++
  endwhile
  
  return, intersection_array
  
end


;+
; :Description:
;    This function returns the index relative to the first array of the 
;    value also found in the second array
;
; :Keywords:
;    array1
;    array2
;
; :Author: j35
;-
function getIndexOfIntersectionOfArrays, array1=array1, array2=array2
compile_opt idl2

_index_of_value_found = !null
sz = n_elements(array1)

_i = 0
while (_i lt sz) do begin

_val = array1[_i]
_result = where(_val eq array2,nbr)
if (nbr ne 0) then begin
_index_of_value_found = [_index_of_value_found, _result]
endif

_i++
endwhile

return, _index_of_value_found

end










