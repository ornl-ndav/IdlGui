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
;   This procedures is the event handler of all the buttons (screenshots) of tab1
;
; :params:
;   event
;
; :Keywords:
;   uname
;
; :Author: j35
;-
pro event_button, Event, uname=uname

  button_name = getButtonName(uname)
  if (button_name eq '') then return
  error = 0
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    if (event.press eq 1) then begin
      display_buttons, event=event, button=button_name, status='on'
      if (button_name eq 'sns_tools') then begin ;launch application
        launch_this_application, event, button_name
      endif else begin ;launch web page
        launch_this_web_page, event, button_name
        widget_control, /hourglass
        wait, 1.5
        widget_control, hourglass=0
      endelse
    endif
    if (event.release eq 1) then begin
      display_buttons, event=event, button=button_name, status='off'
    endif
  endif else begin
    if (event.enter) then begin
      display_descriptions_buttons, EVENT=event, button=button_name
      ;cursor becomes a hand
      standard = 58
    endif else begin
      display_descriptions_buttons, EVENT=event, button='no_button'
      standart = 31
      display_buttons, event=event, button=button_name,status='off'
    ;cursor back to normal
    endelse
    id = WIDGET_INFO(Event.top,$
      find_by_uname=uname)
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    DEVICE, CURSOR_STANDARD=standard
  endelse
  
end

;+
; :Description:
;   This procedures is the event handler of all the buttons (screenshots) of tab3
;
; :params:
;   event
;
; :Keywords:
;   uname
;
; :Author: j35
;-
pro tab3_event_button, Event, uname=uname

  button_name = getButtonNameTab3(uname)
  if (button_name eq '') then return
  error = 0
  catch, error
  if (error ne 0) then begin
    catch,/cancel
    if (event.press eq 1) then begin
      display_buttons_tab3, event=event, button=button_name, status='on'
      if (button_name eq 'fix_firefox' or $
        button_name eq 'fix_gnome' or $
        button_name eq 'fix_isaw' or $
        button_name eq 'fix_data_link') then begin ;launch application
        launch_this_application, event, button_name
      endif else begin ;launch web page
        launch_this_web_page, event, button_name
      endelse
    endif
    if (event.release eq 1) then begin
      display_buttons_tab3, event=event, button=button_name, status='off'
    endif
  endif else begin
    if (event.enter) then begin
      display_descriptions_buttons_tab3, EVENT=event, button=button_name
      ;cursor becomes a hand
      standard = 58
    endif else begin
      display_descriptions_buttons_tab3, EVENT=event, button='no_button'
      standart = 31
      display_buttons_tab3, event=event, button=button_name,status='off'
    ;cursor back to normal
    endelse
    id = WIDGET_INFO(Event.top,$
      find_by_uname=uname)
    WIDGET_CONTROL, id, GET_VALUE=id_value
    WSET, id_value
    DEVICE, CURSOR_STANDARD=standard
  endelse
  
end