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
  
  
  
  
  
end