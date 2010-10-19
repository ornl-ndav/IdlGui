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
;    Activate the current button name passed as argument
;    and descativate the other ones
;
; :Keywords:
;    event
;    status   [off_off,off_on, on_off, on_on]
;
; :Author: j35
;-
pro spins_button_interactions, event=event, status=status
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  spin_list = ['Off_Off','Off_On','On_Off','On_On']
  images_spin_list = 'images/' + spin_list
  active_list = images_spin_list + '_active.bmp'
  inactive_list = spin_list + '_inactive.bmp'
  button_uname_list = strlowcase(spin_list) + '_button_uname'
  
  ;by default, all the buttons are inactivated
  button_bmp = inactive_list
  
  index = 0
  case (strlowcase(status)) of  
    'off_off' : index = 0
    'off_on' : index = 1
    'on_off' : index = 2
    'on_on' : index = 3
  endcase
  button_bmp[index] = active_list[index]
  (*global).current_spin_state_selected = index
  
  for i=0,3 do begin
    display_button, event=event, $
      button_uname=button_uname_list[i], $
      button_bmp = button_bmp[i]
  endfor
  
end

;+
; :Description:
;    display the button

; :Keywords:
;    event
;    button_uname
;    button_bmp
;
; :Author: j35
;-
pro display_button, event=event, button_uname=button_uname, button_bmp=button_bmp
  compile_opt idl2
  
  id = widget_info(event.top, find_by_uname=button_uname)
  widget_control, id, set_value=button_bmp, /bitmap
  
END