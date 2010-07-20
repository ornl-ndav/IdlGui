;+
; :Copyright:
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
; Copyright (c) 2009, Spallation Neutron Source, Oak Ridge National Lab,
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
; :Author: scu (campbellsi@ornl.gov)
;-

PRO dgsnorm_events, event, dgs_cmd
  
  WIDGET_CONTROL, event.id, GET_UVALUE=myUVALUE
  
  ; Check that we actually got something back in the UVALUE
  IF N_ELEMENTS(myUVALUE) EQ 0 THEN myUVALUE="NOTHING"
  
  CASE (myUVALUE) OF
    'DGSN_WHITE_NORM': BEGIN
      dgs_cmd->SetProperty, WhiteNorm=event.SELECT
      normLabel = WIDGET_INFO(event.top,FIND_BY_UNAME="DGSN_NORM-INT-RANGE_LABEL")
      IF (event.SELECT) THEN BEGIN
        WIDGET_CONTROL, normLabel, SET_VALUE=" Normalisation Integration Range (A)   "
      ENDIF ELSE BEGIN
        WIDGET_CONTROL, normLabel, SET_VALUE=" Normalisation Integration Range (meV) "
      ENDELSE
    END
    
    
    'DGSN_LO_THRESHOLD':BEGIN
    WIDGET_CONTROL, event.ID, GET_VALUE=myValue
    dgs_cmd->SetProperty, Lo_Threshold=myValue
  END
  'DGSN_HI_THRESHOLD':BEGIN
  WIDGET_CONTROL, event.ID, GET_VALUE=myValue
  dgs_cmd->SetProperty, Hi_Threshold=myValue
END
'NOTHING': BEGIN
END
ELSE: begin
  ; Do nowt
  print, '*** UVALUE: ' + myUVALUE + ' not handled! ***'
END
ENDCASE

END