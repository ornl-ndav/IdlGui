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

PRO DGSN_UpdateGUI, tlb, dgsn_cmd

  ; White Beam Norm
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_WHITE_NORM')
  dgsn_cmd->GetProperty, WhiteNorm=myValue
  WIDGET_CONTROL, widget_ID, SET_BUTTON=myValue
  ; Also set the label on the normalisation range
  normLabel = WIDGET_INFO(tlb, FIND_BY_UNAME="DGSN_NORM-INT-RANGE_LABEL")
  IF (myValue) THEN BEGIN
    WIDGET_CONTROL, normLabel, SET_VALUE=" Normalisation Integration Range (A)   "
  ENDIF ELSE BEGIN
    WIDGET_CONTROL, normLabel, SET_VALUE=" Normalisation Integration Range (meV) "
  ENDELSE
  
  ; Low Threshold
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_LO_THRESHOLD')
  dgsn_cmd->GetProperty, Lo_Threshold=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
  
  ; Hi Threshold
  widget_ID = WIDGET_INFO(tlb, FIND_BY_UNAME='DGSN_HI_THRESHOLD')
  dgsn_cmd->GetProperty, Hi_Threshold=myValue
  WIDGET_CONTROL, widget_ID, SET_VALUE=myValue
END