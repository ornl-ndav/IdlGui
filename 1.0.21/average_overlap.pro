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

;+
; :Description:
;   This procedures will average the values with the same x value using the
;   following formula
;   value1 : x1, y1, yerror1
;   value2 : x1, y2, yerror2
;   newx = x1 (= x2)
;   newy = [x1/yerror1^2)+(x2/yerror2^2)] / [1/yerror1^2 + 1/yerrror2^2]
;   newyerror = sqrt(1/(1/yerror1^2 + 1/yerror2^2))
;
; :Params:
;    full_flt0_sorted
;    full_ftl1_sorted
;    full_flt2_sorted
;
; :Author: j35
;-
pro average_overlap, full_flt0_sorted, full_flt1_sorted, full_flt2_sorted
  compile_opt idl2
  
  n_row = n_elements(full_flt0_sorted)
  
  new_full_flt0_sorted = fltarr(1)
  new_full_flt1_sorted = fltarr(1)
  new_full_flt2_sorted = fltarr(1)
  
  for i=0L, n_row-2 do begin
  
    value_left = full_flt0_sorted[i]
    value_right = full_flt0_sorted[i+1]
    
    if (value_left ne value_right) then begin ;no need to average
    
      new_xValue = full_flt0_sorted[i]
      new_yValue = full_flt1_sorted[i]
      new_yerrorValue = full_flt2_sorted[i]
      
    endif else begin ;needs to average values
    
      ;new xaxis value
      new_xValue = mean([value_left, value_right])
      
      yL = full_flt1_sorted[i]
      yerrorL = full_flt2_sorted[i]
      yerrorL2 = yerrorL * yerrorL
      yR = full_flt1_sorted[i+1]
      yerrorR = full_flt2_sorted[i+1]
      yerrorR2 = yerrorR * yerrorR
      
      ;new yaxis value
      new_y1 = yL/yerrorL2 + yR/yerrorR2
      new_y2 = 1./yerrorL2 + 1./yerrorR2
      new_yValue = new_y1 / new_y2
      
      ;new yaxis error value
      new_yerrorValue = sqrt(1/new_y2)
      
      i++
    endelse
    
    new_full_flt0_sorted = [new_full_flt0_sorted, new_xValue]
    new_full_flt1_sorted = [new_full_flt1_sorted, new_yValue]
    new_full_flt2_sorted = [new_full_flt2_sorted, new_yerrorValue]
    
  endfor
  
  full_flt0_sorted = new_full_flt0_sorted[1:*]
  full_flt1_sorted = new_full_flt1_sorted[1:*]
  full_flt2_sorted = new_full_flt2_sorted[1:*]
  
end