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

FUNCTION is_front_back_or_both_plot, Event

  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='show_front_bank_button')
  front_set = WIDGET_INFO(id, /BUTTON_SET)
  IF (front_SET) THEN RETURN, 'front'
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='show_back_bank_button')
  front_set = WIDGET_INFO(id, /BUTTON_SET)
  IF (front_SET) THEN RETURN, 'back'
  
  RETURN, 'both'
  
END

;------------------------------------------------------------------------------
FUNCTION isAutoExcludeDeadTubeSelected, Event
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  IF ((*global).facility EQ 'LENS') THEN RETURN, 0
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='exclude_dead_tube_auto')
  WIDGET_CONTROL, id, GET_VALUE=value
  IF (value EQ 0) THEN RETURN, 1
  RETURN, 0
END

;------------------------------------------------------------------------------
FUNCTION isLinSelected, Event
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='z_axis_scale')
  WIDGET_CONTROL, id, GET_VALUE=value
  IF (value EQ 0) THEN RETURN, 1
  RETURN, 0
END

;------------------------------------------------------------------------------
FUNCTION isLinSelected_uname, Event, uname=uname
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  selected = WIDGET_INFO(id, /BUTTON_SET)
  RETURN, selected
END

;------------------------------------------------------------------------------
FUNCTION isTranManualStep1LinSelected, Event
  RETURN, isLinSelected_uname(Event, uname='transmission_manual_step1_linear')
END

;------------------------------------------------------------------------------
FUNCTION isTranManualStep3LinSelected, Event
  RETURN, isLinSelected_uname(Event, uname='transmission_manual_step3_linear')
END

;------------------------------------------------------------------------------
FUNCTION isOdd, value
  RETURN, value MOD 2
END

;------------------------------------------------------------------------------
FUNCTION isBaseMap, Event, uname
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=uname)
  mapped = WIDGET_INFO(id, /MAP)
  RETURN, mapped
END

;------------------------------------------------------------------------------
FUNCTION isPlotTabZoomSelected, Event
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME='plot_tab_zoom_button')
  selected = WIDGET_INFO(id, /BUTTON_SET)
  RETURN, selected
END

;------------------------------------------------------------------------------
FUNCTION is_eq_and_fit_matched, equation, last_fitting
  IF (equation EQ 'no') THEN RETURN, 0
  xaxis = last_fitting.xaxis_type
  yaxis = last_fitting.yaxis_type
  CASE (equation) OF
    'rg': BEGIN
      IF (xaxis EQ 'Q2' AND yaxis EQ 'log') THEN RETURN, 1
      RETURN, 0
    END
    'rc': BEGIN
      IF (xaxis EQ 'Q2' AND yaxis EQ 'log_Q_IQ') THEN RETURN, 1
      RETURN, 0
    END
    'rt': BEGIN
      IF (xaxis EQ 'Q2' AND yaxis EQ 'log_Q2_IQ') THEN RETURN, 1
      RETURN, 0
    END
    ELSE: RETURN, 0
  ENDCASE
END

;------------------------------------------------------------------------------
FUNCTION getTextFieldValue, Event, uname
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME=uname)
  WIDGET_CONTROL, id, GET_VALUE=value
  RETURN, value[0]
END

FUNCTION is_from_lower_than_to, Event, MODE=mode, TEST=test

  CASE (MODE) OF
    1: mode_base = 'mode1_'
    2: mode_base = 'mode2_'
  ENDCASE
  
  IF (TEST EQ 'bin') THEN BEGIN
    from_uname = mode_base + 'from_tof_bin'
    to_uname   = mode_base + 'to_tof_bin'
  ENDIF ELSE BEGIN
    from_uname = mode_base + 'from_tof_micros'
    to_uname   = mode_base + 'to_tof_micros'
  ENDELSE
  
  from = getTextFieldValue(Event,from_uname)
  to   = getTextFieldValue(Event,to_uname)
  
  IF (from GE to) THEN RETURN, 0b
  
  RETURN, 1b
END

;------------------------------------------------------------------------------
FUNCTION isBothPanelsSelected, Event
  result = is_front_back_or_both_plot(Event)
  IF (result EQ 'both') THEN RETURN, 1
  RETURN, 0
END