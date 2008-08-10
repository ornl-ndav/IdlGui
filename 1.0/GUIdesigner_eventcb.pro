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

PRO send_to_geek_email, Event
;get x-size
  id = WIDGET_INFO(Event.top,find_by_Uname='x_field')
  WIDGET_CONTROL, id, GET_VALUE=new_width
;get y_size
  id = WIDGET_INFO(Event.top,find_by_Uname='y_field')
  WIDGET_CONTROL, id, GET_VALUE=new_height
;get comment
  id = WIDGET_INFO(Event.top,find_by_Uname='comment_text')
  WIDGET_CONTROL, id, GET_VALUE=comments
  IF (comments[0] EQ '') THEN comments = 'N/A'

  no_error = 0
  CATCH, no_error
  If (no_error NE 0) THEN BEGIN
     CATCH,/CANCEL  
     text = 'ERROR sending the message: Please send your requirements by ' + $
            'email to j35@ornl.gov'
     WIDGET_CONTROL, id, SET_VALUE=text
  ENDIF ELSE BEGIN
     application    = 'GUIdesigner'
     subject        = application + " (Size requirements)"
     text = 'xsize = ' + STRCOMPRESS(new_width,/REMOVE_ALL)
     text += '; ysize = ' + STRCOMPRESS(new_height,/REMOVE_ALL)
     text += '; Comments: ' + comments
     cmd  =  'echo "' + text + '" | mail -s "' + subject + '" j35@ornl.gov'
     SPAWN, cmd
  ENDELSE
END





PRO GUIdesigner_eventcb
END
