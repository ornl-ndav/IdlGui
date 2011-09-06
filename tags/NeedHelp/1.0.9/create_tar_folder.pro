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
;   This function copy the files the user wants to attach to the email
;   in his home folder
;
;  :Params:
;     list_of_files
;
;
;  :Author: j35
;-
function cp_to_relative_folder, list_of_files
  compile_opt idl2
  
  tmp_path = './'
  sz = n_elements(list_of_files)
  new_list_of_files = strarr(sz)
  i = 0
  WHILE (i LT sz) DO BEGIN
    base_name = file_basename(list_of_files[i])
    new_list_of_files[i] = tmp_path + base_name + '_tmp'
    ;copy file
    spawn, 'cp ' + list_of_files[i] + ' ' + new_list_of_files[i], $
      listening, err_listening
    ;change permission of file
    spawn, 'chmod 755 ' + new_list_of_files[i], listening, err_listening
    ++i
  ENDWHILE
  return, new_list_of_files
end


;+
; :Description
;   This function removes the temporary files copied in the home directory
;   and used to create the tar file
;
; :Params:
;   list_of_files
;
;
; :Author: j35
;-
PRO clean_tmp_files, new_list_OF_files
  new_list = strjoin(new_list_OF_files, ' ')
  spawn, 'rm ' + new_list, listening
END


;+
; :Description:
;    This routine creates the tar file that will be attach to the email
;
; :Params:
;    tar_file_name
;    list_of_files
;
;
; :Author: j35
;-
pro create_tar_folder, tar_file_name, list_of_files
  compile_opt idl2
  
  ;copy all the files in ./ directory to be sure we are working with
  ;relative path
  new_list_of_files = cp_to_relative_folder(list_of_files)
  
  tar_cmd = 'tar cvf ' + tar_file_name
  nbr_files = n_elements(new_list_of_files)
  i=0
  while (i LT nbr_files) do begin
    tar_cmd += ' ' + new_list_of_files[i]
    ++i
  endwhile
  spawn, tar_cmd, listening
  
  ;remove tmp files
  clean_tmp_files, new_list_OF_files
  
end
