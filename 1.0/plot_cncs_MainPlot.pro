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

PRO MainPlotInteraction, Event
  WIDGET_CONTROL, event.top, GET_UVALUE=global1
  wbase   = (*global1).wBase
  TubeAngle = (*global1).TubeAngle
  big_array_rebin = (*(*global1).big_array_rebin_rescale)
  off   = (*global1).off
  xoff  = (*global1).xoff
  
  ;retrieve bank number
  bank_tube   = getBankTube(Event)
  bank_number = bank_tube[0]
  tube_number = bank_tube[1]
  row_number  = bank_tube[2]
  
  ;show bank number
  IF (bank_number EQ '') THEN BEGIN
    value = 'N/A'
  ENDIF ELSE BEGIN
    value = STRCOMPRESS(bank_number,/REMOVE_ALL)
  ENDELSE
  putTextFieldValue, Event, 'bank_value', value
  
  ;show tube number
  IF (tube_number EQ '') THEN BEGIN
    VALUE = 'N/A'
  ENDIF ELSE BEGIN
    value = STRCOMPRESS(FIX(tube_number) + (FIX(bank_number)-1) * 8L,$
      /REMOVE_ALL)
  ENDELSE
  putTextFieldValue, Event, 'tube_value', value
  
  ;Show tube angle
  real_tube_number = FIX(tube_number) + (FIX(bank_number)-1) * 8L
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    angle = 'N/A'
  ENDIF ELSE BEGIN
    IF (tube_number NE '') THEN BEGIN
      angle = STRCOMPRESS(TubeAngle[real_tube_number],/REMOVE_ALL)
    ENDIF ELSE BEGIN
      angle = 'N/A'
    ENDELSE
  ENDELSE
  putTextFieldValue, Event, 'angle_value', angle
  
  ;Show row
  IF (row_number EQ '') THEN BEGIN
    value = 'N/A'
  ENDIF ELSE BEGIN
    value = STRCOMPRESS(row_number,/REMOVE_ALL)
  ENDELSE
  putTextFieldValue, event, 'row_value', value
  
  ;show real pixelID
  real_tube = FIX(real_tube_number)
  IF (real_tube EQ -8L) THEN BEGIN
    value = 'N/A'
  ENDIF ELSE BEGIN
    row = FIX(row_number)
    value = STRCOMPRESS(LONG(DOUBLE(real_tube) * 128L + $
    DOUBLE(row)),/REMOVE_ALL)
  ENDELSE
  putTextFieldValue, Event, 'pixelid_value', value
  
  ;display counts
  x = Event.X
  y = Event.Y
  error1 = 0
 CATCH, error1
  IF (error1 NE 0) THEN BEGIN
    CATCH,/CANCEL
    value = 'N/A'
  ENDIF ELSE BEGIN
    IF (real_tube eq -8L OR $
      row_number EQ '') THEN BEGIN
      value = 'N/A'
    ENDIF ELSE BEGIN
      x = x
      value = STRCOMPRESS(big_array_rebin[x,y],/REMOVE_ALL)
    ENDELSE
  ENDELSE
  putTextFieldValue, Event, 'counts_value', value

END