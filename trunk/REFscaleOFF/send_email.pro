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
;   This procedure will send an email with the message entered by the user
;   to various people (will depend on the status of the priority).
;   It will also create a tar file of the files added to the message.
;
; :Params:
;    event
;
; :Author: j35
;-
pro send_email, event, email=email, tar_file=tar_file, list_of_files=list_of_files
  compile_opt idl2
  
  catch, error
  error = 0
  if (error ne 0) then begin
    catch,/cancel
    result = send_error_message(event)
    return
  endif
  
  widget_control, event.top, get_uvalue=global
  date = GenerateIsoTimeStamp()
  
  email_message = 'Scaled files created with REFscaleOFF (' + (*global).version + ')'
  email_subject = 'Scaled files created with REFscaleOFF'
  
  ;send email
  cmd_email = 'echo "' + email_message + '" | mail -s " ' + email_subject + '"'
  if (list_of_files[0] ne '') then begin
    cmd_email += ' -a ' + tar_file
  endif
  cmd_email += ' ' + email
  ;spawn, cmd_email, listening, err_listening
  print, cmd_email
  
  send_info_message, event, info_type='success'
  
  ;remove tar file
  if (list_of_files[0] ne '') then begin
    spawn, 'rm ' + tar_file
  endif
  
end