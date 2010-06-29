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

PRO record_calculation_range_value, Event, MODE=mode

  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  tube = getTextFieldValue(Event,'beam_center_2d_plot_tube')
  pixel = getTextFieldValue(Event,'beam_center_2d_plot_pixel')
  
  CASE (mode) OF
    'click': BEGIN
      putTextFieldValue, Event, $
        'beam_center_calculation_range_tube_left',$
        STRCOMPRESS(tube,/REMOVE_ALL)
      putTextFieldValue, Event, $
        'beam_center_calculation_range_pixel_left', $
        STRCOMPRESS(pixel,/REMOVE_ALL)
      putTextFieldValue, Event, $
        'beam_center_calculation_range_tube_right', 'N/A'
      putTextFieldValue, Event, $
        'beam_center_calculation_range_pixel_right', 'N/A'
    END
    'move': BEGIN
      putTextFieldValue, Event, $
        'beam_center_calculation_range_tube_right',$
        STRCOMPRESS(tube,/REMOVE_ALL)
      putTextFieldValue, Event, $
        'beam_center_calculation_range_pixel_right', $
        STRCOMPRESS(pixel,/REMOVE_ALL)
    END
    ELSE:
  ENDCASE
  
  
END
