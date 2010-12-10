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
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='z_axis_linear_log')
WIDGET_CONTROL, id, GET_VALUE=isLogSelected
RETURN, isLogSelected
END

;------------------------------------------------------------------------------
FUNCTION isLogZaxisShiftingSelected, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='z_axis_linear_log_shifting')
WIDGET_CONTROL, id, GET_VALUE=isLogSelected
RETURN, isLogSelected
END

;------------------------------------------------------------------------------
FUNCTION isLogZaxisScalingStep1Selected, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='z_axis_linear_log_scaling_step1')
WIDGET_CONTROL, id, GET_VALUE=isLogSelected
RETURN, isLogSelected
END

;------------------------------------------------------------------------------
FUNCTION isLogZaxisStep5Selected, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='z_axis_linear_log_step5')
WIDGET_CONTROL, id, GET_VALUE=isLogSelected
RETURN, isLogSelected
END
;======================================================================================
; Change code (RC Ward, 13 Aug 2010): check to see if the Max Value splicing alternative is selected
;------------------------------------------------------------------------------
FUNCTION isMaxValueStep5Selected, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='splicing_alternative_step5')
WIDGET_CONTROL, id, GET_VALUE=isMaxValueSelected
RETURN, isMaxValueSelected
END
;======================================================================================
;------------------------------------------------------------------------------
FUNCTION isThisIndexSelected, Event, index_selected, this_index
bFoundList = WHERE(index_selected EQ this_index,nbr)
IF (nbr GT 0) THEN RETURN, 1
RETURN, 0
END

;------------------------------------------------------------------------------
FUNCTION is_YandX_RefPixelSelected, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='reference_pixel_shifting_options')
WIDGET_CONTROL, id, GET_VALUE=isYandXselected
RETURN, isYandXselected
END

;------------------------------------------------------------------------------
FUNCTION isWithAttenuatorCoeff, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME= $
                 'transparency_attenuator_shifting_options')
WIDGET_CONTROL, id, GET_VALUE=index
RETURN, index
END

;------------------------------------------------------------------------------
FUNCTION isPlot2DModeSelected, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='two_d_selection_plot_mode')
value = WIDGET_INFO(id, /BUTTON_SET)
RETURN, value
END

;------------------------------------------------------------------------------
FUNCTION isWithScalingErrorBars, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='plot_error_scaling_options')
WIDGET_CONTROL, id, GET_VALUE=value
IF (value EQ 0) THEN RETURN, 1
RETURN, 0
END

;------------------------------------------------------------------------------
FUNCTION isBaseMapped, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
RETURN, WIDGET_INFO(id,/MAP)
END

;------------------------------------------------------------------------------
FUNCTION isRecapScaleZoomSelected, Event
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='step5_rescale_zoom_button')
return, WIDGET_INFO(id,/BUTTON_SET)
END

;------------------------------------------------------------------------------
FUNCTION isButtonSensitive, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
RETURN, WIDGET_INFO(id,/SENSITIVE)
END

;------------------------------------------------------------------------------
FUNCTION isButtonSelected, Event, uname
id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
RETURN, WIDGET_INFO(id,/BUTTON_SET)
END
















