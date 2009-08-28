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

FUNCTION retrieve_calculation_range, Event

  ON_IOERROR, error
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  data = (*(*global).tt_zoom_data)
  min_tube_plotted  = (*global).min_tube_plotted
  min_pixel_plotted = (*global).min_pixel_plotted
  
  ;calculation range
  tube1  = FIX(getTextFieldValue(Event,'tube1_button_value'))
  tube2  = FIX(getTextFieldValue(Event,'tube2_button_value'))
  pixel1 = FIX(getTextFieldValue(Event,'pixel1_button_value'))
  pixel2 = FIX(getTextFieldValue(Event,'pixel2_button_value'))
  
  tube_min  = MIN([tube1,tube2], MAX=tube_max)
  pixel_min = MIN([pixel1,pixel2], MAX=pixel_max)
  
  tube_min_offset  = tube_min - min_tube_plotted
  tube_max_offset  = tube_max - min_tube_plotted
  pixel_min_offset = pixel_min - min_pixel_plotted
  pixel_max_offset = pixel_max - min_pixel_plotted
  
  array = data[tube_min_offset:tube_max_offset, $
    pixel_min_offset:pixel_max_offset]
    
  RETURN, array
  
  error:
  RETURN, ''
  
END