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

FUNCTION getTextFieldValue, Event, uname
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getTableValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getButtonValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION getDroplistSelect, Event, uname
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  value = WIDGET_INFO(id, /DROPLIST_SELECT)
  RETURN, value
END

;------------------------------------------------------------------------------
function get_hostname
  catch, error
  if (error ne 0) then begin
    catch, /cancel
    return, 'N/A'
  endif
  spawn, 'hostname', hostname
  return, hostname
end


;+
; :Description:
;    This function will return the priority selected by the user
;
; :Params:
;    event
;
;  @returns the priority ('low', 'medium' or 'high')
;
; :Author: j35
;-
function get_priority, event
  compile_opt idl2
  
  value = getDroplistSelect(event,'priority_list')
  if (value eq 0) then return, 'low'
  if (value eq 1) then return, 'medium'
  return, 'high'
end


;+
; :Description:
;   This function returns the list of email that will be use to send the
;   message according to the priority. The mailing list is retrieved from
;   the configuration file
;
; @Params:
;    event
;
; @returns
;    mailing list
;
; :Author: j35
;-
function get_mailing_list, priority
  compile_opt idl2
  
  file = OBJ_NEW('IDLxmlParser','.NeedHelp.cfg')
  tag_root = ['configuration','priority']
  case (priority) of
    'low': tag = [tag_root,'low']
    'medium': tag = [tag_root,'medium']
    'high': tag = [tag_root,'high']
    'debug': tag =[tag_root,'debug']
  endcase
  
  mailing_list = file->getValue(tag=tag)
  
  return, mailing_list
end

