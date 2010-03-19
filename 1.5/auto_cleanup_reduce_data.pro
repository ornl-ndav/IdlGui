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
;   This function is going to retrieve the first line of the input file
;   and check if that line starts with '#auto cleaned up: '.
;
; :Params:
;    file_name
;
; @returns 1 if the file has already beeen cleaned up, 0 otherwise
;
; :Author: j35
;-
function cleaned_up_performed_already, file_name
  compile_opt idl2
  
  openr, 1, file_name
  first_line = ''
  readf, 1, first_line
  close, 1
  
  search_string = '#auto cleaned up'
  split_line = strsplit(first_line,':',/extract)
  result = strmatch(split_line[0],search_string)
  
  return, result
end

;+
; :Description:
;   This function returns the index of the first non zero value
;
; :Params:
;    array
;
; @return: index of first non zero value
;
; :Author: j35
;-
function get_min_non_zero_q_index, array
  compile_opt idl2
  
  sz = n_elements(array)
  index = 0
  while (index lt sz) do begin
    if (float(array[index]) ne float(0)) then return, index
    index++
  endwhile
  
  return, -1
end

;+
; :Description:
;   This function returns the index of the last non zero value
;
; :Params:
;    array
;
; @return: index of last non zero value
;
; :Author: j35
;-
function get_max_non_zero_q_index, array
  compile_opt idl2
  
  sz = n_elements(array)
  index = sz-1
  while (index ge 0) do begin
    if (float(array[index]) ne float(0)) then return, index
    index--
  endwhile
  
  return, -1
end

;+
; :Description:
;   This function returns a 2 elements array of the first and last
;   Q indexes to keep
;
; :Params:
;    event
;    min_non_zero_q_index
;    max_non_zero_q_index
;    x_array
;
; :Author: j35
;-
function calculate_first_last_q_indexes_to_keep, $
    event,$
    min_non_zero_q_index,$
    max_non_zero_q_index,$
    x_array
  compile_opt idl2
  
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    percentage_of_q_to_remove_value = 10.
  endif else begin
    widget_control, event.top, get_uvalue=global
    percentage_of_q_to_remove_value = (*global).percentage_of_q_to_remove_value
  endelse
  
  q_percent_to_remove = float(percentage_of_q_to_remove_value)/100.
  q_min = x_array[min_non_zero_q_index]
  q_max = x_array[max_non_zero_q_index]
  
  q_min_to_keep_calculated = q_percent_to_remove*(q_max-q_min) + q_min
  q_max_to_keep_calculated = q_max - q_percent_to_remove*(q_max-q_min)
  
  ;calculate index of first q to keep after clean up
  sz = n_elements(x_array)
  q_index_min_to_keep = 0
  for i=0L, (sz-1) do begin
    if (x_array[i] ge q_min_to_keep_calculated) then begin
      q_index_min_to_keep = i
      break
    endif
  endfor
  
  q_index_max_to_keep = sz -1
  for i=(sz-1),0,-1 do begin
    if (x_array[i] le q_max_to_keep_calculated) then begin
      q_index_max_to_keep = i
      break
    endif
  endfor
  
  return, [q_index_min_to_keep, q_index_max_to_keep]
end

;+
; :Description:
;   this procedure parse the array and divides the data into 3 arrays
;   x, y and y_error
;
; :Params:
;    DataStringArray
;    Xarray
;    Yarray
;    SigmaYarray
;
;
;
; :Author: j35
;-
pro parse_data_array, DataStringArray, Xarray, Yarray, SigmaYarray
  Nbr = N_ELEMENTS(DataStringArray)
  j=0
  i=0
  WHILE (i LE Nbr-1) DO BEGIN
    CASE j OF
      0: BEGIN
        Xarray[j]      = DataStringArray[i++]
        Yarray[j]      = DataStringArray[i++]
        SigmaYarray[j] = DataStringArray[i++]
      END
      ELSE: BEGIN
        Xarray      = [Xarray,DataStringArray[i++]]
        Yarray      = [Yarray,DataStringArray[i++]]
        SigmaYarray = [SigmaYarray,DataStringArray[i++]]
      END
    ENDCASE
    j++
  ENDWHILE
  ;remove last element of each array
  sz = N_ELEMENTS(Xarray)
  Xarray = Xarray[0:sz-2]
  Yarray = Yarray[0:sz-2]
  SigmaYarray = SigmaYarray[0:sz-2]
END


