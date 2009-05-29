;===============================================================================
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
;===============================================================================

;This function converts the TOF to Q 
PRO convert_TOF_to_Q, Event, angleValue
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

flt0       = (*(*global).flt0_xaxis)
flt0_array = size(flt0)
flt0_size  = flt0_array[1]
Q          = fltarr(flt0_size)

;get current angle value (in deg)
angleValue = float(angleValue)
;get current distance MD
dMD = getTextFieldValue(Event,'ModeratorDetectorDistanceTextField')
dMD = float(dMD)

h_over_mn = (*global).h_over_mn

CST = 4*!PI*sin((!PI * angleValue)/180)
FOR i=0,(flt0_size-1) DO BEGIN
    IF (i EQ (flt0_size-1)) THEN BEGIN
        lambda = h_over_mn * (flt0[i])
    ENDIF ELSE BEGIN
        lambda = h_over_mn * ((flt0[i] + flt0[i+1])/2)
    ENDELSE
    lambda /= dMD
    
    Q[i] = CST / lambda
END

(*(*global).flt0_xaxis) = Q

END

;-------------------------------------------------------------------------------
PRO procedure_ref_scale_tof_to_q
END
