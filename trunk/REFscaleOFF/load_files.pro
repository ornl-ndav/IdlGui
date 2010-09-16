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
;    return true (1b) if the file is a batch file
;    This is defined according to the name of the file ('BATCH' in it or not)
;
; :Params:
;    file_name
;
; :Returns:
;    1b if file is a Batch file
;    0b if file is a crtof reduce file (not a reduce file)
;
; :Author: j35
;-
function isFileBatch, file_name
  compile_opt idl2
  u_file_name   = strupcase(file_name)
  search_string = 'BATCH'
  return, strmatch(u_file_name,search_string)
end


;+
; :Description:
;   This procedure load the files and save the data in the array of pointer DATA and ERROR_DATA
;
; :Params:
;    event
;    ListFullFileName
;
; :Author: j35
;-
pro load_files, event, ListFullFileName
  compile_opt idl2
  
  sz = n_elements(ListFullFileName)
  index = 0
  while (index lt sz) do begin
    file_name = ListFullFileName[index]
    file_is_batch = 0b ;by default, file is not a batch file
    file_is_batch = isFileBatch(file_name)
    if (file_is_batch) then begin
      load_batch_file, event, file_name
    endif else begin
      load_rtof_file, event, file_name
    endelse
    
    index++
  endwhile
  
  
  
  
  
  
  
  
  
  
  
end
