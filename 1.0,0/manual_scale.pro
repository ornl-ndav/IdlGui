;===============================================================================
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
;===============================================================================

;;+
; :Description:
;    Manual scaling of the data
;
; :Params:
;    event
;
; :Author: j35
;-
pro manual_scale, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  files_SF_list = (*global).files_SF_list
  
  pData_x = (*global).pData_x ;tof axis  [row, spin_state]
  
  ;copy pData_y data into pData_y_scaled
  create_clone_of_pData_y, event
  pData_y_scaled = (*global).pData_y_scaled
  ;copy pData_y_error into pData_y_error_scaled
  create_clone_of_pData_y_error, event
  pData_y_error_scaled = (*global).pData_y_error_scaled
  
  file_index_sorted = (*global).file_index_sorted
  
  for spin=0,3 do begin ;go over all the spin states
    nbr_files = get_number_of_files_loaded(event, spin_state=spin)
    
    ;0 or just 1 file loaded for that spin state so we don't need
    ;to do anything
    if (nbr_files le 1) then continue
    
    ;make sure the files are sorted relative to their tof axis
    ;this will return an array of index of the input files
    _file_index_sorted = sort_files(pData_x[0:(nbr_files-1), spin])
    *file_index_sorted[spin] = _file_index_sorted
    
    left_file_index = 0
    while (left_file_index le (nbr_files-1)) do begin
    
      SF = float(files_SF_list[spin, 1, _file_index_sorted[left_file_index]])
      
      *pData_y_scaled[_file_index_sorted[left_file_index],spin] /= SF
      *pData_y_error_scaled[_file_index_sorted[left_file_index],spin] /= SF
      
      left_file_index++
      
    endwhile
    
  endfor
  
  (*global).pData_y_scaled = pData_y_scaled
  (*global).pData_y_error_scaled = pData_y_error_scaled
  (*global).file_index_sorted = file_index_sorted
  
end