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

PRO beam_center_calculation, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;retrieve 2d array of data defined by calculation range
  data = retrieve_calculation_range(Event)
  
  ;calculate beam center pixel
  beam_center_pixel_calculation, Event, DATA=data
  
END

;------------------------------------------------------------------------------
;return array without -1 values
FUNCTION cleanup_bc_array, array
  index = WHERE(array NE -1)
  RETURN, array[index]
END

;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;Work on PIXELS
PRO beam_center_pixel_calculation, Event, DATA=data

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;  print, 'offset: ' + string((*global).calculation_range_offset.pixel)
  
  ;calculate beam center pixel starting at the bottom (pixel_min)
  bc_up_pixel = beam_center_pixel_calculation_function(Event, MODE='up', $
    DATA=data)
  ;  print, bc_up_pixel + (*global).calculation_range_offset.pixel
    
  ;  ;calculate beam center pixel starting at the top (pixel_max)
  bc_down_pixel = beam_center_pixel_calculation_function(Event, MODE='down', $
    DATA=data)
  ;  print, bc_down_pixel + (*global).calculation_range_offset.pixel
    
  ;remove -1 value from up and down arrays
  bc_up_pixel_array = cleanup_bc_array(bc_up_pixel)
  bc_down_pixel_array = cleanup_bc_array(bc_down_pixel)
  
  ;calculate average value of both arrays
  big_bc_array = [bc_up_pixel_array,bc_down_pixel_array]
  bc_pixel = MEAN(big_bc_array) + (*global).calculation_range_offset.pixel
  
  ;put value in its box
  putTextFieldValue, Event, 'beam_center_pixel_center_value', $
    STRCOMPRESS(bc_pixel,/REMOVE_ALL)
    
END