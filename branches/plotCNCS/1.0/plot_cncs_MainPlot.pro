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

  ;retrieve bank number
  bank_tube   = getBankTube(Event)
  bank_number = bank_tube[0]
  tube_number = bank_tube[1]
  
  ;display bank number in title
  IF ((*global1).real_or_tof EQ 0) THEN BEGIN ;real das view
    text = (*global1).main_plot_real_title
  ENDIF ELSE BEGIN ;tof view
    text = (*global1).main_plot_tof_title
  ENDELSE
  IF (bank_number NE '') THEN BEGIN
    text += ' - bank: ' + bank_number
  ENDIF
  
  ;Show tube angle
  real_tube_number = FIX(tube_number) + (FIX(bank_number)-1) * 8L
  IF (tube_number NE '') THEN BEGIN
    text += ' - Scattering Angle: ' + $
    STRCOMPRESS(TubeAngle[real_tube_number],/REMOVE_ALL) + $
    ' degrees'
  ENDIF
  
  ;change title
  id = WIDGET_INFO(wBase,find_by_uname='main_plot_base')
  WIDGET_CONTROL, id, base_set_title= text
END







