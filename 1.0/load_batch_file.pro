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
;    Changes the extension of the file name
;
; :Params:
;    output_file_name
;    old_ext
;    new_ext
;
; :Author: j35
;-
function replace_extension, output_file_name, old_ext, new_ext
compile_opt idl2

path = file_dirname(output_file_name,/mark_directory)
file_name = file_basename(output_file_name, old_ext)
new_file_name = path + file_name + new_ext
return, new_file_name

end

;+
; :Description:
;    Isolates the output file name from the command line and changes the
;    extension from .txt to .rtof
;
; :Params:
;    cmd
;
; :Returns:
;   name of the rtof output file
;
; :Author: j35
;-
function retrieve_rtof_file_name, cmd
compile_opt idl2

parse1 = strsplit(cmd,'--output=',/extract,/regex)
if (n_elements(parse1) ne 2) then return, ''
output_file_name = strsplit(parse1[1],' ',/extract,/regex)

old_ext = '.txt'
new_ext = '.rtof'
new_file_name = replace_extension(output_file_name[0], old_ext, new_ext)
return, new_file_name

end

;+
; :Description:
;    Parses the Big Batch table, and sort all the input files according to their 
;    spin state
;
; :Params:
;    BatchTable  [nbr_column, nbr_row]
;    
; :Returns:
;    Sorted batch table
;
; :Author: j35
;-
function retrieve_input_files_per_spin, BatchTable
compile_opt idl2

nbr_row = (size(BatchTable))[2]
nbr_column = (size(batchTable))[1]

;create SpinBatchFile
SpinBatchTable= strarr(4,nbr_row)

index_row = 0
while (index_row lt nbr_row) do begin

spins = BatchTable[2,index_row]
if (spins eq '') then begin ;no spin state -> spin_state = 0
input_rtof_file = retrieve_rtof_file_name(BatchTable[11,index_row])
SpinBatchTable[0,index_row] = input_rtof_file
endif else begin ;1 or more different spin state

endelse

index_row++
endwhile

return, SpinBatchTable

end

;+
; :Description:
;    Load a list of batch file
;
; :Params:
;    event
;    file_name
;
; :Author: j35
;-
pro load_batch_file, event, file_name
 compile_opt idl2

 widget_control, event.top, get_uvalue=global
 
  iTable = OBJ_NEW('IDLloadBatchFile', file_name, Event)
  BatchTable = iTable->getBatchTable()

  SpinBatchTable = retrieve_input_files_per_spin(BatchTable)
  ;ex:
  ;  ~/results/REF_L_38216,38221,38226_2010y_10m_14d_12h_18mn.rtof
  ;  ~/results/REF_L_38217,38221,38226_2010y_10m_14d_12h_18mn.rtof
  ;  ~/results/REF_L_38218,38221,38226_2010y_10m_14d_12h_18mn.rtof





end