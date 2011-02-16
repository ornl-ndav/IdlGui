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
;    scale the data. The program looks for the minimum value then brings
;    this value to 1 and scaled all the other data using the same factor
;
; :Params:
;    data
;
; :Keywords:
;   scaling_factor    ;scaling factor used to produce new data set
;
; :Returns:
;    the scaled data
;
; :Author: j35
;-
function rescale_data, data, scaling_factor=scaling_factor
  compile_opt idl2
  
  minimum_value = min(data)
  new_min_value = 1.
  if (minimum_value ge 1.) then begin
    return, data
  endif
  
  scaling_factor = 1./float(minimum_value)
  
  return, data*scaling_factor
end


;+
; :Description:
;    This procedure parse the output file created by Michael's code, then
;    reformat the data, scaled them and output the new file that will
;    be used by DAVE
;
; :Keywords:
;    input_file
;    output_file
;
; :Author: j35
;-
pro create_dave_output_file, input_file=input_file, output_file=output_file
  compile_opt idl2
  
;  input_file = '~/IDLWorkspace80/CLoopES\ 1.2/Files/Dummy02142011.txt'
  iFile = obj_new("IDLASCIIparser", input_file)
  if (~obj_valid(iFile)) then return
  
  data = iFile.parseFile()
  obj_destroy, iFile
  
  _data = (*(*data).Q_data)
  data_scaled = rescale_data(_data, scaling_factor=scaling_factor)
  
  ;create a big array of the data big_arra[nbrT,16]
  nbr_T = (*data).nbrT
  T_range = (*(*data).T_range)
  nbr_Q = (*data).nbrQ
  big_array = fltarr(nbr_T,16)
  
  no_null_index = where(data_scaled ne 0)
  big_array[no_null_index] = data_scaled[no_null_index]
  
  metadata_array = strarr(6)
  metadata_array[0] = '#Comments     :'
  metadata_array[1] = '#User         :'
  metadata_array[2] = '#Scan Mode    :'
  metadata_array[3] = '#Start Time   :'
  metadata_array[4] = '#Time/pt      :'
  metadata_array[5] = 'TIME  LIVE  WBM   TBM   SETPT   CTEMP    STEMP' + $
    '  DETECTOR01  DETECTOR02  DETECTOR03  DETECTOR04  DETECTOR05  ' + $
    'DETECTOR06' + $
    '  DETECTOR07  DETECTOR08  DETECTOR09  DETECTOR10  DETECTOR11' + $
    '  DETECTOR12  DETECTOR13  DETECTOR14  DETECTOR15  DETECTOR16  MONITORFC'
    
  file_array_size = 6 + nbr_T
  file_array = strarr(file_array_size)
  
  ;save the metadata
  file_array[0:5] = metadata_array[*]
  _row_part1 = "-1 -1 -1 -1 -1 -1 "
  indexT = 0
  for i=6,(file_array_size-1) do begin
    _row = _row_part1 + strcompress(T_range[indexT],/remove_all) + ' '
    _flat_row = reform(strcompress(big_array[indexT,*],/remove_all))
    _big_array_row = strjoin(_flat_row,' ')
    
    _row += _big_array_row + ' -1'
    file_array[i] = _row[0]
    
    ++indexT
  endfor
  
  print, output_file
  
  openw, 1, output_file
  
  for i=0, (file_array_size-1) do begin
    printf, 1, file_array[i]
  endfor
  
  close, 1
  free_lun, 1
  
end