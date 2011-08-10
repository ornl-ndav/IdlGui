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

FUNCTION IsXYRowTubePixelidBankInputCorrect, X=X,$
    Y=Y,$
    Row=Row,$
    Tube=Tube,$
    Pixelid=Pixelid,$
    Bank=Bank
    
  IF (n_elements(X) EQ 1) THEN BEGIN
    IF (~(X GE 0 AND X LT 56)) THEN RETURN, 0
  ENDIF
  
  IF (n_elements(Y) EQ 1) THEN BEGIN
    IF (~(Y GE 0 AND Y LT 64)) THEN RETURN, 0
  ENDIF
  
  IF (n_elements(Row) EQ 1) THEN BEGIN
    IF (~(Row GE 0 AND Row LT 128)) THEN RETURN, 0
  ENDIF
  
  IF (n_elements(Tube) EQ 1) THEN BEGIN
    IF (~((Tube GE 0 AND Tube LT 56) OR $
      (Tube GE 64 AND Tube LT 120))) THEN RETURN, 0
  ENDIF
  
  IF (n_elements(PixelID) EQ 1) THEN BEGIN
    IF (~((PixelID GE 0 AND PixelID LT 3584) OR $
      (PixelID GE 4096 AND PixelID LT 7680) or $
      (pixelID ge 2*4096 and pixelID lt 2*4096+3584) or $
      (pixelID ge 3*4096 and pixelID lt 3*4096+3584))) THEN RETURN, 0
  ENDIF
  
  IF (n_elements(Bank) EQ 1) THEN BEGIN
    IF (~(Bank EQ 1 OR Bank EQ 2 OR bank eq 3 or bank eq 4)) THEN RETURN, 0
  ENDIF
  
  RETURN, 1
END




FUNCTION isPixelExcludedSymbolFull, Event
  id = widget_info(Event.top,find_by_uname='excluded_pixel_type')
  widget_control, id, get_value=value
  RETURN, value
END


;if button click or not
FUNCTION isButtonSelected, Event, uname
  id = widget_info(Event.top,find_by_uname=uname)
  widget_control, id, get_value=value
  RETURN, value
END



FUNCTION isButtonUnSelected, Event, uname
  id = widget_info(Event.top,find_by_uname=uname)
  widget_control, id, get_value=value
  IF (value EQ 0) THEN RETURN, 1
  RETURN, 0
END


;if button is activated
FUNCTION isButtonEnabled, Event, uname
  id = widget_info(Event.top,find_by_uname=uname)
  sensitiveStatus = widget_info(id,/sensitive)
  RETURN, sensitiveStatus
END


;if button is click and activated
FUNCTION isButtonSelectedAndEnabled, Event, uname
  IF ((isButtonSelected(event,uname) EQ 1) AND $
    isButtonEnabled(event,uname) EQ 1) THEN BEGIN
    return, 1
  ENDIF ELSE BEGIN
    return, 0
  ENDELSE
END

;if base is map or not
FUNCTION isBaseMapped, Event, uname
  id = widget_info(event.top,find_by_uname=uname)
  status = widget_info(id,/map)
  RETURN, status
END
