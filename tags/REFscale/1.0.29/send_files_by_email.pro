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
;   This function send by email the output files
;
; :Params:
;    event
;    file_name
;
; :Author: j35
;-
function send_files_by_email, event, files
  compile_opt idl2
  
  result = 0
  
  catch, error
  error = 0
  if (error ne 0) then begin
    catch, /cancel
    return, 0
  endif
  
  widget_control, event.top, get_uvalue=global
  email = (*global).email
  
  ucams    = get_ucams()
  version  = (*global).version
  date     = GenerateIsoTimeStamp()
  
  ;list of files
  list_of_files = files[1:*]
  
  ;message of email
  email_message = 'Output files created by ' + ucams + $
    ' with REFscale (' + version + ') on ' + date + '. Files: - '
  index = 0
  while (index lt n_elements(list_of_files)) do begin
    email_message += file_basename(list_of_files[index]) + ' - '
    index++
  endwhile
  
  ;message subject
  email_subject = 'Output files created by REFscale on ' + date
  
  ;send email
  cmd_email = 'echo "' + email_message + '" | mutt -s " ' + email_subject + '"'
  index = 0
;  cmd_email += ' -a '
  while (index lt n_elements(list_of_files)) do begin
    cmd_email += ' -a ' + list_of_files[index]
    index++
  endwhile
  
  cmd_email += ' ' + email
  
  spawn, cmd_email, listening, err_listening
  
  return, 1
end