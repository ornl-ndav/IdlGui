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
pro send_your_message, event
  compile_opt idl2
  
  ;check that contact is not empty
  contact = getTextFieldValue(event, 'contact_uname')
  if (strcompress(contact,/remove_all) eq '') then begin
    send_error_message, event, error_type='contact'
    return
  endif
  
  widget_control, event.top, get_uvalue=global
  general_infos = (*global).general_infos
  ucams    = general_infos.ucams
  version  = general_infos.version
  hostname = general_infos.hostname
  home     = general_infos.home
  date     = GenerateIsoTimeStamp()
  
  ;get message
  message = getTextFieldValue(event, 'message')
  
  ;list of files
  list_of_files = (*(*global).list_of_files)
  
  ;priority ('low', 'medium', 'high')
  priority = get_priority(event)
  ;get email list
  mailing_list = get_mailing_list(priority)
  
  if ((*global).debugging eq 'yes') then begin
    print, 'ucams: ' + ucams
    print, 'version: ' + version
    print, 'hostname: ' + hostname
    print, 'home: ' + home
    print, 'date: ' + date
    print, 'message: ' + message
    help, message
    print, 'list_of_files:'
    help, list_of_files
    print, list_of_files
    print, 'priority: ' + priority
    print, 'mailing_list: ' + mailing_list
  endif
  
  
  
end