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
;   This function takes the file name defined by the program/user and
;   add for the ref_m instrument the spin state in the name
;
; :Params:
;    Event
;    outputFileName
;    spin_state
;
; :Author: j35
;-
function add_spin_state_to_outputFileName, Event,$
    outputFileName,$
    spin_state
    
  output_array = strsplit(outputFileName,'.',/extract, count=nbr)
  if (nbr lt 2) then begin
    output_file_name = output_array[0] + '_' + spin_state
    return, output_file_name
  endif
  if (nbr eq 2) then begin
    output_file_name = output_array[0] + '_' + spin_state + '.' + $
      output_array[1]
    return, output_file_name
  endif
  if (nbr gt 2) then begin
    output_file_name = strjoin(output_array[0:nbr-2],'.') + '_' + spin_state
    output_file_name += '.' + output_array[nbr-1]
    return, output_file_name
  endif
  
end

;+
; :Description:
;   This function takes the file name defined by the program/user and
;   add for the ref_m instrument the spin state and the current working
;   pixel in the name
;
;   This function is reached when the "broad reflective peak" has been selected
;
; :Params:
;    Event
;    outputFileName
;    spin_state
;    pixel_number
;
; :Author: j35
;-
function add_spin_state_and_pixel_to_outputFileName, Event,$
    outputFileName, $
    spin_state, $
    pixel_number
    
  _pixel = strcompress(pixel_number,/remove_all)
    
  output_array = strsplit(outputFileName,'.',/extract, count=nbr)
  if (nbr lt 2) then begin
    output_file_name = output_array[0] + '_' + spin_state + '_' + _pixel 
    return, output_file_name
  endif
  if (nbr eq 2) then begin
    output_file_name = output_array[0] + '_' + spin_state + '_' + _pixel + $
    '.' + output_array[1]
    return, output_file_name
  endif
  if (nbr gt 2) then begin
    output_file_name = strjoin(output_array[0:nbr-2],'.') + '_' + spin_state + $
    '_' + _pixel
    output_file_name += '.' + output_array[nbr-1]
    return, output_file_name
  endif
  
end