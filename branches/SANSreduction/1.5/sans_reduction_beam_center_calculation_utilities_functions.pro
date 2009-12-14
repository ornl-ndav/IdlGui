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

FUNCTION getLastElementOfIncreasingCounts, data, MODE=mode

  nbr_data_values = N_ELEMENTS(data)
  
  counts_previous = data[0]
  counts = 0
  
  IF (mode EQ 'pixel') THEN BEGIN
    ;big_step = 15
    big_step = 5
  ENDIF ELSE BEGIN
    big_step = 10
  ENDELSE
  small_step = 5
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, -1
  ENDIF
  
  index = 0
  WHILE (index LT nbr_data_values-(big_step+1)) DO BEGIN
    counts = data[index+big_step]
    IF (counts LT counts_previous) THEN BEGIN ;we started to move down
      sub_array = data[index:index+big_step]
      max = MAX(sub_array, max_index)
      RETURN, index + max_index
    ENDIF ELSE BEGIN
      counts_previous = counts
    ENDELSE
    index += small_step
  ENDWHILE
  
  RETURN, -1
END

;------------------------------------------------------------------------------
FUNCTION getLastElementOfDecreasingCounts, data, MODE=mode

  nbr_data_values = N_ELEMENTS(data)
  
  counts_previous = data[nbr_data_values-1]
  counts = 0
  
  IF (mode EQ 'pixel') THEN BEGIN
    big_step = 15
  ENDIF ELSE BEGIN
    big_step = 10
  ENDELSE
  small_step = 5
  
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, -1
  ENDIF
  
  index = nbr_data_values-1
  WHILE (index GT (big_step+1)) DO BEGIN
    counts = data[index-big_step]
    IF (counts LT counts_previous) THEN BEGIN ;we started to move down
      sub_array = data[index-big_step:index]
      max = MAX(sub_array, max_index)
      RETURN, index - big_step + max_index
    ENDIF ELSE BEGIN
      counts_previous = counts
    ENDELSE
    index -= small_step
  ENDWHILE
  RETURN, -1
END

