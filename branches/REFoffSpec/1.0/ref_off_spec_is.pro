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

FUNCTION isLogZaxisSelected, Event
id = widget_info(Event.top,find_by_uname='z_axis_linear_log')
widget_control, id, get_value=isLogSelected
return, isLogSelected
END

;------------------------------------------------------------------------------
FUNCTION isLogZaxisShiftingSelected, Event
id = widget_info(Event.top,find_by_uname='z_axis_linear_log_shifting')
widget_control, id, get_value=isLogSelected
return, isLogSelected
END

;------------------------------------------------------------------------------
FUNCTION isThisIndexSelected, Event, index_selected, this_index
bFoundList = WHERE(index_selected EQ this_index,nbr)
IF (nbr GT 0) THEN RETURN, 1
RETURN, 0
END

;------------------------------------------------------------------------------
FUNCTION is_YandX_RefPixelSelected, Event
id = widget_info(Event.top,find_by_uname='reference_pixel_shifting_options')
widget_control, id, get_value=isYandXselected
RETURN, isYandXselected
END
