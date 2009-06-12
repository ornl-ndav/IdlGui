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

PRO display_image, Event, uname=uname, image=image
id = WIDGET_INFO(event.top,find_by_uname=uname)
WIDGET_CONTROL, id, GET_VALUE=id_value
WSET, id_value
splash = READ_PNG(image)
TV, splash, 0, 0, /true
END

;------------------------------------------------------------------------------
PRO play_buttons_activation, event, activate_button=activate_button

  image_play = 'plotCNCS_images/play_disable.png'
  image_next = 'plotCNCS_images/next_disable.png'
  image_stop = 'plotCNCS_images/stop_disable.png'
  image_pause = 'plotCNCS_images/pause_disable.png'
  image_previous = 'plotCNCS_images/previous_disable.png'
  image_raw = 'plotCNCS_images/set_of_buttons_raw.png'
  
  case (activate_button) OF
    'play': image_play = 'plotCNCS_images/play_enable.png'
    'next': image_next = 'plotCNCS_images/next_enable.png'
    'stop': image_stop = 'plotCNCS_images/stop_enable.png'
    'pause': image_pause = 'plotCNCS_images/pause_enable.png'
    'previous': image_previous = 'plotCNCS_images/previous_enable.png'
    'raw': 
    ELSE:
  ENDCASE
  
  display_image, Event, uname='play_buttons', image=image_raw
  display_image, Event, uname='play_button', image=image_play
  display_image, Event, uname='next_button', image=image_next
  display_image, Event, uname='stop_button', image=image_stop
  display_image, Event, uname='previous_button', image=image_previous
  display_image, Event, uname='pause_button', image=image_pause
  
END