;+
; :Description:
;   this procedure removes all the inf and nan values from the array
;
; :Params:
;    Xarray
;    Yarray
;    SigmaYarray
;
;
;
; :Author: j35
;-
pro remove_inf_nan, Xarray, Yarray, SigmaYarray
  ;remove -Inf, Inf and NaN
  RealMinIndex = WHERE(FINITE(Yarray),nbr)
  IF (nbr GT 0) THEN BEGIN
    Xarray = Xarray(RealMinIndex)
    Yarray = Yarray(RealMinIndex)
    SigmaYarray = SigmaYarray(RealMinIndex)
  ENDIF
END


;+
; :Description:
;   This routine parses the ascii file and retrieves the data and
;   save them into the x_array, y_array and y_error_array
;
; :Params:
;    file_name
;    x_array
;    y_array
;    y_error_array
;
;
;
; :Author: j35
;-
pro retrieve_data, file_name, x_array, y_array, y_error_array
  iAsciiFile = OBJ_NEW('IDL3columnsASCIIparser', file_name)
  sAscii = iAsciiFile->getData()
  DataStringArray = *(*sAscii.data)[0].data
  obj_destroy, iAsciiFile
  ;this method will creates a 3 columns array (x,y,sigma_y)
  Nbr = N_ELEMENTS(DataStringArray)
  x_array      = STRARR(1)
  y_array      = STRARR(1)
  y_error_array = STRARR(1)
  IF (Nbr GT 1) THEN BEGIN
    parse_data_array, $
      DataStringArray,$
      x_array,$
      y_array,$
      y_error_array
    ;Remove all rows with NaN, -inf, +inf ...
    remove_inf_nan, x_array, y_array, y_error_array
    ;Change format of array (string -> float)
    x_array       = FLOAT(temporary(x_array))
    y_array       = FLOAT(temporary(y_array))
    y_error_array = FLOAT(temporary(y_error_array))
  endif
end

;+
; :Description:
;   This function takes 3 arrays of float and creates a string array
;   with each element of the various arrays on the same line
;
; :Params:
;    new_x_array
;    new_y_array
;    new_y_error_array
;
; @returns: the string array (3 columns ascii format)
;
; :Author: j35
;-
function make_string_array, new_x_array, new_y_array, new_y_error_array
  compile_opt idl2
  
  sz = n_elements(new_y_array)
  result_array = strarr(sz+1)
  index = 0
  while (index lt sz) do begin
    result = strcompress(new_x_array[index],/remove_all)
    result += '   ' + strcompress(new_y_array[index],/remove_all)
    result += '   ' + strcompress(new_y_error_array[index],/remove_all)
    result_array[index] = result
    index++
  endwhile
  result_array[sz] = strcompress(new_x_array[sz],/remove_all)
  
  return, result_array
end



;+
; :Description:
;   This routine will read the reduce file, takes the argument from the
;   auto cleanup configure base and will cleanup the data
;
; :Params:
;    event
;
; :Keywords:
;    file_name
;
; :Author: j35
;-
pro cleanup_reduce_data, event, file_name = file_name
  compile_opt idl2
  
  ;check that the input file does not start with the autocleanup
  ;line
  ;#auto cleaned up: 10%
  if (cleaned_up_performed_already(file_name)) then return
  
  ;retrieve values from the file_name file
  retrieve_data, file_name, x_array, y_array, y_error_array
  sz = n_elements(y_array)
  if (sz lt 2) then return
  ;get indexes of first and last non zero Q values
  min_non_zero_q_index = get_min_non_zero_q_index(y_array)
  if (min_non_zero_q_index eq -1) then return
  max_non_zero_q_index = get_max_non_zero_q_index(y_array)
  if (max_non_zero_q_index eq -1) then return
  
  ;percentage of Q to remove (user defined)
  first_last_q_values_indexes_to_keep = $
    calculate_first_last_q_indexes_to_keep(event,$
    min_non_zero_q_index,$
    max_non_zero_q_index,$
    x_array)
  q_min_index = first_last_q_values_indexes_to_keep[0]
  q_max_index = first_last_q_values_indexes_to_keep[1]
  
  ;keep only range of interest
  new_x_array = x_array[q_min_index:q_max_index+1]
  new_y_array = y_array[q_min_index:q_max_index]
  new_y_error_array = y_error_array[q_min_index:q_max_index]
  
  ;make string array of data
  data_array = make_string_array(new_x_array, new_y_array, new_y_error_array)
  
  
  
end


;main test
file_name = '~/results/REF_L_20927,20935_2009y_06m_18d_00h_32mn.txt'
cleanup_reduce_data, '', file_name = file_name

end

