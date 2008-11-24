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

;###############################################################################
;*******************************************************************************

;This function converts the input angle into deg
FUNCTION convert_to_deg, f_angle_rad
f_angle_deg_local = (180 * f_angle_rad) / !PI
RETURN, f_angle_deg_local
END

;^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^

;This functions gets the current angle value
;and do the conversion if necessary (in degree)
PRO get_angle_value_and_do_conversion, Event, angleValue

id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE_ref_scale')
widget_control,id,get_uvalue=global

;check status of deg/rad button
AngleUnitsId = widget_info(Event.top,find_by_uname='AngleUnits')
widget_control, AngleUnitsId, get_value=indexSelected

IF (indexSelected NE 1) THEN BEGIN ;rad
    IDLsendToGeek_addLogBookText, Event, '--> Angle Value : ' + $
      STRCOMPRESS(angleValue,/REMOVE_ALL) + ' radians'
    IDLsendToGeek_addLogBookText, Event, '---> Conversion to degrees :'
    f_angle_deg           = convert_to_deg(float(angleValue))
    IDLsendToGeek_addLogBookText, Event, '--> Angle Value : ' + $
      STRCOMPRESS(f_angle_deg,/REMOVE_ALL) + ' degrees'
    (*global).angleValue  = f_angle_deg
;copy new value into text field
    AngleTextFieldId = widget_info(Event.top,find_by_uname='AngleTextField')
    widget_control, AngleTextFieldId, $
      set_value=strcompress(f_angle_deg,/remove_all)
;reverse status of rad/degree button
    widget_control, AngleUnitsId, set_value=1
ENDIF ELSE BEGIN
    IDLsendToGeek_addLogBookText, Event, '--> Angle Value : ' + $
      STRCOMPRESS(angleValue,/REMOVE_ALL) + ' degrees'
ENDELSE
END

;###############################################################################
;*******************************************************************************

PRO ref_scale_math
END

