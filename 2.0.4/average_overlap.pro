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
;    This routines will start the right average procedure
;
; :Params:
;    event
;    full_flt0_sorted
;    full_flt1_sorted
;    full_flt2_sorted
;
; :Keywords:
;    method
;
; :Author: j35
;-
pro run_average_overlap, event, $
    full_flt0_sorted, $
    full_flt1_sorted, $
    full_flt2_sorted, $
    method=method
  compile_opt idl2
  
  case (method) of
    'old': begin
      average_overlap, event, $
        full_flt0_sorted, $
        full_flt1_sorted, $
        full_flt2_sorted
    end
    'new': begin
      global_average_overlap, event, $
        full_flt0_sorted, $
        full_flt1_sorted, $
        full_flt2_sorted
    end
  endcase
  
end

;+
; :Description:
;   This procedures will average two successive values with the same x value,
;   or with x within a given range of relative difference, using the
;   following formula
;   value1 : x1, y1, yerror1
;   value2 : x1, y2, yerror2
;   newx = x1 (= x2)
;   newy = [x1/yerror1^2)+(x2/yerror2^2)] / [1/yerror1^2 + 1/yerrror2^2]
;   newyerror = sqrt(1/(1/yerror1^2 + 1/yerror2^2))
;
;   relative difference is calculated as such:
;       (x1 - x2) / (x1+x2) < 0.1 %
;
; :Params:
;    event
;    full_flt0_sorted
;    full_ftl1_sorted
;    full_flt2_sorted
;
; :Author: j35
;-
pro average_overlap, event, $
    full_flt0_sorted, $
    full_flt1_sorted, $
    full_flt2_sorted
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  n_row = n_elements(full_flt0_sorted)
  
  new_full_flt0_sorted = !null
  new_full_flt1_sorted = !null
  new_full_flt2_sorted = !null
  
  for i=0L, n_row-2 do begin
  
    value_left = full_flt0_sorted[i]
    value_right = full_flt0_sorted[i+1]
    
    bAverage = 0b
    if (value_left eq value_right) then bAverage=1b
    if (bAverage eq 0b) then begin
      abs_value_left = abs(value_left)
      abs_value_right = abs(value_right)
      _relative_diff = $
        (abs_value_left-abs_value_right)/(abs_value_left+abs_value_right)
      if (_relative_diff le (*global).relative_diff) then bAverage=1b
    endif
    
    ;treated as same value on right and left
    if (bAverage) then begin
    
      ;new xaxis value
      new_xValue = mean([value_left, value_right])
      
      yL = full_flt1_sorted[i]
      yerrorL = full_flt2_sorted[i]
      yerrorL2 = yerrorL * yerrorL
      yR = full_flt1_sorted[i+1]
      yerrorR = full_flt2_sorted[i+1]
      yerrorR2 = yerrorR * yerrorR
      
      if (yerrorL2 eq 0 or $
        yerrorR2 eq 0) then begin
        
        new_yValue = 0
        new_yerrorValue = 0
        
      endif else begin
      
        ;new yaxis value
        new_y1 = yL/yerrorL2 + yR/yerrorR2
        new_y2 = 1./yerrorL2 + 1./yerrorR2
        new_yValue = new_y1 / new_y2
        
        ;new yaxis error value
        new_yerrorValue = sqrt(1/new_y2)
        
      endelse
      
      i++
      
    endif else begin
    
      new_xValue = full_flt0_sorted[i]
      new_yValue = full_flt1_sorted[i]
      new_yerrorValue = full_flt2_sorted[i]
      
    endelse
    
    new_full_flt0_sorted = [new_full_flt0_sorted, new_xValue]
    new_full_flt1_sorted = [new_full_flt1_sorted, new_yValue]
    new_full_flt2_sorted = [new_full_flt2_sorted, new_yerrorValue]
    
  endfor
  
  full_flt0_sorted = new_full_flt0_sorted
  full_flt1_sorted = new_full_flt1_sorted
  full_flt2_sorted = new_full_flt2_sorted
  
end


;+
; :Description:
;   This procedures will average the values with the same x value, or
;   with x within a given range of relative difference, using the
;   following formula
;   value1 : x1, y1, yerror1
;   value2 : x1, y2, yerror2
;   newx = x1 (= x2)
;   newy = [x1/yerror1^2)+(x2/yerror2^2)] / [1/yerror1^2 + 1/yerrror2^2]
;   newyerror = sqrt(1/(1/yerror1^2 + 1/yerror2^2))
;
;   relative difference is calculated as such:
;       (x1 - x2) / (x1+x2) < 0.1 %
;
; :Params:
;    event
;    full_flt0_sorted
;    full_ftl1_sorted
;    full_flt2_sorted
;
; :Author: j35
;-
pro global_average_overlap, event, $
    full_flt0_sorted, $
    full_flt1_sorted, $
    full_flt2_sorted
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  n_row = n_elements(full_flt0_sorted)
  
  new_full_flt0_sorted = !null
  new_full_flt1_sorted = !null
  new_full_flt2_sorted = !null
  
  _flt0_left = full_flt0_sorted[0]
  _flt1_left = full_flt1_sorted[0]
  _flt2_left = full_flt2_sorted[0]
  
  _index = 1
  while (_index lt n_row) do begin
  
    _flt0_right = full_flt0_sorted[_index]
    _flt1_right = full_flt1_sorted[_index]
    _flt2_right = full_flt2_sorted[_index]
    
    ;see if the new flt0 value is equal or near the old flt0
    bTreatedAsSameValue = 0b
    
    abs_value_left = abs(_flt0_left)
    abs_value_right = abs(_flt0_right)
    _relative_diff = (abs_value_right - abs_value_left) / $
      (abs_value_left + abs_value_right)
      
    if (_relative_diff le (*global).relative_diff) then bTreatedAsSameValue=1b
    
    if (bTreatedAsSameValue) then begin
    
      new_flt0_value = mean([_flt0_left, _flt0_right])
      
      yL = _flt1_left
      yerrorL = _flt2_left
      yerrorL2 = yerrorL * yerrorL
      yR = _flt1_right
      yerrorR = _flt2_right
      yerrorR2 = yerrorR * yerrorR
      
      case (yerrorL2 + yerrorR2) of
        0: begin
          new_yValue = 0
          new_yerrorValue = 0
        end
        yerrorL2: begin
          new_yValue = yL
          new_yerrorValue = yerrorL
        end
        yerrorR2: begin
          new_yValue = yR
          new_yerrorValue = yerrorR
        end
        else: begin
        
          ;new yaxis value
          new_y1 = yL/yerrorL2 + yR/yerrorR2
          new_y2 = 1./yerrorL2 + 1./yerrorR2
          new_yValue = new_y1 / new_y2
          
          ;new yaxis error value
          new_yerrorValue = sqrt(1/new_y2)
          
        end
      endcase
      
      _flt0_left = new_flt0_value
      _flt1_left = new_yValue
      _flt2_left = new_yerrorValue
      
    endif else begin
    
      new_full_flt0_sorted = [new_full_flt0_sorted, _flt0_left]
      new_full_flt1_sorted = [new_full_flt1_sorted, _flt1_left]
      new_full_flt2_sorted = [new_full_flt2_sorted, _flt2_left]
      
      _flt0_left = _flt0_right
      _flt1_left = _flt1_right
      _flt2_left = _flt2_right
      
    endelse
    
    _index++
    
  endwhile
  
  full_flt0_sorted = new_full_flt0_sorted
  full_flt1_sorted = new_full_flt1_sorted
  full_flt2_sorted = new_full_flt2_sorted
  
end