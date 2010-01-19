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

;This procedure replot the main plot before addign the circle selection
PRO refresh_main_plot_for_circle_selection, Event

  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME = 'draw_uname')
  WIDGET_CONTROL, id, GET_VALUE = id_value
  WSET, id_value
  TV, (*(*global).background), true=3
  
END

;-------------------------------------------------------------------------------
;type: tube, pixel, radius
;direction: plus, minus
PRO change_circle_value, Event, type=type, direction=direction

  CASE (type) OF
    'tube'  : BEGIN
      uname = 'circle_tube_center'
      off_value = 1
    END
    'pixel' : BEGIN
      uname = 'circle_pixel_center'
      off_value = 1
    END
    'radius': BEGIN
      uname = 'circle_radius_value'
      off_value = 0.1
    END
  ENDCASE
  
  ON_IOERROR, error
  
  value =  getTextFieldValue(Event,uname)
  CASE (type) OF
    'tube'  : value = FIX(value)
    'pixel' : value = FIX(value)
    'radius': value = FLOAT(value)
  ENDCASE
  
  IF (direction EQ 'plus') THEN BEGIN
    value += off_value
  ENDIF ELSE BEGIN
    value -= off_value
  ENDELSE
  
  CASE (type) OF
    'tube' : BEGIN
      IF (value GT 192) THEN value = 191
      IF (value LE 0) THEN value = 1
    END
    'pixel' : BEGIN
      IF (value GT 255) THEN value = 255
      IF (value LT 0) THEN value = 0
    END
    'radius' : BEGIN
      IF (value LE 0) THEN value = 0.1
    END
  ENDCASE
  
  putTextFieldValue, Event, uname, STRCOMPRESS(value,/REMOVE_ALL)
  RETURN
  
  error:
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='MAIN_BASE')
  message_text = [type + ' value (' + STRCOMPRESS(value,/REMOVE_ALL) + $
    ') is not a valid number','','Please check your input!']
  result = DIALOG_MESSAGE(message_text,$
    /ERROR, $
    /CENTER, $
    DIALOG_PARENT = id,$
    TITLE = type + ' input ERROR!')
    
END