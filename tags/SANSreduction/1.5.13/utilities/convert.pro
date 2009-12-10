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

FUNCTION convert_xdata_into_device, Event, imported_data_value
  data_value = imported_data_value
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  ;go 2 by 2 for front and back panels only
  ;start at 1 if back panel
  panel_selected = getPanelSelected(Event)
  CASE (panel_selected) OF
    'front': BEGIN
      data_value -= 1
      device_value = (data_value ) * (*global).congrid_x_coeff
    END
    'back': BEGIN
      data_value -= 2
      device_value = (data_value ) * (*global).congrid_x_coeff
    END
    ELSE: BEGIN
      data_value -= 1
      device_value = data_value * (*global).congrid_x_coeff
    END
  ENDCASE
  
  RETURN, device_value
END

;------------------------------------------------------------------------------
FUNCTION convert_ydata_into_device, Event, data_value
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  device_value = data_value * (*global).congrid_y_coeff
  RETURN, device_value
END

;------------------------------------------------------------------------------
FUNCTION convert_xdevice_into_data, Event, device_value
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  
  IF ((*global).facility EQ 'LENS') THEN BEGIN
    IF ((*global).Xpixel  EQ 80L) THEN BEGIN
      Xcoeff = 8
    ENDIF ELSE BEGIN
      Xcoeff = 2
    ENDELSE
    ScreenX = device_value / Xcoeff
  ENDIF ELSE BEGIN
  
    ;check if both panels are plotted
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='show_both_banks_button')
    value = WIDGET_INFO(id, /BUTTON_SET)
    coeff = 0.5
    IF (value EQ 1) THEN coeff = 1
    ScreenX = FIX(FLOAT(device_value) / (*global).congrid_x_coeff * coeff)
    
    panel_selected = getPanelSelected(Event)
    CASE (panel_selected) OF
      'front': BEGIN
        ScreenX *= 2
      END
      'back': BEGIN
        ScreenX = ScreenX * 2 + 1
      END
      ELSE:
    ENDCASE
    
  ENDELSE
  
  RETURN, screenX
END

;------------------------------------------------------------------------------
FUNCTION convert_ydevice_into_data, Event, device_value
  WIDGET_CONTROL, Event.top, GET_UVALUE=global
  data_value = device_value / (*global).congrid_y_coeff
  RETURN, data_value
END

;------------------------------------------------------------------------------
FUNCTION m_to_angstroms, r
  RETURN, r * 1e10
END

;------------------------------------------------------------------------------
FUNCTION convert_micros_to_bin, Event, micros
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof
  global = (*global_tof).global
  tof_tof = (*(*global).array_of_tof_bins)
  index = WHERE(tof_tof LE microS, count)
  IF (count GT 0) THEN BEGIN
    RETURN, index[count-1]
  ENDIF
  RETURN, -1
END

;------------------------------------------------------------------------------
FUNCTION convert_bin_to_micros, Event, bin
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_tof
  global = (*global_tof).global
  tof_tof = (*(*global).array_of_tof_bins)
  IF (bin GE N_ELEMENTS(tof_tof)) THEN RETURN, -1
  RETURN, tof_tof[bin]
END

