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
;    Inform the user that infos are missing to continue
;
; :Params:
;    event
;    info_type: 'contact', 'success'
;
; :Author: j35
;-
pro  send_info_message, event, info_type=info_type
  compile_opt idl2
  
  case (info_type) of
    'contact': begin
      message_title = 'Contact infos missing!'
      message_array = ['Please give us a way to contact you!']
    end
    'success': begin
      message_title = 'Your message has been sent with success!'
      message_array = ['Our team will contact you shortly','',$
      'Thanks for using NeedHelp.']
    end
    else:
  endcase
  
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
  
  result = dialog_message(message_array, $
    title = message_title,$
    /information, $
    /center, $
    dialog_parent = widget_id)
    
end


;+
; :Description:
;   This procedure pop us a dialog_message that informs the user that an
;   error occured while sending his message and that it did not work
;
; :Params:
;    event
;
; :Keywords:
;    error_type
;
; :Author: j35
;-
pro send_error_message, event
  compile_opt idl2
  
  widget_id = widget_info(event.top, find_by_uname='MAIN_BASE')
  message_title = 'Error while sending your message'
  message_array = ['Please inform j35@ornl.gov that you had a problem',$
    'sending your message!','','Thanks a lot']
    
  result = dialog_message(message_array, $
    title = message_title,$
    /error, $
    /center, $
    dialog_parent = widget_id)
    
end
