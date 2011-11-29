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

pro calculate_mean_transmission, event=event, data=data
  compile_opt idl2
  
  ;collect table of ROIs
  roi_table =  retrieve_list_roi(event=event)
  table_sz = size(roi_table)
  if (table_sz[0] eq 1) then begin
    nbr_rois = 0
  endif else begin
    nbr_rois = table_sz[1]
  endelse
  
  if (nbr_rois gt 0) then begin
  
    _open_beam_mean_of_regions = fltarr(nbr_rois)
    _index_ob_region = 0
    _sum_counts = 0
    _total_nbr_pixels = 0
    while (_index_ob_region lt nbr_rois) do begin
    
      x0 = roi_table[_index_ob_region,0]
      y0 = roi_table[_index_ob_region,1]
      x1 = roi_table[_index_ob_region,2]
      y1 = roi_table[_index_ob_region,3]
      
      xmin = min([x0,x1],max=xmax)
      ymin = min([y0,y1],max=ymax)
      
      _tmp_ob_data_region = data[xmin:xmax,ymin:ymax]
      _sum = total(_tmp_ob_data_region,1)
      _sum_counts += total(_sum,1)
      _total_nbr_pixels += (xmax-xmin+1) * (ymax-ymin+1)
      
      _index_ob_region++
    endwhile
    
    ;calculate mean transmission
    transmission_value = float(_sum_counts) / float(_total_nbr_pixels)
    
  endif else begin
  
    transmission_value = 'N/A'
    
  endelse
  
  putValue, event=event, 'mean_transmission_uname', $
    strcompress(transmission_value,/remove_all)
    
end
