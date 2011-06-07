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
;    This routine will remove all tha gamme counts from the data array
;
;    Method: Any pixel count will be compare to its neighbor. If 50% of its
;    value is higher than the average value, then its value will be replaced
;    by the average value
;
; :Keywords:
;    event
;    data
;
;
;
; :Author: j35
;-
pro gamma_cleaner, event=event, data=data
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  coeff = (*global).gamma_filtering_coeff
  
  case ((*global).gamma_filtering) of
    0: data = smooth(data, coeff)
    1: data = leefilt(data, coeff)
    else:
  endcase
  
  return
  
;  sz = size(data,/dim)
;  nbr_row = sz[0]
;  nbr_column = sz[1]
;
;  ;work to do
;  ;using where, create huge array that is the average of all the
;  ;neighbors
;  c_i_index = indgen(1,nbr_column-2)
;  c_j_index = indgen(1,nbr_row-2)
;
;  l_i_index = c_i_index - 1
;  r_i_index = c_i_index + 1
;
;  t_j_index = c_j_index + 1
;  b_j_index = c_j_index - 1
;
;  average_data = fltarr(nbr_row, nbr_column)
;
;  average_data[c_i_index,c_j_index] = (data[l_i_index,t_j_index] + $
;  data[l_i_index,c_j_index] + $
;  data[l_i_index,b_j_index] + $
;  data[c_i_index,t_j_index] + $
;  data[c_i_index,b_j_index] + $
;  data[r_i_index,t_j_index] + $
;  data[r_i_index,c_j_index] + $
;  data[r_i_index,b_j_index]) / 8.
;
;  data = average_data
;  return
;
; index = where(data/2. ge average_data)
;;  data[index] = average_data[index]
;
;  index_gammas = array_indices(data, where(data/2. ge average_data))
;  help, index_gammas
;
;return
;
;  nbr_pt = (size(index_gammas,/dim))[1]
;  for i=0,(nbr_pt-1) do begin
;
;    x = index_gammas[0,i]
;    y = index_gammas[1,i]
;    if (x eq 0 or x eq nbr_row-1) then continue
;    if (y eq 0 or y eq nbr_column-1) then continue
;
;    y_tl = data[x-1,y+1]
;    y_t  = data[x,y+1]
;    y_tr = data[x+1,y+1]
;    y_l  = data[x-1,y]
;    y_r  = data[x+1,y]
;    y_bl = data[x-1,y-1]
;    y_b  = data[x,y-1]
;    y_br = data[x+1,y-1]
;
;    mean_y = (y_tl + y_t + y_tr + y_l + y_r + y_bl + y_b + y_br) / 8.
;    data[x,y] = mean_y
;
;  endfor
  
  
end